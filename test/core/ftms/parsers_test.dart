import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/ftms/parsers/indoor_bike_parser.dart';
import 'package:vividfit_v2/core/ftms/parsers/treadmill_parser.dart';
import 'package:vividfit_v2/core/ftms/parsers/cross_trainer_parser.dart';
import 'package:vividfit_v2/core/ftms/parsers/rower_parser.dart';

void main() {
  group('IndoorBikeParser', () {
    test('空数据返回默认值', () {
      final parser = IndoorBikeParser();
      final result = parser.parse(Uint8List(0));
      expect(result.instSpeed, isNull);
      expect(result.distTotal, isNull);
      expect(result.machineState, 0);
    });

    test('解析完整单车数据(Flags=0x1FFE)', () {
      // 构造:Flags(0x1FFE) + 各字段
      // bit0=0(moreData存在), bit1-12全置1
      final data = Uint8List.fromList([
        0xFE, 0x1F, // flags = 0x1FFE (bit0=0)
        0xD0, 0x07, // instSpeed = 2000 * 0.01 = 20.0 km/h
        0xC8, 0x05, // avgSpeed = 1480 * 0.01 = 14.8 km/h
        0xF0, 0x00, // instCadence = 240 * 0.5 = 120 rpm
        0xB4, 0x00, // avgCadence = 180 * 0.5 = 90 rpm
        0xE8, 0x03, 0x00, // totalDistance = 1000 m
        0x0A, 0x00, // resistance = 10
        0x64, 0x00, // instPower = 100 W
        0x50, 0x00, // avgPower = 80 W
        0xAA, 0x00, // totalEnergy = 170 kcal
        0x2C, 0x01, // energyPerHour = 300 kcal
        0x05, // energyPerMin = 5 kcal
        0x96, // hr = 150 bpm
        0x78, // met = 12.0
        0x2C, 0x01, // elapsedTime = 300 s
        0x10, 0x00, // remainingTime = 16 s
      ]);

      final parser = IndoorBikeParser();
      final result = parser.parse(data);

      expect(result.instSpeed, closeTo(20.0, 0.01));
      expect(result.avgSpeed, closeTo(14.8, 0.01));
      expect(result.instCadence, 120.0);
      expect(result.avgCadence, 90.0);
      expect(result.distTotal, 1000);
      expect(result.resistanceLvl, 10.0);
      expect(result.instPower, 100);
      expect(result.avgPower, 80);
      expect(result.energyTotal, 170);
      expect(result.energyPerHr, 300);
      expect(result.energyPerMin, 5);
      expect(result.hr, 150);
      expect(result.met, closeTo(12.0, 0.1));
      expect(result.timeElapsed, 300);
      expect(result.timeRemaining, 16);
    });

    test('仅解析瞬时速度和踏频', () {
      // flags: bit0=0(moreData), bit2=1(instCadence) => 0x0004
      final data2 = Uint8List.fromList([
        0x04, 0x00, // flags = 0x0004 (bit0=0, bit2=1)
        0x88, 0x02, // instSpeed = 648 * 0.01 = 6.48 km/h
        0x50, 0x00, // instCadence = 80 * 0.5 = 40 rpm
      ]);
      final parser = IndoorBikeParser();
      final result = parser.parse(data2);
      expect(result.instSpeed, closeTo(6.48, 0.01));
      expect(result.instCadence, 40.0);
      expect(result.avgSpeed, isNull);
      expect(result.distTotal, isNull);
    });
  });

  group('TreadmillParser', () {
    test('空数据返回默认值', () {
      final parser = TreadmillParser();
      final result = parser.parse(Uint8List(0));
      expect(result.instSpeed, isNull);
      expect(result.inclineAngle, isNull);
    });

    test('解析坡度字段', () {
      // Flags: bit0=0(moreData), bit3=1(incline)
      // 0x0008 = bit3=1
      final data = Uint8List.fromList([
        0x08, 0x00, // flags (bit0=0, bit3=1)
        0x00, 0x00, // instSpeed = 0
        0x32, 0x00, // inclineAngle = 50 * 0.1 = 5.0%
        0x1E, 0x00, // rampAngle = 30 * 0.1 = 3.0 degrees
      ]);
      final parser = TreadmillParser();
      final result = parser.parse(data);
      expect(result.instSpeed, closeTo(0.0, 0.01));
      expect(result.inclineAngle, closeTo(5.0, 0.1));
      expect(result.rampAngle, closeTo(3.0, 0.1));
    });

    test('无坡度数据时返回null', () {
      // flags: bit0=0, bit3=0
      final data = Uint8List.fromList([
        0x00, 0x00, // flags (only moreData)
        0x00, 0x00, // instSpeed = 0
      ]);
      final parser = TreadmillParser();
      final result = parser.parse(data);
      expect(result.inclineAngle, isNull);
      expect(result.rampAngle, isNull);
    });
  });

  group('RowerParser', () {
    test('解析桨频和桨次', () {
      // flags: moreData(bit0=0) + totalDistance(bit2=1) = 0x0004
      final data = Uint8List.fromList([
        0x04, 0x00, // flags = 0x0004 (bit0=0, bit2=1)
        0x40, // strokeRate = 64 * 0.5 = 32 spm
        0xE8, 0x03, // strokeCount = 1000
        0x10, 0x27, 0x00, // totalDistance = 10000 m
      ]);

      final parser = RowerParser();
      final result = parser.parse(data);

      expect(result.strokesPerMin, 32.0);
      expect(result.strokeCountTotal, 1000);
      expect(result.distTotal, 10000);
    });

    test('仅解析桨频(无距离)', () {
      // flags: bit0=0 => 0x0000
      final data = Uint8List.fromList([
        0x00, 0x00, // flags = 0x0000 (bit0=0)
        0x28, // strokeRate = 40 * 0.5 = 20 spm
        0x64, 0x00, // strokeCount = 100
      ]);
      final parser = RowerParser();
      final result = parser.parse(data);
      expect(result.strokesPerMin, 20.0);
      expect(result.strokeCountTotal, 100);
      expect(result.distTotal, isNull);
    });
  });

  group('CrossTrainerParser', () {
    test('解析步频和步数', () {
      // flags: moreData(0) + stepCount(bit3) + strideCount(bit4) = 0x0018
      final data = Uint8List.fromList([
        0x18, 0x00, // flags = 0x0018 (bit0=0, bit3=1, bit4=1)
        0x00, 0x00, // instSpeed = 0
        0xF0, 0x00, // stepsPerMin = 240
        0xC8, 0x00, // avgStepRate = 200
        0xE8, 0x03, // strideCountTotal = 1000
      ]);

      final parser = CrossTrainerParser();
      final result = parser.parse(data);

      expect(result.instSpeed, closeTo(0.0, 0.01));
      expect(result.stepsPerMin, 240);
      expect(result.avgStepRate, 200);
      expect(result.strideCountTotal, 1000);
    });

    test('解析运动方向', () {
      // flags: bit15=1(movementDirection) => 0x8000
      final data = Uint8List.fromList([
        0x00, 0x80, // flags = 0x8000 (bit15=1)
        0x01, // movementDirection = 1 (向后)
      ]);
      final parser = CrossTrainerParser();
      final result = parser.parse(data);
      expect(result.movementDirection, 1);
      expect(result.instSpeed, isNull); // bit0=1, moreData不存在
    });
  });
}
