import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../data/models/rank_leaderboard_entity.dart';
import '../data/models/rank_user_info.dart';
import '../domain/rank_device_type.dart';
import '../repositories/rank_repository.dart';
import '../states/rank_state.dart';

part 'rank_notifier.g.dart';

@Riverpod(keepAlive: true)
class RankNotifier extends _$RankNotifier {
  @override
  RankState build() {
    _storage = ref.watch(storageServiceProvider);
    _repository = ref.watch(rankRepositoryProvider);
    _initData();
    return const RankState();
  }

  late final StorageService _storage;
  late final RankRepository _repository;

  Future<void> _initData() async {
    state = state.copyWith(isLoading: true);
    try {
      await _loadUserInfo();
      await _fetchRankData();
    } catch (e) {
      debugPrint('[Rank] initData error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _loadUserInfo() async {
    final nickName = _storage.username ?? 'User';
    final headImage = _storage.headImageHash ?? '';
    state = state.copyWith(
      userNickName: nickName,
      userHeadImage: headImage,
    );
  }

  Future<void> _fetchRankData() async {
    final deviceType = state.deviceType;
    final timeRange = state.timeRange;
    final userId = _storage.userId ?? 0;

    debugPrint('[Rank] fetchRankData: deviceType=$deviceType, timeRange=$timeRange');

    final results = await Future.wait([
      _repository.fetchLeaderboard(
        deviceType: deviceType,
        timeRange: timeRange,
      ),
      _repository.fetchUserInfo(
        userId: userId,
        deviceType: deviceType,
        timeRange: timeRange,
      ),
    ]);

    final leaderboard = results[0] as List<RankLeaderboardEntity>;
    final userInfo = results[1] as RankUserInfo;

    debugPrint('[Rank] leaderboard loaded: ${leaderboard.length} items');
    debugPrint('[Rank] userInfo: rank=${userInfo.data?.myRank}, score=${userInfo.data?.calories ?? userInfo.data?.count}');

    state = state.copyWith(
      isLoading: false,
      leaderboardList: leaderboard,
      userRank: userInfo.data?.myRank?.toString() ?? '-',
      userScore: deviceType == RankDeviceType.all
          ? userInfo.data?.calories?.toStringAsFixed(0) ?? '-'
          : userInfo.data?.count?.toStringAsFixed(0) ?? '-',
    );
  }

  Future<void> refresh() async {
    await _fetchRankData();
  }

  Future<void> changeDeviceType(RankDeviceType type) async {
    state = state.copyWith(deviceType: type);
    await _fetchRankData();
  }

  Future<void> changeTimeRange(RankTimeRange range) async {
    state = state.copyWith(timeRange: range);
    await _fetchRankData();
  }
}
