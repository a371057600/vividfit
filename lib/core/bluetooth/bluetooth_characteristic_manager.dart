import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../ftms/ftms_device_type.dart';
import '../ftms/ftms_uuids.dart';

/// 蓝牙特征值管理器。
///
/// 连接成功后发现 FTMS 服务,按设备类型订阅特征值,管理 `StreamSubscription` 生命周期。
///
/// **职责**:
/// - 发现服务,查找 FTMS 服务(0x1826)
/// - 订阅实时数据特征值(0x2AD2/2ACD/2ACE/2AD1)→ [onDataReceived]
/// - 订阅控制点回包(0x2AD9 `lastValueStream`)→ [onWriteResponse]
/// - 订阅设备状态(0x2ADA)→ [onMachineStatus]
/// - 提供 [writeCommand] 写入 0x2AD9
/// - 提供 [readTrainingStatus] 读取 0x2AD3
///
/// **零业务依赖**: 仅依赖 `flutter_blue_plus` + `lib/core/ftms/`。
class BluetoothCharacteristicManager {
  BluetoothCharacteristicManager(this.deviceType);

  /// 当前设备类型,决定订阅哪个实时数据特征值。
  final FtmsDeviceType deviceType;

  BluetoothDevice? _device;
  BluetoothService? _ftmsService;
  BluetoothCharacteristic? _dataCharacteristic;
  BluetoothCharacteristic? _controlCharacteristic;
  BluetoothCharacteristic? _statusCharacteristic;

  StreamSubscription<List<int>>? _dataSub;
  StreamSubscription<List<int>>? _controlSub;
  StreamSubscription<List<int>>? _statusSub;

  /// 实时数据回调(对应旧 `_writeValueStream` 之外的数据流)。
  void Function(List<int> data)? onDataReceived;

  /// 控制点回包回调(对应旧 `_writeValueStream`,0x80 前缀回包)。
  void Function(List<int> data)? onWriteResponse;

  /// 设备状态通知回调(对应旧 `bigDeviceStatus`,0x2ADA)。
  void Function(List<int> data)? onMachineStatus;

  /// 当前是否已就绪(服务发现 + 特征值查找完成)。
  bool get isReady =>
      _dataCharacteristic != null && _controlCharacteristic != null;

  /// 发现服务并订阅特征值。
  ///
  /// 在 `BluetoothConnectionService.connect()` 成功后调用。
  Future<bool> setup(BluetoothDevice device) async {
    try {
      _device = device;
      final services = await device.discoverServices();

      _ftmsService = services.firstWhere(
        (s) => s.uuid == FtmsUuids.service,
        orElse: () => throw Exception('FTMS service 0x1826 not found'),
      );

      _dataCharacteristic = _findCharacteristic(deviceType.dataCharacteristicUuid);
      _controlCharacteristic = _findCharacteristic(FtmsUuids.controlPoint);
      _statusCharacteristic = _findCharacteristic(FtmsUuids.machineStatus);

      await _subscribeData();
      await _subscribeControl();
      await _subscribeStatus();

      print('[CharacteristicManager] setup success, deviceType=$deviceType');
      return true;
    } catch (e) {
      print('[CharacteristicManager] setup failed: $e');
      return false;
    }
  }

  /// 写入控制指令到 0x2AD9。
  Future<void> writeCommand(Uint8List data) async {
    if (_controlCharacteristic == null) {
      throw StateError('Control characteristic 0x2AD9 not available');
    }
    await _controlCharacteristic!.write(data, withoutResponse: true);
  }

  /// 读取训练状态(0x2AD3)。
  Future<List<int>?> readTrainingStatus() async {
    if (_ftmsService == null) return null;
    try {
      final ch = _findCharacteristic(FtmsUuids.trainingState);
      return await ch.read();
    } catch (e) {
      print('[CharacteristicManager] readTrainingStatus failed: $e');
      return null;
    }
  }

  /// 读取坡度范围(0x2AD5)。
  Future<List<int>?> readInclinationRange() async {
    if (_ftmsService == null) return null;
    try {
      final ch = _findCharacteristic(FtmsUuids.inclinationRange);
      return await ch.read();
    } catch (_) {
      return null;
    }
  }

  /// 读取阻力范围(0x2AD6)。
  Future<List<int>?> readResistanceRange() async {
    if (_ftmsService == null) return null;
    try {
      final ch = _findCharacteristic(FtmsUuids.resistanceRange);
      return await ch.read();
    } catch (_) {
      return null;
    }
  }

  /// 释放所有订阅(不断开蓝牙连接,连接由 BluetoothConnectionService 管理)。
  Future<void> dispose() async {
    await _dataSub?.cancel();
    await _controlSub?.cancel();
    await _statusSub?.cancel();
    _dataSub = null;
    _controlSub = null;
    _statusSub = null;

    try {
      await _dataCharacteristic?.setNotifyValue(false);
      await _statusCharacteristic?.setNotifyValue(false);
    } catch (_) {}

    _dataCharacteristic = null;
    _controlCharacteristic = null;
    _statusCharacteristic = null;
    _ftmsService = null;
    _device = null;
    print('[CharacteristicManager] disposed');
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
    _dataSub = _dataCharacteristic!.lastValueStream.listen((data) {
      if (data.isNotEmpty) {
        onDataReceived?.call(data);
      }
    });
    _device?.cancelWhenDisconnected(_dataSub!);
    await _dataCharacteristic!.setNotifyValue(true);
    print('[CharacteristicManager] subscribed data: ${deviceType.dataCharacteristicUuid}');
  }

  Future<void> _subscribeControl() async {
    if (_controlCharacteristic == null) return;
    _controlSub = _controlCharacteristic!.lastValueStream.listen((data) {
      if (data.isNotEmpty) {
        onWriteResponse?.call(data);
      }
    });
    _device?.cancelWhenDisconnected(_controlSub!);
    // 0x2AD9 是 Write+Indicate,需要开启 indicate
    try {
      await _controlCharacteristic!.setNotifyValue(true);
    } catch (_) {}
    print('[CharacteristicManager] subscribed control: ${FtmsUuids.controlPoint}');
  }

  Future<void> _subscribeStatus() async {
    if (_statusCharacteristic == null) return;
    _statusSub = _statusCharacteristic!.lastValueStream.listen((data) {
      if (data.isNotEmpty) {
        onMachineStatus?.call(data);
      }
    });
    _device?.cancelWhenDisconnected(_statusSub!);
    await _statusCharacteristic!.setNotifyValue(true);
    print('[CharacteristicManager] subscribed status: ${FtmsUuids.machineStatus}');
  }
}
