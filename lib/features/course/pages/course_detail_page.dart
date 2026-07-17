import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../data/models/course_detail.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/course_providers.dart';
import '../states/course_detail_state.dart';

/// 课程详情页（1:1 还原原 new_course_detail_screen.dart）。
class CourseDetailPage extends ConsumerStatefulWidget {
  const CourseDetailPage({super.key});

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.offset <= -100.0) {
        // 下拉返回逻辑（原项目 isback 标记）
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        ref
            .read(courseDetailNotifierProvider.notifier)
            .initFromArguments(extra);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseDetailNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        foregroundColor: Colors.black,
        scrolledUnderElevation: 0,
        backgroundColor: FitTheme.backgroundColor,
        leadingWidth: MediaQuery.of(context).size.width,
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
                  l10n.courses,
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
      body: _buildMainWidget(state, l10n),
    );
  }

  Widget _buildMainWidget(CourseDetailState state, AppLocalizations l10n) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 20).r,
            color: Colors.transparent,
            child: ExtendedImage.network(
              state.courseCover.isNotEmpty
                  ? 'https://www.ucfitness.club/api/picture/path/${state.courseCover}'
                  : '',
              fit: BoxFit.fill,
              loadStateChanged: (ExtendedImageState imageState) {
                switch (imageState.extendedImageLoadState) {
                  case LoadState.loading:
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: FitTheme.textColor,
                        size: 50,
                      ),
                    );
                  case LoadState.failed:
                    return const Center(child: SizedBox.shrink());
                  case LoadState.completed:
                    return ExtendedRawImage(
                      image: imageState.extendedImageInfo?.image,
                      width: MediaQuery.of(context).size.width - 10,
                      fit: BoxFit.fill,
                    );
                }
              },
            ),
          ),
          SizedBox(
            width: 400.w,
            height: 100.h,
            child: TabBar(
              controller: _tabController,
              labelColor: FitTheme.buttonColor,
              unselectedLabelColor: FitTheme.textColor,
              indicatorWeight: 2.0,
              indicatorPadding: const EdgeInsets.only(bottom: 5),
              indicatorColor: FitTheme.buttonColor,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: l10n.action),
                Tab(text: l10n.description),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildActionList(state),
                    _buildDescription(state, l10n),
                  ],
                ),
                if (state.playWithDevice)
                  Positioned(
                    bottom: 100.5,
                    right: 10.52,
                    child: RepaintBoundary(
                      child: Container(
                        width: 69,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34.5),
                          color: Colors.transparent,
                          border: Border.all(
                            color: FitTheme.buttonColor,
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            // TODO: 跳转到设备连接页
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(16, 106, 240, 1),
                                  Color.fromARGB(255, 20, 247, 213),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/icon_lj.png',
                                  width: 21,
                                  height: 21,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.connect,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FitTheme.textColor,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(flex: 1, child: _buildBottomButton(state, l10n)),
        ],
      ),
    );
  }

  Widget _buildActionList(CourseDetailState state) {
    final data = state.courseDetail?.data ?? [];
    final displayCount = data.isEmpty
        ? 0
        : ref.read(courseDetailNotifierProvider.notifier).areAllElementsSame()
            ? 2
            : data.length;

    return SizedBox(
      height: 600,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: displayCount,
        itemBuilder: (_, index) {
          if (index >= data.length) return const SizedBox.shrink();
          final action = data[index];
          if (action.actionType == -1) return Container();

          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _showActionBottomSheet(action, index),
            child: Container(
              height: 82,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                action.cover != null && action.cover!.isNotEmpty
                                    ? 'https://www.ucfitness.club/api/picture/path/${action.cover}'
                                    : '',
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            progressIndicatorBuilder: (
                              context,
                              url,
                              downloadProgress,
                            ) =>
                                Container(
                              margin: const EdgeInsets.all(15),
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                backgroundColor: FitTheme.backgroundColor,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 82,
                        width: MediaQuery.of(context).size.width * 0.68,
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Color.fromARGB(255, 147, 147, 147),
                            ),
                          ),
                        ),
                        child: Text(
                          action.actionName ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: FitTheme.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription(CourseDetailState state, AppLocalizations l10n) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.courseProposal,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              state.proposal,
              style: TextStyle(fontSize: 13, color: FitTheme.textColor),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.courseDescription,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              state.describe,
              style: TextStyle(fontSize: 13, color: FitTheme.textColor),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.notice,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              state.carefulthing,
              style: TextStyle(fontSize: 13, color: FitTheme.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(CourseDetailState state, AppLocalizations l10n) {
    return Container(
      height: 80.h,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: state.isDownloading
          ? InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: Container(
                height: 40,
                width: 170,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: FitTheme.buttonColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    LinearPercentIndicator(
                      width: 170,
                      lineHeight: 40,
                      percent: state.downloadProgress / 100,
                      backgroundColor: FitTheme.secondbackGround,
                      linearGradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.blue],
                      ),
                      barRadius: const Radius.circular(30),
                      padding: const EdgeInsets.all(0),
                    ),
                    Text(
                      '${state.downloadProgress.round()} %',
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: FitTheme.buttonColor,
                minimumSize: const Size(170, 40),
                backgroundColor: FitTheme.buttonColor,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              onPressed: () {
                ref.read(courseDetailNotifierProvider.notifier).startAction();
              },
              child: Text(
                state.isNeedUpdate ? l10n.download : l10n.play,
                style: TextStyle(color: FitTheme.textButtonColor),
              ),
            ),
    );
  }

  void _showActionBottomSheet(CourseAction action, int index) {
    // TODO: 实现动作详情底部弹窗（ImageAnimation 等）
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 60,
          color: const Color.fromARGB(255, 17, 17, 17),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 51, 51, 51),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: FitTheme.secondbackGround,
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.actionName ?? '',
                        style: TextStyle(
                          color: FitTheme.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(
                        color: FitTheme.textColor,
                        thickness: 0.5,
                        height: 20,
                      ),
                      Text(
                        'Key Point',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FitTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action.actionIntroduce ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: FitTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
