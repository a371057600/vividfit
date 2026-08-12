import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../notifiers/gym_game_select_notifier.dart';
import '../notifiers/quick_start_notifier.dart';

/// 游戏选择页（对应旧 big_device_game_select.dart 的 GameSelect）。
///
/// UI 1:1 保持原样不改动；业务逻辑通过 ref.watch/ref.read 连接 Riverpod Notifier：
/// - 音乐 / 轮播 / 游戏路由 → GymGameSelectNotifier
/// - 运动数据 / START-STOP → QuickStartNotifier（复用）
class GymGameSelectScreen extends ConsumerStatefulWidget {
  final FtmsDeviceType deviceType;

  const GymGameSelectScreen({super.key, required this.deviceType});

  @override
  ConsumerState<GymGameSelectScreen> createState() =>
      _GymGameSelectScreenState();
}

class _GymGameSelectScreenState extends ConsumerState<GymGameSelectScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // 首次进入：初始化两个 Notifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gymGameSelectProvider.notifier).bootstrap(widget.deviceType);
      ref.read(quickStartProvider.notifier).setDeviceType(widget.deviceType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // watch 两个 Notifier 的 state
    final gameState = ref.watch(gymGameSelectProvider);
    final qsState = ref.watch(quickStartProvider);
    final qsNotifier = ref.read(quickStartProvider.notifier);

    return Scaffold(
      backgroundColor: FitTheme.backgroundColorOld,
      body: Stack(
        children: [
          // 主内容区 — 1:1 还原（UI 结构、间距、颜色、尺寸完全不动）
          Container(
            margin: EdgeInsets.only(left: 120, right: 0, top: 150).r,
            height: screenHeight,
            width: screenWidth,
            child: Row(
              children: [
                _leftContainer(
                  screenWidth,
                  screenHeight,
                  gameState.gamePictureList,
                ),
                SizedBox(width: 10.w),
                _rightContainer(
                  screenWidth,
                  screenHeight,
                  gameState,
                  qsState,
                  qsNotifier,
                ),
              ],
            ),
          ),
          // 返回按钮 — 1:1 还原（新增：点击停止运动+停止音乐+释放）
          Positioned(
            top: 40.h,
            left: 20.w,
            child: InkWell(
              onTap: () async {
                print('🏃 [GameSelect-Sport] 返回按钮 → 停止运动');
                ref.read(quickStartProvider.notifier).stopSport();
                print('🎵 [GameSelect-Music] 返回按钮 → 停止音乐+释放');
                await ref.read(gymGameSelectProvider.notifier).stopMusic();
                await ref
                    .read(gymGameSelectProvider.notifier)
                    .disposeResources();
                if (context.mounted && context.canPop()) {
                  print('🧭 [GameSelect-Nav] 返回 pop');
                  context.pop();
                }
              },
              child: Icon(Icons.arrow_back_ios, color: const Color(0xFFFFFFFF)),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 右侧容器（UI 完全不动，仅替换内部数据和回调） ====================
  Widget _rightContainer(
    double screenWidth,
    double screenHeight,
    dynamic gameState,
    dynamic qsState,
    dynamic qsNotifier,
  ) {
    final bool isPlaying = qsState.isPlaying;
    final notifier = ref.read(gymGameSelectProvider.notifier);

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 10, right: 50).r,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 专辑封面+播放控制区 — UI完全不动
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(40).r,
              ),
              height: screenHeight * 2 / 5,
              width: double.infinity,
              child: Stack(
                children: [
                  // 专辑封面图（索引改为从 gameState 取，用于轮播）
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      "images/newUIScreen/bigScreenAnimation/bigDeviceMusicPlay/${gameState.albumImageIndex}.jpg",
                      gaplessPlayback: true,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: const Color(0xFF4CAF50));
                      },
                    ),
                  ),
                  // 播放/暂停/音量按钮覆盖层 — UI 完全不动（回调绑定 Notifier）
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: screenHeight * 2 / 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 播放/暂停按钮 — UI 完全不动
                          gameState.isMusicPlaying
                              ? InkWell(
                                  onTap: () {
                                    print(
                                      '🎵 [GameSelect-Music] UI点击 → pauseMusic',
                                    );
                                    notifier.pauseMusic();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(40).r,
                                    width: 150.r,
                                    height: 150.r,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(40).w,
                                    ),
                                    child: Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_pause.png",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.pause, size: 50.w),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    print(
                                      '🎵 [GameSelect-Music] UI点击 → playMusic',
                                    );
                                    notifier.playMusic();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(40).r,
                                    width: 150.r,
                                    height: 150.r,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(40).w,
                                    ),
                                    child: Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_play.png",
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.play_arrow,
                                            size: 50.w,
                                          ),
                                    ),
                                  ),
                                ),
                          SizedBox(width: 100.w),
                          // 音量按钮 — UI 完全不动
                          InkWell(
                            onTap: () {
                              print(
                                '🎵 [GameSelect-Music] UI点击 → toggleVolume',
                              );
                              notifier.toggleVolume();
                            },
                            child: Container(
                              margin: EdgeInsets.all(40).r,
                              width: 150.r,
                              height: 150.r,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(40).w,
                              ),
                              child: gameState.isVolumeOpen
                                  ? Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/volume_open.png",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.volume_up, size: 50.w),
                                    )
                                  : Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/volume_close.png",
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.volume_off,
                                            size: 50.w,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 45.r),
            // 数据+按钮区 — UI 完全不动（仅替换数据来源）
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(),
                width: double.infinity,
                child: ListView(
                  shrinkWrap: false,
                  children: [
                    // 第一行数据：时间、距离、卡路里 — UI 完全不动（换为 qsState 真实值）
                    Container(
                      decoration: BoxDecoration(
                        color: FitTheme.secondbackGroundOld,
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: 200.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          _singleDataShow(
                            'Sport Time',
                            '',
                            qsNotifier.convertSecondsToTime(
                              qsState.realSportTime,
                            ),
                          ),
                          _singleDataShow(
                            'Distance',
                            '(km)',
                            (qsState.sportDistance / 1000).toStringAsFixed(2),
                          ),
                          _singleDataShow(
                            'Energy',
                            '(Kcal)',
                            qsState.sportEnergy.toStringAsFixed(0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.r),
                    // 第二行数据：设备相关指标 — UI 完全不动（按设备类型取字段）
                    Container(
                      decoration: BoxDecoration(
                        color: FitTheme.secondbackGroundOld,
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: 200.h,
                      width: double.infinity,
                      child: _deviceTypeSingleDataShowWidget(qsState),
                    ),
                    SizedBox(height: 80.r),
                    // 开始/停止按钮 — UI 完全不动（回调改为 QuickStartNotifier，对齐旧版样式）
                    Center(
                      child: isPlaying
                          ? InkWell(
                              splashColor: const Color(0x00000000),
                              onTap: () {
                                print('🏃 [GameSelect-Sport] STOP 按钮');
                                ref
                                    .read(quickStartProvider.notifier)
                                    .stopSport();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: FitTheme.buttonColor,
                                  borderRadius: BorderRadius.circular(40).r,
                                ),
                                height: 160.h,
                                width: screenWidth * 0.6,
                                child: Text(
                                  'STOP',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.bebas,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              splashColor: const Color(0x00000000),
                              onTap: () {
                                print('🏃 [GameSelect-Sport] STRAT 按钮');
                                ref
                                    .read(quickStartProvider.notifier)
                                    .startSport();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(40).r,
                                ),
                                height: 160.h,
                                width: screenWidth * 0.6,
                                child: Text(
                                  // 保持旧版拼写 'STRAT' 不变（查重需要）
                                  'STRAT',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.bebas,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 设备类型指标显示（1:1 对齐旧版 _deviceTypeSingleDataShowWidget）。
  Widget _deviceTypeSingleDataShowWidget(dynamic qsState) {
    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
        return Row(
          children: [
            _singleDataShow(
              "Heart Rate",
              "(bpm)",
              qsState.sportHeartRate.toString(),
            ),
            _singleDataShow(
              "Cadence",
              "(rpm)",
              qsState.sportCadence.toStringAsFixed(0),
            ),
            _singleDataShow(
              "Speed",
              "(km/h)",
              qsState.sportSpeed.toStringAsFixed(2),
            ),
          ],
        );
      case FtmsDeviceType.treadmill:
        return Row(
          children: [
            _singleDataShow(
              "Heart Rate",
              "(bpm)",
              qsState.sportHeartRate.toString(),
            ),
            _singleDataShow(
              "Inclination",
              "(%)",
              (qsState.sportInclinationButton).toStringAsFixed(0),
            ),
            _singleDataShow(
              "Speed",
              "(km/h)",
              qsState.sportSpeed.toStringAsFixed(2),
            ),
          ],
        );
      case FtmsDeviceType.crossTrainer:
        return Row(
          children: [
            _singleDataShow(
              "Heart Rate",
              "(bpm)",
              qsState.sportHeartRate.toString(),
            ),
            _singleDataShow(
              "Cadence",
              "(rpm)",
              qsState.sportCadence.toStringAsFixed(0),
            ),
            _singleDataShow(
              "Speed",
              "(km/h)",
              qsState.sportSpeed.toStringAsFixed(2),
            ),
          ],
        );
      case FtmsDeviceType.rower:
        return Row(
          children: [
            _singleDataShow(
              "Heart Rate",
              "(bpm)",
              qsState.sportHeartRate.toString(),
            ),
            _singleDataShow(
              "Stroke Count",
              "(T)",
              qsState.sportStrokeCount.toStringAsFixed(0),
            ),
            _singleDataShow(
              "Stroke Rate",
              "(rpm)",
              qsState.sportStrokeRate.toStringAsFixed(0),
            ),
          ],
        );
      case FtmsDeviceType.strengthStation:
        return Row(
          children: [
            _singleDataShow(
              "Heart Rate",
              "(bpm)",
              qsState.sportHeartRate.toString(),
            ),
            _singleDataShow(
              "Stroke Count",
              "(T)",
              qsState.sportStrokeCount.toStringAsFixed(0),
            ),
            _singleDataShow(
              "Stroke Rate",
              "(rpm)",
              qsState.sportStrokeRate.toStringAsFixed(0),
            ),
          ],
        );
    }
  }

  // ==================== 左侧容器（UI 完全不动，仅替换图片来源和回调） ====================
  Widget _leftContainer(
    double screenWidth,
    double screenHeight,
    List<String> gamePictureList,
  ) {
    final gameNotifier = ref.read(gymGameSelectProvider.notifier);
    final qsNotifier = ref.read(quickStartProvider.notifier);
    final int selectedMusicIndex = ref.watch(
      gymGameSelectProvider.select((s) => s.selectedMusicIndex),
    );

    return Container(
      padding: EdgeInsets.only(left: 50, right: 0).r,
      height: screenHeight,
      width: screenWidth / 2,
      child: Column(
        children: [
          // 游戏选择区（两个大卡片）— UI 完全不动（图片来源+回调替换）
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40).r,
            ),
            height: screenHeight * 2 / 5,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      // 第一关：WebView 实装阻断校验（用户约束：无连接→不让跳）
                      if (!gameNotifier.canNavigateToGame(0)) return;
                      final route = ref
                          .read(gymGameSelectProvider)
                          .gameRouteList[0];
                      print('🧭 [GameSelect-Nav] 游戏卡片1 → 先停止运动+音乐');
                      qsNotifier.stopSport();
                      await gameNotifier.stopMusic();
                      if (context.mounted) {
                        print('🧭 [GameSelect-Nav] push → $route');
                        context.push(route, extra: widget.deviceType);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40).r,
                      child: SizedBox(
                        width: screenWidth / 4 - 5.w,
                        child: Image.asset(
                          gamePictureList.isNotEmpty
                              ? gamePictureList[0]
                              : "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bike_game1.jpg",
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: const Color(0xFF9E9E9E));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // 第一关：WebView 实装阻断校验（用户约束：无连接→不让跳）
                      if (!gameNotifier.canNavigateToGame(1)) return;
                      final route = ref
                          .read(gymGameSelectProvider)
                          .gameRouteList[1];
                      // ⚠️ 严格对齐旧版 L563-566：卡片2 仅 toNamed，不做任何 stop
                      // 旧版卡片2行为：不stopSport、不musicStop、直接跳转
                      print(
                        '🧭 [GameSelect-Nav] 游戏卡片2 → 直接push（不停止运动/音乐，对齐旧版）',
                      );
                      print('🧭 [GameSelect-Nav] push → $route');
                      context.push(route, extra: widget.deviceType);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40).r,
                      child: SizedBox(
                        width: screenWidth / 4 - 5.w,
                        child: Image.asset(
                          gamePictureList.length > 1
                              ? gamePictureList[1]
                              : "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bike_game2.jpg",
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: const Color(0xFF9E9E9E));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 音乐选择区 — UI 完全不动（仅回调替换）
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40).r,
              ),
              height: screenHeight,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.r),
                    // 第一行音乐：大封面(0) + 2x2小封面(1-4) — UI 完全不动
                    Container(
                      height: 440.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          // 大封面 — UI 完全不动（选中态边框取 state）
                          InkWell(
                            onTap: () {
                              gameNotifier.selectMusic(0);
                            },
                            child: Container(
                              padding: EdgeInsets.all(20).r,
                              alignment: Alignment.bottomLeft,
                              height: 440.h,
                              width: screenWidth / 6 - 5.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40).r,
                                border: Border.all(
                                  color: selectedMusicIndex == 0
                                      ? const Color(0xFFE0E0E0)
                                      : const Color(0x00000000),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40).r,
                                child: Image.asset(
                                  'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/big_select.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF9E9E9E),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // 2x2 小封面 — UI 完全不动
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      _singleMusicSelectWidget(
                                        1,
                                        selectedMusicIndex,
                                      ),
                                      SizedBox(width: 10.w),
                                      _singleMusicSelectWidget(
                                        2,
                                        selectedMusicIndex,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                Expanded(
                                  child: Row(
                                    children: [
                                      _singleMusicSelectWidget(
                                        3,
                                        selectedMusicIndex,
                                      ),
                                      SizedBox(width: 10.w),
                                      _singleMusicSelectWidget(
                                        4,
                                        selectedMusicIndex,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.r),
                    // 第二行音乐：3个小封面(5-7) — UI 完全不动
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: 200.h,
                      width: screenWidth / 2,
                      child: Row(
                        children: [
                          _singleMusicSelectWidget(5, selectedMusicIndex),
                          SizedBox(width: 10.w),
                          _singleMusicSelectWidget(6, selectedMusicIndex),
                          SizedBox(width: 10.w),
                          _singleMusicSelectWidget(7, selectedMusicIndex),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 小组件（UI 完全不动，仅回调替换） ====================

  Widget _singleMusicSelectWidget(int index, int selectedMusicIndex) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(gymGameSelectProvider.notifier).selectMusic(index);
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40).r,
            border: Border.all(
              color: selectedMusicIndex == index
                  ? const Color(0xFFE0E0E0)
                  : const Color(0x00000000),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40).r,
            child: Image.asset(
              'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/0${index + 1}.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF9E9E9E));
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 单个数据展示 — 1:1 UI 完全不动（仅 _singleDataShow 的 padding 与旧版对齐）
  Widget _singleDataShow(String title, String unit, String data) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 50).r,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                data,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.bebas,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
