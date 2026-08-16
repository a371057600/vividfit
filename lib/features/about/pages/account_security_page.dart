import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/account_security_notifier.dart';
import '../states/account_security_state.dart';

class AccountSecurityPage extends ConsumerStatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  ConsumerState<AccountSecurityPage> createState() =>
      _AccountSecurityPageState();
}

class _AccountSecurityPageState extends ConsumerState<AccountSecurityPage> {
  @override
  void initState() {
    super.initState();
    // 页面进入后异步加载手机号/邮箱/unionId 等绑定信息（对应老 getData()）
    Future.microtask(() {
      if (!mounted) return;
      ref.read(accountSecurityProvider.notifier).loadUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(accountSecurityProvider);

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        leadingWidth: 300,
        leading: Container(
          margin: const EdgeInsets.only(left: 0, top: 5, bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.pop(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 10),
                Icon(Icons.arrow_back_ios, color: FitTheme.textColor, size: 20),
                Text(
                  l10n.accountSecurity,
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
      body: Container(
        color: FitTheme.secondbackGround,
        padding: const EdgeInsets.only(
          top: 10,
          left: 15,
          right: 20,
          bottom: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildListItem(
              l10n.phoneNumber,
              state.phoneNumber.isEmpty ? '138****8888' : state.phoneNumber,
              onTap: () {
                // 0=绑定手机场景（对应老 _buildSelectDialog(0)），校验后跳绑定手机页
                ref
                    .read(accountSecurityProvider.notifier)
                    .setAccountAddType(0);
                _showPhoneDialog();
              },
            ),
            const SizedBox(height: 10),
            _buildDivider(),
            _buildListItem(
              l10n.setNewPassword,
              '',
              onTap: () => _showPasswordDialog(),
            ),
            const SizedBox(height: 10),
            _buildDivider(),
            _buildListItem('Unionid', state.unionId, showArrow: false),
            const SizedBox(height: 10),
            _buildDivider(),
            _buildListItem(
              l10n.emailAddress,
              state.emailAddress.isEmpty
                  ? 'u***@email.com'
                  : state.emailAddress,
              onTap: () {
                // 3=绑定邮箱场景（对应老 bindingAccount case 3），校验后跳绑定邮箱页
                ref
                    .read(accountSecurityProvider.notifier)
                    .setAccountAddType(3);
                _showEmailDialog();
              },
            ),
            const SizedBox(height: 10),
            _buildDivider(),
            _buildListItem(
              l10n.deleteAccount,
              '',
              onTap: () => _showDeleteDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    String title,
    String text, {
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15, color: FitTheme.textColor),
            ),
            const Spacer(),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(210, 186, 183, 183),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 3),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: const Color.fromARGB(210, 154, 154, 154),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 0.5,
      height: 3,
      indent: 5,
      endIndent: 5,
      color: Color.fromARGB(47, 132, 129, 129),
    );
  }

  void _showPhoneDialog() {
    final notifier = ref.read(accountSecurityProvider.notifier);
    notifier.resetCounting();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(accountSecurityProvider);
          final notifier = ref.read(accountSecurityProvider.notifier);
          return Dialog(
            backgroundColor: FitTheme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                right: 20,
                left: 20,
                bottom: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      l10n.authentication,
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.confirmOwnOperation,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      letterSpacing: 0.3,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.phoneNumber.isEmpty
                        ? '138****8888'
                        : state.phoneNumber,
                    style: TextStyle(color: FitTheme.textColor, fontSize: 10),
                  ),
                  _buildVerificationCodeField(state, notifier, 0),
                  const SizedBox(height: 10),
                  if (state.hasEmailAddress)
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _showEmailDialog();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            l10n.chooseOtherVerification,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          width: 100,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            l10n.cancel,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // 异步校验验证码（手机弹窗传 0），成功后才关弹窗跳转
                          final notifier =
                              ref.read(accountSecurityProvider.notifier);
                          final ok = await notifier.verifyCheckVerCode(0);
                          if (!ok) return; // 老代码：失败静默，保持弹窗打开
                          if (!dialogContext.mounted) return;
                          Navigator.pop(dialogContext);
                          if (!mounted) return;
                          final accountAddType = ref
                              .read(accountSecurityProvider)
                              .accountAddType;
                          if (accountAddType == 1) {
                            // 设置密码场景：跳设置新密码页
                            context.push('/set-new-password');
                          } else {
                            // 其他场景：跳添加验证方式页
                            context.push(
                              '/add-verification',
                              extra: {'accountAddType': accountAddType},
                            );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            l10n.confirm,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEmailDialog() {
    final notifier = ref.read(accountSecurityProvider.notifier);
    notifier.resetCounting();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(accountSecurityProvider);
          final notifier = ref.read(accountSecurityProvider.notifier);
          return Dialog(
            backgroundColor: FitTheme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                right: 20,
                left: 20,
                bottom: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      l10n.authentication,
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.confirmOwnOperation,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      letterSpacing: 0.3,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.emailAddress.isEmpty
                        ? 'u***@email.com'
                        : state.emailAddress,
                    style: TextStyle(color: FitTheme.textColor, fontSize: 10),
                  ),
                  _buildVerificationCodeField(state, notifier, 1),
                  const SizedBox(height: 10),
                  if (state.hasPhoneNumber)
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _showPhoneDialog();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            l10n.chooseOtherVerification,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          width: 100,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            l10n.cancel,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // 异步校验验证码（邮箱弹窗传 1），成功后才关弹窗跳转
                          final notifier =
                              ref.read(accountSecurityProvider.notifier);
                          final ok = await notifier.verifyCheckVerCode(1);
                          if (!ok) return; // 老代码：失败静默，保持弹窗打开
                          if (!dialogContext.mounted) return;
                          Navigator.pop(dialogContext);
                          if (!mounted) return;
                          final accountAddType = ref
                              .read(accountSecurityProvider)
                              .accountAddType;
                          if (accountAddType == 1) {
                            // 设置密码场景：跳设置新密码页
                            context.push('/set-new-password');
                          } else {
                            // 其他场景：跳添加验证方式页
                            context.push(
                              '/add-verification',
                              extra: {'accountAddType': accountAddType},
                            );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            l10n.confirm,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPasswordDialog() {
    final notifier = ref.read(accountSecurityProvider.notifier);
    final state = ref.read(accountSecurityProvider);
    notifier.setAccountAddType(1); // 1=设置密码场景
    if (!state.isLoading) {
      // 数据未加载完成时点击无响应（老代码行为）
      if (state.hasPhoneNumber) {
        _showPhoneDialog(); // 优先手机校验
      } else if (state.hasEmailAddress) {
        _showEmailDialog(); // 次选邮箱校验
      } else {
        // 都未绑定：跳绑定验证方式页（老代码行为）
        context.push('/add-verification', extra: {'accountAddType': 1});
      }
    }
  }

  Widget _buildVerificationCodeField(
    AccountSecurityState state,
    AccountSecurityNotifier notifier,
    int type,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        TextField(
          style: TextStyle(color: FitTheme.textColor, fontSize: 15),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 5),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: FitTheme.textColor, width: 0.5),
            ),
            hintText: l10n.verificationCode,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          onChanged: (value) => notifier.setCheckVerCode(value),
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              // 发送身份校验验证码：type 0=手机 1=邮箱；倒计时中不可重复发送
              if (!state.isCounting) {
                notifier.sendCheckVerCode(type);
              }
            },
            child: state.isCounting
                ? Text(
                    '${l10n.codeSent}(${state.counter})',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    l10n.getCode,
                    style: TextStyle(
                      color: FitTheme.buttonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: FitTheme.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            right: 20,
            left: 20,
            bottom: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  l10n.deleteAccount,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.warningDeleteAccount,
                textAlign: TextAlign.left,
                style: TextStyle(color: FitTheme.textColor, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      // 先缓存 notifier，await 后不再使用 dialogContext（async 安全）
                      final notifier = ref.read(accountSecurityProvider.notifier);
                      // 注销：先关弹窗再调接口（对应老 HomeController.loginOut 行为）
                      Navigator.pop(dialogContext);
                      final ok = await notifier.deleteAccount();
                      if (!mounted) return;
                      if (ok) {
                        // 注销成功：本地登录态已清空，跳转登录页
                        context.go('/login');
                      } else {
                        // 失败：老代码统一 toast "It seems that there is no internet"
                        Fluttertoast.showToast(msg: l10n.itSeemsNoInternet);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        l10n.confirm,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
