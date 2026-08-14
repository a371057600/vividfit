import '../../../core/ftms/ftms_device_type.dart';
import '../notifiers/distance_unit_notifier.dart';

/// 设备字段可见性与单位转换工具。
///
/// 根据设备类型统一判定运动数据各字段是否需要展示，
/// 并提供速度/距离单位换算：
/// - 速度：划船机 m/s → km/h（其余设备原始值已为 km/h）
/// - 距离：所有设备原始值为**米**，统一 m → km（默认）或 m → mile（英制）
///
/// UI 层应通过本类查询可见性，避免在多个 Widget 中重复硬编码判断。
class DeviceFieldVisibility {
  /// 当前设备类型。
  final FtmsDeviceType deviceType;

  /// 构造函数。
  const DeviceFieldVisibility(this.deviceType);

  /// 是否显示速度（所有设备均显示；划船机在调用侧通过不传 speed 字段控制隐藏）。
  bool get shouldShowSpeed => true;

  /// 是否显示踏频（单车、椭圆机）。
  bool get shouldShowCadence => deviceType.supportsCadenceDisplay;

  /// 是否显示阻力（除跑步机外均显示）。
  bool get shouldShowResistance => deviceType.supportsResistanceControl;

  /// 是否显示坡度（跑步机、椭圆机）。
  bool get shouldShowInclination => deviceType.supportsInclinationControl;

  /// 是否显示桨频（划船机）。
  bool get shouldShowStrokeRate => deviceType.supportsStrokeDisplay;

  /// 是否显示桨数（划船机）。
  bool get shouldShowStrokeCount => deviceType.supportsStrokeDisplay;

  /// 是否显示功率（单车、椭圆机、划船机）。
  bool get shouldShowPower => deviceType.supportsPowerDisplay;

  /// 是否显示心率（所有设备均显示）。
  bool get shouldShowHeartRate => true;

  /// 是否显示距离（所有设备均显示）。
  bool get shouldShowDistance => true;

  /// 是否显示能量/卡路里（所有设备均显示）。
  bool get shouldShowEnergy => true;

  /// 速度单位转换：划船机 m/s → km/h。
  ///
  /// 其余设备原始值已为 km/h，直接返回。
  double convertSpeed(double rawSpeed) {
    if (deviceType.needsSpeedConversion) return rawSpeed * 3.6;
    return rawSpeed;
  }

  /// 距离单位转换：原始值（米）→ km（默认）或 mile（英制）。
  ///
  /// **修复说明**：旧实现仅对划船机做 m→km，其余设备直接返回米数却显示单位「km」，
  /// 导致单车/跑步机/椭圆机距离数值偏大 1000 倍。
  /// 现统一为：所有设备原始距离均为米，按 [unit] 转换为 km 或 mile。
  double convertDistance(
    double rawMeters, {
    DistanceUnit unit = DistanceUnit.km,
  }) {
    final kmValue = rawMeters / 1000.0;
    if (unit == DistanceUnit.mile) return kmValue * 0.621371;
    return kmValue;
  }
}
