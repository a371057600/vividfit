import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../course_download/domain/course_resource_manifest.dart';
import '../../course_download/domain/download_progress.dart';
import '../../course_download/domain/downloaded_course_asset.dart';
import '../../course_download/services/course_download_registry.dart';
import '../../course_download/services/course_download_registry_provider.dart';
import '../../course_download/services/course_download_service_provider.dart';
import '../data/course_play_data.dart';
import '../repositories/course_detail_repository.dart';
import '../states/gym_course_detail_state.dart';

part 'gym_course_detail_notifier.g.dart';

/// 课程详情页 Notifier(Riverpod 3.0 代码生成,auto-dispose)。
///
/// 1:1 迁移自旧 `ControllerCourseDetail` 的数据加载逻辑。
/// auto-dispose:每次进详情页 state 全新,对齐旧 `Get.put(ControllerCourseDetail())`
/// 每次创建新实例的语义;push 到播放页时详情页 widget 仍挂载,provider 不销毁,
/// pop 详情页才销毁。
///
/// 语音方言匹配:旧项目 `hc.languageIndex` 全工程无赋值(恒 0),
/// `enLanguageList[0]` = "Chinese"。本 Notifier 内置常量复刻该逻辑。
///
/// 本阶段仅实现 `loadDetail`(数据加载);下载/解压方法留待后续下载任务测试后补充。
@riverpod
class GymCourseDetailNotifier extends _$GymCourseDetailNotifier {
  /// 方言列表(1:1 还原旧 `enLanguageList`)。
  static const _enLanguageList = [
    "Chinese",
    "Shanghainese",
    "Sichuanese",
    "Cantonese",
    "Dongbeinese",
  ];

  /// 当前方言索引(1:1 还原旧 `hc.languageIndex.value`,恒 0)。
  /// TODO: 后续可接入语言设置 Provider 动态获取。
  static const _voiceDialectIndex = 0;

  @override
  GymCourseDetailState build() => const GymCourseDetailState();

  /// 加载课程详情数据(对应旧 `getData()`)。
  ///
  /// 流程:fetch JSON → firstWhere(id==courseId) → 解析 barLines(方言匹配)
  /// → 设置 courseTitle/courseProperties/courseImage/courseActionList。
  /// 找不到课程时设置 notFound=true(页面 watch 后 pop,对应旧 `Get.back()`)。
  Future<void> loadDetail({
    required int? courseId,
    required FtmsDeviceType deviceType,
  }) async {
    state = state.copyWith(
      isLoading: true,
      notFound: false,
      courseId: courseId,
      deviceType: deviceType,
    );

    try {
      final repository = ref.read(courseDetailRepositoryProvider);
      final storage = ref.read(storageServiceProvider);
      final coursePlayData = await repository.fetchCoursePlayData(
        deviceType: deviceType,
        languageNum: storage.languageNum,
      );

      final dataList = coursePlayData.dataList;
      if (dataList == null || dataList.isEmpty || courseId == null) {
        state = state.copyWith(isLoading: false, notFound: true);
        return;
      }

      // 1:1 还原旧 firstWhereOrNull((e) => e.id == courseId.value)
      CourseItem? targetElement;
      for (final element in dataList) {
        if (element.id == courseId) {
          targetElement = element;
          break;
        }
      }

      if (targetElement == null) {
        state = state.copyWith(isLoading: false, notFound: true);
        return;
      }

      // 设置标题属性(对应旧 courseTitle.value = TitleProperties(...))
      final titleProps = targetElement.titleProperties;
      final courseTitle = TitleProperties(
        bigTitle: titleProps?.bigTitle,
        smallTitle: titleProps?.smallTitle,
        level: titleProps?.level,
        difficulty: titleProps?.difficulty,
      );

      // 设置课程属性(对应旧 courseProperties.value = CourseProperties(...))
      final cp = targetElement.courseProperties;
      final courseProperties = CourseProperties(
        name: cp?.name,
        time: cp?.time,
        level: cp?.level,
        imagePath: cp?.imagePath,
        courseType: cp?.courseType,
        details: cp?.details,
        notes: cp?.notes,
        suggestions: cp?.suggestions,
        isAllowShowProgressBar: cp?.isAllowShowProgressBar,
      );

      // 课程封面图(对应旧 courseImage.value = courseProperties().imagePath ?? "")
      final courseImage = courseProperties.imagePath ?? '';

      // 解析 barLines → courseActionList(1:1 还原旧 mapping + 方言匹配)
      final barLines = targetElement.barLineDtaList;
      final List<CourseActionListItem> actionList = [];
      if (barLines != null && barLines.isNotEmpty) {
        for (final barLine in barLines) {
          actionList.add(_mapBarLineToAction(barLine));
        }
      }

      state = state.copyWith(
        isLoading: false,
        courseTitle: courseTitle,
        courseProperties: courseProperties,
        courseImage: courseImage,
        courseActionList: actionList,
      );

      // 异步检查课程离线就绪状态(不阻塞 UI)
      unawaited(checkReadiness());
    } catch (e) {
      debugPrint('🔴 [CourseDetail] loadDetail failed: $e');
      state = state.copyWith(isLoading: false, notFound: true);
    }
  }

