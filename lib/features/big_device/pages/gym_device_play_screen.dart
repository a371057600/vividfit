import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../../../l10n/app_localizations.dart';
import '../data/sport_metric_icons.dart';
import '../notifiers/gym_course_play_notifier.dart';
import '../states/gym_course_play_state.dart';

/// 大设备运动播放页 (对应原版 big_device_play_screen.dart)
///
/// 支持 4 种设备类型:
/// - [FtmsDeviceType.indoorBike] 动感单车
/// - [FtmsDeviceType.treadmill] 跑步机
/// - [FtmsDeviceType.crossTrainer] 椭圆机
/// - [FtmsDeviceType.rower] 划船机
///
/// 三态: loading / playing / finished
class GymDevicePlayScreen extends ConsumerStatefulWidget {
  final String courseId;
  final FtmsDeviceType deviceType;

  const GymDevicePlayScreen({
    super.key,
    required this.courseId,
    required this.deviceType,
  });

  @override
  ConsumerState<GymDevicePlayScreen> createState() => _GymDevicePlayScreenState();
}

class _GymDevicePlayScreenState extends ConsumerState<GymDevicePlayScreen> {
  // ── 等级相关数据 (对应原版 stageList / stateExTitleList) ──
  final List<String> _stageIcons = const [
    'images/newUIScreen/bigScreenAnimation/icons/stage0.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage1.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage2.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage3.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage4.png',
  ];

  final List<String> _stageTitles = const [
    'Easy Adaptation',
    'Moderate Improvement',
    'Moderate Challenge',
    'Intense Load',
    'Extreme Breakthrough',
  ];

  // ── 进度条分段颜色 (对应 uniqueColors) ──
  final List<Color> _segmentColors = const [
    Color(0xFF80FFCC),
    Color(0xFF7B93FF),
    Color(0xFFFFDD66),
    Color(0xFFFF9999),
    Color(0xFF66CCFF),
    Color(0xFFCCAA88),
    Color(0xFFAAAAAA),
  ];

  // ── 评分等级图片 (对应 motoLeaveListImage) ──
  final List<String> _ratingLevelIcons = const [
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer0.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer1.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer2.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer3.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer4.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer5.png',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gymCoursePlayProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: _buildBody(state, l10n, context),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // 四态分发: loading / playing / paused / finished
  // ══════════════════════════════════════════════════════════
  Widget _buildBody(GymCoursePlayState state, AppLocalizations l10n, BuildContext context) {
    if (state.screenStatus == GymPlayScreenStatus.loading) {
      return _buildLoadingState(state, l10n);
    }
    if (state.isStopScreen) {
      return _buildFinishedState(state, l10n, context);
    }
    return Stack(
      children: [
        _buildPlayingState(state, l10n, context),
        if (state.isPauseScreen) _buildPauseOverlay(state),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // Loading 态
  // ══════════════════════════════════════════════════════════
  Widget _buildLoadingState(GymCoursePlayState state, AppLocalizations l10n) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 20.h),
          if (state.allowTouch)
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF242424),
                borderRadius: BorderRadius.circular(40.r),
              ),
              padding: EdgeInsets.all(15),
              child: Text(
                l10n.back,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Playing 态 (完整播放界面)
  // ══════════════════════════════════════════════════════════
  Widget _buildPlayingState(GymCoursePlayState state, AppLocalizations l10n, BuildContext context) {
    return Stack(
      children: [
        // 1. 背景动画层 (按设备类型切换)
        ..._buildDeviceBackground(state),

        // 2. 顶部数据条
        _buildTopDataBar(state, l10n),

        // 3. 左侧课程信息
        _buildLeftCourseInfo(state),

        // 4. 右侧动作列表
        _buildRightActionList(state, context),

        // 5. 底部进度条分段
        _buildProgressSegments(state),

        // 6. 播放进度箭头
        _buildProgressArrow(state, context),

        // 7. 中央 Play 按钮
        if (state.showPlayButton) _buildCenterPlayButton(state),

        // 8. 控制按钮 (按设备类型)
        ..._buildControlButtons(state),

        // 9. 返回按钮
        _buildBackButton(state),

        // 10. 底部/顶部蒙版 (渐隐效果)
        _buildBottomFadeMask(),
        _buildTopFadeMask(),
      ],
    );
  }

  // ── 1. 背景动画层 ──
  List<Widget> _buildDeviceBackground(GymCoursePlayState state) {
    final deviceType = state.deviceType;
    final actions = state.courseActions;
    if (actions.isEmpty) return [const SizedBox.shrink()];

    final currentAction = actions[state.playIndex.clamp(0, actions.length - 1)];
    final isRest = currentAction.isRestStage;

    return [
      // 动作帧 (占位 Container, 等待实装动画)
      Positioned(
        top: 200.h,
        bottom: 200.h,
        left: 0,
        right: 0,
        child: Container(
          color: const Color(0xFF121212),
          child: Center(
            child: Text(
              isRest ? 'REST' : currentAction.name,
              style: TextStyle(color: Colors.white, fontSize: 40.sp),
            ),
          ),
        ),
      ),
    ];
  }

  // ── 2. 顶部数据条 ──
  Widget _buildTopDataBar(GymCoursePlayState state, AppLocalizations l10n) {
    final deviceType = state.deviceType;

    // 划船机: 第 4 项显示桨频
    final fourthIcon = deviceType == FtmsDeviceType.rower
        ? SportMetricIcons.strokeCount
        : SportMetricIcons.speed;
    final fourthValue = deviceType == FtmsDeviceType.rower
        ? state.sportStrokeRate
        : state.sportSpeed;

    return Container(
      margin: EdgeInsets.only(left: 140.w, top: 40.r, right: 20.w),
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topDataItem(SportMetricIcons.time, state.sportTime),
          _topDataItem(SportMetricIcons.distance, state.sportDistance),
          _topDataItem(SportMetricIcons.calories, state.sportCalories),
          _topDataItem(fourthIcon, fourthValue),
          _topDataItem(SportMetricIcons.heartRate, state.sportHeartRate),
        ],
      ),
    );
  }

