import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 记录模块统一空状态占位组件。
///
/// 用于列表为空、数据加载失败等场景，提供插画 + 文案 + 可选操作按钮。
/// 网络请求未实装阶段，所有空页面统一使用本组件呈现"暂无数据"。
class EmptyDataWidget extends StatelessWidget {
  final String message;
  final String? iconPath;
  final Widget? actionButton;

  const EmptyDataWidget({
    super.key,
    required this.message,
    this.iconPath,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null)
              Image.asset(
                iconPath!,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.inbox_outlined,
                  size: 120.r,
                  color: Colors.grey,
                ),
              )
            else
              Icon(
                Icons.inbox_outlined,
                size: 120.r,
                color: Colors.grey,
              ),
            SizedBox(height: 30.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null) ...[
              SizedBox(height: 30.h),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