  /// 将 `BarLineData` 映射为 `CourseActionListItem`(1:1 还原旧 mapping)。
  ///
  /// 语音方言匹配:对 `voiceProperties` 数组按 `dialect` 字段匹配当前方言,
  /// 找不到则取第一个(对应旧 `firstWhere(orElse: () => v.first)`)。
  CourseActionListItem _mapBarLineToAction(BarLineData barLine) {
    final imageProps = barLine.imageProperties;
    final bgmProps = barLine.bgmProperties;
    final voiceProps = barLine.voiceProperties;

    // 语音方言匹配(1:1 还原旧 voiceProperties 的 IIFE 逻辑)
    String? voiceName;
    String? voiceDownLoadPath;
    if (voiceProps != null && voiceProps.isNotEmpty) {
      final targetDialect = _enLanguageList[_voiceDialectIndex].toLowerCase();
      VoiceProperty target = voiceProps.first;
      for (final vp in voiceProps) {
        if (vp.dialect?.toLowerCase() == targetDialect) {
          target = vp;
          break;
        }
      }
      voiceName = target.name;
      voiceDownLoadPath = target.downLoadPath;
    }

    return CourseActionListItem(
      orderId: barLine.orderId,
      count: barLine.count,
      duration: barLine.duration,
      posture: barLine.posture,
      resistance: barLine.resistance,
      cadence: barLine.cadence,
      gradient: barLine.gradient,
      distance: barLine.distance,
      name: barLine.stageName,
      zipDownLoadPath: imageProps?.downLoadPath,
      imagePath: imageProps?.imagePath,
      imageName: imageProps?.name,
      bgmName: bgmProps?.name,
      bgmDownLoadPath: bgmProps?.downLoadPath,
      voiceName: voiceName,
      voiceDownLoadPath: voiceDownLoadPath,
      isRestStage: barLine.isRestStage,
      imagefps: imageProps?.imagefps,
      imageLength: imageProps?.count,
      imagePathName: imageProps?.imagePathName,
    );
  }

  // ─── 下载编排(对接 course_download 模块)─────────────────────────
  CancelToken? _downloadCancelToken;

  /// 详情页加载完成后异步检查课程是否已离线就绪。
  /// 命中登记表 ready 且文件二次校验通过 → state.isCourseReady=true。
  Future<void> checkReadiness() async {
    if (state.courseActionList.isEmpty || state.courseId == null) return;
    try {
      final manifest =
          CourseResourceManifest.fromActions(state.courseActionList);
      final registry = ref.read(courseDownloadRegistryProvider);
      final ready = await registry.isReady(state.courseId!, state.deviceType);
      // 二次确认:登记表说 ready,但文件可能被外部清理过
      final service = await ref.read(courseDownloadServiceProvider.future);
      final fileReady = await service.isManifestReady(manifest);
      final finalReady = ready && fileReady;
      state = state.copyWith(
        isCourseReady: finalReady,
        totalFileCount: manifest.totalFileCount,
        downloadedFileCount: finalReady ? manifest.totalFileCount : 0,
        downLoadProgress: finalReady ? 1.0 : 0.0,
      );
      if (ready && !fileReady) {
        // 登记表说 ready 但文件缺失 → 标记 partial
        await registry.markPartial(state.courseId!, state.deviceType, 0);
        debugPrint(
            '⚠️ [CourseDetail] registry says ready but files missing, mark partial');
      }
    } catch (e) {
      debugPrint('🔴 [CourseDetail] checkReadiness failed: $e');
    }
  }

