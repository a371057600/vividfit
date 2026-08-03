// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(publicApi)
final publicApiProvider = PublicApiProvider._();

final class PublicApiProvider
    extends $FunctionalProvider<PublicApi, PublicApi, PublicApi>
    with $Provider<PublicApi> {
  PublicApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicApiHash();

  @$internal
  @override
  $ProviderElement<PublicApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PublicApi create(Ref ref) {
    return publicApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PublicApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PublicApi>(value),
    );
  }
}

String _$publicApiHash() => r'd3e5a5a4e14865a03865c46a60404b615dd91637';

@ProviderFor(userApi)
final userApiProvider = UserApiProvider._();

final class UserApiProvider
    extends $FunctionalProvider<UserApi, UserApi, UserApi>
    with $Provider<UserApi> {
  UserApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userApiHash();

  @$internal
  @override
  $ProviderElement<UserApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserApi create(Ref ref) {
    return userApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserApi>(value),
    );
  }
}

String _$userApiHash() => r'6b40d39f827fb6674db81cd8020b72861b4a60c8';

@ProviderFor(sportHistoryApi)
final sportHistoryApiProvider = SportHistoryApiProvider._();

final class SportHistoryApiProvider
    extends
        $FunctionalProvider<SportHistoryApi, SportHistoryApi, SportHistoryApi>
    with $Provider<SportHistoryApi> {
  SportHistoryApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sportHistoryApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sportHistoryApiHash();

  @$internal
  @override
  $ProviderElement<SportHistoryApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SportHistoryApi create(Ref ref) {
    return sportHistoryApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SportHistoryApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SportHistoryApi>(value),
    );
  }
}

String _$sportHistoryApiHash() => r'10e06f3b10a1a8e5580b73818d6f25ee64eee89a';

@ProviderFor(sportStatisticsApi)
final sportStatisticsApiProvider = SportStatisticsApiProvider._();

final class SportStatisticsApiProvider
    extends
        $FunctionalProvider<
          SportStatisticsApi,
          SportStatisticsApi,
          SportStatisticsApi
        >
    with $Provider<SportStatisticsApi> {
  SportStatisticsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sportStatisticsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sportStatisticsApiHash();

  @$internal
  @override
  $ProviderElement<SportStatisticsApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SportStatisticsApi create(Ref ref) {
    return sportStatisticsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SportStatisticsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SportStatisticsApi>(value),
    );
  }
}

String _$sportStatisticsApiHash() =>
    r'751575126f82e24906bdfb1182d3b061b2b6c3c9';

@ProviderFor(webApi)
final webApiProvider = WebApiProvider._();

final class WebApiProvider extends $FunctionalProvider<WebApi, WebApi, WebApi>
    with $Provider<WebApi> {
  WebApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webApiHash();

  @$internal
  @override
  $ProviderElement<WebApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebApi create(Ref ref) {
    return webApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebApi>(value),
    );
  }
}

String _$webApiHash() => r'2e4c29916bc6fc2d0482e02b1393f3cd01ef0252';
