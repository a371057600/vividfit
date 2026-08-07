import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/rank_leaderboard_entity.dart';
import '../data/models/rank_user_info.dart';
import '../domain/rank_device_type.dart';

part 'rank_repository.g.dart';

@Riverpod(keepAlive: true)
class RankRepository extends _$RankRepository {
  @override
  RankRepository build() => this;

  // ============ Mock 数据 ============

  final List<RankLeaderboardEntity> _mockLeaderboard = [
    const RankLeaderboardEntity(
      rank: 1,
      nickName: 'Champion',
      headImg: 'hash_001',
      count: 1250,
      calories: 680.5,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 2,
      nickName: 'RunnerUp',
      headImg: 'hash_002',
      count: 1100,
      calories: 580.0,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 3,
      nickName: 'ThirdPlace',
      headImg: 'hash_003',
      count: 980,
      calories: 520.3,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 4,
      nickName: 'FitnessKing',
      headImg: 'hash_004',
      count: 870,
      calories: 460.0,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 5,
      nickName: 'StrongMan',
      headImg: 'hash_005',
      count: 760,
      calories: 410.5,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 6,
      nickName: 'CardioMaster',
      headImg: 'hash_006',
      count: 650,
      calories: 380.0,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 7,
      nickName: 'PowerLover',
      headImg: 'hash_007',
      count: 580,
      calories: 340.2,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 8,
      nickName: 'ExercisePro',
      headImg: 'hash_008',
      count: 520,
      calories: 310.0,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 9,
      nickName: 'HealthFreak',
      headImg: 'hash_009',
      count: 470,
      calories: 280.5,
      equipmentType: 0,
    ),
    const RankLeaderboardEntity(
      rank: 10,
      nickName: 'SportStar',
      headImg: 'hash_010',
      count: 420,
      calories: 250.0,
      equipmentType: 0,
    ),
  ];

  final RankUserInfo _mockUserInfo = const RankUserInfo(
    code: '200',
    msg: 'success',
    data: RankUserData(
      myRank: 25,
      calories: 180.5,
      count: 320,
    ),
  );

  // ============ 业务方法 ============

  String _buildTimeParam(RankTimeRange range) {
    switch (range) {
      case RankTimeRange.total:
        return 'all';
      case RankTimeRange.annual:
        return DateTime.now().year.toString();
      case RankTimeRange.monthly:
        final now = DateTime.now();
        return '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
    }
  }

  Future<List<RankLeaderboardEntity>> fetchLeaderboard({
    required RankDeviceType deviceType,
    required RankTimeRange timeRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint(
      '[Rank] fetchLeaderboard: deviceType=${deviceType.value}, timeRange=${_buildTimeParam(timeRange)}',
    );
    // Mock: 根据设备类型调整数据
    if (deviceType == RankDeviceType.all) {
      return _mockLeaderboard;
    }
    // 其他设备类型返回不同的数据
    return _mockLeaderboard
        .map((e) => RankLeaderboardEntity(
              rank: e.rank,
              nickName: e.nickName,
              headImg: e.headImg,
              count: (e.count * deviceType.value),
              calories: (e.calories * deviceType.value),
              equipmentType: deviceType.value,
            ))
        .toList();
  }

  Future<RankUserInfo> fetchUserInfo({
    required int userId,
    required RankDeviceType deviceType,
    required RankTimeRange timeRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint(
      '[Rank] fetchUserInfo: userId=$userId, deviceType=${deviceType.value}, timeRange=${_buildTimeParam(timeRange)}',
    );
    return _mockUserInfo;
  }

  Future<bool> refreshToken() async {
    return true;
  }
}
