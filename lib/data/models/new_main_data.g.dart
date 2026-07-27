// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_main_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FitMainData _$FitMainDataFromJson(Map<String, dynamic> json) => _FitMainData(
  animationIndex2: (json['animationIndex2'] as num?)?.toInt() ?? 1,
  recordDate: json['recordDate'] as String? ?? '',
  triCycleCalorie: (json['triCycleCalorie'] as num?)?.toInt() ?? 0,
  goalCalorie: (json['goalCalorie'] as num?)?.toInt() ?? 100,
  triCycleDuration: (json['triCycleDuration'] as num?)?.toInt() ?? 0,
  goalDuration: (json['goalDuration'] as num?)?.toInt() ?? 50,
  triCycleStrength: (json['triCycleStrength'] as num?)?.toDouble() ?? 0.0,
  goalStrength: (json['goalStrength'] as num?)?.toDouble() ?? 5.0,
  todayCount: (json['todayCount'] as num?)?.toInt() ?? 0,
  bodyWeight: (json['bodyWeight'] as num?)?.toInt() ?? 40,
  bodyBmi: (json['bodyBmi'] as num?)?.toDouble() ?? 20.0,
  bodyHeight: (json['bodyHeight'] as num?)?.toInt() ?? 160,
  isLoading: json['isLoading'] as bool? ?? true,
  isLoading2: json['isLoading2'] as bool? ?? true,
);

Map<String, dynamic> _$FitMainDataToJson(_FitMainData instance) =>
    <String, dynamic>{
      'animationIndex2': instance.animationIndex2,
      'recordDate': instance.recordDate,
      'triCycleCalorie': instance.triCycleCalorie,
      'goalCalorie': instance.goalCalorie,
      'triCycleDuration': instance.triCycleDuration,
      'goalDuration': instance.goalDuration,
      'triCycleStrength': instance.triCycleStrength,
      'goalStrength': instance.goalStrength,
      'todayCount': instance.todayCount,
      'bodyWeight': instance.bodyWeight,
      'bodyBmi': instance.bodyBmi,
      'bodyHeight': instance.bodyHeight,
      'isLoading': instance.isLoading,
      'isLoading2': instance.isLoading2,
    };
