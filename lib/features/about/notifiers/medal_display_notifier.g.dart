// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medal_display_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 勋章面板状态管理（迁移自旧项目 NewMedalController，移除 GetX）。
///
/// 进入页面自动加载勋章面板数据；重新进入页面时 provider 重建会重新请求，
/// 与旧版 Get.put(NewMedalController()) 的生命周期行为一致。

@ProviderFor(MedalDisplayNotifier)
final medalDisplayProvider = MedalDisplayNotifierProvider._();

/// 勋章面板状态管理（迁移自旧项目 NewMedalController，移除 GetX）。
///
/// 进入页面自动加载勋章面板数据；重新进入页面时 provider 重建会重新请求，
/// 与旧版 Get.put(NewMedalController()) 的生命周期行为一致。
final class MedalDisplayNotifierProvider
    extends $NotifierProvider<MedalDisplayNotifier, MedalDisplayState> {
  /// 勋章面板状态管理（迁移自旧项目 NewMedalController，移除 GetX）。
  ///
  /// 进入页面自动加载勋章面板数据；重新进入页面时 provider 重建会重新请求，
  /// 与旧版 Get.put(NewMedalController()) 的生命周期行为一致。
  MedalDisplayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medalDisplayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medalDisplayNotifierHash();

  @$internal
  @override
  MedalDisplayNotifier create() => MedalDisplayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedalDisplayState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedalDisplayState>(value),
    );
  }
}

String _$medalDisplayNotifierHash() =>
    r'87ecdeb2eba17eea9329d0460485d38f01c8fabc';

/// 勋章面板状态管理（迁移自旧项目 NewMedalController，移除 GetX）。
///
/// 进入页面自动加载勋章面板数据；重新进入页面时 provider 重建会重新请求，
/// 与旧版 Get.put(NewMedalController()) 的生命周期行为一致。

abstract class _$MedalDisplayNotifier extends $Notifier<MedalDisplayState> {
  MedalDisplayState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MedalDisplayState, MedalDisplayState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MedalDisplayState, MedalDisplayState>,
              MedalDisplayState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
