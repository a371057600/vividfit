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

    /// 阻力档位列表。
    @Default(<double>[0, 0, 0, 0]) List<double> buttonResistanceList,

    /// 速度档位列表。
    @Default(<double>[0, 0, 0, 0]) List<double> buttonSpeedList,

    /// 坡度档位列表。
    @Default(<double>[0, 0, 0, 0]) List<double> buttonInclinationList,

    /// 是否支持坡度。
    @Default(false) bool hasInclinationSupport,

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

    // ==================== 阻力加载状态（任务3） ====================
    /// 阻力指令下发后是否正在等待设备回执实际阻力值。
    /// true 时中心按钮显示「获取中」，收到 0x07 回执或超时后置 false。
    @Default(false) bool isFetchingResistance,

    // ==================== 设备运行状态检测（任务5） ====================
    /// 进入界面时检测到设备是否正在运行（speed/cadence/strokeRate > 0）。
    /// true 时弹出引导用户先停止设备的阻塞弹窗，设备停转后自动置 false。
    @Default(false) bool isDeviceRunningDetected,
  }) = _QuickStartState;
}
