import 'package:freezed_annotation/freezed_annotation.dart';

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

    /// 是否显示【时间目标达成】弹窗。
    @Default(false) bool showTimeGoalDialog,

    /// 是否显示【距离目标达成】弹窗。
    @Default(false) bool showDistanceGoalDialog,

    /// 是否显示【卡路里目标达成】弹窗。
    @Default(false) bool showEnergyGoalDialog,

    /// 当前触发的时间目标值（秒），供 UI 展示。
    @Default(0) int currentTimeGoalSec,

    /// 当前触发的距离目标值（公里），供 UI 展示。
    @Default(0.0) double currentDistanceGoalKm,

    /// 当前触发的卡路里目标值（千卡），供 UI 展示。
    @Default(0.0) double currentEnergyGoalKcal,
  }) = _QuickStartState;
}
