import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../../about/widgets/upload_progress_dialog.dart';
import '../notifiers/avatar_notifier.dart';

/// 注册流程头像选择页(参照 about 模块 avatar_select_page 设计)。
///
/// 功能:20 个默认头像网格选择 + 拍照/相册自定义头像 + 预览 + 确认上传 → 推送到 GoalSettingPage。
class AvatarSetupPage extends ConsumerStatefulWidget {
  const AvatarSetupPage({super.key, this.isRegistration = false});

  final bool isRegistration;

  @override
  ConsumerState<AvatarSetupPage> createState() => _AvatarSetupPageState();
}

class _AvatarSetupPageState extends ConsumerState<AvatarSetupPage> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(avatarProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
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
              context.pop();
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
                    // TODO(l10n): 待补充 avatarSelection 文案
                    '选择头像',
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
      body: _buildMainBody(context, l10n, notifier),
    );
  }

  Widget _buildMainBody(
    BuildContext context,
    AppLocalizations l10n,
    AvatarNotifier notifier,
  ) {
    final state = ref.watch(avatarProvider);
    final isRegistration = widget.isRegistration;
    final buttonMargin = MediaQuery.of(context).size.width * 0.05;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: FitTheme.backgroundColor,
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 60).r,
      child: Column(
        children: [
          _buildHeadImageWidget(context, l10n, notifier),
          _buildSelectImageWidget(notifier),

          if (isRegistration)
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: buttonMargin).r,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FitTheme.buttonColor,
                ),
                onPressed: state.isLoading
                    ? null
                    : () => _onConfirmUpload(context, l10n, notifier),
                child: Text(
                  // TODO(l10n): 待补充 next 文案
                  '下一步',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            context.pop();
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
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => _onConfirmUpload(context, l10n, notifier),
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
              ],
            ),
        ],
      ),
    );
  }

  /// 预览区 + 拍照/相册按钮(参照 avatar_select_page._buildHeadImageWidget)。
  /// 预览优先级:裁剪后的自定义本地图片 > 当前选中默认头像 asset。
  Widget _buildHeadImageWidget(
    BuildContext context,
    AppLocalizations l10n,
    AvatarNotifier notifier,
  ) {
    final state = ref.watch(avatarProvider);
    final hasCustomPick = state.imagePickFile.isNotEmpty;
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
              // 预览:裁剪后的本地图片 > 默认头像
              child: hasCustomPick
                  ? Image.file(
                      File(state.imagePickFile),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stack) => defaultAvatar,
                    )
                  : defaultAvatar,
            ),
          ),
          SizedBox(height: 80.r),
          // 拍照 + 相册选择按钮(样式与 about 模块完全一致)
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 拍照按钮
                InkWell(
                  onTap: () => _takePhoto(context, notifier),
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
                      border: Border.all(
                        color: FitTheme.textColor,
                        width: 2.r,
                      ),
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
                // 相册选择按钮
                InkWell(
                  onTap: () => _pickImage(context, notifier),
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
                      border: Border.all(
                        color: FitTheme.textColor,
                        width: 2.r,
                      ),
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

  /// 拍照 → 裁剪页 → 回到本页预览(不立即上传,等点确认/下一步)
  /// 对照 about 模块 avatar_select_page._takePhoto。
  Future<void> _takePhoto(
    BuildContext context,
    AvatarNotifier notifier,
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

  /// 相册选图 → 裁剪页 → 回到本页预览(不立即上传,等点确认/下一步)
  /// 对照 about 模块 avatar_select_page._pickImage。
  Future<void> _pickImage(
    BuildContext context,
    AvatarNotifier notifier,
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

  /// 确认上传(对照 about 模块 avatar_select_page._onConfirm)。
  /// 弹上传进度弹窗 → 上传成功跳 goal-setting;失败弹 toast 留页。
  Future<void> _onConfirmUpload(
    BuildContext context,
    AppLocalizations l10n,
    AvatarNotifier notifier,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => UploadProgressDialog(
        l10n: l10n,
        onUpload: (onProgress) =>
            notifier.confirmUpload(onSendProgress: onProgress),
      ),
    );
    if (ok == true) {
      Fluttertoast.showToast(msg: l10n.uploadSuccess);
      if (!context.mounted) return;
      context.push('/goal-setting', extra: {'isRegistration': true});
    } else if (ok == false) {
      Fluttertoast.showToast(msg: l10n.uploadFailed);
    }
  }

  Widget _buildSelectImageWidget(AvatarNotifier notifier) {
    final state = ref.watch(avatarProvider);
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 30).r,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 计算单个头像尺寸,确保 5 行 × 4 列 铺满可用空间
            const crossAxisCount = 4;
            const rowCount = 5;
            final crossAxisSpacing = 20.r;
            final mainAxisSpacing = 30.r;

            // 计算宽度:可用宽度减去间距后除以列数
            final availableWidth = constraints.maxWidth;
            final itemWidth =
                (availableWidth - (crossAxisCount - 1) * crossAxisSpacing) /
                crossAxisCount;

            // 计算高度:可用高度减去间距后除以行数
            final availableHeight = constraints.maxHeight;
            final itemHeight =
                (availableHeight - (rowCount - 1) * mainAxisSpacing) / rowCount;

            // 取较小值保持正方形
            final itemSize = itemWidth.clamp(0.0, itemHeight);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int row = 0; row < rowCount; row++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: row < rowCount - 1 ? mainAxisSpacing : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int col = 0; col < crossAxisCount; col++)
                          Padding(
                            padding: EdgeInsets.only(
                              right: col < crossAxisCount - 1
                                  ? crossAxisSpacing
                                  : 0,
                            ),
                            child: _buildAvatarItem(
                              index: row * crossAxisCount + col,
                              size: itemSize,
                              isSelected:
                                  state.selectedImageIndex ==
                                      col + row * crossAxisCount &&
                                  state.imagePickFile.isEmpty,
                              onTap: () => notifier.selectDefaultAvatar(
                                row * crossAxisCount + col,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarItem({
    required int index,
    required double size,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: FitTheme.secondbackGround,
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(
            color: isSelected ? FitTheme.buttonColor : Colors.transparent,
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
    );
  }
}