  /// "Entry Course" 按钮入口:编排下载 → 解压 → 登记 → 导航。
  Future<void> onEnterCoursePressed() async {
    if (state.isNeedDownloaded) return; // 防抖
    state = state.copyWith(
      isNeedDownloaded: true,
      allowGoToPlayScreen: false,
      downloadError: null,
      downLoadProgress: 0.0,
    );

    try {
      final manifest =
          CourseResourceManifest.fromActions(state.courseActionList);
      final service = await ref.read(courseDownloadServiceProvider.future);
      final registry = ref.read(courseDownloadRegistryProvider);

      // 快速路径:已就绪
      if (await service.isManifestReady(manifest)) {
        await _saveAssetAndFinish(manifest, registry);
        return;
      }

      _downloadCancelToken = CancelToken();
      state = state.copyWith(totalFileCount: manifest.totalFileCount);

      // 下载
      await for (final progress
          in service.downloadManifest(manifest, cancelToken: _downloadCancelToken)) {
        if (!state.isNeedDownloaded) break; // 已被取消
        state = state.copyWith(
          downLoadProgress: progress.overallProgress,
          downloadedFileCount: progress.completedFiles,
          currentDownloadingFile: progress.currentFileName,
          totalFileCount: progress.totalFiles,
        );
        if (progress.status == DownloadStatus.failed) {
          await registry.markPartial(
              state.courseId!, state.deviceType, progress.completedFiles);
          state = state.copyWith(
            isNeedDownloaded: false,
            downloadError: progress.errorReason ?? '下载失败',
          );
          debugPrint(
              '🔴 [CourseDetail] download failed: ${progress.errorReason}');
          return;
        }
        if (progress.status == DownloadStatus.cancelled) {
          await registry.markPartial(
              state.courseId!, state.deviceType, progress.completedFiles);
          state = state.copyWith(
            isNeedDownloaded: false,
            downloadError: '已取消',
          );
          return;
        }
      }

      // 解压
      await service.unzipManifest(manifest, cancelToken: _downloadCancelToken);

      // 二次校验 + 登记 + 导航
      final ready = await service.isManifestReady(manifest);
      if (ready) {
        await _saveAssetAndFinish(manifest, registry);
      } else {
        await registry.markPartial(
            state.courseId!, state.deviceType, state.downloadedFileCount);
        state = state.copyWith(
          isNeedDownloaded: false,
          downloadError: '解压后校验仍不通过,请重试',
        );
      }
    } catch (e) {
      debugPrint('🔴 [CourseDetail] onEnterCoursePressed failed: $e');
      state = state.copyWith(
        isNeedDownloaded: false,
        downloadError: '下载异常: $e',
      );
    } finally {
      _downloadCancelToken = null;
    }
  }

  /// 保存登记条目 + 完成态。
  Future<void> _saveAssetAndFinish(
    CourseResourceManifest manifest,
    CourseDownloadRegistry registry,
  ) async {
    final imageAssets = <ImageAsset>[];
    for (final f in manifest.imageZips) {
      imageAssets.add(ImageAsset(imageName: f.name));
    }
    final voiceAssets = <VoiceAsset>[];
    for (final f in manifest.voiceMp3s) {
      voiceAssets.add(VoiceAsset(voiceName: f.name));
    }
    final bgmAssets = <BgmAsset>[];
    for (final f in manifest.bgmMp3s) {
      bgmAssets.add(BgmAsset(bgmName: f.name));
    }
    final asset = DownloadedCourseAsset(
      courseId: state.courseId!,
      deviceType: state.deviceType,
      status: AssetStatus.ready,
      totalFiles: manifest.totalFileCount,
      completedFiles: manifest.totalFileCount,
      imageAssets: imageAssets,
      voiceAssets: voiceAssets,
      bgmAssets: bgmAssets,
      downloadDate: DateTime.now().toIso8601String(),
      schemaVersion: 1,
    );
    await registry.saveAsset(asset);
    state = state.copyWith(
      isNeedDownloaded: false,
      isCourseReady: true,
      allowGoToPlayScreen: true,
      downLoadProgress: 1.0,
      downloadedFileCount: manifest.totalFileCount,
    );
  }

  /// 取消下载(供 UI 取消按钮或返回时调用)。
  void cancelDownload() {
    _downloadCancelToken?.cancel('user cancelled');
    state = state.copyWith(
      isNeedDownloaded: false,
      downloadError: '已取消',
    );
  }
}
