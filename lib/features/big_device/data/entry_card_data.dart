import 'package:flutter/material.dart';

import '../../../core/ftms/ftms_device_type.dart';

/// 入口卡片元数据(替代旧 `cardData` List<Map>)。
class EntryCardData {
  const EntryCardData({
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.index,
  });

  /// i18n 键(如 `quickStart`)。
  final String titleKey;

  /// 图标字符。
  final IconData icon;

  /// 卡片背景色。
  final Color color;

  /// 卡片在 5 张中的索引(0-4)。
  final int index;

  /// 默认 5 张入口卡片(1:1 还原旧 `cardData`)。
  static List<EntryCardData> get defaultCards => const [
        EntryCardData(
          titleKey: 'quickStart',
          icon: Icons.play_arrow,
          color: Color(0xFF4CAF50),
          index: 0,
        ),
        EntryCardData(
          titleKey: 'courseTraining',
          icon: Icons.fitness_center,
          color: Color(0xFF2196F3),
          index: 1,
        ),
        EntryCardData(
          titleKey: 'realScene',
          icon: Icons.landscape,
          color: Color(0xFFFF9800),
          index: 2,
        ),
        EntryCardData(
          titleKey: 'cityAdventure',
          icon: Icons.location_city,
          color: Color(0xFF9C27B0),
          index: 3,
        ),
        EntryCardData(
          titleKey: 'recreationalFitness',
          icon: Icons.games,
          color: Color(0xFFE91E63),
          index: 4,
        ),
      ];

  /// 根据设备类型和索引解析背景图路径(替代旧 `setImageaboutFirstScreen`)。
  ///
  /// 返回 `images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/` 下的图片路径。
  static String resolveCardImage(FtmsDeviceType category, int dataIndex) {
    final prefix = switch (category) {
      FtmsDeviceType.indoorBike => 'bigDeviceBike',
      FtmsDeviceType.treadmill => 'bigDeviceTreadmill',
      FtmsDeviceType.crossTrainer => 'bigDeviceCross',
      FtmsDeviceType.rower => 'bigDeviceRower',
      FtmsDeviceType.strengthStation => 'bigDeviceStrength',
    };
    return 'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/${prefix}_$dataIndex.jpg';
  }

  /// 设备类型 → 中文标题(替代旧 `titleList`)。
  static String deviceTitleKey(FtmsDeviceType category) {
    return switch (category) {
      FtmsDeviceType.indoorBike => 'spinBike',
      FtmsDeviceType.treadmill => 'treadmillMachine',
      FtmsDeviceType.crossTrainer => 'ellipticalMachine',
      FtmsDeviceType.rower => 'rowingMachine',
      FtmsDeviceType.strengthStation => 'strengthStation',
    };
  }

}
