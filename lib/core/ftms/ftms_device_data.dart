import 'package:freezed_annotation/freezed_annotation.dart';

part 'ftms_device_data.freezed.dart';

/// FTMS 统一设备数据模型。
///
/// 所有 4 种设备(单车/跑步机/椭圆机/划船机)解析后均输出此模型,
/// 每种设备只填充自己支持的字段,不支持的字段为 null。
///
/// 命名遵循"语义保持"去重策略(与 big_device 模块重构计划一致):
/// - instantaneous* -> inst*
/// - average* -> avg*
/// - total* -> *Total
/// - heartRate -> hr
/// - metabolicEquivalent -> met
/// - elapsedTime -> timeElapsed
/// - remainingTime -> timeRemaining
/// - resistanceLevel -> resistanceLvl
/// - strokeRate -> strokesPerMin
/// - strokeCount -> strokeCountTotal
/// - stepPerMinute -> stepsPerMin
/// - strideCount -> strideCountTotal
/// - inclination -> inclineAngle
/// - deviceStatus -> machineState
@freezed
abstract class FtmsDeviceData with _$FtmsDeviceData {
  const factory FtmsDeviceData({
    // ---- 通用速度/距离 ----
    double? instSpeed,        // 瞬时速度(km/h)
    double? avgSpeed,         // 平均速度(km/h)
    int? distTotal,           // 总距离(米)

    // ---- 踏频/步频/桨频 ----
    double? instCadence,      // 瞬时踏频(rpm,单车/椭圆机)
    double? avgCadence,       // 平均踏频(rpm)
    int? stepsPerMin,         // 步频(椭圆机)
    int? avgStepRate,         // 平均步频(椭圆机)
    int? strideCountTotal,    // 总步数(椭圆机)
    double? strokesPerMin,    // 桨频(spm,划船机)
    int? strokeCountTotal,    // 总桨次(划船机)
    double? avgStrokeRate,    // 平均桨频(spm)

    // ---- 阻力/坡度/功率 ----
    double? resistanceLvl,    // 阻力等级
    double? inclineAngle,     // 坡度(百分比)
    double? rampAngle,        // 坡度角度(度)
    int? elevationGainPos,    // 正海拔增益(米)
    int? elevationGainNeg,    // 负海拔增益(米)
    int? instPower,           // 瞬时功率(瓦)
    int? avgPower,            // 平均功率(瓦)
    int? forceOnBelt,         // 皮带受力(牛,跑步机)

    // ---- 能耗/心率/代谢 ----
    int? energyTotal,         // 总能耗(千卡)
    int? energyPerHr,         // 每小时能耗(千卡)
    int? energyPerMin,        // 每分钟能耗(千卡)
    int? hr,                  // 心率(bpm)
    double? met,              // 代谢当量

    // ---- 时间 ----
    int? timeElapsed,         // 已运动时长(秒)
    int? timeRemaining,       // 剩余时间(秒)

    // ---- 配速 ----
    double? instPace,         // 瞬时配速
    double? avgPace,          // 平均配速

    // ---- 椭圆机特有 ----
    int? movementDirection,   // 运动方向(0=向前/1=向后)

    // ---- 设备状态 ----
    @Default(0) int machineState, // 设备状态码(0x2AD3)
  }) = _FtmsDeviceData;
}

/// 设备训练状态(对应 0x2AD3 Training Status)。
enum FtmsTrainingStatus {
  unknown(0x00),
  idle(0x01),
  running(0x0D),
  preWorkout(0x0E),
  postWorkout(0x0F);

  const FtmsTrainingStatus(this.code);
  final int code;

  static FtmsTrainingStatus fromCode(int code) =>
      FtmsTrainingStatus.values.firstWhere((e) => e.code == code,
          orElse: () => FtmsTrainingStatus.unknown);
}
