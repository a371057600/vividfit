import 'package:flutter/foundation.dart';

import 'ftms_control_config.dart';
import 'ftms_device_type.dart';
import 'ftms_service_base.dart';

/// 设备能力读取器。
///
/// 从蓝牙 GATT 特征值读取设备支持的控制参数范围：
/// - 速度：0x2AD4 Supported Speed Range（uint16 ×3，单位 0.01 km/h → ÷100）
/// - 坡度：0x2AD5 Supported Inclination Range（sint16 ×3，单位 0.1% → ÷10）
/// - 阻力：0x2AD6 Supported Resistance Level Range（sint16 ×3，÷10 换算）
///
/// 读取流程：
/// 1. 按设备类型仅读取其支持的维度（跑步机读速度+坡度，其余读阻力）
/// 2. 某维度特征值不存在时跳过该维度（回退默认配置）
/// 3. 全部失败时返回默认配置（降级，不抛异常）
class FtmsDeviceCapabilityReader {
  final FtmsServiceBase _service;

  FtmsDeviceCapabilityReader(this._service);

  /// 读取设备能力并生成配置（单维度失败自动回退默认，不抛异常）。
  Future<FtmsControlConfig> readCapabilities(FtmsDeviceType deviceType) async {
    final fallback = defaultConfigFor(deviceType);

    // 按设备类型决定读取哪些维度
    final readSpeed = deviceType.supportsSpeedControl;
    final readInclination = deviceType.supportsInclinationControl;
    final readResistance = deviceType.supportsResistanceControl;

    var speedCfg = fallback.speed;
    var inclCfg = fallback.inclination;
    var resCfg = fallback.resistance;
    var anyFromDevice = false;

    // —— 速度范围 ——
    if (readSpeed) {
      try {
        final data = await _service.readSpeedRange();
        if (data != null && data.length >= 6) {
          final min = _readUint16LE(data, 0) / 100;
          final max = _readUint16LE(data, 2) / 100;
          final step = _readUint16LE(data, 4) / 100;
          speedCfg = ControlConfig.fromDeviceCapabilities(
            min: min,
            max: max,
            step: step,
          );
          anyFromDevice = true;
          debugPrint(
            '[CapabilityReader] 📏 速度范围(0x2AD4): min=$min, max=$max, '
            'step=$step km/h',
          );
        } else {
          debugPrint('[CapabilityReader] ⚠️ 速度范围特征值为空，回退默认');
        }
      } catch (e) {
        debugPrint('[CapabilityReader] ⚠️ 速度范围读取失败（设备不支持）: $e');
      }
    }

    // —— 坡度范围 ——
    if (readInclination) {
      try {
        final data = await _service.readInclinationRange();
        if (data != null && data.length >= 6) {
          final min = _readSint16LE(data, 0) / 10;
          final max = _readSint16LE(data, 2) / 10;
          final step = _readUint16LE(data, 4) / 10;
          inclCfg = ControlConfig.fromDeviceCapabilities(
            min: min,
            max: max,
            step: step,
          );
          anyFromDevice = true;
          debugPrint(
            '[CapabilityReader] 📏 坡度范围(0x2AD5): min=$min, max=$max, '
            'step=$step %',
          );
        } else {
          debugPrint('[CapabilityReader] ⚠️ 坡度范围特征值为空，回退默认');
        }
      } catch (e) {
        debugPrint('[CapabilityReader] ⚠️ 坡度范围读取失败（设备不支持）: $e');
      }
    }

    // —— 阻力范围 ——
    if (readResistance) {
      try {
        final data = await _service.readResistanceRange();
        if (data != null && data.length >= 6) {
          final min = _readSint16LE(data, 0) / 10;
          final max = _readSint16LE(data, 2) / 10;
          final step = _readUint16LE(data, 4) / 10;
          resCfg = ControlConfig.fromDeviceCapabilities(
            min: min,
            max: max,
            step: step,
          );
          anyFromDevice = true;
          debugPrint(
            '[CapabilityReader] 📏 阻力范围(0x2AD6): min=$min, max=$max, '
            'step=$step',
          );
        } else {
          debugPrint('[CapabilityReader] ⚠️ 阻力范围特征值为空，回退默认');
        }
      } catch (e) {
        debugPrint('[CapabilityReader] ⚠️ 阻力范围读取失败（设备不支持）: $e');
      }
    }

    return FtmsControlConfig(
      speed: speedCfg,
      inclination: inclCfg,
      resistance: resCfg,
      source:
          anyFromDevice ? ConfigSource.fromDevice : ConfigSource.defaults,
    );
  }

  // ---- 字节解析辅助 ----

  /// 小端 uint16 读取。
  static int _readUint16LE(List<int> data, int offset) =>
      data[offset] | (data[offset + 1] << 8);

  /// 小端 sint16 读取（二补码转有符号）。
  static int _readSint16LE(List<int> data, int offset) {
    final v = _readUint16LE(data, offset);
    return v >= 0x8000 ? v - 0x10000 : v;
  }
}
