import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_record.freezed.dart';
part 'sport_record.g.dart';

/// 单次运动记录模型（本地持久化）。
///
/// 用于结束页数据回显与 Record 模块统计。
/// 所有字段均可 JSON 序列化，便于 shared_preferences 存储。
@freezed
abstract class SportRecord with _$SportRecord {
  const factory SportRecord({
    /// 记录唯一 ID（时间戳+随机数生成）
    required String id,

    /// 用户 ID
    required int userId,

    /// 设备类型（对应 FtmsDeviceType.value）
    required int deviceType,

    /// 运动模式（课程 ID 或自定义模式）
    int? mode,

    /// 训练模式（0=自由训练, 1=课程）
    int? trainMode,

    /// 开始时间
    required DateTime startTime,

    /// 结束时间
    required DateTime endTime,

    /// 运动时长（秒）
    required int duration,

    /// 累计距离（km）
    required double distance,

    /// 累计卡路里（kcal）
    required double calories,

    /// 平均速度（km/h）
    double? avgSpeed,

    /// 最大速度（km/h）
    double? maxSpeed,

    /// 平均踏频（rpm）
    int? avgCadence,

    /// 最大踏频（rpm）
    int? maxCadence,

    /// 平均心率（bpm）
    int? avgHeartRate,

    /// 最大心率（bpm）
    int? maxHeartRate,

    /// 平均功率（W）
    double? avgPower,

    /// 最大功率（W）
    double? maxPower,

    /// 平均阻力
    double? avgResistance,

    /// 平均坡度（%）
    double? avgInclination,

    /// 总桨数（划船机）
    int? totalStrokes,

    /// 平均桨频（spm）
    double? avgStrokeRate,

    /// 课程完成度（%）
    double? finishPercent,

    /// 速度采样序列（供图表绘制，每隔 2-3s 采样一次）
    List<double>? speedSamples,

    /// 是否为离线记录（预留服务端同步）
    @Default(false) bool isOffline,

    /// 是否已同步到服务端（预留）
    @Default(false) bool isSynced,
  }) = _SportRecord;

  factory SportRecord.fromJson(Map<String, dynamic> json) =>
      _$SportRecordFromJson(json);
}
