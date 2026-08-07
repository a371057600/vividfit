/// 记录模块设备类型枚举。
///
/// 仅保留 5 种设备类型，对应后端 equipmentType 字段：
/// - 0: 全部设备
/// - 1: 动感单车
/// - 2: 跑步机
/// - 3: 椭圆机
/// - 4: 划船机
enum RecordEquipmentType {
  all(0, '全部设备', 'images/newUIScreen/icons/icon_mainCardT.png'),
  spinBike(1, '动感单车', 'images/newUIScreen/device_icons/icondataimage10.png'),
  treadmill(2, '跑步机', 'images/newUIScreen/device_icons/icondataimage14.png'),
  elliptical(3, '椭圆机', 'images/newUIScreen/device_icons/icondataimage15.png'),
  rowingMachine(4, '划船机', 'images/newUIScreen/device_icons/icondataimage9.png');

  final int id;
  final String displayName;
  final String iconPath;

  const RecordEquipmentType(this.id, this.displayName, this.iconPath);

  /// 根据后端返回的 equipmentType 字段构造枚举。
  /// 未知值统一回退为 [all]。
  static RecordEquipmentType fromId(int id) {
    return RecordEquipmentType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => RecordEquipmentType.all,
    );
  }
}
