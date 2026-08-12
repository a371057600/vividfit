import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/user_info.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../bridge/realscene_bridge.dart';

part 'game_webview_scaffold.g.dart';

// ============================================================================
// 通用游戏模式 WebView 脚手架
//
// 4 种设备（单车/跑步机/椭圆机/划船机）× 2 个游戏 = 8 个页面共用此组件。
// 差异通过 deviceType + gameIndex 自动切换 URL。
// 复用 RealsceneBridge 抽象接口，Mock/Ftms 实现自动可用。
//
// 与实景模式的差异：
//   - 定时器间隔：划船机 1000ms，其他设备 500ms
//   - URL 路径：游戏专用路径（webBicycle / webRun / webRobot / webCanoeing 等）
//   - 其余协议处理（07/08/300/010/gradient/000）完全相同
// ============================================================================

class GameWebViewScaffold extends ConsumerStatefulWidget {
  const GameWebViewScaffold({
    super.key,
    required this.deviceType,
    required this.gameIndex,
  });

  final FtmsDeviceType deviceType;
  final int gameIndex;

  @override
  ConsumerState<GameWebViewScaffold> createState() =>
      _GameWebViewScaffoldState();
}

class _GameWebViewScaffoldState
    extends ConsumerState<GameWebViewScaffold> {
  InAppWebViewController? _webViewController;
  late RealsceneBridge _bridge;

  bool _isWebViewReady = false;
  bool _flagetoSendData = false;
  bool _sendPauseflag = true;

  StreamSubscription<RealsceneSportData>? _sportSub;
  StreamSubscription<bool>? _pauseSub;

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
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
    ]);

    _bridge = ref.read(gameRealsceneBridgeProvider(
      deviceType: widget.deviceType,
      gameIndex: widget.gameIndex,
    ));

    _sportSub = _bridge.sportDataStream.listen(_pushSportDataToWeb);
    _pauseSub = _bridge.pauseEventStream.listen(_onPauseEvent);

    _logWeb('初始化完成 deviceType=${widget.deviceType} gameIndex=${widget.gameIndex}');
  }

  @override
  void dispose() {
    _logDispose('开始释放资源');

    _loadingDismissTimer?.cancel();
    _sportSub?.cancel();
    _pauseSub?.cancel();

    Future<void>(() async {
      try {
        await _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri('about:blank')),
        );
      } catch (_) {}
    });

    _logDispose('释放完成');
    super.dispose();
  }

  // ==========================================================================
  // 2. URL 映射（严格对应旧项目 8 个游戏页面）
  // ==========================================================================

  static const String kBaseCn = 'https://gamifits.fitmonster.club';
  static const String kBaseEn = 'https://www.fitmonster.net';

  WebUri _buildTargetUrl() {
    final isCn = Localizations.localeOf(context).languageCode == 'zh';
    final base = isCn ? kBaseCn : kBaseEn;

    final path = _resolveGamePath(widget.deviceType, widget.gameIndex);
    final url = WebUri('$base$path');
    _logWeb('加载 URL: $url (isCn=$isCn, deviceType=${widget.deviceType}, gameIndex=${widget.gameIndex})');
    return url;
  }

  /// 游戏路径解析 — 严格对应旧项目 8 个 URL
  static String _resolveGamePath(FtmsDeviceType deviceType, int gameIndex) {
    return switch (deviceType) {
      // === 单车 ===
      FtmsDeviceType.indoorBike ||
      FtmsDeviceType.strengthStation =>
        gameIndex == 1 ? '/training/outDoor/webBicycle/' : '/training/outDoor/web2DBike/',

      // === 跑步机 ===
      FtmsDeviceType.treadmill =>
        gameIndex == 1 ? '/training/webRun/' : '/training/outDoor/webRunCar/',

      // === 椭圆机 ===
      FtmsDeviceType.crossTrainer =>
        gameIndex == 1 ? '/training/outDoor/webRobot/' : '/training/outDoor/webEllipticalCar',

      // === 划船机 ===
      FtmsDeviceType.rower =>
        gameIndex == 1 ? '/training/outDoor/webCanoeing/' : '/training/outDoor/webCanoeingCar/',
    };
  }

  // ==========================================================================
  // 3. UI 构建
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBackTap();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: _buildInAppWebView()),
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
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        allowsPictureInPictureMediaPlayback: true,
        transparentBackground: true,
      ),
      initialUrlRequest: URLRequest(url: _buildTargetUrl()),
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;

        controller.addJavaScriptHandler(
          handlerName: 'SendMessage',
          callback: (List<dynamic> args) {
            if (args.isEmpty) return;
            _handleWebMessage(args.first.toString());
            return null;
          },
        );
        _logWeb('SendMessage Handler 已注册');
      },
      onLoadStop: (InAppWebViewController controller, WebUri? uri) async {
        _logWeb('页面加载完成: uri=$uri');
        _isWebViewReady = true;
        await _injectJavaScriptChannelCompatibility(controller);
      },
      onReceivedError: (_, _, WebResourceError error) {
        _logWeb('⚠️ 加载错误: ${error.description}');
      },
      onConsoleMessage: (_, ConsoleMessage message) {
        if (message.messageLevel != ConsoleMessageLevel.LOG) {
          _logWeb('Console[${message.messageLevel.toString().split('.').last}]: ${message.message}');
        }
      },
    );
  }

  // ==========================================================================
  // 4. Web → Flutter：SendMessage 协议处理
  // ==========================================================================

  Future<void> _handleWebMessage(String raw) async {
    _logBridge('⬅️ Web 发消息: raw="$raw"');

    if (raw.trim() == '300') {
      return _respondUserInfo300();
    }

    if (raw.trim() == '07') {
      _flagetoSendData = true;
      _sendPauseflag = true;
      await _bridge.startSport();
      _logBridge('✅ 07 已执行，flagetoSendData=true');
      return;
    }

    if (raw.trim() == '08') {
      _flagetoSendData = false;
      await _bridge.stopSport();
      _logBridge('✅ 08 已执行，flagetoSendData=false');
      return;
    }

    if (raw.trim() == '010') {
      return _showLoading010();
    }

    final trimmed = raw.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return _tryHandleGradientJson(trimmed);
    }

    _logBridge('ℹ️ 未识别的 Web 消息（忽略）');
  }

  Future<void> _respondUserInfo300() async {
    final storage = ref.read(storageServiceProvider);
    final authState = ref.read(authProvider);
    final FitUserInfo? userInfo = authState.userInfo;

    final int? userId = storage.userId;
    final String? token = storage.accessToken;
    final String nickName =
        userInfo?.nickName ?? storage.username ?? '';
    final String headImage = userInfo?.headImage ?? storage.headImageHash ?? '';

    if (token == null || token.isEmpty || userId == null) {
      _logBridge('⚠️ token/userId 缺失：token=${token == null ? "null" : "✓"} '
          'userId=$userId — 仍回传，字段填空字符串');
    }

    final message = <String, dynamic>{
      'msg': '300',
      'data': <String, dynamic>{
        'userId': '$userId',
        'nickName': nickName,
        'headImage': headImage,
        'token': token ?? '',
      },
    };
    final jsonData = jsonEncode(message);
    _logBridge('➡️ 回传 300 token JSON — userId=$userId nickName="$nickName"');
    await _safeEvalJs('callUnityWithjsonData($jsonData);');
  }

  Future<void> _showLoading010() async {
    if (_isLoadingDialogShown) return;
    _isLoadingDialogShown = true;
    _logBridge('🎯 显示 010 LoadingDialog（15s 自动关闭）');

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
      _logBridge('🧹 15s 到达，自动关闭 010 LoadingDialog');
    });
  }

  Future<void> _tryHandleGradientJson(String raw) async {
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['msg'] == 'gradient') {
        final int? drag = (json['data'] as Map<String, dynamic>?)?['drag'] as int?;
        if (drag != null) {
          _logBridge('➡️ gradient drag=$drag — 转调 Bridge.setGradientLevel');
          await _bridge.setGradientLevel(drag);
        }
      }
    } catch (e) {
      _logBridge('⚠️ gradient JSON 解析失败: e=$e  raw=$raw');
    }
  }

  // ==========================================================================
  // 5. Flutter → Web：数据推送 / 暂停事件 / JS 兼容性注入
  // ==========================================================================

  Future<void> _pushSportDataToWeb(RealsceneSportData data) async {
    if (!_flagetoSendData || !_bridge.isDeviceReady || !_isWebViewReady) return;

    final unityMap = data.toUnityJson(widget.deviceType);
    final Map<String, dynamic> wrapper = <String, dynamic>{
      'msg': 'IndoorBikeData',
      'data': unityMap,
    };
    final jsonData = jsonEncode(wrapper);

    _logData('➡️ Push: IndoorBikeData dist=${unityMap['totalDistance']} '
        'speed=${unityMap['instantaneousSpeed']} cad=${unityMap['instantaneousCadence']} '
        '${unityMap['strokeRate'] != null ? 'stroke=${unityMap['strokeRate']}' : ''}');
    await _safeEvalJs('callUnityWithjsonData($jsonData);');
  }

  Future<void> _onPauseEvent(bool isPaused) async {
    if (isPaused && _sendPauseflag) {
      _sendPauseflag = false;
      _logBridge('⏸ 暂停事件触发 → 推送 callUnityWithString("0x02")');
      await _safeEvalJs('callUnityWithString("0x02");');
    }
  }

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
      _logWeb('JS 兼容性注入成功（window.SendMessage → Flutter handler）');
    } catch (e) {
      _logWeb('⚠️ JS 兼容性注入异常（不影响主流程）: e=$e');
    }
  }

  // ==========================================================================
  // 6. 返回按钮（协议：000 → 延迟 1s → pop）
  // ==========================================================================

  Future<void> _handleBackTap() async {
    _logBridge('🔙 返回按钮：先 callUnityWithString("000") 通知 Unity 保存，1s 后 pop');
    try {
      if (_isWebViewReady && _webViewController != null) {
        await _webViewController!.evaluateJavascript(
          source: 'callUnityWithString("000");',
        );
      }
    } catch (e) {
      _logBridge('⚠️ 返回前 000 通知 Unity 失败（不影响 pop）: e=$e');
    }
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

  Future<void> _safeEvalJs(String source) async {
    if (_webViewController == null) {
      _logWeb('⚠️ JS 注入跳过：_webViewController=null');
      return;
    }
    if (!_isWebViewReady) {
      _logWeb('⚠️ JS 注入跳过：_isWebViewReady=false');
      return;
    }
    try {
      await _webViewController!.evaluateJavascript(source: source);
    } catch (e) {
      _logWeb('⚠️ JS 注入异常: e=$e');
    }
  }

  // ========== 日志前缀（Game 专用） ==========
  void _logWeb(String msg) => debugPrintSynchronize('🎮 [Game-WebView] $msg');
  void _logBridge(String msg) =>
      debugPrintSynchronize('🎮 [Game-Bridge] $msg');
  void _logData(String msg) => debugPrintSynchronize('🎮 [Game-Data] $msg');
  void _logDispose(String msg) =>
      debugPrintSynchronize('🧹 [GameDispose] $msg');

  static void debugPrintSynchronize(String msg) {
    // ignore: avoid_print
    print(msg);
  }
}

