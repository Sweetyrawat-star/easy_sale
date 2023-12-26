import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/ui/store/widgets/rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../ui/store/detail_store.dart';

class FeedbackItemWidget extends StatelessWidget {
  final String shopId;
  final String shopAvatar;
  final String shopName;
  final String content;
  final String userName;
  final int? rating;
  final VoidCallback onPressed;

  const FeedbackItemWidget({
    Key? key,
    required this.shopId,
    required this.shopAvatar,
    required this.shopName,
    required this.content,
    required this.userName,
    required this.rating,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 154.0,
      width: 340,
      // padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: AppColors.quoteBgColor,
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(Endpoints.getDownloadUrl(shopAvatar)),
                    // radius: 70,
                  ),
                ),
                Expanded(
                  child: MyLabelWidget(text: shopName, style: AppStyles.textStyle14Medium, maxLines: 2,),
                  flex: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Image.asset(Assets.quoteIcon, height: 20, width: 20,),
                ),
              ],
            ),
            onTap: () {
              NavigationService.push(context, DetailStoreScreen(storeId: shopId,));
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right:40),
            child: MyLabelWidget(
              text: content,
              maxLines: 3,
              style: TextStyle(height: 1.28, color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingWidget(rating: this.rating!/1, starSize: 18, hideRating: true,),
                  MyLabelWidget(text: userName, style: AppStyles.textStyle14Regular)
                  // InkWell(
                  //   child: Row(
                  //     children: [
                  //       MyLabelWidget(text: "Xem thêm", style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.link)),),
                  //       SizedBox(width: 7),
                  //       Image.asset(Assets.greaterIcon, width: 11.0,),
                  //     ],
                  //   ),
                  //   onTap: onPressed,
                  // )
                ],
            ),
          )
        ],
      ),
    );
  }
}
