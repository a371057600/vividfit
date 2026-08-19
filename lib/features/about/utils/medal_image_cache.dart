import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

/// 勋章图片本地缓存管理器。
///
/// 服务端返回的勋章 image 为完整 OSS URL，按新规则禁止直接网络展示：
/// 请求面板数据后批量下载到本地（文档目录/medal_images/），
/// UI 层一律从本地文件渲染。
///
/// 文件名取 URL 最后一段（OSS 文件名本身为 32 位哈希，天然唯一稳定）；
/// 下载采用 .part 临时文件 + rename 原子写入，失败自动清理。
class MedalImageCache {
  MedalImageCache._();

  static final MedalImageCache instance = MedalImageCache._();

  final Dio _dio = Dio();
  final Map<String, Future<File?>> _pending = {};

  Directory? _dir;

  /// 缓存根目录（懒初始化）：<docs>/medal_images
  Future<Directory> _ensureDir() async {
    if (_dir != null) return _dir!;
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/medal_images');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    _dir = dir;
    return dir;
  }

  /// URL → 本地文件名（取最后一段，如 9de2eef2875d46538145fa0eb8509c0d.png）。
  String _fileNameOf(String url) => url.split('/').last;

  /// 获取勋章图片本地文件；不存在则下载后返回。
  /// 下载失败返回 null（UI 回退失败占位），不抛异常。
  Future<File?> getFile(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final dir = await _ensureDir();
      final file = File('${dir.path}/${_fileNameOf(url)}');
      if (file.existsSync()) return file;

      // 并发去重：同一 URL 只下载一次
      final pending = _pending.putIfAbsent(
        url,
        () => _download(url, file),
      );
      return await pending;
    } catch (e) {
      print('⚠️ [MedalImage] getFile error: $url ($e)');
      return null;
    } finally {
      _pending.remove(url);
    }
  }

  /// 下载到 .part 临时文件后原子 rename。
  Future<File?> _download(String url, File file) async {
    final partFile = File('${file.path}.part');
    try {
      print('⬇️ [MedalImage] download start: ${file.uri.pathSegments.last}');
      await _dio.download(url, partFile.path);
      await partFile.rename(file.path);
      print('✅ [MedalImage] downloaded: ${file.uri.pathSegments.last}');
      return file;
    } catch (e) {
      print('❌ [MedalImage] download failed: ${file.uri.pathSegments.last} ($e)');
      // 失败清理残留临时文件，下次可重试
      if (partFile.existsSync()) partFile.deleteSync();
      return null;
    }
  }

  /// 批量预下载（数据加载成功后调用，fire-and-forget 不阻塞 UI）。
  Future<void> prefetchAll(Iterable<String?> urls) async {
    final list = urls.whereType<String>().toSet().toList();
    print('⬇️ [MedalImage] prefetch ${list.length} images');
    final results = await Future.wait(
      list.map((u) => getFile(u)),
      eagerError: false,
    );
    final ok = results.whereType<File>().length;
    print('⬇️ [MedalImage] prefetch done: $ok/${list.length} success');
  }
}

/// 勋章本地图片展示组件：一律从本地缓存文件渲染（新规则禁止网络直连展示）。
///
/// 文件未就绪时显示加载动画，下载失败显示 [errorWidget]（调用方区分场景：
/// 轮播空文本 / 网格默认头像图）。
class LocalMedalImage extends StatelessWidget {
  const LocalMedalImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.fitWidth,
    this.errorWidget,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: MedalImageCache.instance.getFile(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: const Color.fromARGB(255, 217, 217, 229),
              size: 50,
            ),
          );
        }
        final file = snapshot.data;
        if (file == null) {
          return Center(child: errorWidget ?? const Text(''));
        }
        return ExtendedImage.file(
          file,
          fit: fit,
          width: width,
          height: height,
        );
      },
    );
  }
}
