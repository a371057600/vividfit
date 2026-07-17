import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
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

  final List<String> iconTitle = [
    "运动设置",
    "账号安全",
    "软件更新",
    "用户隐私政策",
    "关于",
    "重新登录",
    "数据采集",
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsNotifierProvider);

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
              context.go('/user-settings');
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
              context.go('/medal-display');
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
      child: ExtendedImage.asset(
        "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
        fit: BoxFit.fill,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Center(
                child: CircularProgressIndicator(
                  color: FitTheme.textColor,
                ),
              );
            case LoadState.failed:
              return const Center(child: Text(""));
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: MediaQuery.of(context).size.width - 10,
                fit: BoxFit.fill,
              );
          }
        },
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
                context.go('/sport-setting');
              },
              child: _buildSmallItemButton(0),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.go('/account-security');
              },
              child: _buildSmallItemButton(1),
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
              child: _buildSmallItemButton(2),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                // 占位:隐私政策
              },
              child: _buildSmallItemButton(3),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.go('/about-info');
              },
              child: _buildSmallItemButton(4),
            ),
            const Divider(color: Color.fromARGB(167, 36, 36, 36)),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                _showSignOutDialog(context, l10n);
              },
              child: _buildSmallItemButton(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallItemButton(int index) {
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
                  iconTitle[index],
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
    final state = ref.watch(userSettingsNotifierProvider);
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

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
                _buildCharacterRadio(0, "Michael", state, notifier),
                _buildCharacterRadio(1, "Vicky", state, notifier),
                _buildCharacterRadio(2, "Fiona", state, notifier),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCharacterRadio(3, "Paul", state, notifier),
                _buildCharacterRadio(4, "Lucy", state, notifier),
                _buildCharacterRadio(5, "Jack", state, notifier),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCharacterRadio(6, "Carol", state, notifier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterRadio(
    int index,
    String label,
    state,
    notifier,
  ) {
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

  void _showSignOutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FitTheme.backgroundColor,
          contentPadding: const EdgeInsets.all(20),
          titlePadding: const EdgeInsets.only(top: 20),
          title: Text(
            "退出登录",
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "警告:是否退出,未保存的信息将被删除?",
            style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp),
          ),
          actions: [
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 30,
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(color: FitTheme.textColor),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/login');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 30,
                      child: Text(
                        l10n.confirm,
                        style: TextStyle(color: FitTheme.textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
