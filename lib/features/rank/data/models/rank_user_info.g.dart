// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankUserInfo _$RankUserInfoFromJson(Map<String, dynamic> json) =>
    _RankUserInfo(
      code: json['code'] as String?,
      msg: json['msg'] as String?,
      data: json['data'] == null
          ? null
          : RankUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RankUserInfoToJson(_RankUserInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

_RankUserData _$RankUserDataFromJson(Map<String, dynamic> json) =>
    _RankUserData(
      myRank: (json['myRank'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RankUserDataToJson(_RankUserData instance) =>
    <String, dynamic>{
      'myRank': instance.myRank,
      'calories': instance.calories,
      'count': instance.count,
    };
