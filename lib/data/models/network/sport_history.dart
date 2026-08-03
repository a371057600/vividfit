import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_history.freezed.dart';
part 'sport_history.g.dart';

@freezed
abstract class SportHistory with _$SportHistory {
  const factory SportHistory({
    int? id,
    int? userId,
    int? equipmentType,
    int? mode,
    int? trainMode,
    double? calories,
    int? duringTime,
    double? distance,
    int? count,
    bool? isOffline,
    String? startTime,
    String? createTime,
  }) = _SportHistory;

  factory SportHistory.fromJson(Map<String, dynamic> json) =>
      _$SportHistoryFromJson(json);
}

@freezed
abstract class SportHistoryDto with _$SportHistoryDto {
  const factory SportHistoryDto({
    int? userId,
    int? equipmentType,
    int? mode,
    int? trainMode,
    double? calories,
    int? duringTime,
    double? distance,
    int? count,
    bool? offline,
    String? startTime,
    int? timeZone,
  }) = _SportHistoryDto;

  factory SportHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$SportHistoryDtoFromJson(json);
}
