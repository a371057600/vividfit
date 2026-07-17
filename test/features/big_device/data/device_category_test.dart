import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';

void main() {
  group('DeviceCategory', () {
    test('index 映射正确 0-4', () {
      expect(DeviceCategory.bike.index, 0);
      expect(DeviceCategory.treadmill.index, 1);
      expect(DeviceCategory.elliptical.index, 2);
      expect(DeviceCategory.rower.index, 3);
      expect(DeviceCategory.strengthStation.index, 4);
    });

    test('fromIndex 映射正确', () {
      expect(DeviceCategoryExtension.fromIndex(0), DeviceCategory.bike);
      expect(DeviceCategoryExtension.fromIndex(1), DeviceCategory.treadmill);
      expect(DeviceCategoryExtension.fromIndex(2), DeviceCategory.elliptical);
      expect(DeviceCategoryExtension.fromIndex(3), DeviceCategory.rower);
      expect(DeviceCategoryExtension.fromIndex(4), DeviceCategory.strengthStation);
      expect(DeviceCategoryExtension.fromIndex(99), DeviceCategory.bike); // default
    });

    test('toCourseTypeSelect 映射正确', () {
      expect(DeviceCategory.bike.toCourseTypeSelect(), 0);
      expect(DeviceCategory.treadmill.toCourseTypeSelect(), 1);
      expect(DeviceCategory.elliptical.toCourseTypeSelect(), 2);
      expect(DeviceCategory.rower.toCourseTypeSelect(), 3);
      expect(DeviceCategory.strengthStation.toCourseTypeSelect(), 4);
    });
  });
}
