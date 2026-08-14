/// 设备控制数据。
///
/// 封装运动控制按钮与数据展示所需的输入参数，
/// 包括当前速度/坡度/阻力值、各档位预设列表以及设备能力上限/下限/步进。
/// 该类为纯数据载体，不持有任何业务逻辑，便于在 Widget 之间传递与复用。
class DeviceControlData {
  /// 当前速度值。
  final double speedValue;

  /// 当前坡度值。
  final double inclineValue;

  /// 当前阻力值。
  final double resistanceValue;

  /// 速度档位预设列表（用于档位快速切换按钮）。
  final List<double> speedPresets;

  /// 坡度档位预设列表。
  final List<double> inclinePresets;

  /// 阻力档位预设列表。
  final List<double> resistancePresets;

  /// 设备是否支持坡度（用于控制坡度相关 UI 是否展示）。
  final bool hasInclinationSupport;

  /// 阻力是否正在等待设备回执（true 时中心值显示「获取中」）。
  final bool resistanceLoading;

  /// 速度上限。
  final int? maxSpeed;

  /// 速度下限。
  final int? minSpeed;

  /// 速度步进。
  final int? speedStep;

  /// 阻力上限。
  final int? maxResistance;

  /// 阻力下限。
  final int? minResistance;

  /// 阻力步进。
  final int? resistanceStep;

  /// 坡度上限。
  final int? maxIncline;

  /// 坡度下限。
  final int? minIncline;

  /// 坡度步进。
  final int? inclineStep;

  /// 构造函数。
  const DeviceControlData({
    required this.speedValue,
    required this.inclineValue,
    required this.resistanceValue,
    required this.speedPresets,
    required this.inclinePresets,
    required this.resistancePresets,
    required this.hasInclinationSupport,
    this.resistanceLoading = false,
    this.maxSpeed,
    this.minSpeed,
    this.speedStep,
    this.maxResistance,
    this.minResistance,
    this.resistanceStep,
    this.maxIncline,
    this.minIncline,
    this.inclineStep,
  });

  /// 返回一份当前实例的拷贝，可选字段覆盖。
  DeviceControlData copyWith({
    double? speedValue,
    double? inclineValue,
    double? resistanceValue,
    List<double>? speedPresets,
    List<double>? inclinePresets,
    List<double>? resistancePresets,
    bool? hasInclinationSupport,
    bool? resistanceLoading,
    int? maxSpeed,
    int? minSpeed,
    int? speedStep,
    int? maxResistance,
    int? minResistance,
    int? resistanceStep,
    int? maxIncline,
    int? minIncline,
    int? inclineStep,
  }) {
    return DeviceControlData(
      speedValue: speedValue ?? this.speedValue,
      inclineValue: inclineValue ?? this.inclineValue,
      resistanceValue: resistanceValue ?? this.resistanceValue,
      speedPresets: speedPresets ?? this.speedPresets,
      inclinePresets: inclinePresets ?? this.inclinePresets,
      resistancePresets: resistancePresets ?? this.resistancePresets,
      hasInclinationSupport:
          hasInclinationSupport ?? this.hasInclinationSupport,
      resistanceLoading: resistanceLoading ?? this.resistanceLoading,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      minSpeed: minSpeed ?? this.minSpeed,
      speedStep: speedStep ?? this.speedStep,
      maxResistance: maxResistance ?? this.maxResistance,
      minResistance: minResistance ?? this.minResistance,
      resistanceStep: resistanceStep ?? this.resistanceStep,
      maxIncline: maxIncline ?? this.maxIncline,
      minIncline: minIncline ?? this.minIncline,
      inclineStep: inclineStep ?? this.inclineStep,
    );
  }
}
