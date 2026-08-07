import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/them_change.dart';
import '../../domain/rank_device_type.dart';
import 'rank_avatar_widget.dart';

class RankUserCardWidget extends StatelessWidget {
  final String userNickName;
  final String userHeadImage;
  final String userRank;
  final String userScore;
  final RankDeviceType deviceType;

  const RankUserCardWidget({
    super.key,
    required this.userNickName,
    required this.userHeadImage,
    required this.userRank,
    required this.userScore,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10).r,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).r,
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(10).r,
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 80.w,
            child: Text(
              userRank,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.bebas,
                color: FitTheme.textColor,
                fontSize: 35.sp,
              ),
            ),
          ),
          // Avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).r,
            child: RankAvatarWidget(
              headImgHash: userHeadImage,
              size: 70,
            ),
          ),
          // Nickname
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userNickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  deviceType == RankDeviceType.all
                      ? 'Calories'
                      : 'Count',
                  style: TextStyle(
                    color: FitTheme.textColor.withValues(alpha: 0.6),
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                userScore,
                style: TextStyle(
                  fontFamily: AppFonts.bebas,
                  color: FitTheme.textColor,
                  fontSize: 40.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
