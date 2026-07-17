// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'e400ccf16e06b9ed55213ae00239a61489fecbac';

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
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
