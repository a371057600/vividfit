import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ftms/ftms_device_type.dart';
import 'game_webview_scaffold.dart';
import 'realscene_webview_scaffold.dart';

/// 单车游戏页1（对应旧 big_device_bike_game.dart）
class GymBikeGameScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymBikeGameScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 1);
  }
}

/// 单车游戏页2（对应旧 bike_device_bike_game2.dart）
class GymBikeGame2Screen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymBikeGame2Screen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 2);
  }
}

/// 单车实景页（对应旧 big_device_realscene_screen.dart - bike）
class GymBikeRealsceneScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymBikeRealsceneScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RealsceneWebViewScaffold(deviceType: deviceType);
  }
}

/// 跑步机游戏页1（对应旧 big_device_treadmill_game.dart）
class GymTreadmillGameScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymTreadmillGameScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 1);
  }
}

/// 跑步机游戏页2（对应旧 big_device_treadmill_game2.dart）
class GymTreadmillGame2Screen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymTreadmillGame2Screen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 2);
  }
}

/// 跑步机实景页（对应旧 big_device_realscene_screen.dart - treadmill）
class GymTreadmillRealsceneScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymTreadmillRealsceneScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RealsceneWebViewScaffold(deviceType: deviceType);
  }
}

/// 椭圆机游戏页1（对应旧 big_device_cross_trainer_game.dart）
class GymEllipticalGameScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymEllipticalGameScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 1);
  }
}

/// 椭圆机游戏页2（对应旧 big_device_cross_trainer_game2.dart）
class GymEllipticalGame2Screen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymEllipticalGame2Screen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 2);
  }
}

/// 椭圆机实景页（对应旧 big_device_realscene_screen.dart - cross_trainer）
class GymEllipticalRealsceneScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymEllipticalRealsceneScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RealsceneWebViewScaffold(deviceType: deviceType);
  }
}

/// 划船机游戏页1（对应旧 big_device_rower_game.dart）
class GymRowerGameScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymRowerGameScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 1);
  }
}

/// 划船机游戏页2（对应旧 big_device_rower_game2.dart）
class GymRowerGame2Screen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymRowerGame2Screen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWebViewScaffold(deviceType: deviceType, gameIndex: 2);
  }
}

/// 划船机实景页（对应旧 big_device_realscene_screen.dart - rower）
class GymRowerRealsceneScreen extends ConsumerWidget {
  final FtmsDeviceType deviceType;
  const GymRowerRealsceneScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RealsceneWebViewScaffold(deviceType: deviceType);
  }
}