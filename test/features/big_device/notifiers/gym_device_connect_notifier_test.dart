import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/services/bluetooth_connection_service.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_device_connect_notifier.dart';

void main() {
  group('GymDeviceConnectNotifier', () {
    test('初始状态:未搜索/未连接/设备列表空', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      expect(notifier.state.isSearching, false);
      expect(notifier.state.isEquipmentConnected, false);
      expect(notifier.state.foundDeviceNames, isEmpty);
      expect(notifier.state.hasConnectedOnce, false);
    });

    test('setDeviceCategory 后 validateReadyForEntry 未连接返回提示', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      notifier.setDeviceCategory(DeviceCategory.bike);
      final result = notifier.validateReadyForEntry();
      expect(result, isNotNull);
      expect(result, 'pleaseConnectDevice');
    });

    test('markConnected 后 validateReadyForEntry 返回 null(可进入)', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      notifier.setDeviceCategory(DeviceCategory.treadmill);
      notifier.markConnectedForTest();
      expect(notifier.validateReadyForEntry(), isNull);
    });

    test('setDeviceCategory 默认 bike', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      expect(notifier.deviceCategory, DeviceCategory.bike);
      notifier.setDeviceCategory(DeviceCategory.rower);
      expect(notifier.deviceCategory, DeviceCategory.rower);
    });
  });
}
