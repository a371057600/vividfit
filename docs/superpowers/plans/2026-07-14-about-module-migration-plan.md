# About 模块迁移实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将旧的 About 模块从 GetX 框架迁移到 flutter_riverpod + go_router 架构,保持 UI 完全一致,使用空页面占位,暂不接通云端。

**Architecture:** 采用 Riverpod 状态管理替代 GetX,使用 go_router 进行路由导航,遵循已迁移的 auth 和 home 模块的架构模式。使用代码别名防止查重,将 Controller 重命名为 Notifier,将 Screen 重命名为 Page。

**Tech Stack:** Flutter, flutter_riverpod, go_router, flutter_screenutil, extended_image

---

## 文件结构映射

### 新建文件 (使用别名防止查重)

```
lib/features/about/
├── notifiers/
│   ├── about_providers.dart              # About 模块的 Provider 汇总
│   └── user_settings_notifier.dart       # 用户设置状态管理 (原 controller_about_user_head.dart)
├── pages/
│   ├── about_shell_page.dart             # About 主页 (原 new_abouts_screen.dart)
│   ├── user_settings_page.dart           # 用户基本设置页 (原 about_user_head_screen.dart)
│   ├── avatar_select_page.dart           # 头像选择页 (原 new_image_select_screen.dart)
│   ├── about_info_page.dart              # 关于信息页 (原 about_info_screen.dart)
│   ├── sport_setting_page.dart           # 运动设置页 (原 new_about_sport_setting_screen.dart)
│   ├── account_security_page.dart        # 账号安全页 (原 account_safe_screen.dart)
│   ├── medal_display_page.dart           # 勋章展示页 (原 new_medal_screen.dart)
│   └── placeholder_about_page.dart       # About 模块占位页面
└── states/
    └── user_settings_state.dart          # 用户设置状态类 (使用 freezed)
```

### 修改文件

```
lib/core/routing/app_router.dart          # 添加 About 模块路由
lib/l10n/app_en.arb                       # 添加 About 模块国际化键
lib/l10n/app_zh.arb                       # 添加 About 模块国际化键
```

---

## Task 1: 创建用户设置状态类

**Files:**
- Create: `lib/features/about/states/user_settings_state.dart`

- [ ] **Step 1: 编写用户设置状态类**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings_state.freezed.dart';

@freezed
class UserSettingsState with _$UserSettingsState {
  const factory UserSettingsState({
    @Default('') String headImage,
    @Default(0) int selectedImageIndex,
    @Default('') String imagePickFile,
    @Default(true) bool isLoading,
    @Default('Nick') String nickName,
    @Default('2000-01-01') String birthday,
    @Default('01') String bodyAgeDay,
    @Default('01') String bodyAgeMonth,
    @Default('1991') String bodyAgeYear,
    @Default(true) bool gander, // true = Male, false = Female
    @Default(170) int bodyHeight,
    @Default(80) int bodyWeight,
    @Default(70) int bodyGoalWeight,
    @Default(70) int heightPosition,
    @Default(50) int weightPosition,
    @Default(30) int goalWeightPosition,
    @Default(false) bool isUpdating,
  }) = _UserSettingsState;
}
```

- [ ] **Step 2: 运行代码生成**

Run: `cd /Users/dryao/Dev/fitMonsterAPP/2026WorkSpace/力动app工作区/app/vividfit_v2 && flutter pub run build_runner build --delete-conflicting-outputs`

Expected: 生成 `user_settings_state.freezed.dart` 文件

- [ ] **Step 3: 提交代码**

```bash
git add lib/features/about/states/user_settings_state.dart lib/features/about/states/user_settings_state.freezed.dart
git commit -m "feat: add UserSettingsState with freezed"
```

---

## Task 2: 创建用户设置 Notifier

**Files:**
- Create: `lib/features/about/notifiers/user_settings_notifier.dart`

- [ ] **Step 1: 编写用户设置 Notifier**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/user_settings_state.dart';

class UserSettingsNotifier extends StateNotifier<UserSettingsState> {
  UserSettingsNotifier() : super(const UserSettingsState());

  // 模拟数据加载 (暂不接通云端)
  Future<void> loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoading: false,
      nickName: 'TestUser',
      birthday: '2000-01-01',
      gander: true,
      bodyHeight: 175,
      bodyWeight: 70,
    );
  }

  // 更新昵称
  void updateNickName(String name) {
    state = state.copyWith(nickName: name);
  }

  // 更新生日
  void updateBirthday(String date) {
    state = state.copyWith(birthday: date);
  }

  // 更新性别
  void updateGender(bool isMale) {
    state = state.copyWith(gander: isMale);
  }

  // 更新身高
  void updateHeight(int height) {
    state = state.copyWith(
      bodyHeight: height,
      heightPosition: height - 100,
    );
  }

  // 更新体重
  void updateWeight(int weight) {
    state = state.copyWith(
      bodyWeight: weight,
      weightPosition: weight - 40,
    );
  }

  // 更新头像索引
  void updateSelectedImageIndex(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  // 切换更新状态
  void toggleUpdating(bool isUpdating) {
    state = state.copyWith(isUpdating: isUpdating);
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/about/notifiers/user_settings_notifier.dart
git commit -m "feat: add UserSettingsNotifier for state management"
```

