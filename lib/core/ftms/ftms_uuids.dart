import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// FTMS (Fitness Machine Service) 蓝牙 UUID 常量。
///
/// 基于 FTMS 协议 V2(简化版)。所有 UUID 均为 Bluetooth SIG 标准 16-bit UUID
/// 拼接到基础 UUID `0000xxxx-0000-1000-8000-00805f9b34fb`。
class FtmsUuids {
  FtmsUuids._();

  // ---- 服务 ----

  /// Fitness Machine Service(0x1826)。
  static final Guid service = Guid('00001826-0000-1000-8000-00805f9b34fb');

  // ---- 特征值 ----

  /// Fitness Machine Feature(0x2ACC) - 读取设备支持的能力。
  static final Guid feature = Guid('00002acc-0000-1000-8000-00805f9b34fb');

  /// Treadmill Data(0x2ACD) - 跑步机实时数据(Notify)。
  static final Guid treadmillData = Guid('00002acd-0000-1000-8000-00805f9b34fb');

  /// Cross Trainer Data(0x2ACE) - 椭圆机实时数据(Notify)。
  static final Guid crossTrainerData =
      Guid('00002ace-0000-1000-8000-00805f9b34fb');

  /// Rower Data(0x2AD1) - 划船机实时数据(Notify)。
  static final Guid rowerData = Guid('00002ad1-0000-1000-8000-00805f9b34fb');

  /// Indoor Bike Data(0x2AD2) - 智能单车实时数据(Notify)。
  static final Guid indoorBikeData =
      Guid('00002ad2-0000-1000-8000-00805f9b34fb');

  /// Training Status(0x2AD3) - 训练状态(Read/Notify)。
  static final Guid trainingState = Guid('00002ad3-0000-1000-8000-00805f9b34fb');

  /// Supported Speed Range(0x2AD4) - 支持的速度范围(Read)。
  static final Guid speedRange = Guid('00002ad4-0000-1000-8000-00805f9b34fb');

  /// Supported Inclination Range(0x2AD5) - 支持的坡度范围(Read)。
  static final Guid inclinationRange =
      Guid('00002ad5-0000-1000-8000-00805f9b34fb');

  /// Supported Resistance Level Range(0x2AD6) - 支持的阻力范围(Read)。
  static final Guid resistanceRange =
      Guid('00002ad6-0000-1000-8000-00805f9b34fb');

  /// Supported Heart Rate Range(0x2AD7) - 支持的心率范围(Read)。
  static final Guid heartRateRange =
      Guid('00002ad7-0000-1000-8000-00805f9b34fb');

  /// Supported Power Range(0x2AD8) - 支持的功率范围(Read)。
  static final Guid powerRange = Guid('00002ad8-0000-1000-8000-00805f9b34fb');

  /// Fitness Machine Control Point(0x2AD9) - 控制点(Write/Indicate)。
  static final Guid controlPoint = Guid('00002ad9-0000-1000-8000-00805f9b34fb');

  /// Fitness Machine Status(0x2ADA) - 设备状态通知(Notify)。
  static final Guid machineStatus = Guid('00002ada-0000-1000-8000-00805f9b34fb');
}
