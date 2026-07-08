import 'package:flutter/material.dart';

/// 占位页:所有未迁移模块的跳转目标。
///
/// 进入时在控制台打印目标名称,UI 显示"功能开发中"。
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.targetName});

  final String targetName;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('[PlaceholderPage] navigate to: $targetName');
    return Scaffold(
      appBar: AppBar(title: Text(targetName)),
      body: const Center(
        child: Text('功能开发中(占位页)'),
      ),
    );
  }
}
