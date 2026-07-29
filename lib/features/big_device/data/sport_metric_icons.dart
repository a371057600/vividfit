/// 运动数据图标路径配置（提取自旧 `ControllerNewFourBigDeviceSprot.mainIconImageList`）。
///
/// 索引说明（与旧 mainIconImageList 完全一致）:
/// - [0] 时间 mian_min.png
/// - [1] 距离 mian_km.png
/// - [2] 卡路里 main_kcal.png
/// - [3] 速度 main_kmh.png
/// - [4] 桨次数 main_rowing_time.png
/// - [5] 心率 main_heart_rate.png
/// - [6] 桨频 icon_stroke_count.png
/// - [7] 踏频 over_total_step.png
class SportMetricIcons {
  SportMetricIcons._();

  static const String time = 'images/newUIScreen/bigScreenAnimation/icons/mian_min.png';
  static const String distance = 'images/newUIScreen/bigScreenAnimation/icons/mian_km.png';
  static const String calories = 'images/newUIScreen/bigScreenAnimation/icons/main_kcal.png';
  static const String speed = 'images/newUIScreen/bigScreenAnimation/icons/main_kmh.png';
  static const String strokeCount = 'images/newUIScreen/bigScreenAnimation/icons/main_rowing_time.png';
  static const String heartRate = 'images/newUIScreen/bigScreenAnimation/icons/main_heart_rate.png';
  static const String strokeRate = 'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/icon_stroke_count.png';
  static const String cadence = 'images/newUIScreen/bigScreenAnimation/bigDevicePlayCourseIcon/over_total_step.png';

  /// 按旧索引获取图标路径（兼容旧 mainIconImageList[0-7]）。
  static String byIndex(int index) {
    return switch (index) {
      0 => time,
      1 => distance,
      2 => calories,
      3 => speed,
      4 => strokeCount,
      5 => heartRate,
      6 => strokeRate,
      7 => cadence,
      _ => time,
    };
  }
}
