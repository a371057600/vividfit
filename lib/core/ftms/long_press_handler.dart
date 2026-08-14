import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ftms_command_dispatcher.dart';
import 'ftms_data_sync_guard.dart';

/// 长按定时器管理器。
///
/// 用于处理调速/调坡度等长按场景下的连续步进控制：
/// - 启动时立即执行一步，随后每 500ms 执行一次。
/// - 每步通过 [FtmsCommandDispatcher.dispatchImmediate] 即时下发指令。
/// - 松手时通过 debounce 模式下发最终值，并开启保护窗口，
///   防止设备 0x2ADA 回调覆盖本地刚写入的值。
///
/// 边界处理采用 clamp（不回绕），到达边界后自动停止定时器。
class LongPressHandler {
  LongPressHandler({
    required this.dispatcher,
    required this.syncGuard,
    required this.getCurrentValue,
    required this.min,
    required this.max,
    required this.step,
    required this.commandBuilder,
    required this.isIncrement,
  });

  /// FTMS 指令调度器。
  final FtmsCommandDispatcher dispatcher;

  /// 数据同步保护器，松手时开启保护窗口。
  final FtmsDataSyncGuard syncGuard;

  /// 获取当前值的回调。
  final int Function() getCurrentValue;

  /// 最小值边界。
  final int min;

  /// 最大值边界。
  final int max;

  /// 单步步进值（设备实际 step）。
  final int step;

  /// 根据指定值构建 FTMS 指令。
  final FtmsCommand Function(int value) commandBuilder;

  /// 是否递增长按。true=递增，false=递减。
  final bool isIncrement;

  /// 每步值变化时的回调（用于更新本地状态）。
  void Function(int value)? onValueChanged;

  /// 长按步进定时器。
  Timer? _timer;

  /// 长按步进周期。
  static const Duration _stepInterval = Duration(milliseconds: 500);

  /// 松手后保护窗口时长。
  static const Duration _guardWindowDuration = Duration(milliseconds: 1500);

  /// 启动长按。
  ///
  /// 立即执行一步，随后每 [_stepInterval] 触发一次 [_step]。
  void startLongPress() {
    final currentValue = getCurrentValue();
    debugPrint(
      '[LongPress] start: isIncrement=$isIncrement, step=$step, current=$currentValue',
    );
    // 立即执行一步
    _step();
    // 启动周期定时器
    _timer?.cancel();
    _timer = Timer.periodic(_stepInterval, (_) => _step());
  }

  /// 停止长按。
  ///
  /// 取消定时器，通过 debounce 模式下发最终值，并开启保护窗口。
  void stopLongPress() {
    _timer?.cancel();
    _timer = null;
    final finalValue = getCurrentValue();
    dispatcher.dispatch(commandBuilder(finalValue));
    syncGuard.beginGuardWindow(_guardWindowDuration);
    debugPrint(
      '[LongPress] stop: finalValue=$finalValue, '
      'dispatch(debounce) + guard window(${_guardWindowDuration.inMilliseconds}ms)',
    );
  }

  /// 释放资源。
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  /// 执行一步步进。
  ///
  /// 计算新值并 clamp 到边界；若已到达边界则停止定时器；
  /// 否则通过回调更新本地值，并立即下发指令。
  void _step() {
    final currentValue = getCurrentValue();
    final raw = isIncrement ? currentValue + step : currentValue - step;
    // clamp 返回 num，需显式转 int
    final newValue = raw.clamp(min, max).toInt();

    if (newValue == currentValue) {
      // 已在边界，停止定时器
      _timer?.cancel();
      _timer = null;
      final bound = isIncrement ? max : min;
      debugPrint(
        '[LongPress] 🔒 clamp at ${isIncrement ? 'max' : 'min'}=$bound, timer cancelled',
      );
      return;
    }

    // 更新本地值
    onValueChanged?.call(newValue);
    // 立即下发指令
    dispatcher.dispatchImmediate(commandBuilder(newValue));
    debugPrint('[LongPress] step: $currentValue → $newValue, dispatchImmediate');
  }
}
