import 'package:flutter/foundation.dart';

/// 设备控制回调集合。
///
/// 封装用户在运动控制面板上可能触发的全部交互回调，
/// 包括速度/坡度/阻力的加减、长按加减、档位预设点击以及长按结束事件。
/// 所有回调均为可选，Widget 按设备能力选择性注入。
class DeviceControlCallbacks {
  // ==================== 速度相关 ====================
  /// 速度加。
  final VoidCallback? onSpeedAdd;

  /// 速度减。
  final VoidCallback? onSpeedDown;

  /// 速度长按加。
  final VoidCallback? onSpeedLongPressAdd;

  /// 速度长按减。
  final VoidCallback? onSpeedLongPressDown;

  /// 速度档位预设点击（参数为预设值）。
  final void Function(double)? onSpeedPreset;

  // ==================== 坡度相关 ====================
  /// 坡度加。
  final VoidCallback? onInclineAdd;

  /// 坡度减。
  final VoidCallback? onInclineDown;

  /// 坡度长按加。
  final VoidCallback? onInclineLongPressAdd;

  /// 坡度长按减。
  final VoidCallback? onInclineLongPressDown;

  /// 坡度档位预设点击（参数为预设值）。
  final void Function(double)? onInclinePreset;

  // ==================== 阻力相关 ====================
  /// 阻力加。
  final VoidCallback? onResistanceAdd;

  /// 阻力减。
  final VoidCallback? onResistanceDown;

  /// 阻力长按加。
  final VoidCallback? onResistanceLongPressAdd;

  /// 阻力长按减。
  final VoidCallback? onResistanceLongPressDown;

  /// 阻力档位预设点击（参数为预设值）。
  final void Function(double)? onResistancePreset;

  // ==================== 通用 ====================
  /// 长按结束（速度/坡度/阻力任意一项长按结束时触发）。
  final VoidCallback? onLongPressEnd;

  /// 构造函数。
  const DeviceControlCallbacks({
    // 速度
    this.onSpeedAdd,
    this.onSpeedDown,
    this.onSpeedLongPressAdd,
    this.onSpeedLongPressDown,
    this.onSpeedPreset,
    // 坡度
    this.onInclineAdd,
    this.onInclineDown,
    this.onInclineLongPressAdd,
    this.onInclineLongPressDown,
    this.onInclinePreset,
    // 阻力
    this.onResistanceAdd,
    this.onResistanceDown,
    this.onResistanceLongPressAdd,
    this.onResistanceLongPressDown,
    this.onResistancePreset,
    // 通用
    this.onLongPressEnd,
  });
}
