import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_info.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 登录接口响应(迁移自旧项目 LoginInfo)。
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    String? code, // "200" 成功 / "201" 新注册 / "400"/"402"/"403"/"412" 失败
    String? msg,
    LoginData? data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 登录响应 data 字段(迁移自旧项目 Data)。
@freezed
class LoginData with _$LoginData {
  const factory LoginData({
    FitUserInfo? userInfo,
    String? token,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
