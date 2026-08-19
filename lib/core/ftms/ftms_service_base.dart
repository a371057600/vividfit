import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'ftms_command_builder.dart';
import 'ftms_control_response.dart';
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
  StreamSubscription<List<int>>? _responseSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  final _dataController = StreamController<FtmsDeviceData>.broadcast();
  final _statusController = StreamController<FtmsStatusEvent>.broadcast();
  final _responseController = StreamController<FtmsControlResponse>.broadcast();

  /// 解析后的实时数据流。
  Stream<FtmsDeviceData> get dataStream => _dataController.stream;

  /// 设备状态事件流(0x2ADA)。
  Stream<FtmsStatusEvent> get statusStream => _statusController.stream;

  /// 控制点回执流(0x2AD9 Response)。
  Stream<FtmsControlResponse> get responseStream => _responseController.stream;

  /// 设备连接状态流(断连监听用)。
  ///
  /// 未连接设备时返回空流,调用方无需判空。
  Stream<BluetoothConnectionState> get connectionStateStream {
    final device = _device;
    if (device == null) return const Stream.empty();
    return device.connectionState;
  }

  /// 当前是否已连接并发现服务。
  bool get isReady =>
      _device != null &&
      _dataCharacteristic != null &&
      _controlCharacteristic != null;

  /// 是否已收到首个数据包(Layer 2 就绪标记)。
  bool _hasReceivedFirstData = false;
  
  /// 首个数据到达回调(供 Notifier 处理 Layer 2 就绪)。
  void Function(FtmsDeviceData data)? onDataReady;

  /// 是否已收到首个数据包(供外部检查 Layer 2 状态)。
  bool get hasReceivedFirstData => _hasReceivedFirstData;

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
    debugPrint('[FTMS] connect begin, deviceType=$deviceType, id=${device.remoteId}');
    try {
      _device = device;
      final services = await device.discoverServices();
      debugPrint('[FTMS] discovered ${services.length} services');

      _ftmsService = services.firstWhere(
        (s) => s.uuid == FtmsUuids.service,
        orElse: () {
          debugPrint('[FTMS] FTMS service 0x1826 NOT FOUND in discovered services');
          throw Exception('FTMS service not found');
        },
      );
      debugPrint('[FTMS] FTMS service 0x1826 found, characteristics: ${_ftmsService!.characteristics.length}');

      _dataCharacteristic = _findCharacteristic(deviceType.dataCharacteristicUuid);
      debugPrint('[FTMS] data characteristic found: ${deviceType.dataCharacteristicUuid}');

      _controlCharacteristic = _findCharacteristic(FtmsUuids.controlPoint);
      debugPrint('[FTMS] control characteristic found: 0x2AD9');

      _statusCharacteristic = _findCharacteristic(FtmsUuids.machineStatus);
      debugPrint('[FTMS] status characteristic found: 0x2ADA');

      await _subscribeData();
      debugPrint('[FTMS] data subscription enabled');

      await _subscribeStatus();
      debugPrint('[FTMS] status subscription enabled');

      await _subscribeControlResponse();

      debugPrint('[FTMS] === FTMS CONNECTED & READY ===');
      return true;
    } catch (e) {
      debugPrint('[FTMS] connect FAILED: $e');
      return false;
    }
  }

  /// 断开订阅(不断开蓝牙连接,连接由上层管理)。
  Future<void> disconnect() async {
    debugPrint('[FTMS] === disconnect BEGIN ===');
    _hasReceivedFirstData = false;
    onDataReady = null;

    await _dataSubscription?.cancel();
    await _statusSubscription?.cancel();
    await _responseSubscription?.cancel();
    await _connectionStateSubscription?.cancel();
    _dataSubscription = null;
    _statusSubscription = null;
    _responseSubscription = null;
    _connectionStateSubscription = null;
    debugPrint('[FTMS] ✅ subscriptions cancelled');

    try {
      await _dataCharacteristic?.setNotifyValue(false);
      await _statusCharacteristic?.setNotifyValue(false);
      debugPrint('[FTMS] ✅ notify values disabled');
    } catch (e) {
      debugPrint('[FTMS] disconnect setNotifyValue warning: $e');
    }

    await _dataController.close();
    await _statusController.close();
    await _responseController.close();

    // 清空所有特征值与服务引用,确保 dispose 后 isReady 返回 false。
    // 防止持有旧引用的调用方(如未刷新的 dispatcher)误判为可用而写入失效特征值。
    _dataCharacteristic = null;
    _controlCharacteristic = null;
    _statusCharacteristic = null;
    _ftmsService = null;
    _device = null;
    debugPrint('[FTMS] === disconnect END ===');
  }

  // ---- 写入控制指令 ----

  /// 请求控制权限。
  Future<void> requestControl() {
    debugPrint('[FTMS] >>> requestControl (0x00)');
    return _writeControl(FtmsCommandBuilder.requestControl());
  }

  /// 重置设备。
  Future<void> reset() {
    debugPrint('[FTMS] >>> reset (0x01)');
    return _writeControl(FtmsCommandBuilder.reset());
  }

  /// 开始/恢复运动。
  Future<void> startOrResume() {
    debugPrint('[FTMS] >>> startOrResume (0x07)');
    return _writeControl(FtmsCommandBuilder.startOrResume());
  }

  /// 停止运动。
  Future<void> stop() {
    debugPrint('[FTMS] >>> stop (0x08, control=0x01)');
    return _writeControl(FtmsCommandBuilder.stop());
  }

  /// 暂停运动。
  Future<void> pause() {
    debugPrint('[FTMS] >>> pause (0x08, control=0x02)');
    return _writeControl(FtmsCommandBuilder.pause());
  }

  /// 设置目标速度(km/h)。
  Future<void> setTargetSpeed(double speedKmPerH) {
    debugPrint('[FTMS] >>> setTargetSpeed ${speedKmPerH}km/h (0x02)');
    return _writeControl(FtmsCommandBuilder.setTargetSpeed(speedKmPerH));
  }

  /// 设置目标坡度(%)。
  Future<void> setTargetInclination(double inclinePercent) {
    debugPrint('[FTMS] >>> setTargetInclination ${inclinePercent}% (0x03)');
    return _writeControl(
        FtmsCommandBuilder.setTargetInclination(inclinePercent));
  }

  /// 设置目标阻力等级。
  Future<void> setTargetResistance(double level) {
    debugPrint('[FTMS] >>> setTargetResistance level=$level (0x04)');
    return _writeControl(FtmsCommandBuilder.setTargetResistance(level));
  }

  /// 设置目标功率(瓦)。
  Future<void> setTargetPower(int watts) {
    debugPrint('[FTMS] >>> setTargetPower ${watts}W (0x05)');
    return _writeControl(FtmsCommandBuilder.setTargetPower(watts));
  }

  /// 写入控制点(Control Point 0x2AD9)原始字节。
  ///
  /// 供 [FtmsCommandDispatcher] 等外部调度器直接下发已构建的指令字节。
  Future<void> writeControlPoint(List<int> data) => _writeControl(data);

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
    if (_dataCharacteristic == null) {
      debugPrint('[FTMS] _subscribeData: dataCharacteristic is null, skip');
      return;
    }
    debugPrint('[FTMS] subscribing data characteristic: ${deviceType.dataCharacteristicUuid}');
    // 使用 onValueReceived：仅接收订阅后真实到达的帧，
    // 避免 lastValueStream 缓存重放旧帧导致「假就绪」（Layer 2 误触发）
    _dataSubscription = _dataCharacteristic!.onValueReceived.listen((data) {
      final parsed = _parser.parse(Uint8List.fromList(data));
      debugPrint('[FTMS] 📊 data: speed=${parsed.instSpeed}km/h, cadence=${parsed.instCadence}rpm, hr=${parsed.hr}bpm, distance=${parsed.distTotal}m, energy=${parsed.energyTotal}kcal');
      
      // 触发 Layer 2 就绪通知(首次数据到达)
      if (!_hasReceivedFirstData) {
        _hasReceivedFirstData = true;
        debugPrint('[FTMS] ✅ === FIRST DATA RECEIVED (Layer 2 Ready) ===');
        onDataReady?.call(parsed);
      }
      
      if (!_dataController.isClosed) _dataController.add(parsed);
    });
    _device?.cancelWhenDisconnected(_dataSubscription!);
    await _dataCharacteristic!.setNotifyValue(true);
    debugPrint('[FTMS] ✅ data subscription enabled');
  }

  Future<void> _subscribeStatus() async {
    if (_statusCharacteristic == null) {
      debugPrint('[FTMS] _subscribeStatus: statusCharacteristic is null, skip');
      return;
    }
    debugPrint('[FTMS] subscribing status characteristic: ${FtmsUuids.machineStatus}');
    // onValueReceived：仅接收新帧，防止缓存重放（同 _subscribeData）
    _statusSubscription = _statusCharacteristic!.onValueReceived.listen((data) {
      final event = FtmsStatusParser.parse(Uint8List.fromList(data));
      debugPrint('[FTMS] 🔔 status: ${event.runtimeType}');
      if (!_statusController.isClosed) _statusController.add(event);
    });
    _device?.cancelWhenDisconnected(_statusSubscription!);
    await _statusCharacteristic!.setNotifyValue(true);
    debugPrint('[FTMS] ✅ status subscription enabled');
  }

  /// 订阅控制点回执(0x2AD9 Indicate)。
  ///
  /// 设备对控制指令的执行结果会通过 Indicate 回执:
  /// 格式为 `[0x80, requestOpCode, resultCode]`,由
  /// [FtmsControlResponse.tryParse] 解析后广播到 [responseStream]。
  ///
  /// 设备不支持 Indicate 时不抛异常,由 0x2ADA 状态事件兜底。
  Future<void> _subscribeControlResponse() async {
    if (_controlCharacteristic == null) {
      debugPrint('[FTMS] _subscribeControlResponse: controlCharacteristic is null, skip');
      return;
    }

    // 控制点回执依赖 Indicate 属性,不支持时降级处理(不抛异常)
    if (!_controlCharacteristic!.properties.indicate) {
      debugPrint('[FTMS] ⚠️ control point 不支持 Indicate，回执监听降级（由 0x2ADA 事件兜底）');
      return;
    }

    debugPrint('[FTMS] subscribing control response: ${FtmsUuids.controlPoint}');
    // onValueReceived：仅接收新帧，防止缓存重放（同 _subscribeData）
    _responseSubscription = _controlCharacteristic!.onValueReceived.listen((data) {
      final response = FtmsControlResponse.tryParse(Uint8List.fromList(data));
      if (response == null) return;
      debugPrint('[FTMS] 📩 control response: request=0x${response.requestOpCode.toRadixString(16)}, result=${response.resultCode}');
      if (!_responseController.isClosed) _responseController.add(response);
    });
    _device?.cancelWhenDisconnected(_responseSubscription!);
    await _controlCharacteristic!.setNotifyValue(true);
    debugPrint('[FTMS] ✅ control response subscription enabled');
  }

  Future<void> _writeControl(List<int> data) async {
    if (_controlCharacteristic == null) {
      debugPrint('[FTMS] _writeControl: controlCharacteristic is null, THROW');
      throw StateError('Control characteristic not available');
    }
    debugPrint('[FTMS] _writeControl: opcode=${data[0].toRadixString(16)}, data=${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(',')}');
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
