import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/utils/loading_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';

/// 6 位验证码输入页(对应旧项目 NewGetCodeScreen)。
///
/// 支持:倒计时重新获取、Pinput 自动焦点、输入完成后 Loading + 登录 + 按 200/201 分发跳转。
class GetCodePage extends ConsumerStatefulWidget {
  const GetCodePage({super.key});

  @override
  ConsumerState<GetCodePage> createState() => _GetCodePageState();
}

class _GetCodePageState extends ConsumerState<GetCodePage> {
  final _pinCtrl = TextEditingController();
  final _pinFocus = FocusNode();

  @override
  void dispose() {
    _pinCtrl.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Future<void> _onCompleted(String pin) async {
    final l10n = AppLocalizations.of(context)!;
    final n = ref.read(authProvider.notifier);
    showLoadingDialog(context, message: l10n.login);
    try {
      final ok = await n.selectLoginType(pin);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (ok) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (!context.mounted) return;
        final isNewUser = ref.read(authProvider).isNewUser;
        context.go(isNewUser ? '/nickname-setup' : '/home-shell');
      } else {
        // 登录失败(验证码错误等)→清空 Pinput 重新聚焦让用户再输
        _pinCtrl.clear();
        _pinFocus.requestFocus();
      }
    } catch (e) {
      print('❌ [GetCodePage] unexpected error: $e');
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final state = ref.watch(authProvider);
    final countdown = state.countdown;
    final reGet = state.reGetCode2;
    final loginType = state.loginType;
    final targetHint = loginType == 1
        ? state.phoneNumber.toString()
        : state.emailAccount;

    final defaultPinTheme = PinTheme(
      width: 80.r,
      height: 90.r,
      textStyle: TextStyle(color: FitTheme.textColor, fontSize: 40.sp),
      decoration: BoxDecoration(
        border: Border.all(color: FitTheme.buttonColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            if (context.canPop()) context.pop();
          },
          child: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
        ),
        title: Text(l10n.getCodeTitle,
            style: TextStyle(color: FitTheme.textColor, fontSize: 40.sp)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.r, vertical: 40.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.r),
              Text(
                l10n.enterCode,
                style: TextStyle(color: FitTheme.textColor, fontSize: 60.sp),
              ),
              SizedBox(height: 20.r),
              // TODO(l10n): "Code was sent to <phone/email>" - 当前硬编码占位
              Text(
                'Code was sent to $targetHint',
                style: TextStyle(
                  color: FitTheme.textColor.withValues(alpha: 0.6),
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 80.r),
              Center(
                child: Pinput(
                  controller: _pinCtrl,
                  focusNode: _pinFocus,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(
                        color: FitTheme.buttonColor,
                        width: 2.5,
                      ),
                    ),
                  ),
                  onCompleted: _onCompleted,
                  autofocus: true,
                  showCursor: true,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                ),
              ),
              SizedBox(height: 60.r),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: reGet
                        ? () {
                            ref.read(authProvider.notifier).regetCode();
                          }
                        : null,
                    child: Text(
                      reGet
                          ? l10n.reGet
                          : '${l10n.reGet} (${countdown}s)',
                      style: TextStyle(
                        color: reGet
                            ? FitTheme.buttonColor
                            : FitTheme.textColor.withValues(alpha: 0.4),
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100.r),
              SizedBox(
                width: width,
                height: 90.r,
                child: ElevatedButton(
                  onPressed: () {
                    if (_pinCtrl.text.length == 6) {
                      _onCompleted(_pinCtrl.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    l10n.login,
                    style: TextStyle(
                      color: FitTheme.textButtonColor,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
