import 'package:freezed_annotation/freezed_annotation.dart';

import 'goal_banner_display_state.dart';

part 'quick_start_state.freezed.dart';

@freezed
abstract class QuickStartState with _$QuickStartState {
  const factory QuickStartState({
    /// 是否显示开始按钮（对应旧 hc.showPlayButton）。
    @Default(true) bool showPlayButton,

    /// 是否正在暂停（对应旧 hc.isPause）。
    @Default(false) bool isPaused,

    /// 是否在快速开始播放中（对应旧 hc.isInQuickPlay）。
    @Default(false) bool isInQuickPlay,

    /// 是否正在播放（对应旧 hc.isPlaying）。
    @Default(false) bool isPlaying,

    /// 音乐是否正在播放。
    @Default(false) bool isMusicPlaying,

    /// 当前运动时间（秒）。
    @Default(0) int realSportTime,

    /// 运动距离（米）。
    @Default(0.0) double sportDistance,

    /// 卡路里。
    @Default(0.0) double sportEnergy,

    /// 当前速度。
    @Default(0.0) double sportSpeed,

    /// 踏频。
    @Default(0.0) double sportCadence,

    /// 心率。
    @Default(0) int sportHeartRate,

    /// 桨频。
    @Default(0.0) double sportStrokeRate,

    /// 桨次数。
    @Default(0.0) double sportStrokeCount,

    /// NPC 时间（跑道动画用）。
    @Default(0.0) double npcTime,

    /// 最大速度。
    @Default(0) int maxSpeed,

    /// 阻力按钮当前值。
    @Default(0.0) double sportResistanceButton,

    /// 速度按钮当前值。
    @Default(0.0) double sportSpeedButton,

    /// 坡度按钮当前值。
    @Default(0.0) double sportInclinationButton,

    /// 速度实际值（设备数据通道实时值，内部验证用，不直接驱动按钮）。
    @Default(0.0) double sportSpeedActual,

    /// 阻力实际值（设备数据通道实时值）。
    @Default(0.0) double sportResistanceActual,

    /// 坡度实际值（设备数据通道实时值）。
    @Default(0.0) double sportInclinationActual,

    /// 速度命令锁窗口标志（锁定期间数据流不得覆盖按钮值）。
    @Default(false) bool isSpeedLocked,

    /// 阻力命令锁窗口标志。
    @Default(false) bool isResistanceLocked,

    /// 坡度命令锁窗口标志。
    @Default(false) bool isInclinationLocked,

    /// 设备断连标志（驱动训练页自动退出）。
    @Default(false) bool isDeviceConnectionLost,

    /// 指令重发耗尽标志（驱动页面 Toast 提示）。
    @Default(false) bool lastParamSyncFailed,

    // ==================== 设备能力范围（0x2AD4/0x2AD5/0x2AD6 动态读取） ====================
    // 数值已换算为物理值：速度 km/h（÷100）、坡度 %（÷10）、阻力 level（÷10）。
    // 0 表示尚未读到设备范围（回退默认常量）。

    /// 速度下限（km/h），0 表示未读到。
    @Default(0.0) double speedRangeMin,

    /// 速度上限（km/h），0 表示未读到。
    @Default(0.0) double speedRangeMax,

    /// 速度步长（km/h），0 表示未读到。
    @Default(0.0) double speedRangeStep,

    /// 坡度下限（%），0 表示未读到。
    @Default(0.0) double inclinationRangeMin,

    /// 坡度上限（%），0 表示未读到。
    @Default(0.0) double inclinationRangeMax,

    /// 坡度步长（%），0 表示未读到。
    @Default(0.0) double inclinationRangeStep,

    /// 阻力下限（level），0 表示未读到。
    @Default(0.0) double resistanceRangeMin,

    /// 阻力上限（level），0 表示未读到。
    @Default(0.0) double resistanceRangeMax,

    /// 阻力步长（level），0 表示未读到。
    @Default(0.0) double resistanceRangeStep,

    /// 阻力档位列表。
    @Default(<double>[0, 0, 0, 0]) List<double> buttonResistanceList,

    /// 速度档位列表。
    @Default(<double>[0, 0, 0, 0]) List<double> buttonSpeedList,

    /// 坡度档位列表。
    @Default(<double>[0, 0, 0, 0]) List<double> buttonInclinationList,

    /// 是否支持坡度。
    @Default(false) bool hasInclinationSupport,

    /// 是否支持速度调节（0x2AD4 上报 max<=min 视为不支持）。
    @Default(true) bool hasSpeedSupport,

    /// 是否支持阻力调节（0x2AD6 上报 max<=min 视为不支持）。
    @Default(true) bool hasResistanceSupport,

    /// 设备运行状态检测：进入界面时设备是否正在被动运行
    /// （速度/踏频/桨频任一 > 0 且用户未主动开始），用于触发阻塞层。
    @Default(false) bool isDeviceRunningDetected,

    // ==================== 目标达成弹窗相关状态 ====================
    /// 已达成的时间目标档位索引（避免重复弹窗）。
    @Default(<int>[]) List<int> achievedTimeLevels,

    /// 已达成的距离目标档位索引。
    @Default(<int>[]) List<int> achievedDistanceLevels,

    /// 已达成的卡路里目标档位索引。
    @Default(<int>[]) List<int> achievedEnergyLevels,

    /// 【时间目标达成】弹窗的显示状态。
    @Default(GoalBannerDisplayState.hidden) GoalBannerDisplayState timeDialogDisplayState,

    /// 【距离目标达成】弹窗的显示状态。
    @Default(GoalBannerDisplayState.hidden) GoalBannerDisplayState distanceDialogDisplayState,

    /// 【卡路里目标达成】弹窗的显示状态。
    @Default(GoalBannerDisplayState.hidden) GoalBannerDisplayState energyDialogDisplayState,

    /// 当前触发的时间目标值（秒），供 UI 展示。
    @Default(0) int currentTimeGoalSec,

    /// 当前触发的距离目标值（公里），供 UI 展示。
    @Default(0.0) double currentDistanceGoalKm,

    /// 当前触发的卡路里目标值（千卡），供 UI 展示。
    @Default(0.0) double currentEnergyGoalKcal,
  }) = _QuickStartState;
}
