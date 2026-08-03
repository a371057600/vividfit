import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'package:vividfit_v2/core/network/api_client.dart';
import 'package:vividfit_v2/data/models/network/sport_history.dart';

/// 运动历史接口服务
class SportHistoryApi {
  final ApiClient _client;

  SportHistoryApi(this._client);

  /// 查询运动数据
  Future<List<SportHistory>> getSportHistory({
    required int userId,
    required int equipmentType,
    required int page,
    int? pageLimited,
    String? startTime,
    String? endTime,
    int? zone,
  }) async {
    return _client.getRaw<List<SportHistory>>(
      ApiConstants.sportHistory,
      queryParameters: {
        'userId': userId,
        'equipmentType': equipmentType,
        'page': page,
        if (pageLimited != null) 'pageLimited': pageLimited,
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
        if (zone != null) 'zone': zone,
      },
      parser: (json) => (json as List<dynamic>)
          .map((e) => SportHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 获取运动记录详情
  Future<SportHistory> getSportHistoryDetail({
    required int id,
  }) async {
    return _client.getRaw<SportHistory>(
      ApiConstants.sportHistoryDetail,
      queryParameters: {'id': id},
      parser: (json) => SportHistory.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 查询多设备类型运动数据
  Future<List<SportHistory>> getSportHistoryMultiTypes({
    required int userId,
    required List<int> equipmentTypes,
    required int page,
    int? pageLimited,
    String? startTime,
    String? endTime,
    int? zone,
  }) async {
    return _client.getRaw<List<SportHistory>>(
      ApiConstants.sportHistoryMultiTypes,
      queryParameters: {
        'userId': userId,
        'equipmentTypes': equipmentTypes,
        'page': page,
        if (pageLimited != null) 'pageLimited': pageLimited,
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
        if (zone != null) 'zone': zone,
      },
      parser: (json) => (json as List<dynamic>)
          .map((e) => SportHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 上传运动数据
  Future<void> uploadSportHistory({
    required List<SportHistoryDto> sportHistoryDtoList,
  }) async {
    await _client.post<void>(
      ApiConstants.sportHistory,
      data: sportHistoryDtoList.map((e) => e.toJson()).toList(),
      parser: (json) {},
    );
  }

  /// 删除运动数据
  Future<void> deleteSportHistory({
    required List<int> ids,
  }) async {
    await _client.delete<void>(
      ApiConstants.sportHistory,
      data: ids.toString(),
      parser: (json) {},
    );
  }
}