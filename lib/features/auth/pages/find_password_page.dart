import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/utils/loading_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';

/// 找回密码流程(对应旧项目 NewGetCodeScreen + FindPasswordPage)。
///
/// 三步:1. 输邮箱获取验证码 → 2.Pinput 6位验证码 + 新密码两次 → 3.点击 Set Password 调 updatePwd
class FindPasswordPage extends ConsumerStatefulWidget {
  const FindPasswordPage({super.key});

  @override
  ConsumerState<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends ConsumerState<FindPasswordPage> {
  late TextEditingController _emailCtrl;
  late TextEditingController _pwdCtrl;
  late TextEditingController _pwd2Ctrl;
  final _pinCtrl = TextEditingController();
  final _pinFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final s = ref.read(authProvider);
    _emailCtrl = TextEditingController(text: s.emailAccount);
    _pwdCtrl = TextEditingController(text: s.password);
    _pwd2Ctrl = TextEditingController(text: s.changepassword);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    _pinCtrl.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Future<void> _sendCode(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final n = ref.read(authProvider.notifier);
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      Fluttertoast.showToast(msg: l10n.enterEmail);
      return;
    }
    n.setEmailAccount(email);
    if (!ref.read(authProvider).ishasInternet) {
      Fluttertoast.showToast(msg: l10n.noInternetConnectionOrNoInput);
      return;
    }
    showLoadingDialog(context, message: l10n.getCaptcha);
    try {
      final ok = await n.sendEmailCaptcha();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (ok) {
        // 发送成功,聚焦验证码输入框
        Future<void>.delayed(
          const Duration(milliseconds: 100),
          () => _pinFocus.requestFocus(),
        );
      }
    } catch (e) {
      print('❌ [FindPasswordPage.sendCode] error=$e');
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _setPassword(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final n = ref.read(authProvider.notifier);
    final pwd = _pwdCtrl.text;
    final pwd2 = _pwd2Ctrl.text;
    final pin = _pinCtrl.text;
    if (pwd.isEmpty || pwd2.isEmpty) {
      Fluttertoast.showToast(msg: l10n.enterPassword);
      return;
    }
    if (pwd != pwd2) {
      // TODO(l10n): 两次密码不一致(当前硬简中占位)
      Fluttertoast.showToast(msg: '两次输入的密码不一致');
      return;
    }
    if (pin.length != 6) {
      Fluttertoast.showToast(msg: l10n.enterCode);
      return;
    }
    n
      ..setPassword(pwd)
      ..setChangePassword(pwd2)
      ..setCaptcha(pin);
    showLoadingDialog(context, message: l10n.setPassword);
    try {
      final ok = await n.checkCaptchaAndResetPassword();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (ok) {
        // 设置成功 → 返回登录页
        context.go('/login');
      }
    } catch (e) {
      print('❌ [FindPasswordPage.setPassword] error=$e');
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

    final pinTheme = PinTheme(
      width: 72.r,
      height: 82.r,
      textStyle: TextStyle(color: FitTheme.textColor, fontSize: 36.sp),
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 60.r, vertical: 40.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.forgetPassword,
                style: TextStyle(color: FitTheme.textColor, fontSize: 60.sp),
              ),
              SizedBox(height: 40.r),
              // 邮箱+获取验证码
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: ref.read(authProvider.notifier).setEmailAccount,
                      style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
                      cursorColor: FitTheme.buttonColor,
                      decoration: InputDecoration(
                        labelText: l10n.emailLogin,
                        labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
                        hintText: l10n.enterEmail,
                        hintStyle: TextStyle(
                          color: FitTheme.textColor.withValues(alpha: 0.4),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FitTheme.textColor.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: FitTheme.buttonColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.r),
                  TextButton(
                    onPressed: reGet ? () => _sendCode(context) : null,
                    child: Text(
                      reGet ? l10n.reGet : '${l10n.reGet}(${countdown}s)',
                      style: TextStyle(
                        color: reGet
                            ? FitTheme.buttonColor
                            : FitTheme.textColor.withValues(alpha: 0.4),
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.r),
              Center(
                child: Pinput(
                  controller: _pinCtrl,
                  focusNode: _pinFocus,
                  length: 6,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: pinTheme.copyWith(
                    decoration: pinTheme.decoration!.copyWith(
                      border: Border.all(color: FitTheme.buttonColor, width: 2.5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.r),
              TextField(
                controller: _pwdCtrl,
                obscureText: true,
                onChanged: ref.read(authProvider.notifier).setPassword,
                style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
                cursorColor: FitTheme.buttonColor,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
                  hintText: l10n.enterPassword,
                  hintStyle: TextStyle(
                    color: FitTheme.textColor.withValues(alpha: 0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: FitTheme.textColor.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.buttonColor),
                  ),
                ),
              ),
              SizedBox(height: 30.r),
              TextField(
                controller: _pwd2Ctrl,
                obscureText: true,
                onChanged: ref.read(authProvider.notifier).setChangePassword,
                style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
                cursorColor: FitTheme.buttonColor,
                decoration: InputDecoration(
                  labelText: l10n.setPassword,
                  labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
                  hintText: l10n.enterPassword,
                  hintStyle: TextStyle(
                    color: FitTheme.textColor.withValues(alpha: 0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: FitTheme.textColor.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.buttonColor),
                  ),
                ),
              ),
              SizedBox(height: 100.r),
              SizedBox(
                width: width,
                height: 90.r,
                child: ElevatedButton(
                  onPressed: () => _setPassword(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    l10n.setPassword,
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
