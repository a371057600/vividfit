import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../notifiers/avatar_notifier.dart';

/// 注册流程头像选择页(参照 about 模块 avatar_select_page 设计)。
///
/// 功能:20 个默认头像网格选择 + 预览 + 确认 → 推送到 GoalSettingPage。
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
      body: _buildMainBody(context, notifier),
    );
  }

  Widget _buildMainBody(BuildContext context, AvatarNotifier notifier) {
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
          _buildHeadImageWidget(),
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
                    : () async {
                        await notifier.confirmSelection();
                        if (!context.mounted) return;
                        context.push(
                          '/goal-setting',
                          extra: {'isRegistration': true},
                        );
                      },
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
                      // TODO(l10n): 待补充 returnButton 文案
                      '返回',
                      style: TextStyle(color: Colors.white, fontSize: 35.sp),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await notifier.confirmSelection();
                            if (!context.mounted) return;
                            context.push(
                              '/goal-setting',
                              extra: {'isRegistration': true},
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FitTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20).r,
                      ),
                    ),
                    child: Text(
                      // TODO(l10n): 待补充 confirm 文案
                      '确认',
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

  Widget _buildHeadImageWidget() {
    final state = ref.watch(avatarProvider);
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
              child: Image.asset(
                "images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 30.r),
          Text(
            // TODO(l10n): 待补充 chooseAvatarHint 文案
            '选择一个你喜欢的头像',
            style: TextStyle(
              color: FitTheme.textColor.withValues(alpha: 0.7),
              fontSize: 26.sp,
            ),
          ),
        ],
      ),
    );
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
                                  !state.isCustomImage,
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
