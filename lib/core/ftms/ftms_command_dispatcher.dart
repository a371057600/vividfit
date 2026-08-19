import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ftms_data_sync_guard.dart';
import 'ftms_service_base.dart';

/// FTMS 控制指令数据结构。
///
/// 由 [opCode] 与参数 [data] 组成,[toBytes] 输出可直接写入
/// Control Point(0x2AD9)的字节序列: OpCode + 参数。
class FtmsCommand {
  /// FTMS OpCode(如 0x00 Request Control、0x07 Start or Resume)。
  final int opCode;

  /// 指令参数(不含 OpCode)。
  final List<int> data;

  FtmsCommand(this.opCode, this.data);

  /// 拼接为完整写入字节: [opCode] + [data]。
  Uint8List toBytes() => Uint8List.fromList([opCode, ...data]);
}

/// 指令来源枚举（用于优先级仲裁）。
///
/// - [user]: 用户手动操作（按钮点击/长按），优先级最高，立即执行
/// - [course]: 课程自动下发（动作阶段切换参数），可被用户指令覆盖
enum CommandSource {
  user,
  course,
}

/// 指令下发失败类型（供上层区分提示策略）。
///
/// - [serviceUnavailable]: FTMS 服务实例不可用（蓝牙未连接 / provider 未就绪），
///   连接建立期常见，上层应静默（有就绪等待/重试兜底），不弹 Toast。
/// - [serviceNotReady]: 服务实例已存在但特征值未发现完毕（isReady=false），
///   同样属连接建立期正常现象，上层应静默。
/// - [writeError]: 写入特征值抛出真实异常（如 GATT 错误、`primary service not found`），
///   上层需提示用户重启蓝牙或重连。
enum FtmsCommandFailure {
  serviceUnavailable,
  serviceNotReady,
  writeError,
}

/// FTMS 蓝牙指令统一调度器。
///
/// 提供三种下发模式:
/// - [dispatch]: debounce 模式,500ms 内仅保留最后一条指令,
///   适合连续调节场景(如长按调速/调坡度)。
/// - [dispatchImmediate]: 即时模式,立即下发,
///   适合离散动作(如开始/暂停/停止)。
/// - [dispatchTracked]: 跟踪模式,超时未确认自动重发,保证最终值必达。
///
/// 另提供 [dispatchWithPriority] 优先级仲裁:
/// 用户指令立即执行并丢弃 pending 中的课程指令;
/// 课程指令走 debounce,可被任何后发指令覆盖。
///
/// 下发成功后通过 [syncGuard] 开启保护窗口,
/// 防止设备 0x2ADA 回调覆盖本地刚写入的值。
class FtmsCommandDispatcher {
  FtmsCommandDispatcher({
    required this._serviceGetter,
    this.syncGuard,
    this.onCommandFailed,
    this.onRetryExhausted,
  });

  /// FTMS 服务实例 getter(不缓存引用)。
  ///
  /// 每次执行指令时动态调用,确保获取最新的 FtmsService 实例。
  /// 避免断开重连后 dispatcher 持有旧实例的失效特征值引用。
  final FtmsServiceBase? Function() _serviceGetter;

  /// 数据同步保护器(可选),下发成功后开启保护窗口。
  final FtmsDataSyncGuard? syncGuard;

  /// 指令下发失败回调(可选)。
  ///
  /// 触发时机(按 [FtmsCommandFailure] 分类):
  /// - [FtmsCommandFailure.serviceUnavailable]: 服务实例不可用(provider 未就绪)
  /// - [FtmsCommandFailure.serviceNotReady]: 服务未就绪(isReady=false)
  /// - [FtmsCommandFailure.writeError]: 写入特征值异常(如 `primary service not found '1826'`)
  ///
  /// 供上层(Notifier)按类型决定是否提示用户。
  final void Function(FtmsCommandFailure type, String error)? onCommandFailed;

  /// 指令重发耗尽回调(可选)。
  ///
  /// 触发时机:dispatchTracked 下发的指令在达到最大重试次数后仍未确认。
  /// 参数为该指令的 OpCode,供上层提示用户。
  final void Function(int opCode)? onRetryExhausted;

  /// debounce 计时器。
  Timer? _debounceTimer;

  /// debounce 期间暂存的待发送指令。
  FtmsCommand? _pendingCommand;

  /// 跟踪中的指令任务表(按 OpCode 索引)。
  ///
  /// 同 OpCode 新指令进入时重置旧任务,以新指令重新计数。
  final Map<int, _RetryTask> _trackedTasks = {};

  /// debounce 延迟时长。
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  /// 保护窗口时长。
  static const Duration _guardWindowDuration = Duration(milliseconds: 1500);

  /// 参数指令(速度/坡度/阻力)确认超时(覆盖电机物理调整 + 匹配窗口)。
  static const Duration paramAckTimeout = Duration(seconds: 4);

