import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class AboutInfoPage extends ConsumerWidget {
  const AboutInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: FitTheme.textColor),
        titleTextStyle: TextStyle(color: FitTheme.textColor),
        title: Text(
          l10n.about,
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: FitTheme.backgroundColor,
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Spacer(),
                        ClipOval(
                          child: Image.asset(
                            "images/newUIScreen/tergasy.png",
                            height: 200.r,
                            width: 200.r,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "Vivid Fit",
                          style: TextStyle(
                            color: FitTheme.textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "v1.0.0",
                          style: TextStyle(color: FitTheme.textColor),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: FitTheme.secondbackGround,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    left: 45,
                    right: 25,
                    top: 20,
                    bottom: 20,
                  ).r,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.serviceHotline,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 25.sp,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "400-083-1718",
                            style: TextStyle(color: FitTheme.textColor),
                          ),
                          SizedBox(width: 10.r),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 30.r,
                            color: Color.fromARGB(210, 154, 154, 154),
                          ),
                        ],
                      ),
                      Divider(color: Color.fromARGB(167, 40, 40, 40)),
                      Row(
                        children: [
                          Text(
                            l10n.legalInformation,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 25.sp,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 30.r,
                            color: Color.fromARGB(210, 154, 154, 154),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20),
                    width: 260,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "粤ICP备19140274号-4A",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                        Text(
                          l10n.copyrightInfo,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
