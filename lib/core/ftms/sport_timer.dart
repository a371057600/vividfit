import 'dart:async';

import 'package:flutter/foundation.dart';

/// 时间同步状态枚举
///
/// 用于描述 [SportTimer] 本地计时与设备时间之间的偏差状态。
enum TimeSyncStatus {
  /// 偏差 <1s，本地与设备时间一致
  synced,

  /// 偏差 1~5s，等待连续两次确认后再校准
  drifting,

  /// 偏差 >5s，需立即校准
  unsynced,

  /// 3s 无设备数据，仅依赖本地计时
  noData,
}

/// 运动计时器
///
/// 统一管理运动场景下的本地计时与设备时间同步。基于 [Stopwatch] 进行本地
/// 计时，通过 [syncFromDevice] 接收设备归一化时间值并按偏差阈值进行校准，
/// 保证本地展示的运动时长与设备一致。
///
/// 校准机制说明：由于 [Stopwatch] 不支持 offset，这里通过 [_baseOffset] 维护
/// 校准基准，[elapsed] 返回值 = [Stopwatch.elapsed] 的秒数 + [_baseOffset]。
class SportTimer {
  // 核心计时器
  final Stopwatch _stopwatch = Stopwatch();

  // Timer.periodic(1s) 用于触发 UI 更新回调
  Timer? _ticker;

  // 每秒回调，参数为当前已运动秒数
  void Function(int elapsed)? onTick;

  // 上次成功同步的时刻
  // ignore: unused_field
  DateTime? _lastSyncTime;

  // 上次同步时的设备值
  // ignore: unused_field
  int? _lastDeviceElapsed;

  // 上次校准检查时间（每 60 秒才允许一次偏差判定与校准）
  DateTime? _lastCalibrateCheckTime;

  // 当前偏差毫秒数
  int _driftMs = 0;

  // 同步状态
  TimeSyncStatus _syncStatus = TimeSyncStatus.noData;

  // 上次收到数据的时间
  // ignore: unused_field
  DateTime? _lastDataTime;

  // 校准基准偏移量（秒），校准后 [Stopwatch] 归零，elapsed = 秒数 + _baseOffset
  int _baseOffset = 0;

  // 是否等待设备计时启动（start/resume 后设备真正开始计时前的武装状态）
  bool _waitingDeviceStart = false;

  // 等待期间记录的设备时间基准（设备值超过它才算"设备计时已启动"）
  int? _waitingRefDeviceElapsed;

  /// 归零并进入「等待设备计时启动」状态
  ///
  /// 发送开始指令后设备有数秒延迟才真正计时，本地不立即启动，
  /// 而是等设备时间开始递增后再以设备时间为基准启动本地计时，
  /// 从根本上避免本地超前设备产生的负向 drift 反复纠正。
  void start() {
    _baseOffset = 0;
    _stopwatch.reset();
    _waitingDeviceStart = true;
    _waitingRefDeviceElapsed = null;
    // 重置校准节流基准：设备启动后首帧允许立即校准一次
    _lastCalibrateCheckTime = null;
    _syncStatus = TimeSyncStatus.noData;
    debugPrint('[SportTimer] start: 已武装，等待设备时间递增后启动本地计时');
  }

  /// 暂停计时
  void pause() {
    _stopwatch.stop();
    _ticker?.cancel();
    _ticker = null;
    debugPrint('[SportTimer] paused at ${elapsed}s');
  }

  /// 恢复计时（同样等设备时间恢复递增后再启动，设备恢复也有延迟）
  void resume() {
    _stopwatch.stop();
    _waitingDeviceStart = true;
    _waitingRefDeviceElapsed = null;
    _lastCalibrateCheckTime = null;
    debugPrint('[SportTimer] resume: 已武装，等待设备时间恢复递增');
  }

  /// 停止并归零
  void stop() {
    _stopwatch.stop();
    _stopwatch.reset();
    _ticker?.cancel();
    _ticker = null;
    _baseOffset = 0;
    _waitingDeviceStart = false;
    _waitingRefDeviceElapsed = null;
    debugPrint('[SportTimer] stopped and reset');
  }

  /// 已运动秒数（本地计时 + 校准基准偏移）
  int get elapsed => _stopwatch.elapsed.inSeconds + _baseOffset;

  /// 计时是否真正运行中（非武装等待、非暂停）。
  ///
  /// Notifier 用它守卫数据帧对 realSportTime 的直写：
  /// 只有运行中才允许设备帧驱动显示，武装/暂停期显示由本地 ticker 独占。
  bool get isRunning => _stopwatch.isRunning && !_waitingDeviceStart;

