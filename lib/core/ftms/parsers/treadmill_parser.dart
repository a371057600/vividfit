import 'dart:typed_data';

import '../ftms_data_parser_base.dart';
import '../ftms_device_data.dart';

/// 跑步机数据解析器(对应 0x2ACD Treadmill Data)。
///
/// Flags bit 定义(FTMS 协议 V2):
/// bit0: More Data(0=存在)
/// bit1: Average Speed
/// bit2: Total Distance
/// bit3: Inclination and Ramp Angle Setting
/// bit4: Elevation Gain
/// bit5: Instantaneous Pace
/// bit6: Average Pace
/// bit7: Expended Energy
/// bit8: Heart Rate
/// bit9: Metabolic Equivalent
/// bit10: Elapsed Time
/// bit11: Remaining Time
/// bit12: Force on Belt and Power Output
/// bit13: Steps
class TreadmillParser extends FtmsDataParserBase {
  @override
  FtmsDeviceData parse(Uint8List data) {
    if (data.isEmpty) return const FtmsDeviceData();
    final bd = ByteData.view(data.buffer);
    int offset = 0;

    final flags = readUint16(bd, offset);
    offset += 2;

    final moreData = !flagSet(flags, 0);
    double? instSpeed;
    double? avgSpeed;
    int? totalDistance;
    double? inclineAngle;
    double? rampAngle;
    int? elevationGainPos;
    int? elevationGainNeg;
    double? instPace;
    double? avgPace;
    int? totalEnergy;
    int? energyPerHr;
    int? energyPerMin;
    int? hr;
    double? met;
    int? elapsedTime;
    int? remainingTime;
    int? forceOnBelt;
    int? instPower;

    // 瞬时速度
    if (moreData && hasData(data, offset, 2)) {
      instSpeed = fixPrecision(readUint16(bd, offset) * 0.01, 2);
      offset += 2;
    }

    // 平均速度(bit1)
    if (flagSet(flags, 1) && hasData(data, offset, 2)) {
      avgSpeed = fixPrecision(readUint16(bd, offset) * 0.01, 2);
      offset += 2;
    }

    // 总距离(bit2, uint24)
    if (flagSet(flags, 2) && hasData(data, offset, 3)) {
      totalDistance = readUint24(data, offset);
      offset += 3;
    }

    // 坡度 + 坡度角(bit3, 各 sint16)
    if (flagSet(flags, 3) && hasData(data, offset, 4)) {
      inclineAngle = fixPrecision(readInt16(bd, offset) * 0.1, 1);
      offset += 2;
      rampAngle = fixPrecision(readInt16(bd, offset) * 0.1, 1);
      offset += 2;
    }

    // 海拔增益(bit4, 各 uint16, 0.1 米)
    if (flagSet(flags, 4) && hasData(data, offset, 4)) {
      elevationGainPos = (readUint16(bd, offset) * 0.1).round();
      offset += 2;
      elevationGainNeg = (readUint16(bd, offset) * 0.1).round();
      offset += 2;
    }

    // 瞬时配速(bit5, uint8, 0.1 km/m)
    if (flagSet(flags, 5) && hasData(data, offset, 1)) {
      instPace = fixPrecision(readUint8(bd, offset) * 0.1, 1);
      offset += 1;
    }

    // 平均配速(bit6)
    if (flagSet(flags, 6) && hasData(data, offset, 1)) {
      avgPace = fixPrecision(readUint8(bd, offset) * 0.1, 1);
      offset += 1;
    }

    // 能耗(bit7: total(2) + perHour(2) + perMin(1))
    if (flagSet(flags, 7) && hasData(data, offset, 5)) {
      totalEnergy = readUint16(bd, offset);
      offset += 2;
      energyPerHr = readUint16(bd, offset);
      offset += 2;
      energyPerMin = readUint8(bd, offset);
      offset += 1;
    }

    // 心率(bit8)
    if (flagSet(flags, 8) && hasData(data, offset, 1)) {
      hr = readUint8(bd, offset);
      offset += 1;
    }

    // 代谢当量(bit9)
    if (flagSet(flags, 9) && hasData(data, offset, 1)) {
      met = fixPrecision(readUint8(bd, offset) * 0.1, 1);
      offset += 1;
    }

    // 运动时长(bit10)
    if (flagSet(flags, 10) && hasData(data, offset, 2)) {
      elapsedTime = readUint16(bd, offset);
      offset += 2;
    }

    // 剩余时间(bit11)
    if (flagSet(flags, 11) && hasData(data, offset, 2)) {
      remainingTime = readUint16(bd, offset);
      offset += 2;
    }

    // Force on Belt + Power Output(bit12, 各 sint16)
    if (flagSet(flags, 12) && hasData(data, offset, 4)) {
      forceOnBelt = readInt16(bd, offset);
      offset += 2;
      instPower = readInt16(bd, offset);
      offset += 2;
    }

    return FtmsDeviceData(
      instSpeed: instSpeed,
      avgSpeed: avgSpeed,
      distTotal: totalDistance,
      inclineAngle: inclineAngle,
      rampAngle: rampAngle,
      elevationGainPos: elevationGainPos,
      elevationGainNeg: elevationGainNeg,
      instPace: instPace,
      avgPace: avgPace,
      energyTotal: totalEnergy,
      energyPerHr: energyPerHr,
      energyPerMin: energyPerMin,
      hr: hr,
      met: met,
      timeElapsed: elapsedTime,
      timeRemaining: remainingTime,
      forceOnBelt: forceOnBelt,
      instPower: instPower,
    );
  }
}
