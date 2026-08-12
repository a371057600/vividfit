import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/them_change.dart';

/// 日历日期格子下方的迷你三环进度指示器。
///
/// [isSelected] 控制颜色状态：选中时显示三环主题色，未选中时显示灰色。
class MiniDayRings extends StatelessWidget {
  final double durationProgress;
  final double strengthProgress;
  final double calorieProgress;
  final bool isSelected;

  const MiniDayRings({
    super.key,
    required this.durationProgress,
    required this.strengthProgress,
    required this.calorieProgress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = 36.r;
    final outStep = (durationProgress * 20).round().clamp(0, 20);
    final midStep = (strengthProgress * 20).round().clamp(0, 20);
    final inStep = (calorieProgress * 20).round().clamp(0, 20);

    final outColor = isSelected
        ? FitTheme.threeRingsColorOutSide
        : Colors.grey.withValues(alpha: 0.4);
    final midColor = isSelected
        ? FitTheme.threeRingsColorMiddle
        : Colors.grey.withValues(alpha: 0.4);
    final inColor = isSelected
        ? FitTheme.threeRingsColorInSide
        : Colors.grey.withValues(alpha: 0.4);

    final outBgColor = isSelected
        ? FitTheme.threeRingsColorbackGroundOutSide.withValues(alpha: 0.5)
        : Colors.grey.withValues(alpha: 0.2);
    final midBgColor = isSelected
        ? FitTheme.threeRingsColorbackGroundMiddle.withValues(alpha: 0.5)
        : Colors.grey.withValues(alpha: 0.2);
    final inBgColor = isSelected
        ? FitTheme.threeRingsColorbackGroundInSide.withValues(alpha: 0.5)
        : Colors.grey.withValues(alpha: 0.2);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularStepProgressIndicator(
            totalSteps: 20,
            currentStep: 20,
            stepSize: 3.r,
            startingAngle: -3.14 * 0.9,
            selectedColor: outBgColor,
            unselectedColor: Colors.transparent,
            padding: 0,
            width: size,
            height: size,
            selectedStepSize: 3.r,
            roundedCap: (_, _) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 22,
              currentStep: 22,
              stepSize: 3.r,
              startingAngle: -3.14 * 0.87,
              selectedColor: midBgColor,
              unselectedColor: Colors.transparent,
              padding: 0,
              selectedStepSize: 3.r,
              roundedCap: (_, _) => true,
              child: CircularStepProgressIndicator(
                totalSteps: 24,
                currentStep: 24,
                stepSize: 3.r,
                startingAngle: -3.14 * 0.8,
                selectedColor: inBgColor,
                unselectedColor: Colors.transparent,
                padding: 0,
                selectedStepSize: 3.r,
                roundedCap: (_, _) => true,
              ),
            ),
          ),
          CircularStepProgressIndicator(
            totalSteps: 20,
            currentStep: outStep,
            stepSize: 3.r,
            startingAngle: -3.14 * 0.9,
            selectedColor: outColor,
            unselectedColor: Colors.transparent,
            padding: 0,
            width: size,
            height: size,
            selectedStepSize: 3.r,
            circularDirection: CircularDirection.clockwise,
            roundedCap: (_, _) => true,
            child: CircularStepProgressIndicator(
              totalSteps: 22,
              currentStep: midStep,
              stepSize: 3.r,
              startingAngle: -3.14 * 0.87,
              selectedColor: midColor,
              unselectedColor: Colors.transparent,
              padding: 0,
              selectedStepSize: 3.r,
              roundedCap: (_, _) => true,
              child: CircularStepProgressIndicator(
                totalSteps: 24,
                currentStep: inStep,
                stepSize: 3.r,
                startingAngle: -3.14 * 0.8,
                selectedColor: inColor,
                unselectedColor: Colors.transparent,
                padding: 0,
                selectedStepSize: 3.r,
                roundedCap: (_, _) => true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}