import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/user_info.dart';

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
    print(
      '🔐 [AuthRepo.login] response code=${response.code} msg=${response.msg}',
    );
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
    print(
      '🔐 [AuthRepo.emailLogin] response code=${response.code} msg=${response.msg}',
    );
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
    print(
      '🔐 [AuthRepo.phoneLogin] response code=${response.code} msg=${response.msg}',
    );
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
    print(
      '🔐 [AuthRepo.sendPhone] area=$areaCode phone=$phoneNumber isCn=$isCn',
    );
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
    print(
      '🔐 [WeChat] wechatLogin PLACEHOLDER called, code=${code.substring(0, code.length > 6 ? 6 : code.length)}...',
    );
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

  // ============ 用户信息获取 ============

  /// 获取用户信息(GET /api/user/info?userId=xxx)。
  /// 对应旧项目 controller_home/controller_body_data/controller_about_user_head
  /// 的 getUserInfo 调用,返回解析后的 FitUserInfo。
  Future<FitUserInfo?> getUserInfo(int userId) async {
    print('🔐 [AuthRepo.getUserInfo] userId=$userId');
    try {
      final response = await _api.getRaw<Map<String, dynamic>>(
        ApiConstants.userInfo,
        queryParameters: {'userId': userId},
        options: _publicOptions,
        parser: (json) => json as Map<String, dynamic>,
      );
      // 打印服务器完整原始返回,便于确认字段格式(尤其 headImage)
      print('🔐 [AuthRepo.getUserInfo] RAW RESPONSE = $response');
      if (response['code']?.toString() != '200') {
        print('🔐 [AuthRepo.getUserInfo] fail code=${response['code']}');
        return null;
      }
      final data = response['data'];
      if (data is Map && data['userInfo'] is Map) {
        final userInfoMap = data['userInfo'] as Map<String, dynamic>;
        print('🔐 [AuthRepo.getUserInfo] data.userInfo = $userInfoMap');
        final info = FitUserInfo.fromJson(userInfoMap);
        print(
          '🔐 [AuthRepo.getUserInfo] parsed: '
          'id=${info.id} nickName=${info.nickName} '
          'sex=${info.sex} birthday=${info.birthday} '
          'height=${info.height} weight=${info.weight} '
          'headImage=${info.headImage} '
          'mailAddress=${info.mailAddress} phoneNumber=${info.phoneNumber}',
        );
        return info;
      }
      print('🔐 [AuthRepo.getUserInfo] data format unexpected: $data');
      return null;
    } catch (e) {
      print('🔐 [AuthRepo.getUserInfo] error: $e');
      return null;
    }
  }

  // ============ 头像上传 ============

  /// 上传用户头像(PUT /api/user/headImg,FormData)。
  /// 对应旧项目 controller_about_user_head.updateUserImage。
  /// [imageFile] 裁剪后(已压缩)的图片文件;[userId] 用户 ID;[accessToken] 登录 token。
  /// [onSendProgress] 上传进度回调(count已发送,total总大小)。
  Future<bool> uploadHeadImage({
    required File imageFile,
    required int userId,
    required String accessToken,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final fileSize = await imageFile.length();
    print(
      '📤 [AuthRepo.uploadHeadImage] userId=$userId file=${imageFile.path} size=$fileSize bytes',
    );
    try {
      final formData = FormData.fromMap({
        'newHeadImg': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'userImage.jpg',
        ),
        'userId': userId,
      });
      final response = await _api.uploadFormData<Map<String, dynamic>>(
        'PUT',
        ApiConstants.updateHeadImg,
        data: formData,
        headers: {
          ApiConstants.headerAppPass: ApiConstants.appPass,
          ApiConstants.headerAccessToken: accessToken,
        },
        parser: (json) => json as Map<String, dynamic>,
        onSendProgress: onSendProgress,
      );
      final code = response['code']?.toString();
      final ok = code == '200';
      print('📤 [AuthRepo.uploadHeadImage] code=$code ok=$ok');
      return ok;
    } catch (e) {
      print('❌ [AuthRepo.uploadHeadImage] error: $e');
      return false;
    }
  }

  /// 上传默认头像(从 asset 加载 bytes 后上传)。
  /// 对应旧项目 controller_about_user_head.saveImageLocal + updateInsetImage。
  /// [onSendProgress] 上传进度回调。
  Future<bool> uploadAssetHeadImage({
    required ByteData assetBytes,
    required String assetPath,
    required int userId,
    required String accessToken,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    print('📤 [AuthRepo.uploadAssetHeadImage] userId=$userId asset=$assetPath');
    try {
      final imageBytes = assetBytes.buffer.asUint8List();
      print(
        '📤 [AuthRepo.uploadAssetHeadImage] size=${imageBytes.length} bytes',
      );
      final formData = FormData.fromMap({
        'newHeadImg': MultipartFile.fromBytes(
          imageBytes,
          filename: assetPath.split('/').last,
        ),
        'userId': userId,
      });
      final response = await _api.uploadFormData<Map<String, dynamic>>(
        'PUT',
        ApiConstants.updateHeadImg,
        data: formData,
        headers: {
          ApiConstants.headerAppPass: ApiConstants.appPass,
          ApiConstants.headerAccessToken: accessToken,
        },
        parser: (json) => json as Map<String, dynamic>,
        onSendProgress: onSendProgress,
      );
      final code = response['code']?.toString();
      final ok = code == '200';
      print('📤 [AuthRepo.uploadAssetHeadImage] code=$code ok=$ok');
      return ok;
    } catch (e) {
      print('❌ [AuthRepo.uploadAssetHeadImage] error: $e');
      return false;
    }
  }
}