  /// 开始/停止等二值指令确认超时。
  static const Duration binaryAckTimeout = Duration(seconds: 3);

  /// debounce 模式下发指令。
  ///
  /// 500ms 内若有新指令进入,取消上一条并替换为最新指令,
  /// 仅最后一条会被实际下发。适合连续调节场景。
  void dispatch(FtmsCommand command) {
    _debounceTimer?.cancel();
    _pendingCommand = command;
    debugPrint(
      '[Dispatcher] dispatch(debounce): ${_formatCommand(command)}, '
      'pending (${_debounceDelay.inMilliseconds}ms)',
    );
    _debounceTimer = Timer(_debounceDelay, _execute);
  }

  /// 即时模式下发指令。
  ///
  /// 立即执行,不经过 debounce。适合离散动作(如开始/暂停/停止)。
  void dispatchImmediate(FtmsCommand command) {
    debugPrint('[Dispatcher] dispatchImmediate: ${_formatCommand(command)}');
    _executeCommand(command);
  }

  /// 带来源优先级仲裁的下发（课程 vs 用户指令冲突核心）。
  ///
  /// 优先级规则：
  /// 1. **用户指令**（[CommandSource.user]）：
  ///    - 立即丢弃 debounce 中 pending 的课程指令（`cancelPending`）
  ///    - 立即执行（不走 debounce 等待）
  ///    - 带跟踪重发（4s 超时确认，最多 3 次），保证用户操作必达
  /// 2. **课程指令**（[CommandSource.course]）：
  ///    - 走 debounce 模式，500ms 内被任何新指令（用户/课程）覆盖
  ///
  /// 典型时序：课程发 0.6 → 用户发 2.0（立即执行 2.0，丢弃 0.6）
  /// → 课程切阶段发 1.0（500ms 后执行 1.0）✅ 以后发为准。
  void dispatchWithPriority(
    FtmsCommand command, {
    required CommandSource source,
  }) {
    switch (source) {
      case CommandSource.user:
        debugPrint(
          '[Dispatcher] 🎯 user command (priority): '
          '${_formatCommand(command)} → 丢弃pending + 立即跟踪下发',
        );
        cancelPending();
        dispatchTracked(command);
      case CommandSource.course:
        debugPrint(
          '[Dispatcher] 📖 course command: '
          '${_formatCommand(command)} → debounce 模式（可被覆盖）',
        );
        dispatch(command);
    }
  }

  /// 取消 debounce 中尚未发送的指令。
  void cancelPending() {
    final discarded = _pendingCommand;
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _pendingCommand = null;
    if (discarded != null) {
      debugPrint(
        '[Dispatcher] cancelPending: discarded opCode=${_formatOpCode(discarded.opCode)}',
      );
    } else {
      debugPrint('[Dispatcher] cancelPending');
    }
  }

  /// 带跟踪下发指令:超时未确认自动重发,最多 [maxRetries] 次。
  ///
  /// 与 [dispatch]/[dispatchImmediate] 的区别:
  /// - 记录指令并启动确认超时计时器
  /// - 同 OpCode 新指令进入时取消旧跟踪,以新指令重新计数
  /// - 确认来源:上层收到设备回执/数据匹配后调用 [confirmReceipt]
  /// - 重试耗尽触发 [onRetryExhausted],按钮值保持用户输入不回滚
  void dispatchTracked(FtmsCommand command,
      {Duration? timeout, int maxRetries = 3}) {
    final effectiveTimeout = timeout ?? paramAckTimeout;
    // 取消同 OpCode 旧跟踪任务
    _removeTask(command.opCode);
    final task = _RetryTask(command: command, timeout: effectiveTimeout);
    _trackedTasks[command.opCode] = task;
    debugPrint(
      '[Dispatcher] dispatchTracked: ${_formatCommand(command)}, '
      'timeout=${effectiveTimeout.inSeconds}s, maxRetries=$maxRetries',
    );
    _executeCommand(command);
    _startAckTimer(task, maxRetries);
  }

  /// 确认指令已被设备接受(收到成功回执或数据匹配)。
  ///
  /// 取消该 OpCode 的超时计时器并移除跟踪任务。
  void confirmReceipt(int opCode) {
    final task = _trackedTasks.remove(opCode);
    if (task == null) return;
    task.confirmed = true;
    task.timer?.cancel();
    debugPrint(
      '[Dispatcher] ✅ receipt confirmed: opCode=${_formatOpCode(opCode)}'
      '（第 ${task.sentCount} 次发送后确认）',
    );
  }

  /// 主动放弃跟踪(如停止运动、页面退出场景)。
  void cancelTracking(int opCode) {
    final task = _trackedTasks.remove(opCode);
    if (task == null) return;
    task.timer?.cancel();
    debugPrint('[Dispatcher] cancelTracking: opCode=${_formatOpCode(opCode)}');
  }

