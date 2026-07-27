import 'ftms_device_type.dart';
import 'ftms_service_base.dart';

/// 🏭 FTMS 服务工厂类(核心入口)。
///
/// 根据设备类型创建对应的 FTMS 服务实例。
/// 所有设备共享同一套 [FtmsServiceBase] 逻辑,
/// 差异由 [FtmsDeviceType] 的配置扩展(data UUID + 解析器)决定。
///
/// ## 使用示例
///
/// ```dart
/// // 1. 创建服务
/// final service = FtmsServiceFactory.create(FtmsDeviceType.indoorBike);
///
/// // 2. 连接设备
/// await service.connect(bluetoothDevice);
///
/// // 3. 监听实时数据
/// service.dataStream.listen((data) {
///   print('速度: ${data.instSpeed} km/h, 踏频: ${data.instCadence} rpm');
/// });
///
/// // 4. 监听设备状态变化
/// service.statusStream.listen((event) {
///   switch (event) {
///     case FtmsStatusTargetSpeedChanged(speed: final s):
///       print('设备端速度变更: $s');
///     default:
///       break;
///   }
/// });
///
/// // 5. 发送控制指令
/// await service.setTargetResistance(8.5);
/// await service.startOrResume();
///
/// // 6. 断开
/// await service.disconnect();
/// ```
class FtmsServiceFactory {
  FtmsServiceFactory._();

  /// 根据设备类型创建 FTMS 服务实例。
  static FtmsServiceBase create(FtmsDeviceType type) {
    return _FtmsServiceImpl(type);
  }

  /// 根据数值创建(方便旧代码迁移)。
  static FtmsServiceBase fromValue(int value) =>
      create(FtmsDeviceType.fromValue(value));
}

/// 内部默认实现(仅暴露基类接口)。
class _FtmsServiceImpl extends FtmsServiceBase {
  _FtmsServiceImpl(super.deviceType);
}
