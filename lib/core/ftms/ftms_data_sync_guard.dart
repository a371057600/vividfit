import 'package:flutter/foundation.dart';

/// 蓝牙回调保护窗口管理器。
///
/// 用于防止 0x2ADA 回调在长按松手后覆盖本地按钮值。
/// 通过开启一个时间窗口，在该窗口内屏蔽设备回调对本地状态的写入。
class FtmsDataSyncGuard {
  /// 保护窗口结束时间，null 表示未开启。
  DateTime? _guardUntil;

  /// 开启保护窗口。
  ///
  /// 调用后 [isInGuardWindow] 在 [duration] 时间内会返回 true。
  void beginGuardWindow(Duration duration) {
    _guardUntil = DateTime.now().add(duration);
    debugPrint(
      '[Guard] window begin, duration=${duration.inMilliseconds}ms, expires at $_guardUntil',
    );
  }

  /// 查询当前是否在保护窗口内。
  ///
  /// 返回 true 表示处于保护期，应忽略设备回调的写入。
  bool isInGuardWindow() {
    if (_guardUntil != null && DateTime.now().isBefore(_guardUntil!)) {
      final remainingMs = _guardUntil!.difference(DateTime.now()).inMilliseconds;
      debugPrint(
        '[Guard] ✅ in guard window, remaining=${remainingMs}ms',
      );
      return true;
    }
    debugPrint('[Guard] ❌ guard window expired or not set');
    return false;
  }
}
