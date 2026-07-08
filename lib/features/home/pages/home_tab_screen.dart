import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/home_providers.dart';

/// 主页主屏(1:1 复刻旧 NewMainSportScreen)。
///
/// UI 结构:
/// RefreshIndicator > SingleChildScrollView > Column[
///   _sportStatusDisplay2 (三环 + 动画人物 + 时长/MET/Kcal),
///   _buildCourseBigDevice (5 大设备入口),
///   _buildCourseEntry (5 功能入口:课程/排行/打卡/AI/勋章),
///   _buildNotificationWidget (BMI 卡),
///   _cardListEntryWidget (10 卡片网格),
/// ]
class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  // 卡片名(简中)
  static const _cardNameCn = [
    'Exercise Record', 'Body Data', 'Burn Rank', "Today's Burn",
    'Check-in Task', 'AI PT', '线上商城', '运动目标',
    'Sports Report', '线上说明',
  ];
  // 卡片名(非简中)
  static const _cardNameNotCn = [
    'Exercise Record', 'Body Mass Index', 'Ranks', 'Kcal cons',
    'Daily Task', 'Fitness Goals', 'Sports Report', 'Device Manual',
  ];
  static const _cardImageCn = [
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
  static const _cardImageNotCn = [
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

  static const _textTitle = ['Time/Min', 'MET', 'Kcal'];
  static const _colors = [
    Color.fromARGB(255, 6, 249, 223),
    Color.fromARGB(255, 48, 244, 0),
    Color.fromARGB(255, 255, 168, 0),
    Color.fromARGB(255, 230, 51, 16),
  ];
  static const _weightLeave = ['Under Weight', 'Normal Weight', 'Over Weight', 'Obesity'];
  static const _bmiLeave = [
    'Low body weight, may pose health risks such as malnutrition',
    'Normal range, indicating good physical condition',
    'Overweight, pay attention to diet and exercise',
    'Obese body type, with risk of chronic diseases',
  ];

  static const _courseEntryText = ['Courses', 'Ranks', 'Daily', 'Fitness AI', 'Medal', 'Game', 'Game'];
  static const _courseEntryImage = [
    'images/newUIScreen/icons/icon_second_button3.png',
    'images/newUIScreen/icons/icon_second_button0.png',
    'images/newUIScreen/icons/icon_second_button4.png',
    'images/newUIScreen/icons/icon_second_button2.png',
    'images/newUIScreen/icons/icon_second_button1.png',
    'images/newUIScreen/icons/icon_game.png',
  ];
  static const _courseEntryText2 = [
    'Spin Bike', 'Treadmill Machine', 'Elliptical Machine',
    'Rowing Machine', 'Strength Station', 'Game', 'Game',
  ];
  static const _courseEntryImage2 = [
    'images/newUIScreen/HomePageAnimation/other/icon_bike.png',
    'images/newUIScreen/HomePageAnimation/other/icon_run_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_run_elliptical_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_rowing_machine.png',
    'images/newUIScreen/HomePageAnimation/other/icon_power_station.png',
    'images/newUIScreen/icons/icon_game.png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    final isCn = state.selectedCharacterIndex >= 0; // 始终用 mainData.languageNum 判断更准,这里简化
    return Scaffold(
      backgroundColor: ThemChange.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSportStatusDisplay2(context, ref),
              _buildCourseBigDevice(context),
              _buildCourseEntry(context, ref),
              _buildNotificationWidget(context, ref),
              _cardListEntryWidget(context, ref),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ---- 三环 + 动画人物 ----
  Widget _buildSportStatusDisplay2(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Card(
          margin: EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 0).r,
          color: ThemChange.secondbackGround,
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
                        child: _buildThreeCircular(ref),
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
                          _buildSingleText(ref, 0),
                          _buildSingleText(ref, 1),
                          _buildSingleText(ref, 2),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () => context.go('/placeholder'),
                  child: _buildFootStepData(ref),
                ),
              ],
            ),
          ),
        ),
        Positioned(child: _buildAnimationImage(ref)),
      ],
    );
  }

  Widget _buildAnimationImage(WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final characters = ['xinxin', 'rubby', 'cat', 'boxing', 'dog', 'jack', 'carol'];
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

  Widget _buildSingleText(WidgetRef ref, int index) {
    final notifier = ref.read(homeNotifierProvider.notifier);
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
              _textTitle[index],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                letterSpacing: 0.5,
                color: ThemChange.textColor,
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
              color: _colors[index],
              borderRadius: BorderRadius.circular(5).r,
            ),
          ),
          Text(
            notifier.mainDataShow(index),
            style: TextStyle(
              fontSize: 35.sp,
              height: 1,
              color: ThemChange.textColor,
              fontFamily: AppFonts.bebas,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeCircular(WidgetRef ref) {
    final m = ref.watch(homeNotifierProvider).mainData;
    final outColor = m.triCycleDuration / m.goalDuration / 60 > 1
        ? ThemChange.threeRingsColorbackGroundOutSide2
        : ThemChange.threeRingsColorbackGroundOutSide;
    final midColor = m.triCycleStrength / m.goalStrength > 1
        ? ThemChange.threeRingsColorbackGroundMiddle2
        : ThemChange.threeRingsColorbackGroundMiddle;
    final inColor = m.triCycleCalorie / m.goalCalorie > 1
        ? ThemChange.threeRingsColorbackGroundInSide2
        : ThemChange.threeRingsColorbackGroundInSide;
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
                  color: ThemChange.textColor, height: 30.r, width: 30.r),
              SizedBox(height: 2),
              Image.asset('images/newUIScreen/icons/icon_mainCardP.png',
                  color: ThemChange.textColor, height: 30.r, width: 30.r),
              SizedBox(height: 2),
              Image.asset('images/newUIScreen/icons/icon_mainCardT.png',
                  color: ThemChange.textColor, height: 30.r, width: 30.r),
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
          startingAngle: -3.14 * 0.9, selectedColor: ThemChange.threeRingsColorOutSide,
          unselectedColor: Colors.transparent, padding: 0,
          width: 400.r, height: 400.r, selectedStepSize: 30.r,
          circularDirection: CircularDirection.clockwise,
          roundedCap: (_, __) => true,
          child: CircularStepProgressIndicator(
            totalSteps: 115, currentStep: midStep, stepSize: 30.r,
            startingAngle: -3.14 * 0.87, selectedColor: ThemChange.threeRingsColorMiddle,
            unselectedColor: Colors.transparent, padding: 0,
            selectedStepSize: 30.r, roundedCap: (_, __) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 125, currentStep: inStep, stepSize: 30.r,
              startingAngle: -3.14 * 0.8, selectedColor: ThemChange.threeRingsColorInSide,
              unselectedColor: Colors.transparent, padding: 0,
              selectedStepSize: 30.r, roundedCap: (_, __) => true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFootStepData(WidgetRef ref) {
    final notifier = ref.read(homeNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: ThemChange.backgroundColor,
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
            width: 35.r, height: 35.r,
            child: ExtendedImage.asset('images/newUIScreen/footSetp.png'),
          ),
          Text('The calorie consumption today is ',
              style: TextStyle(color: ThemChange.textColor, fontSize: 25.sp)),
          Container(
            margin: EdgeInsets.only(bottom: 10, left: 10).r,
            child: Text(
              notifier.mainDataShow(2),
              style: TextStyle(
                height: 0.5, fontSize: 35.sp,
                color: ThemChange.textColor, fontFamily: AppFonts.bebas,
              ),
            ),
          ),
          Text(' Kcal',
              style: TextStyle(
                fontSize: 25.sp, color: ThemChange.textColor,
                fontFamily: AppFonts.hofontmedium,
              )),
        ],
      ),
    );
  }

  // ---- 5 大设备入口 ----
  Widget _buildCourseBigDevice(BuildContext context) {
    return Card(
      color: ThemChange.secondbackGround,
      margin: EdgeInsets.only(top: 25, left: 25, right: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) => _singleEntry2(context, i)),
        ),
      ),
    );
  }

  Widget _singleEntry2(BuildContext context, int index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.go('/placeholder'),
      child: SizedBox(
        width: 130.w,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20).r,
              height: 60.h, width: 60.w,
              child: Image.asset(_courseEntryImage2[index]),
            ),
            Text(
              _courseEntryText2[index],
              maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5, color: ThemChange.textColor,
                fontFamily: AppFonts.hofontregular, fontSize: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 5 功能入口 ----
  Widget _buildCourseEntry(BuildContext context, WidgetRef ref) {
    final isCn = ref.watch(homeNotifierProvider).selectedCharacterIndex >= 0;
    // 旧项目:简中用 [5,3,1,2,4] 非简中用 [5,0,1,2,4]
    final order = [5, 3, 1, 2, 4];
    return Card(
      color: ThemChange.secondbackGround,
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: order.map((i) => _singleEntry(context, i)).toList(),
        ),
      ),
    );
  }

  Widget _singleEntry(BuildContext context, int index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.go('/placeholder'),
      child: SizedBox(
        width: 130.w,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20).r,
              height: 60.h, width: 60.w,
              child: Image.asset(_courseEntryImage[index],
                  color: ThemChange.buttonColor),
            ),
            Text(
              _courseEntryText[index],
              maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5, color: ThemChange.textColor,
                fontFamily: AppFonts.hofontregular, fontSize: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- BMI 卡 ----
  Widget _buildNotificationWidget(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    final bmiIdx = notifier.bmiIndex();
    return Card(
      color: ThemChange.secondbackGround,
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25).r,
      child: Container(
        padding: EdgeInsets.all(20).r,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text('Body Mass Index:',
                  style: TextStyle(
                    height: 1, fontSize: 30.sp,
                    color: ThemChange.textColor,
                  )),
            ),
            _buildMiddleContent(context, ref, bmiIdx),
            if (state.selectedCharacterIndex == 0)
              Container(
                margin: EdgeInsets.only(top: 10).r,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Physical fitness assessment: ${_bmiLeave[bmiIdx]}',
                  maxLines: 2,
                  style: TextStyle(
                    color: ThemChange.textColor, fontSize: 25.sp,
                    height: 1.5, fontFamily: AppFonts.hofontregular,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleContent(BuildContext context, WidgetRef ref, int bmiIdx) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
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
                      height: 1, color: _colors[bmiIdx],
                      fontSize: 60.sp, fontFamily: AppFonts.bebas,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _colors[bmiIdx],
                    borderRadius: BorderRadius.circular(5).r,
                  ),
                  margin: EdgeInsets.only(top: 10, left: 10).r,
                  height: 40.h, width: 140.w,
                  alignment: Alignment.center,
                  child: Text(
                    _weightLeave[bmiIdx],
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
                    Text('18.5', style: TextStyle(fontSize: 24.sp, color: ThemChange.textColor)),
                    SizedBox(width: 70.w),
                    Text('25', style: TextStyle(fontSize: 24.sp, color: ThemChange.textColor)),
                    SizedBox(width: 70.w),
                    Text('30', style: TextStyle(fontSize: 24.sp, color: ThemChange.textColor)),
                  ],
                ),
                Image.asset('images/newUIScreen/mian_bar_BMI.png'),
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    ...List.generate(4, (i) => Container(
                      alignment: Alignment.center,
                      width: 80.w,
                      margin: EdgeInsets.only(right: 20.w),
                      child: Text(_weightLeave[i],
                        textAlign: TextAlign.center, maxLines: 2,
                        style: TextStyle(
                          fontSize: ThemChange.fonSizeSmall,
                          color: ThemChange.textColor,
                        )),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- 卡片网格 ----
  Widget _cardListEntryWidget(BuildContext context, WidgetRef ref) {
    final isCn = ref.watch(homeNotifierProvider).selectedCharacterIndex == 0;
    final count = 10; // 简中 10 卡,非简中 8 卡(简化:统一 10,样式与旧项目一致)
    return Container(
      margin: EdgeInsets.only(left: 25, bottom: 20, right: 25).r,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 25.r, runSpacing: 25.r,
        children: List.generate(count, (i) => _wrapCardSingle(context, ref, i)),
      ),
    );
  }

  Widget _wrapCardSingle(BuildContext context, WidgetRef ref, int index) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    final isCn = state.selectedCharacterIndex == 0;
    final name = isCn ? _cardNameCn : _cardNameNotCn;
    final img = isCn ? _cardImageCn : _cardImageNotCn;
    return Card(
      margin: EdgeInsets.zero,
      color: ThemChange.secondbackGround,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.go('/placeholder'),
        child: Container(
          padding: EdgeInsets.all(20).r,
          width: MediaQuery.of(context).size.width / 2 - 40.r,
          height: 370.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name[index % name.length],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30.sp, color: ThemChange.textColor,
                          fontFamily: AppFonts.hofontmedium,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5).r,
                      height: 30.r, width: 30.r,
                      child: Image.asset('images/newUIScreen/icons/icon_homepage_entry.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 20).r,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        notifier.homePageWrapData(index),
                        overflow: TextOverflow.ellipsis, maxLines: 1,
                        style: TextStyle(
                          color: ThemChange.textColor, fontSize: 50.sp,
                          fontFamily: AppFonts.bebas, height: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10).r,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          notifier.homePageUnit(index),
                          style: TextStyle(
                            color: ThemChange.textColor, fontSize: 25.sp,
                            height: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 160.r,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: Image.asset(img[index % img.length], fit: BoxFit.fill),
              ),
              Text(
                state.mainData.recordDate,
                style: TextStyle(
                  fontSize: 25.sp, color: ThemChange.textColor, height: 1,
                  fontFamily: AppFonts.hofontregular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
