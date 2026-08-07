import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// 蓝牙连接事件类型(供 Notifier 区分 Layer 1/Layer 2)。
enum BluetoothConnectionEvent {
  /// Layer 1: 蓝牙链路已建立(BluetoothConnectionState.connected)。
  bluetoothConnected,

  /// 蓝牙链路已断开(BluetoothConnectionState.disconnected)。
  bluetoothDisconnected,
}

/// 共享蓝牙连接服务。
///
/// 封装 `FlutterBluePlus` 的扫描、连接、断开、状态订阅,
/// 持有 `BluetoothDevice` 实例和 `StreamSubscription` 生命周期。
/// **所有模块(course/connect/big_device)共享此 Service**,避免各自直接依赖 `flutter_blue_plus`。
///
/// 通过 callback 向调用方(Notifier)报告事件,调用方负责将事件转换为 Riverpod state。
/// 采用双保险判定机制:
/// - Layer 1: bluetoothConnected → 仅表示蓝牙链路建立,不代表设备就绪
/// - Layer 2: 由 FTMS 服务报告数据就绪后才设置 isEquipmentConnected=true
class BluetoothConnectionService {
  BluetoothConnectionService();

  /// 当前目标设备(对应旧 `device`)。Service 层持有,不进 freezed state。
  BluetoothDevice? _targetDevice;
  BluetoothDevice? get targetDevice => _targetDevice;

  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<bool>? _isScanningSub;
  StreamSubscription<BluetoothConnectionState>? _connStateSub;

  final Map<String, BluetoothDevice> _discoveredDevices = {};

  /// 发现设备列表更新回调 → Notifier 中更新 `foundDeviceNames`。
  void Function(List<String> deviceNames)? onDevicesUpdated;

  /// 搜索状态变更回调 → Notifier 中更新 `isSearching`。
  void Function(bool isScanning)? onScanningChanged;

  /// 连接事件回调(替代旧 `onConnectionChanged`)。
  /// Notifier 根据 event 类型分别处理 Layer 1/Layer 2 状态。
  void Function(BluetoothConnectionEvent event)? onConnectionEvent;

  /// 启动蓝牙扫描(带白名单过滤)。
  Future<void> startScan(List<String> whitelist) async {
    debugPrint('[Bluetooth] startScan begin, whitelist=$whitelist');
    _discoveredDevices.clear();
    onDevicesUpdated?.call([]);
    onScanningChanged?.call(true);

    // 6 秒兜底结束搜索(对应旧 6.delay)。
    Future.delayed(const Duration(seconds: 6), () {
      if (_isScanningSub != null) {
        debugPrint('[Bluetooth] startScan 6s timeout, forcing stop');
        onScanningChanged?.call(false);
      }
    });

    _scanSub = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        for (final r in results) {
          final name = r.device.advName;
          if (name.isEmpty) continue;
          if (!_discoveredDevices.containsKey(name)) {
            _discoveredDevices[name] = r.device;
            debugPrint('[Bluetooth] discovered device: "$name" (total: ${_discoveredDevices.length})');
            onDevicesUpdated?.call(List<String>.from(_discoveredDevices.keys));
          }
        }
      }
    }, onError: (e) => debugPrint('[Bluetooth] scan error: $e'));

    FlutterBluePlus.cancelWhenScanComplete(_scanSub!);

    final adapterState = await FlutterBluePlus.adapterState.first;
    debugPrint('[Bluetooth] adapterState=$adapterState');
    if (adapterState != BluetoothAdapterState.on) {
      onScanningChanged?.call(false);
      debugPrint('[Bluetooth] adapter OFF, throwing BluetoothNotEnabledException');
      throw BluetoothNotEnabledException();
    }

    await FlutterBluePlus.startScan(
      withKeywords: whitelist,
      timeout: const Duration(seconds: 5),
    );
    debugPrint('[Bluetooth] startScan started, 5s timeout');

    _isScanningSub = FlutterBluePlus.isScanning.listen((scanning) {
      debugPrint('[Bluetooth] isScanning=$scanning');
      if (!scanning) {
        onScanningChanged?.call(false);
        _isScanningSub?.cancel();
        _isScanningSub = null;
      }
    });
  }

  /// 停止扫描并清理订阅。
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();
    _scanSub = null;
  }

  /// 连接指定广播名的设备。
  Future<void> connect(String deviceName) async {
    debugPrint('[Bluetooth] connect begin, deviceName="$deviceName"');
    final device = _discoveredDevices[deviceName];
    if (device == null) {
      debugPrint('[Bluetooth] connect: device not found in discovered list');
      return;
    }
    _targetDevice = device;
    await stopScan();
    debugPrint('[Bluetooth] connecting to device "${deviceName}" (id=${device.remoteId}), 35s timeout');

    try {
      await device.connect(
        license: License.free,
        timeout: const Duration(seconds: 35),
        autoConnect: false,
      );
      debugPrint('[Bluetooth] connect SUCCESS: "$deviceName"');
    } catch (e) {
      debugPrint('[Bluetooth] connect FAILED: "$deviceName", error=$e');
    }

    _connStateSub = device.connectionState.listen((event) {
      debugPrint('[Bluetooth] connectionState event: ${event.name}');
      if (event == BluetoothConnectionState.connected) {
        debugPrint('[Bluetooth] Layer 1: bluetoothConnected');
        onConnectionEvent?.call(BluetoothConnectionEvent.bluetoothConnected);
      } else if (event == BluetoothConnectionState.disconnected) {
        debugPrint('[Bluetooth] bluetoothDisconnected');
        onConnectionEvent?.call(BluetoothConnectionEvent.bluetoothDisconnected);
      }
    });
    device.cancelWhenDisconnected(_connStateSub!, delayed: true, next: true);
  }

  /// 断开当前设备并清理订阅。
  Future<void> disconnect() async {
    debugPrint('[Bluetooth] disconnect begin');
    await _connStateSub?.cancel();
    _connStateSub = null;
    if (_targetDevice != null) {
      try {
        await _targetDevice!.disconnect();
        debugPrint('[Bluetooth] disconnect SUCCESS');
      } catch (e) {
        debugPrint('[Bluetooth] disconnect error: $e');
      }
      _targetDevice = null;
    }
  }

  /// 若当前有连接中的设备,直接断开(对应旧 dialog 关闭按钮逻辑)。
  void disconnectIfAny() {
    if (_targetDevice != null) {
      _targetDevice!.disconnect();
    }
  }

  /// 释放所有订阅(Notifier dispose 时调用)。
  void dispose() {
    _scanSub?.cancel();
    _isScanningSub?.cancel();
    _connStateSub?.cancel();
  }
}

/// 蓝牙未开启异常。
class BluetoothNotEnabledException implements Exception {
  @override
  String toString() => 'BluetoothNotEnabledException';
}
