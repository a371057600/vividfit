import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_stats_item.freezed.dart';
part 'record_stats_item.g.dart';

@freezed
abstract class RecordStatsItem with _$RecordStatsItem {
  const factory RecordStatsItem({
    required int sportCount,
    required double calorie,
    required int duringTime,
    required double sportStrength,
    String? startTime,
    String? endTime,
  }) = _RecordStatsItem;

  factory RecordStatsItem.fromJson(Map<String, dynamic> json) =>
      _$RecordStatsItemFromJson(json);
}

@freezed
abstract class RecordStatsResponse with _$RecordStatsResponse {
  const factory RecordStatsResponse({
    required String code,
    required List<RecordStatsItem> data,
  }) = _RecordStatsResponse;

  factory RecordStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecordStatsResponseFromJson(json);
}