import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/home_notifier.dart';
import '../states/home_state.dart';

// ============================================================================
// 功能入口配置模型
// ============================================================================
class HomeFuncEntryConfig {
  final String key;
  final String Function(AppLocalizations) labelBuilder;
  final String imagePath;
  final String? route;
  final int? tabIndex;
  final bool isEnabled;

  const HomeFuncEntryConfig({
    required this.key,
    required this.labelBuilder,
    required this.imagePath,
    this.route,
    this.tabIndex,
    this.isEnabled = true,
  });
}

// ============================================================================
// 卡片网格类型枚举
// ============================================================================
enum HomeGridCardType {
  numberAndUnit,
  textStatus,
  unitOnly,
}

// ============================================================================
// 卡片网格配置模型
// ============================================================================
class HomeGridCardConfig {
  final String key;
  final String Function(AppLocalizations) titleBuilder;
  final String imagePath;
  final String Function(AppLocalizations)? unitBuilder;
  final HomeGridCardType cardType;
  final bool isCnOnly;
  final bool isNotCnOnly;
  final bool isEnabled;

  const HomeGridCardConfig({
    required this.key,
    required this.titleBuilder,
    required this.imagePath,
    this.unitBuilder,
    required this.cardType,
    this.isCnOnly = false,
    this.isNotCnOnly = false,
    this.isEnabled = true,
  });
}

/// 主页主屏(1:1 复刻旧 NewMainSportScreen)。
class HomeTabScreen extends ConsumerWidget {
  HomeTabScreen({super.key});

  static const _ringLabels = ['timeMin', 'met', 'kcal'];
  static const _ringColors = [
    Color.fromARGB(255, 6, 249, 223),
    Color.fromARGB(255, 48, 244, 0),
    Color.fromARGB(255, 255, 168, 0),
    Color.fromARGB(255, 230, 51, 16),
  ];
  // ---- 功能入口配置模型 ----
  late final List<HomeFuncEntryConfig> _funcEntryConfigs = [
    // 顺序即为显示顺序, 禁用后会自动跳过, 空位自动填充
    HomeFuncEntryConfig(
      key: 'game',
      labelBuilder: (l10n) => l10n.game,
      imagePath: 'images/newUIScreen/icons/icon_game.png',
      route: '/placeholder',
    ),
    HomeFuncEntryConfig(
      key: 'medal',
      labelBuilder: (l10n) => l10n.medal,
      imagePath: 'images/newUIScreen/icons/icon_second_button1.png',
      route: '/placeholder',
    ),
    HomeFuncEntryConfig(
      key: 'ranks',
      labelBuilder: (l10n) => l10n.ranks,
      imagePath: 'images/newUIScreen/icons/icon_second_button0.png',
      route: '/ranking',
    ),
    HomeFuncEntryConfig(
      key: 'daily',
      labelBuilder: (l10n) => l10n.daily,
      imagePath: 'images/newUIScreen/icons/icon_second_button4.png',
      route: '/placeholder',
    ),
    HomeFuncEntryConfig(
      key: 'courses',
      labelBuilder: (l10n) => l10n.courses,
      imagePath: 'images/newUIScreen/icons/icon_second_button3.png',
      tabIndex: 1,
    ),
    // AI 入口 - 暂时禁用, 启用时将 isEnabled 改为 true
    HomeFuncEntryConfig(
      key: 'fitnessAi',
      labelBuilder: (l10n) => l10n.fitnessAi,
      imagePath: 'images/newUIScreen/icons/icon_second_button2.png',
      route: '/placeholder',
      isEnabled: false,
    ),
  ];

