import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/user_info.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';
import 'auth_repository_provider.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _storage = ref.watch(storageServiceProvider);
    _connectivity = Connectivity();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (_, _) {},
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
    print('🔐 [AuthNotifier.build] initial isAuth=${state.isAuthenticated} '
        'userId=${state.userId} lang=${state.languageNum}');
    return state;
  }

  // ============ 表单字段 setter ============

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

  // ============ 网络检测 ============

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

  // ============ 登录结果分发(核心,对应旧 verificationLogin) ============

  /// 分发登录结果 → 返回登录是否整体成功(可跳转)。
  /// code=200→已注册用户;201→新用户(需走昵称设置流程)
  Future<bool> _handleVerification(LoginResponse response) async {
    final code = response.code;
    state = state.copyWith(loginResultCode: code);
    print('🔐 [AuthNotifier._handleVerification] code=$code '
        'hasToken=${response.data?.token != null}');
    if (code == '201') {
      // 新注册用户:存 session + 标记 isNewUser=true → 后续跳到昵称设置
      await _persistSession(response, isNewUser: true);
      _showToastByCode(code);
      return true;
    } else if (code == '200') {
      // 已注册老用户
      await _persistSession(response, isNewUser: false);
      _showToastByCode(code);
      return true;
    } else {
      // 错误码 → 弹对应 Toast
      _showToastByCode(code);
      state = state.copyWith(
        errorMessage: _localizedIncorrectCode(code),
      );
      return false;
    }
  }

  void _showToastByCode(String? code) {
    final msg = _localizedIncorrectCode(code);
    if (msg.isEmpty) return;
    Fluttertoast.showToast(msg: msg);
  }

  /// 对应旧 verificationLogin 的 Toast 分支。
  String _localizedIncorrectCode(String? code) {
    final isCn = state.languageNum == 0 || state.languageNum == 2;
    switch (code) {
      case '200':
      case '201':
        // 成功也 Toast 一下(和旧版一致:通过页面跳转 + Fluttertoast 不直接弹 200,静默)
        return '';
      case '400':
        return isCn ? '验证码错误' : 'Incorrect verification code.';
      case '402':
      case '403':
        return isCn ? '账号或密码错误' : 'Incorrect ID or password.';
      case '412':
        return isCn ? '账号已被禁用' : 'Account disabled.';
      default:
        return isCn ? '登录失败,请稍后重试' : 'Login failed, please retry.';
    }
  }

  String _localizedNetworkError(Object e) {
    final isCn = state.languageNum == 0 || state.languageNum == 2;
    return isCn ? '网络错误: $e' : 'Network error: $e';
  }

  // ============ Session 持久化 ============

  Future<void> _persistSession(LoginResponse response, {required bool isNewUser}) async {
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
      // 只有老用户标记 firstOpenApp=false,新用户走完昵称设置再标
      if (!isNewUser) {
        await _storage.setFirstOpenApp(false);
      }
      state = state.copyWith(
        isAuthenticated: true,
        isNewUser: isNewUser,
        accessToken: token,
        userId: userId,
        userInfo: userInfo,
        errorMessage: null,
      );
      print('🔐 [AuthNotifier._persistSession] userId=$userId '
          'isNewUser=$isNewUser token=${token.substring(0, token.length > 6 ? 6 : token.length)}...');
    }
  }

  // ============ 三种登录方式入口 ============

  /// 密码登录(Account Login)。
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
      print('❌ [AuthNotifier.login] error=$e');
      final msg = _localizedNetworkError(e);
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  /// 验证码类型选择(手机=1/邮箱=2)并登录,对应旧 selectLoginType。
  Future<bool> selectLoginType(String pin) async {
    state = state.copyWith(captcha: pin);
    return captchaLogin();
  }

  /// 短信/邮箱验证码登录。
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
      print('❌ [AuthNotifier.captchaLogin] error=$e');
      final msg = _localizedNetworkError(e);
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  // ============ 发送验证码(带倒计时) ============

  Future<bool> sendEmailCaptcha() async {
    if (!state.ishasInternet ||
        state.emailAccount.isEmpty ||
        !state.reGetCode2) {
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final isCn = state.countryCode == '86' || state.languageNum == 0;
      final ok = await _repository.sendEmailCaptcha(
        state.emailAccount,
        isCn: isCn,
      );
      if (ok) {
        state = state.copyWith(loginType: 2, isLoading: false);
        _startCountdown();
        return true;
      }
      final msg = state.languageNum == 0 || state.languageNum == 2
          ? '发送验证码失败'
          : 'Failed to send verification code.';
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    } catch (e) {
      print('❌ [AuthNotifier.sendEmailCaptcha] error=$e');
      final msg = _localizedNetworkError(e);
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
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
      final msg = state.languageNum == 0 || state.languageNum == 2
          ? '发送验证码失败'
          : 'Failed to send verification code.';
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    } catch (e) {
      print('❌ [AuthNotifier.sendPhoneCaptcha] error=$e');
      final msg = _localizedNetworkError(e);
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
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

  // ============ 倒计时 ============

  void _startCountdown() {
    state = state.copyWith(reGetCode: false, reGetCode2: false, countdown: 60);
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
  }

  // ============ 找回密码流程(3 步) ============

  Future<bool> checkCaptchaAndResetPassword() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final codeOk = await _repository.checkCaptcha(
        target: state.emailAccount,
        code: state.captcha,
      );
      if (!codeOk) {
        state = state.copyWith(isLoading: false);
        Fluttertoast.showToast(msg: _localizedIncorrectCode('400'));
        return false;
      }
      final accountId = await _repository.checkBindMail(state.emailAccount);
      if (accountId == null) {
        final msg = state.languageNum == 0 || state.languageNum == 2
            ? '邮箱未绑定' : 'Mail not bound.';
        Fluttertoast.showToast(msg: msg);
        state = state.copyWith(isLoading: false);
        return false;
      }
      final ok = await _repository.updatePassword(
        userId: accountId,
        newPassword: state.changepassword,
      );
      state = state.copyWith(isLoading: false);
      if (ok) {
        final msg = state.languageNum == 0 || state.languageNum == 2
            ? '密码修改成功' : 'Password updated.';
        Fluttertoast.showToast(msg: msg);
      }
      return ok;
    } catch (e) {
      print('❌ [AuthNotifier.checkCaptchaAndResetPassword] error=$e');
      final msg = _localizedNetworkError(e);
      Fluttertoast.showToast(msg: msg);
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  // ============ 登出 / 调试 ============

  Future<void> logout() async {
    await _storage.clearAuth();
    state = AuthState(languageNum: state.languageNum);
    print('🔐 [AuthNotifier.logout] session cleared');
  }

  /// 开发免登录:模拟老用户登录(code 200 → 直接进 home-shell)。
  Future<void> devLogin() async {
    await _storage.setAccessToken('dev_token');
    await _storage.setUserId(1);
    await _storage.setHeadImageHash('');
    await _storage.setHasPassword(true);
    await _storage.setFirstOpenApp(false);
    state = state.copyWith(
      isAuthenticated: true,
      isNewUser: false,
      loginResultCode: '200',
      accessToken: 'dev_token',
      userId: 1,
    );
    print('🔐 [AuthNotifier.devLogin] simulated code=200 old user → home-shell');
  }

  /// 调试按钮:模拟新用户注册(code 201 → 进入昵称设置流程)。
  /// 让用户能在 LoginPage 走一轮完整"新用户注册→昵称→目标→首页"流程。
  Future<void> devSimulateRegister() async {
    await _storage.setAccessToken('dev_new_user_token');
    await _storage.setUserId(9999);
    await _storage.setHeadImageHash('');
    await _storage.setHasPassword(false);
    // 新用户 firstOpenApp 先不标 false,等走完注册流程再说
    state = state.copyWith(
      isAuthenticated: true,
      isNewUser: true,
      loginResultCode: '201',
      accessToken: 'dev_new_user_token',
      userId: 9999,
      userInfo: FitUserInfo(
        id: 9999,
        nickName: '',
        hasPsw: false,
        mailAddress: 'dev-new-user@example.com',
      ),
    );
    print('🔐 [AuthNotifier.devSimulateRegister] simulated code=201 new user → nickname-setup');
    Fluttertoast.showToast(
      msg: state.languageNum == 0 || state.languageNum == 2
          ? '模拟注册成功(新用户),即将进入昵称设置'
          : 'Simulated register (new user), nickname setup next.',
    );
  }

  // ============ 微信登录三件套(占位/后续接入打开) ============

  /// 初始化微信 SDK(Fluwx registerApi)。
  Future<void> initWechatSdk() async {
    print('🔐 [WeChat] initWechatSdk PLACEHOLDER - NOT IMPL (wx46759e30d588e056)');
    // TODO(wechat): 接入 Fluwx 后打开:
    // await fluwx.registerApi(
    //   appId: "wx46759e30d588e056",
    //   universalLink: "https://www.ucfitness.club/fitmonsterapp/",
    // );
    // cancelable = fluwx.addSubscriber((response) {
    //   if (response is WeChatAuthResponse && response.errCode == 0) {
    //     handleWechatCode(response.code!);
    //   }
    // });
  }

  /// 点击微信登录按钮触发授权(占位)。
  Future<void> startWechatAuth() async {
    print('🔐 [WeChat] startWechatAuth PLACEHOLDER - NOT IMPL');
    Fluttertoast.showToast(
      msg: state.languageNum == 0 || state.languageNum == 2
          ? '微信登录暂未上线'
          : 'WeChat login coming soon.',
    );
    // TODO(wechat): 接入后打开:
    // await fluwx.authBy(which: NormalAuth(scope:'snsapi_userinfo', state:'wechat_sdk_demo_test'));
  }

  /// 授权回调拿到 code 后调服务端 wechatLogin 接口(占位)。
  Future<void> handleWechatCode(String code) async {
    print('🔐 [WeChat] handleWechatCode PLACEHOLDER code=${code.substring(0, code.length > 6 ? 6 : code.length)}...');
    // TODO(wechat): final resp = await _repository.wechatLogin(code: code);
    // await _handleVerification(resp);
  }

  // ============ 注册流程:提交用户完整数据 ============

  /// 完成注册流程:收集所有步骤的数据 → PUT /api/user/info → 进首页。
  /// 对应旧项目 NewUserDataSettingController.updateInofo()。
  /// 无论 API 成功与否,都会强制设置 isNewUser=false 和 isAuthenticated=true,
  /// 确保用户完成注册流程后直接进入已登录状态。
  Future<void> completeRegistration() async {
    final userId = _storage.userId;
    final nickName = _storage.username ?? 'User';
    final sex = _storage.userSex;
    final height = _storage.userHeight;
    final weight = _storage.userWeight < 20 ? 20 : _storage.userWeight;
    final birthday = _storage.userBirthday;
    final goalWeight = _storage.goalWeight;

    final data = {
      'id': userId,
      'nickName': nickName,
      'sex': sex,
      'height': height,
      'weight': weight,
      'birthday': birthday,
    };

    print('🏁 [Register.complete] userId=$userId nickName=$nickName '
        'sex=$sex height=$height weight=$weight birthday=$birthday goalWeight=$goalWeight');

    // 先强制更新状态:标记为已登录 + 非新用户(无论 API 成功与否)
    state = state.copyWith(isNewUser: false, isAuthenticated: true);
    await _storage.setFirstOpenApp(false);
    await _storage.setGoalWeight(goalWeight);
    print('🏁 [Register.complete] state updated → isNewUser=false, isAuthenticated=true');

    // API 调用为 best-effort,失败不阻塞进入首页
    try {
      final ok = await _repository.updateUserInfo(data);
      print('🏁 [Register.complete] API result: ok=$ok');
    } catch (e) {
      print('⚠️ [Register.complete] API error (ignored): $e');
    }
  }
}
