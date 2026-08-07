import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 全局通用透明背景 Loading 弹窗(替换旧 Get.defaultDialog)。
///
/// 用法:
/// ```dart
/// final ctx = showLoadingDialog(context);
/// try {
///   await someFuture();
/// } finally {
///   if (ctx.mounted) Navigator.of(ctx).pop();
/// }
/// ```
BuildContext showLoadingDialog(
  BuildContext context, {
  String? message,
  Color? bgColor,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: bgColor ?? Colors.black.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 30,
            ).r,
            constraints: BoxConstraints(
              minWidth: 240.r,
              maxWidth: 320.r,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 54.r,
                  height: 54.r,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3.5,
                  ),
                ),
                SizedBox(height: 18.r),
                Text(
                  message ?? 'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return context;
}
