import 'dart:math';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/product_list_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/brand/brand.dart';
import '../../widgets/block_header_widget.dart';
import '../../widgets/cart_icon_widget.dart';

class DetailBrandScreen extends StatefulWidget {
  final String brandId;

  DetailBrandScreen({Key? key, required this.brandId});

  @override
  State<StatefulWidget> createState() => _DetailBrandScreenState();
}

class _DetailBrandScreenState extends State<DetailBrandScreen> {
  final Repository _repository = getIt<Repository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: MyLabelWidget(text: "Brand", style: AppStyles.textStyle18Medium,),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: CartIconWidget(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _repository.getBrand(widget.brandId),
          builder: ((context, AsyncSnapshot<Brand> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildBody(snapshot.data!);
              } else {
                return SizedBox();
              }
            } else {
              return SizedBox();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildBody(Brand brand) {
    const arr = [
      "https://imgmedia.lbb.in/media/2019/08/5d5be72da2c996581f710a08_1566304045802.jpg",
      "https://www.instorindia.com/wp-content/uploads/2017/11/banner-1.png",
      "https://cdn.akamai.steamstatic.com/steam/apps/1355060/header.jpg",
      "https://c.ndtvimg.com/2022-03/qnrhrrug_grocery-store_625x300_25_March_22.jpg"
    ];
    return Column(
      children: [
        SizedBox(
          height: 246,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 55),
                child: CachedNetworkImage(
                  imageUrl: arr[new Random().nextInt(3) + 0],//Endpoints.getDownloadUrl(
                      // "upload/image/henry-be-iicyiapyggi-unsplash_ad_caei9j9s49g2gh6e8d0g.jpg"),
                      // "upload/image/simon-berger-twukn12en7c-unsplash_ad_caei9j9s49g2gh6e8d0g.jpg"),
                      // "upload/image/gory-sneg-lug-tsvety-shtat-vashington-ssha_ad_caei9j9s49g2gh6e8d0g.jpeg"),
                      // "upload/image/6231375_ad_caei9j9s49g2gh6e8d0g.jpg"),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.bgGreyColor,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: CachedNetworkImageProvider(
                        Endpoints.getDownloadUrl(brand.logo, "brand"),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 140, bottom: 10),
                child: MyLabelWidget(
                  text: brand.name,
                  style: AppStyles.textStyle24Medium,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 5,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: BlockHeaderWidget(
            leftIcon: Image.asset(
              Assets.newIcon,
              width: 26.0,
            ),
            titleText: "Products",
          ),
        ),
        _buildListProduct(brand.id),
      ],
    );
  }

  Widget _buildListProduct(String brandId) {
    return ProductListWidget(
      height: MediaQuery.of(context).size.height - 123 - 236,
      queryParams: {"brand_id": brandId},
    );
  }
}
