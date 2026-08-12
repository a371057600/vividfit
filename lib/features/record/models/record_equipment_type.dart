import 'package:flutter/material.dart';

/// 记录模块设备类型枚举。
///
/// 仅保留 5 种设备类型，对应后端 equipmentType 字段：
/// - 0: 全部设备
/// - 1: 动感单车
/// - 2: 跑步机
/// - 3: 椭圆机
/// - 4: 划船机
enum RecordEquipmentType {
  all(0, '全部设备', Icons.help_outline),
  spinBike(1, '动感单车', Icons.directions_bike),
  treadmill(2, '跑步机', Icons.directions_run),
  elliptical(3, '椭圆机', Icons.fitness_center),
  rowingMachine(4, '划船机', Icons.waves);

  final int id;
  final String displayName;
  final IconData icon;

  const RecordEquipmentType(this.id, this.displayName, this.icon);

  /// 根据后端返回的 equipmentType 字段构造枚举。
  /// 未知值统一回退为 [all]。
  static RecordEquipmentType fromId(int id) {
    return RecordEquipmentType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => RecordEquipmentType.all,
    );
  }
}
