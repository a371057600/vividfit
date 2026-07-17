import 'device_category.dart';

/// 5 类大设备的蓝牙搜索白名单常量。
/// 1:1 还原旧 `setWhiteNameList()` 中的各 case。
class DeviceScanConstants {
  DeviceScanConstants._();

  /// 健身车白名单(对应旧 `FM-B10`、`powerSP` 等)。
  static final Set<String> bikeWhitelist = {
    'FM-B10',
    'powerSP',
    'FM-B100',
    'FM-B100G',
    'FM-B100B',
    'FM-B100P',
  };

  /// 跑步机白名单(对应旧 `FM-R10` 等)。
  static final Set<String> treadmillWhitelist = {
    'FM-R10',
    'FM-R100',
  };

  /// 椭圆机白名单(对应旧 `FM-E10` 等)。
  static final Set<String> ellipticalWhitelist = {
    'FM-E10',
    'FM-E100',
  };

  /// 划船机白名单(对应旧 `FM-R10`、海德 `HEAD-`、捷瑞特 `JEE-` 等)。
  static final Set<String> rowerWhitelist = {
    'FM-R10',
    'HEAD-',
    'JEE-',
    'JTE-',
    'RAC-',
    'headsk',
  };

  /// 力量站白名单(对应旧 `FM-S10` 等)。
  static final Set<String> strengthStationWhitelist = {
    'FM-S10',
    'FM-S100',
  };

  /// 根据设备类型返回对应白名单(对应旧 `setWhiteNameList()` 的 switch)。
  static List<String> whitelistFor(DeviceCategory category) {
    return switch (category) {
      DeviceCategory.bike => bikeWhitelist.toList(),
      DeviceCategory.treadmill => treadmillWhitelist.toList(),
      DeviceCategory.elliptical => ellipticalWhitelist.toList(),
      DeviceCategory.rower => rowerWhitelist.toList(),
      DeviceCategory.strengthStation => strengthStationWhitelist.toList(),
    };
  }
}
