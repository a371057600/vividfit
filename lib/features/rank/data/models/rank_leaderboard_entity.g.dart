// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_leaderboard_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankLeaderboardEntity _$RankLeaderboardEntityFromJson(
  Map<String, dynamic> json,
) => _RankLeaderboardEntity(
  rank: (json['myRank'] as num).toInt(),
  nickName: json['nickName'] as String,
  headImg: json['headImg'] as String?,
  count: (json['count'] as num).toInt(),
  calories: (json['calories'] as num).toDouble(),
  equipmentType: (json['equipmentType'] as num?)?.toInt(),
);

Map<String, dynamic> _$RankLeaderboardEntityToJson(
  _RankLeaderboardEntity instance,
) => <String, dynamic>{
  'myRank': instance.rank,
  'nickName': instance.nickName,
  'headImg': instance.headImg,
  'count': instance.count,
  'calories': instance.calories,
  'equipmentType': instance.equipmentType,
};
