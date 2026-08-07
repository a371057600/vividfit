enum RankDeviceType {
  all(0, 'All Device'),
  spinBike(1, 'Spin Bike'),
  treadmill(2, 'Treadmill'),
  elliptical(3, 'Elliptical'),
  rower(4, 'Rower');

  final int value;
  final String displayName;
  const RankDeviceType(this.value, this.displayName);

  static RankDeviceType fromValue(int value) {
    return RankDeviceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => RankDeviceType.all,
    );
  }
}

enum RankTimeRange {
  total('Total'),
  annual('Annual'),
  monthly('Monthly');

  final String displayName;
  const RankTimeRange(this.displayName);
}
