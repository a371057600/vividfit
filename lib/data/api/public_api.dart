import 'package:dio/dio.dart';
import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'package:vividfit_v2/core/network/api_client.dart';
import 'package:vividfit_v2/data/models/login_response.dart';

/// 公共接口服务（无需登录）
class PublicApi {
  final ApiClient _client;

  PublicApi(this._client);

  /// 密码登录
  Future<LoginData> loginByPassword({
    required String bindingAccount,
    required String password,
  }) async {
    return _client.postRaw<LoginData>(
      ApiConstants.pwdLogin,
      queryParameters: {
        'bindingAccount': bindingAccount,
        'password': password,
      },
      parser: (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 邮箱验证码登录
  Future<LoginData> loginByMailVerificationCode({
    required String mailAddress,
    required String code,
    required String businessType,
  }) async {
    return _client.postRaw<LoginData>(
      ApiConstants.mailLogin,
      queryParameters: {
        'mailAddress': mailAddress,
        'code': code,
        'businessType': businessType,
      },
      parser: (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 手机验证码登录
  Future<LoginData> loginByPhoneVerificationCode({
    required String phoneNumber,
    required String areaCode,
    required String code,
    required String businessType,
  }) async {
    return _client.postRaw<LoginData>(
      ApiConstants.phoneLogin,
      queryParameters: {
        'phoneNumber': phoneNumber,
        'areaCode': areaCode,
        'code': code,
        'businessType': businessType,
      },
      parser: (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 微信第三方登录
  Future<LoginData> loginByWeixin({
    required String code,
    String? lang,
  }) async {
    return _client.postRaw<LoginData>(
      ApiConstants.weixinLogin,
      queryParameters: {
        'code': code,
        if (lang != null) 'lang': lang,
      },
      parser: (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 检查邮箱是否已绑定
  Future<Map<String, dynamic>> checkBindMail({
    required String mailAddress,
  }) async {
    return _client.getRaw<Map<String, dynamic>>(
      ApiConstants.checkBindMail,
      queryParameters: {'mailAddress': mailAddress},
      parser: (json) => json as Map<String, dynamic>,
    );
  }

  /// 检查手机号是否已绑定
  Future<Map<String, dynamic>> checkBindPhone({
    required String phoneNumber,
  }) async {
    return _client.getRaw<Map<String, dynamic>>(
      ApiConstants.checkBindPhone,
      queryParameters: {'phoneNumber': phoneNumber},
      parser: (json) => json as Map<String, dynamic>,
    );
  }

  /// 修改密码
  Future<void> updatePassword({
    required int userId,
    required String newPassword,
  }) async {
    await _client.post<void>(
      ApiConstants.updatePassword,
      queryParameters: {
        'userId': userId,
        'newPassword': newPassword,
      },
      parser: (json) => null,
    );
  }

  /// 刷新 token
  Future<String> refreshToken() async {
    return _client.getRaw<String>(
      ApiConstants.refreshToken,
      parser: (json) => json.toString(),
    );
  }

  /// 验证码校验
  Future<void> checkVerCode({
    required String target,
    required String code,
    required String businessType,
  }) async {
    await _client.get<void>(
      ApiConstants.checkVerCode,
      queryParameters: {
        'target': target,
        'code': code,
        'businessType': businessType,
      },
      parser: (json) => null,
    );
  }

  /// 向邮箱发送验证码
  Future<void> sendMailVerCode({
    required String mailAddress,
    required String businessType,
    bool? isCn,
  }) async {
    await _client.get<void>(
      ApiConstants.sendMailVerCode,
      queryParameters: {
        'mailAddress': mailAddress,
        'businessType': businessType,
        if (isCn != null) 'isCn': isCn,
      },
      parser: (json) => null,
    );
  }

  /// 向手机发送验证码
  Future<void> sendPhoneVerCode({
    required String phoneNumber,
    required String areaCode,
    required String businessType,
    bool? isCn,
  }) async {
    await _client.get<void>(
      ApiConstants.sendPhoneVerCode,
      queryParameters: {
        'phoneNumber': phoneNumber,
        'areaCode': areaCode,
        'businessType': businessType,
        if (isCn != null) 'isCn': isCn,
      },
      parser: (json) => null,
    );
  }
}