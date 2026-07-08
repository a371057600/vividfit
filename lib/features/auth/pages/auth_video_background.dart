import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 登录模块各页面共用的全屏静音循环视频背景。
///
/// 1:1 复刻旧项目每个登录子页 initState 里的视频初始化逻辑:
/// `VideoPlayerController.asset("assets/lidong.mp4")` + 循环 + 静音 + 全屏铺满。
/// 抽成共享组件以减少重复代码,视觉效果与旧页完全一致。
class AuthVideoBackground extends StatefulWidget {
  const AuthVideoBackground({super.key});

  @override
  State<AuthVideoBackground> createState() => _AuthVideoBackgroundState();
}

class _AuthVideoBackgroundState extends State<AuthVideoBackground> {
  late VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/lidong.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
