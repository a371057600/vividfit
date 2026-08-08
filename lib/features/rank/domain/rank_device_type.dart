import '../../../l10n/app_localizations.dart';

enum RankDeviceType {
  all(0),
  spinBike(1),
  treadmill(2),
  elliptical(3),
  rower(4);

  final int value;
  const RankDeviceType(this.value);

  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case RankDeviceType.all:
        return l10n.rankAllDevice;
      case RankDeviceType.spinBike:
        return l10n.rankSpinBike;
      case RankDeviceType.treadmill:
        return l10n.rankTreadmill;
      case RankDeviceType.elliptical:
        return l10n.rankElliptical;
      case RankDeviceType.rower:
        return l10n.rankRower;
    }
  }

  static RankDeviceType fromValue(int value) {
    return RankDeviceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => RankDeviceType.all,
    );
  }
}

enum RankTimeRange {
  total,
  annual,
  monthly;

  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case RankTimeRange.total:
        return l10n.rankTotal;
      case RankTimeRange.annual:
        return l10n.rankAnnual;
      case RankTimeRange.monthly:
        return l10n.rankMonthly;
    }
  }
}
