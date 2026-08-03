import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../l10n/app_localizations.dart';

/// 课程详情页（对应旧 big_device_course_detail_screen.dart）
class GymCourseDetailScreen extends ConsumerWidget {
  final String courseId;
  final FtmsDeviceType deviceType;

  const GymCourseDetailScreen({
    super.key,
    required this.courseId,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // TODO: 实现课程详情逻辑
    // - 课程图片展示
    // - 课程描述、建议、注意事项
    // - 动作列表
    // - 下载进度条
    // - 进入课程按钮

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        body: Stack(
          children: [
            // 背景图
            Positioned.fill(
              child: Image.asset(
                'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/big_device_background.jpg',
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Container(color: Colors.black),
              ),
            ),
            // 返回按钮
            Positioned(
              top: 40.h,
              left: 10.w,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // 主内容
            Positioned(
              top: 160.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        // 课程图片
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.w),
                            decoration: BoxDecoration(
                              color: FitTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Center(
                              child: Text(l10n.courseImage),
                            ),
                          ),
                        ),
                        // 课程信息
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10.r),
                            child: ListView(
                              children: [
                                Text(
                                  l10n.courseDescription,
                                  style: TextStyle(
                                    color: FitTheme.textColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  l10n.courseDetailsPlaceholder,
                                  style: TextStyle(
                                    color: FitTheme.textColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 动作列表
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150.w,
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              color: FitTheme.secondbackGround,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text('${l10n.action} ${index + 1}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // 底部按钮
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FitTheme.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          minimumSize: Size(300.w, 80.h),
                        ),
                        onPressed: () {
                          context.push('/gym-device-play', extra: {
                            'courseId': courseId,
                            'deviceType': deviceType,
                          });
                        },
                        child: Text(
                          l10n.entryCourse,
                          style: TextStyle(
                            color: FitTheme.textButtonColor,
                            fontSize: FitTheme.fonSizeBig,
                          ),
                        ),
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
  }
}