import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/login_response.dart';

/// 登录数据仓库(1:1 迁移自旧项目 NewLoginController 的网络调用部分)。
///
/// 保留原请求方式:GET/POST + queryParameters + headers{app_pass} + 50s 超时。
/// CN/AWS 服务器切换由 [ApiConstants] 单端点承担(当前默认 CN),后续 i18n 模块再加分支。
class AuthRepository {
  AuthRepository(this._api);

  final ApiService _api;

  /// 请求头 app_pass(旧项目统一带上)。
  Options get _appPassOptions => Options(
        headers: const {ApiConstants.headerAppPass: ApiConstants.appPass},
        sendTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 50),
      );

  /// 账号密码登录(旧 passWordLogin)。
  Future<LoginResponse> login({
    required String account,
    required String password,
  }) async {
    final json = await _api.post(
      ApiConstants.pwdLoginUrl,
      queryParameters: {
        'password': password,
        'bindingAccount': account,
      },
      options: _appPassOptions,
    );
    return LoginResponse.fromJson(json);
  }

  /// 邮箱验证码登录(旧 emailCaptchaLogin)。
  Future<LoginResponse> emailCaptchaLogin({
    required String mailAddress,
    required String code,
  }) async {
    final json = await _api.post(
      ApiConstants.mailLoginUrl,
      queryParameters: {
        'mailAddress': mailAddress,
        'code': code,
        'businessType': 'mailLogin',
      },
      options: _appPassOptions,
    );
    return LoginResponse.fromJson(json);
  }

  /// 手机验证码登录(旧 phoneCaptchaLogin)。
  Future<LoginResponse> phoneCaptchaLogin({
    required String areaCode,
    required String phoneNumber,
    required String code,
  }) async {
    final json = await _api.post(
      ApiConstants.phoneLoginUrl,
      queryParameters: {
        'areaCode': areaCode,
        'code': code,
        'phoneNumber': phoneNumber,
        'businessType': 'phoneLogin',
      },
      options: _appPassOptions,
    );
    return LoginResponse.fromJson(json);
  }

  /// 发送邮箱验证码(旧 getEmailCaptcha)。成功返回 true。
  Future<bool> sendEmailCaptcha(String mailAddress) async {
    final json = await _api.get(
      ApiConstants.sendMailNumberUrl,
      queryParameters: {
        'mailAddress': mailAddress,
        'businessType': 'mailLogin',
        'isCn': false,
      },
      options: _appPassOptions,
    );
    return !json.containsKey('error');
  }

  /// 发送手机验证码(旧 getPhoneCaptcha)。成功返回 true。
  Future<bool> sendPhoneCaptcha({
    required String areaCode,
    required String phoneNumber,
  }) async {
    final json = await _api.get(
      ApiConstants.sendPhoneNumberUrl,
      queryParameters: {
        'areaCode': areaCode,
        'phoneNumber': phoneNumber,
        'businessType': 'phoneLogin',
        'isCn': areaCode == '86',
      },
      options: _appPassOptions,
    );
    return !json.containsKey('error');
  }

  /// 校验验证码(旧 checkCaptcha)。code=="200" 返回 true。
  Future<bool> checkCaptcha({
    required String target,
    required String code,
  }) async {
    final json = await _api.get(
      ApiConstants.checkNumberUrl,
      queryParameters: {
        'target': target,
        'code': code,
        'businessType': 'mailLogin',
      },
      options: _appPassOptions,
    );
    return json['code'] == '200';
  }

  /// 查邮箱绑定账号(旧 _setNewPassword 第一步)。返回 accountId,失败返回 null。
  Future<int?> checkBindMail(String mailAddress) async {
    final json = await _api.get(
      ApiConstants.checkBindMailUrl,
      queryParameters: {'mailAddress': mailAddress},
      options: _appPassOptions,
    );
    if (json['code'] == '200') {
      final data = json['data'];
      if (data is Map && data['id'] is int) return data['id'] as int;
    }
    return null;
  }

  /// 修改密码(旧 _setNewPassword 第二步)。code=="200" 返回 true。
  Future<bool> updatePassword({
    required int userId,
    required String newPassword,
  }) async {
    final json = await _api.put(
      ApiConstants.updatePwdUrl,
      queryParameters: {
        'userId': userId,
        'newPassword': newPassword,
      },
      options: _appPassOptions,
    );
    return json['code'] == '200';
  }
}
