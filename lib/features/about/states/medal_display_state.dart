import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/network/medal.dart';

part 'medal_display_state.freezed.dart';

/// 勋章页面状态（迁移自旧项目 NewMedalController 的 Rx 变量集合）。
@freezed
abstract class MedalDisplayState with _$MedalDisplayState {
  const factory MedalDisplayState({
    /// 是否正在加载勋章面板
    @Default(true) bool isLoading,

    /// 服务器返回的勋章分组（对应旧 newMedalJson.data）
    @Default([]) List<MedalGroup> groups,

    /// 已获得的勋章（createTime 非空），按获得时间降序（对应旧 filteredAndSortedList）
    @Default([]) List<MedalMsg> earnedMedals,

    /// 顶部轮播当前索引（对应旧 topCarouselSliderIndex）
    @Default(0) int topCarouselIndex,
  }) = _MedalDisplayState;
}
