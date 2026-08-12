import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';

/// Record 页面专用三环进度组件。
///
/// 严格参照主页 _buildThreeRings() 的Stack三层结构实现：图标层 + 底轨层 + 进度层。
/// 颜色全部使用 FitTheme 常量，图标使用项目内asset图片。
class RecordThreeRings extends StatelessWidget {
  final double durationProgress;
  final double strengthProgress;
  final double calorieProgress;
  final String durationText;
  final String strengthText;
  final String calorieText;

  const RecordThreeRings({
    super.key,
    required this.durationProgress,
    required this.strengthProgress,
    required this.calorieProgress,
    required this.durationText,
    required this.strengthText,
    required this.calorieText,
  });

  @override
  Widget build(BuildContext context) {
    final outBgColor = durationProgress >= 1.0
        ? FitTheme.threeRingsColorbackGroundOutSide2
        : FitTheme.threeRingsColorbackGroundOutSide;
    final midBgColor = strengthProgress >= 1.0
        ? FitTheme.threeRingsColorbackGroundMiddle2
        : FitTheme.threeRingsColorbackGroundMiddle;
    final inBgColor = calorieProgress >= 1.0
        ? FitTheme.threeRingsColorbackGroundInSide2
        : FitTheme.threeRingsColorbackGroundInSide;

    final outStep = (durationProgress * 100).round().clamp(0, 100);
    final midStep = (strengthProgress * 100).round().clamp(0, 100);
    final inStep = (calorieProgress * 100).round().clamp(0, 100);

    return Container(
      height: 400.h,
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 400.r,
            height: 400.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildCenterIcons(),
                CircularStepProgressIndicator(
                  totalSteps: 111,
                  currentStep: 100,
                  stepSize: 50.r,
                  startingAngle: -3.14 * 0.9,
                  selectedColor: outBgColor,
                  unselectedColor: Colors.transparent,
                  padding: 0,
                  width: 400.r,
                  height: 400.r,
                  selectedStepSize: 50.r,
                  roundedCap: (_, _) => true,
                  child: CircularStepProgressIndicator(
                    totalSteps: 115,
                    currentStep: 100,
                    stepSize: 50.r,
                    startingAngle: -3.14 * 0.87,
                    selectedColor: midBgColor,
                    unselectedColor: Colors.transparent,
                    padding: 0,
                    selectedStepSize: 50.r,
                    roundedCap: (_, _) => true,
                    child: CircularStepProgressIndicator(
                      totalSteps: 125,
                      currentStep: 100,
                      stepSize: 50.r,
                      startingAngle: -3.14 * 0.8,
                      selectedColor: inBgColor,
                      unselectedColor: Colors.transparent,
                      padding: 0,
                      selectedStepSize: 50.r,
                      roundedCap: (_, _) => true,
                    ),
                  ),
                ),
                CircularStepProgressIndicator(
                  totalSteps: 111,
                  currentStep: outStep,
                  stepSize: 50.r,
                  startingAngle: -3.14 * 0.9,
                  selectedColor: FitTheme.threeRingsColorOutSide,
                  unselectedColor: Colors.transparent,
                  padding: 0,
                  width: 400.r,
                  height: 400.r,
                  selectedStepSize: 50.r,
                  circularDirection: CircularDirection.clockwise,
                  roundedCap: (_, _) => true,
                  child: CircularStepProgressIndicator(
                    totalSteps: 115,
                    currentStep: midStep,
                    stepSize: 50.r,
                    startingAngle: -3.14 * 0.87,
                    selectedColor: FitTheme.threeRingsColorMiddle,
                    unselectedColor: Colors.transparent,
                    padding: 0,
                    selectedStepSize: 50.r,
                    roundedCap: (_, _) => true,
                    child: CircularStepProgressIndicator(
                      totalSteps: 125,
                      currentStep: inStep,
                      stepSize: 50.r,
                      startingAngle: -3.14 * 0.8,
                      selectedColor: FitTheme.threeRingsColorInSide,
                      unselectedColor: Colors.transparent,
                      padding: 0,
                      selectedStepSize: 50.r,
                      roundedCap: (_, _) => true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          _buildLabels(),
        ],
      ),
    );
  }

  Widget _buildCenterIcons() {
    return Center(
      child: SizedBox(
        width: 50.r,
        height: 400.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/newUIScreen/icons/icon_mainCardK.png',
              color: FitTheme.textColor,
              height: 40.r,
              width: 40.r,
            ),
            SizedBox(height: 5),
            Image.asset(
              'images/newUIScreen/icons/icon_mainCardP.png',
              color: FitTheme.textColor,
              height: 40.r,
              width: 40.r,
            ),
            SizedBox(height: 5),
            Image.asset(
              'images/newUIScreen/icons/icon_mainCardT.png',
              color: FitTheme.textColor,
              height: 40.r,
              width: 40.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabels() {
    return Container(
      width: 200.w,
      height: 320.h,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelItem(
            '时长/MIN',
            durationText,
            FitTheme.threeRingsColorOutSide,
          ),
          _buildLabelItem('运动强度', strengthText, FitTheme.threeRingsColorMiddle),
          _buildLabelItem('卡路里/K', calorieText, FitTheme.threeRingsColorInSide),
        ],
      ),
    );
  }

  Widget _buildLabelItem(String title, String value, Color lineColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            letterSpacing: 0.5,
            color: FitTheme.textColor,
            fontSize: 22.sp,
            fontFamily: AppFonts.hofontmedium,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6).r,
          width: 120.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: BorderRadius.circular(2).r,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 36.sp,
            height: 1.1,
            color: FitTheme.textColor,
            fontFamily: AppFonts.bebas,
          ),
        ),
      ],
    );
  }
}
