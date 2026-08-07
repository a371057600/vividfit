import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/devices/device_whitelist.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/ftms/ftms_service_base.dart';
import '../../../core/ftms/ftms_service_provider.dart';
import '../../../core/services/bluetooth_connection_service.dart';
import '../../../core/services/bluetooth_connection_service_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/gym_device_connect_state.dart';

part 'gym_device_connect_notifier.g.dart';

@Riverpod(keepAlive: true)
class GymDeviceConnectNotifier extends _$GymDeviceConnectNotifier {
  @override
  GymDeviceConnectState build() {
    final service = ref.watch(bluetoothConnectionServiceProvider);
    _storage = ref.watch(storageServiceProvider);
    _service = service;
    _deviceCategory = FtmsDeviceType.indoorBike;
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
      debugPrint('[ConnectNotifier] onDevicesUpdated: ${names.length} devices found: $names');
      state = state.copyWith(foundDeviceNames: names);
    };

    // 搜索状态回调
    _service.onScanningChanged = (scanning) {
      debugPrint('[ConnectNotifier] onScanningChanged: isSearching=$scanning');
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
        debugPrint('[ConnectNotifier] === Layer 1: BLUETOOTH CONNECTED ===');
        state = state.copyWith(
          isBluetoothConnected: true,
          isConnecting: false,
        );
        // 记录已连接(用于断连 Toast 防护)
        state = state.copyWith(hasConnectedOnce: true);
        // 触发 FTMS 服务初始化,等待 Layer 2 数据就绪
        _initializeFtmsService();

      case BluetoothConnectionEvent.bluetoothDisconnected:
        debugPrint('[ConnectNotifier] === BLUETOOTH DISCONNECTED ===');
        // 重置所有状态
        state = state.copyWith(
          isBluetoothConnected: false,
          isEquipmentConnected: false,
          isConnecting: false,
        );
        // 只有曾经连接过才显示断连提示(对应旧 _hasConnected 逻辑)
        if (state.hasConnectedOnce) {
          debugPrint('[ConnectNotifier] Showing disconnect toast');
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
    if (state.isEquipmentConnected) return;
    debugPrint('[ConnectNotifier] === Layer 2: EQUIPMENT READY ===');
    state = state.copyWith(isEquipmentConnected: true);
    Fluttertoast.showToast(msg: 'connected');
  }

  void setDeviceCategory(FtmsDeviceType category) {
    _deviceCategory = category;
    debugPrint('[ConnectNotifier] setDeviceCategory: $category');
  }

  /// 蓝牙连接建立后,初始化 FTMS 服务。
  ///
  /// 对应旧代码中 `connectSmartBike()` 里的 `bikeBluetoothTools().discoverS(...)` 调用。
  /// FTMS 服务内部会发现特征并开始订阅数据,收到第一个数据包后调用 [markEquipmentReady]。
  void _initializeFtmsService() {
    debugPrint('[ConnectNotifier] _initializeFtmsService for $_deviceCategory');
    try {
      final ftmsService = ref.read(ftmsServiceProvider(_deviceCategory));
      if (ftmsService != null) {
        debugPrint('[ConnectNotifier] FTMS service created, isReady=${ftmsService.isReady}');
        // 如果 FTMS 服务已经就绪(罕见情况),直接标记
        if (ftmsService.isReady) {
          markEquipmentReady();
        }
      } else {
        debugPrint('[ConnectNotifier] FTMS service is null (device not ready yet)');
      }
    } catch (e) {
      debugPrint('[ConnectNotifier] _initializeFtmsService error: $e');
    }
  }

  /// 获取当前设备类型的 FTMS 服务实例(供其他 Notifier 调用)。
  FtmsServiceBase? get ftmsService {
    try {
      return ref.read(ftmsServiceProvider(_deviceCategory));
    } catch (e) {
      debugPrint('[ConnectNotifier] ftmsService getter error: $e');
      return null;
    }
  }

  Future<void> startDeviceScan() async {
    final whitelist = DeviceWhitelist.forType(_deviceCategory);
    debugPrint('[ConnectNotifier] startDeviceScan, type=$_deviceCategory, whitelist=$whitelist');
    try {
      await _service.startScan(whitelist);
    } on BluetoothNotEnabledException {
      debugPrint('[ConnectNotifier] startDeviceScan: BluetoothNotEnabledException');
      Fluttertoast.showToast(msg: 'pleaseOpenBluetooth');
    }
  }

  Future<void> stopScan() async {
    debugPrint('[ConnectNotifier] stopScan');
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
    debugPrint('[ConnectNotifier] connectSelectedDevice: "$deviceName"');
    // 标记连接中状态
    state = state.copyWith(isConnecting: true);
    // 持久化设备名
    await _persistDeviceName(deviceName);
    // 执行连接(Layer 1)
    await _service.connect(deviceName);
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
    debugPrint('[ConnectNotifier] haltSport');
    await _service.disconnect();
    state = state.copyWith(
      isBluetoothConnected: false,
      isEquipmentConnected: false,
      isConnecting: false,
    );
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
    debugPrint('[ConnectNotifier] disconnectIfAny');
    _service.disconnectIfAny();
    // 立即重置状态(不等回调)
    state = state.copyWith(
      isBluetoothConnected: false,
      isEquipmentConnected: false,
      isConnecting: false,
    );
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
