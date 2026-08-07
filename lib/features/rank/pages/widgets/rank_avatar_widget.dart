import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/them_change.dart';

class RankAvatarWidget extends StatelessWidget {
  final String? headImgHash;
  final double size;

  const RankAvatarWidget({
    super.key,
    this.headImgHash,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final hash = headImgHash ?? '';

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1A1A1A),
      ),
      clipBehavior: Clip.hardEdge,
      child: hash.isEmpty
          ? ExtendedImage.asset(
              'images/newUIScreen/defaultheadimages/deheadImage1.jpg',
              fit: BoxFit.cover,
            )
          : ExtendedImage.network(
              '${ApiConstants.baseUrl}${ApiConstants.userPicture}$hash',
              headers: const {'app_pass': ApiConstants.appPass},
              fit: BoxFit.cover,
              loadStateChanged: (state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: FitTheme.textColor,
                        size: size * 0.4,
                      ),
                    );
                  case LoadState.failed:
                    return Center(
                      child: ExtendedImage.asset(
                        'images/newUIScreen/defaultheadimages/deheadImage1.jpg',
                        fit: BoxFit.cover,
                      ),
                    );
                  case LoadState.completed:
                    return ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      fit: BoxFit.cover,
                    );
                }
              },
            ),
    );
  }
}
