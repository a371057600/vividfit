import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../states/account_security_state.dart';

part 'account_security_notifier.g.dart';

/// 账号安全 Notifier（对应旧 AccountSecurityPage 的 GetX Controller 逻辑）。
///
/// 职责：承载账号绑定信息 + 身份校验验证码（发送/校验）+ 修改密码。
@Riverpod(keepAlive: false)
class AccountSecurityNotifier extends _$AccountSecurityNotifier {
  late final ApiClient _api;
  late final StorageService _storage;
  Timer? _timer;

  /// 与 AuthRepository 保持一致的 50s 超时配置。
  Options get _options => Options(
    sendTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  );

  @override
  AccountSecurityState build() {
    _api = ref.watch(apiClientProvider);
    _storage = ref.watch(storageServiceProvider);
    ref.onDispose(() => _timer?.cancel());
    return const AccountSecurityState();
  }

  // ============ 字段 setter（页面输入框绑定） ============

  void setPhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void setEmailAddress(String value) {
    state = state.copyWith(emailAddress: value);
  }

  void setUnionId(String value) {
    state = state.copyWith(unionId: value);
  }

  void setHasPhoneNumber(bool value) {
    state = state.copyWith(hasPhoneNumber: value);
  }

  void setHasEmailAddress(bool value) {
    state = state.copyWith(hasEmailAddress: value);
  }

  void setVerCode(String value) {
    state = state.copyWith(verCode: value);
  }

  void setAccountAddType(int value) {
    state = state.copyWith(accountAddType: value);
  }

  void setBindAccount(String value) {
    state = state.copyWith(bindAccount: value);
  }

  void setAreaCode(String value) {
    state = state.copyWith(areaCode: value);
  }

  void setCounting(bool isCounting, int counter) {
    state = state.copyWith(isCounting: isCounting, counter: counter);
  }

  void resetCounting() {
    state = state.copyWith(isCounting: false, counter: 0);
  }

  void setInternetStatus(bool hasInternet) {
    state = state.copyWith(ishasInternet: hasInternet);
  }

  void setCheckVerCode(String value) {
    state = state.copyWith(checkVerCode: value);
  }

  void setChangepassword(String value) {
    state = state.copyWith(changepassword: value);
  }

  void setChangepassword2(String value) {
    state = state.copyWith(changepassword2: value);
  }

  // ============ 业务方法（对应老 Controller 网络逻辑） ============