  /// 用设备归一化值校准本地计时
  ///
  /// 校准策略（等待设备启动 + 60 秒节流 + 单向防回退）：
  /// - start/resume 后处于武装状态：仅当设备时间开始递增才启动本地计时
  /// - 计时中：首帧立即判定；之后每 60 秒才做一次偏差判定，避免每秒纠正的怪异观感
  /// - |drift| <= 1s：视为同步，不校准
  /// - drift > 1s（设备超前）：校准，显示正向推进（UI 单调守卫 + 翻转动画平顺过渡）
  /// - drift < 0（设备落后）：**不回退**，保持本地继续计时，等设备追上后自然对齐
  void syncFromDevice(int deviceElapsed) {
    _lastDataTime = DateTime.now();

    // 武装状态：监听设备时间是否开始递增
    if (_waitingDeviceStart) {
      final ref = _waitingRefDeviceElapsed;
      if (ref == null) {
        // 首帧：仅记录基准，无论是否大于 0 都等「递增」再启动。
        // （部分设备点击开始后先短暂计数又重置，不能见非零就立即跟跑）
        _waitingRefDeviceElapsed = deviceElapsed;
        debugPrint('[SportTimer] 等待设备计时启动: device=${deviceElapsed}s');
        return;
      }
      if (deviceElapsed > ref) {
        // 设备时间递增 → 以设备时间为基准启动本地计时
        _beginRunFromDevice(deviceElapsed);
      } else if (deviceElapsed < ref) {
        // 设备时间回落（会话重置）：刷新基准继续等待
        _waitingRefDeviceElapsed = deviceElapsed;
        debugPrint('[SportTimer] 设备计时回落，重置基准: device=${deviceElapsed}s');
      }
      // 设备时间未动，继续等待（本地保持不动）
      return;
    }

    // 校准检查节流：除首帧外，60 秒内不重复做偏差判定与校准
    final lastCheck = _lastCalibrateCheckTime;
    if (lastCheck != null &&
        _lastDataTime!.difference(lastCheck) < const Duration(seconds: 60)) {
      return;
    }
    _lastCalibrateCheckTime = _lastDataTime;

    final localElapsed = elapsed;
    final drift = deviceElapsed - localElapsed;
    _driftMs = drift * 1000;

    if (drift.abs() <= 1) {
      // 偏差 <= 1s，视为同步
      _syncStatus = TimeSyncStatus.synced;
    } else if (drift > 0) {
      // 设备超前：正向校准（不回退），由 UI 层单调守卫保证时间只前进
      _calibrate(deviceElapsed);
      _syncStatus = TimeSyncStatus.synced;
    } else {
      // 设备落后：保持本地计时（不回退），等待下一周期自然对齐
      _syncStatus = TimeSyncStatus.drifting;
    }

    _lastSyncTime = DateTime.now();
    _lastDeviceElapsed = deviceElapsed;

    debugPrint(
      '[SportTimer] sync: local=${localElapsed}s, device=${deviceElapsed}s, '
      'drift=${drift}s, status=${_syncStatus.name}（60s 节流）',
    );
  }

  /// 设备计时已启动：以设备时间为基准启动本地计时
  void _beginRunFromDevice(int deviceElapsed) {
    _waitingDeviceStart = false;
    _waitingRefDeviceElapsed = null;
    _baseOffset = deviceElapsed;
    _stopwatch
      ..reset()
      ..start();
    _syncStatus = TimeSyncStatus.synced;
    _lastDeviceElapsed = deviceElapsed;
    _lastSyncTime = DateTime.now();
    _startTicker();
    // 立即回调一次，让显示从设备当前值起步（避免 0 → N 秒的空窗跳变）
    onTick?.call(elapsed);
    debugPrint(
      '[SportTimer] 设备计时已启动，本地计时跟随: ${deviceElapsed}s 起步',
    );
  }

  /// 校准本地计时器
  ///
  /// 通过 [_baseOffset] 记录设备时间作为基准，[Stopwatch] 归零后继续累计，
  /// 从而保证 [elapsed] 从设备时间开始递增。
  void _calibrate(int deviceElapsed) {
    final oldOffset = _baseOffset;
    final wasRunning = _stopwatch.isRunning;
    _baseOffset = deviceElapsed;
    _stopwatch.reset();
    if (wasRunning) {
      _stopwatch.start();
    }
    debugPrint(
      '[SportTimer] calibrating: offset ${oldOffset}s → ${_baseOffset}s',
    );
  }

  /// 当前同步状态
  TimeSyncStatus get syncStatus => _syncStatus;

  /// 当前偏差（毫秒）
  int get driftMs => _driftMs;

  /// 标记无数据状态（3s 无设备数据时调用）
  void markNoData() {
    _syncStatus = TimeSyncStatus.noData;
    debugPrint('[SportTimer] ⚠️ no device data, relying on local');
  }

  /// 启动每秒 ticker，触发 [onTick] 回调
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      debugPrint('[SportTimer] tick: ${elapsed}s');
      onTick?.call(elapsed);
    });
  }

  /// 释放资源
  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
  }
}
