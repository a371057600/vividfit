import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/data/device_scan_constants.dart';

void main() {
  group('DeviceScanConstants', () {
    test('bike 白名单非空', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.bike), isNotEmpty);
    });

    test('treadmill 白名单非空', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.treadmill), isNotEmpty);
    });

    test('elliptical 白名单非空', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.elliptical), isNotEmpty);
    });

    test('rower 白名单非空', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.rower), isNotEmpty);
    });

    test('strengthStation 白名单非空', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.strengthStation), isNotEmpty);
    });
  });
}
