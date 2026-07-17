import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/bluetooth_connection_service.dart';
import '../../../core/services/bluetooth_connection_service_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../data/device_category.dart';
import '../data/device_scan_constants.dart';
import '../states/gym_device_connect_state.dart';

part 'gym_device_connect_notifier.g.dart';

@riverpod
class GymDeviceConnectNotifier extends _$GymDeviceConnectNotifier {
  @override
  GymDeviceConnectState build() {
    final service = ref.watch(bluetoothConnectionServiceProvider);
    _storage = ref.watch(storageServiceProvider);
    _service = service;
    _deviceCategory = DeviceCategory.bike;
    _setupServiceCallbacks();
    return const GymDeviceConnectState();
  }

  late BluetoothConnectionService _service;
  late StorageService _storage;
  DeviceCategory _deviceCategory = DeviceCategory.bike;

  DeviceCategory get deviceCategory => _deviceCategory;

  void _setupServiceCallbacks() {
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
    switch (_deviceCategory) {
      case DeviceCategory.bike:
        await _storage.setBikeMachineName(name);
        break;
      case DeviceCategory.treadmill:
        await _storage.setTreadmillName(name);
        break;
      case DeviceCategory.elliptical:
        await _storage.setEllipticalMachineName(name);
        break;
      case DeviceCategory.rower:
        await _storage.setRowerMachineName(name);
        break;
      case DeviceCategory.strengthStation:
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
