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
    _service.onDevicesUpdated = (names) {
      debugPrint('[ConnectNotifier] onDevicesUpdated: ${names.length} devices found: $names');
      state = state.copyWith(foundDeviceNames: names);
    };
    _service.onScanningChanged = (scanning) {
      debugPrint('[ConnectNotifier] onScanningChanged: isSearching=$scanning');
      state = state.copyWith(isSearching: scanning);
    };
    _service.onConnectionChanged = (isConnected, hasConnectedOnce) {
      debugPrint('[ConnectNotifier] onConnectionChanged: isConnected=$isConnected, hasConnectedOnce=$hasConnectedOnce');
      state = state.copyWith(
        isEquipmentConnected: isConnected,
        hasConnectedOnce: state.hasConnectedOnce || hasConnectedOnce,
      );
      if (isConnected) {
        debugPrint('[ConnectNotifier] === DEVICE CONNECTED ===');
        Fluttertoast.showToast(msg: 'connected');
        // 蓝牙链路建立后,触发 FTMS 服务发现
        _initializeFtmsService();
      } else if (state.hasConnectedOnce) {
        debugPrint('[ConnectNotifier] === DEVICE DISCONNECTED ===');
        Fluttertoast.showToast(msg: 'deviceDisconnected');
      }
    };
  }

  void setDeviceCategory(FtmsDeviceType category) {
    _deviceCategory = category;
    debugPrint('[ConnectNotifier] setDeviceCategory: $category');
  }

  /// 蓝牙连接建立后,初始化 FTMS 服务。
  ///
  /// 通过 ref.read(ftmsServiceProvider(_deviceCategory)) 触发 Provider 重建,
  /// Provider 内部会执行 FtmsServiceFactory.create + connect(device)。
  void _initializeFtmsService() {
    debugPrint('[ConnectNotifier] _initializeFtmsService for $_deviceCategory');
    try {
      final ftmsService = ref.read(ftmsServiceProvider(_deviceCategory));
      if (ftmsService != null) {
        debugPrint('[ConnectNotifier] FTMS service created, isReady=${ftmsService.isReady}');
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

  Future<void> connectSelectedDevice(String deviceName) async {
    debugPrint('[ConnectNotifier] connectSelectedDevice: "$deviceName"');
    await _persistDeviceName(deviceName);
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

  Future<void> haltSport() async {
    await _service.disconnect();
    state = state.copyWith(isEquipmentConnected: false);
  }

  void disconnectIfAny() {
    _service.disconnectIfAny();
  }

  void markConnectedForTest() {
    state = state.copyWith(
      isEquipmentConnected: true,
      hasConnectedOnce: true,
    );
  }
}