import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../states/quick_start_state.dart';

part 'quick_start_notifier.g.dart';

// ==================== 目标达成弹窗阈值常量（集中调节入口，严格对齐 XML 档位表） ====================
/// 时间目标档位（分钟）。XML 表格「5/10/15/20/30/45/60/90/120/180」MIN
const List<int> kTimeGoalLevelsMin = [5, 10, 15, 20, 30, 45, 60, 90, 120, 180];

/// 时间目标档位（秒，供内部比对用，由 [kTimeGoalLevelsMin] × 60 生成）。
List<int> get _kTimeGoalLevelsSec =>
    kTimeGoalLevelsMin.map((m) => m * 60).toList(growable: false);

/// 距离目标档位（公里）。XML 表格「0.5/1/2/3/5/8/10/15/20/30/50/70」KM
const List<double> kDistanceGoalLevelsKm = [
  0.5,
  1,
  2,
  3,
  5,
  8,
  10,
  15,
  20,
  30,
  50,
  70,
];

/// 距离目标档位（米，供内部比对用，由 [kDistanceGoalLevelsKm] × 1000 生成）。
List<double> get _kDistanceGoalLevelsM =>
    kDistanceGoalLevelsKm.map((km) => km * 1000).toList(growable: false);

/// 卡路里目标档位（千卡）。XML 表格「30/60/100/150/220/300/500/800/1000/1200/1500/2000」KCAL
const List<double> kEnergyGoalLevelsKcal = [
  30,
  60,
  100,
  150,
  220,
  300,
  500,
  800,
  1000,
  1200,
  1500,
  2000,
];

/// 目标弹窗自动关闭时长（秒）。
const int kGoalDialogAutoDismissSec = 5;

/// 目标弹窗类型枚举，用于队列管理。
enum GoalDialogType { time, distance, energy }

/// 快速开始 Notifier（Riverpod 3.0 代码生成，业务逻辑留白）。
///
/// 所有运动控制方法暂留 TODO，待蓝牙模块完整迁移后实现。
@Riverpod(keepAlive: true)
class QuickStartNotifier extends _$QuickStartNotifier {
  FtmsDeviceType _deviceType = FtmsDeviceType.indoorBike;

  FtmsDeviceType get deviceType => _deviceType;

  // ==================== 目标达成弹窗：Timer 与队列 ====================
  Timer? _timeGoalTimer;
  Timer? _distanceGoalTimer;
  Timer? _energyGoalTimer;
  Timer? _mockTickTimer;

  /// 弹窗队列：当已有弹窗显示时，后续入队等待展示。
  final List<GoalDialogType> _pendingDialogQueue = [];

  bool _isAnyDialogVisible() =>
      state.showTimeGoalDialog ||
      state.showDistanceGoalDialog ||
      state.showEnergyGoalDialog;

  void setDeviceType(FtmsDeviceType type) {
    _deviceType = type;
    // 设置mock数据用于UI调试
    state = _getMockStateForDevice(type);
  }

