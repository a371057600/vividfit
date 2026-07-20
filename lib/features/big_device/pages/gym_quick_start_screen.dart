import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 快速开始页（对应旧 big_device_quick_start_screen.dart）
class GymQuickStartScreen extends ConsumerStatefulWidget {
  const GymQuickStartScreen({super.key});

  @override
  ConsumerState<GymQuickStartScreen> createState() => _GymQuickStartScreenState();
}

class _GymQuickStartScreenState extends ConsumerState<GymQuickStartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 实现快速开始逻辑
    // - 设备类型判断（Bike/Treadmill/Elliptical/Rower）
    // - 实时数据图表
    // - 速度/阻力/坡度控制
    // - 音乐播放

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // 主界面
            _buildMainWidget(),
            // 顶部数据栏
            _buildTopDataBar(),
            // 播放按钮
            _buildPlayButton(),
            // 音乐按钮
            Positioned(
              left: 50.w,
              top: 50.h,
              child: _buildMusicButton(),
            ),
            // 返回按钮
            Positioned(
              right: 20.w,
              top: 50.h,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWidget() {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 45.w, top: 45.h, right: 45.w),
            height: 200.h,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(45.r),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _TrackPainter(_animation.value),
                    child: const Center(child: Text('Track Animation')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDataBar() {
    return Positioned(
      top: 25.h,
      left: 100.w,
      right: 80.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDataItem('Time', '00:00'),
          _buildDataItem('Distance', '0.00'),
          _buildDataItem('Calories', '0'),
          _buildDataItem('Speed', '0.0'),
          _buildDataItem('HeartRate', '--'),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(Icons.circle, size: 10.sp, color: Colors.white),
          SizedBox(width: 5.w),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: 开始/停止运动
        },
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(125),
            border: Border.all(color: Colors.white.withAlpha(125), width: 2),
          ),
          child: Icon(Icons.play_arrow, size: 60.w, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMusicButton() {
    return IconButton(
      icon: Icon(Icons.music_note, color: Colors.white, size: 30.sp),
      onPressed: () {
        // TODO: 播放/暂停音乐
      },
    );
  }
}

class _TrackPainter extends CustomPainter {
  final double progress;

  _TrackPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawOval(rect, paint);

    // 进度指示
    final progressPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final angle = progress * 2 * pi;
    canvas.drawArc(
      rect,
      -pi / 2,
      angle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TrackPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}