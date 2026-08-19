// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SportRecord _$SportRecordFromJson(Map<String, dynamic> json) => _SportRecord(
  id: json['id'] as String,
  userId: (json['userId'] as num).toInt(),
  deviceType: (json['deviceType'] as num).toInt(),
  mode: (json['mode'] as num?)?.toInt(),
  trainMode: (json['trainMode'] as num?)?.toInt(),
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  duration: (json['duration'] as num).toInt(),
  distance: (json['distance'] as num).toDouble(),
  calories: (json['calories'] as num).toDouble(),
  avgSpeed: (json['avgSpeed'] as num?)?.toDouble(),
  maxSpeed: (json['maxSpeed'] as num?)?.toDouble(),
  avgCadence: (json['avgCadence'] as num?)?.toInt(),
  maxCadence: (json['maxCadence'] as num?)?.toInt(),
  avgHeartRate: (json['avgHeartRate'] as num?)?.toInt(),
  maxHeartRate: (json['maxHeartRate'] as num?)?.toInt(),
  avgPower: (json['avgPower'] as num?)?.toDouble(),
  maxPower: (json['maxPower'] as num?)?.toDouble(),
  avgResistance: (json['avgResistance'] as num?)?.toDouble(),
  avgInclination: (json['avgInclination'] as num?)?.toDouble(),
  totalStrokes: (json['totalStrokes'] as num?)?.toInt(),
  avgStrokeRate: (json['avgStrokeRate'] as num?)?.toDouble(),
  finishPercent: (json['finishPercent'] as num?)?.toDouble(),
  speedSamples: (json['speedSamples'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  isOffline: json['isOffline'] as bool? ?? false,
  isSynced: json['isSynced'] as bool? ?? false,
);

Map<String, dynamic> _$SportRecordToJson(_SportRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'deviceType': instance.deviceType,
      'mode': instance.mode,
      'trainMode': instance.trainMode,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'duration': instance.duration,
      'distance': instance.distance,
      'calories': instance.calories,
      'avgSpeed': instance.avgSpeed,
      'maxSpeed': instance.maxSpeed,
      'avgCadence': instance.avgCadence,
      'maxCadence': instance.maxCadence,
      'avgHeartRate': instance.avgHeartRate,
      'maxHeartRate': instance.maxHeartRate,
      'avgPower': instance.avgPower,
      'maxPower': instance.maxPower,
      'avgResistance': instance.avgResistance,
      'avgInclination': instance.avgInclination,
      'totalStrokes': instance.totalStrokes,
      'avgStrokeRate': instance.avgStrokeRate,
      'finishPercent': instance.finishPercent,
      'speedSamples': instance.speedSamples,
      'isOffline': instance.isOffline,
      'isSynced': instance.isSynced,
    };
