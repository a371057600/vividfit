import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/login_response.dart';

/// 认证仓储(仅国内服务器,无需 AWS 切换)。
///
/// 所有请求都自动附加 app_pass header(由 ApiClient interceptors 统一注入)。
class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Options get _publicOptions => Options(
    sendTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  );

  /// 密码登录(Account Login),对应旧 pwdLoginUrl。
  Future<LoginResponse> login({
    required String account,
    required String password,
  }) async {
    print('🔐 [AuthRepo.login] bindingAccount=$account');
    final response = await _api.postRaw<LoginResponse>(
      ApiConstants.pwdLoginUrl,
      queryParameters: {'password': password, 'bindingAccount': account},
      options: _publicOptions,
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
    print('🔐 [AuthRepo.login] response code=${response.code} msg=${response.msg}');
    return response;
  }

  /// 邮箱验证码登录,对应旧 mailLoginUrl。
  Future<LoginResponse> emailCaptchaLogin({
    required String mailAddress,
    required String code,
  }) async {
    print('🔐 [AuthRepo.emailLogin] mail=$mailAddress codeLen=${code.length}');
    final response = await _api.postRaw<LoginResponse>(
      ApiConstants.mailLoginUrl,
      queryParameters: {
        'mailAddress': mailAddress,
        'code': code,
        'businessType': 'mailLogin',
      },
      options: _publicOptions,
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
    print('🔐 [AuthRepo.emailLogin] response code=${response.code} msg=${response.msg}');
    return response;
  }

  /// 手机验证码登录,对应旧 phoneLoginUrl。
  Future<LoginResponse> phoneCaptchaLogin({
    required String areaCode,
    required String phoneNumber,
    required String code,
  }) async {
    print('🔐 [AuthRepo.phoneLogin] area=$areaCode phone=$phoneNumber');
    final response = await _api.postRaw<LoginResponse>(
      ApiConstants.phoneLoginUrl,
      queryParameters: {
        'areaCode': areaCode,
        'code': code,
        'phoneNumber': phoneNumber,
        'businessType': 'phoneLogin',
      },
      options: _publicOptions,
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
    print('🔐 [AuthRepo.phoneLogin] response code=${response.code} msg=${response.msg}');
    return response;
  }

  /// 发送邮箱验证码,对应旧 sendMailNumberUrl。
  /// isCn:国家码==86 或 languageNum==0 时 true。
  Future<bool> sendEmailCaptcha(String mailAddress, {bool isCn = false}) async {
    print('🔐 [AuthRepo.sendMail] mail=$mailAddress isCn=$isCn');
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.sendMailNumberUrl,
      queryParameters: {
        'mailAddress': mailAddress,
        'businessType': 'mailLogin',
        'isCn': isCn,
      },
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    final ok = response['code']?.toString() == '200';
    print('🔐 [AuthRepo.sendMail] code=${response['code']} ok=$ok');
    return ok;
  }

  /// 发送手机验证码,对应旧 sendPhoneNumberUrl。
  Future<bool> sendPhoneCaptcha({
    required String areaCode,
    required String phoneNumber,
  }) async {
    final isCn = areaCode == '86';
    print('🔐 [AuthRepo.sendPhone] area=$areaCode phone=$phoneNumber isCn=$isCn');
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.sendPhoneNumberUrl,
      queryParameters: {
        'areaCode': areaCode,
        'phoneNumber': phoneNumber,
        'businessType': 'phoneLogin',
        'isCn': isCn,
      },
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    final ok = response['code']?.toString() == '200';
    print('🔐 [AuthRepo.sendPhone] code=${response['code']} ok=$ok');
    return ok;
  }

  /// 验证码校验(找回密码第1步),对应旧 checkNumberUrl。
  Future<bool> checkCaptcha({
    required String target,
    required String code,
  }) async {
    print('🔐 [AuthRepo.checkCaptcha] target=$target codeLen=${code.length}');
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.checkNumberUrl,
      queryParameters: {
        'target': target,
        'code': code,
        'businessType': 'mailLogin',
      },
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    final ok = response['code']?.toString() == '200';
    print('🔐 [AuthRepo.checkCaptcha] code=${response['code']} ok=$ok');
    return ok;
  }

  /// 检查邮箱是否已绑定并返回 userId,对应旧 checkBindMailUrl。
  Future<int?> checkBindMail(String mailAddress) async {
    print('🔐 [AuthRepo.checkBindMail] mail=$mailAddress');
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.checkBindMailUrl,
      queryParameters: {'mailAddress': mailAddress},
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    if (response['code']?.toString() != '200') {
      print('🔐 [AuthRepo.checkBindMail] fail code=${response['code']}');
      return null;
    }
    final data = response['data'];
    final id = data is Map && data['id'] is int ? data['id'] as int : null;
    print('🔐 [AuthRepo.checkBindMail] userId=$id');
    return id;
  }

  /// 修改密码(找回密码第3步),对应旧 updatePwdUrl。
  Future<bool> updatePassword({
    required int userId,
    required String newPassword,
  }) async {
    print('🔐 [AuthRepo.updatePwd] userId=$userId');
    final response = await _api.putRaw<Map<String, dynamic>>(
      ApiConstants.updatePwdUrl,
      queryParameters: {'userId': userId, 'newPassword': newPassword},
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    final ok = response['code']?.toString() == '200';
    print('🔐 [AuthRepo.updatePwd] code=${response['code']} ok=$ok');
    return ok;
  }

  // ==================== 微信登录占位(后续接入打开) ====================

  /// 占位:微信第三方登录(后续接入 Fluwx SDK 后填充)。
  Future<LoginResponse> wechatLogin({required String code}) async {
    print('🔐 [WeChat] wechatLogin PLACEHOLDER called, code=${code.substring(0, code.length > 6 ? 6 : code.length)}...');
    // TODO(wechat): 接入 Fluwx SDK 后改为真实 POST /api/public/login/thirdPart/weixin
    throw UnimplementedError('微信登录未上线');
  }

  // ============ 注册流程:用户数据提交 ============

  /// 提交用户完整资料到服务端(PUT /api/user/info)。
  /// 对应旧项目 GetUserInfoApi + NewUserDataSettingController.updateInofo()。
  Future<bool> updateUserInfo(Map<String, dynamic> data) async {
    print('📡 [AuthRepo.updateUserInfo] payload=$data');
    final response = await _api.putRaw<Map<String, dynamic>>(
      ApiConstants.userInfo,
      data: data,
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    final code = response['code']?.toString() ?? response['result']?.toString();
    final ok = code == '200' || code == '0';
    print('📡 [AuthRepo.updateUserInfo] code=$code ok=$ok');
    return ok;
  }
}
