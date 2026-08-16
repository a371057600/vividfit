import 'dart:typed_data';

import '../ftms_data_parser_base.dart';
import '../ftms_device_data.dart';

/// 划船机数据解析器(对应 0x2AD1 Rower Data)。
///
/// Flags bit 定义(FTMS 协议 V2):
/// bit0: More Data(0=存在)
/// bit1: Average Stroke Rate
/// bit2: Total Distance
/// bit3: Instantaneous Pace
/// bit4: Average Pace
/// bit5: Instantaneous Power
/// bit6: Average Power
/// bit7: Resistance Level
/// bit8: Expended Energy
/// bit9: Heart Rate
/// bit10: Metabolic Equivalent
/// bit11: Elapsed Time
/// bit12: Remaining Time
class RowerParser extends FtmsDataParserBase {
  @override
  FtmsDeviceData parse(Uint8List data) {
    if (data.isEmpty) return const FtmsDeviceData();
    final bd = ByteData.view(data.buffer);
    int offset = 0;

    final flags = readUint16(bd, offset);
    offset += 2;

    final moreData = !flagSet(flags, 0);
    double? strokesPerMin;
    int? strokeCountTotal;
    double? avgStrokeRate;
    int? totalDistance;
    int? instPace;
    int? avgPace;
    int? instPower;
    int? avgPower;
    double? resistanceLvl;
    int? totalEnergy;
    int? energyPerHr;
    int? energyPerMin;
    int? hr;
    double? met;
    int? elapsedTime;
    int? remainingTime;

    // 桨频 + 总桨次(与旧项目一致:受 moreData 控制)
    // Stroke Rate(uint8, 0.5 stroke/min) + Stroke Count(uint16, Unitless)
    if (moreData && hasData(data, offset, 3)) {
      strokesPerMin = readUint8(bd, offset) * 0.5;
      offset += 1;
      strokeCountTotal = readUint16(bd, offset);
      offset += 2;
    }

    // 平均桨频(bit1, uint8, 0.5 spm)
    if (flagSet(flags, 1) && hasData(data, offset, 1)) {
      avgStrokeRate = readUint8(bd, offset) * 0.5;
      offset += 1;
    }

    // 总距离(bit2, uint24)
    if (flagSet(flags, 2) && hasData(data, offset, 3)) {
      totalDistance = readUint24(data, offset);
      offset += 3;
    }

    // 瞬时配速(bit3, uint16)
    if (flagSet(flags, 3) && hasData(data, offset, 2)) {
      instPace = readUint16(bd, offset);
      offset += 2;
    }

    // 平均配速(bit4, uint16)
    if (flagSet(flags, 4) && hasData(data, offset, 2)) {
      avgPace = readUint16(bd, offset);
      offset += 2;
    }

    // 瞬时功率(bit5, sint16)
    if (flagSet(flags, 5) && hasData(data, offset, 2)) {
      instPower = readInt16(bd, offset);
      offset += 2;
    }

    // 平均功率(bit6, sint16)
    if (flagSet(flags, 6) && hasData(data, offset, 2)) {
      avgPower = readInt16(bd, offset);
      offset += 2;
    }

    // 阻力等级(bit7, sint16)
    if (flagSet(flags, 7) && hasData(data, offset, 2)) {
      resistanceLvl = readInt16(bd, offset).toDouble();
      offset += 2;
    }

    // 能耗(bit8: total(2) + perHour(2) + perMin(1))
    if (flagSet(flags, 8) && hasData(data, offset, 5)) {
      totalEnergy = readUint16(bd, offset);
      offset += 2;
      energyPerHr = readUint16(bd, offset);
      offset += 2;
      energyPerMin = readUint8(bd, offset);
      offset += 1;
    }

    // 心率(bit9)
    if (flagSet(flags, 9) && hasData(data, offset, 1)) {
      hr = readUint8(bd, offset);
      offset += 1;
    }

    // 代谢当量(bit10)
    if (flagSet(flags, 10) && hasData(data, offset, 1)) {
      met = fixPrecision(readUint8(bd, offset) * 0.1, 1);
      offset += 1;
    }

    // 运动时长(bit11)
    if (flagSet(flags, 11) && hasData(data, offset, 2)) {
      elapsedTime = readUint16(bd, offset);
      offset += 2;
    }

    // 剩余时间(bit12)
    if (flagSet(flags, 12) && hasData(data, offset, 2)) {
      remainingTime = readUint16(bd, offset);
      offset += 2;
    }

    return FtmsDeviceData(
      strokesPerMin: strokesPerMin,
      strokeCountTotal: strokeCountTotal,
      avgStrokeRate: avgStrokeRate,
      distTotal: totalDistance,
      instPace: instPace?.toDouble(),
      avgPace: avgPace?.toDouble(),
      instPower: instPower,
      avgPower: avgPower,
      resistanceLvl: resistanceLvl,
      energyTotal: totalEnergy,
      energyPerHr: energyPerHr,
      energyPerMin: energyPerMin,
      hr: hr,
      met: met,
      timeElapsed: elapsedTime,
      timeRemaining: remainingTime,
    );
  }
}
