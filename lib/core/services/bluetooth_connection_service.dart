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
    debugPrint('[BLE] === startScan BEGIN ===');
    debugPrint('[BLE] whitelist=$whitelist');
    _discoveredDevices.clear();
    onDevicesUpdated?.call([]);
    onScanningChanged?.call(true);
    debugPrint('[BLE] scanning started, notifier notified');

    // 6 秒兜底结束搜索(对应旧 6.delay)。
    Future.delayed(const Duration(seconds: 6), () {
      if (_isScanningSub != null) {
        debugPrint('[BLE] 6s timeout, forcing stop scan');
        onScanningChanged?.call(false);
      }
    });

    _scanSub = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        for (final r in results) {
          final name = r.device.advName;
          if (name.isEmpty) {
            debugPrint('[BLE] skip empty-name device (id=${r.device.remoteId})');
            continue;
          }
          if (!_discoveredDevices.containsKey(name)) {
            _discoveredDevices[name] = r.device;
            debugPrint('[BLE] ✅ discovered: "$name" (total: ${_discoveredDevices.length})');
            onDevicesUpdated?.call(List<String>.from(_discoveredDevices.keys));
          }
        }
      }
    }, onError: (e) {
      debugPrint('[BLE] ❌ scan error: $e');
      onScanningChanged?.call(false);
    });

    FlutterBluePlus.cancelWhenScanComplete(_scanSub!);

    final adapterState = await FlutterBluePlus.adapterState.first;
    debugPrint('[BLE] adapterState=$adapterState');
    if (adapterState != BluetoothAdapterState.on) {
      onScanningChanged?.call(false);
      debugPrint('[BLE] ❌ adapter OFF, throwing BluetoothNotEnabledException');
      throw BluetoothNotEnabledException();
    }

    debugPrint('[BLE] starting FlutterBluePlus.startScan...');
    await FlutterBluePlus.startScan(
      withKeywords: whitelist,
      timeout: const Duration(seconds: 5),
    );
    debugPrint('[BLE] ✅ startScan started, 5s timeout');

    _isScanningSub = FlutterBluePlus.isScanning.listen((scanning) {
      debugPrint('[BLE] isScanning=$scanning');
      if (!scanning) {
        debugPrint('[BLE] ✅ scan completed');
        onScanningChanged?.call(false);
        _isScanningSub?.cancel();
        _isScanningSub = null;
      }
    });
  }

  /// 停止扫描并清理订阅。
  Future<void> stopScan() async {
    debugPrint('[BLE] === stopScan BEGIN ===');
    try {
      await FlutterBluePlus.stopScan();
      debugPrint('[BLE] ✅ FlutterBluePlus.stopScan done');
    } catch (e) {
      debugPrint('[BLE] ⚠️ stopScan warning: $e');
    }
    await _scanSub?.cancel();
    _scanSub = null;
    debugPrint('[BLE] ✅ scan subscription cancelled');
  }

  /// 连接指定广播名的设备。
  Future<void> connect(String deviceName) async {
    debugPrint('[BLE] === connect BEGIN ===');
    debugPrint('[BLE] target deviceName="$deviceName"');
    
    final device = _discoveredDevices[deviceName];
    if (device == null) {
      debugPrint('[BLE] ❌ connect FAILED: device not found in discovered list');
      debugPrint('[BLE] discovered list has ${_discoveredDevices.length} devices: ${_discoveredDevices.keys}');
      return;
    }
    
    _targetDevice = device;
    debugPrint('[BLE] target device set: id=${device.remoteId}');
    
    await stopScan();
    
    debugPrint('[BLE] connecting to "${deviceName}" (id=${device.remoteId}), 35s timeout...');
    try {
      await device.connect(
        license: License.free,
        timeout: const Duration(seconds: 35),
        autoConnect: false,
      );
      debugPrint('[BLE] ✅ connect SUCCESS: "$deviceName"');
    } catch (e) {
      debugPrint('[BLE] ❌ connect FAILED: "$deviceName", error=$e');
      rethrow;
    }

    _connStateSub = device.connectionState.listen((event) {
      debugPrint('[BLE] connectionState=${event.name}');
      if (event == BluetoothConnectionState.connected) {
        debugPrint('[BLE] === Layer 1: bluetoothConnected ===');
        onConnectionEvent?.call(BluetoothConnectionEvent.bluetoothConnected);
      } else if (event == BluetoothConnectionState.disconnected) {
        debugPrint('[BLE] === bluetoothDisconnected ===');
        onConnectionEvent?.call(BluetoothConnectionEvent.bluetoothDisconnected);
      }
    });
    device.cancelWhenDisconnected(_connStateSub!, delayed: true, next: true);
    debugPrint('[BLE] ✅ connectionState listener set up');
  }

  /// 断开当前设备并清理订阅。
  Future<void> disconnect() async {
    debugPrint('[BLE] === disconnect BEGIN ===');
    await _connStateSub?.cancel();
    _connStateSub = null;
    debugPrint('[BLE] ✅ connectionState subscription cancelled');
    
    if (_targetDevice != null) {
      debugPrint('[BLE] disconnecting device id=${_targetDevice!.remoteId}...');
      try {
        await _targetDevice!.disconnect();
        debugPrint('[BLE] ✅ disconnect SUCCESS');
      } catch (e) {
        debugPrint('[BLE] ❌ disconnect error: $e');
      }
      _targetDevice = null;
    } else {
      debugPrint('[BLE] no device to disconnect');
    }
    debugPrint('[BLE] === disconnect END ===');
  }

  /// 若当前有连接中的设备,直接断开(对应旧 dialog 关闭按钮逻辑)。
  void disconnectIfAny() {
    debugPrint('[BLE] disconnectIfAny called, hasDevice=${_targetDevice != null}');
    if (_targetDevice != null) {
      _targetDevice!.disconnect();
      debugPrint('[BLE] ✅ disconnectIfAny triggered');
    }
  }

  /// 释放所有订阅(Notifier dispose 时调用)。
  void dispose() {
    debugPrint('[BLE] === service dispose BEGIN ===');
    _scanSub?.cancel();
    _isScanningSub?.cancel();
    _connStateSub?.cancel();
    debugPrint('[BLE] ✅ all subscriptions cancelled');
    debugPrint('[BLE] === service dispose END ===');
  }
}

/// 蓝牙未开启异常。
class BluetoothNotEnabledException implements Exception {
  @override
  String toString() => 'BluetoothNotEnabledException';
}
