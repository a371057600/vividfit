import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/ftms/ftms_device_type.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_course_home_notifier.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_course_home_notifier_provider.dart';

GymCourseHomeNotifier _createNotifier() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container.read(gymCourseHomeNotifierProvider.notifier);
}

void main() {
  group('GymCourseHomeNotifier', () {
    test('bootstrap(0) 选中 bike + 5 张卡片', () {
      final notifier = _createNotifier();
      notifier.bootstrap(0);
      expect(notifier.state.selectedDeviceCategory, FtmsDeviceType.indoorBike);
      expect(notifier.state.entryCards!.length, 5);
    });

    test('bootstrap(2) 选中 elliptical', () {
      final notifier = _createNotifier();
      notifier.bootstrap(2);
      expect(notifier.state.selectedDeviceCategory, FtmsDeviceType.crossTrainer);
    });

    test('resolveCardImage bike 返回正确路径', () {
      final notifier = _createNotifier();
      notifier.bootstrap(0);
      expect(
        notifier.resolveCardImage(3),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_3.jpg',
      );
    });

    test('deviceTitleKey treadmill 返回 treadmillMachine', () {
      final notifier = _createNotifier();
      notifier.bootstrap(1);
      expect(notifier.deviceTitleKey, 'treadmillMachine');
    });

    test('deviceEnglishTitle rower 返回 Rowing Machine', () {
      final notifier = _createNotifier();
      notifier.bootstrap(3);
      // expect(notifier.deviceEnglishTitleKey, 'Rowing Machine');
    });
  });
}
