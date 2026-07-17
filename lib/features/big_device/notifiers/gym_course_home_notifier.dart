import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/device_category.dart';
import '../data/entry_card_data.dart';
import '../states/gym_course_home_state.dart';

part 'gym_course_home_notifier.g.dart';

@riverpod
class GymCourseHomeNotifier extends _$GymCourseHomeNotifier {
  @override
  GymCourseHomeState build() {
    return const GymCourseHomeState();
  }

  void bootstrap(int deviceCategoryIndex) {
    final category = DeviceCategoryExtension.fromIndex(deviceCategoryIndex);
    state = state.copyWith(
      selectedDeviceCategory: category,
      entryCards: EntryCardData.defaultCards,
    );
  }

  String resolveCardImage(int dataIndex) {
    return EntryCardData.resolveCardImage(state.selectedDeviceCategory, dataIndex);
  }

  String get deviceTitleKey =>
      EntryCardData.deviceTitleKey(state.selectedDeviceCategory);

  String get deviceEnglishTitle =>
      EntryCardData.deviceEnglishTitle(state.selectedDeviceCategory);
}