  /// 根据设备类型返回mock数据
  QuickStartState _getMockStateForDevice(FtmsDeviceType type) {
    switch (type) {
      case FtmsDeviceType.indoorBike:
        return state.copyWith(
          realSportTime: 125,
          sportDistance: 1250.0,
          sportEnergy: 45.0,
          sportSpeed: 22.5,
          sportCadence: 85.0,
          sportHeartRate: 128,
          npcTime: 25.0,
          maxSpeed: 0,
          sportResistanceButton: 8.0,
          sportSpeedButton: 0.0,
          sportInclinationButton: 0.0,
          buttonResistanceList: [4.0, 6.0, 10.0, 12.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
        );
      case FtmsDeviceType.treadmill:
        return state.copyWith(
          realSportTime: 180,
          sportDistance: 2400.0,
          sportEnergy: 88.0,
          sportSpeed: 8.5,
          sportCadence: 0.0,
          sportHeartRate: 135,
          npcTime: 35.0,
          maxSpeed: 2000, // FTMS原始值，除以100=20km/h
          sportResistanceButton: 0.0,
          sportSpeedButton: 8.0,
          sportInclinationButton: 3.0,
          buttonResistanceList: [0.0, 0.0, 0.0, 0.0],
          buttonSpeedList: [4.0, 6.0, 10.0, 12.0],
          buttonInclinationList: [0.0, 1.0, 5.0, 7.0],
          hasInclinationSupport: true,
        );
      case FtmsDeviceType.crossTrainer:
        return state.copyWith(
          realSportTime: 210,
          sportDistance: 3200.0,
          sportEnergy: 120.0,
          sportSpeed: 18.0,
          sportCadence: 70.0,
          sportHeartRate: 142,
          npcTime: 40.0,
          maxSpeed: 0,
          sportResistanceButton: 12.0,
          sportSpeedButton: 0.0,
          sportInclinationButton: 5.0,
          buttonResistanceList: [6.0, 9.0, 15.0, 18.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [1.0, 3.0, 7.0, 9.0],
          hasInclinationSupport: true,
        );
      case FtmsDeviceType.rower:
        return state.copyWith(
          realSportTime: 300,
          sportDistance: 1500.0,
          sportEnergy: 210.0,
          sportSpeed: 12.0,
          sportCadence: 0.0,
          sportHeartRate: 155,
          npcTime: 55.0,
          maxSpeed: 0,
          sportStrokeRate: 28.0,
          sportStrokeCount: 850.0,
          sportResistanceButton: 6.0,
          sportSpeedButton: 0.0,
          sportInclinationButton: 0.0,
          buttonResistanceList: [2.0, 4.0, 8.0, 10.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
        );
      case FtmsDeviceType.strengthStation:
        return state;
    }
  }

  @override
  QuickStartState build() => const QuickStartState();

  // ==================== 目标达成弹窗：判定与队列 ====================

  /// 每次运动数据变化后调用：检查 3 个维度是否命中新目标档。
  void _checkAndTriggerGoalDialogs() {
    // 3 个维度互相独立并行，同时弹窗不互斥；enqueue 内已按类型判断是否该类型已显示。
    _checkTimeGoal();
    _checkDistanceGoal();
    _checkEnergyGoal();
  }

  void _checkTimeGoal() {
    final timeLevelsSec = _kTimeGoalLevelsSec;
    if (state.achievedTimeLevels.length >= timeLevelsSec.length) return;
    for (int i = 0; i < timeLevelsSec.length; i++) {
      if (state.achievedTimeLevels.contains(i)) continue;
      if (state.realSportTime >= timeLevelsSec[i]) {
        print(
          '🎯 [GoalDialog] ✨ 触发时间目标弹窗：level=$i, '
          'minutes=${kTimeGoalLevelsMin[i]}',
        );
        state = state.copyWith(
          achievedTimeLevels: [...state.achievedTimeLevels, i],
          currentTimeGoalSec: timeLevelsSec[i],
        );
        _enqueueDialog(GoalDialogType.time);
        return;
      }
    }
  }

  void _checkDistanceGoal() {
    final distLevelsM = _kDistanceGoalLevelsM;
    if (state.achievedDistanceLevels.length >= distLevelsM.length) {
      return;
    }
    for (int i = 0; i < distLevelsM.length; i++) {
      if (state.achievedDistanceLevels.contains(i)) continue;
      if (state.sportDistance >= distLevelsM[i]) {
        print(
          '🎯 [GoalDialog] ✨ 触发距离目标弹窗：level=$i, '
          'km=${kDistanceGoalLevelsKm[i]}',
        );
        state = state.copyWith(
          achievedDistanceLevels: [...state.achievedDistanceLevels, i],
          currentDistanceGoalKm: kDistanceGoalLevelsKm[i],
        );
        _enqueueDialog(GoalDialogType.distance);
        return;
      }
    }
  }

  void _checkEnergyGoal() {
    if (state.achievedEnergyLevels.length >= kEnergyGoalLevelsKcal.length) {
      return;
    }
    for (int i = 0; i < kEnergyGoalLevelsKcal.length; i++) {
      if (state.achievedEnergyLevels.contains(i)) continue;
      // 浮点容差比较，避免 219.999... 漏触发 220 档
      final threshold = kEnergyGoalLevelsKcal[i];
      if (state.sportEnergy + 0.0005 >= threshold) {
        print(
          '🎯 [GoalDialog] ✨ 触发卡路里目标弹窗：level=$i, kcal=${threshold.toStringAsFixed(0)}',
        );
        state = state.copyWith(
          achievedEnergyLevels: [...state.achievedEnergyLevels, i],
          currentEnergyGoalKcal: threshold,
        );
        _enqueueDialog(GoalDialogType.energy);
        return;
      }
    }
  }

  void _enqueueDialog(GoalDialogType type) {
    // —— 允许三个类型同时弹窗：
    // 1. 同一类型：已经展示时，新事件先入队（避免同一槽位瞬间覆盖），Timer 结束后自动推进该类型队列
    // 2. 不同类型：并行展示，彼此互不阻塞
    if (_isDialogTypeVisible(type)) {
      _pendingDialogQueue.add(type);
      return;
    }
    _showDialog(type);
  }

  /// 按 [dismissedType] 推进对应类型的队列（允许其他类型继续显示，互不阻塞）。
  void _processPendingDialogQueue(GoalDialogType dismissedType) {
    if (_isDialogTypeVisible(dismissedType)) return;
    // 只找队列中下一个"被关闭的类型"，其他类型不动
    final idx = _pendingDialogQueue.indexWhere((e) => e == dismissedType);
    if (idx < 0) return;
    final next = _pendingDialogQueue.removeAt(idx);
    _showDialog(next);
  }

  /// 判断指定类型是否正在显示（解除互斥后，仅判断自身 show 开关）。
  bool _isDialogTypeVisible(GoalDialogType type) => switch (type) {
    GoalDialogType.time => state.showTimeGoalDialog,
    GoalDialogType.distance => state.showDistanceGoalDialog,
    GoalDialogType.energy => state.showEnergyGoalDialog,
  };

  void _showDialog(GoalDialogType type) {
    switch (type) {
      case GoalDialogType.time:
        // 先做一次赋值（turn on show 开关），然后再用相同 state 触发一次 rebuild，
        // 规避 Riverpod 对「连续相同 copyWith」做去重导致的 Widget 不重建问题。
        final before = state;
        state = state.copyWith(showTimeGoalDialog: true);
        print(
          '🎯 [GoalDialog] SHOW TIME → '
          'seconds=${state.currentTimeGoalSec}, '
          'show=${state.showTimeGoalDialog} (之前=${before.showTimeGoalDialog})',
        );
        state = state.copyWith(); // 主动触发一次重建（value 不变但 Widget 会重建）
        _timeGoalTimer?.cancel();
        _timeGoalTimer = Timer(
          const Duration(seconds: kGoalDialogAutoDismissSec),
          () {
            print(
              '🎯 [GoalDialog] ⏱️ ${kGoalDialogAutoDismissSec}秒到，自动关闭：时间目标弹窗',
            );
            dismissTimeGoalDialog();
          },
        );
        break;
      case GoalDialogType.distance:
        final before = state;
        state = state.copyWith(showDistanceGoalDialog: true);
        print(
          '🎯 [GoalDialog] SHOW DISTANCE → '
          'km=${state.currentDistanceGoalKm}, '
          'show=${state.showDistanceGoalDialog} (之前=${before.showDistanceGoalDialog})',
        );
        state = state.copyWith();
        _distanceGoalTimer?.cancel();
        _distanceGoalTimer = Timer(
          const Duration(seconds: kGoalDialogAutoDismissSec),
          () {
            print(
              '🎯 [GoalDialog] ⏱️ ${kGoalDialogAutoDismissSec}秒到，自动关闭：距离目标弹窗',
            );
            dismissDistanceGoalDialog();
          },
        );
        break;
      case GoalDialogType.energy:
        final before = state;
        state = state.copyWith(showEnergyGoalDialog: true);
        print(
          '🎯 [GoalDialog] SHOW ENERGY → '
          'kcal=${state.currentEnergyGoalKcal.toStringAsFixed(0)}, '
          'show=${state.showEnergyGoalDialog} (之前=${before.showEnergyGoalDialog})',
        );
        state = state.copyWith();
        _energyGoalTimer?.cancel();
        _energyGoalTimer = Timer(
          const Duration(seconds: kGoalDialogAutoDismissSec),
          () {
            print(
              '🎯 [GoalDialog] ⏱️ ${kGoalDialogAutoDismissSec}秒到，自动关闭：卡路里目标弹窗',
            );
            dismissEnergyGoalDialog();
          },
        );
        break;
    }
  }

  void dismissTimeGoalDialog() {
    _timeGoalTimer?.cancel();
    _timeGoalTimer = null;
    state = state.copyWith(showTimeGoalDialog: false);
    _processPendingDialogQueue(GoalDialogType.time);
  }

  void dismissDistanceGoalDialog() {
    _distanceGoalTimer?.cancel();
    _distanceGoalTimer = null;
    state = state.copyWith(showDistanceGoalDialog: false);
    _processPendingDialogQueue(GoalDialogType.distance);
  }

  void dismissEnergyGoalDialog() {
    _energyGoalTimer?.cancel();
    _energyGoalTimer = null;
    state = state.copyWith(showEnergyGoalDialog: false);
    _processPendingDialogQueue(GoalDialogType.energy);
  }

  /// 页面 dispose 时统一清理所有弹窗 Timer 与临时 mock Timer。
  void disposeGoalTimers() {
    print('🎯 [GoalDialog] 🧹 清理弹窗全部 Timer');
    _timeGoalTimer?.cancel();
    _distanceGoalTimer?.cancel();
    _energyGoalTimer?.cancel();
    _mockTickTimer?.cancel();
    _timeGoalTimer = null;
    _distanceGoalTimer = null;
    _energyGoalTimer = null;
    _mockTickTimer = null;
    _pendingDialogQueue.clear();
  }

  // [DEBUG-TEST-BUTTONS] 开始：调试用强制触发方法（测试完成后搜索本标记删除整块）

  /// [调试专用] 仅清空指定类型的弹窗状态：Timer、show 开关、该类型队列项。
  ///
  /// 允许另外两个类型继续显示，实现三个 Banner 并行。
  void _debugResetDialogTypeForImmediateShow(GoalDialogType type) {
    switch (type) {
      case GoalDialogType.time:
        _timeGoalTimer?.cancel();
        _timeGoalTimer = null;
        state = state.copyWith(showTimeGoalDialog: false);
        break;
      case GoalDialogType.distance:
        _distanceGoalTimer?.cancel();
        _distanceGoalTimer = null;
        state = state.copyWith(showDistanceGoalDialog: false);
        break;
      case GoalDialogType.energy:
        _energyGoalTimer?.cancel();
        _energyGoalTimer = null;
        state = state.copyWith(showEnergyGoalDialog: false);
        break;
    }
    // 仅清理该类型在 pending queue 中的所有项
    _pendingDialogQueue.removeWhere((e) => e == type);
  }

  /// 调试用：随机触发一个时间档位的弹窗（XML 10 档中随机选一，立刻展示，不影响另外两个 Banner）。
  void debugForceTriggerTimeDialog() {
    final rng = Random();
    final idx = rng.nextInt(kTimeGoalLevelsMin.length);
    final minutes = kTimeGoalLevelsMin[idx];
    print('🧪 [DEBUG-TEST-BUTTONS] 随机触发时间目标弹窗：level=$idx, minutes=$minutes');
    _debugResetDialogTypeForImmediateShow(GoalDialogType.time);
    state = state.copyWith(currentTimeGoalSec: minutes * 60);
    _showDialog(GoalDialogType.time);
  }

  /// 调试用：随机触发一个距离档位的弹窗（XML 12 档中随机选一，立刻展示，不影响另外两个 Banner）。
  void debugForceTriggerDistanceDialog() {
    final rng = Random();
    final idx = rng.nextInt(kDistanceGoalLevelsKm.length);
    final km = kDistanceGoalLevelsKm[idx];
    print('🧪 [DEBUG-TEST-BUTTONS] 随机触发距离目标弹窗：level=$idx, km=$km');
    _debugResetDialogTypeForImmediateShow(GoalDialogType.distance);
    state = state.copyWith(currentDistanceGoalKm: km);
    _showDialog(GoalDialogType.distance);
  }

  /// 调试用：随机触发一个卡路里档位的弹窗（XML 12 档中随机选一，立刻展示，不影响另外两个 Banner）。
  void debugForceTriggerEnergyDialog() {
    final rng = Random();
    final idx = rng.nextInt(kEnergyGoalLevelsKcal.length);
    final kcal = kEnergyGoalLevelsKcal[idx];
    print(
      '🧪 [DEBUG-TEST-BUTTONS] 随机触发卡路里目标弹窗：level=$idx, kcal=${kcal.toStringAsFixed(0)}',
    );
    _debugResetDialogTypeForImmediateShow(GoalDialogType.energy);
    state = state.copyWith(currentEnergyGoalKcal: kcal);
    _showDialog(GoalDialogType.energy);
  }

  // [DEBUG-TEST-BUTTONS] 结束

  // ==================== 业务方法（部分 TODO，待蓝牙完整迁移） ====================

  /// 发送重置指令到设备（对应旧 cnfbd.sendResetToDevice）。
  void sendResetToDevice() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 开始运动（对应旧 cnfbd.startSport）。
  ///
  /// 蓝牙模块未接入前启动临时本地 mock Timer 累加运动数据，
  /// 便于在真机快速验证 3 个目标弹窗的触发与 30 秒自动消失行为。
  /// 蓝牙接入后将累加逻辑替换为真实回调，在回调处调用 [_checkAndTriggerGoalDialogs] 即可。
  void startSport() {
    state = state.copyWith(
      showPlayButton: false,
      isInQuickPlay: true,
      isPlaying: true,
    );
    _mockTickTimer?.cancel();
    _mockTickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        realSportTime: state.realSportTime + 1,
        sportDistance: state.sportDistance + 5.0, // 5 m/s
        sportEnergy: state.sportEnergy + 0.4, // 0.4 kcal/s
        npcTime: state.npcTime + 1.0,
      );
      _checkAndTriggerGoalDialogs();
    });
    // 立即做一次检查，避免刚到阈值的用户漏掉弹窗
    _checkAndTriggerGoalDialogs();
  }

