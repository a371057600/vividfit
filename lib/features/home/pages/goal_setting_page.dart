import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../notifiers/goal_setting_notifier.dart';

/// 运动目标设置页(1:1 复刻旧 GoalSettingScreen)。
///
/// [isRegistration] 为 true 时走注册流程链路(确认后提交注册数据→/home-shell)。
class GoalSettingPage extends ConsumerWidget {
  const GoalSettingPage({super.key, this.isRegistration = false});

  final bool isRegistration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(goalSettingProvider);
    final notifier = ref.read(goalSettingProvider.notifier);

    // 运动类型名(3 个)
    final sportTypes = [l10n.aerobic, l10n.anaerobic, l10n.rehab];
    // 每个类型下的 3 个子档位名
    final sportSubs = [
      [l10n.basic, l10n.moderate, l10n.hiit],
      [l10n.strength, l10n.shaping, l10n.power],
      [l10n.stage1, l10n.stage2, l10n.stage3],
    ];
    // 类型说明
    final sportContents = [
      l10n.aerobicContent,
      l10n.anaerobicContent,
      l10n.rehabContent,
    ];
    // 子档位说明
    final sportAreas = [
      [l10n.basicArea, l10n.moderateArea, l10n.hiitArea],
      [l10n.strengthArea, l10n.shapingArea, l10n.powerArea],
      [l10n.stage1Area, l10n.stage2Area, l10n.stage3Area],
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 300,
          backgroundColor: FitTheme.backgroundColor,
          scrolledUnderElevation: 0,
          leading: Container(
            margin: EdgeInsets.only(left: 45).r,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (isRegistration) {
                  context.pop();
                } else {
                  context.go('/home-shell');
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 10).r,
                    height: 100.r,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: FitTheme.textColor,
                      size: 40.sp,
                    ),
                  ),
                  Text(
                    l10n.sportsGoalSetting,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 40.sp,
                      fontFamily: AppFonts.hofontmedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: FitTheme.backgroundColor,
        body: state.isLoading
            ? Center(
                child: Text(
                  l10n.loading,
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: FitTheme.textColor,
                    fontFamily: AppFonts.bebas,
                  ),
                ),
              )
            : Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 600.h,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 600.h,
                        child: Image.asset(
                          'images/sportSettingPIC/${notifier.languageType()}/${notifier.goalSportTypeSelectIndex()}.png',
                        ),
                      ),
                    ),
                    _buildSportSettingWidget(
                      context,
                      ref,
                      l10n,
                      sportTypes,
                      sportSubs,
                      sportContents,
                      sportAreas,
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(20).r,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FitTheme.buttonColor,
                        ),
                        onPressed: () async {
                          await notifier.saveGoal();
                          if (!context.mounted) return;
                          if (isRegistration) {
                            // 注册流程:保存运动目标 → 提交注册数据 → 进首页
                            await ref
                                .read(authProvider.notifier)
                                .completeRegistration();
                            if (!context.mounted) return;
                            context.go('/home-shell');
                          } else {
                            context.go('/home-shell');
                          }
                        },
                        child: Text(
                          l10n.confirm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FitTheme.fonSizeBigBig,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSportSettingWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<String> sportTypes,
    List<List<String>> sportSubs,
    List<String> sportContents,
    List<List<String>> sportAreas,
  ) {
    final state = ref.watch(goalSettingProvider);
    final notifier = ref.read(goalSettingProvider.notifier);
    final firstIdx = state.sportTypeSelectIndex;
    final secondIdx = state.sportTypeSelectIndex2;
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25).r,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 25).r,
            child: Text(
              l10n.goalSetting,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 35.sp,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 300.h,
                width: 200.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _typeButton(ref, sportTypes[0], 0, firstIdx, notifier),
                    _typeButton(ref, sportTypes[1], 1, firstIdx, notifier),
                    _typeButton(ref, sportTypes[2], 2, firstIdx, notifier),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: FitTheme.textColor, width: 3.r),
                    borderRadius: BorderRadius.all(Radius.circular(20).r),
                  ),
                  height: 300.h,
                  padding: EdgeInsets.all(20.r),
                  child: SingleChildScrollView(
                    child: Text(
                      '${sportContents[firstIdx]}\n\n${sportAreas[firstIdx][secondIdx]}\n',
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 27.sp,
                        fontFamily: AppFonts.hofontmedium,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _subButton(
                  ref,
                  sportSubs[firstIdx][0],
                  firstIdx,
                  0,
                  secondIdx,
                  notifier,
                ),
                _subButton(
                  ref,
                  sportSubs[firstIdx][1],
                  firstIdx,
                  1,
                  secondIdx,
                  notifier,
                ),
                _subButton(
                  ref,
                  sportSubs[firstIdx][2],
                  firstIdx,
                  2,
                  secondIdx,
                  notifier,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeButton(
    WidgetRef ref,
    String label,
    int index,
    int selected,
    GoalSettingNotifier notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => notifier.selectType(index, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected == index
                ? FitTheme.buttonColor
                : FitTheme.textColor,
            width: 3.r,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50).r),
        ),
        height: 60.h,
        width: 200.w,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: FitTheme.textColor,
            fontFamily: AppFonts.hofontmedium,
            fontSize: 25.sp,
          ),
        ),
      ),
    );
  }

  Widget _subButton(
    WidgetRef ref,
    String label,
    int first,
    int index,
    int selected,
    GoalSettingNotifier notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => notifier.selectType(first, index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected == index
                ? FitTheme.buttonColor
                : FitTheme.textColor,
            width: 3.r,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50).r),
        ),
        height: 60.h,
        width: 200.w,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: FitTheme.textColor,
            fontFamily: AppFonts.hofontmedium,
            fontSize: 25.sp,
          ),
        ),
      ),
    );
  }
}
