import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/ftms/ftms_command_builder.dart';
import 'package:vividfit_v2/core/ftms/ftms_status_parser.dart';
import 'package:vividfit_v2/core/ftms/ftms_device_data.dart';

void main() {
  group('FtmsCommandBuilder', () {
    test('requestControl 返回 [0x00]', () {
      final result = FtmsCommandBuilder.requestControl();
      expect(result, [0x00]);
    });

    test('reset 返回 [0x01]', () {
      expect(FtmsCommandBuilder.reset(), [0x01]);
    });

    test('startOrResume 返回 [0x07]', () {
      expect(FtmsCommandBuilder.startOrResume(), [0x07]);
    });

    test('stop 返回 [0x08, 0x01]', () {
      expect(FtmsCommandBuilder.stop(), [0x08, 0x01]);
    });

    test('pause 返回 [0x08, 0x02]', () {
      expect(FtmsCommandBuilder.pause(), [0x08, 0x02]);
    });

    test('setTargetSpeed(12.5) 返回正确小端序', () {
      // 12.5 * 100 = 1250 = 0x04E2 -> LE: [0xE2, 0x04]
      final result = FtmsCommandBuilder.setTargetSpeed(12.5);
      expect(result.length, 3);
      expect(result[0], 0x02); // opCode
      expect(result[1], 0xE2); // low byte
      expect(result[2], 0x04); // high byte
    });

    test('setTargetInclination(5.0) 正坡度', () {
      // 5.0 * 10 = 50 = 0x0032 -> sint16 LE: [0x32, 0x00]
      final result = FtmsCommandBuilder.setTargetInclination(5.0);
      expect(result.length, 3);
      expect(result[0], 0x03);
      expect(result[1], 0x32);
      expect(result[2], 0x00);
    });

    test('setTargetInclination(-2.5) 负坡度', () {
      // -2.5 * 10 = -25 = 0xFFE7 -> sint16 LE: [0xE7, 0xFF]
      final result = FtmsCommandBuilder.setTargetInclination(-2.5);
      expect(result.length, 3);
      expect(result[0], 0x03);
      final bd = ByteData.sublistView(Uint8List.fromList(result), 1);
      expect(bd.getInt16(0, Endian.little), -25);
    });

    test('setTargetResistance(8.5)', () {
      // 8.5 * 10 = 85 = 0x55
      final result = FtmsCommandBuilder.setTargetResistance(8.5);
      expect(result, [0x04, 85]);
    });

    test('setTargetPower(150)', () {
      // 150 = 0x0096 -> LE: [0x96, 0x00]
      final result = FtmsCommandBuilder.setTargetPower(150);
      expect(result.length, 3);
      expect(result[0], 0x05);
      expect(result[1], 0x96);
      expect(result[2], 0x00);
    });

    test('setTargetHeartRate(120)', () {
      expect(FtmsCommandBuilder.setTargetHeartRate(120), [0x06, 120]);
    });
  });

  group('FtmsStatusParser', () {
    test('解析 Reset 事件', () {
      final event = FtmsStatusParser.parse(Uint8List.fromList([0x01]));
      expect(event, isA<FtmsStatusReset>());
    });

    test('解析 Stopped 事件', () {
      final event = FtmsStatusParser.parse(Uint8List.fromList([0x02, 0x01]));
      expect(event, isA<FtmsStatusStoppedPaused>());
      expect((event as FtmsStatusStoppedPaused).isPause, false);
    });

    test('解析 Paused 事件', () {
      final event = FtmsStatusParser.parse(Uint8List.fromList([0x02, 0x02]));
      expect((event as FtmsStatusStoppedPaused).isPause, true);
    });

    test('解析 StartedResumed 事件', () {
      final event = FtmsStatusParser.parse(Uint8List.fromList([0x04]));
      expect(event, isA<FtmsStatusStartedResumed>());
    });

    test('解析 TargetSpeedChanged 事件', () {
      // 12.0 km/h = 1200 * 0.01 = 0x04B0 -> LE: [0xB0, 0x04]
      final event = FtmsStatusParser.parse(
          Uint8List.fromList([0x05, 0xB0, 0x04]));
      expect(event, isA<FtmsStatusTargetSpeedChanged>());
      expect(
          (event as FtmsStatusTargetSpeedChanged).speedKmPerH, closeTo(12.0, 0.01));
    });

    test('解析 TargetInclineChanged 事件', () {
      // 5.0% = 50 * 0.1 = 0x0032 -> LE: [0x32, 0x00]
      final event = FtmsStatusParser.parse(
          Uint8List.fromList([0x06, 0x32, 0x00]));
      expect(event, isA<FtmsStatusTargetInclineChanged>());
      expect((event as FtmsStatusTargetInclineChanged).inclinePercent,
          closeTo(5.0, 0.1));
    });

    test('解析 TargetResistanceChanged 事件', () {
      // 8.5 level = 85 * 0.1 = 0x0055 -> LE: [0x55, 0x00]
      final event = FtmsStatusParser.parse(
          Uint8List.fromList([0x07, 0x55, 0x00]));
      expect(event, isA<FtmsStatusTargetResistanceChanged>());
      expect((event as FtmsStatusTargetResistanceChanged).resistanceLevel,
          closeTo(8.5, 0.1));
    });

    test('解析 TargetPowerChanged 事件', () {
      // 150 W = 0x0096 -> LE: [0x96, 0x00]
      final event = FtmsStatusParser.parse(
          Uint8List.fromList([0x08, 0x96, 0x00]));
      expect(event, isA<FtmsStatusTargetPowerChanged>());
      expect((event as FtmsStatusTargetPowerChanged).powerWatts, 150);
    });

    test('解析 ControlPermissionLost', () {
      final event = FtmsStatusParser.parse(Uint8List.fromList([0xFF]));
      expect(event, isA<FtmsStatusControlPermissionLost>());
    });

    test('未知 OpCode 返回 FtmsStatusUnknown', () {
      final event = FtmsStatusParser.parse(Uint8List.fromList([0x42]));
      expect(event, isA<FtmsStatusUnknown>());
      expect((event as FtmsStatusUnknown).opCode, 0x42);
    });

    test('空数据返回 FtmsStatusUnknown(0)', () {
      final event = FtmsStatusParser.parse(Uint8List(0));
      expect(event, isA<FtmsStatusUnknown>());
      expect((event as FtmsStatusUnknown).opCode, 0);
    });

    test('parseTrainingStatus', () {
      // Flags bit0=1 (存在), status=0x0D(running)
      final status = FtmsStatusParser.parseTrainingStatus(
          Uint8List.fromList([0x01, 0x0D]));
      expect(status, FtmsTrainingStatus.running);
    });

    test('parseTrainingStatus flags bit0=0 返回 unknown', () {
      final status = FtmsStatusParser.parseTrainingStatus(
          Uint8List.fromList([0x00, 0x0D]));
      expect(status, FtmsTrainingStatus.unknown);
    });
  });
}
