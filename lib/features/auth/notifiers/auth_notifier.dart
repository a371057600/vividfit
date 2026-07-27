import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/user_info.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';
import 'auth_repository_provider.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _storage = ref.watch(storageServiceProvider);
    _connectivity = Connectivity();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (_, __) {
      },
    );
    ref.onDispose(() {
      _timer?.cancel();
      _connectivitySubscription.cancel();
    });
    return _buildInitialState();
  }

  late AuthRepository _repository;
  late StorageService _storage;
  late Connectivity _connectivity;
  Timer? _timer;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  AuthState _buildInitialState() {
    final token = _storage.accessToken;
    final userId = _storage.userId;
    final userInfoJson = _storage.userInfoJson;
    FitUserInfo? userInfo;
    if (userInfoJson != null) {
      try {
        userInfo = FitUserInfo.fromJson(
          jsonDecode(userInfoJson) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    var state = AuthState(languageNum: _storage.languageNum);
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(
        isAuthenticated: true,
        accessToken: token,
        userId: userId,
        userInfo: userInfo,
      );
    }
    return state;
  }

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

  Future<bool> selectLoginType(String pin) async {
    state = state.copyWith(captcha: pin);
    return captchaLogin();
  }

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

  Future<bool> _handleVerification(LoginResponse response) async {
    final code = response.code;
    if (code == '201') {
      await _persistSession(response);
      return true;
    } else if (code == '200') {
      await _persistSession(response);
      return true;
    } else if (code == '400') {
      state = state.copyWith(errorMessage: 'Incorrect verification code.');
      return false;
    } else if (code == '402' || code == '403' || code == '412') {
      return false;
    } else {
      state = state.copyWith(errorMessage: 'Incorrect verification code.');
      return false;
    }
  }

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
        await _storage.setFitUserInfoJson(jsonEncode(userInfo.toJson()));
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

  Future<void> regetCode() async {
    if (!state.ishasInternet) return;
    if (state.loginType == 2) {
      await sendEmailCaptcha();
    } else if (state.loginType == 1) {
      await sendPhoneCaptcha();
    }
  }

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
    Future.delayed(const Duration(seconds: 60), () {
      try {
        state = state.copyWith(reGetCode: true, reGetCode2: true);
      } catch (_) {
      }
    });
  }

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

  Future<void> logout() async {
    await _storage.clearAuth();
    state = AuthState(languageNum: state.languageNum);
  }

  Future<void> devLogin() async {
    await _storage.setAccessToken('dev_token');
    await _storage.setUserId(1);
    await _storage.setHeadImageHash('');
    await _storage.setHasPassword(true);
    state = state.copyWith(
      isAuthenticated: true,
      accessToken: 'dev_token',
      userId: 1,
    );
  }
}