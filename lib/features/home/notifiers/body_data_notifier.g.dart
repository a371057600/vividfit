// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_data_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bodyDataNotifierHash() => r'0766f188a0b13ea753953166386b1dce0ff85a2e';

/// 身体数据状态机(1:1 迁移自旧 BodyDataController 的本地状态部分)。
///
/// 网络上传 PUT 接口在后续 user 模块补齐,本阶段只做本地存储 + UI 状态。
///
/// Copied from [BodyDataNotifier].
@ProviderFor(BodyDataNotifier)
final bodyDataNotifierProvider =
    AutoDisposeNotifierProvider<BodyDataNotifier, BodyDataState>.internal(
      BodyDataNotifier.new,
      name: r'bodyDataNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$bodyDataNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BodyDataNotifier = AutoDisposeNotifier<BodyDataState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
