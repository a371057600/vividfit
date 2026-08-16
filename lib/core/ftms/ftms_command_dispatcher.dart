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

/// FTMS 蓝牙指令统一调度器。
///
/// 提供两种下发模式:
/// - [dispatch]: debounce 模式,500ms 内仅保留最后一条指令,
///   适合连续调节场景(如长按调速/调坡度)。
/// - [dispatchImmediate]: 即时模式,立即下发,
///   适合离散动作(如开始/暂停/停止)。
///
/// 下发成功后通过 [syncGuard] 开启保护窗口,
/// 防止设备 0x2ADA 回调覆盖本地刚写入的值。
class FtmsCommandDispatcher {
  FtmsCommandDispatcher({
    required this._serviceGetter,
    this.syncGuard,
    this.onCommandFailed,
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
  /// 触发时机:
  /// - 服务未就绪(isReady=false)时跳过写入
  /// - 写入过程抛出异常(如 `primary service not found '1826'`)
  ///
  /// 供上层(Notifier)提示用户重启蓝牙或重新连接设备。
  final void Function(String error)? onCommandFailed;

  /// debounce 计时器。
  Timer? _debounceTimer;

  /// debounce 期间暂存的待发送指令。
  FtmsCommand? _pendingCommand;

  /// debounce 延迟时长。
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  /// 保护窗口时长。
  static const Duration _guardWindowDuration = Duration(milliseconds: 1500);

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

  /// 释放资源,取消所有待发送指令。
  void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _pendingCommand = null;
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
      onCommandFailed?.call('ftmsService is null');
      return;
    }
    if (!ftmsService.isReady) {
      debugPrint(
        '[Dispatcher] ⚠️ ftmsService not ready (isReady=false), skip: '
        '${_formatCommand(command)}',
      );
      onCommandFailed?.call('ftmsService not ready');
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
      onCommandFailed?.call(e.toString());
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
