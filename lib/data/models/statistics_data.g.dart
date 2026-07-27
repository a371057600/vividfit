// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatisticsItem _$StatisticsItemFromJson(Map<String, dynamic> json) =>
    _StatisticsItem(
      calorie: (json['calorie'] as num?)?.toInt() ?? 0,
      duringTime: (json['duringTime'] as num?)?.toInt() ?? 0,
      sportCount: (json['sportCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StatisticsItemToJson(_StatisticsItem instance) =>
    <String, dynamic>{
      'calorie': instance.calorie,
      'duringTime': instance.duringTime,
      'sportCount': instance.sportCount,
    };

_FitStatsData _$FitStatsDataFromJson(Map<String, dynamic> json) =>
    _FitStatsData(
      code: json['code'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => StatisticsItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FitStatsDataToJson(_FitStatsData instance) =>
    <String, dynamic>{'code': instance.code, 'data': instance.data};
