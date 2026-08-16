import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/utils/loading_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import '../widgets/privacy_agreement_check.dart';

/// 账号密码登录页(对应旧项目 NewAccountLoginScreen)。
///
/// 点击 Login 按钮 → 弹窗 Loading → 调用 AuthNotifier.login → 路由层按 200/201 分发跳转。
class AccountLoginPage extends ConsumerStatefulWidget {
  const AccountLoginPage({super.key});

  @override
  ConsumerState<AccountLoginPage> createState() => _AccountLoginPageState();
}

class _AccountLoginPageState extends ConsumerState<AccountLoginPage> {
  late TextEditingController _accountCtrl;
  late TextEditingController _pwdCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(authProvider);
    _accountCtrl = TextEditingController(text: s.emailAccount);
    _pwdCtrl = TextEditingController(text: s.password);
  }

  @override
  void dispose() {
    _accountCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _doLogin(BuildContext context) async {
    final n = ref.read(authProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final account = _accountCtrl.text.trim();
    final pwd = _pwdCtrl.text.trim();
    if (account.isEmpty || pwd.isEmpty) {
      Fluttertoast.showToast(msg: l10n.pleaseEnterAccountAndPassword);
      return;
    }
    // 隐私协议前置校验
    if (!ref.read(authProvider).agreedToPrivacy) {
      Fluttertoast.showToast(msg: l10n.pleaseAgreePrivacy);
      return;
    }
    n
      ..setEmailAccount(account)
      ..setPassword(pwd);
    // 调登录接口前展示 Loading
    showLoadingDialog(context, message: l10n.login);
    try {
      final ok = await n.login();
      if (!context.mounted) return;
      Navigator.of(context).pop(); // 关闭 Loading
      if (ok) {
        // 路由层 redirect 会按 isNewUser 分发 → 201→/nickname-setup; 200→/home-shell
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (!context.mounted) return;
        final isNewUser = ref.read(authProvider).isNewUser;
        context.go(isNewUser ? '/nickname-setup' : '/home-shell');
      }
    } catch (e) {
      print('❌ [AccountLoginPage] unexpected error: $e');
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final showPwd = ref.watch(authProvider.select((s) => s.showPassword));

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
          padding: EdgeInsets.symmetric(horizontal: 60.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.r),
              Text(
                l10n.accountLogin,
                style: TextStyle(color: FitTheme.textColor, fontSize: 60.sp),
              ),
              SizedBox(height: 80.r),
              _buildAccountField(context, l10n),
              SizedBox(height: 30.r),
              _buildPasswordField(context, l10n, showPwd),
              SizedBox(height: 30.r),
              Row(
                children: [
                  // 注册链接(对应旧项目 Register → NewEmailLoginScreen)
                  // 账号密码登录无法注册新账号,引导用户用邮箱验证码方式注册
                  // 邮箱验证码登录返回 201 → 自动进入注册流程
                  InkWell(
                    onTap: () => context.push('/email-login'),
                    child: Text(
                      l10n.register,
                      style: TextStyle(
                        color: FitTheme.textColor.withValues(alpha: 0.7),
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.push('/find-password'),
                    child: Text(
                      l10n.forgetPassword,
                      style: TextStyle(
                        color: FitTheme.textColor.withValues(alpha: 0.7),
                        fontSize: 26.sp,
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
                  onPressed: () => _doLogin(context),
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
              SizedBox(height: 40.r),
              const PrivacyAgreementCheck(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountField(BuildContext context, AppLocalizations l10n) {
    return TextField(
      controller: _accountCtrl,
      keyboardType: TextInputType.emailAddress,
      onChanged: ref.read(authProvider.notifier).setEmailAccount,
      style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
      cursorColor: FitTheme.buttonColor,
      decoration: InputDecoration(
        labelText: l10n.account,
        labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
        hintText: l10n.enterEmail,
        hintStyle: TextStyle(color: FitTheme.textColor.withValues(alpha: 0.4)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FitTheme.textColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FitTheme.buttonColor),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    AppLocalizations l10n,
    bool showPwd,
  ) {
    return TextField(
      controller: _pwdCtrl,
      obscureText: showPwd,
      onChanged: ref.read(authProvider.notifier).setPassword,
      style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
      cursorColor: FitTheme.buttonColor,
      decoration: InputDecoration(
        labelText: l10n.password,
        labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
        hintText: l10n.enterPassword,
        hintStyle: TextStyle(color: FitTheme.textColor.withValues(alpha: 0.4)),
        suffixIcon: InkWell(
          onTap: ref.read(authProvider.notifier).toggleShowPassword,
          child: Icon(
            showPwd ? Icons.visibility_off : Icons.visibility,
            color: FitTheme.textColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FitTheme.textColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FitTheme.buttonColor),
        ),
      ),
    );
  }
}
