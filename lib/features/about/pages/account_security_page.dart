import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              onTap: () => _showPhoneDialog(),
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
              onTap: () => _showEmailDialog(),
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
                  _buildVerificationCodeField(state, notifier),
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
                        onTap: () {
                          Navigator.pop(dialogContext);
                          final accountAddType = ref
                              .read(accountSecurityProvider)
                              .accountAddType;
                          context.push(
                            '/add-verification',
                            extra: {'accountAddType': accountAddType},
                          );
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
                  _buildVerificationCodeField(state, notifier),
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
                        onTap: () {
                          Navigator.pop(dialogContext);
                          final accountAddType = ref
                              .read(accountSecurityProvider)
                              .accountAddType;
                          context.push(
                            '/add-verification',
                            extra: {'accountAddType': accountAddType},
                          );
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
    context.push('/set-new-password');
  }

  Widget _buildVerificationCodeField(
    AccountSecurityState state,
    AccountSecurityNotifier notifier,
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
          onChanged: (value) => notifier.setVerCode(value),
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {},
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
                    onTap: () {
                      Navigator.pop(dialogContext);
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
