import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../data/models/course_list.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/course_list_notifier.dart';
import '../states/course_list_state.dart';

/// 课程列表页（1:1 还原原 new_course_list_homepage.dart + new_course_list_screen.dart）。
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseListNotifierProvider);
    final notifier = ref.read(courseListNotifierProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 100.r,
        foregroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        backgroundColor: FitTheme.backgroundColor,
        leadingWidth: 300,
        leading: Container(
          padding: const EdgeInsets.only(left: 45).r,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.pop(),
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
                    size: 20,
                  ),
                ),
                Text(
                  l10n.courses,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontFamily: AppFonts.hofontmedium,
                    fontSize: 40.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Card(
        color: FitTheme.secondbackGround,
        margin: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25)
            .r,
        child: SizedBox(
          height: 1600.h,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 25).r,
                width: 195.w,
                height: 1400.h,
                child: _buildLeftContent(state, notifier),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20).r,
                  height: 1400.h,
                  child: Column(
                    children: [
                      Container(
                        height: 80.h,
                        padding: const EdgeInsets.only(bottom: 13).r,
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 20).r,
                          child: Text(
                            l10n.courses,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontFamily: AppFonts.hofontregular,
                              fontSize: 30.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildRightContent(context, ref, state, notifier),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftContent(CourseListState state, CourseListNotifier notifier) {
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
                    state.showDeviceNameList[index],
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

  Widget _buildRightContent(
    BuildContext context,
    WidgetRef ref,
    CourseListState state,
    CourseListNotifier notifier,
  ) {
    if (state.isLoading || state.courseDataMap[state.deviceType] == null) {
      return InkWell(
        onTap: () => notifier.getCourseList(),
        child: Container(
          alignment: Alignment.center,
          child: LoadingAnimationWidget.discreteCircle(
            color: FitTheme.textColor,
            size: 100.r,
          ),
        ),
      );
    }

    final dataList =
        state.courseDataMap[state.deviceType]!.data?.dataList ?? [];

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (_, index) {
        final item = dataList[index];
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (!state.isLoading) {
              _gotoDetail(context, item, index);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 25).r,
            color: FitTheme.textColor,
            child: ExtendedImage.asset(
              'images/newUIScreen/courseImage/$index.jpg',
              fit: BoxFit.fitWidth,
              loadStateChanged: (ExtendedImageState imageState) {
                switch (imageState.extendedImageLoadState) {
                  case LoadState.loading:
                    return Container(
                      height: 200.h,
                      alignment: Alignment.center,
                      child: LoadingAnimationWidget.waveDots(
                        color: FitTheme.textColor,
                        size: 50,
                      ),
                    );
                  case LoadState.failed:
                    return Center(
                      child: Text(
                        'No Picture',
                        style: TextStyle(color: FitTheme.textColor),
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

  void _gotoDetail(BuildContext context, CourseItem item, int index) {
    context.push('/course-detail', extra: {
      'courseIndex': index,
      'courseTitle': item.title,
      'courseId': item.id,
      'courseCover': item.cover,
      'interactiveEquipment': item.interactiveEquipment,
      'version': item.version,
      'courseBGM': item.courseBgm,
      'proposal': item.proposal,
      'describe': item.describe,
      'carefulthing': item.carefulthing,
    });
  }
}
