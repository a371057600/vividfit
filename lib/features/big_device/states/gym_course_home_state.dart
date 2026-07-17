import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/device_category.dart';
import '../data/entry_card_data.dart';

part 'gym_course_home_state.freezed.dart';

@freezed
class GymCourseHomeState with _$GymCourseHomeState {
  const factory GymCourseHomeState({
    /// 当前选中的设备类型(对应旧 `newMainSelectType`)。
    @Default(DeviceCategory.bike) DeviceCategory selectedDeviceCategory,

    /// 5 张入口卡片数据(对应旧 `cardData`)。
    @Default(<EntryCardData>[]) List<EntryCardData> entryCards,
  }) = _GymCourseHomeState;
}
