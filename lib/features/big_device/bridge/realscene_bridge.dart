import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';

part 'realscene_bridge.g.dart';

// ============================================================================
// 数据类：500ms 周期上报给 WebView 的运动数据
// 严格对应旧版 4 个 realscene 页面的 JSON 字段，字段命名一字不差
// ============================================================================

/// 实景模式上行运动数据。
///
/// 按设备类型序列化时自动切换字段：
///   - 单车 / 跑步机 / 椭圆机：speed/cadence 正常填充，strokeRate/totalStrokes 为 null（不输出到 JSON）
///   - 划船机：speed/cadence 固定输出字符串 "0"，追加 strokeRate + totalStrokes
class RealsceneSportData {
  RealsceneSportData({
    required this.instantaneousSpeed,
    required this.instantaneousCadence,
    required this.totalDistance,
    required this.totalEnergy,
    required this.elapsedTime,
    required this.heartRate,
    this.strokeRate,
    this.totalStrokes,
  });

  final double instantaneousSpeed;
  final double instantaneousCadence;
  final double totalDistance;
  final double totalEnergy;

  /// "mm:ss" 格式字符串或秒数字符串，对齐旧版。
  final String elapsedTime;
  final int heartRate;

  // === 划船机专用字段（非划船机保持 null，toJson 时不包含）===
  final double? strokeRate;
  final double? totalStrokes;

  /// 按设备类型生成上报给 Unity WebGL 的 JSON Map。
  Map<String, dynamic> toUnityJson(FtmsDeviceType deviceType) {
    final isRower = deviceType == FtmsDeviceType.rower;
    final map = <String, dynamic>{};

    // speed / cadence：划船机强制字符串 "0"
    if (isRower) {
      map['instantaneousSpeed'] = '0';
      map['instantaneousCadence'] = '0';
    } else {
      map['instantaneousSpeed'] = instantaneousSpeed.toStringAsFixed(2);
      map['instantaneousCadence'] = instantaneousCadence.toStringAsFixed(2);
    }

    map['totalDistance'] = totalDistance.toStringAsFixed(2);
    map['totalEnergy'] = totalEnergy.toStringAsFixed(2);
    map['elapsedTime'] = elapsedTime;
    map['heartRate'] = heartRate;

    // 划船机追加字段
    if (isRower && strokeRate != null) {
      map['strokeRate'] = strokeRate!.toStringAsFixed(2);
    }
    if (isRower && totalStrokes != null) {
      map['totalStrokes'] = totalStrokes!.toStringAsFixed(2);
    }

    return map;
  }
}

// ============================================================================
// 抽象桥接接口：WebView 页面 与 设备(蓝牙/模拟) 解耦
// 页面永远只依赖 RealsceneBridge，不直接接触 FTMS / flutter_blue_plus
// ============================================================================

/// 实景模式桥接抽象接口。
///
/// 接入蓝牙阶段只需新增 `FtmsRealsceneBridge` 一个实现类替换 Mock，
/// `RealsceneWebViewScaffold` 代码零修改。
abstract class RealsceneBridge {
  // === Web → 设备（下行控制） ===

  /// 开始运动。对应 Web 指令 07。
  /// 蓝牙阶段：→ GymDeviceConnectNotifier.ftmsService.startOrResume()
  Future<void> startSport();

  /// 停止运动。对应 Web 指令 08。
  /// 蓝牙阶段：→ GymDeviceConnectNotifier.ftmsService.pauseOrStop()
  Future<void> stopSport();

  /// 设置坡度/阻力档位。对应 Web gradient.drag。
  /// 蓝牙阶段：→ 根据设备类型选择 setResistance / setInclination / manualSendInclination
  Future<void> setGradientLevel(int level);

  /// 设备是否已连接并能上报数据（flagetoSendData 总开关）。
  /// 蓝牙阶段：判断 GymDeviceConnectState.connectionStep == dataReady
  bool get isDeviceReady;

  // === 设备 → Web（上行数据） ===

  /// 500ms 周期发射的运动数据 Stream（上层订阅后转 JS 注入）。
  Stream<RealsceneSportData> get sportDataStream;

  /// 暂停事件流（hc.isPause 变为 true 时发射一次，触发 0x02 推送）。
  Stream<bool> get pauseEventStream;

  // === 生命周期 ===

  /// 页面 dispose 时必须同步调用，否则 Timer/Stream/Timer 泄漏。
  void dispose();
}

