// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(privacyService)
final privacyServiceProvider = PrivacyServiceProvider._();

final class PrivacyServiceProvider
    extends $FunctionalProvider<PrivacyService, PrivacyService, PrivacyService>
    with $Provider<PrivacyService> {
  PrivacyServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyServiceHash();

  @$internal
  @override
  $ProviderElement<PrivacyService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrivacyService create(Ref ref) {
    return privacyService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivacyService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivacyService>(value),
    );
  }
}

String _$privacyServiceHash() => r'6d6be944f65390a5a3762c712beeb888a21df36a';
