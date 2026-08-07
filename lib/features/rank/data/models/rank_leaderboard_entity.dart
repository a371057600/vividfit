import 'package:freezed_annotation/freezed_annotation.dart';

part 'rank_leaderboard_entity.freezed.dart';
part 'rank_leaderboard_entity.g.dart';

@freezed
abstract class RankLeaderboardEntity with _$RankLeaderboardEntity {
  const factory RankLeaderboardEntity({
    @JsonKey(name: 'myRank') required int rank,
    @JsonKey(name: 'nickName') required String nickName,
    @JsonKey(name: 'headImg') String? headImg,
    @JsonKey(name: 'count') required int count,
    @JsonKey(name: 'calories') required double calories,
    @JsonKey(name: 'equipmentType') int? equipmentType,
  }) = _RankLeaderboardEntity;

  factory RankLeaderboardEntity.fromJson(Map<String, dynamic> json) =>
      _$RankLeaderboardEntityFromJson(json);
}
