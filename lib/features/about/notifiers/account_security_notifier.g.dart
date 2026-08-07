// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_security_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccountSecurityNotifier)
final accountSecurityProvider = AccountSecurityNotifierProvider._();

final class AccountSecurityNotifierProvider
    extends $NotifierProvider<AccountSecurityNotifier, AccountSecurityState> {
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
    r'af904abed859fe98915c36da3e09ce43e2ee1399';

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
