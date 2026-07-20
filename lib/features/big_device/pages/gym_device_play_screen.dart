import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设备运动播放页（对应旧 big_device_play_screen.dart）
/// 
/// 支持 4 种设备类型：
/// - Bike (单车)
/// - Treadmill (跑步机)
/// - Elliptical (椭圆机)
/// - Rower (划船机)
class GymDevicePlayScreen extends ConsumerWidget {
  const GymDevicePlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 实现运动播放逻辑
    // - 设备连接状态监听
    // - 运动数据展示（时间、距离、卡路里、心率等）
    // - 课程动作图片播放
    // - 速度/阻力/坡度控制
    // - 暂停/继续/结束控制

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // 顶部数据栏
              Positioned(
                top: 40.h,
                left: 140.w,
                right: 20.w,
                child: _buildTopDataBar(context),
              ),
              // 左侧课程信息
              Positioned(
                top: 50.h,
                left: 20.w,
                child: _buildLeftInfo(context),
              ),
              // 中央动作展示区域
              Positioned(
                top: 200.h,
                bottom: 200.h,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Text('Course Action Image'),
                  ),
                ),
              ),
              // 底部进度条
              Positioned(
                bottom: 50.h,
                left: 20.w,
                right: 20.w,
                child: _buildProgressBar(context),
              ),
              // 返回按钮
              Positioned(
                top: 100.h,
                right: 25.w,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                  onPressed: () => _showExitDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDataBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDataItem(context, 'Time', '00:00:00'),
        _buildDataItem(context, 'Distance', '0.00'),
        _buildDataItem(context, 'Calories', '0.0'),
        _buildDataItem(context, 'Speed', '0.0'),
        _buildDataItem(context, 'HeartRate', '--'),
      ],
    );
  }

  Widget _buildDataItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLeftInfo(BuildContext context) {
    return Container(
      width: 140.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Title',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Current Set: 1/10',
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            'Action Name',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Container(
      height: 100.h,
      child: Row(
        children: List.generate(10, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notice'),
        content: const Text('Confirm exit course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}