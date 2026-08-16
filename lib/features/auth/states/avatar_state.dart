import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_state.freezed.dart';

/// 头像选择状态(注册流程专用)。
@freezed
abstract class AvatarState with _$AvatarState {
  const factory AvatarState({
    @Default(0) int selectedImageIndex, // 默认头像索引 0-19
    @Default('') String customImagePath, // 自定义图片路径(空=用默认头像)
    @Default(false) bool isCustomImage, // true=使用自定义图片
    @Default('') String imagePickFile, // 裁剪后待上传的本地图片路径(空=用默认头像)
    @Default(false) bool isLoading, // 上传中/处理中
  }) = _AvatarState;
}
