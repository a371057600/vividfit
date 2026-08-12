// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_stats_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordStatsItem _$RecordStatsItemFromJson(Map<String, dynamic> json) =>
    _RecordStatsItem(
      sportCount: (json['sportCount'] as num).toInt(),
      calorie: (json['calorie'] as num).toDouble(),
      duringTime: (json['duringTime'] as num).toInt(),
      sportStrength: (json['sportStrength'] as num).toDouble(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );

Map<String, dynamic> _$RecordStatsItemToJson(_RecordStatsItem instance) =>
    <String, dynamic>{
      'sportCount': instance.sportCount,
      'calorie': instance.calorie,
      'duringTime': instance.duringTime,
      'sportStrength': instance.sportStrength,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

_RecordStatsResponse _$RecordStatsResponseFromJson(Map<String, dynamic> json) =>
    _RecordStatsResponse(
      code: json['code'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => RecordStatsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordStatsResponseToJson(
  _RecordStatsResponse instance,
) => <String, dynamic>{'code': instance.code, 'data': instance.data};