  // ---- 卡片网格配置 ----
  late final List<HomeGridCardConfig> _gridCardConfigs = [
    // CN 卡片 (简中模式)
    HomeGridCardConfig(
      key: 'exerciseRecord',
      titleBuilder: (l10n) => l10n.exerciseRecord,
      imagePath: 'images/newUIScreen/icons/icon_home_page0.png',
      unitBuilder: (l10n) => l10n.times,
      cardType: HomeGridCardType.numberAndUnit,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'bodyData',
      titleBuilder: (l10n) => l10n.bodyData,
      imagePath: 'images/newUIScreen/icons/icon_home_page1.png',
      unitBuilder: (l10n) => l10n.bmi,
      cardType: HomeGridCardType.numberAndUnit,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'burnRank',
      titleBuilder: (l10n) => l10n.burnRank,
      imagePath: 'images/newUIScreen/icons/icon_home_page2.png',
      unitBuilder: (l10n) => l10n.rankUnit,
      cardType: HomeGridCardType.numberAndUnit,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'todaysBurn',
      titleBuilder: (l10n) => l10n.todaysBurn,
      imagePath: 'images/newUIScreen/icons/icon_home_page3.png',
      unitBuilder: (l10n) => l10n.kcal,
      cardType: HomeGridCardType.numberAndUnit,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'checkInTask',
      titleBuilder: (l10n) => l10n.checkInTask,
      imagePath: 'images/newUIScreen/icons/icon_home_page4.png',
      cardType: HomeGridCardType.textStatus,
      isCnOnly: true,
    ),
    // AI 卡片 - 暂时禁用, 启用时将 isEnabled 改为 true
    HomeGridCardConfig(
      key: 'aiPt',
      titleBuilder: (l10n) => l10n.aiPt,
      imagePath: 'images/newUIScreen/icons/icon_home_page5.png',
      cardType: HomeGridCardType.textStatus,
      isCnOnly: true,
      isEnabled: false,
    ),
    HomeGridCardConfig(
      key: 'onlineStore',
      titleBuilder: (l10n) => l10n.onlineStore,
      imagePath: 'images/newUIScreen/icons/icon_home_page6.png',
      unitBuilder: (l10n) => l10n.jdShopping,
      cardType: HomeGridCardType.unitOnly,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'sportsGoal',
      titleBuilder: (l10n) => l10n.sportsGoal,
      imagePath: 'images/newUIScreen/icons/icon_home_page7.png',
      unitBuilder: (l10n) => l10n.reasonableGoalSetting,
      cardType: HomeGridCardType.unitOnly,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'sportsReport',
      titleBuilder: (l10n) => l10n.sportsReport,
      imagePath: 'images/newUIScreen/icons/icon_home_page8.png',
      unitBuilder: (l10n) => l10n.annualSportsSummary,
      cardType: HomeGridCardType.unitOnly,
      isCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'onlineManual',
      titleBuilder: (l10n) => l10n.onlineManual,
      imagePath: 'images/newUIScreen/icons/icon_home_page9.png',
      unitBuilder: (l10n) => l10n.manualDownload,
      cardType: HomeGridCardType.unitOnly,
      isCnOnly: true,
    ),
    // 非 CN 卡片 (国际模式)
    HomeGridCardConfig(
      key: 'exerciseRecord',
      titleBuilder: (l10n) => l10n.exerciseRecord,
      imagePath: 'images/newUIScreen/icons/icon_home_page0.png',
      unitBuilder: (l10n) => l10n.times,
      cardType: HomeGridCardType.numberAndUnit,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'bodyMassIndex',
      titleBuilder: (l10n) => l10n.bodyMassIndex,
      imagePath: 'images/newUIScreen/icons/icon_home_page1.png',
      cardType: HomeGridCardType.numberAndUnit,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'ranks',
      titleBuilder: (l10n) => l10n.ranks,
      imagePath: 'images/newUIScreen/icons/icon_home_page2.png',
      cardType: HomeGridCardType.numberAndUnit,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'kcalCons',
      titleBuilder: (l10n) => l10n.kcalCons,
      imagePath: 'images/newUIScreen/icons/icon_home_page3.png',
      unitBuilder: (l10n) => l10n.kcal,
      cardType: HomeGridCardType.numberAndUnit,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'dailyTask',
      titleBuilder: (l10n) => l10n.dailyTask,
      imagePath: 'images/newUIScreen/icons/icon_home_page4.png',
      cardType: HomeGridCardType.textStatus,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'fitnessGoals',
      titleBuilder: (l10n) => l10n.fitnessGoals,
      imagePath: 'images/newUIScreen/icons/icon_home_page7.png',
      unitBuilder: (l10n) => l10n.goalSetting,
      cardType: HomeGridCardType.unitOnly,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'sportsReport',
      titleBuilder: (l10n) => l10n.sportsReport,
      imagePath: 'images/newUIScreen/icons/icon_home_page8.png',
      unitBuilder: (l10n) => l10n.annualSportsReview,
      cardType: HomeGridCardType.unitOnly,
      isNotCnOnly: true,
    ),
    HomeGridCardConfig(
      key: 'deviceManual',
      titleBuilder: (l10n) => l10n.deviceManual,
      imagePath: 'images/newUIScreen/icons/icon_home_page9.png',
      unitBuilder: (l10n) => l10n.manualDownload,
      cardType: HomeGridCardType.unitOnly,
      isNotCnOnly: true,
    ),
  ];
  static const _deviceEntryKeys = [
    'spinBike',
    'treadmillMachine',
    'ellipticalMachine',
    'rowingMachine',
    'strengthStation',
    'game',
    'game',
  ];
  static const _deviceEntryImages = [
    'images/newUIScreen/HomePageAnimation/other/icon_bike.png',
    'images/newUIScreen/HomePageAnimation/other/icon_run_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_run_elliptical_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_rowing_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_power_station.png',
    'images/newUIScreen/icons/icon_game.png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildRingSection(context, ref),
              _buildDeviceEntries(context),
              _buildFuncEntries(context, ref),
              _buildBmiCard(context, ref),
              _buildCardGrid(context, ref),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ---- 三环 + 动画人物 ----
  Widget _buildRingSection(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Card(
          margin: EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 0).r,
          color: FitTheme.secondbackGround,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(20).r,
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: 480.h,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => context.go('/goal-setting'),
                      child: Container(
                        alignment: Alignment.center,
                        width: 290.r,
                        height: 290.r,
                        child: _buildThreeRings(ref),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 10).r,
                      width: 180.r,
                      height: 300.r,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRingLabel(ref, 0),
                          _buildRingLabel(ref, 1),
                          _buildRingLabel(ref, 2),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () => context.push('/record-main'),
                  child: _buildStepBar(ref),
                ),
              ],
            ),
          ),
        ),
        Positioned(child: _buildCharacterImage(ref)),
      ],
    );
  }

  Widget _buildCharacterImage(WidgetRef ref) {
    final state = ref.watch(homeProvider);
    const characters = [
      'xinxin',
      'rubby',
      'cat',
      'boxing',
      'dog',
      'jack',
      'carol',
    ];
    final character = characters[state.selectedCharacterIndex.clamp(0, 6)];
    final frameIndex = state.animationIndex;
    return SizedBox(
      height: 460.h,
      width: MediaQuery.of(ref.context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => ref.read(homeProvider.notifier).touchCharacter(),
                child: ExtendedImage.asset(
                  'images/newUIScreen/HomePageAnimation/$character/$frameIndex.png',
                  repeat: ImageRepeat.noRepeat,
                  fit: BoxFit.fitHeight,
                  height: 390.h,
                  gaplessPlayback: true,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => ref.context.go('/goal-setting'),
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildRingLabel(WidgetRef ref, int index) {
    final notifier = ref.read(homeProvider.notifier);
    final l10n = AppLocalizations.of(ref.context)!;
    final label = _ringLabels[index] == 'timeMin'
        ? l10n.timeMin
        : _ringLabels[index] == 'met'
        ? l10n.met
        : l10n.kcal;
    return Container(
      alignment: Alignment.center,
      width: 155.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                letterSpacing: 0.5,
                color: FitTheme.textColor,
                fontSize: 25.sp,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 2).r,
            width: 135.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: _ringColors[index],
              borderRadius: BorderRadius.circular(5).r,
            ),
          ),
          Text(
            notifier.mainDataShow(index),
            style: TextStyle(
              fontSize: 35.sp,
              height: 1,
              color: FitTheme.textColor,
              fontFamily: AppFonts.bebas,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeRings(WidgetRef ref) {
    final m = ref.watch(homeProvider).mainData;
    final outColor = m.triCycleDuration / m.goalDuration / 60 > 1
        ? FitTheme.threeRingsColorbackGroundOutSide2
        : FitTheme.threeRingsColorbackGroundOutSide;
    final midColor = m.triCycleStrength / m.goalStrength > 1
        ? FitTheme.threeRingsColorbackGroundMiddle2
        : FitTheme.threeRingsColorbackGroundMiddle;
    final inColor = m.triCycleCalorie / m.goalCalorie > 1
        ? FitTheme.threeRingsColorbackGroundInSide2
        : FitTheme.threeRingsColorbackGroundInSide;
    final outStep =
        ((m.triCycleDuration / m.goalDuration / 60) * 100).round() % 101;
    final midStep = ((m.triCycleStrength / m.goalStrength) * 100).round() % 101;
    final inStep =
        ((m.triCycleCalorie / m.goalCalorie) * 100).round() % 101 % 100;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 400.r,
          width: 110.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'images/newUIScreen/icons/icon_mainCardK.png',
                color: FitTheme.textColor,
                height: 30.r,
                width: 30.r,
              ),
              SizedBox(height: 2),
              Image.asset(
                'images/newUIScreen/icons/icon_mainCardP.png',
                color: FitTheme.textColor,
                height: 30.r,
                width: 30.r,
              ),
              SizedBox(height: 2),
              Image.asset(
                'images/newUIScreen/icons/icon_mainCardT.png',
                color: FitTheme.textColor,
                height: 30.r,
                width: 30.r,
              ),
            ],
          ),
        ),
        CircularStepProgressIndicator(
          totalSteps: 111,
          currentStep: 100,
          stepSize: 30.r,
          startingAngle: -3.14 * 0.9,
          selectedColor: outColor,
          unselectedColor: Colors.transparent,
          padding: 0,
          width: 400.r,
          height: 400.r,
          selectedStepSize: 30.r,
          roundedCap: (_, _) => true,
          child: CircularStepProgressIndicator(
            totalSteps: 115,
            currentStep: 100,
            stepSize: 30.r,
            startingAngle: -3.14 * 0.87,
            selectedColor: midColor,
            unselectedColor: Colors.transparent,
            padding: 0,
            selectedStepSize: 30.r,
            roundedCap: (_, _) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 125,
              currentStep: 100,
              stepSize: 30.r,
              startingAngle: -3.14 * 0.8,
              selectedColor: inColor,
              unselectedColor: Colors.transparent,
              padding: 0,
              selectedStepSize: 30.r,
              roundedCap: (_, _) => true,
            ),
          ),
        ),
        CircularStepProgressIndicator(
          totalSteps: 111,
          currentStep: outStep,
          stepSize: 30.r,
          startingAngle: -3.14 * 0.9,
          selectedColor: FitTheme.threeRingsColorOutSide,
          unselectedColor: Colors.transparent,
          padding: 0,
          width: 400.r,
          height: 400.r,
          selectedStepSize: 30.r,
          circularDirection: CircularDirection.clockwise,
          roundedCap: (_, _) => true,
          child: CircularStepProgressIndicator(
            totalSteps: 115,
            currentStep: midStep,
            stepSize: 30.r,
            startingAngle: -3.14 * 0.87,
            selectedColor: FitTheme.threeRingsColorMiddle,
            unselectedColor: Colors.transparent,
            padding: 0,
            selectedStepSize: 30.r,
            roundedCap: (_, _) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 125,
              currentStep: inStep,
              stepSize: 30.r,
              startingAngle: -3.14 * 0.8,
              selectedColor: FitTheme.threeRingsColorInSide,
              unselectedColor: Colors.transparent,
              padding: 0,
              selectedStepSize: 30.r,
              roundedCap: (_, _) => true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepBar(WidgetRef ref) {
    final notifier = ref.read(homeProvider.notifier);
    final l10n = AppLocalizations.of(ref.context)!;
    return Container(
      decoration: BoxDecoration(
        color: FitTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      height: 70.h,
      width: 660.w,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 15).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5).r,
            width: 35.r,
            height: 35.r,
            child: ExtendedImage.asset('images/newUIScreen/footSetp.png'),
          ),
          Text(
            l10n.calorieConsumptionToday,
            style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, left: 10).r,
            child: Text(
              notifier.mainDataShow(2),
              style: TextStyle(
                height: 0.5,
                fontSize: 35.sp,
                color: FitTheme.textColor,
                fontFamily: AppFonts.bebas,
              ),
            ),
          ),
          Text(
            ' ${l10n.kcal}',
            style: TextStyle(
              fontSize: 25.sp,
              color: FitTheme.textColor,
              fontFamily: AppFonts.hofontmedium,
            ),
          ),
        ],
      ),
    );
  }

  // ---- 5 大设备入口 ----
  Widget _buildDeviceEntries(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: FitTheme.secondbackGround,
      margin: EdgeInsets.only(top: 25, left: 25, right: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) => _deviceEntry(context, l10n, i)),
        ),
      ),
    );
  }

  Widget _deviceEntry(BuildContext context, AppLocalizations l10n, int index) {
    final label = _deviceEntryKeys[index] == 'spinBike'
        ? l10n.spinBike
        : _deviceEntryKeys[index] == 'treadmillMachine'
        ? l10n.treadmillMachine
        : _deviceEntryKeys[index] == 'ellipticalMachine'
        ? l10n.ellipticalMachine
        : _deviceEntryKeys[index] == 'rowingMachine'
        ? l10n.rowingMachine
        : _deviceEntryKeys[index] == 'strengthStation'
        ? l10n.strengthStation
        : l10n.game;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        print(
          '[HomeTab] navigate to /big-device-entry, deviceCategoryIndex=$index',
        );
        context.push(
          '/big-device-entry',
          extra: {'deviceCategoryIndex': index},
        );
      },
      child: SizedBox(
        width: 130.w,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20).r,
              height: 60.h,
              width: 60.w,
              child: Image.asset(_deviceEntryImages[index]),
            ),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5,
                color: FitTheme.textColor,
                fontFamily: AppFonts.hofontregular,
                fontSize: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 功能入口 ----
  List<HomeFuncEntryConfig> _getEnabledFuncEntries() {
    return _funcEntryConfigs.where((e) => e.isEnabled).toList();
  }

  Widget _buildFuncEntries(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final entries = _getEnabledFuncEntries();
    return Card(
      color: FitTheme.secondbackGround,
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: entries
              .map((config) => _funcEntry(context, ref, l10n, config))
              .toList(),
        ),
      ),
    );
  }

  Widget _funcEntry(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    HomeFuncEntryConfig config,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (config.tabIndex != null) {
          ref.read(homeProvider.notifier).changePage(config.tabIndex!);
        } else if (config.route != null) {
          context.push(config.route!);
        }
      },
      child: SizedBox(
        width: 130.w,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20).r,
              height: 60.h,
              width: 60.w,
              child: Image.asset(
                config.imagePath,
                color: FitTheme.buttonColor,
              ),
            ),
            Text(
              config.labelBuilder(l10n),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5,
                color: FitTheme.textColor,
                fontFamily: AppFonts.hofontregular,
                fontSize: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- BMI 卡 ----
  Widget _buildBmiCard(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(homeProvider.notifier);
    final bmiIdx = notifier.bmiIndex();
    final weightLabels = [
      l10n.underWeight,
      l10n.normalWeight,
      l10n.overWeight,
      l10n.obesity,
    ];
    final bmiDescs = [
      l10n.bmiLowWeight,
      l10n.bmiNormalRange,
      l10n.bmiOverweight,
      l10n.bmiObese,
    ];
    return Card(
      color: FitTheme.secondbackGround,
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "BMI",
                style: TextStyle(
                  height: 1,
                  fontSize: 30.sp,
                  color: FitTheme.textColor,
                ),
              ),
            ),
            _buildBmiMiddle(context, ref, bmiIdx, weightLabels),
            if (notifier.isCn)
              Container(
                margin: EdgeInsets.only(top: 10).r,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${l10n.physicalFitnessAssessment} ${bmiDescs[bmiIdx]}',
                  maxLines: 2,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 25.sp,
                    height: 1.5,
                    fontFamily: AppFonts.hofontregular,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiMiddle(
    BuildContext context,
    WidgetRef ref,
    int bmiIdx,
    List<String> weightLabels,
  ) {
    final state = ref.watch(homeProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20).r,
            width: 250.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10).r,
                  child: Text(
                    state.mainData.bodyBmi.toStringAsFixed(1),
                    style: TextStyle(
                      height: 1,
                      color: _ringColors[bmiIdx],
                      fontSize: 55.sp,
                      fontFamily: AppFonts.bebas,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _ringColors[bmiIdx],
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    margin: EdgeInsets.only(top: 10, left: 10).r,
                    height: 40.h,
                    width: 140.w,
                    alignment: Alignment.center,
                    child: Text(
                      weightLabels[bmiIdx],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontFamily: AppFonts.hofontregular,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 400.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 80.w),
                    Text(
                      '18.5',
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: FitTheme.textColor,
                      ),
                    ),
                    SizedBox(width: 70.w),
                    Text(
                      '25',
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: FitTheme.textColor,
                      ),
                    ),
                    SizedBox(width: 70.w),
                    Text(
                      '30',
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: FitTheme.textColor,
                      ),
                    ),
                  ],
                ),
                Image.asset('images/newUIScreen/mian_bar_BMI.png'),
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    _bmiLabel(weightLabels[0]),
                    SizedBox(width: 20.w),
                    _bmiLabel(weightLabels[1]),
                    SizedBox(width: 30.w),
                    _bmiLabel(weightLabels[2]),
                    SizedBox(width: 20.w),
                    _bmiLabel(weightLabels[3]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bmiLabel(String text) {
    return Container(
      alignment: Alignment.center,
      width: 80.w,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(
          fontSize: FitTheme.fonSizeSmall,
          color: FitTheme.textColor,
        ),
      ),
    );
  }

  // ---- 卡片网格 ----
  List<HomeGridCardConfig> _getEnabledGridCards(bool isCn) {
    return _gridCardConfigs.where((config) {
      if (!config.isEnabled) return false;
      if (isCn && config.isNotCnOnly) return false;
      if (!isCn && config.isCnOnly) return false;
      return true;
    }).toList();
  }

  Widget _buildCardGrid(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeProvider.notifier);
    final isCn = notifier.isCn;
    final cards = _getEnabledGridCards(isCn);
    return Container(
      margin: EdgeInsets.only(left: 25, bottom: 20, right: 25).r,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 25.r,
        runSpacing: 25.r,
        children: cards
            .map((config) => _buildGridCard(context, ref, config, isCn))
            .toList(),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    WidgetRef ref,
    HomeGridCardConfig config,
    bool isCn,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(homeProvider);

    // textStatus 类型使用较短高度
    final isTextCard = config.cardType == HomeGridCardType.textStatus;

    return Card(
      margin: EdgeInsets.zero,
      color: FitTheme.secondbackGround,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.push('/placeholder'),
        child: Container(
          padding: EdgeInsets.all(20).r,
          width: MediaQuery.of(context).size.width / 2 - 40.r,
          height: isTextCard ? 355.h : 370.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              SizedBox(
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        config.titleBuilder(l10n),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: FitTheme.textColor,
                          fontFamily: AppFonts.hofontmedium,
                        ),
                      ),
                    ),
                    // 数字卡(index 0-3 对应 key 以 exerciseRecord/burnRank 等)不显示箭头
                    if (config.key != 'todaysBurn' && config.key != 'kcalCons')
                      Container(
                        padding: EdgeInsets.only(bottom: 5).r,
                        height: 30.r,
                        width: 30.r,
                        child: Image.asset(
                          'images/newUIScreen/icons/icon_homepage_entry.png',
                        ),
                      ),
                  ],
                ),
              ),
              // 内容区
              Expanded(
                child: _buildCardContent(context, ref, l10n, config, isCn),
              ),
              // 卡片图片
              Container(
                height: 160.r,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: Image.asset(config.imagePath, fit: BoxFit.fill),
              ),
              // 日期
              Text(
                state.mainData.recordDate,
                style: TextStyle(
                  fontSize: 25.sp,
                  color: FitTheme.textColor,
                  height: 1,
                  fontFamily: AppFonts.hofontregular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 卡片内容区:文字卡 / 纯单位卡 / 数字+单位卡。
  Widget _buildCardContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    HomeGridCardConfig config,
    bool isCn,
  ) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    switch (config.cardType) {
      case HomeGridCardType.textStatus:
        return _buildTextStatusCard(config.key, state, l10n);

      case HomeGridCardType.unitOnly:
        final unit = config.unitBuilder?.call(l10n) ?? '';
        return Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 10, bottom: 20).r,
          child: Text(
            unit,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 25.sp,
              height: 1,
            ),
          ),
        );

      case HomeGridCardType.numberAndUnit:
        final value = notifier.cardDataValueByKey(config.key);
        final unit = config.unitBuilder?.call(l10n) ?? '';
        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 20).r,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    letterSpacing: 0,
                    color: FitTheme.textColor,
                    fontSize: 50.sp,
                    fontFamily: AppFonts.bebas,
                    height: 1,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10).r,
                alignment: Alignment.bottomLeft,
                child: Text(
                  unit,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 25.sp,
                    height: 0.8,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  /// 文字状态卡 (打卡 / AI 报告)
  Widget _buildTextStatusCard(String key, HomeState state, AppLocalizations l10n) {
    if (key == 'checkInTask' || key == 'dailyTask') {
      final text = state.isReached ? l10n.achieved : l10n.unachieved;
      final color = state.isReached
          ? Colors.green
          : const Color.fromARGB(255, 221, 62, 44);
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: 10).r,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            letterSpacing: 0,
            color: color,
            fontSize: 25.sp,
            fontFamily: AppFonts.hofontmedium,
            height: 1,
          ),
        ),
      );
    }

    if (key == 'aiPt') {
      final text = state.hasAiReport ? l10n.customized : l10n.unsatisfactory;
      final color = state.hasAiReport
          ? FitTheme.textColor
          : const Color.fromARGB(255, 221, 62, 44);
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: 10).r,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            letterSpacing: 0,
            color: color,
            fontSize: 25.sp,
            fontFamily: AppFonts.hofontmedium,
            height: 1,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
