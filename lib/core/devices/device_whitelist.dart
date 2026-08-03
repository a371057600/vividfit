import '../ftms/ftms_device_type.dart';

/// 设备搜索白名单配置。
///
/// 数据来源: 旧 `controller_new_four_big_device_sprot.dart` 的 `setWhiteNameList()` 方法 (行 228-304)。
///
/// 用法: `DeviceWhitelist.forType(FtmsDeviceType.indoorBike)`
class DeviceWhitelist {
  DeviceWhitelist._();

  /// 按 FtmsDeviceType 返回搜索白名单。
  ///
  /// 这些字符串作为 `withKeywords` 传给 `FlutterBluePlus.startScan`。
  static List<String> forType(FtmsDeviceType type) {
    return switch (type) {
      /// 单车 (case 0)
      FtmsDeviceType.indoorBike => const [
          'FM-B100',
          'FM-B101',
          'FM-B103',
          'FM-B501',
          'FS-LD CX20',
          'FS-LD CX30',
          'FS-LD CX50',
          'FS-LD R2',
          'RIDO U2',
          'FS',
        ],

      /// 跑步机 (case 1)
      FtmsDeviceType.treadmill => const [
          'FIT-TM-',
          'FIT-',
          'T2',
          'RIDO-T101',
          'FM-T100',
          'FM-T101',
          'FM-T103',
          'FM-T501',
          'FM-T201',
        ],

      /// 椭圆机 (case 2)
      FtmsDeviceType.crossTrainer => const [
          'FM-C100',
          'FM-C101',
          'FM-C103',
          'FM-C501',
          'E2',
          'FS',
        ],

      /// 划船机 (case 3)
      FtmsDeviceType.rower => const [
          'RIDO W2',
          'FM-R100',
          'FM-R101',
          'FM-R103',
          'FM-R501',
          'W5',
        ],

      /// 力量站 (case 4)
      FtmsDeviceType.strengthStation => const [
          'Fit Monster Treadmill',
        ],
    };
  }

  /// 检查设备名是否匹配某类设备的白名单。
  ///
  /// 白名单匹配规则: 设备名以白名单字符串开头即视为匹配（旧项目逻辑）。
  static bool matches(String deviceName, FtmsDeviceType type) {
    final whitelist = forType(type);
    return whitelist.any((prefix) => deviceName.startsWith(prefix));
  }
}
