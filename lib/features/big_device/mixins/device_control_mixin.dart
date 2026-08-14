/// 设备控制回调签名 mixin。
///
/// 定义速度 / 坡度 / 阻力三大维度的统一控制方法签名，
/// 供 [QuickStartNotifier] 和 [GymCoursePlayNotifier] 混入，
/// 确保两个 Notifier 对外暴露的设备控制接口保持一致。
///
/// 所有方法默认空实现，混入方按需 override 即可。
/// 对应原版 `cnfbd`（ControllerNewFourBigDeviceSprot）中的蓝牙控制方法。
mixin DeviceControlMixin {
  // ==================== 速度控制 ====================

  /// 速度加（对应旧 cnfbd.speedAdd）。
  void speedAdd() {}

  /// 速度减（对应旧 cnfbd.speedDown）。
  void speedDown() {}

  /// 速度长按加（对应旧 cnfbd.longPressSpeedAdd）。
  void speedLongPressAdd() {}

  /// 速度长按减（对应旧 cnfbd.longPressSpeedDown）。
  void speedLongPressDown() {}

  /// 速度档位预设点击（参数为预设值，对应旧 cnfbd.numberButton(value, 0)）。
  void speedPreset(double value) {}

  // ==================== 坡度控制 ====================

  /// 坡度加（对应旧 cnfbd.inclinationAdd）。
  void inclineAdd() {}

  /// 坡度减（对应旧 cnfbd.inclinationDown）。
  void inclineDown() {}

  /// 坡度长按加（对应旧 cnfbd.longPressInclinationAdd）。
  void inclineLongPressAdd() {}

  /// 坡度长按减（对应旧 cnfbd.longPressInclinationDown）。
  void inclineLongPressDown() {}

  /// 坡度档位预设点击（参数为预设值，对应旧 cnfbd.numberButton(value, 1)）。
  void inclinePreset(double value) {}

  // ==================== 阻力控制 ====================

  /// 阻力加（对应旧 cnfbd.resistanceAdd）。
  void resistanceAdd() {}

  /// 阻力减（对应旧 cnfbd.resistanceDown）。
  void resistanceDown() {}

  /// 阻力长按加（对应旧 cnfbd.longPressResistanceAdd）。
  void resistanceLongPressAdd() {}

  /// 阻力长按减（对应旧 cnfbd.longPressResistanceDown）。
  void resistanceLongPressDown() {}

  /// 阻力档位预设点击（参数为预设值，对应旧 cnfbd.numberButton(value, 2)）。
  void resistancePreset(double value) {}

  // ==================== 通用 ====================

  /// 长按结束（速度 / 坡度 / 阻力任意一项长按结束时触发，对应旧 cnfbd.longPressEnd）。
  void longPressEnd() {}
}
