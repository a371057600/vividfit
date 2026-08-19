import 'ftms_device_type.dart';

/// 配置来源枚举。
///
/// - [defaults]: 默认回退配置（设备能力未上报时使用）
/// - [fromDevice]: 从设备能力特征（0x2AD4/0x2AD5/0x2AD6）读取的动态配置
enum ConfigSource {
  defaults,
  fromDevice,
}

/// 单维度控制配置（全部参数动态化）。
///
/// 描述速度/坡度/阻力某一维度的：
/// - 边界范围（[min] / [max]）
/// - 步进值（[singleStep] 单次点击 / [longPressStep] 长按连续触发）
/// - 功能支持标记（[supported]，如单车不支持坡度）
class ControlConfig {
  /// 最小值（动态化，设备上报优先）
  final double min;

  /// 最大值（动态化，设备上报优先）
  final double max;

  /// 单次点击步进值（动态化）
  final double singleStep;

  /// 长按连续触发步进值（动态化，通常为单次步进的一半）
  final double longPressStep;

  /// 该维度是否受设备支持
  final bool supported;

  const ControlConfig({
    required this.min,
    required this.max,
    required this.singleStep,
    required this.longPressStep,
    this.supported = true,
  });

  /// 不支持该维度时的占位配置。
  const ControlConfig.unsupported()
      : min = 0,
        max = 0,
        singleStep = 0,
        longPressStep = 0,
        supported = false;

  /// 从设备上报的能力范围构建配置。
  ///
  /// 规则（与现有交互保持一致）：
  /// - 单次点击步进 = 设备步进 [step]
  /// - 长按步进 = 设备步进 / 2（长按更细腻）
  factory ControlConfig.fromDeviceCapabilities({
    required double min,
    required double max,
    required double step,
  }) {
    // 防御：步进非法时回退 0.5，避免按钮卡死
    final safeStep = step > 0 ? step : 0.5;
    return ControlConfig(
      min: min,
      max: max,
      singleStep: safeStep,
      longPressStep: (safeStep / 2 * 10).round() / 10,
      supported: max > min,
    );
  }
}

/// 设备控制配置（三维度 + 配置来源）。
///
/// 由 [FtmsDeviceCapabilityReader] 从设备读取生成，
/// 读取失败时回退到各设备类型的默认常量配置。
class FtmsControlConfig {
  /// 速度配置
  final ControlConfig speed;

  /// 坡度配置
  final ControlConfig inclination;

  /// 阻力配置
  final ControlConfig resistance;

  /// 配置来源
  final ConfigSource source;

  const FtmsControlConfig({
    required this.speed,
    required this.inclination,
    required this.resistance,
    this.source = ConfigSource.defaults,
  });
}

// ==================== 各设备类型默认回退配置 ====================
// 数值与课程播放页原硬编码一致，保证设备未上报能力时交互不变。

/// 跑步机默认配置
const FtmsControlConfig kTreadmillDefaultConfig = FtmsControlConfig(
  speed: ControlConfig(min: 0.0, max: 50.0, singleStep: 0.5, longPressStep: 0.2),
  inclination: ControlConfig(
    min: -5.0,
    max: 15.0,
    singleStep: 1.0,
    longPressStep: 0.5,
  ),
  resistance: ControlConfig(
    min: 1.0,
    max: 20.0,
    singleStep: 1.0,
    longPressStep: 0.5,
  ),
);

/// 单车默认配置（不支持坡度）
const FtmsControlConfig kBikeDefaultConfig = FtmsControlConfig(
  speed: ControlConfig(min: 0.0, max: 50.0, singleStep: 0.5, longPressStep: 0.2),
  inclination: ControlConfig.unsupported(),
  resistance: ControlConfig(
    min: 1.0,
    max: 20.0,
    singleStep: 1.0,
    longPressStep: 0.5,
  ),
);

/// 椭圆机/划船机/力量站默认配置（不支持坡度）
const FtmsControlConfig kTrainerDefaultConfig = FtmsControlConfig(
  speed: ControlConfig(min: 0.0, max: 50.0, singleStep: 0.5, longPressStep: 0.2),
  inclination: ControlConfig.unsupported(),
  resistance: ControlConfig(
    min: 1.0,
    max: 20.0,
    singleStep: 1.0,
    longPressStep: 0.5,
  ),
);

/// 按设备类型获取默认回退配置。
FtmsControlConfig defaultConfigFor(FtmsDeviceType type) {
  switch (type) {
    case FtmsDeviceType.treadmill:
      return kTreadmillDefaultConfig;
    case FtmsDeviceType.indoorBike:
      return kBikeDefaultConfig;
    case FtmsDeviceType.crossTrainer:
    case FtmsDeviceType.rower:
    case FtmsDeviceType.strengthStation:
      return kTrainerDefaultConfig;
  }
}
