import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/user_settings_notifier.dart';
import '../states/user_settings_state.dart';

class UserSettingsPage extends ConsumerStatefulWidget {
  const UserSettingsPage({super.key});

  @override
  ConsumerState<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends ConsumerState<UserSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userSettingsProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsProvider);
    final notifier = ref.read(userSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 300,
        toolbarHeight: 80.h,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: FitTheme.textColor),
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

  Widget _buildListUserInfo(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAvatarRow(context, ref, l10n, state, notifier),
            _buildOtherColumn(context, ref, l10n, state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarRow(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        context.push('/avatar-select');
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
          top: 15,
          bottom: 15,
        ).r,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: FitTheme.secondbackGround,
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Row(
          children: [
            state.isLoading
                ? Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: FitTheme.buttonColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : _buildAvatarWidget(state),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Text(
                l10n.avatar,
                style: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 28.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(UserSettingsState state) {
    // headImage 为服务器返回的完整 URL,直接使用,无需拼接
    final hasCustomAvatar = state.headImage.isNotEmpty;
    print('🖼️ [UserSettings] render avatar headImage="${state.headImage}"');
    final defaultAvatar = Image.asset(
      "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "images/newUIScreen/defaultheadimages/deheadImage1.jpg",
          fit: BoxFit.cover,
        );
      },
    );
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle),
      height: 60.r,
      width: 60.r,
      clipBehavior: Clip.hardEdge,
      child: hasCustomAvatar
          ? CachedNetworkImage(
              imageUrl: state.headImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => defaultAvatar,
              errorWidget: (context, url, error) {
                print('❌ [UserSettings] avatar load failed: $url error=$error');
                return defaultAvatar;
              },
            )
          : defaultAvatar,
    );
  }

  Widget _buildOtherColumn(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20).r,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 10,
      ).r,
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNameCreatWidget(context, ref, l10n, state, notifier),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          _buildSexPickerWidget(context, ref, l10n, state, notifier),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          _buildBirthdayPickWidget(context, ref, l10n, state, notifier),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          _buildHeightPickerWidget(context, ref, l10n, state, notifier),
          const Divider(color: Color.fromARGB(167, 34, 34, 34), indent: 10),
          _buildWeightPickerWidget(context, ref, l10n, state, notifier),
          SizedBox(height: 10.r),
        ],
      ),
    );
  }

  Widget _buildNameCreatWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showNickNameDialog(context, ref, l10n, state, notifier);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_0.png",
                color: FitTheme.buttonColor,
                width: 28.r,
                height: 28.r,
              ),
            ),
            Text(
              l10n.nickname,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.nickName,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 28.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSexPickerWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showSexPickerBottomSheet(context, ref, l10n, state, notifier);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_4.png",
                color: FitTheme.buttonColor,
                width: 28.r,
                height: 28.r,
              ),
            ),
            Text(
              l10n.gender,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.gander ? l10n.male : l10n.female,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 28.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthdayPickWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showDatePickerBottomSheet(context, ref, l10n, state, notifier);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_2.png",
                color: FitTheme.buttonColor,
                width: 28.r,
                height: 28.r,
              ),
            ),
            Text(
              l10n.birthday,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.birthday,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 28.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightPickerWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showHeightPickerBottomSheet(context, ref, l10n, state, notifier);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_1.png",
                color: FitTheme.buttonColor,
                width: 28.r,
                height: 28.r,
              ),
            ),
            Text(
              l10n.height,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.bodyHeight.toString(),
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 28.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightPickerWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showWeightPickerBottomSheet(context, ref, l10n, state, notifier);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10).r,
              child: Image.asset(
                "images/newUIScreen/icons/icon_about_head_3.png",
                color: FitTheme.buttonColor,
                width: 28.r,
                height: 28.r,
              ),
            ),
            Text(
              l10n.weight,
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            const Spacer(),
            Text(
              state.bodyWeight.toString(),
              style: TextStyle(fontSize: 28.sp, color: FitTheme.textColor),
            ),
            SizedBox(width: 20.r),
            Icon(
              Icons.arrow_forward_ios,
              size: 28.sp,
              color: FitTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  // ---- 统一弹窗规范：参照 body_data_page.dart ----
  // backgroundColor: Colors.transparent
  // height: 280, margin: all(10), padding: symmetric(h:10, v:5)
  // 白色背景 borderRadius 10, 标题居中 fontSize 20 bold
  // CupertinoPicker: offAxisFraction: 0, diameterRatio: 1.0

  void _showNickNameDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    final textController = TextEditingController(text: state.nickName);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            height: 280,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: FitTheme.secondbackGround,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(height: 15.h),
                Text(
                  l10n.setNickName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    style: TextStyle(color: FitTheme.textColor, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: l10n
                          .theNicknameIsUsedToHideYourRealNameOtherUsersInTheSystemCanSeeYourNickname,
                      hintStyle: TextStyle(
                        color: FitTheme.textColor.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FitTheme.buttonColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FitTheme.buttonColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                _buildButtonGroup(
                  l10n,
                  onCancel: () => Navigator.pop(ctx),
                  onConfirm: () {
                    final name = textController.text.trim();
                    if (name.isNotEmpty && name.length > 1) {
                      print('🎯 [UserSettings] update nickname: $name');
                      notifier.updateNickName(name);
                    }
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSexPickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSettingsState state,
    notifier,
  ) {
    final currentSex = state.gander;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Text(
                l10n.genderSelection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RadioGroup<int>(
                    groupValue: currentSex ? 0 : 1,
                    onChanged: (int? value) {
                      if (value == 0) {
                        print('🎯 [UserSettings] select gender: male');
                        notifier.updateGender(true);
                      } else {
                        print('🎯 [UserSettings] select gender: female');
                        notifier.updateGender(false);
                      }
                      Navigator.pop(ctx);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSexRadioRow(l10n.male, 0),
                        const Divider(
                          height: 9,
                          color: Color.fromARGB(47, 132, 129, 129),
                        ),
                        _buildSexRadioRow(l10n.female, 1),
                      ],
                    ),
                  ),
                ),
              ),
              _buildButtonGroup(
                l10n,
                onCancel: () => Navigator.pop(ctx),
                onConfirm: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSexRadioRow(String label, int value) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: FitTheme.textColor, fontSize: 18),
            ),
            SizedBox(
              height: 24,
              width: 24,
              child: Radio<int>(
                value: value,
                fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return FitTheme.buttonColor;
                  }
                  return null;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    // 解析当前生日
    DateTime initialDate = DateTime(2000, 1, 1);
    try {
      final parts = state.birthday.split('-');
      if (parts.length == 3) {
        initialDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (_) {}

    DateTime selectedDate = initialDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Text(
                l10n.dateSelection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    backgroundColor: FitTheme.secondbackGround,
                    initialDateTime: initialDate,
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime date) {
                      selectedDate = date;
                    },
                  ),
                ),
              ),
              _buildButtonGroup(
                l10n,
                onCancel: () => Navigator.pop(ctx),
                onConfirm: () {
                  final birthday =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")}";
                  print('🎯 [UserSettings] update birthday: $birthday');
                  notifier.updateBirthday(birthday);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHeightPickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    final initialPosition = state.heightPosition;
    int tempPosition = initialPosition;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Text(
                l10n.height,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: FitTheme.secondbackGround,
                  squeeze: 1.2,
                  itemExtent: 40,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 1.0,
                  offAxisFraction: 0,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialPosition,
                  ),
                  onSelectedItemChanged: (p) => tempPosition = p,
                  children: [
                    for (int i = 100; i <= 240; i++)
                      Center(
                        child: Text(
                          '${i}cm',
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildButtonGroup(
                l10n,
                onCancel: () {
                  print('🎯 [UserSettings] height cancel, rollback');
                  Navigator.pop(ctx);
                },
                onConfirm: () {
                  final height = tempPosition + 100;
                  print('🎯 [UserSettings] confirm height: $height');
                  notifier.updateHeight(height);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWeightPickerBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    notifier,
  ) {
    final initialPosition = state.weightPosition;
    int tempPosition = initialPosition;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Text(
                l10n.weight,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: FitTheme.secondbackGround,
                  squeeze: 1.2,
                  itemExtent: 40,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 1.0,
                  offAxisFraction: 0,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialPosition,
                  ),
                  onSelectedItemChanged: (p) => tempPosition = p,
                  children: [
                    for (int i = 40; i <= 200; i++)
                      Center(
                        child: Text(
                          '${i}kg',
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildButtonGroup(
                l10n,
                onCancel: () {
                  print('🎯 [UserSettings] weight cancel, rollback');
                  Navigator.pop(ctx);
                },
                onConfirm: () {
                  final weight = tempPosition + 40;
                  print('🎯 [UserSettings] confirm weight: $weight');
                  notifier.updateWeight(weight);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtonGroup(
    AppLocalizations l10n, {
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onCancel,
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 18, color: FitTheme.buttonColor),
            ),
          ),
          const SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          const SizedBox(width: 50),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onConfirm,
            child: Text(
              l10n.confirm,
              style: TextStyle(fontSize: 18, color: FitTheme.buttonColor),
            ),
          ),
        ],
      ),
    );
  }
}
