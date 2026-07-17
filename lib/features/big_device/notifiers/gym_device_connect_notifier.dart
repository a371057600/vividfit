import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/services/bluetooth_connection_service.dart';
import '../../../core/services/storage_service.dart';
import '../data/device_category.dart';
import '../data/device_scan_constants.dart';
import '../states/gym_device_connect_state.dart';

class GymDeviceConnectNotifier extends StateNotifier<GymDeviceConnectState> {
  GymDeviceConnectNotifier(this._service)
      : super(const GymDeviceConnectState()) {
    _service.onDevicesUpdated = (names) {
      state = state.copyWith(foundDeviceNames: names);
    };
    _service.onScanningChanged = (scanning) {
      state = state.copyWith(isSearching: scanning);
    };
    _service.onConnectionChanged = (isConnected, hasConnectedOnce) {
      state = state.copyWith(
        isEquipmentConnected: isConnected,
        hasConnectedOnce: state.hasConnectedOnce || hasConnectedOnce,
      );
      if (isConnected) {
        Fluttertoast.showToast(msg: 'connected');
      } else if (state.hasConnectedOnce) {
        Fluttertoast.showToast(msg: 'deviceDisconnected');
      }
    };
  }

  final BluetoothConnectionService _service;
  StorageService? _storage;

  DeviceCategory _deviceCategory = DeviceCategory.bike;
  DeviceCategory get deviceCategory => _deviceCategory;

  void setStorage(StorageService storage) => _storage = storage;

  void setDeviceCategory(DeviceCategory category) {
    _deviceCategory = category;
  }

  Future<void> startDeviceScan() async {
    final whitelist = DeviceScanConstants.whitelistFor(_deviceCategory);
    try {
      await _service.startScan(whitelist);
    } on BluetoothNotEnabledException {
      Fluttertoast.showToast(msg: 'pleaseOpenBluetooth');
    }
  }

  Future<void> connectSelectedDevice(String deviceName) async {
    await _persistDeviceName(deviceName);
    await _service.connect(deviceName);
  }

  Future<void> _persistDeviceName(String name) async {
    final s = _storage;
    if (s == null) return;
    switch (_deviceCategory) {
      case DeviceCategory.bike:
        await s.setBikeMachineName(name);
        break;
      case DeviceCategory.treadmill:
        await s.setTreadmillName(name);
        break;
      case DeviceCategory.elliptical:
        await s.setEllipticalMachineName(name);
        break;
      case DeviceCategory.rower:
        await s.setRowerMachineName(name);
        break;
      case DeviceCategory.strengthStation:
        await s.setStrengthStationName(name);
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

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
