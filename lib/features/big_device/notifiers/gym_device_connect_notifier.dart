import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/bluetooth/bluetooth_permission.dart';
import '../../../core/devices/device_whitelist.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/ftms/ftms_service_base.dart';
import '../../../core/ftms/ftms_service_provider.dart';
import '../../../core/services/bluetooth_connection_service.dart';
import '../../../core/services/bluetooth_connection_service_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import 'gym_course_home_notifier.dart';
import '../states/gym_device_connect_state.dart';

part 'gym_device_connect_notifier.g.dart';

@Riverpod(keepAlive: true)
class GymDeviceConnectNotifier extends _$GymDeviceConnectNotifier {
  @override
  GymDeviceConnectState build() {
    final service = ref.watch(bluetoothConnectionServiceProvider);
    _storage = ref.watch(storageServiceProvider);
    _service = service;
    // 🔧 设备类型从单一事实源恢复（gymCourseHomeProvider.selectedDeviceCategory），
    // 不再硬编码回退单车：Notifier 实例重建（依赖变化触发 rebuild）时，
    // 若用户当前选中的是跑步机，旧逻辑会把 _deviceCategory 重置为单车，
    // 导致后续 invalidate(ftmsServiceProvider(indoorBike)) 目标错误，
    // 真正的跑步机 FTMS 实例变成持有失效特征值的孤儿。
    _deviceCategory = ref.read(gymCourseHomeProvider).selectedDeviceCategory;
    _setupServiceCallbacks();
    return const GymDeviceConnectState();
  }

  late BluetoothConnectionService _service;
  late StorageService _storage;
  FtmsDeviceType _deviceCategory = FtmsDeviceType.indoorBike;

  FtmsDeviceType get deviceCategory => _deviceCategory;

  void _setupServiceCallbacks() {
    // 设备发现回调
    _service.onDevicesUpdated = (names) {
      debugPrint('[Notifier] onDevicesUpdated: ${names.length} devices found');
      state = state.copyWith(foundDeviceNames: names);
    };

    // 搜索状态回调
    _service.onScanningChanged = (scanning) {
      debugPrint('[Notifier] onScanningChanged: isSearching=$scanning');
      state = state.copyWith(isSearching: scanning);
    };

    // 双保险判定：连接事件回调
    _service.onConnectionEvent = (event) {
      _handleConnectionEvent(event);
    };
  }

  /// 处理连接事件(双保险判定核心逻辑)。
  ///
  /// Layer 1: 蓝牙链路建立 → 初始化 FTMS 服务,等待数据就绪
  /// Layer 2: 由 FTMS 服务通过 [markEquipmentReady] 报告就绪后才标记设备已连接
  void _handleConnectionEvent(BluetoothConnectionEvent event) {
    switch (event) {
      case BluetoothConnectionEvent.bluetoothConnected:
        // 🔧 重复 connected 事件去重：
        // iOS/Android 蓝牙栈在服务发现期间可能重复发出 connected（未经 disconnected），
        // 若不去重，每次重复事件都会 invalidate + 重建 FtmsService，
        // 正在使用中的实例被销毁（特征值引用失效）→ 页面指令写入失败。
        // 真实「断开→重连」不受影响：disconnected 已先将标志置 false。
        if (state.isBluetoothConnected) {
          debugPrint(
            '[Notifier] ⏭️ duplicate connected event (already connected), skip FTMS re-init',
          );
          return;
        }
        debugPrint('[Notifier] === Layer 1: BLUETOOTH CONNECTED ===');
        state = state.copyWith(isBluetoothConnected: true, isConnecting: false);
        // 记录已连接(用于断连 Toast 防护)
        state = state.copyWith(hasConnectedOnce: true);
        // 触发 FTMS 服务初始化,等待 Layer 2 数据就绪
        _initializeFtmsService();

      case BluetoothConnectionEvent.bluetoothDisconnected:
        debugPrint('[Notifier] === BLUETOOTH DISCONNECTED ===');
        // 重置所有状态
        state = state.copyWith(
          isBluetoothConnected: false,
          isEquipmentConnected: false,
          isConnecting: false,
        );
        // 清理旧 FTMS 服务实例(触发 dispose → disconnect),
        // 避免下次连接复用失效的 _controlCharacteristic 引用
        ref.invalidate(ftmsServiceProvider(_deviceCategory));
        debugPrint('[Notifier] invalidated ftmsServiceProvider on disconnect');
        // 只有曾经连接过才显示断连提示(对应旧 _hasConnected 逻辑)
        if (state.hasConnectedOnce) {
          debugPrint('[Notifier] showing disconnect toast');
          Fluttertoast.showToast(msg: 'deviceDisconnected');
        }
        // 清空设备列表
        state = state.copyWith(foundDeviceNames: []);
    }
  }

