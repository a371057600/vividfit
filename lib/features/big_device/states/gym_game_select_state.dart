import 'package:freezed_annotation/freezed_annotation.dart';

part 'gym_game_select_state.freezed.dart';

/// GymGameSelect 页面状态（1:1 对应旧 ControllerBigCourseSelect 的 rx 变量）。
@freezed
abstract class GymGameSelectState with _$GymGameSelectState {
  const factory GymGameSelectState({
    // ==================== 音乐相关 ====================
    /// 当前选中音乐索引 0~7（对应旧 cbcs.selectIndex）。
    @Default(0) int selectedMusicIndex,

    /// 音乐是否正在播放（对应旧 cbcs.isMusicPlaying）。
    @Default(false) bool isMusicPlaying,

    /// 音量是否开启（对应旧 cbcs.isVolumeOpen）。
    @Default(true) bool isVolumeOpen,

    /// 音乐暂停标志（对应旧 cbcs.ismusicPause，区分暂停恢复 vs 切换新歌）。
    @Default(false) bool isMusicPaused,

    /// 专辑封面轮播索引 0~70（对应旧 cbcs.imageIndex）。
    @Default(0) int albumImageIndex,

    // ==================== 游戏相关 ====================
    /// 游戏卡片图片资源列表（对应旧 cbcs.gamePictureList）。
    @Default(<String>[]) List<String> gamePictureList,

    /// 游戏跳转路由名列表（对应旧 cbcs.gameList）。
    @Default(<String>[]) List<String> gameRouteList,

    /// 各游戏页 WebView 是否已实装（true=允许跳转 / false=Toast 阻断）。
    /// key：gameRouteList 中的路由名。
    /// ⚠️ 约束：任何没有 WebView URL 实装的 Placeholder 页，必须为 false。
    @Default(<String, bool>{}) Map<String, bool> gameWebViewReadyMap,
  }) = _GymGameSelectState;
}
