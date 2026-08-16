import 'dart:typed_data';

import '../ftms_data_parser_base.dart';
import '../ftms_device_data.dart';

/// 椭圆机数据解析器(对应 0x2ACE Cross Trainer Data)。
///
/// 解析规则与旧项目 cross_trainer_blueTooth_data_tool.dart 保持一致:
/// - direction 在 Flags 之后无条件读取第 1 字节(不受 bit15 控制)
/// - bit5(Elevation Gain)先于 bit6(Inclination)解析(按协议顺序)
///
/// Flags bit 定义:
/// bit0: More Data(0=存在)
/// bit1: Average Speed
/// bit2: Total Distance
/// bit3: Step Count
/// bit4: Stride Count
/// bit5: Elevation Gain
/// bit6: Inclination and Ramp Angle Setting
/// bit7: Resistance Level
/// bit8: Instantaneous Power
/// bit9: Average Power
/// bit10: Expended Energy
/// bit11: Heart Rate
/// bit12: Metabolic Equivalent
/// bit13: Elapsed Time
/// bit14: Remaining Time
class CrossTrainerParser extends FtmsDataParserBase {
  @override
  FtmsDeviceData parse(Uint8List data) {
    if (data.isEmpty) return const FtmsDeviceData();
    final bd = ByteData.view(data.buffer);
    int offset = 0;

    final flags = readUint16(bd, offset);
    offset += 2;

    final moreData = !flagSet(flags, 0);

    // 运动方向:旧项目在 Flags 后无条件读取第 1 字节
    int? movementDirection;
    if (hasData(data, offset, 1)) {
      movementDirection = readUint8(bd, offset);
      offset += 1;
    }

    double? instSpeed;
    double? avgSpeed;
    int? totalDistance;
    int? stepsPerMin;
    int? avgStepRate;
    int? strideCountTotal;
    double? elevationGainPos;
    double? elevationGainNeg;
    double? inclineAngle;
    double? rampAngle;
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

    // 步频 + 平均步频(bit3, 各 uint16)
    if (flagSet(flags, 3) && hasData(data, offset, 4)) {
      stepsPerMin = readUint16(bd, offset);
      offset += 2;
      avgStepRate = readUint16(bd, offset);
      offset += 2;
    }

    // 总步数(bit4, uint16)
    if (flagSet(flags, 4) && hasData(data, offset, 2)) {
      strideCountTotal = readUint16(bd, offset);
      offset += 2;
    }

    // 海拔增益(bit5, 各 uint16, 1 米)
    if (flagSet(flags, 5) && hasData(data, offset, 4)) {
      elevationGainPos = readUint16(bd, offset).toDouble();
      offset += 2;
      elevationGainNeg = readUint16(bd, offset).toDouble();
      offset += 2;
    }

    // 坡度 + 坡度角(bit6, 各 sint16)
    if (flagSet(flags, 6) && hasData(data, offset, 4)) {
      inclineAngle = fixPrecision(readInt16(bd, offset) * 0.1, 1);
      offset += 2;
      rampAngle = fixPrecision(readInt16(bd, offset) * 0.1, 1);
      offset += 2;
    }

    // 阻力等级(bit7, sint16, 0.1)
    if (flagSet(flags, 7) && hasData(data, offset, 2)) {
      resistanceLvl = fixPrecision(readInt16(bd, offset) * 0.1, 1);
      offset += 2;
    }

    // 瞬时功率(bit8, sint16)
    if (flagSet(flags, 8) && hasData(data, offset, 2)) {
      instPower = readInt16(bd, offset);
      offset += 2;
    }

    // 平均功率(bit9, sint16)
    if (flagSet(flags, 9) && hasData(data, offset, 2)) {
      avgPower = readInt16(bd, offset);
      offset += 2;
    }

    // 能耗(bit10: total(2) + perHour(2) + perMin(1))
    if (flagSet(flags, 10) && hasData(data, offset, 5)) {
      totalEnergy = readUint16(bd, offset);
      offset += 2;
      energyPerHr = readUint16(bd, offset);
      offset += 2;
      energyPerMin = readUint8(bd, offset);
      offset += 1;
    }

    // 心率(bit11)
    if (flagSet(flags, 11) && hasData(data, offset, 1)) {
      hr = readUint8(bd, offset);
      offset += 1;
    }

    // 代谢当量(bit12)
    if (flagSet(flags, 12) && hasData(data, offset, 1)) {
      met = fixPrecision(readUint8(bd, offset) * 0.1, 1);
      offset += 1;
    }

    // 运动时长(bit13)
    if (flagSet(flags, 13) && hasData(data, offset, 2)) {
      elapsedTime = readUint16(bd, offset);
      offset += 2;
    }

    // 剩余时间(bit14)
    if (flagSet(flags, 14) && hasData(data, offset, 2)) {
      remainingTime = readUint16(bd, offset);
      offset += 2;
    }

    return FtmsDeviceData(
      instSpeed: instSpeed,
      avgSpeed: avgSpeed,
      distTotal: totalDistance,
      stepsPerMin: stepsPerMin,
      avgStepRate: avgStepRate,
      strideCountTotal: strideCountTotal,
      elevationGainPos: elevationGainPos,
      elevationGainNeg: elevationGainNeg,
      inclineAngle: inclineAngle,
      rampAngle: rampAngle,
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
      movementDirection: movementDirection,
    );
  }
}
