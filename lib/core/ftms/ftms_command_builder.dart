import 'dart:typed_data';

/// FTMS 控制指令构建器(对应 0x2AD9 Fitness Machine Control Point)。
///
/// 所有方法返回 Uint8List,可直接写入 Control Point 特征值。
/// 指令格式: OpCode (1 byte) + Parameter (variable)
///
/// 基于 FTMS 协议 V2 简化版 OpCode 定义:
/// 0x00 Request Control
/// 0x01 Reset
/// 0x02 Set Target Speed(uint16, 0.01 km/h)
/// 0x03 Set Target Inclination(sint16, 0.1 %)
/// 0x04 Set Target Resistance Level(uint8, 0.1 unitless)
/// 0x05 Set Target Power(sint16, Watt)
/// 0x06 Set Target Heart Rate(uint8, BPM)
/// 0x07 Start or Resume
/// 0x08 Stop or Pause(uint8 control: 01=stop 02=pause)
class FtmsCommandBuilder {
  FtmsCommandBuilder._();

  // ---- 基础控制 ----

  /// 请求控制权限(0x00)。
  static Uint8List requestControl() => Uint8List.fromList([0x00]);

  /// 重置设备(0x01)。
  static Uint8List reset() => Uint8List.fromList([0x01]);

  /// 开始或恢复运动(0x07)。
  static Uint8List startOrResume() => Uint8List.fromList([0x07]);

  /// 停止运动(0x08, control=0x01)。
  static Uint8List stop() => Uint8List.fromList([0x08, 0x01]);

  /// 暂停运动(0x08, control=0x02)。
  static Uint8List pause() => Uint8List.fromList([0x08, 0x02]);

  // ---- 目标值设置 ----

  /// 设置目标速度(0x02, uint16 小端序,单位 0.01 km/h)。
  ///
  /// [speedKmPerH] 速度,单位 km/h,如 12.5 表示 12.5 km/h。
  static Uint8List setTargetSpeed(double speedKmPerH) {
    final raw = (speedKmPerH * 100).round(); // 0.01 km/h 精度
    final bd = ByteData(3);
    bd.setUint8(0, 0x02);
    bd.setUint16(1, raw, Endian.little);
    return bd.buffer.asUint8List();
  }

  /// 设置目标坡度(0x03, sint16 小端序,单位 0.1 %)。
  ///
  /// [inclinationPercent] 坡度,单位百分比,如 5.0 表示 5.0%。
  static Uint8List setTargetInclination(double inclinationPercent) {
    final raw = (inclinationPercent * 10).round(); // 0.1% 精度
    final bd = ByteData(3);
    bd.setUint8(0, 0x03);
    bd.setInt16(1, raw, Endian.little);
    return bd.buffer.asUint8List();
  }

  /// 设置目标阻力等级(0x04, uint8,单位 0.1 unitless)。
  ///
  /// [resistanceLevel] 阻力等级,如 8.5 表示 8.5 级。
  static Uint8List setTargetResistance(double resistanceLevel) {
    final raw = (resistanceLevel * 10).round().clamp(0, 255); // uint8
    return Uint8List.fromList([0x04, raw]);
  }

  /// 设置目标功率(0x05, sint16 小端序,单位 Watt)。
  static Uint8List setTargetPower(int powerWatts) {
    final bd = ByteData(3);
    bd.setUint8(0, 0x05);
    bd.setInt16(1, powerWatts, Endian.little);
    return bd.buffer.asUint8List();
  }

  /// 设置目标心率(0x06, uint8,单位 BPM)。
  static Uint8List setTargetHeartRate(int bpm) {
    return Uint8List.fromList([0x06, bpm.clamp(0, 255)]);
  }
}
