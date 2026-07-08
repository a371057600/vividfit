import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/body_data_notifier.dart';

class BodyDataPage extends ConsumerWidget {
  const BodyDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bodyDataNotifierProvider);
    final notifier = ref.read(bodyDataNotifierProvider.notifier);
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ThemChange.backgroundColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 100.h,
            leading: Container(
              padding: EdgeInsets.only(left: 45).r,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () async {
                  await notifier.save();
                  if (context.mounted) context.go('/home-shell');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_back_ios,
                        color: ThemChange.textColor, size: 40.r),
                    Text('Body Data',
                        style: TextStyle(
                          color: ThemChange.textColor, fontSize: 40.sp,
                          fontFamily: AppFonts.hofontmedium,
                        )),
                  ],
                ),
              ),
            ),
            leadingWidth: MediaQuery.of(context).size.width,
            centerTitle: false,
          ),
          backgroundColor: ThemChange.backgroundColor,
          body: Stack(
            children: [
              Container(
                color: Colors.black,
                margin: EdgeInsets.all(25).r,
                child: Column(
                  children: [
                    // TODO: 1:1 复刻旧 body_data_screen.dart 完整 UI
                    // - 头像 + 昵称
                    // - 性别选择(Male/Female)
                    // - 身高滑块 + 显示
                    // - 体重滑块 + 显示
                    // - 生日选择
                    Text('Body Data(待完整复刻)',
                        style: TextStyle(color: ThemChange.textColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
