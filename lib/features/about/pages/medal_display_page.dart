import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../data/models/network/medal.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/medal_display_notifier.dart';
import '../states/medal_display_state.dart';
import 'medal_detail_page.dart';

/// 勋章主页面（迁移自旧项目 NewMedalScreen，移除 GetX/Obx，改用 Riverpod）。
///
/// UI 结构 1:1 复刻旧版：顶部已获得勋章轮播 + 分组勋章网格，
/// 终端展示效果与旧版完全一致。
class MedalDisplayPage extends ConsumerWidget {
  const MedalDisplayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(medalDisplayProvider);

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 100.r,
        backgroundColor: FitTheme.backgroundColor,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        leadingWidth: 300,
        leading: Container(
          padding: const EdgeInsets.only(left: 45).r,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.pop(),
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
                    size: 20,
                  ),
                ),
                Text(
                  l10n.medalsTitle,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontFamily: AppFonts.hofontmedium,
                    fontSize: 40.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildMainWidget(context, ref, l10n, state),
    );
  }

  /// 主体：加载中显示波浪点动画，否则显示轮播 + 分组列表（对应旧 _buildMainWidget）。
  Widget _buildMainWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    MedalDisplayState state,
  ) {
    if (state.isLoading) {
      return Container(
        alignment: Alignment.center,
        child: LoadingAnimationWidget.waveDots(
          color: const Color.fromARGB(255, 217, 217, 229),
          size: 50,
        ),
      );
    }
    return _buildListView(context, ref, l10n, state);
  }

  /// 外层列表：首项为顶部轮播，其余为各分组卡片（对应旧 _listViewWidegt）。
  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    MedalDisplayState state,
  ) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ListView.builder(
        itemCount: state.groups.length,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Column(
              children: [
                _buildTopCarousel(context, ref, state),
                state.earnedMedals.isEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 25).r,
                        alignment: Alignment.center,
                        width: size.width,
                        child: Text(
                          l10n.pleaseTryToGetMedal,
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: FitTheme.textColor,
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 20).r,
                        alignment: Alignment.center,
                        width: size.width,
                        child: _buildTopMedalTitle(ref, state),
                      ),
              ],
            );
          } else {
            return _buildGroupCard(context, index, state);
          }
        },
      ),
    );
  }

  /// 轮播下方当前勋章描述 + 获得日期（对应旧 _topMedalTitle）。
  /// 服务端 lang=zh 直返中文，无需客户端翻译。
  Widget _buildTopMedalTitle(WidgetRef ref, MedalDisplayState state) {
    final notifier = ref.read(medalDisplayProvider.notifier);
    final medal = state.earnedMedals[state.topCarouselIndex];
    return Column(
      children: [
        Text(
          medal.describe ?? '',
          style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
        ),
        Text(
          notifier.formatDateTime(medal.createTime ?? ''),
          style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
        ),
      ],
    );
  }

  /// 顶部背景图 + 已获得勋章轮播（对应旧 _topCarouselSlider）。
  Widget _buildTopCarousel(
    BuildContext context,
    WidgetRef ref,
    MedalDisplayState state,
  ) {
    final notifier = ref.read(medalDisplayProvider.notifier);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: size.width,
          child: Image.asset(
            'images/newUIScreen/medals/medal_background.jpg',
            height: 360.h,
            width: size.width,
            fit: BoxFit.fitWidth,
          ),
        ),
        if (state.earnedMedals.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: 300.h,
              aspectRatio: 1,
              enlargeCenterPage: true,
              onPageChanged: (index, _) =>
                  notifier.updateTopCarouselIndex(index),
              viewportFraction: 0.5,
              enlargeFactor: 0.5,
              padEnds: true,
              disableCenter: true,
              reverse: false,
            ),
            items: state.earnedMedals.map((medal) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      // 点击轮播勋章 → 顶部来源详情页（对应旧 NewSingleMedalScreenTop）
                      context.push(
                        '/medal-detail',
                        extra: const MedalDetailArgs(fromTop: true),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ExtendedImage.network(
                        // 服务端返回完整 OSS URL，直接加载
                        medal.image ?? '',
                        fit: BoxFit.fitWidth,
                        width: 300.r,
                        height: 300.r,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return Center(
                                child: LoadingAnimationWidget.waveDots(
                                  color: FitTheme.textColor,
                                  size: 50,
                                ),
                              );
                            case LoadState.failed:
                              return const Center(child: Text(''));
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
                  );
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  /// 单个分组卡片：组名 + 3 列勋章网格（对应旧 _singleOutContainer）。
  Widget _buildGroupCard(
    BuildContext context,
    int index,
    MedalDisplayState state,
  ) {
    final size = MediaQuery.of(context).size;
    final group = state.groups[index];
    return Card(
      color: FitTheme.secondbackGround,
      margin: const EdgeInsets.only(left: 25, right: 25, top: 40).r,
      child: Column(
        children: [
          Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.only(left: 25, top: 25, right: 10, bottom: 25)
                    .r,
            child: Row(
              children: [
                Text(
                  group.groupName ?? '',
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: FitTheme.textColor,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // 勋章数量按服务端实际返回渲染（新接口每组 2~12 个不等）
          // shrinkWrap 高度随行数自适应，行内尺寸与旧版一致
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 15,
              bottom: 15,
            ).r,
            width: size.width,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              children: _buildGroupMedals(context, group, index),
            ),
          ),
        ],
      ),
    );
  }

  /// 生成分组内勋章项（按服务端实际数量，旧版固定 5 个的假设已废弃）。
  List<Widget> _buildGroupMedals(
    BuildContext context,
    MedalGroup group,
    int outIndex,
  ) {
    final count = group.medals?.length ?? 0;
    return List.generate(
      count,
      (index) => _buildSingleMedal(context, index, group, outIndex),
    );
  }

  /// 单个勋章：图片（未获得 0.1 透明度）+ 下方累计目标值（对应旧 _buildSingleMedal）。
  Widget _buildSingleMedal(
    BuildContext context,
    int index,
    MedalGroup group,
    int outIndex,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final medal = group.medals![index];
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              // 点击网格勋章 → 网格来源详情页（对应旧 NewSingleMedalScreen）
              context.push(
                '/medal-detail',
                extra: MedalDetailArgs(
                  fromTop: false,
                  groupIndex: outIndex,
                  medalIndex: index,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              alignment: Alignment.center,
              child: Opacity(
                opacity: (medal.have ?? false) ? 1 : 0.1,
                child: ExtendedImage.network(
                  // 服务端返回完整 OSS URL，直接加载
                  medal.image ?? '',
                  fit: BoxFit.fitWidth,
                  width: 200.sp,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return Center(
                          child: LoadingAnimationWidget.waveDots(
                            color: FitTheme.textColor,
                            size: 50,
                          ),
                        );
                      case LoadState.failed:
                        return Center(
                          child: Image.asset(
                            'images/newUIScreen/defaultheadimages/deheadImage8.jpg',
                          ),
                        );
                      case LoadState.completed:
                        return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          width: size.width - 10,
                          fit: BoxFit.fill,
                        );
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            alignment: Alignment.topCenter,
            child: Text(
              '${l10n.medalTotal} ${medal.target} ',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp),
            ),
          ),
        ],
      ),
    );
  }
}
