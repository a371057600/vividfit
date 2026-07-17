import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/data/entry_card_data.dart';

void main() {
  group('EntryCardData', () {
    test('defaultCards 有 5 张', () {
      expect(EntryCardData.defaultCards.length, 5);
    });

    test('resolveCardImage bike 返回正确路径', () {
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.bike, 0),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_0.jpg',
      );
    });

    test('resolveCardImage treadmill 返回正确路径', () {
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.treadmill, 3),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_3.jpg',
      );
    });

    test('resolveCardImage elliptical 返回正确路径', () {
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.elliptical, 2),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_2.jpg',
      );
    });

    test('resolveCardImage rower 返回正确路径', () {
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.rower, 1),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_1.jpg',
      );
    });

    test('resolveCardImage strengthStation 返回正确路径', () {
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.strengthStation, 4),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_4.jpg',
      );
    });

    test('deviceTitleKey 映射正确', () {
      expect(EntryCardData.deviceTitleKey(DeviceCategory.bike), 'spinBike');
      expect(EntryCardData.deviceTitleKey(DeviceCategory.treadmill), 'treadmillMachine');
    });

    test('deviceEnglishTitle 映射正确', () {
      expect(EntryCardData.deviceEnglishTitle(DeviceCategory.rower), 'Rowing Machine');
      expect(EntryCardData.deviceEnglishTitle(DeviceCategory.strengthStation), 'Strength Station');
    });
  });
}
