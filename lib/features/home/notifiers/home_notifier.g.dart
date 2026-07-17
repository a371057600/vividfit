// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeNotifierHash() => r'f6d3c4d91c8e7a5ba760cd04e0b00c3f9e756ff9';

/// 主页状态机(1:1 迁移自旧 HomeController + NewMainController 的状态逻辑)。
///
/// Copied from [HomeNotifier].
@ProviderFor(HomeNotifier)
final homeNotifierProvider =
    AutoDisposeNotifierProvider<HomeNotifier, HomeState>.internal(
      HomeNotifier.new,
      name: r'homeNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$homeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HomeNotifier = AutoDisposeNotifier<HomeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