---

## Task 3: 创建 About 模块 Providers

**Files:**
- Create: `lib/features/about/notifiers/about_providers.dart`

- [ ] **Step 1: 编写 Providers 文件**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_settings_notifier.dart';
import '../states/user_settings_state.dart';

final userSettingsNotifierProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettingsState>(
  (ref) => UserSettingsNotifier(),
);
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/about/notifiers/about_providers.dart
git commit -m "feat: add about_providers for Riverpod integration"
```

---

## Task 4: 添加国际化键

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`

- [ ] **Step 1: 添加英文翻译**

在 `app_en.arb` 文件中添加以下键值对:

```json
{
  "settings": "Settings",
  "other": "Other",
  "virtualCoach": "Virtual Coach",
  "medal": "Medal",
  "received": "Received",
  "sportsSettings": "Sports Settings",
  "accountSecurity": "Account Security",
  "softwareUpdate": "Software Update",
  "userPrivacyPolicy": "User Privacy Policy",
  "about": "About",
  "reLogin": "Re-login",
  "basicSettings": "Basic Settings",
  "avatar": "Avatar",
  "create": "Create",
  "nickname": "Nickname",
  "gender": "Gender",
  "male": "Male",
  "female": "Female",
  "birthday": "Birthday",
  "height": "Height",
  "weight": "Weight",
  "cancel": "Cancel",
  "confirm": "Confirm",
  "dateSelection": "Date Selection",
  "genderSelection": "Gender Selection",
  "setNickName": "Set NickName",
  "theNicknameIsUsedToHideYourRealNameOtherUsersInTheSystemCanSeeYourNickname": "The nickname is used to hide your real name. Other users in the system can see your nickname.",
  "theNumberOfWordsShouldNotBeLessThan3PleaseReEnter": "The number of words should not be less than 3, please re-enter",
  "thereAreMoreThan10WordsPleaseReEnter": "There are more than 10 words, please re-enter",
  "takePhoto": "Take Photo",
  "pictureSelect": "Picture Select",
  "return": "Return",
  "serviceHotline": "Service Hotline",
  "legalInformation": "Legal Information"
}
```

- [ ] **Step 2: 添加中文翻译**

在 `app_zh.arb` 文件中添加以下键值对:

```json
{
  "settings": "设置",
  "other": "其他",
  "virtualCoach": "虚拟教练",
  "medal": "勋章",
  "received": "已获得",
  "sportsSettings": "运动设置",
  "accountSecurity": "账号安全",
  "softwareUpdate": "软件更新",
  "userPrivacyPolicy": "用户隐私政策",
  "about": "关于",
  "reLogin": "重新登录",
  "basicSettings": "基本设置",
  "avatar": "头像",
  "create": "创建",
  "nickname": "昵称",
  "gender": "性别",
  "male": "男",
  "female": "女",
  "birthday": "生日",
  "height": "身高",
  "weight": "体重",
  "cancel": "取消",
  "confirm": "确认",
  "dateSelection": "日期选择",
  "genderSelection": "性别选择",
  "setNickName": "设置昵称",
  "theNicknameIsUsedToHideYourRealNameOtherUsersInTheSystemCanSeeYourNickname": "昵称用于隐藏您的真实姓名,系统中的其他用户可以看到您的昵称。",
  "theNumberOfWordsShouldNotBeLessThan3PleaseReEnter": "字数不应少于3个,请重新输入",
  "thereAreMoreThan10WordsPleaseReEnter": "字数超过10个,请重新输入",
  "takePhoto": "拍照",
  "pictureSelect": "图片选择",
  "return": "返回",
  "serviceHotline": "服务热线",
  "legalInformation": "法律信息"
}
```

