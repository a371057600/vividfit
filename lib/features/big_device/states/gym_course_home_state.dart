import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../data/entry_card_data.dart';

part 'gym_course_home_state.freezed.dart';

@freezed
abstract class GymCourseHomeState with _$GymCourseHomeState {
  const factory GymCourseHomeState({
    /// 当前选中的设备类型(对应旧 `newMainSelectType`)。
    @Default(FtmsDeviceType.indoorBike) FtmsDeviceType selectedDeviceCategory,

    /// 5 张入口卡片数据(对应旧 `cardData`)。
    /// null 表示未初始化,build() 时填充默认卡片。
    List<EntryCardData>? entryCards,

    /// 是否处于快速播放模式(对应旧 `isInQuickPlay`)。
    @Default(false) bool isInQuickPlay,

    /// 数据允许标志(对应旧 `dataAllowFlag`)。
    @Default(false) bool dataAllowFlag,
  }) = _GymCourseHomeState;
}
