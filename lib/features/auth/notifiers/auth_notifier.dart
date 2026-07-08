import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/user_info.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';

/// 登录状态机(1:1 迁移自旧项目 NewLoginController)。
///
/// 保留原逻辑:
/// - passWordLogin + verificationLogin(账号密码登录 + code 分支)
/// - getEmailCaptcha / getPhoneCaptcha(发验证码 + 60s 倒计时)
/// - selectLoginType → phoneCaptchaLogin / emailCaptchaLogin(验证码登录)
/// - checkCaptcha + _setNewPassword(找回密码)
/// - connectivity 网络检测
/// - code 200 → 首页,201 → 首页(旧项目跳昵称设置,本阶段先跳首页,后续 profile 模块补)
/// - code 400 → 验证码错误,402/403/412 → 旧项目空处理,else → 验证码错误
///
/// 导航不在 Notifier 里做(旧项目用 Get.off),改由 UI 层根据状态/返回值跳转。
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository, this._storage) : super(const AuthState()) {
    _restoreFromStorage();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (_, __) {
        // 平台通道异常时忽略,保持现有网络状态(与旧项目静默处理一致)。
      },
    );
  }

  final AuthRepository _repository;
  final StorageService _storage;

  // ---- 倒计时 / 网络检测 ----
  Timer? _timer;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void dispose() {
    _timer?.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// 启动时从本地存储恢复登录态。
  void _restoreFromStorage() {
    final token = _storage.accessToken;
    final userId = _storage.userId;
    final userInfoJson = _storage.userInfoJson;
    UserInfo? userInfo;
    if (userInfoJson != null) {
      try {
        userInfo = UserInfo.fromJson(
          jsonDecode(userInfoJson) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    var newState = state.copyWith(languageNum: _storage.languageNum);
    if (token != null && token.isNotEmpty) {
      newState = newState.copyWith(
        isAuthenticated: true,
        accessToken: token,
        userId: userId,
        userInfo: userInfo,
      );
    }
    state = newState;
  }

  // ============ 表单 setter(对应旧 .obs 赋值)============

  void setEmailAccount(String value) =>
      state = state.copyWith(emailAccount: value, errorMessage: null);
  void setPassword(String value) =>
      state = state.copyWith(password: value, errorMessage: null);
  void setChangePassword(String value) =>
      state = state.copyWith(changepassword: value, errorMessage: null);
  void setCountryCode(String value) =>
      state = state.copyWith(countryCode: value);
  void setPhoneNumber(int value) => state = state.copyWith(phoneNumber: value);
  void setCaptcha(String value) => state = state.copyWith(captcha: value);

  void togglePrivacyAgreement() =>
      state = state.copyWith(agreedToPrivacy: !state.agreedToPrivacy);
  void toggleShowPassword() =>
      state = state.copyWith(showPassword: !state.showPassword);

  // ============ 网络检测(对应旧 initConnectivity)============

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (_) {}
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final hasInternet = !result.contains(ConnectivityResult.none);
    state = state.copyWith(ishasInternet: hasInternet);
  }

  // ============ 账号密码登录(对应旧 passWordLogin + verificationLogin)============

  /// 账号密码登录。成功返回 true,失败返回 false(错误信息在 errorMessage)。
  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _repository.login(
        account: state.emailAccount,
        password: state.password,
      );
      final ok = await _handleVerification(response);
      state = state.copyWith(isLoading: false);
      return ok;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error: $e',
      );
      return false;
    }
  }

  // ============ 验证码登录(对应旧 selectLoginType + phoneCaptchaLogin/emailCaptchaLogin)============

  /// Pinput 输入完成时调用(对应旧 selectLoginType):写入验证码后按 loginType 登录。
  /// 返回 true 表示登录成功(UI 层据此由路由重定向到首页)。
  Future<bool> selectLoginType(String pin) async {
    state = state.copyWith(captcha: pin);
    return captchaLogin();
  }

  /// 根据 loginType 调用手机/邮箱验证码登录。成功返回 true。
  Future<bool> captchaLogin() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final LoginResponse response;
      if (state.loginType == 1) {
        response = await _repository.phoneCaptchaLogin(
          areaCode: state.countryCode,
          phoneNumber: state.phoneNumber.toString(),
          code: state.captcha,
        );
      } else {
        response = await _repository.emailCaptchaLogin(
          mailAddress: state.emailAccount,
          code: state.captcha,
        );
      }
      final ok = await _handleVerification(response);
      state = state.copyWith(isLoading: false);
      return ok;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error: $e',
      );
      return false;
    }
  }

  // ============ verificationLogin(code 分支,1:1 迁移)============

  /// 处理登录响应,返回是否成功。
  Future<bool> _handleVerification(LoginResponse response) async {
    final code = response.code;
    if (code == '201') {
      // 注册(旧项目跳昵称设置页,本阶段先按登录成功处理,后续 profile 模块补)
      await _persistSession(response);
      return true;
    } else if (code == '200') {
      // 登录成功
      await _persistSession(response);
      return true;
    } else if (code == '400') {
      state = state.copyWith(errorMessage: 'Incorrect verification code.');
      return false;
    } else if (code == '402' || code == '403' || code == '412') {
      // 旧项目这些分支为空(注释掉了),这里也保持空处理
      return false;
    } else {
      state = state.copyWith(errorMessage: 'Incorrect verification code.');
      return false;
    }
  }

  /// 持久化登录态(对应旧 verificationLogin 200/201 的 box.write)。
  Future<void> _persistSession(LoginResponse response) async {
    final token = response.data?.token;
    final userInfo = response.data?.userInfo;
    final userId = userInfo?.id;
    if (token != null && userId != null) {
      await _storage.setAccessToken(token);
      await _storage.setUserId(userId);
      await _storage.setHeadImageHash(userInfo?.headImage ?? '');
      await _storage.setHasPassword(userInfo?.hasPsw ?? false);
      if (userInfo != null) {
        await _storage.setUserInfoJson(jsonEncode(userInfo.toJson()));
      }
      await _storage.setFirstOpenApp(false);
      state = state.copyWith(
        isAuthenticated: true,
        accessToken: token,
        userId: userId,
        userInfo: userInfo,
        errorMessage: null,
      );
    }
  }

  // ============ 发送验证码(对应旧 getEmailCaptcha / getPhoneCaptcha)============

  /// 发送邮箱验证码。成功返回 true(页面据此跳转 GetCode 页)。
  Future<bool> sendEmailCaptcha() async {
    if (!state.ishasInternet ||
        state.emailAccount.isEmpty ||
        !state.reGetCode2) {
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final ok = await _repository.sendEmailCaptcha(state.emailAccount);
      if (ok) {
        state = state.copyWith(loginType: 2, isLoading: false);
        _startCountdown();
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error: $e',
      );
      return false;
    }
  }

  /// 发送手机验证码。成功返回 true。
  Future<bool> sendPhoneCaptcha() async {
    if (!state.ishasInternet || state.phoneNumber == 0 || !state.reGetCode2) {
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final ok = await _repository.sendPhoneCaptcha(
        areaCode: state.countryCode,
        phoneNumber: state.phoneNumber.toString(),
      );
      if (ok) {
        state = state.copyWith(loginType: 1, isLoading: false);
        _startCountdown();
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error: $e',
      );
      return false;
    }
  }

  /// 重新获取验证码(对应旧 getCodeAgain)。
  Future<void> regetCode() async {
    if (!state.ishasInternet) return;
    if (state.loginType == 2) {
      await sendEmailCaptcha();
    } else if (state.loginType == 1) {
      await sendPhoneCaptcha();
    }
  }

  // ============ 倒计时(对应旧 _getCodeTime + startcountDownTimer)============

  void _startCountdown() {
    state = state.copyWith(reGetCode: false, reGetCode2: false);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(
          reGetCode: true,
          reGetCode2: true,
          countdown: 60,
        );
      }
    });
    // 60 秒后恢复可重新获取(对应旧 Future.delayed)
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        state = state.copyWith(reGetCode: true, reGetCode2: true);
      }
    });
  }

  // ============ 找回密码(对应旧 checkCaptcha + _setNewPassword)============

  /// 找回密码:校验验证码 → 查账号 → 改密码。成功返回 true。
  Future<bool> checkCaptchaAndResetPassword() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final codeOk = await _repository.checkCaptcha(
        target: state.emailAccount,
        code: state.captcha,
      );
      if (!codeOk) {
        state = state.copyWith(isLoading: false);
        return false;
      }
      final accountId = await _repository.checkBindMail(state.emailAccount);
      if (accountId == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }
      final ok = await _repository.updatePassword(
        userId: accountId,
        newPassword: state.changepassword,
      );
      state = state.copyWith(isLoading: false);
      return ok;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error: $e',
      );
      return false;
    }
  }

  // ============ 登出 ============

  Future<void> logout() async {
    await _storage.clearAuth();
    // 保留语言设置,清除其余状态。
    state = AuthState(languageNum: state.languageNum);
  }
}
