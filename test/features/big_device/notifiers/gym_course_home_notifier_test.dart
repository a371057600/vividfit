import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_course_home_notifier.dart';

void main() {
  group('GymCourseHomeNotifier', () {
    test('bootstrap(0) 选中 bike + 5 张卡片', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(0);
      expect(notifier.state.selectedDeviceCategory, DeviceCategory.bike);
      expect(notifier.state.entryCards.length, 5);
    });

    test('bootstrap(2) 选中 elliptical', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(2);
      expect(notifier.state.selectedDeviceCategory, DeviceCategory.elliptical);
    });

    test('resolveCardImage bike 返回正确路径', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(0);
      expect(
        notifier.resolveCardImage(3),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_3.jpg',
      );
    });

    test('deviceTitleKey treadmill 返回 treadmillMachine', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(1);
      expect(notifier.deviceTitleKey, 'treadmillMachine');
    });

    test('deviceEnglishTitle rower 返回 Rowing Machine', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(3);
      expect(notifier.deviceEnglishTitle, 'Rowing Machine');
    });
  });
}
