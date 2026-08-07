import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/them_change.dart';
import '../notifiers/rank_notifier.dart';
import '../states/rank_state.dart';
import 'widgets/rank_date_filter_widget.dart';
import 'widgets/rank_device_filter_sheet.dart';
import 'widgets/rank_list_item_widget.dart';
import 'widgets/rank_top_three_widget.dart';
import 'widgets/rank_user_card_widget.dart';

class RankingScreen extends ConsumerWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rankProvider);
    final notifier = ref.read(rankProvider.notifier);

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 100.r,
        backgroundColor: FitTheme.backgroundColor,
        shadowColor: Colors.transparent,
        leadingWidth: 300.r,
        actions: [
          _buildDeviceSelector(context, state, notifier),
        ],
        leading: _buildBackButton(context),
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildDeviceSelector(BuildContext context, RankState state, RankNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.only(right: 45, bottom: 2).r,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => RankDeviceFilterSheet(
              currentType: state.deviceType,
              onChanged: (type) {
                Navigator.pop(context);
                notifier.changeDeviceType(type);
              },
            ),
          );
        },
        child: Container(
          alignment: Alignment.bottomRight,
          height: 100.r,
          width: 300.r,
          child: Text(
            state.deviceType.displayName,
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 25.sp,
              fontFamily: AppFonts.hofontmedium,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45).r,
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
                size: 20,
              ),
            ),
            Text(
              'Ranking',
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 40.sp,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rankProvider);
    final notifier = ref.read(rankProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 25, right: 25, top: 40).r,
      child: Column(
        children: [
          // 日期筛选
          Container(
            margin: const EdgeInsets.only(bottom: 25).r,
            padding: EdgeInsets.all(2).r,
            alignment: Alignment.center,
            height: 60.h,
            width: double.infinity,
            child: RankDateFilterWidget(
              currentRange: state.timeRange,
              onChanged: (range) => notifier.changeTimeRange(range),
            ),
          ),
          // 加载中 / Top3 / 列表
          state.isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: FitTheme.textColor,
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                    children: [
                      RankTopThreeWidget(
                        topThree: state.leaderboardList.take(3).toList(),
                        deviceType: state.deviceType,
                      ),
                      Expanded(
                        child: RankListItemWidget(
                          leaderboardList: state.leaderboardList.skip(3).toList(),
                          deviceType: state.deviceType,
                        ),
                      ),
                    ],
                  ),
                ),
          // 用户卡片
          RankUserCardWidget(
            userNickName: state.userNickName ?? '',
            userHeadImage: state.userHeadImage ?? '',
            userRank: state.userRank ?? '-',
            userScore: state.userScore ?? '-',
            deviceType: state.deviceType,
          ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}
