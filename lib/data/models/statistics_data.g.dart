// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticsItemImpl _$$StatisticsItemImplFromJson(Map<String, dynamic> json) =>
    _$StatisticsItemImpl(
      calorie: (json['calorie'] as num?)?.toInt() ?? 0,
      duringTime: (json['duringTime'] as num?)?.toInt() ?? 0,
      sportCount: (json['sportCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$StatisticsItemImplToJson(
  _$StatisticsItemImpl instance,
) => <String, dynamic>{
  'calorie': instance.calorie,
  'duringTime': instance.duringTime,
  'sportCount': instance.sportCount,
};

_$StatisticsDataImpl _$$StatisticsDataImplFromJson(Map<String, dynamic> json) =>
    _$StatisticsDataImpl(
      code: json['code'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => StatisticsItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$StatisticsDataImplToJson(
  _$StatisticsDataImpl instance,
) => <String, dynamic>{'code': instance.code, 'data': instance.data};
