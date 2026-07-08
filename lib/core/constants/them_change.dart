import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_fonts.dart';

/// 主题/颜色/字体/字号常量(1:1 迁移自旧项目 util/them_change_tool.dart)。
///
/// 保留原全部静态字段,登录模块及后续模块按原方式引用 FitTheme.xxx。
class FitTheme {
  static Color backgroundColor = const Color(0xFFF5F5F5);
  static Color secondbackGround = const Color.fromARGB(255, 255, 255, 255);
  static Color backgroundColorOld = const Color.fromARGB(255, 0, 0, 0);
  static Color secondbackGroundOld = const Color.fromARGB(255, 15, 15, 15);
  static Color threebackGround = const Color.fromARGB(255, 228, 233, 238);
  static Color textColor = const Color.fromARGB(255, 0, 0, 0);
  static Color textButtonColor = const Color.fromARGB(255, 255, 255, 255);
  static String fontFamily = AppFonts.hofontblod;
  static String fontNumberFamily = AppFonts.bebas;
  static Color buttonColor = const Color(0xff2962ff);
  static double fonSizeSmall = 15.sp;
  static double fonSizeBig = 20.sp;
  static double fonSizeBigBig = 28.sp;
  static Color threeRingsColorOutSide = const Color.fromARGB(255, 255, 162, 0);
  static Color threeRingsColorMiddle = const Color.fromARGB(255, 44, 128, 253);
  static Color threeRingsColorInSide = const Color.fromARGB(255, 245, 55, 33);
  static Color loadingColor = const Color.fromARGB(255, 40, 245, 33);
  static Color threeRingsColorbackGroundOutSide = const Color.fromARGB(
    255,
    255,
    236,
    204,
  );
  static Color threeRingsColorbackGroundMiddle = const Color.fromARGB(
    255,
    214,
    230,
    255,
  );
  static Color threeRingsColorbackGroundInSide = const Color.fromARGB(
    255,
    253,
    215,
    212,
  );
  static Color threeRingsColorbackGroundOutSide2 = const Color.fromARGB(
    255,
    196,
    164,
    108,
  );
  static Color threeRingsColorbackGroundMiddle2 = const Color.fromARGB(
    255,
    77,
    132,
    220,
  );
  static Color threeRingsColorbackGroundInSide2 = const Color.fromARGB(
    255,
    201,
    107,
    100,
  );
  static Color threeRingsColorOutSidecourse = const Color.fromARGB(
    255,
    255,
    162,
    0,
  );
  static Color threeRingsColorMiddlecourse = const Color.fromARGB(
    255,
    44,
    128,
    253,
  );
  static Color threeRingsColorInSidecourse = const Color.fromARGB(
    255,
    245,
    55,
    33,
  );

  static Color threeRingsColorbackGroundOutSidecourse = const Color.fromARGB(
    255,
    63,
    44,
    12,
  );
  static Color threeRingsColorbackGroundMiddlecourse = const Color.fromARGB(
    255,
    21,
    38,
    63,
  );
  static Color threeRingsColorbackGroundInSidecourse = const Color.fromARGB(
    255,
    61,
    23,
    19,
  );
  static Color threeRingsColorbackGroundOutSide2course = const Color.fromARGB(
    255,
    196,
    164,
    108,
  );
  static Color threeRingsColorbackGroundMiddle2course = const Color.fromARGB(
    255,
    77,
    132,
    220,
  );
  static Color threeRingsColorbackGroundInSidecourse2course = const Color.fromARGB(
    255,
    201,
    107,
    100,
  );
}
