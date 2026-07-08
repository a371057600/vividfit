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
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
          // 旧项目 builder 内 textScaler: TextScaler.noScaling
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.noScaling),
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
            locale: View.of(context).platformDispatcher.locale,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
