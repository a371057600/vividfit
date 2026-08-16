import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/user_settings_notifier.dart';

class AvatarSelectPage extends ConsumerWidget {
  const AvatarSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsProvider);
    final notifier = ref.read(userSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 80.h,
        leadingWidth: 750.w,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 45).r,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (!state.isUpdating) {
                notifier.toggleUpdating(true);
                Future.delayed(const Duration(seconds: 5), () {
                  notifier.toggleUpdating(false);
                });
                Navigator.of(context).pop();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 10).r,
                  height: 100.r,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: FitTheme.textColor,
                    size: 40.sp,
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.basicSettings,
                    maxLines: 1,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 40.sp,
                      fontFamily: AppFonts.hofontmedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: FitTheme.textColor),
        titleTextStyle: TextStyle(color: FitTheme.textColor),
      ),
      backgroundColor: FitTheme.backgroundColor,
      body: _buildMainBody(context, ref, l10n, state, notifier),
    );
  }

  Widget _buildMainBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    UserSettingsNotifier notifier,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: FitTheme.backgroundColor,
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 60).r,
      child: Column(
        children: [
          _buildHeadImageWidget(context, ref, l10n, state, notifier),
          _buildSelectImageWidget(context, ref, state, notifier),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: state.isUpdating
                      ? null
                      : () => _onConfirm(context, ref, l10n, notifier),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                  ),
                  child: Text(
                    l10n.confirm,
                    style: TextStyle(color: Colors.white, fontSize: 35.sp),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                  ),
                  child: Text(
                    l10n.returnButton,
                    style: TextStyle(color: Colors.white, fontSize: 35.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 确认按钮(对照旧项目确认按钮 updateInsetImage)。
  /// 上传自定义头像(拍照/相册裁剪后)或默认头像 asset,上传后刷新 headImage。
  Future<void> _onConfirm(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSettingsNotifier notifier,
  ) async {
    Fluttertoast.showToast(msg: l10n.uploading);
    final ok = await notifier.confirmUpload();
    if (!context.mounted) return;
    if (ok) {
      Fluttertoast.showToast(msg: l10n.uploadSuccess);
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: l10n.uploadFailed);
    }
  }

  Widget _buildHeadImageWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
    UserSettingsNotifier notifier,
  ) {
    // 预览头像:优先显示裁剪后的自定义图片 > 服务器头像 > 默认头像
    final hasCustomPick = state.imagePickFile.isNotEmpty;
    final hasServerAvatar = state.headImage.isNotEmpty;
    final defaultAvatar = Image.asset(
      "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
      fit: BoxFit.fill,
    );
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 45, bottom: 45).r,
      child: Column(
        children: [
          ClipOval(
            child: Container(
              width: 150.r,
              height: 150.r,
              decoration: BoxDecoration(
                color: FitTheme.secondbackGround,
                borderRadius: BorderRadius.circular(75).r,
              ),
              // 预览:裁剪后的本地图片 > 服务器头像 > 默认头像
              child: hasCustomPick
                  ? Image.file(
                      File(state.imagePickFile),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stack) => defaultAvatar,
                    )
                  : hasServerAvatar
                  ? CachedNetworkImage(
                      imageUrl: state.headImage,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => defaultAvatar,
                      errorWidget: (context, url, error) => defaultAvatar,
                    )
                  : defaultAvatar,
            ),
          ),
          SizedBox(height: 80.r),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 拍照按钮
                InkWell(
                  onTap: () => _takePhoto(context, ref, l10n, notifier),
                  child: Container(
                    width: 220.r,
                    height: 60.r,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 25,
                      right: 25,
                    ).r,
                    decoration: BoxDecoration(
                      color: FitTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(color: FitTheme.textColor, width: 2.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: FitTheme.textColor,
                          size: 35.r,
                        ),
                        SizedBox(width: 20.r),
                        Expanded(
                          child: Text(
                            l10n.takePhoto,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 40.r),
                // 图片选择按钮
                InkWell(
                  onTap: () => _pickImage(context, ref, l10n, notifier),
                  child: Container(
                    width: 220.r,
                    height: 60.r,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 25,
                      right: 25,
                    ).r,
                    decoration: BoxDecoration(
                      color: FitTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(color: FitTheme.textColor, width: 2.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: FitTheme.textColor,
                          size: 35.r,
                        ),
                        SizedBox(width: 20.r),
                        Expanded(
                          child: Text(
                            l10n.pictureSelect,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: FitTheme.textColor,
                              fontSize: 25.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 拍照 → 裁剪页 → 回到本页预览(不立即上传,等点确认)
  /// 对照旧项目: checkPermission → takePhoto → ImageTest → imagePickFile = saveFile → Get.back() 回本页
  Future<void> _takePhoto(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSettingsNotifier notifier,
  ) async {
    // 1. 拍照(含权限检查)
    final imagePath = await notifier.takePhoto();
    if (imagePath == null) return;
    if (!context.mounted) return;
    // 2. 跳裁剪页,等待返回裁剪后路径
    final croppedPath = await context.push<String>(
      '/image-crop',
      extra: imagePath,
    );
    if (croppedPath == null) return;
    // 3. 存为待上传路径,回本页预览(不立即上传)
    notifier.setPendingUploadPath(croppedPath);
    print('📷 [Avatar] takePhoto done, pending upload: $croppedPath');
  }

  /// 相册选图 → 裁剪页 → 回到本页预览(不立即上传,等点确认)
  /// 对照旧项目: pickImage → ImageTest → imagePickFile = saveFile → Get.back() 回本页
  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSettingsNotifier notifier,
  ) async {
    // 1. 相册选图(含权限检查)
    final imagePath = await notifier.pickImageFromGallery();
    if (imagePath == null) return;
    if (!context.mounted) return;
    // 2. 跳裁剪页,等待返回裁剪后路径
    final croppedPath = await context.push<String>(
      '/image-crop',
      extra: imagePath,
    );
    if (croppedPath == null) return;
    // 3. 存为待上传路径,回本页预览(不立即上传)
    notifier.setPendingUploadPath(croppedPath);
    print('📷 [Avatar] pickImage done, pending upload: $croppedPath');
  }

  Widget _buildSelectImageWidget(
    BuildContext context,
    WidgetRef ref,
    state,
    UserSettingsNotifier notifier,
  ) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 100).r,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20.r,
            mainAxisSpacing: 30.r,
            childAspectRatio: 1,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // 选默认头像时清除自定义图片路径
                notifier.updateSelectedImageIndex(index);
              },
              child: Column(
                children: [
                  Container(
                    width: 130.r,
                    height: 130.r,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(100).r,
                      border: Border.all(
                        color: state.selectedImageIndex == index
                            ? FitTheme.buttonColor
                            : Colors.transparent,
                        width: 5.r,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "images/newUIScreen/defaultheadimages/deheadImage${index + 1}.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.r),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
