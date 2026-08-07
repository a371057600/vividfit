import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/rank_leaderboard_entity.dart';
import '../domain/rank_device_type.dart';

part 'rank_state.freezed.dart';

@freezed
abstract class RankState with _$RankState {
  const factory RankState({
    @Default(RankDeviceType.all) RankDeviceType deviceType,
    @Default(RankTimeRange.total) RankTimeRange timeRange,
    @Default(false) bool isLoading,
    @Default([]) List<RankLeaderboardEntity> leaderboardList,
    String? userNickName,
    String? userHeadImage,
    String? userRank,
    String? userScore,
    @Default('') String errorMessage,
  }) = _RankState;
}
