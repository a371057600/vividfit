// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_start_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 快速开始 Notifier（Riverpod 3.0 代码生成，业务逻辑留白）。
///
/// 所有运动控制方法暂留 TODO，待蓝牙模块完整迁移后实现。

@ProviderFor(QuickStartNotifier)
final quickStartProvider = QuickStartNotifierProvider._();

/// 快速开始 Notifier（Riverpod 3.0 代码生成，业务逻辑留白）。
///
/// 所有运动控制方法暂留 TODO，待蓝牙模块完整迁移后实现。
final class QuickStartNotifierProvider
    extends $NotifierProvider<QuickStartNotifier, QuickStartState> {
  /// 快速开始 Notifier（Riverpod 3.0 代码生成，业务逻辑留白）。
  ///
  /// 所有运动控制方法暂留 TODO，待蓝牙模块完整迁移后实现。
  QuickStartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickStartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickStartNotifierHash();

  @$internal
  @override
  QuickStartNotifier create() => QuickStartNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickStartState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickStartState>(value),
    );
  }
}

String _$quickStartNotifierHash() =>
    r'29fb510b2fdf82b75a788b0c82a52e4606184513';

/// 快速开始 Notifier（Riverpod 3.0 代码生成，业务逻辑留白）。
///
/// 所有运动控制方法暂留 TODO，待蓝牙模块完整迁移后实现。

abstract class _$QuickStartNotifier extends $Notifier<QuickStartState> {
  QuickStartState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<QuickStartState, QuickStartState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuickStartState, QuickStartState>,
              QuickStartState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