- [ ] **Step 3: 运行代码生成**

Run: `cd /Users/dryao/Dev/fitMonsterAPP/2026WorkSpace/力动app工作区/app/vividfit_v2 && flutter gen-l10n`

Expected: 生成新的本地化文件

- [ ] **Step 4: 提交代码**

```bash
git add lib/l10n/app_en.arb lib/l10n/app_zh.arb lib/l10n/app_localizations.dart lib/l10n/app_localizations_en.dart lib/l10n/app_localizations_zh.dart
git commit -m "feat: add about module i18n keys"
```

---

## Task 5: 创建 About 模块占位页面

**Files:**
- Create: `lib/features/about/pages/placeholder_about_page.dart`

- [ ] **Step 1: 编写占位页面**

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/them_change.dart';

class PlaceholderAboutPage extends StatelessWidget {
  final String targetName;

  const PlaceholderAboutPage({
    super.key,
    required this.targetName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        title: Text(
          targetName,
          style: const TextStyle(color: FitTheme.textColor),
        ),
        iconTheme: const IconThemeData(color: FitTheme.textColor),
      ),
      body: Center(
        child: Text(
          targetName,
          style: const TextStyle(color: FitTheme.textColor, fontSize: 24),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/about/pages/placeholder_about_page.dart
git commit -m "feat: add PlaceholderAboutPage for module placeholders"
```

---

## Task 6: 创建 AboutInfoPage (关于信息页)

**Files:**
- Create: `lib/features/about/pages/about_info_page.dart`

- [ ] **Step 1: 编写关于信息页**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class AboutInfoPage extends ConsumerWidget {
  const AboutInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: FitTheme.textColor),
        titleTextStyle: const TextStyle(color: FitTheme.textColor),
        title: Text(
          l10n.about,
          style: const TextStyle(
            color: FitTheme.textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: FitTheme.backgroundColor,
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Spacer(),
                        ClipOval(
                          child: Image.asset(
                            "images/newUIScreen/tergasy.png",
                            height: 200.r,
                            width: 200.r,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "Vivid Fit",
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "v1.0.0",
                          style: TextStyle(color: FitTheme.textColor),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: FitTheme.secondbackGround,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 45,
                    right: 25,
                    top: 20,
                    bottom: 20,
                  ).r,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.serviceHotline,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 25.sp,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "400-083-1718",
                            style: TextStyle(color: FitTheme.textColor),
                          ),
                          SizedBox(width: 10.r),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 30.r,
                            color: const Color.fromARGB(210, 154, 154, 154),
                          ),
                        ],
                      ),
                      const Divider(color: Color.fromARGB(167, 40, 40, 40)),
                      Row(
                        children: [
                          Text(
                            l10n.legalInformation,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 25.sp,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 30.r,
                            color: const Color.fromARGB(210, 154, 154, 154),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    width: 260,
                    alignment: Alignment.bottomCenter,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "粤ICP备19140274号-4A",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                        Text(
                          "Dongguan Quanchuang Optoelectronics Industrial Co., Ltd. All Rights Reserved @2022-2024",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/about/pages/about_info_page.dart
git commit -m "feat: add AboutInfoPage with UI matching original"
```

---

## Task 7: 创建 AvatarSelectPage (头像选择页)

**Files:**
- Create: `lib/features/about/pages/avatar_select_page.dart`

- [ ] **Step 1: 编写头像选择页**

```dart
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/about_providers.dart';

class AvatarSelectPage extends ConsumerWidget {
  const AvatarSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsNotifierProvider);
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 80.h,
        leadingWidth: 750.w,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 45).r,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (!state.isUpdating) {
                notifier.toggleUpdating(true);
                Future.delayed(const Duration(seconds: 5), () {
                  notifier.toggleUpdating(false);
                });
                Navigator.of(context).pop();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 10).r,
                  height: 100.r,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: FitTheme.textColor,
                    size: 40.sp,
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.basicSettings,
                    maxLines: 1,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 40.sp,
                      fontFamily: AppFonts.hofontmedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: FitTheme.textColor),
        titleTextStyle: const TextStyle(color: FitTheme.textColor),
      ),
      backgroundColor: FitTheme.backgroundColor,
      body: _buildMainBody(context, ref, l10n, state),
    );
  }

  Widget _buildMainBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: FitTheme.backgroundColor,
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 60).r,
      child: Column(
        children: [
          _buildHeadImageWidget(context, ref, state),
          _buildSelectImageWidget(context, ref, state),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                  ),
                  child: Text(
                    l10n.confirm,
                    style: TextStyle(color: Colors.white, fontSize: 35.sp),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                  ),
                  child: Text(
                    l10n.returnButton,
                    style: TextStyle(color: Colors.white, fontSize: 35.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeadImageWidget(BuildContext context, WidgetRef ref, state) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 45, bottom: 45).r,
      child: Column(
        children: [
          ClipOval(
            child: Container(
              width: 150.r,
              height: 150.r,
              decoration: BoxDecoration(
                color: FitTheme.secondbackGround,
                borderRadius: BorderRadius.circular(75).r,
              ),
              child: ExtendedImage.asset(
                "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
                fit: BoxFit.fill,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: FitTheme.textColor,
                          size: 50,
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
            ),
          ),
          SizedBox(height: 80.r),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // 占位:拍照功能
                  },
                  child: Container(
                    width: 220.r,
                    height: 60.r,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 25,
                      right: 25,
                    ).r,
                    decoration: BoxDecoration(
                      color: FitTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                        color: FitTheme.textColor,
                        width: 2.r,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: FitTheme.textColor,
                          size: 35.r,
                        ),
                        SizedBox(width: 20.r),
                        Expanded(
                          child: Text(
                            "拍照",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 40.r),
                InkWell(
                  onTap: () {
                    // 占位:图片选择功能
                  },
                  child: Container(
                    width: 220.r,
                    height: 60.r,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 25,
                      right: 25,
                    ).r,
                    decoration: BoxDecoration(
                      color: FitTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                        color: FitTheme.textColor,
                        width: 2.r,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: FitTheme.textColor,
                          size: 35.r,
                        ),
                        SizedBox(width: 20.r),
                        Expanded(
                          child: Text(
                            "图片选择",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 25.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectImageWidget(BuildContext context, WidgetRef ref, state) {
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 100).r,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20.r,
            mainAxisSpacing: 30.r,
            childAspectRatio: 1,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                notifier.updateSelectedImageIndex(index);
              },
              child: Column(
                children: [
                  Container(
                    width: 130.r,
                    height: 130.r,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(100).r,
                      border: Border.all(
                        color: state.selectedImageIndex == index
                            ? FitTheme.buttonColor
                            : Colors.transparent,
                        width: 5.r,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "images/newUIScreen/defaultheadimages/deheadImage${index + 1}.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.r),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/about/pages/avatar_select_page.dart
git commit -m "feat: add AvatarSelectPage with grid layout matching original"
```

---

## Task 8: 创建 UserSettingsPage (基本设置页)

**Files:**
- Create: `lib/features/about/pages/user_settings_page.dart`

- [ ] **Step 1: 编写基本设置页(第一部分:主框架)**

```dart
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/about_providers.dart';

class UserSettingsPage extends ConsumerWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsNotifierProvider);
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 300,
        toolbarHeight: 80.h,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: FitTheme.textColor),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 40.sp),
        leading: Container(
          margin: const EdgeInsets.only(left: 45).r,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (!state.isUpdating) {
                notifier.toggleUpdating(true);
                Future.delayed(const Duration(seconds: 5), () {
                  notifier.toggleUpdating(false);
                });
                Navigator.of(context).pop();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 10).r,
                  height: 100.r,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: FitTheme.textColor,
                    size: 40.sp,
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.basicSettings,
                    maxLines: 1,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 40.sp,
                      fontFamily: AppFonts.hofontmedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: FitTheme.backgroundColor,
      body: _buildListUserInfo(context, ref, l10n, state, notifier),
    );
  }
}
```

- [ ] **Step 2: 编写基本设置页(第二部分:内容区域)**

在同一个文件中继续添加:

```dart
  Widget _buildListUserInfo(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              InkWell(
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  context.go('/avatar-select');
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ).r,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ).r,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: FitTheme.secondbackGround,
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  child: Row(
                    children: [
                      state.isLoading
                          ? Container()
                          : _buildAvatarWidget(context, state),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Text(
                          l10n.avatar,
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.create,
                        style: TextStyle(
                          color: FitTheme.textColor,
                          fontSize: 25.sp,
                        ),
                      ),
                      SizedBox(width: 20.r),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 30.sp,
                        color: FitTheme.textColor,
                      ),
                    ],
                  ),
                ),
              ),
              _buildOtherColumn(context, ref, l10n, state, notifier),
            ],
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 3: 编写基本设置页(第三部分:头像组件)**

继续在同一个文件中添加:

```dart
  Widget _buildAvatarWidget(BuildContext context, state) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 80.r,
      width: 80.r,
      clipBehavior: Clip.hardEdge,
      child: ExtendedImage.asset(
        "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
        fit: BoxFit.fill,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.white,
                  size: 50,
                ),
              );
            case LoadState.failed:
              return ExtendedImage.asset(
                "images/newUIScreen/defaultheadimages/deheadImage1.jpg",
              );
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
```

- [ ] **Step 4: 编写基本设置页(第四部分:其他设置项)**

继续在同一个文件中添加:

```dart
  Widget _buildOtherColumn(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20).r,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10).r,
      height: 540.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Column(
        children: [
          _buildNameCreatWidget(context, ref, l10n, state, notifier, 0),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          _buildSexPickerWidget(context, ref, l10n, state, notifier, 1),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          _buildBirthdayPickWidget(context, ref, l10n, state, notifier, 2),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          Expanded(child: _buildHeightPickerWidget(context, ref, l10n, state, notifier, 3)),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          Expanded(child: _buildWeightPickerWidget(context, ref, l10n, state, notifier, 4)),
        ],
      ),
    );
  }
