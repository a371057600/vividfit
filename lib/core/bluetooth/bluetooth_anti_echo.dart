/// 蓝牙防误火模块(0x2ADA 反向指令抑制)。
///
/// 封装旧项目 `controller_new_four_big_device_sprot.dart` 中分散的防回环逻辑:
/// - 手动指令计数器 `_manualCommandCount`
/// - 三通道时间戳(速度/坡度/阻力)
/// - 1000ms 窗口判断:若距上次 0x2ADA 回调 < 1000ms 且有手动指令,跳过发送
/// - `_isResettingDevice` 标志:重置过程中阻止 debounce
///
/// **协议背景**:
/// 0x2ADA 是设备主动通知 App 同步状态(如用户在设备面板改变速度/坡度/阻力)。
/// App 收到后只更新 UI,不应反向发送指令打断设备操作。
/// 此模块判断变量变化是由设备端(0x2ADA)还是 App 端(手动)触发,避免指令回环。
class BluetoothAntiEcho {
  /// 手动指令计数器 - 记录队列中手动指令的数量。
  int _manualCommandCount = 0;

  /// 设备重置中标志,防止 sendResetToDevice 触发 debounce 重复发指令。
  bool _isResettingDevice = false;

  // 0x2ADA 回调更新时间(分别记录每种类型)
  DateTime? _lastSpeedCallbackTime;
  DateTime? _lastInclinationCallbackTime;
  DateTime? _lastResistanceCallbackTime;

  /// 抑制窗口(毫秒)。距上次 0x2ADA 回调在此窗口内,跳过手动指令。
  static const int _suppressWindowMs = 1000;

  /// 进入设备重置模式。
  ///
  /// 对应旧 `sendResetToDevice` 中 `_isResettingDevice = true`。
  void enterResetMode() {
    _isResettingDevice = true;
    print('[AntiEcho] entered reset mode');
  }

  /// 退出设备重置模式。
  void exitResetMode() {
    _isResettingDevice = false;
    print('[AntiEcho] exited reset mode');
  }

  /// 是否正在重置设备。
  bool get isResetting => _isResettingDevice;

  /// 记录一次手动指令入队。
  void recordManualCommand() {
    _manualCommandCount++;
    print('[AntiEcho] manual command recorded, count=$_manualCommandCount');
  }

  /// 记录一次手动指令已发送(归零计数器)。
  void markManualCommandSent() {
    _manualCommandCount = 0;
  }

  /// 记录 0x2ADA 速度回调。
  void recordSpeedCallback() {
    _lastSpeedCallbackTime = DateTime.now();
    print('[AntiEcho] speed callback recorded');
  }

  /// 记录 0x2ADA 坡度回调。
  void recordInclinationCallback() {
    _lastInclinationCallbackTime = DateTime.now();
    print('[AntiEcho] inclination callback recorded');
  }

  /// 记录 0x2ADA 阻力回调。
  void recordResistanceCallback() {
    _lastResistanceCallbackTime = DateTime.now();
    print('[AntiEcho] resistance callback recorded');
  }

  /// 判断是否应抑制速度手动指令。
  ///
  /// 返回 `true` 表示应跳过发送(防回环)。
  bool shouldSuppressSpeed() {
    if (_isResettingDevice) {
      print('[AntiEcho] suppress speed: resetting');
      return true;
    }
    if (_manualCommandCount > 0 && _lastSpeedCallbackTime != null) {
      final elapsed = DateTime.now().difference(_lastSpeedCallbackTime!).inMilliseconds;
      if (elapsed < _suppressWindowMs) {
        print('[AntiEcho] suppress speed: callback ${elapsed}ms ago');
        return true;
      }
    }
    return false;
  }

  /// 判断是否应抑制坡度手动指令。
  bool shouldSuppressInclination() {
    if (_isResettingDevice) {
      print('[AntiEcho] suppress inclination: resetting');
      return true;
    }
    if (_manualCommandCount > 0 && _lastInclinationCallbackTime != null) {
      final elapsed = DateTime.now().difference(_lastInclinationCallbackTime!).inMilliseconds;
      if (elapsed < _suppressWindowMs) {
        print('[AntiEcho] suppress inclination: callback ${elapsed}ms ago');
        return true;
      }
    }
    return false;
  }

  /// 判断是否应抑制阻力手动指令。
  bool shouldSuppressResistance() {
    if (_isResettingDevice) {
      print('[AntiEcho] suppress resistance: resetting');
      return true;
    }
    if (_manualCommandCount > 0 && _lastResistanceCallbackTime != null) {
      final elapsed = DateTime.now().difference(_lastResistanceCallbackTime!).inMilliseconds;
      if (elapsed < _suppressWindowMs) {
        print('[AntiEcho] suppress resistance: callback ${elapsed}ms ago');
        return true;
      }
    }
    return false;
  }

  /// 重置所有状态(断开连接时调用)。
  void reset() {
    _manualCommandCount = 0;
    _isResettingDevice = false;
    _lastSpeedCallbackTime = null;
    _lastInclinationCallbackTime = null;
    _lastResistanceCallbackTime = null;
    print('[AntiEcho] all state reset');
  }
}
