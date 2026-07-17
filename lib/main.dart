import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'app.dart';
import 'core/services/storage_service_provider.dart';
import 'core/services/storage_service.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  final storageService = await StorageService.create();

  // 1:1 复刻旧 main.dart 的 SystemChrome 设置。
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
      systemStatusBarContrastEnforced: true,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  GestureBinding.instance.resamplingEnabled = false;

  // 1:1 复刻旧 localeListResolutionCallback:按系统语言写 languageNum/country/countryCode。
  final locale = PlatformDispatcher.instance.locale;
  int languageNum = 1; // 默认英语
  String country = '';
  String countryCode = '';
  if (locale.languageCode == 'zh') {
    if (locale.scriptCode == 'Hant' || locale.countryCode != 'CN') {
      languageNum = 2; // 繁中
    } else {
      languageNum = 0; // 简中
      country = 'China';
      countryCode = '86';
    }
  }
  await storageService.setLanguageNum(languageNum);
  if (country.isNotEmpty) await storageService.setCountry(country);
  if (countryCode.isNotEmpty) await storageService.setCountryCode(countryCode);

  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const VividFitApp(),
    ),
  );
}
