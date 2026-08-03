// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SportHistory _$SportHistoryFromJson(Map<String, dynamic> json) =>
    _SportHistory(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      equipmentType: (json['equipmentType'] as num?)?.toInt(),
      mode: (json['mode'] as num?)?.toInt(),
      trainMode: (json['trainMode'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toDouble(),
      duringTime: (json['duringTime'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toInt(),
      isOffline: json['isOffline'] as bool?,
      startTime: json['startTime'] as String?,
      createTime: json['createTime'] as String?,
    );

Map<String, dynamic> _$SportHistoryToJson(_SportHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'equipmentType': instance.equipmentType,
      'mode': instance.mode,
      'trainMode': instance.trainMode,
      'calories': instance.calories,
      'duringTime': instance.duringTime,
      'distance': instance.distance,
      'count': instance.count,
      'isOffline': instance.isOffline,
      'startTime': instance.startTime,
      'createTime': instance.createTime,
    };

_SportHistoryDto _$SportHistoryDtoFromJson(Map<String, dynamic> json) =>
    _SportHistoryDto(
      userId: (json['userId'] as num?)?.toInt(),
      equipmentType: (json['equipmentType'] as num?)?.toInt(),
      mode: (json['mode'] as num?)?.toInt(),
      trainMode: (json['trainMode'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toDouble(),
      duringTime: (json['duringTime'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toInt(),
      offline: json['offline'] as bool?,
      startTime: json['startTime'] as String?,
      timeZone: (json['timeZone'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SportHistoryDtoToJson(_SportHistoryDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'equipmentType': instance.equipmentType,
      'mode': instance.mode,
      'trainMode': instance.trainMode,
      'calories': instance.calories,
      'duringTime': instance.duringTime,
      'distance': instance.distance,
      'count': instance.count,
      'offline': instance.offline,
      'startTime': instance.startTime,
      'timeZone': instance.timeZone,
    };
