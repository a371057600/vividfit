import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vividfit_v2/core/services/bluetooth_connection_service.dart';
import 'package:vividfit_v2/core/services/bluetooth_connection_service_provider.dart';
import 'package:vividfit_v2/core/services/storage_service.dart';
import 'package:vividfit_v2/core/services/storage_service_provider.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_device_connect_notifier.dart';

GymDeviceConnectNotifier _createNotifier(BluetoothConnectionService service, StorageService storage) {
  final container = ProviderContainer(
    overrides: [
      bluetoothConnectionServiceProvider.overrideWithValue(service),
      storageServiceProvider.overrideWithValue(storage),
    ],
  );
  addTearDown(container.dispose);
  return container.read(gymDeviceConnectNotifierProvider.notifier);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BluetoothConnectionService service;
  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.create();
    service = BluetoothConnectionService();
  });

  group('GymDeviceConnectNotifier', () {
    test('初始状态:未搜索/未连接/设备列表空', () {
      final notifier = _createNotifier(service, storage);
      expect(notifier.state.isSearching, false);
      expect(notifier.state.isEquipmentConnected, false);
      expect(notifier.state.foundDeviceNames, isEmpty);
      expect(notifier.state.hasConnectedOnce, false);
    });

    test('setDeviceCategory 后 validateReadyForEntry 未连接返回提示', () {
      final notifier = _createNotifier(service, storage);
      notifier.setDeviceCategory(DeviceCategory.bike);
      final result = notifier.validateReadyForEntry();
      expect(result, isNotNull);
      expect(result, 'pleaseConnectDevice');
    });

    test('markConnected 后 validateReadyForEntry 返回 null(可进入)', () {
      final notifier = _createNotifier(service, storage);
      notifier.setDeviceCategory(DeviceCategory.treadmill);
      notifier.markConnectedForTest();
      expect(notifier.validateReadyForEntry(), isNull);
    });

    test('setDeviceCategory 默认 bike', () {
      final notifier = _createNotifier(service, storage);
      expect(notifier.deviceCategory, DeviceCategory.bike);
      notifier.setDeviceCategory(DeviceCategory.rower);
      expect(notifier.deviceCategory, DeviceCategory.rower);
    });
  });
}
