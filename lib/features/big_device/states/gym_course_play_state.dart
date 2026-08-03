import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';

part 'gym_course_play_state.freezed.dart';

/// 训练状态枚举，对应页面四种显示状态
enum GymPlayScreenStatus {
  /// 加载中
  loading,

  /// 播放/训练中
  playing,

  /// 暂停页
  paused,

  /// 结束页
  finished,
}

/// 设备控制按钮类型
enum GymControlButtonType {
  speed,
  inclination,
  resistance,
}

/// 顶部数据栏显示项
@freezed
abstract class GymTopDataItem with _$GymTopDataItem {
  const factory GymTopDataItem({
    required String iconPath,
    required String label,
    required String value,
  }) = _GymTopDataItem;
}

/// 单个结束页数据项
@freezed
abstract class GymFinishDataItem with _$GymFinishDataItem {
  const factory GymFinishDataItem({
    required String iconPath,
    required String title,
    required String value,
    required String unit,
  }) = _GymFinishDataItem;
}

/// 评分条目
@freezed
abstract class GymRatingItem with _$GymRatingItem {
  const factory GymRatingItem({
    required String title,
    required int score,
  }) = _GymRatingItem;
}

/// 进度条分段数据
@freezed
abstract class GymProgressSegment with _$GymProgressSegment {
  const factory GymProgressSegment({
    required double percentage,
    required int heightFactor,
    required int posture,
  }) = _GymProgressSegment;
}

/// 训练状态模型，整合 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot
@freezed
abstract class GymCoursePlayState with _$GymCoursePlayState {
  const factory GymCoursePlayState({
    /// 设备类型
    @Default(FtmsDeviceType.indoorBike) FtmsDeviceType deviceType,

    /// 页面状态: loading / playing / finished
    @Default(GymPlayScreenStatus.loading) GymPlayScreenStatus screenStatus,

    /// 是否允许触摸返回
    @Default(true) bool allowTouch,

    /// 是否显示中央播放按钮
    @Default(true) bool showPlayButton,

    /// 是否在播放
    @Default(false) bool isPlaying,

    /// 是否暂停（对应旧 isPause）
    @Default(false) bool isPause,

    /// 是否在暂停页（用于显示暂停覆盖层）
    @Default(false) bool isPauseScreen,

    /// 是否在结束页（对应旧 isStopScreen）
    @Default(false) bool isStopScreen,

    // ─── 课程元数据 ───

    /// 课程标题(大标题)，对应旧 titleProperties.bigTitle
    @Default('Power Cycle Pro') String courseTitle,

    /// 难度文字
    @Default('Intermediate') String difficulty,

    /// 等级 (1-5)
    @Default(3) int level,

    /// 目标阻力等级（旧 ControllerNewFourBigDeviceSprot）
    @Default(3) int targetResistanceLevel,

    // ─── 实时运动数据（设备返回的原始数据，String 用于显示） ───

    /// 运动时间 (mm:ss 格式)
    @Default('00:00') String sportTime,

    /// 运动距离 (km 字符串)
    @Default('0.00') String sportDistance,

    /// 消耗卡路里
    @Default('0.0') String sportCalories,

    /// 实时设备速度（km/h）
    @Default('0.0') String sportSpeed,

    /// 设备实际速度（double，用于逻辑判断）
    @Default(0.0) double sportDeviceSpeed,

    /// 实时心率
    @Default('0') String sportHeartRate,

    /// 实时踏频 (rpm)
    @Default('0') String sportCadence,

    /// 实时桨频 (spm, 划船机用)
    @Default('0') String sportStrokeRate,

    /// 实时桨次数 (划船机用)
    @Default('0') String sportStrokeCount,

    /// 实时坡度（String 显示）
    @Default('0.0') String sportInclination,

    /// 实时阻力（String 显示）
    @Default('0') String sportResistance,

    // ─── 按钮值(UI 显示 + 用于发送指令) ───

    /// 按钮速度值
    @Default(25.0) double sportSpeedButton,

    /// 按钮坡度值
    @Default(5.0) double sportInclinationButton,

    /// 按钮阻力值
    @Default(3.0) double sportResistanceButton,

    /// 是否支持坡度(跑步机)
    @Default(true) bool hasInclinationSupport,

    /// 速度范围
    @Default(0) int minSpeed,
    @Default(50) int maxSpeed,

    /// 坡度范围
    @Default(-5) int minInclination,
    @Default(10) int maxInclination,

    /// 阻力范围
    @Default(1) int minResistance,
    @Default(10) int maxResistance,

    // ─── 课程播放进度 ───

    /// 当前动作索引
    @Default(0) int playIndex,

    /// 当前动作总时长(秒)
    @Default(60) int currentDuration,

    /// 当前动作已播放时长(秒)
    @Default(0) int playIndexDuration,

    /// 课程总已播放时长(秒)
    @Default(0) int playTotalDuration,

    /// 课程总进度总时长(秒)
    @Default(525) int totalPlayProgressDuration,

    /// 当前动画帧索引
    @Default(0) int imagePlayIndex,

    /// 动画帧率
    @Default(30) int imageFps,

    /// 播放进度百分比 (0.0-1.0)，控制底部箭头位置
    @Default(0.0) double playProgressPercent,

    /// 动作列表（对应旧 courseActionList）
    @Default([]) List<ActionItemState> courseActions,

    /// 右侧动作名称列表
    @Default([]) List<String> currentActionNameList,

    /// 进度条分段数据（对应旧 _automaticProgressBarFloatingWidget）
    @Default([]) List<GymProgressSegment> progressSegments,

    // ─── 结束页数据（10 项） ───

    /// 结束页数据图标路径
    @Default([]) List<String> finishDataIcons,

    /// 结束页数据标题
    @Default([]) List<String> finishDataTitles,

    /// 结束页数据值
    @Default([]) List<String> finishDataValues,

    /// 结束页数据单位
    @Default([]) List<String> finishDataUnits,

    // ─── 评分（4 项） ───

    /// 评分标题
    @Default([]) List<String> ratingTitles,

    /// 评分等级（0-5）
    @Default([]) List<int> ratingScores,

    /// 评分等级文字（例如 "Level A"）
    @Default('Level A') String scoreLevel,

    /// 等级对应的图片索引（0-5）
    @Default([0, 0, 0, 2]) List<int> ratingImageIndices,

    // ─── 速度图表 ───

    /// 速度图表数据（每 5 秒采样）
    @Default([]) List<double> speedChartData,
  }) = _GymCoursePlayState;
}

/// 单个课程动作(对应旧 ActionList)
@freezed
abstract class ActionItemState with _$ActionItemState {
  const factory ActionItemState({
    @Default('Warm Up') String name,
    @Default('') String imageName,
    @Default(60) int duration,
    @Default(3) int resistance,
    @Default(25) int cadence,
    @Default(0) int posture,
    @Default(false) bool isRestStage,
    @Default(30) int imageFps,
    @Default(300) int imageLength,
    @Default(0) int orderId,
    @Default(0) int count,
    @Default(0) int distance,
  }) = _ActionItemState;
}