// ============================================================================
// Mock 默认实现：无蓝牙阶段 500ms 自增假数据驱动 Web 场景画面
// ============================================================================

class MockRealsceneBridge implements RealsceneBridge {
  MockRealsceneBridge(this.deviceType);

  final FtmsDeviceType deviceType;

  final StreamController<RealsceneSportData> _sportCtrl =
      StreamController<RealsceneSportData>.broadcast();
  final StreamController<bool> _pauseCtrl = StreamController<bool>.broadcast();
  Timer? _timer;

  // === 模拟数据累加器 ===
  double _mockDistance = 0;
  double _mockEnergy = 0;
  int _mockElapsedSec = 0;
  double _mockCadence = 80;
  double _mockSpeed = 22;
  double _mockStrokeRate = 30;
  double _mockTotalStrokes = 0;

  // === RealsceneBridge 实现 ===

  @override
  bool get isDeviceReady => true;

  @override
  Stream<RealsceneSportData> get sportDataStream => _sportCtrl.stream;

  @override
  Stream<bool> get pauseEventStream => _pauseCtrl.stream;

  @override
  Future<void> startSport() async {
    debugPrintBridge('startSport() called — 开启 500ms Mock 数据推送');
    _startMockTicker();
  }

  @override
  Future<void> stopSport() async {
    debugPrintBridge('stopSport() called — 停止 Mock 数据推送');
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> setGradientLevel(int level) async {
    // TODO(蓝牙接入): 改为调用对应 FTMS 指令
    //   单车：setResistance(level)
    //   跑步机/椭圆机：setInclination(level) 或 manualSendInclination(level)
    debugPrintBridge('setGradientLevel(level=$level) — 暂存 Mock，蓝牙阶段下发设备');
  }

  @override
  void dispose() {
    debugPrintBridge('dispose() — 释放 Timer/StreamController');
    _timer?.cancel();
    _timer = null;
    _sportCtrl.close();
    _pauseCtrl.close();
  }

  // === Mock 内部 ===

  void _startMockTicker() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      // 每次 tick 累加 500ms 当量
      _mockElapsedSec += 1; // 2 tick/s → 我们按 1s/tick 等效加速推进画面
      _mockDistance += 5.0; // 5m/step
      _mockEnergy += 0.2; // 0.2 kcal/step
      _mockCadence = 75 + _mockCadence % 20; // 75~95 波动
      _mockSpeed = 20 + (_mockSpeed + 1) % 8; // 20~27 km/h 波动

      final rower = deviceType == FtmsDeviceType.rower;
      if (rower) {
        _mockStrokeRate = 25 + (_mockStrokeRate + 1) % 15;
        _mockTotalStrokes += 1.0;
      }

      final data = RealsceneSportData(
        instantaneousSpeed: _mockSpeed,
        instantaneousCadence: _mockCadence,
        totalDistance: _mockDistance,
        totalEnergy: _mockEnergy,
        elapsedTime: _formatElapsed(_mockElapsedSec),
        heartRate: 110 + (_mockElapsedSec % 30),
        strokeRate: rower ? _mockStrokeRate : null,
        totalStrokes: rower ? _mockTotalStrokes : null,
      );

      if (!_sportCtrl.isClosed) _sportCtrl.add(data);
    });
  }

  static String _formatElapsed(int totalSec) {
    final mm = (totalSec ~/ 60).toString().padLeft(2, '0');
    final ss = (totalSec % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void debugPrintBridge(String msg) {
    // ignore: avoid_print
    print('📡 [RealsceneBridge-Mock/$deviceType] $msg');
  }
}

// ============================================================================
// Riverpod Provider：按设备类型提供 Bridge 实例
// ============================================================================

@Riverpod(dependencies: <Object>[])
RealsceneBridge realsceneBridge(
  Ref ref, {
  required FtmsDeviceType deviceType,
}) {
  // TODO(蓝牙接入): 切换为 FtmsRealsceneBridge，订阅 GymDeviceConnectNotifier
  //   return FtmsRealsceneBridge(deviceType, ref);
  // 当前阶段固定返回 Mock：
  final bridge = MockRealsceneBridge(deviceType);
  ref.onDispose(bridge.dispose);
  return bridge;
}

// ignore: unused_element
String _unusedJsonImportReference() => jsonEncode(<String, dynamic>{});
