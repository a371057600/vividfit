import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../data/entry_card_data.dart';
import '../states/gym_course_home_state.dart';

part 'gym_course_home_notifier.g.dart';

@Riverpod(keepAlive: true)
class GymCourseHomeNotifier extends _$GymCourseHomeNotifier {
  @override
  GymCourseHomeState build() {
    // 初始即填充 5 张默认卡片,避免首帧渲染空白。
    return GymCourseHomeState(
      entryCards: EntryCardData.defaultCards,
    );
  }

  void bootstrap(int deviceCategoryIndex) {
    final category = FtmsDeviceType.fromValue(deviceCategoryIndex);
    state = state.copyWith(
      selectedDeviceCategory: category,
      entryCards: EntryCardData.defaultCards,
    );
  }

  /// 获取入口卡片列表,若为 null 则返回默认 5 张卡片。
  List<EntryCardData> get resolvedEntryCards =>
      state.entryCards ?? EntryCardData.defaultCards;

  String resolveCardImage(int dataIndex) {
    return EntryCardData.resolveCardImage(state.selectedDeviceCategory, dataIndex);
  }

  String get deviceTitleKey =>
      EntryCardData.deviceTitleKey(state.selectedDeviceCategory);
}