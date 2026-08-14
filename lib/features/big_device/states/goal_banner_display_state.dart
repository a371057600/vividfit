/// 目标达成弹窗的显示状态。
///
/// 完整生命周期: hidden → entering → visible → exiting → hidden
enum GoalBannerDisplayState {
  /// 隐藏（不渲染）
  hidden,

  /// 入场动画中（300ms）
  entering,

  /// 完全显示（5秒自动关闭计时从此状态开始）
  visible,

  /// 退场动画中（250ms）
  exiting,
}
