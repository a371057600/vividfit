import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/home_notifier.dart';
import 'home_tab_screen.dart';
import 'placeholder_page.dart';

/// 主页外壳(1:1 复刻旧 MyHomePage)。
class HomeShellScreen extends ConsumerWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: FitTheme.backgroundColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: state.currentIndex == 0 ? 0 : 100.r,
            leading: Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 45).r,
              width: MediaQuery.of(context).size.width,
              child: _buildLeftTitle(l10n, state.currentIndex),
            ),
            leadingWidth: 300,
            centerTitle: false,
          ),
          backgroundColor: FitTheme.backgroundColor,
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              const HomeTabScreen(),
              PlaceholderPage(targetName: l10n.sport),
              PlaceholderPage(targetName: l10n.device),
              PlaceholderPage(targetName: l10n.me),
            ],
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 1,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: FitTheme.buttonColor,
                unselectedItemColor: FitTheme.textColor,
                selectedLabelStyle: TextStyle(fontSize: 25.sp),
                unselectedLabelStyle: TextStyle(fontSize: 25.sp),
                showSelectedLabels: true,
                showUnselectedLabels: true,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              selectedLabelStyle: TextStyle(
                fontFamily: AppFonts.hofontmedium, fontSize: 30.sp,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: AppFonts.hofontregular,
                color: FitTheme.textColor, fontSize: 30.sp,
              ),
              elevation: 20.r,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/healthUn.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('images/newUIScreen/health.png',
                      width: 24, height: 24),
                  label: l10n.health,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/courseUn.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('images/newUIScreen/course.png',
                      width: 24, height: 24),
                  label: l10n.sport,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/icons/icon_device.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset(
                      'images/newUIScreen/icons/icon_device_sel.png',
                      width: 24, height: 24),
                  label: l10n.device,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/icons/meUn.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('images/newUIScreen/icons/me.png',
                      width: 24, height: 24),
                  label: l10n.me,
                ),
              ],
              backgroundColor: FitTheme.backgroundColor,
              currentIndex: state.currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: FitTheme.buttonColor,
              unselectedItemColor: FitTheme.textColor,
              onTap: (i) {
                if (i == 3) {
                  context.go('/about-shell');
                } else {
                  notifier.changePage(i);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftTitle(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(l10n.fitMonster,
                style: TextStyle(
                  color: FitTheme.textColor, fontSize: 40.sp,
                  fontFamily: AppFonts.hofontmedium,
                )),
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(bottom: 6).r,
              child: Text(l10n.madeFitnessFunSlogan,
                  style: TextStyle(
                    color: FitTheme.textColor, fontSize: 25.sp,
                    fontFamily: AppFonts.hofontregular,
                  )),
            ),
          ],
        );
      case 1:
        return Text(l10n.course,
            style: TextStyle(
              color: FitTheme.textColor, fontSize: 40.sp,
              fontFamily: AppFonts.hofontmedium,
            ));
      case 2:
        return Text(l10n.device,
            style: TextStyle(
              color: FitTheme.textColor, fontSize: 40.sp,
              fontFamily: AppFonts.hofontmedium,
            ));
      case 3:
        return Text(l10n.me,
            style: TextStyle(
              color: FitTheme.textColor, fontSize: 40.sp,
              fontFamily: AppFonts.hofontmedium,
            ));
      default:
        return Container();
    }
  }
}
