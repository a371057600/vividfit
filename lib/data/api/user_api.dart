import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'package:vividfit_v2/core/network/api_client.dart';
import 'package:vividfit_v2/data/models/network/user_info_dto.dart';

/// 用户接口服务（需要登录）
class UserApi {
  final ApiClient _client;

  UserApi(this._client);

  /// 获取用户信息
  Future<UserInfoResultDto> getUserInfo({
    required int userId,
  }) async {
    return _client.getRaw<UserInfoResultDto>(
      ApiConstants.userInfo,
      queryParameters: {'userId': userId},
      parser: (json) => UserInfoResultDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 修改用户信息
  Future<Map<String, dynamic>> updateUserInfo({
    required UserInfoDto newUserInfo,
  }) async {
    return _client.putRaw<Map<String, dynamic>>(
      ApiConstants.userInfo,
      data: newUserInfo.toJson(),
      parser: (json) => json as Map<String, dynamic>,
    );
  }

  /// 修改用户头像
  Future<String> updateHeadImg({
    required int userId,
    required String newHeadImgPath,
  }) async {
    return _client.putRaw<String>(
      ApiConstants.updateHeadImg,
      queryParameters: {'userId': userId},
      parser: (json) => json.toString(),
    );
  }

  /// 退出登录
  Future<void> signOut() async {
    await _client.get<void>(
      ApiConstants.signOut,
      parser: (json) {},
    );
  }

  /// 注销账号
  Future<void> deleteAccount() async {
    await _client.get<void>(
      ApiConstants.deleteAccount,
      parser: (json) {},
    );
  }

  /// 修改邮箱
  Future<void> updateMail({
    required int userId,
    required String newMail,
    required String code,
    required String businessType,
  }) async {
    await _client.put<void>(
      ApiConstants.updateMail,
      queryParameters: {
        'userId': userId,
        'newMail': newMail,
        'code': code,
        'businessType': businessType,
      },
      parser: (json) {},
    );
  }

  /// 修改手机号
  Future<void> updatePhone({
    required int userId,
    required String phoneNumber,
    required String areaCode,
    required String code,
    required String businessType,
  }) async {
    await _client.put<void>(
      ApiConstants.updatePhone,
      queryParameters: {
        'userId': userId,
        'phoneNumber': phoneNumber,
        'areaCode': areaCode,
        'code': code,
        'businessType': businessType,
      },
      parser: (json) {},
    );
  }

  /// 解绑第三方账号
  Future<List<dynamic>> unbindThirdPart({
    required int thirdPartUserId,
  }) async {
    return _client.deleteRaw<List<dynamic>>(
      ApiConstants.unbindThirdPart,
      queryParameters: {'thirdPartUserId': thirdPartUserId},
      parser: (json) => json as List<dynamic>,
    );
  }

  /// 加绑微信
  Future<List<dynamic>> bindWeixin({
    required String code,
  }) async {
    return _client.postRaw<List<dynamic>>(
      ApiConstants.bindWeixin,
      queryParameters: {'code': code},
      parser: (json) => json as List<dynamic>,
    );
  }
}