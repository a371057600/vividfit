import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'ftms_data_parser_base.dart';
import 'ftms_uuids.dart';
import 'parsers/cross_trainer_parser.dart';
import 'parsers/indoor_bike_parser.dart';
import 'parsers/rower_parser.dart';
import 'parsers/treadmill_parser.dart';

/// FTMS 设备类型枚举。
///
/// 数值与旧项目 newMainSelectType / bigDeviceType 保持一致:
/// 0=单车  1=跑步机  2=椭圆机  3=划船机  4=力量站(预留)
enum FtmsDeviceType {
  /// 动感单车 / Indoor Bike
  indoorBike(0),

  /// 跑步机 / Treadmill
  treadmill(1),

  /// 椭圆机 / Cross Trainer
  crossTrainer(2),

  /// 划船机 / Rower
  rower(3),

  /// 力量站 / Strength Station(预留,暂复用单车解析器)
  strengthStation(4);

  const FtmsDeviceType(this.value);

  /// 数值编码。
  final int value;

  /// 根据数值获取枚举。
  static FtmsDeviceType fromValue(int v) =>
      FtmsDeviceType.values.firstWhere((e) => e.value == v,
          orElse: () => FtmsDeviceType.indoorBike);
}

/// 扩展:每种设备的 FTMS 配置(数据 UUID + 解析器 + 能力)。
extension FtmsDeviceTypeConfig on FtmsDeviceType {
  /// 实时数据特征值 UUID(Notify)。
  Guid get dataCharacteristicUuid {
    switch (this) {
      case FtmsDeviceType.indoorBike:
        return FtmsUuids.indoorBikeData;
      case FtmsDeviceType.treadmill:
        return FtmsUuids.treadmillData;
      case FtmsDeviceType.crossTrainer:
        return FtmsUuids.crossTrainerData;
      case FtmsDeviceType.rower:
        return FtmsUuids.rowerData;
      case FtmsDeviceType.strengthStation:
        return FtmsUuids.indoorBikeData;
    }
  }

  /// 创建对应设备的数据解析器实例。
  FtmsDataParserBase createParser() {
    switch (this) {
      case FtmsDeviceType.indoorBike:
        return IndoorBikeParser();
      case FtmsDeviceType.treadmill:
        return TreadmillParser();
      case FtmsDeviceType.crossTrainer:
        return CrossTrainerParser();
      case FtmsDeviceType.rower:
        return RowerParser();
      case FtmsDeviceType.strengthStation:
        return IndoorBikeParser();
    }
  }

  /// 是否支持速度控制。
  bool get supportsSpeedControl =>
      this == FtmsDeviceType.treadmill || this == FtmsDeviceType.indoorBike;

  /// 是否支持坡度控制。
  bool get supportsInclinationControl =>
      this == FtmsDeviceType.treadmill || this == FtmsDeviceType.crossTrainer;

  /// 是否支持阻力控制。
  bool get supportsResistanceControl =>
      this != FtmsDeviceType.treadmill;

  /// 是否显示踏频。
  bool get supportsCadenceDisplay =>
      this == FtmsDeviceType.indoorBike || this == FtmsDeviceType.crossTrainer;

  /// 是否显示桨频/桨数。
  bool get supportsStrokeDisplay => this == FtmsDeviceType.rower;

  /// 是否显示功率。
  bool get supportsPowerDisplay =>
      this == FtmsDeviceType.indoorBike ||
      this == FtmsDeviceType.crossTrainer ||
      this == FtmsDeviceType.rower;

  /// 速度是否需要单位转换（划船机 m/s → km/h）。
  bool get needsSpeedConversion => this == FtmsDeviceType.rower;

  /// 距离是否需要单位转换（划船机 m → km）。
  bool get needsDistanceConversion => this == FtmsDeviceType.rower;
}