// ============================================================================
// GameBridge：游戏模式专用 Bridge 实现
// 与 MockRealsceneBridge 的核心差异：定时器间隔
//   - 划船机: 1000ms
//   - 其他设备: 500ms
// ============================================================================

class GameRealsceneBridge implements RealsceneBridge {
  GameRealsceneBridge(this.deviceType, this.gameIndex);

  final FtmsDeviceType deviceType;
  final int gameIndex;

  final StreamController<RealsceneSportData> _sportCtrl =
      StreamController<RealsceneSportData>.broadcast();
  final StreamController<bool> _pauseCtrl = StreamController<bool>.broadcast();
  Timer? _timer;

  double _mockDistance = 0;
  double _mockEnergy = 0;
  int _mockElapsedSec = 0;
  double _mockCadence = 80;
  double _mockSpeed = 22;
  double _mockStrokeRate = 30;
  double _mockTotalStrokes = 0;

  /// 定时器间隔：划船机 1000ms，其他 500ms
  Duration get _tickInterval =>
      deviceType == FtmsDeviceType.rower
          ? const Duration(milliseconds: 1000)
          : const Duration(milliseconds: 500);

  @override
  bool get isDeviceReady => true;

  @override
  Stream<RealsceneSportData> get sportDataStream => _sportCtrl.stream;

