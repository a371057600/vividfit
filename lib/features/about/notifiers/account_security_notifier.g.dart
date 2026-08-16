// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_security_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 账号安全 Notifier（对应旧 AccountSecurityPage 的 GetX Controller 逻辑）。
///
/// 职责：承载账号绑定信息 + 身份校验验证码（发送/校验）+ 修改密码。

@ProviderFor(AccountSecurityNotifier)
final accountSecurityProvider = AccountSecurityNotifierProvider._();

/// 账号安全 Notifier（对应旧 AccountSecurityPage 的 GetX Controller 逻辑）。
///
/// 职责：承载账号绑定信息 + 身份校验验证码（发送/校验）+ 修改密码。
final class AccountSecurityNotifierProvider
    extends $NotifierProvider<AccountSecurityNotifier, AccountSecurityState> {
  /// 账号安全 Notifier（对应旧 AccountSecurityPage 的 GetX Controller 逻辑）。
  ///
  /// 职责：承载账号绑定信息 + 身份校验验证码（发送/校验）+ 修改密码。
  AccountSecurityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountSecurityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountSecurityNotifierHash();

  @$internal
  @override
  AccountSecurityNotifier create() => AccountSecurityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountSecurityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountSecurityState>(value),
    );
  }
}

String _$accountSecurityNotifierHash() =>
    r'1667a89657c120bb61178da7a513aec8fdb506d5';

/// 账号安全 Notifier（对应旧 AccountSecurityPage 的 GetX Controller 逻辑）。
///
/// 职责：承载账号绑定信息 + 身份校验验证码（发送/校验）+ 修改密码。

abstract class _$AccountSecurityNotifier
    extends $Notifier<AccountSecurityState> {
  AccountSecurityState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AccountSecurityState, AccountSecurityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccountSecurityState, AccountSecurityState>,
              AccountSecurityState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
