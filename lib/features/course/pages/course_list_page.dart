import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/course_list_notifier.dart';
import '../states/course_list_state.dart';

/// 课程列表页（1:1 还原原 new_course_list_homepage.dart，纯 UI 假页面）。
class CourseListPage extends ConsumerWidget {
  const CourseListPage({super.key});

  static const List<String> _whiteDeviceIcons = [
    'images/newUIScreen/icons/icon_new_device_white1.png',
    'images/newUIScreen/icons/icon_new_device_white6.png',
    'images/newUIScreen/icons/icon_new_device_white2.png',
    'images/newUIScreen/icons/icon_new_device_white3.png',
    'images/newUIScreen/icons/icon_new_device_white4.png',
    'images/newUIScreen/icons/icon_new_device_white5.png',
    'images/newUIScreen/icons/icon_game_white.png',
  ];

  static const List<String> _orangeDeviceIcons = [
    'images/newUIScreen/icons/icon_new_device_orange1.png',
    'images/newUIScreen/icons/icon_new_device_orange6.png',
    'images/newUIScreen/icons/icon_new_device_orange2.png',
    'images/newUIScreen/icons/icon_new_device_orange3.png',
    'images/newUIScreen/icons/icon_new_device_orange4.png',
    'images/newUIScreen/icons/icon_new_device_orange5.png',
    'images/newUIScreen/icons/icon_game_orange.png',
  ];

  static const List<String> _gripGameImages = [
    'images/newUIScreen/courseImage/game_grip_0_en.jpg',
    'images/newUIScreen/courseImage/game_grip_1_en.jpg',
    'images/newUIScreen/courseImage/game_armwresting_match.jpg',
  ];

  static const List<String> _allGameImages = [
    'images/newUIScreen/courseImage/game_grip_0_en.jpg',
    'images/newUIScreen/courseImage/game_grip_1_en.jpg',
    'images/newUIScreen/courseImage/game_armwresting_match.jpg',
    'images/newUIScreen/courseImage/game_skippingRope.jpg',
    'images/newUIScreen/courseImage/game_fun_tennis.jpg',
    'images/newUIScreen/courseImage/game_run_picture.jpg',
    'images/newUIScreen/courseImage/zombie_screen.jpg',
  ];

  /// 根据索引获取本地化设备名称
  String _deviceName(AppLocalizations l10n, int index) {
    return switch (index) {
      0 => l10n.deviceSkipping,
      1 => l10n.deviceGrip,
      2 => l10n.deviceDumbbell,
      3 => l10n.deviceAdjDumbbell,
      4 => l10n.devicePushUp,
      5 => l10n.deviceKettlebell,
      6 => l10n.deviceGame,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseListProvider);
    final notifier = ref.read(courseListProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: FitTheme.secondbackGround,
      margin: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25).r,
      child: SizedBox(
        height: 1600.h,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 25).r,
              width: 195.w,
              height: 1400.h,
              child: _buildLeftContent(state, notifier, l10n),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20).r,
                height: 1400.h,
                child: Column(
                  children: [
                    Container(height: 25.h),
                    Expanded(
                      child: _buildRightContent(state),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftContent(CourseListState state, CourseListNotifier notifier, AppLocalizations l10n) {
    return ListView.builder(
      itemCount: state.showDeviceNameList.length,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 60, right: 10).r,
          width: 160.w,
          alignment: Alignment.centerLeft,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => notifier.selectDeviceType(index),
            child: Row(
              children: [
                SizedBox(
                  height: 35.h,
                  width: 35.w,
                  child: Image.asset(
                    state.deviceType == index
                        ? _orangeDeviceIcons[index]
                        : _whiteDeviceIcons[index],
                    color: state.deviceType == index
                        ? FitTheme.buttonColor
                        : Colors.grey,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    _deviceName(l10n, index),
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: FitTheme.textColor,
                      fontFamily: AppFonts.hofontregular,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRightContent(CourseListState state) {
    switch (state.deviceType) {
      case 1:
        return _buildGameList(_gripGameImages);
      case 6:
        return _buildGameList(_allGameImages);
      default:
        return _buildMockCourseList();
    }
  }

  Widget _buildGameList(List<String> imagePaths) {
    return ListView(
      children: imagePaths.map((path) {
        return Card(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: Image.asset(path),
        );
      }).toList(),
    );
  }

  Widget _buildMockCourseList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        final imagePath = 'images/newUIScreen/courseImage/${index % 10}.jpg';
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 25).r,
            color: FitTheme.textColor,
            child: ExtendedImage.asset(
              imagePath,
              fit: BoxFit.fitWidth,
              loadStateChanged: (ExtendedImageState imageState) {
                switch (imageState.extendedImageLoadState) {
                  case LoadState.loading:
                    return Container(
                      height: 200.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: LoadingAnimationWidget.waveDots(
                        color: FitTheme.textColor,
                        size: 50,
                      ),
                    );
                  case LoadState.failed:
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: Colors.transparent,
                        size: 50,
                      ),
                    );
                  case LoadState.completed:
                    return ExtendedRawImage(
                      image: imageState.extendedImageInfo?.image,
                      width: 280,
                      fit: BoxFit.fill,
                    );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