  /// 加载用户信息（对应老 getData() 精简版）。
  ///
  /// 解析 userInfo 中的手机号/区号/邮箱与 thirdPartInfos 中的 unionId，
  /// 同步刷新 hasPhoneNumber / hasEmailAddress 标记与 isLoading 状态。
  Future<void> loadUserInfo() async {
    final userId = _storage.userId;
    print('[AccountSecurity] loadUserInfo userId=$userId');
    state = state.copyWith(isLoading: true);
    try {
      final response = await _api.getRaw<Map<String, dynamic>>(
        ApiConstants.userInfo,
        queryParameters: {'userId': userId},
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      final ok = response['code']?.toString() == '200';
      print('[AccountSecurity] loadUserInfo code=${response['code']} ok=$ok');
      if (!ok) return;
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final userInfo = data['userInfo'] as Map<String, dynamic>? ?? {};
      final thirdPartInfos = data['thirdPartInfos'] as List<dynamic>? ?? [];

      final phoneNumber = userInfo['phoneNumber']?.toString() ?? '';
      final areaCode = userInfo['phoneArea']?.toString() ?? '86';
      final emailAddress = userInfo['mailAddress']?.toString() ?? '';
      final unionId = thirdPartInfos.isNotEmpty
          ? thirdPartInfos[0]['unionId']?.toString() ?? ''
          : '';

      state = state.copyWith(
        phoneNumber: phoneNumber,
        areaCode: areaCode,
        emailAddress: emailAddress,
        hasPhoneNumber: phoneNumber.isNotEmpty,
        hasEmailAddress: emailAddress.isNotEmpty,
        unionId: unionId,
      );
      print(
        '[AccountSecurity] loadUserInfo phone=$phoneNumber area=$areaCode '
        'mail=$emailAddress unionId=$unionId',
      );
    } catch (e) {
      print('❌ [AccountSecurity.loadUserInfo] error=$e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 发送身份校验验证码（对应老 sendCheckVerCode(index)）。
  ///
  /// [type] 0=手机验证码 1=邮箱验证码；先启动 60s 倒计时再发请求（与老逻辑一致）。
  /// code=405 表示账号已被绑定，仅打印日志，toast 由 UI 层处理。
  Future<bool> sendCheckVerCode(int type) async {
    final isCn = _storage.languageNum == 0; // 0=简中，等价老代码 !isEnglish
    final target = type == 0 ? state.phoneNumber : state.emailAddress;
    print(
      '[AccountSecurity] sendCheckVerCode type=$type target=$target isCn=$isCn',
    );
    // 老逻辑：发码前先启动倒计时
    _startCountdown();
    try {
      final Map<String, dynamic> params;
      if (type == 0) {
        params = {
          'phoneNumber': state.phoneNumber,
          'areaCode': state.areaCode,
          'businessType': 'checkphone',
          'isCn': isCn,
        };
      } else {
        params = {
          'mailAddress': state.emailAddress,
          'businessType': 'checkmail',
          'isCn': isCn,
        };
      }
      final response = await _api.getRaw<Map<String, dynamic>>(
        type == 0
            ? ApiConstants.sendPhoneNumberUrl
            : ApiConstants.sendMailNumberUrl,
        queryParameters: params,
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      final code = response['code']?.toString();
      if (code == '405') {
        print('[AccountSecurity] sendCheckVerCode code=405 该账号已被绑定');
      }
      final ok = code == '200';
      print(
        '[AccountSecurity] sendCheckVerCode code=${response['code']} ok=$ok',
      );
      return ok;
    } catch (e) {
      print('❌ [AccountSecurity.sendCheckVerCode] error=$e');
      _stopCountdown(); // 请求异常时停止倒计时
      return false;
    }
  }

  /// 校验验证码（对应老 perAuth(index)）。
  ///
  /// [type] 0=手机 1=邮箱；code=200 返回 true 并重置倒计时。
  Future<bool> verifyCheckVerCode(int type) async {
    final isCn = _storage.languageNum == 0;
    final target = type == 0 ? state.phoneNumber : state.emailAddress;
    final businessType = type == 0 ? 'checkphone' : 'checkmail';
    print(
      '[AccountSecurity] verifyCheckVerCode type=$type target=$target '
      'code=${state.checkVerCode} businessType=$businessType',
    );
    try {
      final response = await _api.getRaw<Map<String, dynamic>>(
        ApiConstants.checkNumberUrl,
        queryParameters: {
          'isCn': isCn,
          'target': target,
          'code': state.checkVerCode,
          'businessType': businessType,
        },
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      final ok = response['code']?.toString() == '200';
      print(
        '[AccountSecurity] verifyCheckVerCode code=${response['code']} ok=$ok',
      );
      if (ok) _stopCountdown(); // 老逻辑：校验通过后重置倒计时
      return ok;
    } catch (e) {
      print('❌ [AccountSecurity.verifyCheckVerCode] error=$e');
      return false;
    }
  }

  /// 绑定场景发送验证码（对应老 sendverCode()）。
  ///
  /// [type] 0=绑定手机 1=绑定邮箱；businessType 分别为 bindphone / bindmail。
  /// 返回响应 code 字符串（'200' 成功 / '405' 已被绑定 / 异常返回 ''），
  /// UI 层根据 code 做 toast 提示（对应老代码 405 → "The account has been bound"）。
  Future<String> sendBindVerCode(int type) async {
    final isCn = _storage.languageNum == 0; // 0=简中，等价老代码 !isEnglish
    final target = state.bindAccount;
    print(
      '[AccountSecurity] sendBindVerCode type=$type target=$target isCn=$isCn',
    );
    // 老逻辑：发码前先启动倒计时
    _startCountdown();
    try {
      final Map<String, dynamic> params;
      if (type == 0) {
        // 老代码：手机绑定 isCn 取决于区号是否为 86
        params = {
          'phoneNumber': state.bindAccount,
          'areaCode': state.areaCode,
          'businessType': 'bindphone',
          'isCn': state.areaCode == '86',
        };
      } else {
        params = {
          'mailAddress': state.bindAccount,
          'businessType': 'bindmail',
          'isCn': isCn,
        };
      }
      final response = await _api.getRaw<Map<String, dynamic>>(
        type == 0
            ? ApiConstants.sendPhoneVerCode
            : ApiConstants.sendMailVerCode,
        queryParameters: params,
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      final code = response['code']?.toString() ?? '';
      if (code == '405') {
        print('[AccountSecurity] sendBindVerCode code=405 该账号已被绑定');
      }
      print('[AccountSecurity] sendBindVerCode code=$code');
      return code;
    } catch (e) {
      print('❌ [AccountSecurity.sendBindVerCode] error=$e');
      _stopCountdown(); // 请求异常时停止倒计时
      return '';
    }
  }

  /// 绑定账号（对应老 bindingAccount() 的 case 0 / case 3）。
  ///
  /// [type] 0=绑定手机 1=绑定邮箱；PUT updatePhone / updateMail。
  /// code=200 时同步内存状态与本地存储（对应老 box.write + 更新 rx 变量）。
  /// 返回响应 code 字符串：'200' 成功 / '405' 已被绑定 / '400' 验证码错误 / 异常 ''。
  Future<String> bindAccount(int type) async {
    final userId = _storage.userId;
    print(
      '[AccountSecurity] bindAccount type=$type userId=$userId bindAccount=${state.bindAccount}',
    );
    try {
      final Map<String, dynamic> params;
      if (type == 0) {
        params = {
          'phoneNumber': state.bindAccount,
          'code': state.verCode,
          'areaCode': state.areaCode,
          'userId': userId,
          'businessType': 'bindphone',
        };
      } else {
        params = {
          'newMail': state.bindAccount,
          'code': state.verCode,
          'userId': userId,
          'businessType': 'bindmail',
        };
      }
      final response = await _api.putRaw<Map<String, dynamic>>(
        type == 0 ? ApiConstants.updatePhone : ApiConstants.updateMail,
        queryParameters: params,
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      final code = response['code']?.toString() ?? '';
      print('[AccountSecurity] bindAccount type=$type code=$code');
      if (code == '200') {
        // 老逻辑：绑定成功后同步内存状态 + 本地存储
        state = state.copyWith(
          phoneNumber: type == 0 ? state.bindAccount : state.phoneNumber,
          emailAddress: type == 1 ? state.bindAccount : state.emailAddress,
          hasPhoneNumber: type == 0 ? true : state.hasPhoneNumber,
          hasEmailAddress: type == 1 ? true : state.hasEmailAddress,
        );
        if (type == 0) {
          await _storage.setPhoneNumber(state.bindAccount);
        } else {
          await _storage.setEmailAddress(state.bindAccount);
        }
      }
      return code;
    } catch (e) {
      print('❌ [AccountSecurity.bindAccount] error=$e');
      return '';
    }
  }

  /// 注销账号（对应老 HomeController.loginOut() 的真实注销接口）。
  ///
  /// GET /api/user/loginOut（access_token 由 AuthInterceptor 统一附加），
  /// code=200 时复用 AuthNotifier.logout() 清空本地登录态并重置全局认证状态，
  /// UI 层收到 true 后跳转登录页。
  Future<bool> deleteAccount() async {
    final userId = _storage.userId;
    print('[AccountSecurity] deleteAccount userId=$userId');
    state = state.copyWith(isDeleting: true);
    try {
      final response = await _api.getRaw<Map<String, dynamic>>(
        ApiConstants.deleteAccount,
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      final ok = response['code']?.toString() == '200';
      print('[AccountSecurity] deleteAccount code=${response['code']} ok=$ok');
      if (ok) {
        // 清空 accessToken/userId 等本地数据并重置认证状态
        // （与 about_shell 退出登录一致，否则路由 redirect 会弹回 home-shell）
        await ref.read(authProvider.notifier).logout();
      }
      return ok;
    } catch (e) {
      print('❌ [AccountSecurity.deleteAccount] error=$e');
      return false;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isDeleting: false);
      }
    }
  }

  /// 修改密码（对应老 bindingAccount() case 1）。
  ///
  /// code=200 时写入本地 hasPassword 标记并返回 true。
  Future<bool> updatePassword() async {
    final userId = _storage.userId;
    print(
      '[AccountSecurity] updatePassword userId=$userId '
      'newPwdLen=${state.changepassword.length}',
    );
    try {
      final response = await _api.putRaw<Map<String, dynamic>>(
        ApiConstants.updatePwdUrl,
        queryParameters: {
          'userId': userId,
          'newPassword': state.changepassword,
        },
        options: _options,
        parser: (json) => json as Map<String, dynamic>,
      );
      print('🔑 [AccountSecurity.updatePassword] RAW RESPONSE = $response');
      final ok = response['code']?.toString() == '200';
      if (ok) {
        await _storage.setHasPassword(true);
      }
      print('[AccountSecurity] updatePassword userId=$userId ok=$ok');
      return ok;
    } catch (e) {
      print('❌ [AccountSecurity.updatePassword] error=$e');
      return false;
    }
  }

  // ============ 倒计时（对应老 Timer.periodic 逻辑） ============

  /// 启动 60s 倒计时：每秒 counter-1，归零后 isCounting=false 并取消定时器。
  void _startCountdown() {
    _timer?.cancel();
    state = state.copyWith(isCounting: true, counter: 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!ref.mounted) {
        timer.cancel();
        return;
      }
      final next = state.counter - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(isCounting: false, counter: 0);
      } else {
        state = state.copyWith(counter: next);
      }
    });
  }

  /// 停止并重置倒计时。
  void _stopCountdown() {
    _timer?.cancel();
    _timer = null;
    resetCounting();
  }
}
