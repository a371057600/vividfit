import 'package:flutter/material.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class MedalDisplayPage extends StatelessWidget {
  const MedalDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        title: Text(
          l10n.medal,
          style: TextStyle(color: FitTheme.textColor),
        ),
        iconTheme: IconThemeData(color: FitTheme.textColor),
      ),
      body: Center(
        child: Text(
          l10n.medal,
          style: TextStyle(color: FitTheme.textColor, fontSize: 24),
        ),
      ),
    );
  }
}
