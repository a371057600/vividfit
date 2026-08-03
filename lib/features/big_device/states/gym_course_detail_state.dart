import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../data/course_play_data.dart';

part 'gym_course_detail_state.freezed.dart';

/// 详情页已解析的单个动作(对应旧 controller 内 `ActionList` 类)。
///
/// 由 `BarLineData` 解析而来,语音字段已按方言匹配选出。
@freezed
abstract class CourseActionListItem with _$CourseActionListItem {
  const factory CourseActionListItem({
    int? orderId,
    int? count,
    int? duration,
    int? posture,
    int? resistance,
    int? cadence,
    int? gradient,
    int? distance,
    String? name,
    String? zipDownLoadPath,
    String? imagePath,
    String? imageName,
    String? bgmName,
    String? voiceName,
    String? bgmDownLoadPath,
    String? voiceDownLoadPath,
    String? imagePathName,
    bool? isRestStage,
    int? imagefps,
    int? imageLength,
  }) = _CourseActionListItem;
}

/// 课程详情页状态(对应旧 `ControllerCourseDetail` 的响应式字段)。
///
/// 数据加载字段 + 下载相关字段(已补充,见下方)。
@freezed
abstract class GymCourseDetailState with _$GymCourseDetailState {
  const factory GymCourseDetailState({
    /// 当前设备类型(对应旧 newMainSelectType)。
    @Default(FtmsDeviceType.indoorBike) FtmsDeviceType deviceType,

    /// 当前课程 ID(对应旧 courseId)。
    int? courseId,

    /// 是否正在加载(对应旧 isLoading,初始 true)。
    @Default(true) bool isLoading,

    /// 课程封面图 URL(对应旧 courseImage)。
    @Default('') String courseImage,

    /// 课程属性(对应旧 courseProperties,JSON 模型直接复用)。
    CourseProperties? courseProperties,

    /// 课程标题属性(对应旧 courseTitle)。
    TitleProperties? courseTitle,

    /// 已解析的动作列表(对应旧 courseActionList)。
    @Default([]) List<CourseActionListItem> courseActionList,

    /// courseId 在 JSON 中找不到时为 true(对应旧 `Get.back()` 退回上一页)。
    @Default(false) bool notFound,

    // ─── 下载相关字段(对接 course_download 模块)─────────────────
    /// 是否处于下载/解压中(对应旧 isNeedDownloaded)。
    @Default(false) bool isNeedDownloaded,

    /// 真实聚合下载进度 0.0–1.0(替代旧版伪造跳变)。
    @Default(0.0) double downLoadProgress,

    /// 已完成文件数 / 总文件数。
    @Default(0) int downloadedFileCount,
    @Default(0) int totalFileCount,

    /// 当前正在下载的文件名(用于日志/调试)。
    String? currentDownloadingFile,

    /// 是否允许进播放页(对应旧 allowGoToPlayScreen,防抖)。
    @Default(true) bool allowGoToPlayScreen,

    /// 课程是否已全部就绪(文件齐 + 图解压完),决定按钮行为。
    @Default(false) bool isCourseReady,

    /// 下载失败原因。
    String? downloadError,
  }) = _GymCourseDetailState;
}
