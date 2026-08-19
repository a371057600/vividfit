import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/medal_display_notifier.dart';
import '../utils/medal_image_cache.dart';

/// 详情页跳转参数。
///
/// [fromTop] 为 true 表示来自顶部轮播（对应旧 NewSingleMedalScreenTop），
/// 否则来自分组网格（对应旧 NewSingleMedalScreen，通过 groupIndex/medalIndex 定位）。
class MedalDetailArgs {
  const MedalDetailArgs({
    required this.fromTop,
    this.groupIndex = 0,
    this.medalIndex = 0,
  });

  final bool fromTop;
  final int groupIndex;
  final int medalIndex;
}

/// 勋章详情页（合并旧项目 NewSingleMedalScreen / NewSingleMedalScreenTop）。
///
/// 两个旧页面结构一致，仅描述文字字号不同（网格来源 30sp / 轮播来源 18），
/// 通过 [MedalDetailArgs.fromTop] 参数区分，终端展示效果与旧版一致。
class MedalDetailPage extends ConsumerWidget {
  const MedalDetailPage({super.key, required this.args});

  final MedalDetailArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(medalDisplayProvider);
    final size = MediaQuery.of(context).size;

    // 根据来源定位勋章数据（等价迁移旧版两组索引逻辑）
    final medal = args.fromTop
        ? state.earnedMedals[state.topCarouselIndex]
        : state.groups[args.groupIndex].medals![args.medalIndex];

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: FitTheme.backgroundColor,
        shadowColor: Colors.transparent,
        leadingWidth: 300,
        leading: Container(
          margin: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
          width: size.width,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.pop(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_back_ios,
                  color: FitTheme.textColor,
                  size: 20,
                ),
                Text(
                  l10n.medalDetails,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(height: 100),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: (medal.have ?? false) ? 1 : 0.1,
                child: LocalMedalImage(
                  // 新规则：一律本地文件渲染，禁止网络直连展示
                  url: medal.image,
                  // 旧版失败占位差异：网格来源默认头像图 / 轮播来源空文本
                  errorWidget: args.fromTop
                      ? const Text('')
                      : Image.asset(
                          'images/newUIScreen/defaultheadimages/deheadImage8.jpg',
                        ),
                ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              height: 200,
              width: size.width,
              child: Text(
                // 服务端 lang=zh 直返中文，无需客户端翻译
                medal.describe ?? '',
                style: TextStyle(
                  color: FitTheme.textColor,
                  // 旧版字号差异：网格来源 30sp / 轮播来源 18
                  fontSize: args.fromTop ? 18 : 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
