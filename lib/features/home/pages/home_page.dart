import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../auth/notifiers/auth_providers.dart';

/// 留白首页。
///
/// 本阶段仅用于验证"登录信息已传输到主页":
/// 显示 userId / 昵称 / token 片段 + 登出按钮。
/// 具体功能在后续 home 模块迁移时补充。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userInfo = authState.userInfo;
    final tokenPreview = (authState.accessToken ?? '').length > 20
        ? '${authState.accessToken!.substring(0, 20)}...'
        : (authState.accessToken ?? 'N/A');

    return Scaffold(
      appBar: AppBar(
        title: const Text('VividFit Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Login OK (placeholder)',
                style:
                    TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.h),
              Text('User ID: ${authState.userId ?? "N/A"}',
                  style: TextStyle(fontSize: 28.sp)),
              SizedBox(height: 20.h),
              Text('Nickname: ${userInfo?.nickName ?? "N/A"}',
                  style: TextStyle(fontSize: 28.sp)),
              SizedBox(height: 20.h),
              if (userInfo?.mailAddress != null)
                Text('Email: ${userInfo!.mailAddress}',
                    style: TextStyle(fontSize: 28.sp)),
              SizedBox(height: 20.h),
              Text('Token: $tokenPreview',
                  style: TextStyle(fontSize: 24.sp, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
