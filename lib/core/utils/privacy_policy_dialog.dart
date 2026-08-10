import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as wv;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_fonts.dart';
import '../constants/them_change.dart';
import 'policy_urls.dart';

/// 首次启动隐私+用户协议确认弹窗(内嵌 WebView 直接加载在线协议)。
///
/// 设计:
///  - 顶部标题栏(标题 + 关闭按钮)
///  - 中间 InAppWebView 直接加载隐私政策 URL(无说明文字)
///  - 底部勾选 + 拒绝/同意按钮
///
/// 布局注意:
///  - mainAxisSize.max + Expanded 包裹 WebView,避免布局冲突
///  - 容器有明确高度约束,确保 WebView 能正确测量
class PrivacyPolicyDialog extends StatefulWidget {
  const PrivacyPolicyDialog({
    super.key,
    required this.languageNum,
    required this.onAgree,
    required this.onReject,
  });

  final int languageNum;

  /// 用户点击「同意并继续」时回调(已勾选)。
  final Future<void> Function() onAgree;

  /// 用户点击「拒绝」时回调。
  final Future<void> Function() onReject;

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  bool _checked = false;
  int _progress = 0;
  bool _loadError = false;
  wv.InAppWebViewController? _controller;

  String get _privacyUrl => PolicyUrls.privacy(widget.languageNum);

  @override
  void initState() {
    super.initState();
    debugPrint('🔒 [Privacy] dialog shown, lang=${widget.languageNum}');
    debugPrint('🔒 [Privacy] load url: $_privacyUrl');
  }

  @override
  Widget build(BuildContext context) {
    final isCn = widget.languageNum == 0 || widget.languageNum == 2;
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.85,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            decoration: BoxDecoration(
              color: FitTheme.secondbackGround,
              borderRadius: BorderRadius.circular(16.w),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // // ===== 顶部标题栏 =====
                // _buildHeader(isCn),
                // ===== 进度条 =====
                if (_progress < 100 && !_loadError)
                  LinearProgressIndicator(
                    value: _progress / 100.0,
                    minHeight: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FitTheme.buttonColor,
                    ),
                    backgroundColor: Colors.grey.shade300,
                  ),
                // ===== WebView 内容区 =====
                Expanded(child: _buildContent()),
                // ===== 底部勾选 + 按钮 =====
                _buildFooter(isCn),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 顶部标题栏。
  Widget _buildHeader(bool isCn) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        isCn ? '隐私政策' : 'Privacy Policy',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.w800,
          color: FitTheme.textColor,
          fontFamily: AppFonts.hofontmedium,
        ),
      ),
    );
  }

  /// WebView 内容区(直接加载在线协议,无说明文字)。
  Widget _buildContent() {
    if (_loadError) {
      return _buildErrorView();
    }
    return wv.InAppWebView(
      initialUrlRequest: wv.URLRequest(url: wv.WebUri(_privacyUrl)),
      initialSettings: wv.InAppWebViewSettings(
        allowsInlineMediaPlayback: true,
        mixedContentMode: wv.MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
        useHybridComposition: true,
        supportZoom: true,
        builtInZoomControls: true,
        displayZoomControls: false,
        allowsBackForwardNavigationGestures: true,
      ),
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
        ),
        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
      },
      onWebViewCreated: (controller) {
        _controller = controller;
        debugPrint('🔒 [Privacy] WebView created');
      },
      onProgressChanged: (_, p) {
        if (mounted) setState(() => _progress = p);
      },
      onReceivedError: (c, request, error) {
        // 仅主帧错误才标记失败,子资源错误忽略
        if (request.isForMainFrame == true) {
          debugPrint('🔒 [Privacy] main frame error: ${error.description}');
          if (mounted) setState(() => _loadError = true);
        }
      },
    );
  }

  /// 错误面板 + 重试。
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56.w, color: Colors.redAccent),
            SizedBox(height: 12.w),
            Text(
              '页面加载失败,请检查网络后重试',
              style: TextStyle(fontSize: 14.sp, color: FitTheme.textColor),
            ),
            SizedBox(height: 16.w),
            ElevatedButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _loadError = false;
                    _progress = 0;
                  });
                }
                _controller?.loadUrl(
                  urlRequest: wv.URLRequest(url: wv.WebUri(_privacyUrl)),
                );
              },
              child: const Text('重新加载'),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部勾选 + 按钮。
  Widget _buildFooter(bool isCn) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 勾选行
          InkWell(
            onTap: () => setState(() => _checked = !_checked),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              child: Row(
                children: [
                  Icon(
                    _checked
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: _checked ? FitTheme.buttonColor : Colors.grey[500],
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      isCn
                          ? '我已阅读并同意《隐私政策》和《用户协议》'
                          : 'I have read and agree to the Privacy Policy and User Agreement',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: FitTheme.textColor,
                        fontFamily: AppFonts.hofontregular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.w),
          // 按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 拒绝
              SizedBox(
                width: 250.w,
                height: 70.h,
                child: GestureDetector(
                  onTap: () async {
                    await widget.onReject();
                    if (mounted) SystemNavigator.pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(229, 235, 239, 1),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isCn ? '拒绝' : 'Decline',
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: const Color.fromRGBO(129, 149, 165, 1),
                        fontFamily: AppFonts.hofontmedium,
                      ),
                    ),
                  ),
                ),
              ),
              // 同意并继续
              SizedBox(
                width: 250.w,
                height: 70.h,
                child: GestureDetector(
                  onTap: _checked
                      ? () async {
                          await widget.onAgree();
                          if (mounted) Navigator.of(context).pop(true);
                        }
                      : null,
                  child: Opacity(
                    opacity: _checked ? 1 : 0.5,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 131, 49, 1),
                            Color.fromRGBO(255, 173, 66, 1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        isCn ? '同意并继续' : 'Agree & Continue',
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.hofontmedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
