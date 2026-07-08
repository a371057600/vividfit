import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_data.freezed.dart';
part 'statistics_data.g.dart';

/// 运动统计项(对应旧 FitStatsData.data 列表元素)。
@freezed
class StatisticsItem with _$StatisticsItem {
  const factory StatisticsItem({
    @Default(0) int calorie,
    @Default(0) int duringTime,
    @Default(0) int sportCount,
  }) = _StatisticsItem;

  factory StatisticsItem.fromJson(Map<String, dynamic> json) =>
      _$StatisticsItemFromJson(json);
}

/// getStatistics 接口返回。
@freezed
class FitStatsData with _$FitStatsData {
  const factory FitStatsData({
    @Default('') String code,
    @Default([]) List<StatisticsItem> data,
  }) = _FitStatsData;

  factory FitStatsData.fromJson(Map<String, dynamic> json) =>
      _$FitStatsDataFromJson(json);
}
