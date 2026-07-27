import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/ftms/ftms_device_type.dart';
import 'package:vividfit_v2/core/ftms/ftms_service_factory.dart';
import 'package:vividfit_v2/core/ftms/ftms_service_base.dart';
import 'package:vividfit_v2/core/ftms/parsers/indoor_bike_parser.dart';
import 'package:vividfit_v2/core/ftms/parsers/treadmill_parser.dart';
import 'package:vividfit_v2/core/ftms/parsers/cross_trainer_parser.dart';
import 'package:vividfit_v2/core/ftms/parsers/rower_parser.dart';

void main() {
  group('FtmsDeviceType', () {
    test('value 映射正确', () {
      expect(FtmsDeviceType.indoorBike.value, 0);
      expect(FtmsDeviceType.treadmill.value, 1);
      expect(FtmsDeviceType.crossTrainer.value, 2);
      expect(FtmsDeviceType.rower.value, 3);
      expect(FtmsDeviceType.strengthStation.value, 4);
    });

    test('fromValue 反向映射', () {
      expect(FtmsDeviceType.fromValue(0), FtmsDeviceType.indoorBike);
      expect(FtmsDeviceType.fromValue(1), FtmsDeviceType.treadmill);
      expect(FtmsDeviceType.fromValue(2), FtmsDeviceType.crossTrainer);
      expect(FtmsDeviceType.fromValue(3), FtmsDeviceType.rower);
      expect(FtmsDeviceType.fromValue(4), FtmsDeviceType.strengthStation);
    });

    test('fromValue 非法值默认 indoorBike', () {
      expect(FtmsDeviceType.fromValue(99), FtmsDeviceType.indoorBike);
    });

    test('每个类型都能创建对应的解析器', () {
      expect(FtmsDeviceType.indoorBike.createParser(), isA<IndoorBikeParser>());
      expect(FtmsDeviceType.treadmill.createParser(), isA<TreadmillParser>());
      expect(
          FtmsDeviceType.crossTrainer.createParser(), isA<CrossTrainerParser>());
      expect(FtmsDeviceType.rower.createParser(), isA<RowerParser>());
      expect(FtmsDeviceType.strengthStation.createParser(),
          isA<IndoorBikeParser>());
    });

    test('能力配置正确', () {
      expect(FtmsDeviceType.treadmill.supportsSpeedControl, true);
      expect(FtmsDeviceType.indoorBike.supportsSpeedControl, true);
      expect(FtmsDeviceType.rower.supportsSpeedControl, false);

      expect(FtmsDeviceType.treadmill.supportsInclinationControl, true);
      expect(FtmsDeviceType.crossTrainer.supportsInclinationControl, true);
      expect(FtmsDeviceType.indoorBike.supportsInclinationControl, false);

      expect(FtmsDeviceType.indoorBike.supportsResistanceControl, true);
      expect(FtmsDeviceType.rower.supportsResistanceControl, true);
      expect(FtmsDeviceType.crossTrainer.supportsResistanceControl, true);
    });

    test('dataCharacteristicUuid 映射正确', () {
      // 只需验证不为空且类型正确
      expect(FtmsDeviceType.indoorBike.dataCharacteristicUuid.toString().isNotEmpty, true);
      expect(FtmsDeviceType.treadmill.dataCharacteristicUuid.toString().isNotEmpty, true);
    });
  });

  group('FtmsServiceFactory', () {
    test('create 返回 FtmsServiceBase 实例', () {
      final service = FtmsServiceFactory.create(FtmsDeviceType.indoorBike);
      expect(service, isA<FtmsServiceBase>());
      expect(service.deviceType, FtmsDeviceType.indoorBike);
      expect(service.isReady, false);
    });

    test('fromValue 按数值创建', () {
      final service = FtmsServiceFactory.fromValue(1);
      expect(service.deviceType, FtmsDeviceType.treadmill);
    });

    test('5 种类型均可创建', () {
      for (final type in FtmsDeviceType.values) {
        final service = FtmsServiceFactory.create(type);
        expect(service, isA<FtmsServiceBase>());
        expect(service.deviceType, type);
      }
    });
  });
}
