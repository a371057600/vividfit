import 'package:flutter/foundation.dart';

/// 设备时间归一化器。
///
/// 用于补偿设备 60 秒循环归零问题，将设备原始 elapsedTime
/// 归一化为持续递增值，避免 UI 出现时间回跳。
class DeviceTimeNormalizer {
  /// 上次设备原始值，null 表示尚未接收到数据。
  int? _lastRawElapsed;

  /// 已补偿圈数（每归零一次 +1）。
  int _cycleCount = 0;

  /// 将设备原始 elapsedTime 归一化为持续递增值。
  ///
  /// 算法逻辑：
  /// 1. 若检测到 rawElapsed 小于上次值，视为设备 60 秒循环归零，圈数 +1；
  /// 2. 若检测到 rawElapsed 大幅倒退（>30 且 raw>50），视为设备面板重置，圈数清零；
  /// 3. 更新上次值并返回 [cycleCount * 60 + rawElapsed]。
  int normalize(int rawElapsed) {
    final lastRaw = _lastRawElapsed;

    if (lastRaw != null) {
      if (rawElapsed < lastRaw) {
        // 检测到归零：设备 60 秒循环导致时间回跳
        _cycleCount++;
        debugPrint(
          '[TimeNormalizer] 检测到归零: $lastRaw → $rawElapsed, 累计圈数=$_cycleCount',
        );
      } else if (rawElapsed > lastRaw + 30 && rawElapsed > 50) {
        // 检测到设备重置：圈数清零
        _cycleCount = 0;
        debugPrint('[TimeNormalizer] 检测到设备重置, 归零圈数');
      }
    }

    _lastRawElapsed = rawElapsed;
    final result = _cycleCount * 60 + rawElapsed;
    debugPrint(
      '[TimeNormalizer] normalize: raw=$rawElapsed, cycle=$_cycleCount, result=$result',
    );
    return result;
  }

  /// 重置状态（设备面板重置时调用）。
  void reset() {
    _lastRawElapsed = null;
    _cycleCount = 0;
  }
}
