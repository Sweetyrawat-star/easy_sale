import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/network/constants/endpoints.dart';
import '../utils/shared/text_format.dart';

class VariantCardItemWidget extends StatelessWidget {
  final String name;
  final num price;
  final num preSalePrice;
  final String bonus;
  final String image;
  final Color? color;

  const VariantCardItemWidget({
    Key? key,
    required this.name,
    required this.price,
    required this.preSalePrice,
    required this.bonus,
    required this.image,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: (MediaQuery.of(context).size.width - 40) / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color ?? AppColors.bgGreyColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 160.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          Endpoints.getDownloadUrl(image))),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Text(name,
                    style: AppStyles.textStyle16Regular400
                        .merge(TextStyle(height: 1.21)), maxLines: 4,),
              )
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormat.usd(price.toString()),
                  style: AppStyles.textStyle20RegularBold.merge(TextStyle(
                    height: 1.1,
                    color: AppColors.redLightColor,
                  )),
                ),
                Text(
                  CurrencyFormat.usd(preSalePrice.toString()),
                  style: AppStyles.textStyle14Regular.merge(TextStyle(
                    height: 1.57,
                    color: AppColors.greyPrice,
                    decoration: TextDecoration.lineThrough,
                  )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
