// ignore_for_file: depend_on_referenced_packages

import 'package:fit_monster/screens/home/page/mian/home_screen.dart';
import 'package:fit_monster/screens/login/page/new_login_screen.dart';
import 'package:fit_monster/util/jsp_name.dart';
import 'package:fit_monster/util/them_change_tool.dart';
import 'package:fit_monster/util/user_storage_service.dart';
import 'package:fit_monster/util/smartBand/bluetooth/silent_reconnect_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fit_monster/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'model/save_data.dart';
import 'route/router.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:video_player/video_player.dart';
import 'package:fit_monster/util/privacy_service.dart';
import 'package:fit_monster/widgets/privacy_policy_dialog.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  await ScreenUtil.ensureScreenSize();
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  await GetStorage.init();
  Get.put(UserStorageService(), permanent: true);
  Get.put(SilentReconnectService(), permanent: true);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemStatusBarContrastEnforced: true,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  // GestureBinding.instance.resamplingEnabled = true;
  GestureBinding.instance.resamplingEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print("Get Height ==${Get.height}");
    final box = GetStorage();
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    box.write(JSpName.devicePixelRatio, devicePixelRatio);

    return ScreenUtilInit(
      designSize: const Size(750, 1624),
      builder: (_, build) {
        return ProviderScope(
          child: GetMaterialApp(
            title: 'Fit Monster'.tr,
            translations: Messages(),
            fallbackLocale: const Locale('en', 'US'),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ja', 'JP'),
              Locale('zh', 'CN'),
              Locale('zh', 'Hant'),
              Locale('tw', 'Hant'),
              Locale('hk', 'Hant'),
              Locale('de', 'DE'),
              Locale('pt', 'BR'),
              Locale('es', 'ES'),
              Locale('ru', 'RU'),
              Locale('it', 'IT'),
              Locale('ko', 'KR'),
              Locale('fr', 'FR'),
              Locale('ar', 'SA'),
            ],
            darkTheme: ThemeData.light(),
            themeMode: ThemeMode.light,
            locale: View.of(context).platformDispatcher.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeListResolutionCallback: (
              List<Locale>? locales,
              Iterable<Locale>? supportedLocales,
            ) {
              Locale locale;

              box.write(JSpName.languageNum, 0);
              box.write(
                JSpName.localData,
                "${locales![0].languageCode}_${locales[0].countryCode}",
              );
              if (locales[0].languageCode == "de") {
                box.write(JSpName.languageNum, 6);
              } else if (locales[0].languageCode == "ja") {
                box.write(JSpName.languageNum, 3);
              } else if (locales[0].languageCode == "tw") {
                box.write(JSpName.languageNum, 4);
              } else if (locales[0].languageCode == "pt") {
                box.write(JSpName.languageNum, 5);
              }
              box.write(JSpName.localInChinese, false);
              box.write(JSpName.isSimpleChinese, false);

              if (locales[0].languageCode == 'en') {
                box.write(JSpName.languageNum, 1);
                locale = const Locale('en', 'US');
                SaveData.english = true;
              } else if (locales[0].languageCode == 'zh') {
                locale = const Locale('zh', 'CN');
                box.write(JSpName.languageNum, 0);
                box.write(JSpName.country, "China");
                box.write(JSpName.countryCode, "86");
                box.write(JSpName.localInChinese, true);

                if (locales[0].scriptCode == "Hant" ||
                    locales[0].countryCode != "CN") {
                  box.write(JSpName.isSimpleChinese, false);
                  box.write(JSpName.languageNum, 2);
                } else {
                  box.write(JSpName.languageNum, 0);
                  box.write(JSpName.isSimpleChinese, true);
                }
                SaveData.english = false;
                box.write(JSpName.isEnglish, false);
              } else {
                locale = const Locale('en', 'US');
                SaveData.english = true;
                SaveData.country = '';
                box.write(JSpName.isEnglish, true);
              }
              return locale;
            },
            theme: ThemeData(
              brightness: Brightness.dark,
              // fontFamily: "hofontregular",
              dividerColor: Colors.grey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              platform: TargetPlatform.iOS,
              primarySwatch: Colors.red,
              iconTheme: IconThemeData(color: ThemChange.textColor),
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: ThemChange.fonSizeSmall,
                  color: ThemChange.textColor,
                ),
              ),
            ),
            builder: FlutterSmartDialog.init(
              //default toast widget
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.noScaling),
                  child: child!,
                );
              },
            ),
            home: AnimatedSplashScreen(
              duration: 2900,
              splashIconSize: 900,
              splash: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: _VideoSplashWidget(videoPath: "images/fengmian.mp4"),
              ),
              nextScreen: PrivacyWrapper(
                child:
                    box.hasData(JSpName.firstOpenApp) == false ||
                            box.read(JSpName.firstOpenApp) == true
                        ? const NewLoginScreen()
                        : const MyHomePage(),
              ),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            ),
            // initialRoute: box.read("firstOpenApp") == false ? "/HomePage" : "/",
            getPages: AppRouter.pages,
            navigatorObservers: [routeObserver],
          ),
        );
      },
    );
  }
}

class _VideoSplashWidget extends StatefulWidget {
  final String videoPath;

  const _VideoSplashWidget({required this.videoPath});

  @override
  State<_VideoSplashWidget> createState() => _VideoSplashWidgetState();
}

class _VideoSplashWidgetState extends State<_VideoSplashWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setVolume(0);
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}

/// 隐私政策弹窗包装器
class PrivacyWrapper extends StatefulWidget {
  final Widget child;

  const PrivacyWrapper({super.key, required this.child});

  @override
  State<PrivacyWrapper> createState() => _PrivacyWrapperState();
}

class _PrivacyWrapperState extends State<PrivacyWrapper> {
  final PrivacyService _privacyService = PrivacyService();
  bool _privacyAgreed = false;

  @override
  void initState() {
    super.initState();
    debugPrint('PrivacyWrapper: initState');
    _checkPrivacyPolicy();
  }

  void _checkPrivacyPolicy() {
    debugPrint('PrivacyWrapper: _checkPrivacyPolicy');
    if (_privacyService.shouldShowPrivacyDialog()) {
      // 需要显示弹窗，延迟到下一帧
      debugPrint('PrivacyWrapper: 需要显示弹窗');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPrivacyDialog();
      });
    } else {
      // 不需要显示弹窗，直接标记为已同意
      debugPrint('PrivacyWrapper: 不需要显示弹窗，直接标记为已同意');
      setState(() {
        _privacyAgreed = true;
      });
    }
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => PrivacyPolicyDialog(
            onAgree: () {
              debugPrint('PrivacyWrapper: 用户点击同意');
              _privacyService.agreePrivacyPolicy();
              Navigator.of(dialogContext).pop();
              setState(() {
                _privacyAgreed = true;
              });
            },
            onReject: () {
              debugPrint('PrivacyWrapper: 用户点击拒绝');
              _privacyService.rejectPrivacyPolicy();
              SystemNavigator.pop();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 如果隐私政策未同意，显示空容器或加载指示器
    if (!_privacyAgreed) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return widget.child;
  }
}