  /// Layer 2: FTMS 服务报告数据就绪,标记设备完全可用。
  ///
  /// 对应旧代码中收到第一个 0x2ADA 数据包时的逻辑:
  /// ```dart
  /// void bigDeviceStatus(List<int> status) {
  ///   if (showToastFlag.value) {
  ///     showToastFlag.value = false;
  ///     isDeviceConnect.value = true;  // ← 真正的连接成功判定
  ///     Fluttertoast.showToast(msg: "Connected".tr);
  ///   }
  /// }
  /// ```
  void markEquipmentReady() {
    if (state.isEquipmentConnected) {
      debugPrint('[Notifier] markEquipmentReady: already marked, skip');
      return;
    }
    debugPrint('[Notifier] === Layer 2: EQUIPMENT READY ===');
    state = state.copyWith(isEquipmentConnected: true);
    Fluttertoast.showToast(msg: 'connected');
    debugPrint('[Notifier] ✅ device fully connected & ready');
  }

  void setDeviceCategory(FtmsDeviceType category) {
    _deviceCategory = category;
    debugPrint('[Notifier] setDeviceCategory: $category');
  }

  /// 蓝牙连接建立后,初始化 FTMS 服务。
  ///
  /// 对应旧代码中 `connectSmartBike()` 里的 `bikeBluetoothTools().discoverS(...)` 调用。
  /// FTMS 服务内部会发现特征并开始订阅数据,收到第一个数据包后调用 [markEquipmentReady]。
  ///
  /// **关键修复**：每次蓝牙连接成功时,先 invalidate 旧的 [ftmsServiceProvider] 实例,
  /// 强制销毁旧 FtmsService(触发其 disconnect 清理失效的特征值引用),
  /// 再 read 触发重建,确保新实例基于当前连接重新执行服务发现。
  /// 否则 keepAlive 缓存的旧实例在断开重连后,_controlCharacteristic 引用失效,
  /// 写入时报 `primary service not found '1826'`。
  void _initializeFtmsService() {
    debugPrint('[Notifier] === _initializeFtmsService BEGIN ===');
    debugPrint('[Notifier] deviceCategory=$_deviceCategory');

    try {
      // 强制销毁旧实例(断开重连场景下旧 characteristic 引用已失效)
      ref.invalidate(ftmsServiceProvider(_deviceCategory));
      debugPrint(
        '[Notifier] invalidated old ftmsServiceProvider, rebuilding...',
      );

      final ftmsService = ref.read(ftmsServiceProvider(_deviceCategory));
      if (ftmsService != null) {
        debugPrint(
          '[Notifier] FTMS service created, isReady=${ftmsService.isReady}, hasFirstData=${ftmsService.hasReceivedFirstData}',
        );

        // 设置 Layer 2 就绪回调
        ftmsService.onDataReady = (_) {
          debugPrint('[Notifier] 📡 onDataReady callback triggered');
          markEquipmentReady();
        };

        // 双保险: 如果已经收到首个数据(罕见竞态),直接标记就绪
        if (ftmsService.hasReceivedFirstData) {
          debugPrint(
            '[Notifier] ⚠️ first data already received, marking immediately',
          );
          markEquipmentReady();
        }
      } else {
        debugPrint('[Notifier] ⚠️ FTMS service is null, will retry on rebuild');
      }
    } catch (e) {
      debugPrint('[Notifier] ❌ _initializeFtmsService error: $e');
    }
    debugPrint('[Notifier] === _initializeFtmsService END ===');
  }

  /// 获取当前设备类型的 FTMS 服务实例(供其他 Notifier 调用)。
  FtmsServiceBase? get ftmsService {
    try {
      return ref.read(ftmsServiceProvider(_deviceCategory));
    } catch (e) {
      debugPrint('[Notifier] ftmsService getter error: $e');
      return null;
    }
  }

