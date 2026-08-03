import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../notifiers/user_settings_notifier.dart';

class AboutShellPage extends ConsumerStatefulWidget {
  const AboutShellPage({super.key});

  @override
  ConsumerState<AboutShellPage> createState() => _AboutShellPageState();
}

class _AboutShellPageState extends ConsumerState<AboutShellPage> {
  final List<String> iconList = [
    "icon_sport_setting",
    "icon_secure",
    "icon_update",
    "icon_privacy",
    "icon_about",
    "icon_shop1",
    "icon_shop1",
  ];



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        body: _buildMainBody(context, ref, l10n, state),
      ),
    );
  }

  Widget _buildMainBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
  ) {
    return Container(
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              context.push('/user-settings');
            },
            child: Card(
              margin: const EdgeInsets.only(left: 25, right: 25, top: 25).r,
              color: FitTheme.secondbackGround,
              child: Container(
                padding: const EdgeInsets.only(
                  right: 40,
                  top: 20,
                  bottom: 20,
                  left: 40,
                ).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildHeadImageWidget(context, state),
                          Container(
                            margin: const EdgeInsets.only(left: 20).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.nickName,
                                  style: TextStyle(
                                    color: FitTheme.textColor,
                                    fontSize: 30.sp,
                                    fontFamily: AppFonts.hofontmedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(210, 154, 154, 154),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              context.push('/medal-display');
            },
            child: _buildMedalWidget(context, l10n),
          ),
          Container(
            margin: const EdgeInsets.only(left: 45, bottom: 20, top: 25).r,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.settings,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 30.sp,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ),
          _buildSettingCardButton(context, l10n),
          Container(
            margin: const EdgeInsets.only(left: 45, top: 25, bottom: 20).r,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.other,
              style: TextStyle(
                color: FitTheme.textColor,
                fontFamily: AppFonts.hofontmedium,
                fontSize: 30.sp,
              ),
            ),
          ),
          _buildOtherCardButton(context, l10n),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 45.r, bottom: 25.r),
            child: Text(
              l10n.virtualCoach,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 30.sp,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ),
          _buildSelectCharacterWidget(context, ref, l10n),
        ],
      ),
    );
  }

  Widget _buildHeadImageWidget(BuildContext context, state) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 80.r,
      width: 80.r,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset(
        "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildMedalWidget(BuildContext context, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25).r,
      color: FitTheme.secondbackGround,
      child: Container(
        padding: const EdgeInsets.all(40).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(right: 20).r,
                  height: 50.h,
                  width: 50.w,
                  child: Image.asset(
                    "images/newUIScreen/icons/icon_medals.png",
                    color: FitTheme.buttonColor,
                  ),
                ),
                Container(
                  height: 50.h,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 5).r,
                  child: Text(
                    l10n.medal,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 30.sp,
                      fontFamily: AppFonts.hofontregular,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20).r,
                        padding: const EdgeInsets.only(top: 5).r,
                        child: Text(
                          "${l10n.received}  0",
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 30.sp,
                            fontFamily: AppFonts.hofontregular,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Color.fromARGB(210, 154, 154, 154),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCardButton(BuildContext context, AppLocalizations l10n) {
    return Card(
      color: FitTheme.secondbackGround,
      margin: const EdgeInsets.only(left: 25, right: 25).r,
      child: Container(
        padding: const EdgeInsets.all(20).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.push('/sport-setting');
              },
              child: _buildSmallItemButton(0, l10n),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.push('/account-security');
              },
              child: _buildSmallItemButton(1, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherCardButton(BuildContext context, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25).r,
      color: FitTheme.secondbackGround,
      child: Container(
        padding: const EdgeInsets.all(20).r,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                // 占位:软件更新
              },
              child: _buildSmallItemButton(2, l10n),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                // 占位:隐私政策
              },
              child: _buildSmallItemButton(3, l10n),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.push('/about-info');
              },
              child: _buildSmallItemButton(4, l10n),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                _showSignOutDialog(context, ref, l10n);
              },
              child: _buildSmallItemButton(5, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallItemButton(int index, AppLocalizations l10n) {
    final label = switch (index) {
      0 => l10n.sportsSettings,
      1 => l10n.accountSecurity,
      2 => l10n.softwareUpdate,
      3 => l10n.userPrivacyPolicy,
      4 => l10n.about,
      5 => l10n.reLogin,
      6 => l10n.dataCollection,
      _ => '',
    };
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20).r,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(right: 20).r,
                height: 50.h,
                width: 50.w,
                child: Image.asset(
                  "images/newUIScreen/icons/${iconList[index]}.png",
                  color: FitTheme.buttonColor,
                ),
              ),
              Container(
                height: 50.h,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 5).r,
                child: Text(
                  label,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 30.sp,
                    letterSpacing: 0,
                    fontFamily: AppFonts.hofontregular,
                  ),
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Color.fromARGB(210, 154, 154, 154),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCharacterWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final state = ref.watch(userSettingsProvider);
    final notifier = ref.read(userSettingsProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25).r,
      color: FitTheme.secondbackGround,
      child: Container(
        padding: const EdgeInsets.all(20).r,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCharacterRadio(0, l10n.coachMichael, state, notifier),
                _buildCharacterRadio(1, l10n.coachVicky, state, notifier),
                _buildCharacterRadio(2, l10n.coachFiona, state, notifier),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCharacterRadio(3, l10n.coachPaul, state, notifier),
                _buildCharacterRadio(4, l10n.coachLucy, state, notifier),
                _buildCharacterRadio(5, l10n.coachJack, state, notifier),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_buildCharacterRadio(6, l10n.coachCarol, state, notifier)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterRadio(int index, String label, state, notifier) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: state.selectedImageIndex,
          onChanged: (value) {
            notifier.updateSelectedImageIndex(value!);
          },
          hoverColor: Colors.transparent,
          activeColor: FitTheme.buttonColor,
        ),
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: FitTheme.textColor, fontSize: 22.sp),
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: FitTheme.secondbackGround,
          insetPadding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 560.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 36.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.logout,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.hofontmedium,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    l10n.confirmLogout,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 28.sp,
                      fontFamily: AppFonts.hofontregular,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            foregroundColor: FitTheme.textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: FitTheme.textColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 28.sp,
                              fontFamily: AppFonts.hofontmedium,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final authNotifier = ref.read(
                              authProvider.notifier,
                            );
                            await authNotifier.logout();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            backgroundColor: FitTheme.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            l10n.confirm,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontFamily: AppFonts.hofontmedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