  Widget _topDataItem(String iconPath, String value) {
    return Row(
      children: [
        Image.asset(iconPath, height: 30, color: Colors.white),
        SizedBox(width: 3.w),
        SizedBox(
          width: 60.w,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Bebas',
            ),
          ),
        ),
      ],
    );
  }

  // ── 3. 左侧课程信息 ──
  Widget _buildLeftCourseInfo(GymCoursePlayState state) {
    final actions = state.courseActions;
    final currentAction = actions.isNotEmpty
        ? actions[state.playIndex.clamp(0, actions.length - 1)]
        : null;

    return Positioned(
      top: 50.h,
      left: 20.w,
      child: Container(
        width: 180.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 课程标题 (跑马灯)
            _AutoScrollText(
              text: state.courseTitle,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30.h),
            // 难度 + 星级
            Row(
              children: [
                Text(
                  state.difficulty,
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
                SizedBox(width: 5.w),
                _buildStarRating(state.level),
              ],
            ),
            SizedBox(height: 20.h),
            // 当前动作
            Row(
              children: [
                Text(
                  currentAction?.name ?? '',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
                SizedBox(width: 5.w),
                Text(
                  _formatCurrentDuration(state),
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // 当前组
            Row(
              children: [
                Text(
                  'Current Set',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
                SizedBox(width: 5.w),
                Text(
                  '${state.playIndex + 1}/${actions.length}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            // 训练等级图标
            _buildTrainingLevel(state.level),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int level) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < level ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 12.sp,
        );
      }),
    );
  }

  Widget _buildTrainingLevel(int level) {
    final index = level.clamp(1, 5) - 1;
    return Container(
      width: 160.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.all(30.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Training Intensity',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Image.asset(
              _stageIcons[index],
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade800,
                child: Center(child: Text('L${level + 1}', style: TextStyle(color: Colors.white))),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            _stageTitles[index],
            style: TextStyle(fontSize: 8.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatCurrentDuration(GymCoursePlayState state) {
    final seconds = state.currentDuration - state.playIndexDuration;
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── 4. 右侧动作列表 ──
  Widget _buildRightActionList(GymCoursePlayState state, BuildContext context) {
    final names = state.currentActionNameList;
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      right: 20.w,
      top: 300.h,
      child: Container(
        height: screenHeight * 0.35,
        width: 100.w,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF383838),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: names.length,
          itemBuilder: (context, index) {
            final isCurrent = index == 0;
            return Container(
              margin: EdgeInsets.only(left: 30, top: index == 0 ? 30 : 0).r,
              width: 200,
              height: 100.h,
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  names[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isCurrent ? Colors.white : const Color(0xFF555555),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── 5. 底部进度条分段 ──
  Widget _buildProgressSegments(GymCoursePlayState state) {
    final segments = state.progressSegments;
    if (segments.isEmpty) return const SizedBox.shrink();

    return Positioned(
      bottom: 50.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        height: 200.h,
        child: Row(
          children: segments.asMap().entries.map((entry) {
            final index = entry.key;
            final segment = entry.value;
            final colorIndex = segment.posture.clamp(0, _segmentColors.length - 1);
            final color = _segmentColors[colorIndex];

            // 高度因子: 越高阻力/速度 → 高度越高
            final heightBase = 180.h - segment.heightFactor * 20.h;
            final clampedHeight = heightBase.clamp(20.h, 200.h);

            return Expanded(
              flex: (segment.percentage * 1000).round(),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(left: 1),
                  height: clampedHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── 6. 播放进度箭头 ──
  Widget _buildProgressArrow(GymCoursePlayState state, BuildContext context) {
    final percent = state.playProgressPercent.clamp(0.0, 1.0);
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: 20.w,
      right: 20.w,
      child: Container(
        height: 40.h,
        child: Stack(
          children: [
            Positioned(
              left: (screenWidth - 40.w) * percent - 5.w,
              bottom: 0,
              child: SizedBox(
                width: 10.w,
                height: 50.h,
                child: Icon(Icons.arrow_upward, color: Colors.red, size: 20.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 7. 中央 Play 按钮 ──
  Widget _buildCenterPlayButton(GymCoursePlayState state) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // 仅当设备速度为 0 时启动
          if (state.sportDeviceSpeed == 0) {
            ref.read(gymCoursePlayProvider.notifier).togglePlay();
          }
        },
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(125),
            border: Border.all(
              color: Colors.white.withAlpha(125),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(77),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Icons.play_arrow, size: 60.w, color: Colors.white),
        ),
      ),
    );
  }

  // ── 8. 控制按钮 (按设备类型) ──
  List<Widget> _buildControlButtons(GymCoursePlayState state) {
    final notifier = ref.read(gymCoursePlayProvider.notifier);
    final deviceType = state.deviceType;

    switch (deviceType) {
      case FtmsDeviceType.treadmill:
        return [
          // 坡度按钮 (底部偏上)
          if (state.hasInclinationSupport)
            Positioned(
              bottom: 700.h,
              left: 20.w,
              child: _buildSingleButton(
                title: '坡度',
                value: state.sportInclinationButton.toStringAsFixed(1),
                onAdd: notifier.inclinationAdd,
                onSub: notifier.inclinationDown,
              ),
            ),
          // 速度按钮 (底部偏下)
          Positioned(
            bottom: 300.h,
            left: 20.w,
            child: _buildSingleButton(
              title: '速度',
              value: state.sportSpeedButton.toStringAsFixed(1),
              onAdd: notifier.speedAdd,
              onSub: notifier.speedDown,
              longPressAdd: notifier.speedAdd,
              longPressSub: notifier.speedDown,
            ),
          ),
        ];

      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.rower:
      default:
        return [
          Positioned(
            bottom: 700.h,
            left: 20.w,
            child: _buildSingleButton(
              title: '阻力',
              value: state.sportResistanceButton.toStringAsFixed(1),
              onAdd: notifier.resistanceAdd,
              onSub: notifier.resistanceDown,
            ),
          ),
        ];
    }
  }

  Widget _buildSingleButton({
    required String title,
    required String value,
    required VoidCallback onAdd,
    required VoidCallback onSub,
    VoidCallback? longPressAdd,
    VoidCallback? longPressSub,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(30.r),
      ),
      width: 110.w,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20).r,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
          Divider(height: 5.h, thickness: 1),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onAdd,
                  onLongPress: longPressAdd,
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 30.sp, color: Colors.white),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: 'Bebas',
                  ),
                ),
                GestureDetector(
                  onTap: onSub,
                  onLongPress: longPressSub,
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.remove, size: 30.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 9. 返回按钮 ──
  Widget _buildBackButton(GymCoursePlayState state) {
    return Positioned(
      right: 25.w,
      top: 100.h,
      child: GestureDetector(
        onTap: () {
          debugPrint('👆 [PlayScreen] Back button tapped → entering pause');
          final notifier = ref.read(gymCoursePlayProvider.notifier);
          notifier.pauseSport();
        },
        child: SizedBox(
          height: 20.sp,
          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.sp),
        ),
      ),
    );
  }

  // ── 10. 蒙版 ──
  Widget _buildTopFadeMask() {
    return Container(
      height: 320.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xB1000000),
            const Color(0xB1000000),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomFadeMask() {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 400.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              const Color(0xB1000000),
              const Color(0xB1000000),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Finished 态 (结束页)
  // ══════════════════════════════════════════════════════════
  Widget _buildFinishedState(GymCoursePlayState state, AppLocalizations l10n, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(25).r,
      color: Colors.black,
      child: Column(
        children: [
          // 顶部: 三环 + 数据 + 评分 + 速度图
          _buildFinishedFirstRow(state),

          // 10 项数据网格
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 100, bottom: 25).r,
              child: _buildFinishedDataGrid(state),
            ),
          ),

          // Course Over 按钮
          _buildCourseOverButton(state, l10n, context),
        ],
      ),
    );
  }

  Widget _buildFinishedFirstRow(GymCoursePlayState state) {
    return Container(
      height: 600.h,
      child: Row(
        children: [
          // 三环 + 运动数据
          _buildFinishedCircularData(state),
          // 训练等级
          Expanded(child: _buildTrainingLevel(state.level)),
          // 评分
          Expanded(child: _buildRatingPanel(state)),
          // 速度条形图
          Expanded(child: _buildSpeedChartPanel(state)),
        ],
      ),
    );
  }

  Widget _buildFinishedCircularData(GymCoursePlayState state) {
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(right: 25).r,
        padding: EdgeInsets.all(25).r,
        height: 600.h,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 30.r),
            _buildTripleRing(state),
            SizedBox(width: 30.r),
            Expanded(
              child: Column(
                children: [
                  _buildFinishedDataText('Time', state.sportTime),
                  state.deviceType == FtmsDeviceType.rower
                      ? _buildFinishedDataText('Counts', state.sportStrokeCount)
                      : _buildFinishedDataText('Distance', state.sportDistance),
                  _buildFinishedDataText('Calories', state.sportCalories),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripleRing(GymCoursePlayState state) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 外圈 (时间)
        CircularStepProgressIndicator(
          totalSteps: 120,
          currentStep: state.playTotalDuration.clamp(0, 101),
          stepSize: 18.r,
          startingAngle: -3.14 * 0.9,
          selectedColor: Colors.white,
          unselectedColor: Colors.transparent,
          padding: 0,
          width: 200.r,
          height: 200.r,
          selectedStepSize: 18.r,
          roundedCap: (_, __) => true,
          child: CircularStepProgressIndicator(
            totalSteps: 115,
            currentStep: state.courseActions.isNotEmpty
                ? state.courseActions.fold<int>(0, (a, b) => a + b.duration).clamp(0, 101)
                : 0,
            stepSize: 18.r,
            startingAngle: -3.14 * 0.87,
            selectedColor: Colors.blue,
            unselectedColor: Colors.transparent,
            padding: 0,
            selectedStepSize: 18.r,
            roundedCap: (_, __) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 120,
              currentStep: int.tryParse(state.sportCalories)?.clamp(0, 101) ?? 0,
              stepSize: 18.r,
              startingAngle: -3.14 * 0.8,
              selectedColor: Colors.green,
              unselectedColor: Colors.transparent,
              padding: 0,
              selectedStepSize: 18.r,
              roundedCap: (_, __) => true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinishedDataText(String title, String data) {
    return Expanded(
      child: Container(
        height: 80.h,
        color: const Color(0xFF121212),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                title,
                style: TextStyle(fontSize: 10.sp, color: Colors.white),
              ),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingPanel(GymCoursePlayState state) {
    final titles = state.ratingTitles;
    final scores = state.ratingScores;
    final indices = state.ratingImageIndices;

    return Container(
      height: 600.h,
      margin: EdgeInsets.only(left: 25, right: 25).r,
      padding: EdgeInsets.all(30).r,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Rating',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(titles.length, (i) {
                return _buildSingleRatingRow(
                  titles[i],
                  indices.isNotEmpty && i < indices.length ? indices[i] : 0,
                );
              }),
            ),
          ),
          Text(
            state.scoreLevel,
            style: TextStyle(fontSize: 10.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleRatingRow(String title, int levelIndex) {
    return Container(
      height: 40.h,
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              title,
              style: TextStyle(fontSize: 10.sp, color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              height: 15,
              child: Image.asset(
                _ratingLevelIcons[levelIndex.clamp(0, _ratingLevelIcons.length - 1)],
                fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedChartPanel(GymCoursePlayState state) {
    final data = state.speedChartData;
    final isRower = state.deviceType == FtmsDeviceType.rower;

    return Container(
      height: 600.h,
      padding: EdgeInsets.all(30).r,
      margin: EdgeInsets.only(left: 25, right: 25).r,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(30).r,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20).r,
            child: Text(
              'Speed Bar Chart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 250.h,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  minY: 0,
                  maxY: 40,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(data.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i],
                          width: 2,
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    );
                  }),
                ),
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              ),
            ),
          ),
          Text(
            isRower ? 'spm/group' : 'km/h',
            style: TextStyle(fontSize: 10.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedDataGrid(GymCoursePlayState state) {
    final icons = state.finishDataIcons;
    final titles = state.finishDataTitles;
    final values = state.finishDataValues;
    final units = state.finishDataUnits;

    if (icons.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 25,
        childAspectRatio: 2,
        crossAxisSpacing: 12.5,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
                child: Row(
                  children: [
                    Image.asset(
                      icons[index],
                      height: 30,
                      width: 40,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey,
                        height: 30,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        '${titles[index]}${units[index]}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                values[index],
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseOverButton(GymCoursePlayState state, AppLocalizations l10n, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 160.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(30),
            ),
            width: screenWidth / 4,
            child: InkWell(
              onTap: () {
                debugPrint('👆 [PlayScreen] Course Over button tapped → exiting to detail');
                final notifier = ref.read(gymCoursePlayProvider.notifier);
                notifier.exitToDetail();
                Navigator.of(context).pop();
              },
              child: Text(
                'Course Over',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Pause 暂停覆盖层
  // ══════════════════════════════════════════════════════════
  Widget _buildPauseOverlay(GymCoursePlayState state) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {},  // 阻止点击穿透
        child: Container(
          color: Colors.black.withAlpha(200),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              padding: EdgeInsets.all(40.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 暂停图标
                  Icon(Icons.pause_circle, size: 100.sp, color: Colors.white),
                  SizedBox(height: 30.h),
                  // 标题
                  Text(
                    'PAUSED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '运动已暂停',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  SizedBox(height: 50.h),
                  // 按钮行
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 继续按钮
                      GestureDetector(
                        onTap: () {
                          final notifier = ref.read(gymCoursePlayProvider.notifier);
                          notifier.resumeSport();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            '继续',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                      // 退出课程按钮
                      GestureDetector(
                        onTap: () {
                          final notifier = ref.read(gymCoursePlayProvider.notifier);
                          notifier.exitToDetail();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            '退出课程',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// 跑马灯文本组件 (对应原版 AutoScrollText)
// ══════════════════════════════════════════════════════════
class _AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _AutoScrollText({
    required this.text,
    required this.style,
  });

  @override
  State<_AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<_AutoScrollText> {
  final _controller = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _startScroll();
  }

  @override
  void didUpdateWidget(covariant _AutoScrollText oldWidget) {
    if (oldWidget.text != widget.text) {
      _controller.jumpTo(0);
      _isScrolling = false;
      _startScroll();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startScroll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _performScroll();
  }

  void _performScroll() async {
    if (_isScrolling) return;
    setState(() => _isScrolling = true);

    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textWidth = textPainter.width;
    final scrollDistance = textWidth + 40;
    const scrollSpeed = 30.0;
    final scrollDuration =
        Duration(milliseconds: (scrollDistance / scrollSpeed * 1000).toInt());

    await _controller.animateTo(
      scrollDistance,
      duration: scrollDuration,
      curve: Curves.linear,
    );

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    _controller.jumpTo(0);
    setState(() => _isScrolling = false);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _performScroll();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        physics: _isScrolling ? const NeverScrollableScrollPhysics() : null,
        child: Row(
          children: [
            Text(widget.text, maxLines: 1, style: widget.style),
            SizedBox(width: 40),
            Text(widget.text, maxLines: 1, style: widget.style),
          ],
        ),
      ),
    );
  }
}
