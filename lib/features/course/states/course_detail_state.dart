import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/course_detail.dart';

part 'course_detail_state.freezed.dart';

@freezed
class CourseDetailState with _$CourseDetailState {
  const factory CourseDetailState({
    /// 课程动作详情
    CourseDetail? courseDetail,

    /// 课程封面图 URL
    @Default('') String courseCover,

    /// 课程 ID
    @Default('') String courseId,

    /// 课程标题
    @Default('') String courseTitle,

    /// 课程交互设备类型
    @Default(0) int interactiveEquipment,

    /// 版本号（用于判断是否需要更新）
    @Default(0) int version,

    /// 课程建议
    @Default('') String proposal,

    /// 课程描述
    @Default('') String describe,

    /// 注意事项
    @Default('') String carefulthing,

    /// 是否需要更新（下载）
    @Default(true) bool isNeedUpdate,

    /// 是否正在下载
    @Default(false) bool isDownloading,

    /// 下载进度 0-100
    @Default(0.0) double downloadProgress,

    /// 是否有可连接设备
    @Default(false) bool playWithDevice,

    /// 是否正在加载动作数据
    @Default(false) bool isActionDataLoading,

    /// 课程 index（在列表中的位置）
    @Default(0) int courseIndex,

    /// 当前选中的动作索引（底部 sheet 用）
    @Default(0) int selectedActionIndex,

    /// 图片播放相关
    @Default(false) bool isPlaying,
    @Default(0) int pictureIndex,
    @Default(0) int totalPictureIndex,
    @Default([]) List<String> pictureFileNameList,
    @Default('') String pictureNamePath,
  }) = _CourseDetailState;
}
