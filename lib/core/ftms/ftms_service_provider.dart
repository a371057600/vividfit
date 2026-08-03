import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/bluetooth_connection_service_provider.dart';
import 'ftms_device_type.dart';
import 'ftms_service_base.dart';
import 'ftms_service_factory.dart';

part 'ftms_service_provider.g.dart';

/// 当前连接的 FTMS 服务(按设备类型创建)。
///
/// 依赖 [bluetoothConnectionServiceProvider] 提供 BluetoothDevice,
/// 调用方需先通过 [GymDeviceConnectNotifier] 完成蓝牙链路连接。
///
/// 当蓝牙设备连接成功时,此 Provider 自动创建对应设备类型的 FTMS 服务实例,
/// 并执行服务发现、特征值查找、数据/状态订阅。
///
/// 如果蓝牙未连接,返回 null。
@Riverpod(keepAlive: true)
FtmsServiceBase? ftmsService(Ref ref, FtmsDeviceType deviceType) {
  final connectionService = ref.watch(bluetoothConnectionServiceProvider);
  final device = connectionService.targetDevice;
  if (device == null) {
    debugPrint('[FTMS-Provider] no targetDevice, returning null for $deviceType');
    return null;
  }

  debugPrint('[FTMS-Provider] creating FtmsService for $deviceType, device=${device.remoteId}');
  final service = FtmsServiceFactory.create(deviceType);

  // 异步连接,但不阻塞 Provider 构建
  // 连接成功后通过 dataStream/statusStream 暴露数据
  service.connect(device).then((success) {
    if (success) {
      debugPrint('[FTMS-Provider] FtmsService.connect SUCCESS for $deviceType');
    } else {
      debugPrint('[FTMS-Provider] FtmsService.connect FAILED for $deviceType');
    }
  }).catchError((e) {
    debugPrint('[FTMS-Provider] FtmsService.connect ERROR: $e');
  });

  ref.onDispose(() {
    debugPrint('[FTMS-Provider] disposing FtmsService for $deviceType');
    service.disconnect();
  });

  return service;
}
