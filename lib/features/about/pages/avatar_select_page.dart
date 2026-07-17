import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/user_settings_notifier.dart';

class AvatarSelectPage extends ConsumerWidget {
  const AvatarSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userSettingsNotifierProvider);
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

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
      body: _buildMainBody(context, ref, l10n, state),
    );
  }

  Widget _buildMainBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    state,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: FitTheme.backgroundColor,
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 60).r,
      child: Column(
        children: [
          _buildHeadImageWidget(context, ref, l10n, state),
          _buildSelectImageWidget(context, ref, state),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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

  Widget _buildHeadImageWidget(BuildContext context, WidgetRef ref, AppLocalizations l10n, state) {
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
              child: ExtendedImage.asset(
                "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
                fit: BoxFit.fill,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Center(
                        child: CircularProgressIndicator(
                          color: FitTheme.textColor,
                        ),
                      );
                    case LoadState.failed:
                      return const Center(child: Text(""));
                    case LoadState.completed:
                      return ExtendedRawImage(
                        image: state.extendedImageInfo?.image,
                        width: MediaQuery.of(context).size.width - 10,
                        fit: BoxFit.fill,
                      );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 80.r),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // 占位:拍照功能
                  },
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
                InkWell(
                  onTap: () {
                    // 占位:图片选择功能
                  },
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

  Widget _buildSelectImageWidget(BuildContext context, WidgetRef ref, state) {
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

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
