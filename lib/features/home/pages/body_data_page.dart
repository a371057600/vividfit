import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/body_data_notifier.dart';

/// 身体数据页(1:1 复刻旧 NewBodyDataScreen)。
///
/// [isRegistration] 为 true 时走注册流程链路(保存后跳 /avatar-setup);
/// 为 false 时是普通设置页(保存后直接回 /home-shell)。
class BodyDataPage extends ConsumerWidget {
  const BodyDataPage({super.key, this.isRegistration = false});

  final bool isRegistration;

  static const _divider = Divider(
    height: 9,
    indent: 15,
    endIndent: 15,
    color: Color.fromARGB(47, 132, 129, 129),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(bodyDataProvider);
    final notifier = ref.read(bodyDataProvider.notifier);
    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: FitTheme.backgroundColor,
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
              onTap: () {
                context.pop();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 10).r,
                    height: 100.r,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: FitTheme.textColor,
                      size: 40.r,
                    ),
                  ),
                  Text(
                    l10n.bodyData,
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
        body: Stack(
          children: [
            Container(
              color: FitTheme.secondbackGround,
              margin: EdgeInsets.all(25).r,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  _dataRow(
                    context,
                    l10n.gender,
                    state.sexValue ? l10n.male : l10n.female,
                    () => _sexPickerBottom(context, ref, l10n),
                  ),
                  _divider,
                  _dataRow(
                    context,
                    l10n.birthday,
                    state.birthday,
                    () => _datePickerBottom(context, ref, l10n),
                  ),
                  _divider,
                  _dataRow(
                    context,
                    l10n.height,
                    '${state.bodyHeight} cm',
                    () => _heightPickerBottom(context, ref, l10n),
                  ),
                  _divider,
                  _dataRow(
                    context,
                    l10n.weight,
                    '${state.bodyWeight} kg',
                    () => _weightPickerBottom(context, ref, l10n),
                  ),
                  const Spacer(),
                  if (isRegistration)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(20).r,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FitTheme.buttonColor,
                        ),
                        onPressed: () async {
                          await notifier.save();
                          if (!context.mounted) return;
                          context.push(
                            '/avatar-setup',
                            extra: {'isRegistration': true},
                          );
                        },
                        child: Text(
                          // TODO(l10n): 待补充 next 文案
                          '下一步',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FitTheme.fonSizeBigBig,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(
    BuildContext context,
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
            Text(
              leftTitle,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            Text(
              rightTitle,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_forward_ios,
                color: const Color.fromARGB(210, 154, 154, 154),
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 性别选择底部弹窗(选中后立即关闭)----
  void _sexPickerBottom(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(bodyDataProvider.notifier);
    final currentSex = ref.read(bodyDataProvider).sexValue;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                l10n.genderSelection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sexRadioRow(l10n.male, true, currentSex, () {
                      notifier.setSex(true);
                      Navigator.pop(ctx);
                    }),
                    const Divider(
                      height: 9,
                      color: Color.fromARGB(47, 132, 129, 129),
                    ),
                    _sexRadioRow(l10n.female, false, currentSex, () {
                      notifier.setSex(false);
                      Navigator.pop(ctx);
                    }),
                  ],
                ),
              ),
              _btnGroup(
                l10n,
                onCancel: () => Navigator.pop(ctx),
                onConfirm: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sexRadioRow(
    String label,
    bool isMale,
    bool currentSex,
    VoidCallback onTap,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: FitTheme.textColor, fontSize: 15),
            ),
            SizedBox(
              height: 20,
              width: 20,
              child: Radio<int>(
                value: isMale ? 0 : 1,
                groupValue: currentSex ? 0 : 1,
                fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return FitTheme.buttonColor;
                  }
                  return null;
                }),
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 生日选择底部弹窗 ----
  void _datePickerBottom(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(bodyDataProvider.notifier);
    final state = ref.read(bodyDataProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                l10n.dateSelection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    backgroundColor: FitTheme.secondbackGround,
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
              _btnGroup(
                l10n,
                onCancel: () => Navigator.pop(ctx),
                onConfirm: () {
                  final err = notifier.compareDate();
                  if (err != null) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text(l10n.selectDateBeforeToday),
                        duration: const Duration(seconds: 2),
                      ),
                    );
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
  void _heightPickerBottom(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(bodyDataProvider.notifier);
    final initial = ref.read(bodyDataProvider).heightPosition;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        int position = initial;
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                l10n.heightLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: FitTheme.secondbackGround,
                  squeeze: 1.2,
                  itemExtent: 35,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 1.0,
                  offAxisFraction: 0,
                  scrollController: FixedExtentScrollController(
                    initialItem: initial,
                  ),
                  onSelectedItemChanged: (p) => position = p,
                  children: [
                    for (int i = 100; i <= 240; i++)
                      Center(
                        child: Text(
                          '$i cm',
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _btnGroup(
                l10n,
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
  void _weightPickerBottom(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(bodyDataProvider.notifier);
    final initial = ref.read(bodyDataProvider).weightPosition;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        int position = initial;
        return Container(
          height: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                l10n.weightLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: FitTheme.secondbackGround,
                  squeeze: 1.2,
                  itemExtent: 35,
                  looping: false,
                  magnification: 1,
                  diameterRatio: 1.0,
                  offAxisFraction: 0,
                  scrollController: FixedExtentScrollController(
                    initialItem: initial,
                  ),
                  onSelectedItemChanged: (p) => position = p,
                  children: [
                    for (int i = 40; i <= 200; i++)
                      Center(
                        child: Text(
                          '$i kg',
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _btnGroup(
                l10n,
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

  Widget _btnGroup(
    AppLocalizations l10n, {
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
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 16, color: FitTheme.buttonColor),
            ),
          ),
          const SizedBox(width: 50),
          Container(color: Colors.grey, width: 0.3, height: 30),
          const SizedBox(width: 50),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onConfirm,
            child: Text(
              l10n.confirm,
              style: TextStyle(fontSize: 16, color: FitTheme.buttonColor),
            ),
          ),
        ],
      ),
    );
  }
}
