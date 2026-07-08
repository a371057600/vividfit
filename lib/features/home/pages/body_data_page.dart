import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/body_data_notifier.dart';

/// 身体数据页(1:1 复刻旧 NewBodyDataScreen)。
///
/// UI 结构:
/// - AppBar:返回按钮(点击保存并返回)+ "Body Data"
/// - 黑色卡片容器,内含 4 行(Gender/Birthday/Height/Weight)+ 分割线
/// - 每行点击弹出底部选择器:性别 Radio / 生日 CupertinoDatePicker / 身高 CupertinoPicker / 体重 CupertinoPicker
class BodyDataPage extends ConsumerWidget {
  const BodyDataPage({super.key});

  static const _divider = Divider(
    height: 9,
    indent: 15,
    endIndent: 15,
    color: Color.fromARGB(47, 132, 129, 129),
  );

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
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await notifier.save();
                  if (context.mounted) context.go('/home-shell');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 10).r,
                      height: 100.r,
                      child: Icon(Icons.arrow_back_ios,
                          color: ThemChange.textColor, size: 40.r),
                    ),
                    Text('Body Data',
                        style: TextStyle(
                          color: ThemChange.textColor,
                          fontSize: 40.sp,
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
                color: const Color.fromARGB(255, 0, 0, 0),
                margin: EdgeInsets.all(25).r,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    _buildSingleTextWidget(
                      context,
                      ref,
                      'Gender',
                      state.sexValue ? 'Male' : 'Female',
                      () => _sexPickerBottom(context, ref),
                    ),
                    _divider,
                    _buildSingleTextWidget(
                      context,
                      ref,
                      'Birthday',
                      state.birthday,
                      () => _datePickerBottomWidget(context, ref),
                    ),
                    _divider,
                    _buildSingleTextWidget(
                      context,
                      ref,
                      'Height',
                      '${state.bodyHeight} cm',
                      () => _heightPickerBottomSheet(context, ref),
                    ),
                    _divider,
                    _buildSingleTextWidget(
                      context,
                      ref,
                      'Weight',
                      '${state.bodyWeight} kg',
                      () => _weightPickerBottomSheet(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 单行数据项:左标题 + 右值 + 箭头,点击触发回调。
  Widget _buildSingleTextWidget(
    BuildContext context,
    WidgetRef ref,
    String leftTitle,
    String rightTitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 15, top: 5),
        child: Row(
          children: [
            Text(leftTitle,
                style: TextStyle(
                  color: ThemChange.textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                )),
            const Spacer(),
            Text(rightTitle,
                style: TextStyle(
                  color: ThemChange.textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                )),
            Container(
              margin: const EdgeInsets.all(10),
              child: Icon(Icons.arrow_forward_ios,
                  color: const Color.fromARGB(210, 154, 154, 154), size: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 性别选择底部弹窗 ----
  // 旧项目行为:选中某项后立即关闭弹窗。
  void _sexPickerBottom(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bodyDataNotifierProvider.notifier);
    final currentSex = ref.read(bodyDataNotifierProvider).sexValue;
    void select(bool male, BuildContext ctx) {
      notifier.setSex(male);
      Navigator.pop(ctx);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: ThemChange.backgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (ctx) {
        return Container(
          height: 230,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 34, 34),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gender Selection',
                  style: TextStyle(
                    color: ThemChange.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              _sexRadioRow('Male', true, currentSex, () => select(true, ctx)),
              const Divider(
                height: 9,
                color: Color.fromARGB(47, 132, 129, 129),
              ),
              _sexRadioRow('Female', false, currentSex, () => select(false, ctx)),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.pop(ctx),
                    child: Text('Cancel',
                        style: TextStyle(color: ThemChange.buttonColor)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sexRadioRow(
      String label, bool isMale, bool currentSex, VoidCallback onTap) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(color: ThemChange.textColor, fontSize: 15)),
            SizedBox(
              height: 20,
              width: 20,
              child: Radio<double>(
                groupValue: currentSex ? 0 : 1,
                activeColor: ThemChange.buttonColor,
                value: isMale ? 0 : 1,
                onChanged: (_) => onTap(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 生日选择底部弹窗 ----
  void _datePickerBottomWidget(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bodyDataNotifierProvider.notifier);
    final state = ref.read(bodyDataNotifierProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemChange.backgroundColor,
      elevation: 0,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 34, 34),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 300,
          child: Column(
            children: [
              Text('Date Selection',
                  style: TextStyle(
                    color: ThemChange.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: const CupertinoTextThemeData(
                      dateTimePickerTextStyle:
                          TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    backgroundColor: ThemChange.backgroundColor,
                    initialDateTime: DateTime(
                      int.tryParse(state.bodyAgeYear) ?? 1991,
                      int.tryParse(state.bodyAgeMonth) ?? 1,
                      int.tryParse(state.bodyAgeDay) ?? 1,
                    ),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime date) {
                      notifier.setDate(
                        year: date.year.toString(),
                        month: date.month.toString().padLeft(2, '0'),
                        day: date.day.toString().padLeft(2, '0'),
                      );
                    },
                  ),
                ),
              ),
              _confirmButtonGroup(
                onCancel: () => Navigator.pop(ctx),
                onConfirm: () {
                  final err = notifier.compareDate();
                  if (err != null) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text(err), duration: const Duration(seconds: 2)));
                  } else {
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---- 身高选择底部弹窗(100~240 cm)----
  void _heightPickerBottomSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bodyDataNotifierProvider.notifier);
    final initial = ref.read(bodyDataNotifierProvider).heightPosition;
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemChange.backgroundColor,
      elevation: 0,
      builder: (ctx) {
        int position = initial;
        return Container(
          height: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 34, 34),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text('Height',
                  style: TextStyle(
                    color: ThemChange.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1.3,
                  itemExtent: 40,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 0.9,
                  offAxisFraction: 0.3,
                  scrollController:
                      FixedExtentScrollController(initialItem: initial),
                  onSelectedItemChanged: (p) => position = p,
                  children: [
                    for (int i = 100; i <= 240; i++)
                      Center(
                        child: Text('$i cm',
                            style: TextStyle(color: ThemChange.textColor)),
                      ),
                  ],
                ),
              ),
              _confirmButtonGroup(
                onCancel: () {
                  notifier.resetHeightPosition();
                  Navigator.pop(ctx);
                },
                onConfirm: () {
                  notifier.setHeightPosition(position);
                  notifier.confirmHeight();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---- 体重选择底部弹窗(40~200 kg)----
  void _weightPickerBottomSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bodyDataNotifierProvider.notifier);
    final initial = ref.read(bodyDataNotifierProvider).weightPosition;
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemChange.backgroundColor,
      elevation: 0,
      builder: (ctx) {
        int position = initial;
        return Container(
          height: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 34, 34),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text('Weight',
                  style: TextStyle(
                    color: ThemChange.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1.3,
                  itemExtent: 40,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 0.9,
                  offAxisFraction: 0.3,
                  scrollController:
                      FixedExtentScrollController(initialItem: initial),
                  onSelectedItemChanged: (p) => position = p,
                  children: [
                    for (int i = 40; i <= 200; i++)
                      Center(
                        child: Text('$i kg',
                            style: TextStyle(color: ThemChange.textColor)),
                      ),
                  ],
                ),
              ),
              _confirmButtonGroup(
                onCancel: () => Navigator.pop(ctx),
                onConfirm: () {
                  notifier.setWeightPosition(position);
                  notifier.confirmWeight();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 底部弹窗通用的"取消 / 确认"按钮组(对应旧 _comfirBottonGroupWidget*)。
  Widget _confirmButtonGroup({
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onCancel,
            child: Text('Cancel',
                style: TextStyle(fontSize: 16, color: ThemChange.buttonColor)),
          ),
          const SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          const SizedBox(width: 50),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onConfirm,
            child: Text('Confirm',
                style: TextStyle(fontSize: 16, color: ThemChange.buttonColor)),
          ),
        ],
      ),
    );
  }
}
