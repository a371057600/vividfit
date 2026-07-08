import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

/// 占位页:所有未迁移模块的跳转目标。
///
/// 进入时在控制台打印目标名称,UI 显示"功能开发中"。
/// 保留 AppBar 返回按钮,点击返回首页(/home-shell)。
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.targetName});

  final String targetName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // ignore: avoid_print
    print('[PlaceholderPage] navigate to: $targetName');
    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 100.h,
        leading: Container(
          padding: EdgeInsets.only(left: 45).r,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.go('/home-shell'),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 10).r,
                  height: 100.r,
                  child: Icon(Icons.arrow_back_ios,
                      color: FitTheme.textColor, size: 40.r),
                ),
                Text(
                  targetName,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 40.sp,
                    fontFamily: AppFonts.hofontmedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width,
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          l10n.loading,
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 30.sp,
            fontFamily: AppFonts.hofontmedium,
          ),
        ),
      ),
    );
  }
}
