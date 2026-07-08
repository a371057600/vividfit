import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/goal_setting_notifier.dart';

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
                        color: ThemChange.textColor, fontSize: 40.sp,
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
                      fontSize: 25.sp, color: ThemChange.textColor,
                      fontFamily: AppFonts.bebas,
                    )),
              )
            : Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // 运动类型图片
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 600.h,
                      child: Image.asset(
                        'images/sportSettingPIC/en/${state.sportTypeSelectIndex}.png',
                      ),
                    ),
                    // TODO: 1:1 复刻旧 _buildSportSettingWidget(类型选择 + 子类型选择 + 9 档预设值 + 图片切换)
                    // 细节按旧 goal_setting_screen.dart 完整还原
                    Placeholder(fallbackHeight: 400.h),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () async {
                          await notifier.saveGoal(
                            during: state.goalDuring,
                            kcal: state.goalKcal,
                            strength: state.goalStrength,
                          );
                          if (context.mounted) context.go('/home-shell');
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
