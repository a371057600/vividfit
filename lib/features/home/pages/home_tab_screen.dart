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

/// 主页主屏(1:1 复刻旧 NewMainSportScreen)。
class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  static const _ringLabels = ['timeMin', 'met', 'kcal'];
  static const _ringColors = [
    Color.fromARGB(255, 6, 249, 223),
    Color.fromARGB(255, 48, 244, 0),
    Color.fromARGB(255, 255, 168, 0),
    Color.fromARGB(255, 230, 51, 16),
  ];
  static const _funcEntryKeys = ['courses', 'ranks', 'daily', 'fitnessAi', 'medal', 'game', 'game'];
  static const _funcEntryImages = [
    'images/newUIScreen/icons/icon_second_button3.png',
    'images/newUIScreen/icons/icon_second_button0.png',
    'images/newUIScreen/icons/icon_second_button4.png',
    'images/newUIScreen/icons/icon_second_button2.png',
    'images/newUIScreen/icons/icon_second_button1.png',
    'images/newUIScreen/icons/icon_game.png',
  ];
  static const _deviceEntryKeys = [
    'spinBike', 'treadmillMachine', 'ellipticalMachine',
    'rowingMachine', 'strengthStation', 'game', 'game'
  ];
  static const _deviceEntryImages = [
    'images/newUIScreen/HomePageAnimation/other/icon_bike.png',
    'images/newUIScreen/HomePageAnimation/other/icon_run_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_run_elliptical_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_rowing_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_power_station.png',
    'images/newUIScreen/icons/icon_game.png',
  ];

  // CN 卡片图片(10 张)
  static const _gridCardImagesCn = [
    'images/newUIScreen/icons/icon_home_page0.png',
    'images/newUIScreen/icons/icon_home_page1.png',
    'images/newUIScreen/icons/icon_home_page2.png',
    'images/newUIScreen/icons/icon_home_page3.png',
    'images/newUIScreen/icons/icon_home_page4.png',
    'images/newUIScreen/icons/icon_home_page5.png',
    'images/newUIScreen/icons/icon_home_page6.png',
    'images/newUIScreen/icons/icon_home_page7.png',
    'images/newUIScreen/icons/icon_home_page8.png',
    'images/newUIScreen/icons/icon_home_page9.png',
    'images/newUIScreen/icons/icon_home_page6.png',
  ];
  // 非简中卡片图片(8 张)
  static const _gridCardImagesNotCn = [
    'images/newUIScreen/icons/icon_home_page0.png',
    'images/newUIScreen/icons/icon_home_page1.png',
    'images/newUIScreen/icons/icon_home_page2.png',
    'images/newUIScreen/icons/icon_home_page3.png',
    'images/newUIScreen/icons/icon_home_page4.png',
    'images/newUIScreen/icons/icon_home_page7.png',
    'images/newUIScreen/icons/icon_home_page8.png',
    'images/newUIScreen/icons/icon_home_page9.png',
    'images/newUIScreen/icons/icon_home_page6.png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
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
                  onTap: () => context.push('/placeholder'),
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
    final state = ref.watch(homeNotifierProvider);
    const characters = ['xinxin', 'rubby', 'cat', 'boxing', 'dog', 'jack', 'carol'];
    final character = characters[state.selectedCharacterIndex.clamp(0, 6)];
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
                onTap: () => ref.read(homeNotifierProvider.notifier).touchCharacter(),
                child: ExtendedImage.asset(
                  'images/newUIScreen/HomePageAnimation/$character/1.png',
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
    final notifier = ref.read(homeNotifierProvider.notifier);
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
    final m = ref.watch(homeNotifierProvider).mainData;
    final outColor = m.triCycleDuration / m.goalDuration / 60 > 1
        ? FitTheme.threeRingsColorbackGroundOutSide2
        : FitTheme.threeRingsColorbackGroundOutSide;
    final midColor = m.triCycleStrength / m.goalStrength > 1
        ? FitTheme.threeRingsColorbackGroundMiddle2
        : FitTheme.threeRingsColorbackGroundMiddle;
    final inColor = m.triCycleCalorie / m.goalCalorie > 1
        ? FitTheme.threeRingsColorbackGroundInSide2
        : FitTheme.threeRingsColorbackGroundInSide;
    final outStep = ((m.triCycleDuration / m.goalDuration / 60) * 100).round() % 101;
    final midStep = ((m.triCycleStrength / m.goalStrength) * 100).round() % 101;
    final inStep = ((m.triCycleCalorie / m.goalCalorie) * 100).round() % 101 % 100;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 400.r,
          width: 110.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset('images/newUIScreen/icons/icon_mainCardK.png',
                  color: FitTheme.textColor, height: 30.r, width: 30.r),
              SizedBox(height: 2),
              Image.asset('images/newUIScreen/icons/icon_mainCardP.png',
                  color: FitTheme.textColor, height: 30.r, width: 30.r),
              SizedBox(height: 2),
              Image.asset('images/newUIScreen/icons/icon_mainCardT.png',
                  color: FitTheme.textColor, height: 30.r, width: 30.r),
            ],
          ),
        ),
        CircularStepProgressIndicator(
          totalSteps: 111, currentStep: 100, stepSize: 30.r,
          startingAngle: -3.14 * 0.9, selectedColor: outColor,
          unselectedColor: Colors.transparent, padding: 0,
          width: 400.r, height: 400.r, selectedStepSize: 30.r,
          roundedCap: (_, __) => true,
          child: CircularStepProgressIndicator(
            totalSteps: 115, currentStep: 100, stepSize: 30.r,
            startingAngle: -3.14 * 0.87, selectedColor: midColor,
            unselectedColor: Colors.transparent, padding: 0,
            selectedStepSize: 30.r, roundedCap: (_, __) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 125, currentStep: 100, stepSize: 30.r,
              startingAngle: -3.14 * 0.8, selectedColor: inColor,
              unselectedColor: Colors.transparent, padding: 0,
              selectedStepSize: 30.r, roundedCap: (_, __) => true,
            ),
          ),
        ),
        CircularStepProgressIndicator(
          totalSteps: 111, currentStep: outStep, stepSize: 30.r,
          startingAngle: -3.14 * 0.9, selectedColor: FitTheme.threeRingsColorOutSide,
          unselectedColor: Colors.transparent, padding: 0,
          width: 400.r, height: 400.r, selectedStepSize: 30.r,
          circularDirection: CircularDirection.clockwise, roundedCap: (_, __) => true,
          child: CircularStepProgressIndicator(
            totalSteps: 115, currentStep: midStep, stepSize: 30.r,
            startingAngle: -3.14 * 0.87, selectedColor: FitTheme.threeRingsColorMiddle,
            unselectedColor: Colors.transparent, padding: 0,
            selectedStepSize: 30.r, roundedCap: (_, __) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 125, currentStep: inStep, stepSize: 30.r,
              startingAngle: -3.14 * 0.8, selectedColor: FitTheme.threeRingsColorInSide,
              unselectedColor: Colors.transparent, padding: 0,
              selectedStepSize: 30.r, roundedCap: (_, __) => true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepBar(WidgetRef ref) {
    final notifier = ref.read(homeNotifierProvider.notifier);
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
          Text(l10n.calorieConsumptionToday,
              style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp)),
          Container(
            margin: EdgeInsets.only(bottom: 10, left: 10).r,
            child: Text(
              notifier.mainDataShow(2),
              style: TextStyle(
                height: 0.5, fontSize: 35.sp,
                color: FitTheme.textColor, fontFamily: AppFonts.bebas,
              ),
            ),
          ),
          Text(' ${l10n.kcal}',
              style: TextStyle(
                fontSize: 25.sp, color: FitTheme.textColor,
                fontFamily: AppFonts.hofontmedium,
              )),
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
      onTap: () => context.push('/placeholder'),
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
              maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5, color: FitTheme.textColor,
                fontFamily: AppFonts.hofontregular, fontSize: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 5 功能入口 ----
  Widget _buildFuncEntries(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final order = [5, 3, 1, 2, 4];
    return Card(
      color: FitTheme.secondbackGround,
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: order.map((i) => _funcEntry(context, l10n, i)).toList(),
        ),
      ),
    );
  }

  Widget _funcEntry(BuildContext context, AppLocalizations l10n, int index) {
    final label = _funcEntryKeys[index] == 'courses'
        ? l10n.courses
        : _funcEntryKeys[index] == 'ranks'
            ? l10n.ranks
            : _funcEntryKeys[index] == 'daily'
                ? l10n.daily
                : _funcEntryKeys[index] == 'fitnessAi'
                    ? l10n.fitnessAi
                    : _funcEntryKeys[index] == 'medal'
                        ? l10n.medal
                        : l10n.game;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.push('/placeholder'),
      child: SizedBox(
        width: 130.w,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20).r,
              height: 60.h,
              width: 60.w,
              child: Image.asset(_funcEntryImages[index], color: FitTheme.buttonColor),
            ),
            Text(
              label,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5, color: FitTheme.textColor,
                fontFamily: AppFonts.hofontregular, fontSize: 25.sp,
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
    final notifier = ref.read(homeNotifierProvider.notifier);
    final bmiIdx = notifier.bmiIndex();
    final weightLabels = [l10n.underWeight, l10n.normalWeight, l10n.overWeight, l10n.obesity];
    final bmiDescs = [l10n.bmiLowWeight, l10n.bmiNormalRange, l10n.bmiOverweight, l10n.bmiObese];
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
              child: Text(l10n.bodyMassIndexColon,
                  style: TextStyle(height: 1, fontSize: 30.sp, color: FitTheme.textColor)),
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
                    color: FitTheme.textColor, fontSize: 25.sp,
                    height: 1.5, fontFamily: AppFonts.hofontregular,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiMiddle(BuildContext context, WidgetRef ref, int bmiIdx, List<String> weightLabels) {
    final state = ref.watch(homeNotifierProvider);
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
                      height: 1, color: _ringColors[bmiIdx],
                      fontSize: 60.sp, fontFamily: AppFonts.bebas,
                    ),
                  ),
                ),
                Container(
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
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black, fontSize: 15.sp,
                      fontFamily: AppFonts.hofontregular,
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
                    Text('18.5', style: TextStyle(fontSize: 24.sp, color: FitTheme.textColor)),
                    SizedBox(width: 70.w),
                    Text('25', style: TextStyle(fontSize: 24.sp, color: FitTheme.textColor)),
                    SizedBox(width: 70.w),
                    Text('30', style: TextStyle(fontSize: 24.sp, color: FitTheme.textColor)),
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
        style: TextStyle(fontSize: FitTheme.fonSizeSmall, color: FitTheme.textColor),
      ),
    );
  }

  // ---- 卡片网格 ----
  Widget _buildCardGrid(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeNotifierProvider.notifier);
    final count = notifier.isCn ? 10 : 8;
    return Container(
      margin: EdgeInsets.only(left: 25, bottom: 20, right: 25).r,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 25.r,
        runSpacing: 25.r,
        children: List.generate(count, (i) => _buildGridCard(context, ref, i)),
      ),
    );
  }

  /// 获取卡片名称(基于 l10n)。
  String _gridCardName(AppLocalizations l10n, int index, bool isCn) {
    final cnKeys = [
      l10n.exerciseRecord, l10n.bodyData, l10n.burnRank, l10n.todaysBurn,
      l10n.checkInTask, l10n.aiPt, l10n.onlineStore, l10n.sportsGoal,
      l10n.sportsReport, l10n.onlineManual
    ];
    final notCnKeys = [
      l10n.exerciseRecord, l10n.bodyMassIndex, l10n.ranks, l10n.kcalCons,
      l10n.dailyTask, l10n.fitnessGoals, l10n.sportsReport, l10n.deviceManual
    ];
    final list = isCn ? cnKeys : notCnKeys;
    return list[index % list.length];
  }

  /// 获取卡片单位(基于 l10n)。
  String _gridCardUnit(AppLocalizations l10n, int index, bool isCn) {
    switch (index) {
      case 0:
        return l10n.times;
      case 1:
        return isCn ? l10n.bmi : '';
      case 2:
        return isCn ? l10n.rankUnit : '';
      case 3:
        return l10n.kcal;
      case 5:
        return isCn ? '' : l10n.goalSetting;
      case 6:
        return isCn ? l10n.jdShopping : l10n.annualSportsReview;
      case 7:
        return isCn ? l10n.reasonableGoalSetting : l10n.manualDownload;
      case 8:
        return isCn ? l10n.annualSportsSummary : '';
      case 9:
        return isCn ? l10n.manualDownload : '';
      default:
        return '';
    }
  }

  Widget _buildGridCard(BuildContext context, WidgetRef ref, int index) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    final isCn = notifier.isCn;
    final cardName = _gridCardName(l10n, index, isCn);
    final img = isCn ? _gridCardImagesCn : _gridCardImagesNotCn;

    // 文字卡(index 4/5)高度 355,其余 370
    final isTextCard = index == 4 || (index == 5 && isCn);

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
                        cardName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30.sp, color: FitTheme.textColor,
                          fontFamily: AppFonts.hofontmedium,
                        ),
                      ),
                    ),
                    if (index != 3)
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
              // 内容区:3 种类型
              Expanded(
                child: _buildCardContent(context, ref, l10n, index, isCn),
              ),
              // 卡片图片
              Container(
                height: 160.r,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: Image.asset(img[index % img.length], fit: BoxFit.fill),
              ),
              // 日期
              Text(
                state.mainData.recordDate,
                style: TextStyle(
                  fontSize: 25.sp, color: FitTheme.textColor,
                  height: 1, fontFamily: AppFonts.hofontregular,
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
    BuildContext context, WidgetRef ref, AppLocalizations l10n,
    int index, bool isCn,
  ) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    // index 4:打卡 — 文字 "已达成/未达成",25sp,红/绿色
    if (index == 4) {
      final text = state.isReached ? l10n.achieved : l10n.unachieved;
      final color = state.isReached ? Colors.green : const Color.fromARGB(255, 221, 62, 44);
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: 10).r,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            letterSpacing: 0, color: color,
            fontSize: 25.sp, fontFamily: AppFonts.hofontmedium, height: 1,
          ),
        ),
      );
    }

    // index 5(CN):AI私教 — 文字 "已定制/未定制",25sp
    if (index == 5 && isCn) {
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
            letterSpacing: 0, color: color,
            fontSize: 25.sp, fontFamily: AppFonts.hofontmedium, height: 1,
          ),
        ),
      );
    }

    // index > 5:纯单位文字卡(无数值),25sp,topLeft 对齐
    if (index > 5) {
      final unit = _gridCardUnit(l10n, index, isCn);
      return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 10, bottom: 20).r,
        child: Text(
          unit,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: FitTheme.textColor, fontSize: 25.sp, height: 1,
          ),
        ),
      );
    }

    // 默认:数字 + 单位(0,1,2,3)
    final value = notifier.cardDataValue(index);
    final unit = _gridCardUnit(l10n, index, isCn);
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
                letterSpacing: 0, color: FitTheme.textColor,
                fontSize: 50.sp, fontFamily: AppFonts.bebas, height: 1,
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
                color: FitTheme.textColor, fontSize: 25.sp, height: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
