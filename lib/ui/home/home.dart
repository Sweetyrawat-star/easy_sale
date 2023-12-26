import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/brand/brand_list.dart';
import 'package:boilerplate/models/variant/variant.dart';
import 'package:boilerplate/models/variant/variant_list.dart';
import 'package:boilerplate/stores/cart/cart_store.dart';
import 'package:boilerplate/stores/visit/visit_store.dart';
import 'package:boilerplate/ui/account/promotions_detail.dart';
import 'package:boilerplate/ui/account/two_step.dart';
import 'package:boilerplate/ui/brand/detail_brand.dart';
import 'package:boilerplate/ui/rating/list_note.dart';
import 'package:boilerplate/ui/visit/visit_screen.dart';
import 'package:boilerplate/widgets/feedback_item_widget.dart';
import 'package:boilerplate/widgets/primary_app_bar_widget.dart';
import 'package:boilerplate/widgets/variant_card_item_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../constants/assets.dart';
import '../../di/components/service_locator.dart';
import '../../models/rating/rating.dart';
import '../../models/rating/rating_list.dart';
import '../../stores/feedback/feedback_store.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/block_header_widget.dart';
import '../../widgets/card_style_1_widget.dart';
import '../../widgets/card_style_2_widget.dart';
import '../../widgets/my_label_widget.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../product/detail_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late FeedbackStore _feedbackStore;
  late CartStore _cartStore;
  late VisitStore _visitStore;
  final Repository _repository = getIt<Repository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _feedbackStore = Provider.of<FeedbackStore>(context);
    _cartStore = Provider.of<CartStore>(context);
    _visitStore = Provider.of<VisitStore>(context);

    // check to see if already called api
    if (!_feedbackStore.loading) {
      _feedbackStore.getFeedbacks({"page": 1, "item_per_page": 5});
    }
    _cartStore.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return PrimaryAppBar();
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildCheckedInBlock(),
            _build2StepBlock(),
            _buildFeedbackBlock(),
            Divider(thickness: 7.0, color: AppColors.bgGreyColor),
            _buildBrandsBlock(),
            Divider(
              thickness: 7.0,
              color: AppColors.bgGreyColor,
            ),
            _buildPromoBlock(),
            Divider(thickness: 7.0, color: AppColors.bgGreyColor),
            _buildSaleBlock(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckedInBlock() {
    return Observer(
        builder: (_) => _visitStore.checkedIn
            ? Container(
                height: 70,
                color: AppColors.checkedInBlockColor,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.checkpointIcon,
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MyLabelWidget(
                          text: "Currently check-in store " +
                              (_visitStore.visit?.currentShop.name ?? ""),
                          style: AppStyles.textStyle16Regular400,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 145,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor
                            ]),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: ElevatedButton(
                          onPressed: () {
                            NavigationService.push(context, VisitScreen());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent),
                          child: Text(
                            "Back to store",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ))
            : SizedBox());
  }

  Widget _buildFeedbackBlock() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: BlockHeaderWidget(
              titleText: "Recent Store's Reviews",
              leftIcon: Image.asset(
                Assets.feedbackIcon,
                width: 30.0,
                height: 30.0,
              ),
              onReadmorePressed: () {
                NavigationService.push(context, ListRatingScreen());
              }),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          height: 185,
          child: FutureBuilder(
            future: _repository.getFeedbacks({
              "page": 1,
              "item_per_page": 5,
            }),
            builder: ((context, AsyncSnapshot<RatingList> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return (snapshot.data?.ratings.length == 0)
                      ? Center(
                          child: MyLabelWidget(
                            text: "No review yet!",
                            style: AppStyles.textStyle14Regular
                                .merge(TextStyle(color: AppColors.greyPrice)),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.ratings.length ?? 0 + 1,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: _buildFeedbackItem(
                              list: snapshot.data?.ratings,
                              index: index,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 0),
                        );
                } else {
                  return CustomProgressIndicatorWidget();
                }
              } else {
                return CustomProgressIndicatorWidget();
              }
            }),
          ),
        ),
        // Container(
        //   padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
        //   height: 185,
        //   child: Observer(builder: (context) {
        //     return Material(child: ListView.builder(
        //         shrinkWrap: true,
        //         scrollDirection: Axis.horizontal,
        //         itemCount: _feedbackStore.ratingList?.ratings?.length,
        //         itemBuilder: (BuildContext context, int index) => Padding(
        //           padding: EdgeInsets.only(right: 12),
        //           child: _feedbackStore.ratingList != null ? _buildFeedbackItem(index) : Container(),
        //         )
        //     ),);
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFeedbackItem({List<Rating>? list, required int index}) {
    Rating _rating = list![index];
    return FeedbackItemWidget(
      shopId: '${_rating.storeId}',
      shopAvatar: '${_rating.storeAvatar}',
      shopName: '${_rating.storeName}',
      content: '${_rating.comment}',
      userName: '${_rating.userName}',
      rating: _rating.star,
      onPressed: () {},
    );
  }

  Widget _buildProductVariantItem(
      {List<ProductVariant>? list, required int index}) {
    if (index > list!.length - 1) return SizedBox();
    ProductVariant _variant = list[index];
    return InkWell(
      child: VariantCardItemWidget(
          name: _variant.name,
          price: _variant.price,
          preSalePrice: _variant.preSalePrice,
          bonus: "",
          image: _variant.images[0]),
      onTap: () {
        print('romeo product id: ' + _variant.productId);
        NavigationService.push(
          context,
          DetailProductScreen(
            productId: _variant.productId,
            variantId: _variant.id,
          ),
        ).then((value) => {});
      },
    );
  }

  Widget _buildSaleBlock() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: BlockHeaderWidget(
            titleText: "Should sell today",
            leftIcon: Image.asset(
              Assets.saleIcon,
              width: 33.0,
              height: 12.0,
            ),
          ),
        ),
        FutureBuilder(
          future: _repository.getProductVariants({
            "page": 1,
            "item_per_page": 16,
          }),
          builder: ((context, AsyncSnapshot<ProductVariantList> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                    padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                    height:
                        (snapshot.data?.productVariants.length ?? 0) * 320 / 2,
                    child: AlignedGridView.count(
                      itemCount: 12,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return _buildProductVariantItem(
                          list: snapshot.data?.productVariants,
                          index: index,
                        );
                      },
                    ));
              } else {
                return Container(
                  height: 200,
                  child: CustomProgressIndicatorWidget(),
                );
              }
            } else {
              return Container(
                height: 200,
                child: CustomProgressIndicatorWidget(),
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildPromoBlock() {
    const arr = [
      "assets/images/sale2.png",
      "assets/images/sale3.png",
      "assets/images/sale1.png"
    ];
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: BlockHeaderWidget(
              titleText: "Promotions",
              leftIcon: Image.asset(
                Assets.promoIcon,
                width: 20.0,
                height: 22,
              ),),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          height: 145,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(right: 12),
              child: CardStyle2Widget(
                bgImage: AssetImage(arr[index]),
                onPressed: () {
                  NavigationService.push(context, PromotionDetailScreen());
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandsBlock() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: BlockHeaderWidget(
            leftIcon: Image.asset(
              Assets.handshakeIcon,
              width: 26.0,
            ),
            titleText: "Prominent Brands",
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15, left: 20),
          height: 230,
          child: FutureBuilder(
            future: _repository.getBrands({
              "page": 1,
              "item_per_page": 6,
            }),
            builder: ((context, AsyncSnapshot<BrandList> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.brands?.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: CardStyle1Widget(
                        bgImage: CachedNetworkImageProvider(
                            Endpoints.getDownloadUrl(
                                snapshot.data?.brands?.elementAt(index).logo,
                                "brand")),
                        buttonText: "Explore",
                        onPressed: () {
                          NavigationService.push(
                              context,
                              DetailBrandScreen(
                                  brandId: snapshot.data?.brands
                                          ?.elementAt(index)
                                          .id ??
                                      ""));
                        },
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 200,
                    child: CustomProgressIndicatorWidget(),
                  );
                }
              } else {
                return Container(
                  height: 200,
                  child: CustomProgressIndicatorWidget(),
                );
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _build2StepBlock() {
    return Stack(
      children: [
        Container(
          height: 145.0,
          decoration: BoxDecoration(
              color: AppColors.green[200],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.green[200]!.withOpacity(0.5),
                  AppColors.green[200]!.withOpacity(0),
                ],
              )),
        ),
        Positioned(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  child: Image.asset(Assets.oneTouchImage,
                      width: MediaQuery.of(context).size.width - 40),
                  onTap: () {
                    NavigationService.push(context, TwoStepScreen());
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