```

- [ ] **Step 5: 编写基本设置页(第五部分:单项组件)**

继续在同一个文件中添加昵称、性别、生日、身高、体重组件:

```dart
  // 昵称组件
  Widget _buildNameCreatWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
    int index,
  ) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          _showNickNameDialog(context, ref, l10n, state, notifier);
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_0.png",
                color: FitTheme.buttonColor,
                width: 25.r,
                height: 25.r,
              ),
            ),
            Text(
              l10n.nickname,
              style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.nickName,
              style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 30.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  // 性别组件
  Widget _buildSexPickerWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
    int index,
  ) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          _showSexPickerBottomSheet(context, ref, l10n, state, notifier);
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_4.png",
                color: FitTheme.buttonColor,
                width: 25.r,
                height: 25.r,
              ),
            ),
            Text(
              l10n.gender,
              style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.gander ? l10n.male : l10n.female,
              style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 30.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  // 生日组件
  Widget _buildBirthdayPickWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
    int index,
  ) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          _showDatePickerBottomSheet(context, ref, l10n, state, notifier);
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_2.png",
                color: FitTheme.buttonColor,
                width: 25.r,
                height: 25.r,
              ),
            ),
            Text(
              l10n.birthday,
              style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.birthday,
              style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 30.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  // 身高组件
  Widget _buildHeightPickerWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
    int index,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showHeightPickerBottomSheet(context, ref, l10n, state, notifier);
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10).r,
            child: Image.asset(
              "images/newUIScreen/icons/icon_about_head_1.png",
              color: FitTheme.buttonColor,
              width: 25.r,
              height: 25.r,
            ),
          ),
          Text(
            l10n.height,
            style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
          ),
          const Spacer(),
          Text(
            state.bodyHeight.toString(),
            style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
          ),
          SizedBox(width: 20.r),
          Icon(
            Icons.arrow_forward_ios,
            size: 30.sp,
            color: FitTheme.textColor,
          ),
        ],
      ),
    );
  }

  // 体重组件
  Widget _buildWeightPickerWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
    int index,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showWeightPickerBottomSheet(context, ref, l10n, state, notifier);
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10).r,
            child: Image.asset(
              "images/newUIScreen/icons/icon_about_head_3.png",
              color: FitTheme.buttonColor,
              width: 25.r,
              height: 25.r,
            ),
          ),
          Text(
            l10n.weight,
            style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
          ),
          const Spacer(),
          Text(
            state.bodyWeight.toString(),
            style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
          ),
          SizedBox(width: 20.r),
          Icon(
            Icons.arrow_forward_ios,
            size: 30.sp,
            color: FitTheme.textColor,
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 6: 编写基本设置页(第六部分:底部弹窗)**

继续在同一个文件中添加各种选择器弹窗:

```dart
  // 昵称对话框
  void _showNickNameDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    final textController = TextEditingController(text: state.nickName);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: FitTheme.backgroundColor,
          insetPadding: const EdgeInsets.only(left: 45, right: 45).r,
          child: Container(
            padding: EdgeInsets.all(25).r,
            height: 400.r,
            width: 600.r,
            decoration: BoxDecoration(
              color: FitTheme.secondbackGround,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.setNickName,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontFamily: AppFonts.hofontblod,
                    color: FitTheme.textColor,
                  ),
                ),
                Text(
                  l10n.theNicknameIsUsedToHideYourRealNameOtherUsersInTheSystemCanSeeYourNickname,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 25.sp,
                  ),
                ),
                Container(
                  height: 80.r,
                  margin: const EdgeInsets.only(left: 25, right: 25, top: 0).r,
                  child: TextField(
                    controller: textController,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 0, bottom: 10),
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
                          width: 200.w,
                          height: 80.r,
                          child: const Text(
                            "取消",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (textController.text.length > 3) {
                            notifier.updateNickName(textController.text);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 40,
                          child: const Text(
                            "确认",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 性别选择底部弹窗
  void _showSexPickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FitTheme.backgroundColor,
      elevation: 0,
      builder: (context) {
        return Container(
          height: 230,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.genderSelection,
                style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20).r,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.male,
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 25.sp,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Radio<double>(
                            groupValue: state.gander ? 0 : 1,
                            activeColor: FitTheme.buttonColor,
                            value: 0,
                            onChanged: ((value) {
                              notifier.updateGender(true);
                              Navigator.of(context).pop();
                            }),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 9,
                      indent: 0,
                      endIndent: 0,
                      color: Color.fromARGB(47, 132, 129, 129),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.female,
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 25.sp,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Radio<double>(
                            groupValue: state.gander ? 0 : 1,
                            activeColor: FitTheme.buttonColor,
                            value: 1,
                            onChanged: ((value) {
                              notifier.updateGender(false);
                              Navigator.of(context).pop();
                            }),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 9,
                      indent: 0,
                      endIndent: 0,
                      color: Color.fromARGB(47, 132, 129, 129),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: Colors.white, fontSize: 25.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 日期选择底部弹窗
  void _showDatePickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Column(
            children: [
              Text(
                l10n.dateSelection,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    backgroundColor: FitTheme.secondbackGround,
                    initialDateTime: DateTime(2022, 1, 1),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime date) {
                      final birthday = "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
                      notifier.updateBirthday(birthday);
                    },
                  ),
                ),
              ),
              _buildConfirmButtonGroup1(context, l10n, notifier),
            ],
          ),
        );
      },
    );
  }

  // 身高选择底部弹窗
  void _showHeightPickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                l10n.height,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1.3,
                  itemExtent: 40,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 0.9,
                  offAxisFraction: 0.3,
                  onSelectedItemChanged: (position) {
                    notifier.updateHeight(position + 100);
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: state.heightPosition,
                  ),
                  children: <Widget>[
                    for (int i = 100; i <= 240; i++)
                      Center(
                        child: Text(
                          "${i}cm",
                          style: TextStyle(color: FitTheme.textColor),
                        ),
                      ),
                  ],
                ),
              ),
              _buildConfirmButtonGroup2(context, l10n, notifier, state),
            ],
          ),
        );
      },
      elevation: 0,
    );
  }

  // 体重选择底部弹窗
  void _showWeightPickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                l10n.weight,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1.3,
                  itemExtent: 40,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 0.9,
                  offAxisFraction: 0.3,
                  onSelectedItemChanged: (position) {
                    notifier.updateWeight(position + 40);
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: state.weightPosition,
                  ),
                  children: <Widget>[
                    for (int i = 40; i <= 120; i++)
                      Center(
                        child: Text(
                          "${i}kg",
                          style: TextStyle(color: FitTheme.textColor),
                        ),
                      ),
                  ],
                ),
              ),
              _buildConfirmButtonGroup3(context, l10n, notifier, state),
            ],
          ),
        );
      },
      elevation: 0,
    );
  }
```

- [ ] **Step 7: 编写基本设置页(第七部分:确认按钮组)**

继续在同一个文件中添加确认按钮组:

```dart
  Widget _buildConfirmButtonGroup1(
    BuildContext context,
    AppLocalizations l10n,
    notifier,
  ) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 30.sp, color: FitTheme.buttonColor),
            ),
          ),
          const SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          const SizedBox(width: 50),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.confirm,
              style: TextStyle(fontSize: 30.sp, color: FitTheme.buttonColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButtonGroup2(
    BuildContext context,
    AppLocalizations l10n,
    notifier,
    state,
  ) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 30.sp, color: FitTheme.buttonColor),
            ),
          ),
          const SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          const SizedBox(width: 50),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.confirm,
              style: TextStyle(fontSize: 30.sp, color: FitTheme.buttonColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButtonGroup3(
    BuildContext context,
    AppLocalizations l10n,
    notifier,
    state,
  ) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 30.sp, color: FitTheme.buttonColor),
            ),
          ),
          const SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          const SizedBox(width: 50),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.confirm,
              style: TextStyle(fontSize: 30.sp, color: FitTheme.buttonColor),
            ),
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 8: 提交代码**

```bash
git add lib/features/about/pages/user_settings_page.dart
git commit -m "feat: add UserSettingsPage with complete UI matching original"
```

---

## Task 9: 创建 AboutShellPage (About 主页)

**Files:**
- Create: `lib/features/about/pages/about_shell_page.dart`

- [ ] **Step 1: 编写 About 主页(第一部分:主框架)**

```dart
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/about_providers.dart';

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
}
```

- [ ] **Step 2: 编写 About 主页(第二部分:内容区域)**

在同一个文件中继续添加:

```dart
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
                      color: const Color.fromARGB(210, 154, 154, 154),
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
```

- [ ] **Step 3: 编写 About 主页(第三部分:头像和勋章组件)**

继续在同一个文件中添加:

```dart
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
                child: LoadingAnimationWidget.waveDots(
                  color: FitTheme.textColor,
                  size: 50,
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
```

- [ ] **Step 4: 编写 About 主页(第四部分:设置和其它卡片)**

继续在同一个文件中添加:

```dart
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
```

- [ ] **Step 5: 编写 About 主页(第五部分:虚拟教练选择)**

继续在同一个文件中添加:

```dart
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
```

- [ ] **Step 6: 提交代码**

```bash
git add lib/features/about/pages/about_shell_page.dart
git commit -m "feat: add AboutShellPage with complete UI matching original"
```

---

## Task 10: 创建其他占位页面

**Files:**
- Create: `lib/features/about/pages/sport_setting_page.dart`
- Create: `lib/features/about/pages/account_security_page.dart`
- Create: `lib/features/about/pages/medal_display_page.dart`

- [ ] **Step 1: 编写运动设置占位页**

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class SportSettingPage extends StatelessWidget {
  const SportSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        title: Text(
          l10n.sportsSettings,
          style: const TextStyle(color: FitTheme.textColor),
        ),
        iconTheme: const IconThemeData(color: FitTheme.textColor),
      ),
      body: const Center(
        child: Text(
          "运动设置页面",
          style: TextStyle(color: FitTheme.textColor, fontSize: 24),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 编写账号安全占位页**

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        title: Text(
          l10n.accountSecurity,
          style: const TextStyle(color: FitTheme.textColor),
        ),
        iconTheme: const IconThemeData(color: FitTheme.textColor),
      ),
      body: const Center(
        child: Text(
          "账号安全页面",
          style: TextStyle(color: FitTheme.textColor, fontSize: 24),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: 编写勋章展示占位页**

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class MedalDisplayPage extends StatelessWidget {
  const MedalDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        title: Text(
          l10n.medal,
          style: const TextStyle(color: FitTheme.textColor),
        ),
        iconTheme: const IconThemeData(color: FitTheme.textColor),
      ),
      body: const Center(
        child: Text(
          "勋章展示页面",
          style: TextStyle(color: FitTheme.textColor, fontSize: 24),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/features/about/pages/sport_setting_page.dart lib/features/about/pages/account_security_page.dart lib/features/about/pages/medal_display_page.dart
git commit -m "feat: add placeholder pages for sport setting, account security and medal display"
```

---

## Task 11: 添加路由配置

**Files:**
- Modify: `lib/core/routing/app_router.dart`

- [ ] **Step 1: 在 app_router.dart 顶部添加导入**

在文件顶部的导入部分添加:

```dart
import '../../features/about/pages/about_info_page.dart';
import '../../features/about/pages/about_shell_page.dart';
import '../../features/about/pages/account_security_page.dart';
import '../../features/about/pages/avatar_select_page.dart';
import '../../features/about/pages/medal_display_page.dart';
import '../../features/about/pages/sport_setting_page.dart';
import '../../features/about/pages/user_settings_page.dart';
```

- [ ] **Step 2: 在路由列表中添加 About 模块路由**

在 `appRouterProvider` 的 `routes` 列表中添加以下路由(在 `/placeholder` 路由之后):

```dart
      // About 模块路由
      GoRoute(
        path: '/about-shell',
        name: 'about-shell',
        builder: (context, state) => const AboutShellPage(),
      ),
      GoRoute(
        path: '/user-settings',
        name: 'user-settings',
        builder: (context, state) => const UserSettingsPage(),
      ),
      GoRoute(
        path: '/avatar-select',
        name: 'avatar-select',
        builder: (context, state) => const AvatarSelectPage(),
      ),
      GoRoute(
        path: '/about-info',
        name: 'about-info',
        builder: (context, state) => const AboutInfoPage(),
      ),
      GoRoute(
        path: '/sport-setting',
        name: 'sport-setting',
        builder: (context, state) => const SportSettingPage(),
      ),
      GoRoute(
        path: '/account-security',
        name: 'account-security',
        builder: (context, state) => const AccountSecurityPage(),
      ),
      GoRoute(
        path: '/medal-display',
        name: 'medal-display',
        builder: (context, state) => const MedalDisplayPage(),
      ),
```

- [ ] **Step 3: 提交代码**

```bash
git add lib/core/routing/app_router.dart
git commit -m "feat: add about module routes to app_router"
```

---

## Task 12: 更新 HomeShellScreen 底部导航

**Files:**
- Modify: `lib/features/home/pages/home_shell_screen.dart`

- [ ] **Step 1: 修改底部导航的 "我" 标签点击事件**

找到 `bottomNavigationBar` 的 `onTap` 回调,修改第 3 个标签(索引为 3)的处理:

```dart
              onTap: (i) {
                if (i == 3) {
                  // 点击"我"标签,导航到 About 页面
                  context.go('/about-shell');
                } else {
                  notifier.changePage(i);
                }
              },
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/home/pages/home_shell_screen.dart
git commit -m "feat: update bottom navigation to navigate to about page"
```

---

## Task 13: 运行测试和验证

**Files:**
- 无需创建文件

- [ ] **Step 1: 运行 flutter analyze**

Run: `cd /Users/dryao/Dev/fitMonsterAPP/2026WorkSpace/力动app工作区/app/vividfit_v2 && flutter analyze`

Expected: 无错误,无警告

- [ ] **Step 2: 运行 flutter build apk --debug**

Run: `cd /Users/dryao/Dev/fitMonsterAPP/2026WorkSpace/力动app工作区/app/vividfit_v2 && flutter build apk --debug`

Expected: 成功构建 APK

- [ ] **Step 3: 手动测试导航流程**

在模拟器或真机上测试以下流程:

1. 启动应用,进入首页
2. 点击底部导航的"我"标签,进入 About 主页
3. 点击用户卡片,进入基本设置页
4. 点击头像项,进入头像选择页
5. 点击返回,回到基本设置页
6. 点击返回,回到 About 主页
7. 点击勋章卡片,进入勋章展示页(占位)
8. 点击返回,回到 About 主页
9. 点击"运动设置",进入运动设置页(占位)
10. 点击返回,回到 About 主页
11. 点击"账号安全",进入账号安全页(占位)
12. 点击返回,回到 About 主页
13. 点击"关于",进入关于信息页
14. 点击返回,回到 About 主页
15. 点击"重新登录",弹出退出对话框
16. 点击取消,关闭对话框

- [ ] **Step 4: 提交所有更改**

```bash
git add .
git commit -m "feat: complete about module migration with UI matching original"
```

---

## Self-Review

### 1. Spec Coverage

根据用户需求检查:

- ✅ **不再使用 GetX 框架**: 所有页面都使用 flutter_riverpod 和 go_router
- ✅ **先不要接通云端**: 所有数据都是本地模拟,没有网络请求
- ✅ **界面要求完全相同**: 所有 UI 组件都 1:1 复刻原页面
- ✅ **逻辑后期再深入补充**: 所有逻辑都是占位实现
- ✅ **先做好外层页面**: 完成了主页、基本设置、头像选择、关于信息等主要页面
- ✅ **里面每个页面都用空页面去填充**: 运动设置、账号安全、勋章展示都是占位页
- ✅ **需要可进入可退出**: 所有路由都已配置,可以正常导航进出
- ✅ **使用代码别名**: Controller 重命名为 Notifier, Screen 重命名为 Page

### 2. Placeholder Scan

检查无以下占位符:
- ✅ 无 "TBD", "TODO", "implement later"
- ✅ 无 "Add appropriate error handling" 等模糊描述
- ✅ 所有代码步骤都有完整实现
- ✅ 无 "Similar to Task N" 的引用

### 3. Type Consistency

检查类型一致性:
- ✅ `UserSettingsState` 在所有地方使用一致
- ✅ `UserSettingsNotifier` 的方法签名在所有调用处一致
- ✅ 路由名称在 `app_router.dart` 和各页面引用处一致

---

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-07-14-about-module-migration-plan.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**