import 'package:flutter/foundation.dart';

/// 参数维度。
enum ParamDimension { speed, inclination, resistance }

/// 引擎决策结果。
sealed class ParamSyncDecision {
  const ParamSyncDecision();
}

/// 未匹配（中间值/渐变中/超调未回落）：仅更新实际值，按钮保持不动（防弹跳核心）。
class ParamSyncWaiting extends ParamSyncDecision {
  const ParamSyncWaiting({required this.isOvershooting});

  /// 当前是否处于超调等待回落状态。
  final bool isOvershooting;
}

/// 匹配成功（容差内 + 稳定 + 方向正确 + 超调已回落）：解锁并允许同步按钮。
class ParamSyncMatched extends ParamSyncDecision {
  const ParamSyncMatched();
}

/// 锁超时：解锁，由上层走指令重发轨道，按钮保持用户输入值。
class ParamSyncLockTimeout extends ParamSyncDecision {
  const ParamSyncLockTimeout();
}

/// 未锁定且设备值稳定：设备端自行调整，允许同步按钮（设备优先级）。
class ParamSyncStableIdle extends ParamSyncDecision {
  const ParamSyncStableIdle({required this.value});

  /// 设备端稳定下来的值，用于同步按钮。
  final double value;
}

/// 各维度匹配容差。
const Map<ParamDimension, double> kParamTolerance = {
  ParamDimension.speed: 0.1, // km/h
  ParamDimension.inclination: 0.1, // %
  ParamDimension.resistance: 0.5, // level
};

/// 稳定判定时间窗口（固定时间窗口，规避设备上报频率差异）。
const Duration kStableWindow = Duration(milliseconds: 500);

/// 命令锁窗口时长。
const Duration kLockTimeout = Duration(seconds: 4);

/// 超调后等待回落的最长时间。
const Duration kOvershootWindow = Duration(seconds: 2);

/// 引擎内部维护的单维度状态。
class _DimState {
  bool locked = false;
  double target = 0;
  int direction = 0; // 1=上升, -1=下降, 0=无方向
  DateTime lockStartTime = DateTime.now();
  bool hasOvershot = false;
  DateTime? overshootStartTime;
  // 稳定检测：记录上次值与该值首次出现时间
  double? lastStableCandidate;
  DateTime? stableCandidateSince;
  // waiting 日志节流基准：上次打印过的实际值（变化超过容差才再次打印，防刷屏）
  double? lastLoggedActual;
  // 上次已触发 stableIdle 的值（同值不重复触发，仅当值再次变化时重新计时）
  double? lastStableIdleValue;
}

/// FTMS 参数同步引擎：命令锁窗口 + 匹配式同步 + 防超调。
///
/// 防弹跳三条铁律：
/// 1. **永不同步中间值**：设备渐变过程中的任何中间值都不允许覆盖按钮显示；
/// 2. **匹配 = 容差 + 稳定 + 方向 + 无未回落超调**：四个条件全部满足，
///    才判定指令执行完成并解锁同步按钮；
/// 3. **锁定期间目标值只受用户指令 / 设备主动变更影响**：
///    数据流仅用于验证指令执行情况，不得改写目标值。
class FtmsParamSyncEngine {
  final Map<ParamDimension, _DimState> _states = {};

  _DimState _stateOf(ParamDimension dim) =>
      _states.putIfAbsent(dim, () => _DimState());

  /// 用户发送参数指令时锁定目标值。
  ///
  /// 可重入：长按/连点时刷新目标值与超时基准，不产生锁冲突。
  void lock(ParamDimension dim, double target, double fromValue) {
    final state = _stateOf(dim);
    state.locked = true;
    state.target = target;
    state.direction = target > fromValue ? 1 : (target < fromValue ? -1 : 0);
    state.lockStartTime = DateTime.now();
    state.hasOvershot = false;
    state.overshootStartTime = null;
    // 清空稳定候选与日志节流基准：新锁窗口内重新观测
    state.lastStableCandidate = null;
    state.stableCandidateSince = null;
    state.lastLoggedActual = null;
    state.lastStableIdleValue = null;
    debugPrint(
        '[SyncEngine] lock: dim=${dim.name}, target=$target, from=$fromValue, direction=${state.direction}');
  }

