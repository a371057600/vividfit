import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/them_change.dart';
import '../../data/models/rank_leaderboard_entity.dart';
import '../../domain/rank_device_type.dart';
import 'rank_avatar_widget.dart';

class RankListItemWidget extends StatelessWidget {
  final List<RankLeaderboardEntity> leaderboardList;
  final RankDeviceType deviceType;

  const RankListItemWidget({
    super.key,
    required this.leaderboardList,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    if (leaderboardList.isEmpty) {
      return const Center(
        child: Text('No data'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: leaderboardList.length,
      itemBuilder: (context, index) {
        final entity = leaderboardList[index];
        return _buildListItem(entity);
      },
    );
  }

  Widget _buildListItem(RankLeaderboardEntity entity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10).r,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8).r,
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 60.w,
            child: Text(
              '${entity.rank}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.bebas,
                color: FitTheme.textColor,
                fontSize: 30.sp,
              ),
            ),
          ),
          // Avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10).r,
            child: entity.headImg == null || entity.headImg!.isEmpty
                ? CircleAvatar(
                    radius: 30.r,
                    backgroundColor: FitTheme.textColor,
                    child: Image.asset(
                      'images/newUIScreen/defaultheadimages/deheadImage1.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                : RankAvatarWidget(
                    headImgHash: entity.headImg,
                    size: 60,
                  ),
          ),
          // Nickname
          Expanded(
            child: Text(
              entity.nickName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 25.sp,
              ),
            ),
          ),
          // Score
          Text(
            deviceType == RankDeviceType.all
                ? entity.calories.toStringAsFixed(0)
                : entity.count.toStringAsFixed(0),
            style: TextStyle(
              fontFamily: AppFonts.bebas,
              color: FitTheme.textColor,
              fontSize: 30.sp,
            ),
          ),
        ],
      ),
    );
  }
}
