/// 大设备类型枚举(对应旧 `newMainSelectType` / `deviceTypeIndex`)。
///
/// 5 类设备完整保留:
/// - bike(0)         → 健身车
/// - treadmill(1)    → 跑步机
/// - elliptical(2)   → 椭圆机
/// - rower(3)        → 划船机
/// - strengthStation(4) → 力量站
enum DeviceCategory {
  bike,
  treadmill,
  elliptical,
  rower,
  strengthStation,
}

extension DeviceCategoryExtension on DeviceCategory {
  /// 枚举 → 整数索引(0-4)。
  int get index {
    return switch (this) {
      DeviceCategory.bike => 0,
      DeviceCategory.treadmill => 1,
      DeviceCategory.elliptical => 2,
      DeviceCategory.rower => 3,
      DeviceCategory.strengthStation => 4,
    };
  }

  /// 整数索引(0-4) → 枚举。
  static DeviceCategory fromIndex(int value) {
    return switch (value) {
      0 => DeviceCategory.bike,
      1 => DeviceCategory.treadmill,
      2 => DeviceCategory.elliptical,
      3 => DeviceCategory.rower,
      4 => DeviceCategory.strengthStation,
      _ => DeviceCategory.bike,
    };
  }

  /// 映射到旧 course 模块的设备类型选择值。
  /// (对应旧 `toCourseTypeSelect`)
  int toCourseTypeSelect() {
    return switch (this) {
      DeviceCategory.bike => 0,
      DeviceCategory.treadmill => 1,
      DeviceCategory.elliptical => 2,
      DeviceCategory.rower => 3,
      DeviceCategory.strengthStation => 4,
    };
  }
}
