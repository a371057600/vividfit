// 头像裁剪页(迁移自旧项目 image_test.dart)
// 黑底 + CropImage(1:1) + 重置/确认按钮(加大加亮,确保可见)
// 确认 → croppedBitmap → 压缩(flutter_image_compress) → 写临时目录 → 返回路径

import 'dart:io';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../../l10n/app_localizations.dart';

class ImageCropPage extends StatefulWidget {
  /// 要裁剪的图片本地路径
  final String imagePath;

  const ImageCropPage({super.key, required this.imagePath});

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final _controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  bool _flag = true;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.pictureCropping,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: CropImage(
          controller: _controller,
          image: Image.file(File(widget.imagePath)),
          paddingSize: 25.0,
          alwaysMove: true,
        ),
      ),
      bottomNavigationBar: _isProcessing
          ? _buildProcessingBar()
          : _buildActionButtons(l10n),
    );
  }

  /// 底部操作按钮(重置 + 确认),加大加亮确保可见
  Widget _buildActionButtons(AppLocalizations l10n) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // 重置按钮
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _controller.rotation = CropRotation.up;
                    _controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    _controller.aspectRatio = 1.0;
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.restart_alt, size: 22),
                  label: Text(
                    l10n.returnButton,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 确认按钮
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _finished,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 22),
                  label: Text(
                    l10n.confirm,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理中状态(底部显示进度指示)
  Widget _buildProcessingBar() {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
            SizedBox(width: 16),
            Text(
              'Processing...',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  /// 裁剪完成 → 压缩 → 写入临时目录 → 返回保存路径
  Future<void> _finished() async {
    if (_flag) {
      _flag = false;
      setState(() => _isProcessing = true);
      print('🖼️ [Crop] start cropping...');
      try {
        final appDir = await getTemporaryDirectory();
        // 1. 裁剪得到 bitmap
        final bitmap = await _controller.croppedBitmap();
        // 2. 转 PNG bytes
        final data = await bitmap.toByteData(format: ImageByteFormat.png);
        if (data == null) {
          print('❌ [Crop] toByteData returned null');
          _flag = true;
          setState(() => _isProcessing = false);
          return;
        }
        final pngBytes = data.buffer.asUint8List();
        print('🖼️ [Crop] raw PNG size: ${pngBytes.length} bytes');

        // 3. 压缩图片(纯 Dart,用 image 包,无需原生插件)
        // 目标:最大 512x512,JPEG 质量 80(头像不需要 PNG 无损,压缩后体积小很多)
        File saveFile;
        try {
          final decoded = img.decodeImage(pngBytes);
          if (decoded != null) {
            // 等比缩放到最大 512x512
            final resized = img.copyResize(
              decoded,
              width: 512,
              height: 512,
              maintainAspect: true,
            );
            final compressedBytes = img.encodeJpg(resized, quality: 80);
            saveFile = await File(
              '${appDir.path}/UserImage.jpg',
            ).writeAsBytes(compressedBytes);
            print(
              '🖼️ [Crop] compressed size: ${compressedBytes.length} bytes',
            );
          } else {
            saveFile = await File(
              '${appDir.path}/UserImage.png',
            ).writeAsBytes(pngBytes);
            print('⚠️ [Crop] decode failed, fallback to raw PNG');
          }
        } catch (e) {
          saveFile = await File(
            '${appDir.path}/UserImage.png',
          ).writeAsBytes(pngBytes);
          print('⚠️ [Crop] compress error: $e, fallback to raw PNG');
        }

        print('🖼️ [Crop] saved to ${saveFile.path}');
        if (mounted) {
          context.pop(saveFile.path);
        }
      } catch (e) {
        print('❌ [Crop] error: $e');
        Fluttertoast.showToast(msg: 'Crop failed: $e');
        _flag = true;
        if (mounted) setState(() => _isProcessing = false);
      }
    } else {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.pleaseWait);
    }
  }
}
