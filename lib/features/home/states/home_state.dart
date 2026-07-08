import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/new_main_data.dart';

part 'home_state.freezed.dart';

/// 主页状态(整合旧 HomeController + NewMainController 的核心字段)。
@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    /// 底部导航当前 tab
    @Default(0) int currentIndex,

    /// 主页三环 + BMI 数据
    @Default(FitMainData()) FitMainData mainData,

    /// 用户昵称(主页标题用)
    @Default('UserName') String nickName,

    /// 头像 hash
    @Default('') String headImageHash,

    /// 选中动画角色索引(0=xinxin 1=rubby 2=cat 3=boxing 4=dog 5=jack 6=carol)
    @Default(0) int selectedCharacterIndex,

    /// 主页"我的排名"
    @Default('99') String myRank,

    /// 今日是否打卡
    @Default(false) bool isReached,

    /// 是否有 AI 报告
    @Default(false) bool hasAiReport,

    /// 是否正在加载(首次进入)
    @Default(true) bool isLoading,
  }) = _HomeState;
}
