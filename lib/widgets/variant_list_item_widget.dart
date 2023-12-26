import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/network/constants/endpoints.dart';
import '../models/variant/variant.dart';
import '../ui/product/detail_product.dart';
import '../utils/shared/nav_service.dart';
import '../utils/shared/text_format.dart';

class VariantListItemWidget extends StatelessWidget {
  final ProductVariant variant;
  final Color? color;
  final VoidCallback onAddToCart;
  final bool? isLastItem;

  const VariantListItemWidget({
    Key? key,
    this.color,
    this.isLastItem = false,
    required this.variant,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      // height: 115,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                  width: 125,
                  height: 115.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            Endpoints.getDownloadUrl(variant.images[0]))),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onTap: () => _toDetail(context),
              ),
              SizedBox(width: 15,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyLabelWidget(text: variant.name, style: AppStyles.textStyle16Regular400),
                        SizedBox(height: 10,),
                        Text(
                          CurrencyFormat.usd(variant.price.toString()),
                          style: AppStyles.textStyle20RegularBold.merge(TextStyle(
                            height: 1.1,
                            color: AppColors.redLightColor,
                          )),
                        ),
                        Text(
                          CurrencyFormat.usd(variant.preSalePrice.toString()),
                          style: AppStyles.textStyle14Regular.merge(TextStyle(
                            height: 1.57,
                            color: AppColors.greyPrice,
                            decoration: TextDecoration.lineThrough,
                          )),
                        ),
                      ],
                    ),
                    onTap: () => _toDetail(context),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     InkWell(
                  //       child: Image.asset(Assets.cartPlusIcon, height: 35),
                  //       onTap: onAddToCart,
                  //     )
                  //   ],
                  // )
                ],
              )),
            ],
          ),
        ],
      ),

    );
  }

  void _toDetail(BuildContext context) {
    NavigationService.push(
      context,
      DetailProductScreen(
        productId: variant.productId,
        variantId: variant.id,
      ),
    ).then((value) => {});
  }
}
