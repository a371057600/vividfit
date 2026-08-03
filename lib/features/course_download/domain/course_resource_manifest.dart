import 'package:freezed_annotation/freezed_annotation.dart';

import '../../big_device/states/gym_course_detail_state.dart';

part 'course_resource_manifest.freezed.dart';

enum ResourceType { imageZip, voiceMp3, bgmMp3 }

@freezed
abstract class ResourceFile with _$ResourceFile {
  const factory ResourceFile({
    required String name,
    required String url,
    required ResourceType type,
  }) = _ResourceFile;
}

/// 课程资源清单:从 ActionList 提取并按 name 去重。
/// 1:1 对齐旧版 downloadZip/downloadVoice/downloadBgm 三段式遍历逻辑。
/// 旧版对 isRestStage 不过滤(仅判 path != null),此处保持一致。
@freezed
abstract class CourseResourceManifest with _$CourseResourceManifest {
  const CourseResourceManifest._();

  const factory CourseResourceManifest({
    @Default([]) List<ResourceFile> imageZips,
    @Default([]) List<ResourceFile> voiceMp3s,
    @Default([]) List<ResourceFile> bgmMp3s,
  }) = _CourseResourceManifest;

  factory CourseResourceManifest.fromActions(
    List<CourseActionListItem> actions,
  ) {
    final seenImg = <String>{};
    final seenVoice = <String>{};
    final seenBgm = <String>{};
    final imageZips = <ResourceFile>[];
    final voiceMp3s = <ResourceFile>[];
    final bgmMp3s = <ResourceFile>[];

    for (final a in actions) {
      final imgName = a.imageName;
      final imgPath = a.zipDownLoadPath;
      if (imgName != null && imgPath != null && seenImg.add(imgName)) {
        imageZips.add(ResourceFile(
          name: imgName,
          url: imgPath,
          type: ResourceType.imageZip,
        ));
      }
      final voiceName = a.voiceName;
      final voicePath = a.voiceDownLoadPath;
      if (voiceName != null &&
          voicePath != null &&
          seenVoice.add(voiceName)) {
        voiceMp3s.add(ResourceFile(
          name: voiceName,
          url: voicePath,
          type: ResourceType.voiceMp3,
        ));
      }
      final bgmName = a.bgmName;
      final bgmPath = a.bgmDownLoadPath;
      if (bgmName != null && bgmPath != null && seenBgm.add(bgmName)) {
        bgmMp3s.add(ResourceFile(
          name: bgmName,
          url: bgmPath,
          type: ResourceType.bgmMp3,
        ));
      }
    }
    return CourseResourceManifest(
      imageZips: imageZips,
      voiceMp3s: voiceMp3s,
      bgmMp3s: bgmMp3s,
    );
  }

  int get totalFileCount =>
      imageZips.length + voiceMp3s.length + bgmMp3s.length;
}
