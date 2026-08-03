import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/login_response.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Options get _publicOptions => Options(
    sendTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  );

  Future<LoginResponse> login({
    required String account,
    required String password,
  }) async {
    final response = await _api.postRaw<LoginResponse>(
      ApiConstants.pwdLoginUrl,
      queryParameters: {'password': password, 'bindingAccount': account},
      options: _publicOptions,
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<LoginResponse> emailCaptchaLogin({
    required String mailAddress,
    required String code,
  }) async {
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
    return response;
  }

  Future<LoginResponse> phoneCaptchaLogin({
    required String areaCode,
    required String phoneNumber,
    required String code,
  }) async {
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
    return response;
  }

  Future<bool> sendEmailCaptcha(String mailAddress) async {
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.sendMailNumberUrl,
      queryParameters: {
        'mailAddress': mailAddress,
        'businessType': 'mailLogin',
        'isCn': false,
      },
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    return response['code']?.toString() == '200';
  }

  Future<bool> sendPhoneCaptcha({
    required String areaCode,
    required String phoneNumber,
  }) async {
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.sendPhoneNumberUrl,
      queryParameters: {
        'areaCode': areaCode,
        'phoneNumber': phoneNumber,
        'businessType': 'phoneLogin',
        'isCn': areaCode == '86',
      },
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    return response['code']?.toString() == '200';
  }

  Future<bool> checkCaptcha({
    required String target,
    required String code,
  }) async {
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
    return response['code']?.toString() == '200';
  }

  Future<int?> checkBindMail(String mailAddress) async {
    final response = await _api.getRaw<Map<String, dynamic>>(
      ApiConstants.checkBindMailUrl,
      queryParameters: {'mailAddress': mailAddress},
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    if (response['code']?.toString() != '200') return null;
    final data = response['data'];
    if (data is Map && data['id'] is int) return data['id'] as int;
    return null;
  }

  Future<bool> updatePassword({
    required int userId,
    required String newPassword,
  }) async {
    final response = await _api.putRaw<Map<String, dynamic>>(
      ApiConstants.updatePwdUrl,
      queryParameters: {'userId': userId, 'newPassword': newPassword},
      options: _publicOptions,
      parser: (json) => json as Map<String, dynamic>,
    );
    return response['code']?.toString() == '200';
  }
}