import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/home_providers.dart';
import 'home_tab_screen.dart';
import 'placeholder_page.dart';

/// 主页外壳(1:1 复刻旧 MyHomePage)。
///
/// 结构:
/// - IndexedStack[HomeTabScreen, PlaceholderSport, PlaceholderDevice, PlaceholderMe]
/// - BottomNavigationBar 4 tab: Health / Sport / Device / Me
class HomeShellScreen extends ConsumerWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ThemChange.backgroundColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: state.currentIndex == 0 ? 0 : 100.r,
            leading: Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 45).r,
              width: MediaQuery.of(context).size.width,
              child: _buildLeftTitle(state.currentIndex),
            ),
            leadingWidth: 300,
            centerTitle: false,
          ),
          backgroundColor: ThemChange.backgroundColor,
          body: IndexedStack(
            index: state.currentIndex,
            children: const [
              HomeTabScreen(),
              PlaceholderPage(targetName: 'Sport'),
              PlaceholderPage(targetName: 'Device'),
              PlaceholderPage(targetName: 'Me'),
            ],
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 1,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: ThemChange.buttonColor,
                unselectedItemColor: ThemChange.textColor,
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
                color: ThemChange.textColor, fontSize: 30.sp,
              ),
              elevation: 20.r,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/healthUn.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('images/newUIScreen/health.png',
                      width: 24, height: 24),
                  label: 'Health',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/courseUn.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('images/newUIScreen/course.png',
                      width: 24, height: 24),
                  label: 'Sport',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/icons/icon_device.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset(
                      'images/newUIScreen/icons/icon_device_sel.png',
                      width: 24, height: 24),
                  label: 'Device',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/newUIScreen/icons/meUn.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('images/newUIScreen/icons/me.png',
                      width: 24, height: 24),
                  label: 'Me',
                ),
              ],
              backgroundColor: ThemChange.backgroundColor,
              currentIndex: state.currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: ThemChange.buttonColor,
              unselectedItemColor: ThemChange.textColor,
              onTap: (i) => notifier.changePage(i),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftTitle(int index) {
    switch (index) {
      case 0:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Fit Monster',
                style: TextStyle(
                  color: ThemChange.textColor, fontSize: 40.sp,
                  fontFamily: AppFonts.hofontmedium,
                )),
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(bottom: 6).r,
              child: Text('Made fitness fun',
                  style: TextStyle(
                    color: ThemChange.textColor, fontSize: 25.sp,
                    fontFamily: AppFonts.hofontregular,
                  )),
            ),
          ],
        );
      case 1:
        return Text('Course',
            style: TextStyle(
              color: ThemChange.textColor, fontSize: 40.sp,
              fontFamily: AppFonts.hofontmedium,
            ));
      case 2:
        return Text('Device',
            style: TextStyle(
              color: ThemChange.textColor, fontSize: 40.sp,
              fontFamily: AppFonts.hofontmedium,
            ));
      case 3:
        return Text('Me',
            style: TextStyle(
              color: ThemChange.textColor, fontSize: 40.sp,
              fontFamily: AppFonts.hofontmedium,
            ));
      default:
        return Container();
    }
  }
}
