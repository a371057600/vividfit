import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/account_security_notifier.dart';

class SetNewPasswordPage extends ConsumerStatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  ConsumerState<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends ConsumerState<SetNewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 确认按钮：提交新密码（对应旧 find_password_set_new 的 bindingAccount case 1）。
  ///
  /// 1. 两次密码不一致 → toast 提示并留在当前页
  /// 2. 一致 → 写入 Notifier 状态后调用 updatePassword() 发起 PUT updatePwdUrl
  /// 3. 成功 → toast success 并返回；失败 → toast 密码不符合规定
  Future<void> _submitPassword(AppLocalizations l10n) async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    print('🔑 [SetNewPassword] submit pwdLen=${password.length} '
        'confirmLen=${confirmPassword.length}');

    if (password != confirmPassword) {
      // 与旧项目一致：不一致仅 toast，不跳转
      Fluttertoast.showToast(msg: l10n.passwordMismatch);
      return;
    }

    // 先把输入写入状态，updatePassword() 读取 state.changepassword
    final notifier = ref.read(accountSecurityProvider.notifier);
    notifier.setChangepassword(password);
    notifier.setChangepassword2(confirmPassword);

    final ok = await notifier.updatePassword();
    print('🔑 [SetNewPassword] updatePassword ok=$ok');
    if (!mounted) return;

    if (ok) {
      Fluttertoast.showToast(msg: l10n.success);
      context.pop();
    } else {
      // 旧项目：code != 200 → "密码不符合规定"
      Fluttertoast.showToast(msg: '密码不符合规定');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: FitTheme.backgroundColor,
          elevation: 0,
          leadingWidth: 300,
          leading: Container(
            margin: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => context.pop(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_back_ios,
                    color: FitTheme.textColor,
                    size: 20,
                  ),
                  Text(
                    l10n.changePassword,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: FitTheme.backgroundColor,
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
                // 全局为 dark 主题，不显式指定则输入文字为白色，浅色背景下不可见
                style: TextStyle(color: FitTheme.textColor),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.0,
                      color: FitTheme.textColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 15),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.textColor),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: l10n.password,
                  hintStyle: const TextStyle(color: Colors.grey, height: 1),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
                // 全局为 dark 主题，不显式指定则输入文字为白色，浅色背景下不可见
                style: TextStyle(color: FitTheme.textColor),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    child: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.0,
                      color: FitTheme.textColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 15),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.textColor),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: l10n.confirmPassword,
                  hintStyle: const TextStyle(color: Colors.grey, height: 1),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      FitTheme.buttonColor,
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(340, 50)),
                  ),
                  child: Text(
                    l10n.confirm,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _submitPassword(l10n),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