  /// 停止运动（对应旧 cnfbd.stopSport）。
  void stopSport() {
    _mockTickTimer?.cancel();
    _mockTickTimer = null;
    state = state.copyWith(isPlaying: false);
  }

  /// 暂停运动（对应旧 cnfbd.pauseSport）。
  void pauseSport() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 清除数据（对应旧 cnfbd.clearData）。
  void clearData() {
    disposeGoalTimers();
    state = const QuickStartState();
  }

  /// 阻力 +（对应旧 cnfbd.resistanceAdd）。
  void resistanceAdd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 阻力 -（对应旧 cnfbd.resistanceDown）。
  void resistanceDown() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 速度 +（对应旧 cnfbd.speedAdd）。
  void speedAdd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 速度 -（对应旧 cnfbd.speedDown）。
  void speedDown() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 坡度 +（对应旧 cnfbd.inclinationAdd）。
  void inclinationAdd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 坡度 -（对应旧 cnfbd.inclinationDown）。
  void inclinationDown() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 长按结束（对应旧 cnfbd.longPressEnd）。
  void longPressEnd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 数字按钮选择（对应旧 cnfbd.numberButton）。
  void numberButton(double value, int type) {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 更新音乐播放状态（对应旧 setState isMusicPlaying）。
  void updateMusicPlaying(bool playing) {
    state = state.copyWith(isMusicPlaying: playing);
  }

  /// 秒转时间字符串（对应旧 cnfbd.convertSecondsToTime）。
  String convertSecondsToTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
