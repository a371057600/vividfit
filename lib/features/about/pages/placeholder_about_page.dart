import 'package:flutter/material.dart';
import '../../../core/constants/them_change.dart';

class PlaceholderAboutPage extends StatelessWidget {
  final String targetName;

  const PlaceholderAboutPage({
    super.key,
    required this.targetName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        elevation: 0,
        title: Text(
          targetName,
          style: TextStyle(color: FitTheme.textColor),
        ),
        iconTheme: IconThemeData(color: FitTheme.textColor),
      ),
      body: Center(
        child: Text(
          targetName,
          style: TextStyle(color: FitTheme.textColor, fontSize: 24),
        ),
      ),
    );
  }
}