  /// 启动设备扫描（带权限前置检查 + 蓝牙开关检查）。
  ///
  /// - 首次调用时通过 [context] 请求系统蓝牙权限（iOS弹窗关键入口）
  /// - [context] 为 null 时降级为：仅检查权限是否已授予，不主动弹窗（用于后台/非UI场景）
  /// - 权限被拒或蓝牙未开 → 显示 Toast，return 不继续扫描
  Future<void> startDeviceScan([BuildContext? context]) async {
    final whitelist = DeviceWhitelist.forType(_deviceCategory);
    debugPrint(
      '🔐 [BTPerm] startDeviceScan called, type=$_deviceCategory, whitelist=$whitelist',
    );

    // 防重复：已搜索中直接 return
    if (state.isSearching) {
      debugPrint('🔐 [BTPerm] already searching, skip');
      return;
    }

    // === 1. 权限检查 + 主动请求（有 context 才请求） ===
    bool permissionOk;
    if (context != null && context.mounted) {
      permissionOk = await BluetoothPermission.ensureInformedAndRequest(
        context,
      );
      debugPrint('🔐 [BTPerm] ensureInformedAndRequest result = $permissionOk');
    } else {
      permissionOk = await BluetoothPermission.isGranted();
      debugPrint('🔐 [BTPerm] no context, fallback isGranted = $permissionOk');
    }

    if (!permissionOk) {
      // 权限未授予 → 取提示文案 Toast 提示
      final deniedMsg = await BluetoothPermission.checkPermissions();
      debugPrint(
        '🔐 [BTPerm] permission denied, deniedMsg=${deniedMsg?.substring(0, deniedMsg.length > 60 ? 60 : deniedMsg.length)}...',
      );
      if (deniedMsg != null) {
        Fluttertoast.showToast(msg: deniedMsg);
      }
      return;
    }
    debugPrint('🔐 [BTPerm] permission check passed');

    // === 2. 蓝牙适配器开关检查 ===
    final adapterOn = await BluetoothPermission.isAdapterOn();
    debugPrint('🔐 [BTPerm] adapter is ON = $adapterOn');
    if (!adapterOn) {
      debugPrint('🔐 [BTPerm] adapter is OFF, show toast');
      Fluttertoast.showToast(msg: 'pleaseOpenBluetooth');
      return;
    }

    // === 3. 开始扫描 ===
    debugPrint('🔐 [BTPerm] all checks passed, start scan');
    try {
      await _service.startScan(whitelist);
    } on BluetoothNotEnabledException {
      debugPrint('🔐 [BTPerm] startDeviceScan: BluetoothNotEnabledException');
      Fluttertoast.showToast(msg: 'pleaseOpenBluetooth');
    }
  }

  Future<void> stopScan() async {
    debugPrint('[Notifier] stopScan');
    await _service.stopScan();
    state = state.copyWith(isSearching: false);
  }

  /// 连接选中的设备。
  ///
  /// 对应旧代码中点击设备列表项的逻辑:
  /// ```dart
  /// onTap: () {
  ///   writeBigDeviceLocal(showDeviceName[index].advName);
  ///   connectFlag.value = 0;
  ///   device = showDeviceName[index];
  ///   connectDevice();  // 开始连接
  ///   Get.back();
  /// }
  /// ```
  Future<void> connectSelectedDevice(String deviceName) async {
    debugPrint('[Notifier] === connectSelectedDevice BEGIN ===');
    debugPrint('[Notifier] deviceName="$deviceName"');
    // 标记连接中状态
    state = state.copyWith(isConnecting: true);
    // 持久化设备名
    await _persistDeviceName(deviceName);
    // 执行连接(Layer 1)
    await _service.connect(deviceName);
    debugPrint('[Notifier] === connectSelectedDevice END ===');
  }

  Future<void> _persistDeviceName(String name) async {
    switch (_deviceCategory) {
      case FtmsDeviceType.indoorBike:
        await _storage.setBikeMachineName(name);
        break;
      case FtmsDeviceType.treadmill:
        await _storage.setTreadmillName(name);
        break;
      case FtmsDeviceType.crossTrainer:
        await _storage.setEllipticalMachineName(name);
        break;
      case FtmsDeviceType.rower:
        await _storage.setRowerMachineName(name);
        break;
      case FtmsDeviceType.strengthStation:
        await _storage.setStrengthStationName(name);
        break;
    }
  }

  String? validateReadyForEntry() {
    if (!state.isEquipmentConnected) {
      return 'pleaseConnectDevice';
    }
    return null;
  }

  /// 停止运动并断开设备。
  Future<void> haltSport() async {
    debugPrint('[Notifier] === haltSport BEGIN ===');
    await _service.disconnect();
    state = state.copyWith(
      isBluetoothConnected: false,
      isEquipmentConnected: false,
      isConnecting: false,
    );
    debugPrint('[Notifier] === haltSport END ===');
  }

  /// 断开已有连接(用于切换设备时调用)。
  ///
  /// 对应旧代码中入口页点击时的逻辑:
  /// ```dart
  /// if (bsc.device != null) {
  ///   bsc.device!.disconnect();  // 立即断开
  /// }
  /// ```
  void disconnectIfAny() {
    debugPrint('[Notifier] disconnectIfAny');
    _service.disconnectIfAny();
    // 立即重置状态(不等回调)
    state = state.copyWith(
      isBluetoothConnected: false,
      isEquipmentConnected: false,
      isConnecting: false,
    );
    debugPrint('[Notifier] ✅ state reset after disconnectIfAny');
  }

  /// 测试用: 直接标记设备已就绪(跳过双保险判定)。
  void markConnectedForTest() {
    state = state.copyWith(
      isBluetoothConnected: true,
      isEquipmentConnected: true,
      hasConnectedOnce: true,
    );
  }
}
