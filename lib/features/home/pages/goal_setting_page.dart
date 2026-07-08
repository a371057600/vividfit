import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/goal_setting_notifier.dart';

/// 运动目标设置页(1:1 复刻旧 GoalSettingScreen)。
///
/// UI 结构:
/// - AppBar:返回按钮 + "Sports Goal Setting"
/// - 运动类型图片(根据 first/second 组合索引 + 语言目录)
/// - Goal Setting 标题
/// - 左列 3 个运动类型选择(Aerobic/Anaerobic/Rehab)+ 右侧说明文本框
/// - 3 个子档位选择(Basic/Moderate/HIIT 等)
/// - Confirm 按钮(保存目标并返回)
class GoalSettingPage extends ConsumerWidget {
  const GoalSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalSettingNotifierProvider);
    final notifier = ref.read(goalSettingNotifierProvider.notifier);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 300,
          backgroundColor: ThemChange.backgroundColor,
          scrolledUnderElevation: 0,
          leading: Container(
            margin: EdgeInsets.only(left: 45).r,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => context.go('/home-shell'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 10).r,
                    height: 100.r,
                    child: Icon(Icons.arrow_back_ios,
                        color: ThemChange.textColor, size: 40.sp),
                  ),
                  Text('Sports Goal Setting',
                      style: TextStyle(
                        color: ThemChange.textColor,
                        fontSize: 40.sp,
                        fontFamily: AppFonts.hofontmedium,
                      )),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: ThemChange.backgroundColor,
        body: state.isLoading
            ? Center(
                child: Text('Loading....',
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: ThemChange.textColor,
                      fontFamily: AppFonts.bebas,
                    )),
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
                          'images/sportSettingPIC/${notifier.getLanguageType()}/${notifier.getGoalSportTypeSelectIndex()}.png',
                        ),
                      ),
                    ),
                    _buildSportSettingWidget(context, ref),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(20).r,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemChange.buttonColor,
                        ),
                        onPressed: () async {
                          await notifier.saveGoal();
                          if (context.mounted) context.go('/home-shell');
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ThemChange.fonSizeBigBig,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// 目标设置主体:标题 + 类型选择 + 说明 + 子档位选择。
  Widget _buildSportSettingWidget(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25).r,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 25).r,
            child: Text(
              'Goal Setting',
              style: TextStyle(
                color: ThemChange.textColor,
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
                    _selectContentTitleWidget(ref, 0),
                    _selectContentTitleWidget(ref, 1),
                    _selectContentTitleWidget(ref, 2),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemChange.textColor, width: 3.r),
                    borderRadius: BorderRadius.all(Radius.circular(20).r),
                  ),
                  height: 300.h,
                  padding: EdgeInsets.all(20.r),
                  child: SingleChildScrollView(
                    child: Text(
                      '${GoalSettingNotifier.sportContent[GoalSettingNotifier.sportTypeList[ref.watch(goalSettingNotifierProvider).sportTypeSelectIndex]]}\n\n'
                      '${GoalSettingNotifier.sportAreaText[ref.watch(goalSettingNotifierProvider).sportTypeSelectSubIndexString]}\n',
                      style: TextStyle(
                        color: ThemChange.textColor,
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
                _selectContentTitleWidget2(ref, 0),
                _selectContentTitleWidget2(ref, 1),
                _selectContentTitleWidget2(ref, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 左列:3 大运动类型选择按钮。
  Widget _selectContentTitleWidget(WidgetRef ref, int index) {
    final state = ref.watch(goalSettingNotifierProvider);
    final notifier = ref.read(goalSettingNotifierProvider.notifier);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => notifier.selectType(index, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: state.sportTypeSelectIndex == index
                ? ThemChange.buttonColor
                : ThemChange.textColor,
            width: 3.r,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50).r),
        ),
        height: 60.h,
        width: 200.w,
        alignment: Alignment.center,
        child: Text(
          GoalSettingNotifier.sportTypeList[index],
          style: TextStyle(
            color: ThemChange.textColor,
            fontFamily: AppFonts.hofontmedium,
            fontSize: 25.sp,
          ),
        ),
      ),
    );
  }

  /// 下方:3 个子档位选择按钮。
  Widget _selectContentTitleWidget2(WidgetRef ref, int index) {
    final state = ref.watch(goalSettingNotifierProvider);
    final notifier = ref.read(goalSettingNotifierProvider.notifier);
    final subList = GoalSettingNotifier
        .sportTypeSlecet[GoalSettingNotifier.sportTypeList[state.sportTypeSelectIndex]]!;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => notifier.selectType(state.sportTypeSelectIndex, index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: state.sportTypeSelectIndex2 == index
                ? ThemChange.buttonColor
                : ThemChange.textColor,
            width: 3.r,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50).r),
        ),
        height: 60.h,
        width: 200.w,
        alignment: Alignment.center,
        child: Text(
          subList[index],
          style: TextStyle(
            color: ThemChange.textColor,
            fontFamily: AppFonts.hofontmedium,
            fontSize: 25.sp,
          ),
        ),
      ),
    );
  }
}
