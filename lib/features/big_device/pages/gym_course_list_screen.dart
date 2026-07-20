import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import 'gym_course_detail_screen.dart';

/// 课程列表页（对应旧 big_device_sec_screen.dart）
class GymCourseListScreen extends ConsumerWidget {
  const GymCourseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 实现课程列表逻辑
    // - 获取课程分类列表
    // - 课程卡片展示
    // - 点击进入课程详情

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
              top: 50.h,
              left: 20.w,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // 课程列表
            Positioned(
              top: 160.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(25.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 课程分类标题
                    Text(
                      'Course List',
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // 课程网格
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 2 / 1,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          return _buildCourseCard(context, index);
                        },
                      ),
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

  Widget _buildCourseCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        // TODO: 进入课程详情
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const GymCourseDetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: FitTheme.secondbackGround,
          borderRadius: BorderRadius.circular(11.r),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 课程封面（暂用占位）
            Container(
              color: Colors.grey.shade800,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center, color: FitTheme.textColor, size: 40.sp),
                    SizedBox(height: 10.h),
                    Text(
                      'Course ${index + 1}',
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 14.sp,
                      ),
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
}