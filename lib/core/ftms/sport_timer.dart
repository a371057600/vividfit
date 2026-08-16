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

  // 当前偏差毫秒数
  int _driftMs = 0;

  // 同步状态
  TimeSyncStatus _syncStatus = TimeSyncStatus.noData;

  // 待确认的偏差值（两次确认机制用）
  int? _pendingDrift;

  // 上次收到数据的时间
  // ignore: unused_field
  DateTime? _lastDataTime;

  // 校准基准偏移量（秒），校准后 [Stopwatch] 归零，elapsed = 秒数 + _baseOffset
  int _baseOffset = 0;

  // 预启动标志：start() 已调用但尚未收到设备首帧时间数据。
  // 在此状态下 Stopwatch 不启动，避免本地计时领先于设备导致回跳。
  bool _armed = false;

  /// 预启动计时器。
  ///
  /// 不立即启动 [Stopwatch]，仅标记为预启动状态（[_armed]）。
  /// 等待 [syncFromDevice] 收到设备首帧时间后，以设备时间为基准
  /// 真正启动计时，避免本地计时领先于设备导致 UI 回跳。
  void start() {
    _baseOffset = 0;
    _stopwatch.reset();
    _stopwatch.stop();
    _armed = true;
    _syncStatus = TimeSyncStatus.noData;
    // 预启动阶段不启动 ticker，避免本地 elapsed 从 0 开始递增
    // 而设备尚未上报时间（设备上报有延迟），导致 drift 校准回 0 产生回跳。
    debugPrint('[SportTimer] start: armed (waiting for first device time)');
  }

  /// 暂停计时
  void pause() {
    _armed = false;
    _stopwatch.stop();
    _ticker?.cancel();
    _ticker = null;
    debugPrint('[SportTimer] paused at ${elapsed}s');
  }

  /// 恢复计时
  void resume() {
    _stopwatch.start();
    _startTicker();
    debugPrint('[SportTimer] resumed from ${elapsed}s');
  }

  /// 停止并归零
  void stop() {
    _armed = false;
    _stopwatch.stop();
    _stopwatch.reset();
    _ticker?.cancel();
    _ticker = null;
    _baseOffset = 0;
    debugPrint('[SportTimer] stopped and reset');
  }

  /// 已运动秒数（本地计时 + 校准基准偏移）
  int get elapsed => _stopwatch.elapsed.inSeconds + _baseOffset;

  /// 用设备归一化值校准本地计时
  ///
  /// 首帧处理：若处于预启动状态（[_armed]），以设备时间直接校准并启动计时，
  /// 使本地计时从设备时间开始递增，避免本地领先导致的回跳。
  ///
  /// 后续帧校准策略：
  /// - |drift| <= 1s：视为同步，不校准。
  /// - 1 < |drift| <= 5s：进入 drifting 状态，需连续两次相同偏差才校准。
  /// - |drift| > 5s：立即校准。
  void syncFromDevice(int deviceElapsed) {
    // 预启动状态：首帧设备时间到达，以此为准启动计时
    if (_armed) {
      _armed = false;
      _baseOffset = deviceElapsed;
      _stopwatch.reset();
      _stopwatch.start();
      _startTicker();
      _syncStatus = TimeSyncStatus.synced;
      _lastSyncTime = DateTime.now();
      _lastDeviceElapsed = deviceElapsed;
      debugPrint(
        '[SportTimer] first sync (armed→running): device=${deviceElapsed}s, '
        'timer started from device time',
      );
      return;
    }

    final localElapsed = elapsed;
    final drift = deviceElapsed - localElapsed;
    _driftMs = drift * 1000;
    _lastDataTime = DateTime.now();

    if (drift.abs() <= 1) {
      // 偏差 <= 1s，视为同步
      _syncStatus = TimeSyncStatus.synced;
      _pendingDrift = null;
    } else if (drift.abs() <= 5) {
      // 偏差 1~5s，需连续两次相同偏差才校准
      if (_pendingDrift == drift) {
        _calibrate(deviceElapsed);
        _syncStatus = TimeSyncStatus.synced;
        _pendingDrift = null;
      } else {
        _pendingDrift = drift;
        _syncStatus = TimeSyncStatus.drifting;
      }
    } else {
      // 偏差 > 5s，立即校准
      _calibrate(deviceElapsed);
      _syncStatus = TimeSyncStatus.synced;
      _pendingDrift = null;
    }

    _lastSyncTime = DateTime.now();
    _lastDeviceElapsed = deviceElapsed;

    debugPrint(
      '[SportTimer] sync: local=${localElapsed}s, device=${deviceElapsed}s, '
      'drift=${drift}s, status=${_syncStatus.name}',
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
