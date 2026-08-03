import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'package:vividfit_v2/core/network/api_client.dart';
import 'package:vividfit_v2/data/models/network/medal.dart';
import 'package:vividfit_v2/data/models/network/sport_statistics_dto.dart';

/// 运动统计接口服务
class SportStatisticsApi {
  final ApiClient _client;

  SportStatisticsApi(this._client);

  /// 获取运动统计数据
  Future<List<SportStatisticsDataResultDto>> getSportStatistics({
    required int userId,
    required int equipmentType,
    required int timeArea,
  }) async {
    return _client.getRaw<List<SportStatisticsDataResultDto>>(
      ApiConstants.sportStatistics,
      queryParameters: {
        'userId': userId,
        'equipmentType': equipmentType,
        'timeArea': timeArea,
      },
      parser: (json) => (json as List<dynamic>)
          .map((e) =>
              SportStatisticsDataResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 获取运动日历
  Future<List<String>> getSportCalendar({
    required int userId,
    required int duringTime,
    required String startTime,
    required String endTime,
  }) async {
    return _client.getRaw<List<String>>(
      ApiConstants.sportCalendar,
      queryParameters: {
        'userId': userId,
        'duringTime': duringTime,
        'startTime': startTime,
        'endTime': endTime,
      },
      parser: (json) => (json as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  /// 获取卡路里排行榜
  Future<Map<String, dynamic>> getCaloriesLeaderboard({
    required int equipmentType,
    required String timeType,
  }) async {
    return _client.get<Map<String, dynamic>>(
      ApiConstants.caloriesLeaderboard,
      queryParameters: {
        'equipmentType': equipmentType,
        'timeType': timeType,
      },
      parser: (json) => json as Map<String, dynamic>,
    );
  }

  /// 获取特殊时间段统计
  Future<List<SportStatisticsDataResultDto>> getSpecialTimeStatistics({
    required int userId,
    required int equipmentType,
    required String startTime,
    required String endTime,
    required int avgCount,
    required int zone,
  }) async {
    return _client.getRaw<List<SportStatisticsDataResultDto>>(
      ApiConstants.sportStatisticsSpecialTime,
      queryParameters: {
        'userId': userId,
        'equipmentType': equipmentType,
        'startTime': startTime,
        'endTime': endTime,
        'avgCount': avgCount,
        'zone': zone,
      },
      parser: (json) => (json as List<dynamic>)
          .map((e) =>
              SportStatisticsDataResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 获取新勋章
  Future<List<MedalMsg>> getNewMedal({
    required int userId,
    required String lang,
  }) async {
    return _client.getRaw<List<MedalMsg>>(
      ApiConstants.newMedal,
      queryParameters: {
        'userId': userId,
        'lang': lang,
      },
      parser: (json) => (json as List<dynamic>)
          .map((e) => MedalMsg.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 获取勋章面板
  Future<List<MedalGroup>> getMedalPanel({
    required int userId,
    required String lang,
  }) async {
    return _client.getRaw<List<MedalGroup>>(
      ApiConstants.medalPanel,
      queryParameters: {
        'userId': userId,
        'lang': lang,
      },
      parser: (json) => (json as List<dynamic>)
          .map((e) => MedalGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 标记勋章已读
  Future<void> markMedalRead({
    required int userId,
    required List<int> medalIds,
  }) async {
    await _client.put<void>(
      ApiConstants.markMedalRead,
      data: ReadMedal(userId: userId, medalIds: medalIds).toJson(),
      parser: (json) {},
    );
  }

  /// 获取勋章总数
  Future<int> getMedalTotalCount({
    required int userId,
  }) async {
    return _client.getRaw<int>(
      ApiConstants.medalTotalCount,
      queryParameters: {'userId': userId},
      parser: (json) => json as int,
    );
  }

  /// 获取用户排行榜信息
  Future<Map<String, dynamic>> getUserLeaderboardInfo({
    required int userId,
    required int equipmentType,
    required String timeType,
  }) async {
    return _client.get<Map<String, dynamic>>(
      ApiConstants.userLeaderboardInfo,
      queryParameters: {
        'userId': userId,
        'equipmentType': equipmentType,
        'timeType': timeType,
      },
      parser: (json) => json as Map<String, dynamic>,
    );
  }
}