  @override
  Stream<bool> get pauseEventStream => _pauseCtrl.stream;

  @override
  Future<void> startSport() async {
    _debugPrint('startSport() — 开启 ${_tickInterval.inMilliseconds}ms Mock 数据推送');
    _startMockTicker();
  }

  @override
  Future<void> stopSport() async {
    _debugPrint('stopSport() — 停止 Mock 数据推送');
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> setGradientLevel(int level) async {
    _debugPrint('setGradientLevel(level=$level) — 暂存 Mock，蓝牙阶段下发设备');
  }

  @override
  void dispose() {
    _debugPrint('dispose() — 释放 Timer/StreamController');
    _timer?.cancel();
    _timer = null;
    _sportCtrl.close();
    _pauseCtrl.close();
  }

  void _startMockTicker() {
    if (_timer != null) return;
    _timer = Timer.periodic(_tickInterval, (_) {
      _mockElapsedSec += 1;
      _mockDistance += 5.0;
      _mockEnergy += 0.2;
      _mockCadence = 75 + _mockCadence % 20;
      _mockSpeed = 20 + (_mockSpeed + 1) % 8;

      final rower = deviceType == FtmsDeviceType.rower;
      if (rower) {
        _mockStrokeRate = 25 + (_mockStrokeRate + 1) % 15;
        _mockTotalStrokes += 1.0;
      }

      final data = RealsceneSportData(
        instantaneousSpeed: _mockSpeed,
        instantaneousCadence: _mockCadence,
        totalDistance: _mockDistance,
        totalEnergy: _mockEnergy,
        elapsedTime: _formatElapsed(_mockElapsedSec),
        heartRate: 110 + (_mockElapsedSec % 30),
        strokeRate: rower ? _mockStrokeRate : null,
        totalStrokes: rower ? _mockTotalStrokes : null,
      );

      if (!_sportCtrl.isClosed) _sportCtrl.add(data);
    });
  }

  static String _formatElapsed(int totalSec) {
    final mins = totalSec ~/ 60;
    final secs = totalSec % 60;
    final mm = '${mins < 10 ? '0' : ''}$mins';
    final ss = '${secs < 10 ? '0' : ''}$secs';
    return '$mm:$ss';
  }

  void _debugPrint(String msg) {
    // ignore: avoid_print
    print('🎮 [GameBridge/$deviceType/game$gameIndex] $msg');
  }
}

// ============================================================================
// Riverpod Provider：游戏模式 Bridge
// ============================================================================

@Riverpod(dependencies: <Object>[])
RealsceneBridge gameRealsceneBridge(
  Ref ref, {
  required FtmsDeviceType deviceType,
  required int gameIndex,
}) {
  final bridge = GameRealsceneBridge(deviceType, gameIndex);
  ref.onDispose(bridge.dispose);
  return bridge;
}