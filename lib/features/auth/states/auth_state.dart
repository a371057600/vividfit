import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/user_info.dart';

part 'auth_state.freezed.dart';

/// 登录模块状态(字段对应旧项目 NewLoginController 的 .obs 变量)。
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    // ---- 通用 ----
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    @Default(false) bool agreedToPrivacy,
    String? accessToken,
    int? userId,
    FitUserInfo? userInfo,
    String? errorMessage,

    // ---- 表单字段(对应旧 .obs 变量)----
    @Default('') String emailAccount, // 邮箱/账号(bindingAccount)
    @Default('') String password, // 密码
    @Default('') String changepassword, // 新密码(找回密码用)
    @Default('') String countryCode, // 国家码 "86"
    @Default(0) int phoneNumber, // 手机号
    @Default('') String captcha, // 验证码
    @Default('') String wechatCode, // 微信 code(预留)

    // ---- 倒计时 ----
    @Default(60) int countdown, // 倒计时秒数
    @Default(true) bool reGetCode, // 可重新获取验证码
    @Default(true) bool reGetCode2, // 可重新获取验证码(备用标志)

    // ---- UI 状态 ----
    @Default(true) bool showPassword, // 是否隐藏密码(true=隐藏)
    @Default(0) int loginType, // 登录类型:1=手机 2=邮箱
    @Default(false) bool ishasInternet, // 是否有网络
    @Default(1) int languageNum, // 0=简中 1=英 2=繁中(决定登录入口显示与服务器)
  }) = _AuthState;
}
