import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';

/// 单车游戏页1（对应旧 big_device_bike_game.dart）
class GymBikeGameScreen extends ConsumerWidget {
  const GymBikeGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Bike',
      gameIndex: 1,
    );
  }
}

/// 单车游戏页2（对应旧 bike_device_bike_game2.dart）
class GymBikeGame2Screen extends ConsumerWidget {
  const GymBikeGame2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Bike',
      gameIndex: 2,
    );
  }
}

/// 单车实景页（对应旧 big_device_realscene_screen.dart - bike）
class GymBikeRealsceneScreen extends ConsumerWidget {
  const GymBikeRealsceneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Bike',
      gameIndex: 0,
      isRealscene: true,
    );
  }
}

/// 跑步机游戏页1（对应旧 big_device_treadmill_game.dart）
class GymTreadmillGameScreen extends ConsumerWidget {
  const GymTreadmillGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Treadmill',
      gameIndex: 1,
    );
  }
}

/// 跑步机游戏页2（对应旧 big_device_treadmill_game2.dart）
class GymTreadmillGame2Screen extends ConsumerWidget {
  const GymTreadmillGame2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Treadmill',
      gameIndex: 2,
    );
  }
}

/// 跑步机实景页（对应旧 big_device_realscene_screen.dart - treadmill）
class GymTreadmillRealsceneScreen extends ConsumerWidget {
  const GymTreadmillRealsceneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Treadmill',
      gameIndex: 0,
      isRealscene: true,
    );
  }
}

/// 椭圆机游戏页1（对应旧 big_device_cross_trainer_game.dart）
class GymEllipticalGameScreen extends ConsumerWidget {
  const GymEllipticalGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Elliptical',
      gameIndex: 1,
    );
  }
}

/// 椭圆机游戏页2（对应旧 big_device_cross_trainer_game2.dart）
class GymEllipticalGame2Screen extends ConsumerWidget {
  const GymEllipticalGame2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Elliptical',
      gameIndex: 2,
    );
  }
}

/// 椭圆机实景页（对应旧 big_device_realscene_screen.dart - cross_trainer）
class GymEllipticalRealsceneScreen extends ConsumerWidget {
  const GymEllipticalRealsceneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Elliptical',
      gameIndex: 0,
      isRealscene: true,
    );
  }
}

/// 划船机游戏页1（对应旧 big_device_rower_game.dart）
class GymRowerGameScreen extends ConsumerWidget {
  const GymRowerGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Rower',
      gameIndex: 1,
    );
  }
}

/// 划船机游戏页2（对应旧 big_device_rower_game2.dart）
class GymRowerGame2Screen extends ConsumerWidget {
  const GymRowerGame2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Rower',
      gameIndex: 2,
    );
  }
}

/// 划船机实景页（对应旧 big_device_realscene_screen.dart - rower）
class GymRowerRealsceneScreen extends ConsumerWidget {
  const GymRowerRealsceneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DeviceGameScreen(
      deviceType: 'Rower',
      gameIndex: 0,
      isRealscene: true,
    );
  }
}

/// 通用设备游戏界面组件
class _DeviceGameScreen extends ConsumerWidget {
  final String deviceType;
  final int gameIndex;
  final bool isRealscene;

  const _DeviceGameScreen({
    required this.deviceType,
    required this.gameIndex,
    this.isRealscene = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 实现游戏逻辑
    // - 游戏画面渲染
    // - 设备数据监听
    // - 游戏控制

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 游戏画面
            Positioned.fill(
              child: Container(
                color: Colors.grey.shade900,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isRealscene ? Icons.landscape : Icons.videogame_asset,
                        size: 100.sp,
                        color: FitTheme.textColor,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        '$deviceType ${isRealscene ? 'Realscene' : 'Game $gameIndex'}',
                        style: TextStyle(
                          color: FitTheme.textColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Game content placeholder',
                        style: TextStyle(
                          color: FitTheme.textColor.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 顶部数据栏
            Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              child: _buildTopDataBar(),
            ),
            // 返回按钮
            Positioned(
              top: 20.h,
              right: 20.w,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 32.sp),
                onPressed: () => _showExitDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDataBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDataItem('Time', '00:00:00'),
          _buildDataItem('Distance', '0.00 km'),
          _buildDataItem('Calories', '0 kcal'),
          _buildDataItem('Speed', '0.0 km/h'),
          _buildDataItem('HeartRate', '-- bpm'),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Exit Game', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to exit?',
          style: TextStyle(color: Colors.white),
        ),
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
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}