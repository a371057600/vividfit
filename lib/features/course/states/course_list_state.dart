import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/course_list.dart';

part 'course_list_state.freezed.dart';

@freezed
abstract class CourseListState with _$CourseListState {
  const factory CourseListState({
    /// 当前选中的设备类型索引(0-6)
    @Default(0) int deviceType,

    /// 课程数据缓存（按 deviceType 索引）
    @Default({}) Map<int, CourseList> courseDataMap,

    /// 是否正在加载
    @Default(true) bool isLoading,

    /// 是否首次进入
    @Default(true) bool isFirstIn,

    /// 设备名称列表（用于左侧分类展示）
    /// 注意：实际显示文本在UI层通过AppLocalizations获取，此处仅保留空占位。
    @Default([
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ])
    List<String> showDeviceNameList,

    /// 是否允许跳转到游戏页面（防重复点击）
    @Default(true) bool allowToGamePage,
  }) = _CourseListState;
}
