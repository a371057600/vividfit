import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../data/exercise_song_library.dart';
import '../states/gym_game_select_state.dart';

part 'gym_game_select_notifier.g.dart';

/// 游戏选择页 Notifier（1:1 迁移旧 ControllerBigCourseSelect）。
///
/// 负责：音乐播放控制、专辑封面轮播、游戏列表/路由/图片按设备类型初始化。
/// 运动数据控制复用 QuickStartNotifier，不在此处理。
@Riverpod(keepAlive: true)
class GymGameSelectNotifier extends _$GymGameSelectNotifier {
  // ==================== 内部资源 ====================
  AudioPlayer? _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  Timer? _albumCarouselTimer;
  bool _isCarouselRunning = false;

  /// 当前设备对应的歌曲列表。
  List<String> _musicList = const [];

  @override
  GymGameSelectState build() {
    ref.onDispose(disposeResources);
    return const GymGameSelectState();
  }

  // ==================== 初始化 ====================

  /// 根据设备类型初始化所有静态数据（1:1 对应旧 initData + setGameList + setMusicList）。
  void bootstrap(FtmsDeviceType deviceType) {
    _musicList = ExerciseSongLibrary.forType(deviceType);

    final data = _resolveGameConfig(deviceType);
    final Map<String, bool> readyMap = {
      for (final r in data.routes) r: true,
    };
    state = state.copyWith(
      gamePictureList: data.pictures,
      gameRouteList: data.routes,
      gameWebViewReadyMap: readyMap,
    );
    print('🎮 [GameSelect] bootstrap 完成: device=$deviceType, '
        'gameRoutes=${data.routes}, webViewReady=$readyMap, musicCount=${_musicList.length}');
  }

  _GameConfig _resolveGameConfig(FtmsDeviceType type) {
    const p = "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage";
    switch (type) {
      case FtmsDeviceType.indoorBike:
        return _GameConfig(
          pictures: ["$p/bike_game1.jpg", "$p/bike_game2.jpg"],
          routes: ['/gym-bike-game', '/gym-bike-game2'],
        );
      case FtmsDeviceType.treadmill:
        return _GameConfig(
          pictures: ["$p/treadmill_game1.jpg", "$p/treadmill_game2.jpg"],
          routes: ['/gym-treadmill-game', '/gym-treadmill-game2'],
        );
      case FtmsDeviceType.crossTrainer:
        return _GameConfig(
          pictures: ["$p/crossTrainer_game1.jpg", "$p/crossTrainer_game2.jpg"],
          routes: ['/gym-elliptical-game', '/gym-elliptical-game2'],
        );
      case FtmsDeviceType.rower:
        return _GameConfig(
          pictures: ["$p/rowing_game1.jpg", "$p/rowing_game2.jpg"],
          routes: ['/gym-rower-game', '/gym-rower-game2'],
        );
      case FtmsDeviceType.strengthStation:
        return _GameConfig(
          pictures: ["$p/bike_game1.jpg", "$p/bike_game2.jpg"],
          // 对齐旧版：力量站复用跑步机游戏1两次
          routes: ['/gym-treadmill-game', '/gym-treadmill-game'],
        );
    }
  }

  // ==================== AudioPlayer 懒加载 ====================

  AudioPlayer _ensureAudioPlayer() {
    if (_audioPlayer != null) return _audioPlayer!;
    final player = AudioPlayer();
    _playerStateSubscription = player.playerStateStream.listen((ps) {
      if (ps.playing) {
        print('🎵 [GameSelect-Music] 播放器回调: 播放中');
        state = state.copyWith(isMusicPlaying: true);
        _startAlbumCarousel();
      } else {
        print('🎵 [GameSelect-Music] 播放器回调: 已暂停/停止');
        state = state.copyWith(isMusicPlaying: false);
        _stopAlbumCarousel();
      }
    });
    _audioPlayer = player;
    return player;
  }

  // ==================== 音乐播放控制（Step 3） ====================

  /// 选择指定索引的歌曲并自动播放（1:1 对应旧 音乐封面 onTap）。
  void selectMusic(int index) {
    print('🎵 [GameSelect-Music] 选择歌曲: index=$index, '
        'prev=${state.selectedMusicIndex}');
    state = state.copyWith(
      selectedMusicIndex: index,
      isMusicPaused: false, // 切歌重置暂停标志
    );
    playMusic();
  }

