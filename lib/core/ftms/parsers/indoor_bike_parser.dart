import 'dart:typed_data';

import '../ftms_data_parser_base.dart';
import '../ftms_device_data.dart';

/// 智能单车数据解析器(对应 0x2AD2 Indoor Bike Data)。
///
/// Flags bit 定义(FTMS 协议 V2):
/// bit0: More Data(0=存在)
/// bit1: Average Speed
/// bit2: Instantaneous Cadence
/// bit3: Average Cadence
/// bit4: Total Distance
/// bit5: Resistance Level
/// bit6: Instantaneous Power
/// bit7: Average Power
/// bit8: Expended Energy(总能耗 + 每小时 + 每分钟)
/// bit9: Heart Rate
/// bit10: Metabolic Equivalent
/// bit11: Elapsed Time
/// bit12: Remaining Time
class IndoorBikeParser extends FtmsDataParserBase {
  @override
  FtmsDeviceData parse(Uint8List data) {
    if (data.isEmpty) return const FtmsDeviceData();
    final bd = ByteData.view(data.buffer);
    int offset = 0;

    // Flags(uint16, 必选)
    final flags = readUint16(bd, offset);
    offset += 2;

    final moreData = !flagSet(flags, 0); // bit0=0 表示存在
    double? instSpeed;
    double? avgSpeed;
    double? instCadence;
    double? avgCadence;
    int? totalDistance;
    double? resistanceLvl;
    int? instPower;
    int? avgPower;
    int? totalEnergy;
    int? energyPerHr;
    int? energyPerMin;
    int? hr;
    double? met;
    int? elapsedTime;
    int? remainingTime;

    // 瞬时速度(moreData 存在时)
    if (moreData && hasData(data, offset, 2)) {
      instSpeed = fixPrecision(readUint16(bd, offset) * 0.01, 2);
      offset += 2;
    }

    // 平均速度(bit1)
    if (flagSet(flags, 1) && hasData(data, offset, 2)) {
      avgSpeed = fixPrecision(readUint16(bd, offset) * 0.01, 2);
      offset += 2;
    }

    // 瞬时踏频(bit2)
    if (flagSet(flags, 2) && hasData(data, offset, 2)) {
      instCadence = readUint16(bd, offset) * 0.5;
      offset += 2;
    }

    // 平均踏频(bit3)
    if (flagSet(flags, 3) && hasData(data, offset, 2)) {
      avgCadence = readUint16(bd, offset) * 0.5;
      offset += 2;
    }

    // 总距离(bit4, uint24)
    if (flagSet(flags, 4) && hasData(data, offset, 3)) {
      totalDistance = readUint24(data, offset);
      offset += 3;
    }

    // 阻力等级(bit5, sint16, 分辨率 0.1)
    if (flagSet(flags, 5) && hasData(data, offset, 2)) {
      resistanceLvl = readInt16(bd, offset) * 0.1;
      offset += 2;
    }

    // 瞬时功率(bit6, sint16)
    if (flagSet(flags, 6) && hasData(data, offset, 2)) {
      instPower = readInt16(bd, offset);
      offset += 2;
    }

    // 平均功率(bit7, sint16)
    if (flagSet(flags, 7) && hasData(data, offset, 2)) {
      avgPower = readInt16(bd, offset);
      offset += 2;
    }

    // 能耗(bit8: totalEnergy(2) + energyPerHour(2) + energyPerMinute(1))
    if (flagSet(flags, 8) && hasData(data, offset, 2)) {
      totalEnergy = readUint16(bd, offset);
      offset += 2;
      if (hasData(data, offset, 2)) {
        energyPerHr = readUint16(bd, offset);
        offset += 2;
      }
      if (hasData(data, offset, 1)) {
        energyPerMin = readUint8(bd, offset);
        offset += 1;
      }
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
      instSpeed: instSpeed,
      avgSpeed: avgSpeed,
      instCadence: instCadence,
      avgCadence: avgCadence,
      distTotal: totalDistance,
      resistanceLvl: resistanceLvl,
      instPower: instPower,
      avgPower: avgPower,
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
