import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'ftms_command_builder.dart';
import 'ftms_data_parser_base.dart';
import 'ftms_device_data.dart';
import 'ftms_device_type.dart';
import 'ftms_status_parser.dart';
import 'ftms_uuids.dart';

/// FTMS 服务抽象基类。
///
/// 封装对 FTMS 设备的通用操作:
/// - 服务发现与特征值查找
/// - 订阅实时数据(Notify)
/// - 订阅状态通知(Notify)
/// - 写入控制指令(Write)
/// - 读取特征值(Feature/Range/TrainingStatus)
///
/// 由 [FtmsServiceFactory] 根据设备类型创建具体实例。
///
/// **零业务依赖**:此基类仅依赖 flutter_blue_plus,可独立复用。
abstract class FtmsServiceBase {
  FtmsServiceBase(this.deviceType) : _parser = deviceType.createParser();

  /// 设备类型。
  final FtmsDeviceType deviceType;

  /// 数据解析器(由设备类型决定)。
  final FtmsDataParserBase _parser;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _dataCharacteristic;
  BluetoothCharacteristic? _controlCharacteristic;
  BluetoothCharacteristic? _statusCharacteristic;
  BluetoothService? _ftmsService;

  StreamSubscription<List<int>>? _dataSubscription;
  StreamSubscription<List<int>>? _statusSubscription;

  final _dataController = StreamController<FtmsDeviceData>.broadcast();
  final _statusController = StreamController<FtmsStatusEvent>.broadcast();

  /// 解析后的实时数据流。
  Stream<FtmsDeviceData> get dataStream => _dataController.stream;

  /// 设备状态事件流(0x2ADA)。
  Stream<FtmsStatusEvent> get statusStream => _statusController.stream;

  /// 当前是否已连接并发现服务。
  bool get isReady =>
      _device != null &&
      _dataCharacteristic != null &&
      _controlCharacteristic != null;

  /// 连接设备并发现 FTMS 服务。
  ///
  /// 步骤:
  /// 1. 发现服务
  /// 2. 查找 FTMS 服务(0x1826)
  /// 3. 查找数据特征值(设备特定 Notify)
  /// 4. 查找控制点特征值(0x2AD9 Write)
  /// 5. 查找状态通知特征值(0x2ADA Notify)
  /// 6. 开启 Notify
  Future<bool> connect(BluetoothDevice device) async {
    try {
      _device = device;
      final services = await device.discoverServices();

      _ftmsService = services.firstWhere(
        (s) => s.uuid == FtmsUuids.service,
        orElse: () => throw Exception('FTMS service not found'),
      );

      _dataCharacteristic = _findCharacteristic(deviceType.dataCharacteristicUuid);
      _controlCharacteristic = _findCharacteristic(FtmsUuids.controlPoint);
      _statusCharacteristic = _findCharacteristic(FtmsUuids.machineStatus);

      await _subscribeData();
      await _subscribeStatus();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 断开订阅(不断开蓝牙连接,连接由上层管理)。
  Future<void> disconnect() async {
    await _dataSubscription?.cancel();
    await _statusSubscription?.cancel();
    _dataSubscription = null;
    _statusSubscription = null;

    try {
      await _dataCharacteristic?.setNotifyValue(false);
      await _statusCharacteristic?.setNotifyValue(false);
    } catch (_) {}

    _dataController.close();
    _statusController.close();
  }

  // ---- 写入控制指令 ----

  /// 请求控制权限。
  Future<void> requestControl() =>
      _writeControl(FtmsCommandBuilder.requestControl());

  /// 重置设备。
  Future<void> reset() => _writeControl(FtmsCommandBuilder.reset());

  /// 开始/恢复运动。
  Future<void> startOrResume() =>
      _writeControl(FtmsCommandBuilder.startOrResume());

  /// 停止运动。
  Future<void> stop() => _writeControl(FtmsCommandBuilder.stop());

  /// 暂停运动。
  Future<void> pause() => _writeControl(FtmsCommandBuilder.pause());

  /// 设置目标速度(km/h)。
  Future<void> setTargetSpeed(double speedKmPerH) =>
      _writeControl(FtmsCommandBuilder.setTargetSpeed(speedKmPerH));

  /// 设置目标坡度(%)。
  Future<void> setTargetInclination(double inclinePercent) =>
      _writeControl(
          FtmsCommandBuilder.setTargetInclination(inclinePercent));

  /// 设置目标阻力等级。
  Future<void> setTargetResistance(double level) =>
      _writeControl(FtmsCommandBuilder.setTargetResistance(level));

  /// 设置目标功率(瓦)。
  Future<void> setTargetPower(int watts) =>
      _writeControl(FtmsCommandBuilder.setTargetPower(watts));

  // ---- 读取特征值 ----

  /// 读取设备能力特征(0x2ACC)。
  Future<List<int>?> readFeature() =>
      _readCharacteristic(FtmsUuids.feature);

  /// 读取支持的速度范围(0x2AD4)。
  Future<List<int>?> readSpeedRange() =>
      _readCharacteristic(FtmsUuids.speedRange);

  /// 读取支持的坡度范围(0x2AD5)。
  Future<List<int>?> readInclinationRange() =>
      _readCharacteristic(FtmsUuids.inclinationRange);

  /// 读取支持的阻力范围(0x2AD6)。
  Future<List<int>?> readResistanceRange() =>
      _readCharacteristic(FtmsUuids.resistanceRange);

  /// 读取支持的功率范围(0x2AD8)。
  Future<List<int>?> readPowerRange() =>
      _readCharacteristic(FtmsUuids.powerRange);

  /// 读取训练状态(0x2AD3)。
  Future<FtmsTrainingStatus> readTrainingStatus() async {
    final data = await _readCharacteristic(FtmsUuids.trainingState);
    if (data == null) return FtmsTrainingStatus.unknown;
    return FtmsStatusParser.parseTrainingStatus(Uint8List.fromList(data));
  }

  // ---- 内部方法 ----

  BluetoothCharacteristic _findCharacteristic(Guid uuid) {
    return _ftmsService!.characteristics.firstWhere(
      (c) => c.uuid == uuid,
      orElse: () => throw Exception('Characteristic not found: $uuid'),
    );
  }

  Future<void> _subscribeData() async {
    if (_dataCharacteristic == null) return;
    _dataSubscription = _dataCharacteristic!.lastValueStream.listen((data) {
      final parsed = _parser.parse(Uint8List.fromList(data));
      if (!_dataController.isClosed) _dataController.add(parsed);
    });
    _device?.cancelWhenDisconnected(_dataSubscription!);
    await _dataCharacteristic!.setNotifyValue(true);
  }

  Future<void> _subscribeStatus() async {
    if (_statusCharacteristic == null) return;
    _statusSubscription = _statusCharacteristic!.lastValueStream.listen((data) {
      final event = FtmsStatusParser.parse(Uint8List.fromList(data));
      if (!_statusController.isClosed) _statusController.add(event);
    });
    _device?.cancelWhenDisconnected(_statusSubscription!);
    await _statusCharacteristic!.setNotifyValue(true);
  }

  Future<void> _writeControl(List<int> data) async {
    if (_controlCharacteristic == null) {
      throw StateError('Control characteristic not available');
    }
    await _controlCharacteristic!.write(data, withoutResponse: true);
  }

  Future<List<int>?> _readCharacteristic(Guid uuid) async {
    try {
      if (_ftmsService == null) return null;
      final ch = _findCharacteristic(uuid);
      return await ch.read();
    } catch (_) {
      return null;
    }
  }
}
