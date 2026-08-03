import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'bluetooth_characteristic_manager.dart';

/// 蓝牙指令队列。
///
/// FIFO 串行写入 + 5 秒超时,统一替代旧项目两个不一致的 `orderData` 实现:
/// - `controller_new_four_big_device_sprot.dart` 的 `_orderQueue`(有队列+超时)
/// - `controller_big_course_home.dart` 的 `orderData`(直接 write,无队列无超时)
///
/// **职责**:
/// - [enqueue] 入队
/// - 串行 [_processNext] 处理,调用 [CharacteristicManager.writeCommand]
/// - 5 秒超时自动跳过,继续下一条
/// - [clear] 清空队列
/// - [dispose] 释放资源
class BluetoothCommandQueue {
  BluetoothCommandQueue(this._characteristicManager);

  final BluetoothCharacteristicManager _characteristicManager;

  final List<Uint8List> _queue = [];
  bool _isProcessing = false;

  /// 队列中待处理指令数。
  int get pendingCount => _queue.length;

  /// 是否正在处理指令。
  bool get isProcessing => _isProcessing;

  /// 入队一条指令。
  ///
  /// 入队后自动触发 [_processNext](若未在处理中)。
  void enqueue(Uint8List data) {
    _queue.add(data);
    print('[CommandQueue] enqueued, pending=${_queue.length}');
    if (!_isProcessing) {
      _processNext();
    }
  }

  /// 清空队列(不断开当前正在执行的写入)。
  void clear() {
    final count = _queue.length;
    _queue.clear();
    print('[CommandQueue] cleared $count pending commands');
  }

  /// 释放资源(清空队列,不关闭 CharacteristicManager)。
  void dispose() {
    clear();
    _isProcessing = false;
    print('[CommandQueue] disposed');
  }

  /// 串行处理队列。
  Future<void> _processNext() async {
    if (_isProcessing) return;
    if (_queue.isEmpty) return;

    _isProcessing = true;
    final data = _queue.removeAt(0);

    try {
      print('[CommandQueue] writing ${data.length} bytes, pending=${_queue.length}');
      await _characteristicManager.writeCommand(data).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('[CommandQueue] write timeout, skipping command');
        },
      );
    } catch (e) {
      print('[CommandQueue] write failed: $e');
    } finally {
      _isProcessing = false;
      // 继续处理下一条
      if (_queue.isNotEmpty) {
        _processNext();
      }
    }
  }
}
