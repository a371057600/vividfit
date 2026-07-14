import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

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
                child: CircularProgressIndicator(
                  color: Colors.white,
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
          insetPadding: EdgeInsets.only(left: 45, right: 45).r,
          child: Container(
            padding: EdgeInsets.all(25).r,
            height: 400.r,
            width: 600.r,
            decoration: BoxDecoration(
              color: FitTheme.secondbackGround,
              borderRadius: BorderRadius.circular(40).r,
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
                  margin: EdgeInsets.only(left: 25, right: 25, top: 0).r,
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
                          child: Text(
                            l10n.cancel,
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
                          child: Text(
                            l10n.confirm,
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
                margin: EdgeInsets.only(top: 20).r,
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
                    Divider(
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
                margin: EdgeInsets.only(top: 20),
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
                    Divider(
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
              SizedBox(height: 20),
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
              _buildConfirmButtonGroup(context, l10n),
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
              SizedBox(height: 20),
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
              _buildConfirmButtonGroup(context, l10n),
            ],
          ),
        );
      },
      elevation: 0,
    );
  }

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
              SizedBox(height: 20),
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
              _buildConfirmButtonGroup(context, l10n),
            ],
          ),
        );
      },
      elevation: 0,
    );
  }

  Widget _buildConfirmButtonGroup(
    BuildContext context,
    AppLocalizations l10n,
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
          SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          SizedBox(width: 50),
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
}
