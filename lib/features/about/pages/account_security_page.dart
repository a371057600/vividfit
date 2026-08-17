import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/routing/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/account_security_notifier.dart';
import '../states/account_security_state.dart';

class AccountSecurityPage extends ConsumerStatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  ConsumerState<AccountSecurityPage> createState() =>
      _AccountSecurityPageState();
}

/// 混入 RouteAware：任何子页面（设置密码/绑定验证方式等）pop 返回本页时，
/// didPopNext 自动触发 loadUserInfo()，保证邮箱/手机号/Unionid 为云端最新值。
class _AccountSecurityPageState extends ConsumerState<AccountSecurityPage>
    with RouteAware {
  /// 隐私脱敏：隐藏手机号中间 4 位（18664051102 → 186****1102）。
  /// 长度 ≤ 4 时整体以 **** 显示，避免短号泄露。
  static String _maskPhone(String phone) {
    if (phone.isEmpty) return phone;
    if (phone.length <= 4) return '****';
    if (phone.length <= 7) return '${phone.substring(0, 1)}****';
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
  }

  /// 隐私脱敏：邮箱本地部分隐藏中间 4 位，域名完整保留
  /// （yaozhenneng@gmail.com → yao****neng@gmail.com）。
  static String _maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return _maskPhone(email); // 非邮箱格式按手机号规则处理
    final local = email.substring(0, at);
    final domain = email.substring(at); // 含 @
    if (local.length <= 4) return '****$domain';
    if (local.length <= 7) return '${local.substring(0, 1)}****$domain';
    return '${local.substring(0, 3)}****${local.substring(local.length - 4)}$domain';
  }

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅路由观察者，用于感知子页返回
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// 任何子页面（设置密码/绑定验证方式等）pop 返回本页时触发刷新，
  /// 保证每次回来邮箱/手机号/Unionid 都是云端最新值。
  @override
  void didPopNext() {
    print('[AccountSecurity] didPopNext → 刷新用户信息');
    ref.read(accountSecurityProvider.notifier).loadUserInfo();
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
              _maskPhone(state.phoneNumber), // 隐私脱敏显示
              onTap: () {
                if (state.phoneNumber.isEmpty) {
                  // 未绑定：跳添加验证方式页（绑定手机），返回后刷新
                  _navigateToAddVerification(0);
                  return;
                }
                // 已绑定：显示手机验证弹窗
                ref.read(accountSecurityProvider.notifier).setAccountAddType(0);
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
              _maskEmail(state.emailAddress), // 隐私脱敏显示
              onTap: () {
                if (state.emailAddress.isEmpty) {
                  // 未绑定：跳添加验证方式页（绑定邮箱），返回后刷新
                  _navigateToAddVerification(3);
                  return;
                }
                // 已绑定：显示邮箱验证弹窗
                ref.read(accountSecurityProvider.notifier).setAccountAddType(3);
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
    final pageContext = context; // 保存主页面 context 用于导航
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
                    _maskPhone(state.phoneNumber), // 隐私脱敏显示
                    style: TextStyle(color: FitTheme.textColor, fontSize: 10),
                  ),
                  _buildVerificationCodeField(state, notifier, 0),
                  const SizedBox(height: 10),
                  // 设置密码场景强制邮箱验证，不显示"选择其他验证方式"
                  if (state.hasEmailAddress && state.accountAddType != 1)
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
                          final notifier = ref.read(
                            accountSecurityProvider.notifier,
                          );
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
                            pageContext.push('/set-new-password');
                          } else {
                            // 绑定场景：跳添加验证方式页，返回后刷新
                            await pageContext.push(
                              '/add-verification',
                              extra: {'accountAddType': accountAddType},
                            );
                            if (mounted) {
                              ref
                                  .read(accountSecurityProvider.notifier)
                                  .loadUserInfo();
                            }
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
    final pageContext = context; // 保存主页面 context 用于导航
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
                    _maskEmail(state.emailAddress), // 隐私脱敏显示
                    style: TextStyle(color: FitTheme.textColor, fontSize: 10),
                  ),
                  _buildVerificationCodeField(state, notifier, 1),
                  const SizedBox(height: 10),
                  // 设置密码场景强制邮箱验证，不显示"选择其他验证方式"
                  if (state.hasPhoneNumber && state.accountAddType != 1)
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
                          final notifier = ref.read(
                            accountSecurityProvider.notifier,
                          );
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
                            pageContext.push('/set-new-password');
                          } else {
                            // 绑定场景：跳添加验证方式页，返回后刷新
                            await pageContext.push(
                              '/add-verification',
                              extra: {'accountAddType': accountAddType},
                            );
                            if (mounted) {
                              ref
                                  .read(accountSecurityProvider.notifier)
                                  .loadUserInfo();
                            }
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
      // 必须用邮箱验证（因为登录只能用邮箱+密码）
      if (state.hasEmailAddress) {
        _showEmailDialog(); // 有邮箱：显示邮箱验证弹窗
      } else {
        // 无邮箱：直接跳绑定邮箱页
        _navigateToAddVerification(3);
      }
    }
  }

  /// 跳转到绑定验证方式页，并在返回后刷新用户信息
  Future<void> _navigateToAddVerification(int accountAddType) async {
    await context.push(
      '/add-verification',
      extra: {'accountAddType': accountAddType},
    );
    // 绑定成功后返回 true，或用户直接返回，都刷新信息
    if (mounted) {
      ref.read(accountSecurityProvider.notifier).loadUserInfo();
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
                      final notifier = ref.read(
                        accountSecurityProvider.notifier,
                      );
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