  /// 每帧设备数据到达时调用，返回决策。
  ParamSyncDecision onActualUpdate(ParamDimension dim, double actual) {
    final state = _stateOf(dim);
    final tol = kParamTolerance[dim]!;
    final now = DateTime.now();

    if (state.locked) {
      // 1. 命令锁超时：4s 内未完成匹配，强制解锁走重发轨道
      if (now.difference(state.lockStartTime) >= kLockTimeout) {
        debugPrint(
            '[SyncEngine] dim=${dim.name}, lockTimeout（4s 未匹配），解锁走重发轨道');
        _reset(state);
        return const ParamSyncLockTimeout();
      }

      // 2. 防超调检测：实际值沿命令方向越过目标超过容差
      final bool crossedOver = state.direction > 0
          ? actual - state.target > tol
          : state.direction < 0
              ? state.target - actual > tol
              : false;
      if (crossedOver && !state.hasOvershot) {
        state.hasOvershot = true;
        state.overshootStartTime = now;
        final sign = state.direction > 0 ? '>' : '<';
        debugPrint(
            '[SyncEngine] dim=${dim.name}, overshoot: actual=$actual $sign target=${state.target}，等待回落');
      }

      // 3. 超调回落等待窗口耗尽：仍未回到容差内则强制解锁走重发轨道
      if (state.hasOvershot &&
          state.overshootStartTime != null &&
          now.difference(state.overshootStartTime!) >= kOvershootWindow &&
          (actual - state.target).abs() > tol) {
        debugPrint(
            '[SyncEngine] dim=${dim.name}, lockTimeout（超调未回落: actual=$actual, target=${state.target}），解锁走重发轨道');
        _reset(state);
        return const ParamSyncLockTimeout();
      }

      final bool inTolerance = (actual - state.target).abs() <= tol;

      if (inTolerance) {
        // 超调已回落：当前回到容差内即视为回落，继续走稳定判定
        if (state.hasOvershot) {
          state.hasOvershot = false;
          state.overshootStartTime = null;
        }
        // 稳定判定（500ms 固定窗口）
        _trackStableCandidate(state, actual, tol, now);
        if (state.stableCandidateSince != null &&
            now.difference(state.stableCandidateSince!) >= kStableWindow) {
          debugPrint(
              '[SyncEngine] dim=${dim.name}, ✅ matched: actual=$actual ≈ target=${state.target}，解锁+同步按钮');
          _reset(state);
          return const ParamSyncMatched();
        }
      } else {
        // 中间值：仅当实际值与上次打印值变化超过容差时打印日志，防止刷屏
        _logWaitingThrottled(state, dim, actual, tol);
      }
      return ParamSyncWaiting(isOvershooting: state.hasOvershot);
    }

    // ==== 未锁定分支：设备端自行调整（设备优先级）====
    _trackStableCandidate(state, actual, tol, now);
    final bool stable = state.stableCandidateSince != null &&
        now.difference(state.stableCandidateSince!) >= kStableWindow;
    // 同值不重复触发 stableIdle，仅当值再次变化时重新计时
    final bool alreadyEmitted = state.lastStableIdleValue != null &&
        (actual - state.lastStableIdleValue!).abs() <= tol / 2;
    if (stable && !alreadyEmitted) {
      debugPrint(
          '[SyncEngine] dim=${dim.name}, stableIdle: 设备端稳定于 actual=$actual，同步按钮');
      // 返回后清空稳定候选，避免数据帧重复触发
      state.lastStableCandidate = null;
      state.stableCandidateSince = null;
      state.lastStableIdleValue = actual;
      return ParamSyncStableIdle(value: actual);
    }
    return const ParamSyncWaiting(isOvershooting: false);
  }

  /// 强制解锁单个维度（设备主动变更/用户停止时）。
  void forceUnlock(ParamDimension dim) {
    debugPrint('[SyncEngine] forceUnlock: dim=${dim.name}');
    _reset(_stateOf(dim));
  }

  /// 解锁全部维度（断连/清零场景）。
  void unlockAll() {
    debugPrint('[SyncEngine] unlockAll: 全部维度解锁');
    for (final dim in ParamDimension.values) {
      _reset(_stateOf(dim));
    }
  }

  /// 设备端主动变更目标值（0x2ADA 事件）：对齐 target 与 actual，防误判重发。
  void notifyDeviceTargetChanged(ParamDimension dim, double value) {
    debugPrint('[SyncEngine] deviceTargetChanged: dim=${dim.name}, value=$value');
    final state = _stateOf(dim);
    _reset(state);
    // 对齐稳定候选为设备新目标，避免紧随其后的数据帧重复触发 stableIdle
    state.lastStableCandidate = value;
    state.lastStableIdleValue = value;
  }

  /// 查询维度是否锁定。
  bool isLocked(ParamDimension dim) => _stateOf(dim).locked;

  /// 稳定候选追踪：与上次候选差值在容差一半内视为同值，保持首次出现时间；
  /// 否则更新候选并重新计时。
  void _trackStableCandidate(
      _DimState state, double actual, double tol, DateTime now) {
    final bool sameValue = state.lastStableCandidate != null &&
        (actual - state.lastStableCandidate!).abs() <= tol / 2;
    if (sameValue && state.stableCandidateSince != null) {
      return;
    }
    state.lastStableCandidate = actual;
    state.stableCandidateSince = now;
  }

  /// waiting 日志节流：仅当实际值与上次打印值变化超过容差时打印。
  void _logWaitingThrottled(
      _DimState state, ParamDimension dim, double actual, double tol) {
    final bool shouldLog = state.lastLoggedActual == null ||
        (actual - state.lastLoggedActual!).abs() > tol;
    if (shouldLog) {
      debugPrint(
          '[SyncEngine] dim=${dim.name}, waiting: actual=$actual, target=${state.target}（中间值，按钮保持）');
      state.lastLoggedActual = actual;
    }
  }

  /// 清理维度全部状态。
  void _reset(_DimState state) {
    state.locked = false;
    state.target = 0;
    state.direction = 0;
    state.lockStartTime = DateTime.now();
    state.hasOvershot = false;
    state.overshootStartTime = null;
    state.lastStableCandidate = null;
    state.stableCandidateSince = null;
    state.lastLoggedActual = null;
    state.lastStableIdleValue = null;
  }
}
