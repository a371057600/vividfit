import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/api/api_providers.dart';
import '../../../data/models/network/medal.dart';
import '../states/medal_display_state.dart';
import '../utils/medal_image_cache.dart';

part 'medal_display_notifier.g.dart';

/// 勋章面板状态管理（迁移自旧项目 NewMedalController，移除 GetX）。
///
/// 进入页面自动加载勋章面板数据；重新进入页面时 provider 重建会重新请求，
/// 与旧版 Get.put(NewMedalController()) 的生命周期行为一致。
@riverpod
class MedalDisplayNotifier extends _$MedalDisplayNotifier {
  late StorageService _storage;

  @override
  MedalDisplayState build() {
    _storage = ref.watch(storageServiceProvider);
    // 对应旧版 onInit -> getMedals()
    Future.microtask(loadMedalPanel);
    return const MedalDisplayState();
  }

  /// 拉取勋章面板数据（对应旧版 getMedals）。
  /// 服务端新规则：lang 只允许 zh（zh 直返中文 describe/groupName），
  /// isNew 参数已废除（新勋章分离为 /medal/new 独立接口）。
  Future<void> loadMedalPanel() async {
    final userId = _storage.userId;
    print('🏅 [Medal] loadMedalPanel start, userId=$userId, lang=zh');
    if (userId == null) {
      print('⚠️ [Medal] no userId, skip request');
      state = state.copyWith(isLoading: false);
      return;
    }
    try {
      final groups = await ref
          .read(sportStatisticsApiProvider)
          .getMedalPanel(userId: userId, lang: 'zh');
      // 已获得勋章过滤 + 按获得时间降序（等价迁移旧版 filteredAndSortedList 逻辑）
      final earned =
          groups
              .expand((g) => g.medals ?? <MedalMsg>[])
              .where((m) => m.createTime != null)
              .toList()
            ..sort((a, b) => b.createTime!.compareTo(a.createTime!));
      print(
        '🏅 [Medal] load success: groups=${groups.length}, '
        'earned=${earned.length}',
      );
      // 打印服务器原始文本样本，验证 zh 直返是否为中文
      if (groups.isNotEmpty) {
        final sample = groups.first.medals?.firstOrNull;
        print(
          '🏅 [Medal] raw sample: groupName=${groups.first.groupName}, '
          'describe=${sample?.describe}',
        );
      }
      state = state.copyWith(
        isLoading: false,
        groups: groups,
        earnedMedals: earned,
        topCarouselIndex: 0,
      );
      // 新规则：勋章图片一律本地存储展示，数据到位后批量预下载（不阻塞 UI）
      unawaited(
        MedalImageCache.instance.prefetchAll(
          groups.expand((g) => (g.medals ?? []).map((m) => m.image)),
        ),
      );
    } catch (e) {
      print('❌ [Medal] loadMedalPanel error: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// 顶部轮播翻页回调（对应旧版 topCarouselSliderIndex.value = index）。
  void updateTopCarouselIndex(int index) {
    state = state.copyWith(topCarouselIndex: index);
  }

  /// ISO 时间字符串格式化为 yyyy-MM-dd（等价迁移旧版 formatDateTime）。
  String formatDateTime(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      final y = dateTime.year.toString().padLeft(4, '0');
      final m = dateTime.month.toString().padLeft(2, '0');
      final d = dateTime.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    } catch (e) {
      print('⚠️ [Medal] formatDateTime parse error: $isoDateTime ($e)');
      return isoDateTime;
    }
  }
}
