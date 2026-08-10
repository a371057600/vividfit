import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constants/app_fonts.dart';
import '../constants/them_change.dart';

/// 独立、可复用的在线协议 WebView 页面。
///
/// 用于「隐私政策」「用户协议」等在线 HTML。
///  - 独立页面带 AppBar,支持系统返回
///  - 支持手势滚动、双指缩放
///  - 加载中:顶部进度条
///  - 加载失败:错误占位 + 重试按钮
class PolicyWebViewPage extends StatefulWidget {
  const PolicyWebViewPage({
    super.key,
    required this.url,
    required this.title,
    this.showAppBar = true,
  });

  final String url;
  final String title;

  /// 嵌套在 Dialog 的 Tab 中时传 false,外部自己管理标题栏。
  final bool showAppBar;

  @override
  State<PolicyWebViewPage> createState() => _PolicyWebViewPageState();
}

class _PolicyWebViewPageState extends State<PolicyWebViewPage> {
  late InAppWebViewController _controller;
  int _progress = 0;
  bool _loadError = false;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        if (_progress < 100 && !_loadError)
          LinearProgressIndicator(
            value: _progress / 100.0,
            minHeight: 3,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(FitTheme.buttonColor),
          ),
        Expanded(
          child: _loadError
              ? _buildErrorView()
              : InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                  initialSettings: InAppWebViewSettings(
                    allowsInlineMediaPlayback: true,
                    mixedContentMode:
                        MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    useShouldOverrideUrlLoading: true,
                    useHybridComposition: true,
                    supportZoom: true,
                    builtInZoomControls: true,
                    displayZoomControls: false,
                    verticalScrollBarEnabled: true,
                    horizontalScrollBarEnabled: false,
                  ),
                  gestureRecognizers: {
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                    Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer(),
                    ),
                  },
                  onWebViewCreated: (c) {
                    _controller = c;
                    print('🌐 [WebView] created for ${widget.url}');
                  },
                  onLoadStart: (c, url) {
                    print('🌐 [WebView] loadStart: $url');
                    if (mounted) {
                      setState(() {
                        _loadError = false;
                        _errorMsg = null;
                      });
                    }
                  },
                  onProgressChanged: (c, progress) {
                    debugPrint('🌐 [WebView] progress: $progress%');
                    if (mounted) {
                      setState(() => _progress = progress);
                    }
                  },
                  onReceivedError: (c, request, error) {
                    print(
                      '🌐 [WebView] onReceivedError: '
                      'url=${request.url} type=${error.type} '
                      'desc=${error.description}',
                    );
                    if (mounted) {
                      setState(() {
                        _loadError = true;
                        _errorMsg = error.description;
                      });
                    }
                  },
                ),
        ),
      ],
    );

    if (!widget.showAppBar) return body;

    return Scaffold(
      backgroundColor: FitTheme.secondbackGround,
      appBar: AppBar(
        backgroundColor: FitTheme.secondbackGround,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 20,
            fontFamily: AppFonts.hofontmedium,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              '页面加载失败',
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 18,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
            if (_errorMsg != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMsg!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                print('🌐 [WebView] reload → ${widget.url}');
                setState(() {
                  _loadError = false;
                  _errorMsg = null;
                  _progress = 0;
                });
                _controller.loadUrl(
                  urlRequest: URLRequest(url: WebUri(widget.url)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FitTheme.buttonColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: Text(
                '重新加载',
                style: TextStyle(
                  fontFamily: AppFonts.hofontmedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