  /// 播放音乐（1:1 对应旧 cbcs.playMusic）。
  Future<void> playMusic() async {
    try {
      final player = _ensureAudioPlayer();
      if (!state.isMusicPaused) {
        final url = _musicList[state.selectedMusicIndex];
        print('🎵 [GameSelect-Music] setUrl → $url');
        await player.setUrl(url);
        await player.setLoopMode(LoopMode.one);
      }
      state = state.copyWith(isMusicPaused: false);
      await player.play();
      print('🎵 [GameSelect-Music] play() 执行完成');
    } catch (e) {
      print('🎵 [GameSelect-Music] ❌ 播放音乐出错: $e');
      Fluttertoast.showToast(msg: "播放音乐出错");
    }
  }

  /// 暂停音乐（1:1 对应旧 cbcs.musicPause）。
  void pauseMusic() {
    print('🎵 [GameSelect-Music] pauseMusic()');
    state = state.copyWith(isMusicPaused: true);
    _audioPlayer?.pause();
  }

  /// 停止音乐（1:1 对应旧 cbcs.musicStop，跳转游戏/返回前调用）。
  Future<void> stopMusic() async {
    print('🎵 [GameSelect-Music] stopMusic()');
    state = state.copyWith(isMusicPaused: true);
    await _audioPlayer?.stop();
  }

  /// 切换音量开关（1:1 对应旧 volumeStop/volumeOpen）。
  void toggleVolume() {
    final nextOpen = !state.isVolumeOpen;
    final volume = nextOpen ? 0.5 : 0.0;
    print('🎵 [GameSelect-Music] toggleVolume → open=$nextOpen, vol=$volume');
    _ensureAudioPlayer().setVolume(volume);
    state = state.copyWith(isVolumeOpen: nextOpen);
  }

  // ==================== 专辑封面轮播（Step 4） ====================

  void _startAlbumCarousel() {
    if (_isCarouselRunning) return;
    _isCarouselRunning = true;
    print('🌅 [GameSelect-Carousel] 启动封面轮播 (100ms/帧)');
    _albumCarouselTimer?.cancel();
    _albumCarouselTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!state.isMusicPlaying) {
        _stopAlbumCarousel();
        return;
      }
      final next = state.albumImageIndex + 1;
      state = state.copyWith(albumImageIndex: next >= 71 ? 0 : next);
    });
  }

  void _stopAlbumCarousel() {
    if (!_isCarouselRunning) return;
    _albumCarouselTimer?.cancel();
    _albumCarouselTimer = null;
    _isCarouselRunning = false;
    print('🌅 [GameSelect-Carousel] 停止封面轮播, 当前index=${state.albumImageIndex}');
  }

  // ==================== 资源释放（Step 8） ====================

  /// 统一释放所有资源（页面 dispose / 返回按钮 / 跳转游戏前调用）。
  Future<void> disposeResources() async {
    print('🧹 [GameSelect] disposeResources() 开始清理');
    _stopAlbumCarousel();
    try {
      await _playerStateSubscription?.cancel();
      _playerStateSubscription = null;
      if (_audioPlayer != null) {
        await _audioPlayer!.stop();
        await _audioPlayer!.dispose();
        _audioPlayer = null;
        print('🧹 [GameSelect] AudioPlayer 已释放');
      }
    } catch (e) {
      print('🧹 [GameSelect] ⚠️ 释放音频资源异常: $e');
    }
    state = state.copyWith(isMusicPlaying: false);
  }

  // ==================== 游戏路由阻断校验（用户约束：无WebView→不允许跳转） ====================

  /// 检查第 gameIndex 张卡片对应的游戏页 WebView 是否已实装。
  ///
  /// - 未实装 → Fluttertoast 提示 + 返回 false（不允许跳转）
  /// - 已实装 → 返回 true（允许跳转）
  bool canNavigateToGame(int gameIndex) {
    if (state.gameRouteList.length <= gameIndex) {
      print('🧭 [GameSelect-Nav] ⛔ 阻断: gameRouteList 长度不足 index=$gameIndex');
      Fluttertoast.showToast(msg: "游戏页面开发中，敬请期待");
      return false;
    }
    final route = state.gameRouteList[gameIndex];
    final ready = state.gameWebViewReadyMap[route] ?? false;
    if (!ready) {
      print('🧭 [GameSelect-Nav] ⛔ WebView未实装 → 阻断跳转: route=$route, '
          'gameIndex=$gameIndex');
      Fluttertoast.showToast(msg: "游戏页面开发中，敬请期待");
      return false;
    }
    print('🧭 [GameSelect-Nav] ✅ WebView 实装校验通过: route=$route');
    return true;
  }
}

// ==================== 内部辅助类型 ====================

class _GameConfig {
  final List<String> pictures;
  final List<String> routes;
  _GameConfig({required this.pictures, required this.routes});
}