  /// 释放资源,取消所有待发送指令。
  void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _pendingCommand = null;
    // 取消所有跟踪任务的超时计时器,防止 dispose 后仍触发重发
    for (final task in _trackedTasks.values) {
      task.timer?.cancel();
    }
    _trackedTasks.clear();
    debugPrint('[Dispatcher] dispose');
  }

  // ---- 内部方法 ----

  /// debounce 触发后,执行暂存的指令。
  void _execute() {
    final command = _pendingCommand;
    _debounceTimer = null;
    _pendingCommand = null;
    if (command == null) return;
    _executeCommand(command);
  }

  /// 实际下发指令,成功后开启保护窗口。
  Future<void> _executeCommand(FtmsCommand command) async {
    // 每次执行时动态获取最新 FtmsService 实例(不缓存引用)
    final ftmsService = _serviceGetter();

    // 前置就绪检查:服务未发现 / 未就绪 / 已 dispose 时跳过,避免底层 PlatformException
    if (ftmsService == null) {
      debugPrint(
        '[Dispatcher] ⚠️ ftmsService is null (provider not ready), skip: '
        '${_formatCommand(command)}',
      );
      onCommandFailed?.call(FtmsCommandFailure.serviceUnavailable, 'ftmsService is null');
      return;
    }
    if (!ftmsService.isReady) {
      debugPrint(
        '[Dispatcher] ⚠️ ftmsService not ready (isReady=false), skip: '
        '${_formatCommand(command)}',
      );
      onCommandFailed?.call(FtmsCommandFailure.serviceNotReady, 'ftmsService not ready');
      return;
    }
    debugPrint('[Dispatcher] ✅ executing: ${_formatCommand(command)}');
    try {
      await ftmsService.writeControlPoint(command.toBytes());
      syncGuard?.beginGuardWindow(_guardWindowDuration);
      debugPrint(
        '[Dispatcher] guard window started (${_guardWindowDuration.inMilliseconds}ms)',
      );
    } catch (e) {
      debugPrint('[Dispatcher] ❌ execute error: $e');
      onCommandFailed?.call(FtmsCommandFailure.writeError, e.toString());
    }
  }

  /// 启动(或重启)确认超时计时器。
  void _startAckTimer(_RetryTask task, int maxRetries) {
    task.timer?.cancel();
    task.timer = Timer(task.timeout, () => _onAckTimeout(task, maxRetries));
  }

  /// 确认超时处理:未达上限则重发,耗尽则通知上层。
  void _onAckTimeout(_RetryTask task, int maxRetries) {
    // 已确认或任务已被替换/移除(如同 OpCode 新指令重置跟踪)则直接返回
    if (task.confirmed || _trackedTasks[task.command.opCode] != task) return;
    if (task.sentCount >= maxRetries) {
      debugPrint(
        '[Dispatcher] ❌ retry exhausted: '
        'opCode=${_formatOpCode(task.command.opCode)}, '
        'sent=${task.sentCount}/$maxRetries → 通知上层',
      );
      _removeTask(task.command.opCode, silent: true);
      onRetryExhausted?.call(task.command.opCode);
      return;
    }
    task.sentCount++;
    debugPrint(
      '[Dispatcher] ⏰ ack timeout, retry: ${task.sentCount}/$maxRetries, '
      'opCode=${_formatOpCode(task.command.opCode)}',
    );
    _executeCommand(task.command);
    _startAckTimer(task, maxRetries);
  }

  /// 移除跟踪任务并取消其计时器。
  void _removeTask(int opCode, {bool silent = false}) {
    final task = _trackedTasks.remove(opCode);
    task?.timer?.cancel();
    if (!silent && task != null) {
      debugPrint('[Dispatcher] tracking removed: opCode=${_formatOpCode(opCode)}');
    }
  }

  /// 格式化 OpCode 为 0x 形式(如 0x04)。
  String _formatOpCode(int opCode) =>
      '0x${opCode.toRadixString(16).padLeft(2, '0')}';

  /// 格式化指令日志。
  ///
  /// 输出形如 `opCode=0x04, value=10`;若 [FtmsCommand.data] 为空则仅输出 `opCode=0x00`。
  String _formatCommand(FtmsCommand command) {
    final opCodeStr = 'opCode=${_formatOpCode(command.opCode)}';
    if (command.data.isEmpty) {
      return opCodeStr;
    }
    return '$opCodeStr, value=${command.data.first}';
  }
}

/// 指令跟踪任务:超时未确认则重发,重试次数耗尽触发回调。
class _RetryTask {
  _RetryTask({required this.command, required this.timeout});

  /// 被跟踪的指令。
  final FtmsCommand command;

  /// 确认超时时长。
  final Duration timeout;

  /// 已发送次数(含首次)。
  int sentCount = 1;

  /// 确认超时计时器。
  Timer? timer;

  /// 是否已收到设备确认。
  bool confirmed = false;
}
