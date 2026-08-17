import '../../../core/ftms/ftms_device_type.dart';

/// 设备字段可见性与单位转换工具。
///
/// 根据设备类型统一判定运动数据各字段是否需要展示，
/// 并提供划船机特有的速度/距离单位换算（m/s → km/h、m → km）。
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

  /// 距离单位转换：设备原始米 → km。
  ///
  /// FTMS 协议所有设备（跑步机/单车/椭圆机/划船机）的 Total Distance
  /// 均为 uint24、单位米；与旧项目统一 ÷1000 后以 km 展示。
  double convertDistance(double rawDistance) {
    return rawDistance / 1000.0;
  }
}
