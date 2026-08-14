import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../../big_device/models/device_control_callbacks.dart';
import '../../big_device/models/device_control_data.dart';
import '../../big_device/models/sport_data_model.dart';
import '../../big_device/notifiers/gym_course_detail_notifier.dart';
import '../../big_device/notifiers/gym_course_play_notifier.dart';
import '../../big_device/states/gym_course_play_state.dart';
import '../../big_device/widgets/sport_control_panel.dart';
import '../../big_device/widgets/sport_data_display.dart';

/// 课程播放页（Phase 2 完整实现）。
///
/// 接入 [GymCoursePlayNotifier] 三态切换（loading / playing / finished），
/// 复用 [SportDataDisplay] 与 [SportControlPanel] 组件，并实现：
/// - 中央 Play 按钮（启动播放 / 进入结算页）
/// - 暂停覆盖层（恢复按钮）
/// - 结束页（10 项数据网格 + 4 项评分 + 综合等级 + 返回按钮）
///
/// 强制横屏，与旧版 big_device_play_screen.dart 视觉表现保持一致。
class CoursePlayPage extends ConsumerStatefulWidget {
  const CoursePlayPage({super.key});

  @override
  ConsumerState<CoursePlayPage> createState() => _CoursePlayPageState();
}

class _CoursePlayPageState extends ConsumerState<CoursePlayPage> {
  @override
  void initState() {
    super.initState();
    // 强制横屏 + 沉浸式状态栏（与旧版一致）
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // 在 PostFrameCallback 中初始化，避免在 build 期间修改 Provider 状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🎮 [CoursePlay] initState → initCourseContext');
      final notifier = ref.read(gymCoursePlayProvider.notifier);
      // 从详情页 Provider 读取课程上下文（courseId / deviceType）传入初始化
      // 不传 deviceType 时 Notifier 内部会跳过整个初始化逻辑，导致页面停留在 loading
      final detailState = ref.read(gymCourseDetailProvider);
      notifier.initCourseContext(
        courseId: detailState.courseId,
        deviceType: detailState.deviceType,
      );
    });
  }

  @override
  void dispose() {
    // 退出页面时恢复竖屏 + 边缘到边缘系统 UI
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gymCoursePlayProvider);
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    debugPrint(
      '🎮 [CoursePlay] build: status=${state.screenStatus.name}, '
      'isPlaying=${state.isPlaying}, isPauseScreen=${state.isPauseScreen}, '
      'isStopScreen=${state.isStopScreen}, showPlayButton=${state.showPlayButton}',
    );

    return Material(
      color: Colors.black,
      child: PopScope(
        canPop: false,
        child: SizedBox(
          width: sw,
          height: sh,
          child: _buildBody(state, l10n, sw, sh),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // 三态分发
  // ══════════════════════════════════════════════════════════

  Widget _buildBody(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    // 结束页优先判定：screenStatus.finished 或 isStopScreen 任一为真
    if (state.screenStatus == GymPlayScreenStatus.finished ||
        state.isStopScreen) {
      return _buildFinishedState(state, l10n, sw, sh);
    }
    if (state.screenStatus == GymPlayScreenStatus.loading) {
      return _buildLoadingState(l10n, sw, sh);
    }
    return _buildPlayingState(state, l10n, sw, sh);
  }

  // ══════════════════════════════════════════════════════════
  // Loading 态
  // ══════════════════════════════════════════════════════════

  Widget _buildLoadingState(AppLocalizations l10n, double sw, double sh) {
    return Container(
      width: sw,
      height: sh,
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 20.h),
          Text(
            l10n.coursePlayPlaceholder,
            style: TextStyle(color: FitTheme.textColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Playing 态
  // Stack 子节点顺序（Z 轴从底到顶）：
  //   1. 背景层（深色填充）
  //   2. 帧动画占位区域（显示当前动作名）
  //   3. 顶部数据栏（SportDataDisplay compact）
  //   4. 底部控制面板（SportControlPanel compact）
  //   5. 左上角返回按钮
  //   6. 中央 Play 按钮（showPlayButton 时）
  //   7. 暂停覆盖层（isPauseScreen 时）
  // ══════════════════════════════════════════════════════════

  Widget _buildPlayingState(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. 背景层
        Container(color: const Color.fromARGB(255, 20, 20, 20)),
        // 2. 帧动画占位区域
        _buildFrameAnimationPlaceholder(state, l10n, sw, sh),
        // 3. 顶部数据栏
        Positioned(
          top: 20.h,
          left: 0,
          right: 0,
          child: _buildTopDataBar(state, sw, sh),
        ),
        // 4. 底部控制面板
        Positioned(
          left: 0,
          right: 0,
          bottom: 20.h,
          child: _buildBottomControlPanel(state, sw, sh),
        ),
        // 5. 左上角返回按钮
        Positioned(top: 20.h, left: 20.w, child: _buildBackButton(state)),
        // 6. 中央 Play 按钮（仅 showPlayButton 且非暂停态时显示）
        if (state.showPlayButton && !state.isPauseScreen)
          _buildCenterPlayButton(),
        // 7. 暂停覆盖层
        if (state.isPauseScreen) _buildPauseOverlay(l10n, sw, sh),
      ],
    );
  }

  // ── 帧动画占位区域 ──
  // Phase 2 不实现真实帧动画播放，仅用 Container 占位并显示当前动作名
  Widget _buildFrameAnimationPlaceholder(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    final actions = state.courseActions;
    final currentName = actions.isNotEmpty
        ? actions[state.playIndex.clamp(0, actions.length - 1)].name
        : '';
    final playIndexLabel = actions.isNotEmpty
        ? '${state.playIndex + 1}/${actions.length}'
        : '0/0';

    return Center(
      child: Container(
        width: sw * 0.6,
        height: sh * 0.6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 60.w,
              color: Colors.white24,
            ),
            SizedBox(height: 10.h),
            Text(
              currentName,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '${l10n.action} $playIndexLabel',
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  // ── 顶部数据栏 ──
  Widget _buildTopDataBar(GymCoursePlayState state, double sw, double sh) {
    final sportDataModel = _buildSportDataModel(state);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 18, 18, 18),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SportDataDisplay(
        layout: DataDisplayLayout.compact,
        deviceType: state.deviceType,
        data: sportDataModel,
      ),
    );
  }

  // ── 底部控制面板 ──
  Widget _buildBottomControlPanel(
    GymCoursePlayState state,
    double sw,
    double sh,
  ) {
    final notifier = ref.read(gymCoursePlayProvider.notifier);
    final deviceControlData = DeviceControlData(
      speedValue: state.sportSpeedButton,
      inclineValue: state.sportInclinationButton,
      resistanceValue: state.sportResistanceButton,
      speedPresets: const [],
      inclinePresets: const [],
      resistancePresets: const [],
      hasInclinationSupport: state.hasInclinationSupport,
    );
    final deviceControlCallbacks = _buildControlCallbacks(notifier);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 18, 18, 18),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SportControlPanel(
        style: ControlPanelStyle.compact,
        deviceType: state.deviceType,
        data: deviceControlData,
        callbacks: deviceControlCallbacks,
      ),
    );
  }

  // ── 左上角返回按钮 ──
  Widget _buildBackButton(GymCoursePlayState state) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        debugPrint('🎮 [CoursePlay] 返回按钮点击');
        final notifier = ref.read(gymCoursePlayProvider.notifier);
        // 退出课程播放：先重置 Notifier 状态，再 pop 路由
        notifier.exitToDetail();
        if (context.canPop()) {
          context.pop();
        }
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Color.fromARGB(255, 200, 200, 200),
        size: 32,
      ),
    );
  }

  // ── 中央 Play 按钮 ──
  // 当 state.showPlayButton == true 且 !state.isPlaying：显示 Play 图标
  // 点击调用 notifier.togglePlay() 启动播放
  Widget _buildCenterPlayButton() {
    final btnSize = 100.w;
    final iconSize = 50.w;

    return SizedBox.expand(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          debugPrint('🎮 [CoursePlay] 中央 Play 按钮点击 → togglePlay');
          ref.read(gymCoursePlayProvider.notifier).togglePlay();
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.play_arrow,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── 暂停覆盖层 ──
  // state.isPauseScreen == true 时显示半透明黑色覆盖层
  // 中央显示"已暂停"文字 + 恢复按钮（调用 notifier.resumeSport()）
  Widget _buildPauseOverlay(AppLocalizations l10n, double sw, double sh) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pause_circle_outline, size: 80.w, color: Colors.white),
            SizedBox(height: 16.h),
            Text(
              '已暂停',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            InkWell(
              onTap: () {
                debugPrint('🎮 [CoursePlay] 暂停覆盖层 → 恢复按钮点击 → resumeSport');
                ref.read(gymCoursePlayProvider.notifier).resumeSport();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: FitTheme.buttonColor,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                    SizedBox(width: 8.w),
                    Text(
                      l10n.pleaseResumeTheMachine,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
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

  // ══════════════════════════════════════════════════════════
  // Finished 态（结束页）
  // ══════════════════════════════════════════════════════════

  Widget _buildFinishedState(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    return Container(
      width: sw,
      height: sh,
      color: Colors.black.withValues(alpha: 0.95),
      padding: EdgeInsets.symmetric(
        horizontal: 40.w,
        vertical: 24.h,
      ),
      child: Column(
        children: [
          // 顶部：标题 + 综合等级
          _buildFinishedHeader(state, l10n, sw, sh),
          SizedBox(height: 16.h),
          // 中部：10 项数据网格（5 列 × 2 行）
          Expanded(
            flex: 5,
            child: _buildFinishedDataGrid(state, sw, sh),
          ),
          SizedBox(height: 16.h),
          // 评分区：4 项评分
          Expanded(
            flex: 2,
            child: _buildRatingPanel(state, l10n, sw, sh),
          ),
          SizedBox(height: 16.h),
          // 底部：返回按钮
          _buildFinishedBackButton(l10n, sw, sh),
        ],
      ),
    );
  }

  // ── 结束页顶部：标题 + 综合等级文字 ──
  Widget _buildFinishedHeader(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.courseEndedPlaceholder,
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: FitTheme.buttonColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            state.scoreLevel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ── 10 项数据网格（5 列 × 2 行） ──
  Widget _buildFinishedDataGrid(GymCoursePlayState state, double sw, double sh) {
    final icons = state.finishDataIcons;
    final titles = state.finishDataTitles;
    final values = state.finishDataValues;
    final units = state.finishDataUnits;
    if (icons.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 2.2,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 28, 28, 28),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: FitTheme.buttonColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 顶部：图标 + 标题
              Row(
                children: [
                  Image.asset(
                    icons[index],
                    height: 18.h,
                    width: 24.w,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey,
                      height: 18.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      titles[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              // 数值 + 单位
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    values[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (units[index].isNotEmpty) ...[
                    SizedBox(width: 4.w),
                    Text(
                      units[index],
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── 4 项评分 ──
  Widget _buildRatingPanel(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    final titles = state.ratingTitles;
    final scores = state.ratingScores;
    if (titles.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(titles.length, (index) {
          final score = index < scores.length ? scores[index] : 0;
          return _buildRatingItem(titles[index], score);
        }),
      ),
    );
  }

  Widget _buildRatingItem(String title, int score) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            return Icon(
              i < score ? Icons.star : Icons.star_border,
              color: Colors.yellow,
              size: 14.w,
            );
          }),
        ),
      ],
    );
  }

  // ── 结束页返回按钮 ──
  Widget _buildFinishedBackButton(
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    return SizedBox(
      width: sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              debugPrint('🎮 [CoursePlay] 结束页返回按钮 → exitToDetail + context.pop');
              ref.read(gymCoursePlayProvider.notifier).exitToDetail();
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: sw * 0.25,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: FitTheme.buttonColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Text(
                l10n.back,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // 数据转换工具方法
  // ══════════════════════════════════════════════════════════

  /// 将 [GymCoursePlayState] 中的 String 字段转换为 [SportDataModel]。
  /// 解析失败的字段返回 null，由 [SportDataDisplay] 自行决定是否渲染。
  SportDataModel _buildSportDataModel(GymCoursePlayState state) {
    return SportDataModel(
      elapsedSeconds: _parseTimeToSeconds(state.sportTime),
      speed: double.tryParse(state.sportSpeed),
      distance: double.tryParse(state.sportDistance),
      energy: double.tryParse(state.sportCalories)?.toInt(),
      heartRate: int.tryParse(state.sportHeartRate),
      cadence: int.tryParse(state.sportCadence),
      resistanceLevel: int.tryParse(state.sportResistance),
      inclination: double.tryParse(state.sportInclination),
      strokeRate: int.tryParse(state.sportStrokeRate),
      strokeCount: int.tryParse(state.sportStrokeCount),
    );
  }

  /// 将 "MM:SS" 格式时间字符串解析为秒数。
  /// 解析失败返回 null。
  int? _parseTimeToSeconds(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final m = int.tryParse(parts[0]);
    final s = int.tryParse(parts[1]);
    if (m == null || s == null) return null;
    return m * 60 + s;
  }

  /// 构造 [DeviceControlCallbacks]，绑定到 [GymCoursePlayNotifier] 的控制方法。
  /// 单次点击 + 长按版本均接入；档位预设 Notifier 暂未实现，传 null 占位。
  DeviceControlCallbacks _buildControlCallbacks(GymCoursePlayNotifier notifier) {
    return DeviceControlCallbacks(
      // 速度
      onSpeedAdd: notifier.speedAdd,
      onSpeedDown: notifier.speedDown,
      onSpeedLongPressAdd: notifier.speedAddLongPress,
      onSpeedLongPressDown: notifier.speedDownLongPress,
      // 坡度
      onInclineAdd: notifier.inclinationAdd,
      onInclineDown: notifier.inclinationDown,
      onInclineLongPressAdd: notifier.inclinationAddLongPress,
      onInclineLongPressDown: notifier.inclinationDownLongPress,
      // 阻力
      onResistanceAdd: notifier.resistanceAdd,
      onResistanceDown: notifier.resistanceDown,
      onResistanceLongPressAdd: notifier.resistanceAddLongPress,
      onResistanceLongPressDown: notifier.resistanceDownLongPress,
      // 通用：长按结束保护窗口
      onLongPressEnd: notifier.longPressEnd,
    );
  }
}
