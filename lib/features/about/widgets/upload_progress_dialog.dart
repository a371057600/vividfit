// 头像上传进度弹窗(共享组件)。
// 由 avatar_select_page(about 模块)与 avatar_setup_page(注册流程)共用。
// 显示百分比进度条,上传完成后自动关闭并返回 bool(true=成功,false=失败)。

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// 头像上传进度弹窗。
///
/// 用法:
/// ```dart
/// showDialog<bool>(
///   context: context,
///   barrierDismissible: false,
///   builder: (_) => UploadProgressDialog(
///     l10n: l10n,
///     onUpload: (onProgress) => notifier.confirmUpload(onSendProgress: onProgress),
///   ),
/// ).then((ok) { ... });
/// ```
class UploadProgressDialog extends StatefulWidget {
  final AppLocalizations l10n;
  final Future<bool> Function(void Function(int sent, int total) onProgress)
  onUpload;

  const UploadProgressDialog({
    super.key,
    required this.l10n,
    required this.onUpload,
  });

  @override
  State<UploadProgressDialog> createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<UploadProgressDialog> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    // 延迟到 widget 构建完成后再启动上传,避免在 build 阶段修改 provider 状态
    Future.microtask(_startUpload);
  }

  Future<void> _startUpload() async {
    try {
      final ok = await widget.onUpload((sent, total) {
        if (total > 0 && mounted) {
          setState(() => _progress = sent / total);
          print(
            '📊 [Upload] progress: ${(sent / total * 100).toStringAsFixed(1)}% ($sent/$total)',
          );
        }
      });
      if (mounted) {
        Navigator.of(context).pop(ok);
      }
    } catch (e) {
      print('❌ [Upload] error: $e');
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.l10n.uploading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress > 0 ? _progress : null,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          // 百分比文字
          Text(
            _progress > 0
                ? '${(_progress * 100).toStringAsFixed(0)}%'
                : widget.l10n.pleaseWait,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
