import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vividfit_v2/core/ftms/ftms_device_type.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_course_play_notifier.dart';
import 'package:vividfit_v2/features/big_device/states/gym_course_play_state.dart';

GymCoursePlayNotifier _createNotifier() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container.read(gymCoursePlayProvider.notifier);
}

void main() {
  group('GymCoursePlayNotifier', () {
    test('initial state uses indoorBike and is not paused', () {
      final notifier = _createNotifier();
      final state = notifier.state;

      expect(state.deviceType, FtmsDeviceType.indoorBike);
      expect(state.isPause, false);
      expect(state.isPauseScreen, false);
      expect(state.showPlayButton, false);
      expect(state.isPlaying, true);
      expect(state.isStopScreen, false);
    });

    test('pauseSport() sets isPauseScreen to true', () {
      final notifier = _createNotifier();

      notifier.pauseSport();

      final state = notifier.state;
      expect(state.isPauseScreen, true);
      expect(state.isPause, true);
      expect(state.showPlayButton, true);
      // 其他状态保持不变
      expect(state.isPlaying, true);
      expect(state.isStopScreen, false);
    });

    test('resumeSport() sets isPauseScreen to false', () {
      final notifier = _createNotifier();

      notifier.pauseSport();
      notifier.resumeSport();

      final state = notifier.state;
      expect(state.isPauseScreen, false);
      expect(state.isPause, false);
      expect(state.showPlayButton, false);
      expect(state.isPlaying, true);
    });

    test('exitToDetail() clears all playing states', () {
      final notifier = _createNotifier();

      notifier.pauseSport();
      notifier.exitToDetail();

      final state = notifier.state;
      expect(state.isPause, false);
      expect(state.isPauseScreen, false);
      expect(state.isPlaying, false);
      expect(state.showPlayButton, false);
      expect(state.isStopScreen, false);
    });
  });
}
