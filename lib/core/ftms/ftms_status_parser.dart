import 'dart:typed_data';

import 'ftms_device_data.dart';

/// 0x2ADA 设备状态通知事件(自由联合类型)。
///
/// 对应 FTMS 协议 Fitness Machine Status OpCode:
/// 0x01 Reset
/// 0x02 Stopped or Paused by User
/// 0x03 Stopped by Safety Key
/// 0x04 Started or Resumed by User
/// 0x05 Target Speed Changed
/// 0x06 Target Incline Changed
/// 0x07 Target Resistance Level Changed
/// 0x08 Target Power Changed
/// 0x1F Control Permission Lost
sealed class FtmsStatusEvent {
  const FtmsStatusEvent();
}

class FtmsStatusReset extends FtmsStatusEvent {
  const FtmsStatusReset();
}

class FtmsStatusStoppedPaused extends FtmsStatusEvent {
  const FtmsStatusStoppedPaused(this.isPause);
  final bool isPause; // true=pause, false=stop
}

class FtmsStatusSafetyKey extends FtmsStatusEvent {
  const FtmsStatusSafetyKey();
}

class FtmsStatusStartedResumed extends FtmsStatusEvent {
  const FtmsStatusStartedResumed();
}

class FtmsStatusTargetSpeedChanged extends FtmsStatusEvent {
  const FtmsStatusTargetSpeedChanged(this.speedKmPerH);
  final double speedKmPerH;
}

class FtmsStatusTargetInclineChanged extends FtmsStatusEvent {
  const FtmsStatusTargetInclineChanged(this.inclinePercent);
  final double inclinePercent;
}

class FtmsStatusTargetResistanceChanged extends FtmsStatusEvent {
  const FtmsStatusTargetResistanceChanged(this.resistanceLevel);
  final double resistanceLevel;
}

class FtmsStatusTargetPowerChanged extends FtmsStatusEvent {
  const FtmsStatusTargetPowerChanged(this.powerWatts);
  final int powerWatts;
}

class FtmsStatusControlPermissionLost extends FtmsStatusEvent {
  const FtmsStatusControlPermissionLost();
}

class FtmsStatusUnknown extends FtmsStatusEvent {
  const FtmsStatusUnknown(this.opCode);
  final int opCode;
}

/// 0x2ADA Fitness Machine Status 解析器。
class FtmsStatusParser {
  FtmsStatusParser._();

  /// 解析原始状态通知数据为事件对象。
  static FtmsStatusEvent parse(Uint8List data) {
    if (data.isEmpty) return const FtmsStatusUnknown(0);
    final opCode = data[0];
    final bd = ByteData.view(data.buffer);

    switch (opCode) {
      case 0x01:
        return const FtmsStatusReset();
      case 0x02:
        // control: 01=stop 02=pause
        final control = data.length > 1 ? data[1] : 0x01;
        return FtmsStatusStoppedPaused(control == 0x02);
      case 0x03:
        return const FtmsStatusSafetyKey();
      case 0x04:
        return const FtmsStatusStartedResumed();
      case 0x05:
        // uint16 LE, 0.01 km/h
        if (data.length < 3) return const FtmsStatusUnknown(0x05);
        final speed = bd.getUint16(1, Endian.little) * 0.01;
        return FtmsStatusTargetSpeedChanged(speed);
      case 0x06:
        // sint16 LE, 0.1 %
        if (data.length < 3) return const FtmsStatusUnknown(0x06);
        final incline = bd.getInt16(1, Endian.little) * 0.1;
        return FtmsStatusTargetInclineChanged(incline);
      case 0x07:
        // sint16 LE, 0.1 unitless
        if (data.length < 3) return const FtmsStatusUnknown(0x07);
        final resistance = bd.getInt16(1, Endian.little) * 0.1;
        return FtmsStatusTargetResistanceChanged(resistance);
      case 0x08:
        // sint16 LE, Watt
        if (data.length < 3) return const FtmsStatusUnknown(0x08);
        final power = bd.getInt16(1, Endian.little);
        return FtmsStatusTargetPowerChanged(power);
      case 0xFF:
        return const FtmsStatusControlPermissionLost();
      default:
        return FtmsStatusUnknown(opCode);
    }
  }

  /// 解析 0x2AD3 Training Status 原始数据。
  static FtmsTrainingStatus parseTrainingStatus(Uint8List data) {
    if (data.length < 2) return FtmsTrainingStatus.unknown;
    // byte0: Flags, byte1+: Training Status
    final flags = data[0];
    if ((flags & 0x01) == 0) return FtmsTrainingStatus.unknown; // bit0 不存在
    if (data.length < 2) return FtmsTrainingStatus.unknown;
    return FtmsTrainingStatus.fromCode(data[1]);
  }
}
