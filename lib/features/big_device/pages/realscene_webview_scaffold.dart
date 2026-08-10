import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/user_info.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../bridge/realscene_bridge.dart';

// ============================================================================
// 通用实景模式 WebView 脚手架
//
// 4 种设备（单车/跑步机/椭圆机/划船机）100% 共用此组件。
// 差异通过 FtmsDeviceType 自动切换：
//   - URL 路径（BicyclePlayerWebGL / RunnerPlayerWebGL / CanoeingPlayerWebGL）
//   - 500ms 上报 JSON 字段（划船机 speed/cadence 置 0，追加 stroke 字段）
//
// 与蓝牙完全解耦：仅依赖 RealsceneBridge 抽象；蓝牙接入阶段不改此文件。
// ============================================================================

class RealsceneWebViewScaffold extends ConsumerStatefulWidget {
  const RealsceneWebViewScaffold({super.key, required this.deviceType});

  final FtmsDeviceType deviceType;

  @override
  ConsumerState<RealsceneWebViewScaffold> createState() =>
      _RealsceneWebViewScaffoldState();
}

class _RealsceneWebViewScaffoldState
    extends ConsumerState<RealsceneWebViewScaffold> {
  InAppWebViewController? _webViewController;
  late RealsceneBridge _bridge;

  // === WebView 生命周期守卫 ===
  bool _isWebViewReady = false;
  bool _flagetoSendData = false; // 收到 07=true，08=false
  bool _sendPauseflag = true; // 暂停事件触发防抖

  // === Stream 订阅句柄 ===
  StreamSubscription<RealsceneSportData>? _sportSub;
  StreamSubscription<bool>? _pauseSub;

  // === 010 Loading 相关 ===
  bool _isLoadingDialogShown = false;
  Timer? _loadingDismissTimer;

  // ==========================================================================
  // 1. 生命周期
  // ==========================================================================

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    // 1. 强制横屏 + 沉浸式（与旧版 1:1）
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
    ]);

    // 2. 获取 Bridge（Mock/Ftms 由 Provider 决定）
    _bridge = ref.read(realsceneBridgeProvider(deviceType: widget.deviceType));

    // 3. 订阅 Bridge 数据 → 500ms 推给 Web
    _sportSub = _bridge.sportDataStream.listen(_pushSportDataToWeb);
    _pauseSub = _bridge.pauseEventStream.listen(_onPauseEvent);

    logWeb('初始化完成 deviceType=${widget.deviceType}');
  }

  @override
  void dispose() {
    logDispose('开始释放资源');

    // 010 定时器
    _loadingDismissTimer?.cancel();

    // Stream 订阅
    _sportSub?.cancel();
    _pauseSub?.cancel();

    // WebView 强制加载空白 + 延迟释放（防止 iOS Unity WebGL 内存泄漏崩溃）
    Future<void>(() async {
      try {
        await _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri('about:blank')),
        );
      } catch (_) {}
    });

    logDispose('释放完成');
    super.dispose();
  }

  // ==========================================================================
  // 2. URL 解析（完全对应旧版 4 文件）
  // ==========================================================================

  static const String kBaseCn = 'https://gamifits.fitmonster.club/training/outDoor';
  static const String kBaseEn = 'https://www.fitmonster.net/training/outDoor';

  WebUri _buildTargetUrl() {
    // isCn：用当前本地化语言判断（等价旧版 languageNum==0）
    final isCn = Localizations.localeOf(context).languageCode == 'zh';
    final base = isCn ? kBaseCn : kBaseEn;

    final path = switch (widget.deviceType) {
      FtmsDeviceType.indoorBike ||
      FtmsDeviceType.strengthStation =>
        'BicyclePlayerWebGL/',
      FtmsDeviceType.treadmill || FtmsDeviceType.crossTrainer =>
        'RunnerPlayerWebGL/',
      FtmsDeviceType.rower => 'CanoeingPlayerWebGL/',
    };
    final url = WebUri('$base/$path');
    logWeb('加载 URL: $url (isCn=$isCn)');
    return url;
  }

  // ==========================================================================
  // 3. UI 构建
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // 拦截系统返回键：必须走左上角按钮（执行 000 → 延迟 1s → pop 协议）
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBackTap();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            // ============= 底层：全屏 WebView =============
            Positioned.fill(child: _buildInAppWebView()),
            // ============= 左上角白色返回按钮（1:1 还原旧版位置） =============
            Positioned(
              top: 50.h,
              left: 15.w,
              child: InkWell(
                onTap: _handleBackTap,
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInAppWebView() {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false, // 允许 Unity 自动播放音视频
        allowsInlineMediaPlayback: true, // iOS 内嵌播放
        allowsPictureInPictureMediaPlayback: true,
        transparentBackground: true,
      ),
      initialUrlRequest: URLRequest(url: _buildTargetUrl()),
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;

        // ========== Web → Flutter：注册 SendMessage 核心 Handler ==========
        controller.addJavaScriptHandler(
          handlerName: 'SendMessage',
          callback: (List<dynamic> args) {
            if (args.isEmpty) return;
            _handleWebMessage(args.first.toString());
            return null;
          },
        );
        logWeb('SendMessage Handler 已注册');
      },
      onLoadStop: (InAppWebViewController controller, WebUri? uri) async {
        logWeb('页面加载完成: uri=$uri');
        _isWebViewReady = true;
        // 注入 SendMessage 兼容性函数（Unity WebGL 侧可能依赖 window.SendMessage）
        await _injectJavaScriptChannelCompatibility(controller);
      },
      onReceivedError: (_, __, WebResourceError error) {
        logWeb('⚠️ 加载错误: ${error.description}');
      },
      onConsoleMessage: (_, ConsoleMessage message) {
        // 仅在非 message level LOG 时打印，避免 Unity 打印风暴
        if (message.messageLevel != ConsoleMessageLevel.LOG) {
          logWeb('Console[${message.messageLevel.toString().split('.').last}]: ${message.message}');
        }
      },
    );
  }

  // ==========================================================================
  // 4. Web → Flutter：SendMessage 协议处理（严格 1:1 对应旧版 4 文件）
  // ==========================================================================

  Future<void> _handleWebMessage(String raw) async {
    logBridge('⬅️ Web 发消息: raw="$raw"');

    // === 协议 1：纯字符串 "300" — Web 请求用户信息/token ===
    if (raw.trim() == '300') {
      return _respondUserInfo300();
    }

    // === 协议 2：纯字符串 "07" — Web 端点击「开始运动」===
    if (raw.trim() == '07') {
      _flagetoSendData = true;
      _sendPauseflag = true;
      await _bridge.startSport();
      logBridge('✅ 07 已执行，flagetoSendData=true');
      return;
    }

    // === 协议 3：纯字符串 "08" — Web 端点击「停止运动」===
    if (raw.trim() == '08') {
      _flagetoSendData = false;
      await _bridge.stopSport();
      logBridge('✅ 08 已执行，flagetoSendData=false');
      return;
    }

    // === 协议 4：纯字符串 "010" — Unity 场景加载 Loading 弹窗 15s ===
    if (raw.trim() == '010') {
      return _showLoading010();
    }

    // === 协议 5：JSON gradient 坡度控制 ===
    final trimmed = raw.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return _tryHandleGradientJson(trimmed);
    }

    logBridge('ℹ️ 未识别的 Web 消息（忽略）');
  }

  // --------- 协议 1: 300 用户信息回传 ---------
  Future<void> _respondUserInfo300() async {
    final storage = ref.read(storageServiceProvider);
    final authState = ref.read(authProvider);
    final FitUserInfo? userInfo = authState.userInfo;

    final int? userId = storage.userId;
    final String? token = storage.accessToken;
    final String? nickName =
        userInfo?.nickName ?? storage.username ?? '';
    final String? headImage = userInfo?.headImage ?? storage.headImageHash ?? '';

    if (token == null || token.isEmpty || userId == null) {
      logBridge('⚠️ token/userId 缺失：token=${token == null ? "null" : "✓"} '
          'userId=$userId — 仍回传，字段填空字符串');
    }

    final message = <String, dynamic>{
      'msg': '300',
      'data': <String, dynamic>{
        'userId': '$userId',
        'nickName': nickName ?? '',
        'headImage': headImage ?? '',
        'token': token ?? '',
      },
    };
    final jsonData = jsonEncode(message);
    logBridge('➡️ 回传 300 token JSON — userId=$userId nickName="${nickName ?? ''}"');
    await _safeEvalJs('callUnityWithjsonData($jsonData);');
  }

  // --------- 协议 4: 010 Loading 15s 自动关闭 ---------
  Future<void> _showLoading010() async {
    if (_isLoadingDialogShown) return;
    _isLoadingDialogShown = true;
    logBridge('🎯 显示 010 LoadingDialog（15s 自动关闭）');

    if (!mounted) return;
    final BuildContext dialogCtx = context;
    unawaited(
      showDialog<void>(
        context: dialogCtx,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            child: Center(
              child: Container(
                width: 160.w,
                height: 140.h,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: CircularProgressIndicator(
                        color: FitTheme.buttonColor,
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    _loadingDismissTimer?.cancel();
    _loadingDismissTimer = Timer(const Duration(seconds: 15), () {
      if (!mounted) return;
      final NavigatorState nav = Navigator.of(dialogCtx);
      if (nav.canPop()) {
        nav.pop();
      }
      _isLoadingDialogShown = false;
      logBridge('🧹 15s 到达，自动关闭 010 LoadingDialog');
    });
  }

  // --------- 协议 5: JSON gradient 坡度/阻力 ---------
  Future<void> _tryHandleGradientJson(String raw) async {
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['msg'] == 'gradient') {
        final int? drag = (json['data'] as Map<String, dynamic>?)?['drag'] as int?;
        if (drag != null) {
          logBridge('➡️ gradient drag=$drag — 转调 Bridge.setGradientLevel');
          await _bridge.setGradientLevel(drag);
        }
      }
    } catch (e) {
      logBridge('⚠️ gradient JSON 解析失败: e=$e  raw=$raw');
    }
  }

  // ==========================================================================
  // 5. Flutter → Web：数据推送 / 暂停事件 / JS 兼容性注入
  // ==========================================================================

  /// 500ms Bridge 数据到达 → 序列化（按设备类型差异化）→ 注入 Web
  Future<void> _pushSportDataToWeb(RealsceneSportData data) async {
    if (!_flagetoSendData || !_bridge.isDeviceReady || !_isWebViewReady) return;

    final unityMap = data.toUnityJson(widget.deviceType);
    final Map<String, dynamic> wrapper = <String, dynamic>{
      'msg': 'IndoorBikeData',
      'data': unityMap,
    };
    final jsonData = jsonEncode(wrapper);

    logData('➡️ Push: IndoorBikeData dist=${unityMap['totalDistance']} '
        'speed=${unityMap['instantaneousSpeed']} cad=${unityMap['instantaneousCadence']} '
        '${unityMap['strokeRate'] != null ? 'stroke=${unityMap['strokeRate']}' : ''}');
    await _safeEvalJs('callUnityWithjsonData($jsonData);');
  }

  /// 暂停事件：hc.isPause 变 true 时，仅推送一次 0x02
  Future<void> _onPauseEvent(bool isPaused) async {
    if (isPaused && _sendPauseflag) {
      _sendPauseflag = false;
      logBridge('⏸ 暂停事件触发 → 推送 callUnityWithString("0x02")');
      await _safeEvalJs('callUnityWithString("0x02");');
    }
  }

  /// 注入 JS 兼容性函数：window.SendMessage → Flutter handler
  Future<void> _injectJavaScriptChannelCompatibility(
      InAppWebViewController ctrl) async {
    const String compatibility = '''
(function() {
  if (typeof window.flutter_inappwebview !== 'undefined' &&
      typeof window.flutter_inappwebview.callHandler === 'function') {
    window.SendMessage = function(objectName, methodName, message) {
      try {
        var payload = typeof message === 'string' ? message : JSON.stringify(message);
        window.flutter_inappwebview.callHandler('SendMessage', payload);
      } catch (e) { console.error('[Compat] SendMessage call error:', e); }
    };
    console.log('[Compat] window.SendMessage 注入成功');
  } else {
    console.warn('[Compat] flutter_inappwebview 未就绪，SendMessage 兼容注入跳过');
  }
})();
''';
    try {
      await ctrl.evaluateJavascript(source: compatibility);
      logWeb('JS 兼容性注入成功（window.SendMessage → Flutter handler）');
    } catch (e) {
      logWeb('⚠️ JS 兼容性注入异常（不影响主流程）: e=$e');
    }
  }

  // ==========================================================================
  // 6. 返回按钮（协议：000 → 延迟 1s → pop）
  // ==========================================================================

  Future<void> _handleBackTap() async {
    logBridge('🔙 返回按钮：先 callUnityWithString("000") 通知 Unity 保存，1s 后 pop');
    try {
      if (_isWebViewReady && _webViewController != null) {
        await _webViewController!.evaluateJavascript(
          source: 'callUnityWithString("000");',
        );
      }
    } catch (e) {
      logBridge('⚠️ 返回前 000 通知 Unity 失败（不影响 pop）: e=$e');
    }
    // 严格对齐旧版：延迟 1 秒后返回
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final GoRouter router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  // ==========================================================================
  // 7. 辅助
  // ==========================================================================

  /// evaluateJavascript 的安全封装：防止 controller null / _isWebViewReady false
  Future<void> _safeEvalJs(String source) async {
    if (_webViewController == null) {
      logWeb('⚠️ JS 注入跳过：_webViewController=null');
      return;
    }
    if (!_isWebViewReady) {
      logWeb('⚠️ JS 注入跳过：_isWebViewReady=false');
      return;
    }
    try {
      await _webViewController!.evaluateJavascript(source: source);
    } catch (e) {
      logWeb('⚠️ JS 注入异常: e=$e');
    }
  }

  // ========== 日志统一前缀（方便真机过滤） ==========
  void logWeb(String msg) => debugPrintSynchronize('📡 [Realscene-WebView] $msg');
  void logBridge(String msg) =>
      debugPrintSynchronize('🌉 [Web-Bridge] $msg');
  void logData(String msg) => debugPrintSynchronize('🌉 [Web-Data] $msg');
  void logDispose(String msg) =>
      debugPrintSynchronize('🧹 [RealsceneDispose] $msg');

  static void debugPrintSynchronize(String msg) {
    // ignore: avoid_print
    print(msg);
  }
}
