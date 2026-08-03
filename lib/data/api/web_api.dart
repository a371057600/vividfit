import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'package:vividfit_v2/core/network/api_client.dart';
import 'package:vividfit_v2/data/models/network/web_rank_dto.dart';

/// Web 接口服务
class WebApi {
  final ApiClient _client;

  WebApi(this._client);

  /// 获取 Web 排行榜
  Future<WebRankDto> getWebRank({
    int? equipmentType,
    String? timeType,
    int? userId,
    int? page,
    int? pageLimited,
  }) async {
    return _client.get<WebRankDto>(
      ApiConstants.webRank,
      queryParameters: {
        if (equipmentType != null) 'equipmentType': equipmentType,
        if (timeType != null) 'timeType': timeType,
        if (userId != null) 'userId': userId,
        if (page != null) 'page': page,
        if (pageLimited != null) 'pageLimited': pageLimited,
      },
      parser: (json) => WebRankDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 上传 Web 排行榜数据
  Future<WebRankDto> uploadWebRank({
    required Map<String, dynamic> data,
  }) async {
    return _client.post<WebRankDto>(
      ApiConstants.webRank,
      data: data,
      parser: (json) => WebRankDto.fromJson(json as Map<String, dynamic>),
    );
  }
}