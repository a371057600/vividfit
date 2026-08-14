/// 运动数据模型。
///
/// 封装一次运动实时上报的全部指标字段，
/// 包括速度、踏频、距离、能量、心率、功率、阻力等级、坡度、
/// 桨频、桨数以及已用/剩余时间。
/// 字段均为可空，由各设备解析器按能力填充；UI 层依据
/// [DeviceFieldVisibility] 判断是否展示对应字段。
class SportDataModel {
  /// 当前速度（单位由设备决定，划船机为 m/s，其余为 km/h）。
  final double? speed;

  /// 踏频（rpm）。
  final int? cadence;

  /// 累计距离（单位由设备决定，划船机为 m，其余为 km）。
  final double? distance;

  /// 累计能量（千卡）。
  final int? energy;

  /// 当前心率（bpm）。
  final int? heartRate;

  /// 当前功率（瓦特）。
  final int? power;

  /// 当前阻力等级。
  final int? resistanceLevel;

  /// 当前坡度（百分比或档位）。
  final double? inclination;

  /// 桨频（每分钟桨次数）。
  final int? strokeRate;

  /// 累计桨数。
  final int? strokeCount;

  /// 已运动时间（秒）。
  final int? elapsedSeconds;

  /// 剩余运动时间（秒，目标模式才有意义）。
  final int? remainingSeconds;

  /// 构造函数。
  const SportDataModel({
    this.speed,
    this.cadence,
    this.distance,
    this.energy,
    this.heartRate,
    this.power,
    this.resistanceLevel,
    this.inclination,
    this.strokeRate,
    this.strokeCount,
    this.elapsedSeconds,
    this.remainingSeconds,
  });

  /// 返回一份当前实例的拷贝，可选字段覆盖。
  SportDataModel copyWith({
    double? speed,
    int? cadence,
    double? distance,
    int? energy,
    int? heartRate,
    int? power,
    int? resistanceLevel,
    double? inclination,
    int? strokeRate,
    int? strokeCount,
    int? elapsedSeconds,
    int? remainingSeconds,
  }) {
    return SportDataModel(
      speed: speed ?? this.speed,
      cadence: cadence ?? this.cadence,
      distance: distance ?? this.distance,
      energy: energy ?? this.energy,
      heartRate: heartRate ?? this.heartRate,
      power: power ?? this.power,
      resistanceLevel: resistanceLevel ?? this.resistanceLevel,
      inclination: inclination ?? this.inclination,
      strokeRate: strokeRate ?? this.strokeRate,
      strokeCount: strokeCount ?? this.strokeCount,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}
