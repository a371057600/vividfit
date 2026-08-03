import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../ftms/ftms_device_type.dart';
import '../../ftms/ftms_service_base.dart';
import '../../ftms/ftms_service_provider.dart';

part 'bluetooth_command_queue_provider.g.dart';

/// 蓝牙指令队列（按设备类型实例化）。
///
/// 封装 FtmsServiceBase 的控制指令为 FIFO 串行执行，
/// 避免快速连续点击导致的指令丢失或冲突。
class BluetoothCommandQueue {
  BluetoothCommandQueue(this._service);

  final FtmsServiceBase _service;
  final List<_QueuedCommand> _queue = [];
  bool _isProcessing = false;

  int get pendingCount => _queue.length;
  bool get isProcessing => _isProcessing;

  void enqueue(Future<void> Function() command) {
    _queue.add(_QueuedCommand(command));
    if (!_isProcessing) _processNext();
  }

  void clear() {
    _queue.clear();
  }

  void dispose() {
    clear();
    _isProcessing = false;
  }

  Future<void> _processNext() async {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;
    final cmd = _queue.removeAt(0);
    try {
      await cmd.execute().timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    } catch (_) {
      // 静默失败
    } finally {
      _isProcessing = false;
      if (_queue.isNotEmpty) _processNext();
    }
  }
}

class _QueuedCommand {
  _QueuedCommand(this._command);
  final Future<void> Function() _command;
  Future<void> execute() => _command();
}

@Riverpod(keepAlive: true)
BluetoothCommandQueue? bluetoothCommandQueue(Ref ref, int deviceCategoryIndex) {
  final type = FtmsDeviceType.fromValue(deviceCategoryIndex);
  final service = ref.watch(ftmsServiceProvider(type));
  if (service == null || !service.isReady) return null;
  final queue = BluetoothCommandQueue(service);
  ref.onDispose(queue.dispose);
  return queue;
}
