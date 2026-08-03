import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../domain/downloaded_course_asset.dart';

/// 课程下载登记表:基于 SharedPreferences 的元数据持久化。
///
/// 存储格式:单个 SP key 指向一段 JSON 对象,
/// 内部为 { compositeKey: DownloadedCourseAssetJson, ... }。
///
/// 复合键 = "${courseId}_${deviceType.name}"。
/// downloadDate 仅供审计展示,不参与查询。
class CourseDownloadRegistry {
  CourseDownloadRegistry({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _kStoreKey = 'course_download_registry_v1';

  Future<Map<String, dynamic>> _readAll() async {
    final raw = _prefs.getString(_kStoreKey);
    if (raw == null || raw.isEmpty) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _writeAll(Map<String, dynamic> map) async {
    await _prefs.setString(_kStoreKey, jsonEncode(map));
  }

  /// 取条目。未登记返回 null。
  Future<DownloadedCourseAsset?> getAsset(
    int courseId,
    FtmsDeviceType deviceType,
  ) async {
    final all = await _readAll();
    final key = DownloadedCourseAsset.makeKey(courseId, deviceType);
    final raw = all[key];
    if (raw == null) return null;
    return DownloadedCourseAsset.fromJson(raw as Map<String, dynamic>);
  }

  /// 是否已就绪(status == ready)。
  Future<bool> isReady(int courseId, FtmsDeviceType deviceType) async {
    final a = await getAsset(courseId, deviceType);
    return a?.isReady ?? false;
  }

  /// 保存/覆盖条目(下载成功后调用)。
  Future<void> saveAsset(DownloadedCourseAsset asset) async {
    final all = await _readAll();
    all[asset.compositeKey] = asset.toJson();
    await _writeAll(all);
  }

  /// 标记为 partial(失败/取消时调用,保留已下载素材清单便于续传决策)。
  Future<void> markPartial(
    int courseId,
    FtmsDeviceType deviceType,
    int completedFiles,
  ) async {
    final all = await _readAll();
    final key = DownloadedCourseAsset.makeKey(courseId, deviceType);
    final existing = all[key];
    DownloadedCourseAsset asset;
    if (existing != null) {
      asset = DownloadedCourseAsset.fromJson(existing as Map<String, dynamic>);
      asset = asset.copyWith(
          status: AssetStatus.partial, completedFiles: completedFiles);
    } else {
      asset = DownloadedCourseAsset(
        courseId: courseId,
        deviceType: deviceType,
        status: AssetStatus.partial,
        totalFiles: 0,
        completedFiles: completedFiles,
        imageAssets: const [],
        voiceAssets: const [],
        bgmAssets: const [],
        downloadDate: DateTime.now().toIso8601String(),
        schemaVersion: 1,
      );
    }
    all[key] = asset.toJson();
    await _writeAll(all);
  }

  /// 删除条目(仅删元数据,不删本地文件;如需删文件由调用方配合 CourseLocalStorage 完成)。
  Future<void> removeAsset(int courseId, FtmsDeviceType deviceType) async {
    final all = await _readAll();
    final key = DownloadedCourseAsset.makeKey(courseId, deviceType);
    if (all.containsKey(key)) {
      all.remove(key);
      await _writeAll(all);
    }
  }

  /// 返回所有已登记条目(未来"已下载课程列表"页用)。
  Future<List<DownloadedCourseAsset>> listAll() async {
    final all = await _readAll();
    return all.values
        .map((e) => DownloadedCourseAsset.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
