import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_statistics_dto.freezed.dart';
part 'sport_statistics_dto.g.dart';

@freezed
abstract class SportStatisticsDataResultDto with _$SportStatisticsDataResultDto {
  const factory SportStatisticsDataResultDto({
    double? calorie,
    int? duringTime,
    String? endTime,
    int? sportCount,
    double? sportDistance,
    String? startTime,
  }) = _SportStatisticsDataResultDto;

  factory SportStatisticsDataResultDto.fromJson(Map<String, dynamic> json) =>
      _$SportStatisticsDataResultDtoFromJson(json);
}
