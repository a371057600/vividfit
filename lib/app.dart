import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/them_change.dart';
import 'core/routing/app_router.dart';
import 'l10n/app_localizations.dart';

/// 应用根 Widget(1:1 复刻旧项目 ThemeData + ScreenUtilInit + i18n)。
///
/// 保留:dark 主题、iOS 平台、dividerColor grey、iconTheme/textTheme 用 FitTheme、
/// 文本不缩放(旧 FlutterSmartDialog.init 的 MediaQuery textScaler noScaling)。
class VividFitApp extends ConsumerWidget {
  const VividFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return ScreenUtilInit(
      designSize: const Size(750, 1624),
      builder: (context, child) {
        return MediaQuery(
          // 旧项目 builder 内 textScaler: TextScaler.noScaling
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: MaterialApp.router(
            title: 'Vivid Fit',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              dividerColor: Colors.grey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              platform: TargetPlatform.iOS,
              primarySwatch: Colors.blue,
              iconTheme: IconThemeData(color: FitTheme.textColor),
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: FitTheme.fonSizeSmall,
                  color: FitTheme.textColor,
                ),
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            // 1:1 复刻旧 main.dart localeListResolutionCallback:
            // 显式把系统 locale 映射到 supportedLocales 中的项,
            // 避免 Flutter 默认 resolution 在 zh_Hans_CN 等带 script/country 的
            // locale 下 fallback 到英文(en 是 supportedLocales 首项)。
            localeListResolutionCallback: (locales, supportedLocales) {
              if (locales == null || locales.isEmpty) {
                return const Locale('en');
              }
              final lang = locales.first.languageCode;
              if (lang == 'zh') {
                // 简中/繁中统一命中 Locale('zh'),由 arb 内容区分
                return const Locale('zh');
              }
              // 其它语言 fallback 英文(与旧项目一致)
              return const Locale('en');
            },
            routerConfig: router,
          ),
        );
      },
    );
  }
}
