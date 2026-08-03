// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_statistics_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SportStatisticsDataResultDto _$SportStatisticsDataResultDtoFromJson(
  Map<String, dynamic> json,
) => _SportStatisticsDataResultDto(
  calorie: (json['calorie'] as num?)?.toDouble(),
  duringTime: (json['duringTime'] as num?)?.toInt(),
  endTime: json['endTime'] as String?,
  sportCount: (json['sportCount'] as num?)?.toInt(),
  sportDistance: (json['sportDistance'] as num?)?.toDouble(),
  startTime: json['startTime'] as String?,
);

Map<String, dynamic> _$SportStatisticsDataResultDtoToJson(
  _SportStatisticsDataResultDto instance,
) => <String, dynamic>{
  'calorie': instance.calorie,
  'duringTime': instance.duringTime,
  'endTime': instance.endTime,
  'sportCount': instance.sportCount,
  'sportDistance': instance.sportDistance,
  'startTime': instance.startTime,
};
