import 'dart:io';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/cart/cart.dart';
import 'package:boilerplate/models/variant/variant.dart';
import 'package:boilerplate/stores/cart/cart_store.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/cart_icon_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../data/network/constants/endpoints.dart';
import '../../di/components/service_locator.dart';
import '../../models/product/product.dart';
import '../../utils/shared/text_format.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/gallery_photo_view_item_widget.dart';
import '../../widgets/gallery_photo_view_widget.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../../widgets/rounded_button_widget.dart';
import '../../widgets/rounded_icon_button_widget.dart';
import '../cart/detail_cart.dart';
import '../provider/detail_provider.dart';

class ChoiceModel {
  String attrId;
  String attrName;
  String attrValueId;
  String attrValueName;

  ChoiceModel(
      {required this.attrId,
      required this.attrName,
      required this.attrValueId,
      required this.attrValueName});

  static empty() {
    return ChoiceModel(
        attrId: "", attrValueId: "", attrName: "", attrValueName: "");
  }
}

class DetailProductScreen extends StatefulWidget {
  final String productId;
  final String? variantId;

  DetailProductScreen({required this.productId, this.variantId});

  @override
  State<StatefulWidget> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final Repository _repository = getIt<Repository>();
  late Product currentProduct;
  ProductVariant? selectedVariant;
  int total = 1;
  num totalPrice = 0;
  List<ChoiceModel> selectedAttributes = [];
  late CartStore _cartStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<CartStore>(context);
    _repository.getProduct(widget.productId).then((product) {
      var tmp = product.variants?.productVariants[0];
      if (widget.variantId != null) {
        tmp = product.variants?.productVariants
            .firstWhere((element) => element.id == widget.variantId);
        product.attributes.forEach((element) {
          selectedAttributes.add(ChoiceModel(
            attrId: element.id,
            attrName: element.name,
            attrValueId: tmp?.kv[element.id],
            attrValueName: element.values
                .firstWhereOrNull((item) => item.id == tmp?.kv[element.id])!
                .value,
          ));
        });
      } else {
        product.attributes.forEach((element) {
          selectedAttributes.add(ChoiceModel(
              attrId: element.id,
              attrName: element.name,
              attrValueId: element.values[0].id,
              attrValueName: element.values[0].value));
        });
      }
      setState(() {
        currentProduct = product;
        selectedVariant = tmp;
        totalPrice = selectedVariant?.price ?? 0;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: MyLabelWidget(text: "Product", style: AppStyles.textStyle18Medium,),
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
      body: _buildProductDetailsPage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildProductDetailsPage() {
    return selectedVariant != null
        ? ListView(
            children: [
              SizedBox(height: 10,),
              _buildImages(),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: MyLabelWidget(
                          text: selectedVariant?.name ?? "",
                          style: AppStyles.textStyle18Medium
                              .merge(TextStyle(height: 1.333))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                  CurrencyFormat.usd(
                                          selectedVariant?.price.toString() ??
                                              ""),
                                  style: AppStyles.textStyle24Bold.merge(
                                      TextStyle(
                                          height: 1.1,
                                          color: AppColors.redLightColor))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  CurrencyFormat.usd(selectedVariant
                                              ?.preSalePrice
                                              .toString() ??
                                          ""),
                                  style: AppStyles.textStyle14Regular.merge(
                                      TextStyle(
                                          height: 1.57,
                                          color: AppColors.greyPrice,
                                          decoration:
                                              TextDecoration.lineThrough))),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage:CachedNetworkImageProvider(
                                    Endpoints.getDownloadUrl(currentProduct.provider?.logo, "brand")),
                              ),
                              SizedBox(height: 5.0,),
                              MyLabelWidget(
                                  text: currentProduct.provider?.name ?? "",
                                  style: AppStyles.textStyle16Medium)
                            ],
                          ),
                          onTap: () {
                            NavigationService.push(context, DetailProviderScreen(provider: currentProduct.provider,));
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: List.from(currentProduct.attributes
                          .map((item) => _buildAttribute(item))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyLabelWidget(
                        text: "Product detail",
                        style: AppStyles.textStyle16Medium),
                    SizedBox(
                      height: 10,
                    ),
                    Html(
                      data: currentProduct.desc,
                      // Styling with CSS (not real CSS)
                      style: {
                        'h1': Style(color: Colors.red),
                        'p': Style(color: Colors.black87, fontSize: FontSize.medium),
                        'ul': Style(padding: EdgeInsets.all(20))
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : CustomProgressIndicatorWidget();
  }

  _buildImages() {
    return InkWell(
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: CachedNetworkImage(
          imageUrl: Endpoints.getDownloadUrl(selectedVariant?.images[0]),
          fit: BoxFit.fitWidth,
        ),
      ),
      onTap: () {
        NavigationService.push(
            context,
            GalleryPhotoViewWrapper(
              galleryItems: _buildImageGallery(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: 0,
              scrollDirection: Axis.horizontal,
            ));
      },
    );
  }

  _buildAttribute(Attribute attribute) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyLabelWidget(text: attribute.name, style: AppStyles.textStyle16Medium),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: attribute.values.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(
                  attribute.values[index].value.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white, fontSize: 14),
                ),
                selected: _isSelected(attribute, index),
                selectedColor: AppColors.green[500],
                onSelected: (value) {
                  var tmp = selectedAttributes
                      .firstWhere((element) => element.attrId == attribute.id);
                  if (tmp.attrValueId == attribute.values[index].id) return;
                  List<ChoiceModel> tmp2 =
                      List.from(selectedAttributes.map((element) {
                    if (element.attrId == attribute.id) {
                      return ChoiceModel(
                        attrId: element.attrId,
                        attrName: attribute.values[index].value,
                        attrValueId: attribute.values[index].id,
                        attrValueName: attribute.values[index].value,
                      );
                    } else {
                      return element;
                    }
                  }));
                  _onAttributeSelected(tmp2);
                },
                // backgroundColor: color,
                elevation: 1,
              ),
            ),
            padding: EdgeInsets.only(top: 0),
          ),
        )
      ],
    );
  }

  _onAttributeSelected(List<ChoiceModel> list) {
    ProductVariant? variant =
        currentProduct.variants?.productVariants.firstWhereOrNull((element) {
      bool isOk = true;
      for (var i = 0; i < list.length; i++) {
        if (element.kv[list[i].attrId] != list[i].attrValueId) {
          isOk = false;
        }
      }
      return isOk;
    });
    if (variant != null) {
      setState(() {
        selectedAttributes = list;
        selectedVariant = variant;
        totalPrice = variant.price * total;
      });
    }
  }

  bool _isSelected(Attribute attribute, int index) {
    ChoiceModel choice = selectedAttributes.firstWhere(
        (element) =>
            element.attrId == attribute.id &&
            element.attrValueId == attribute.values[index].id,
        orElse: () => ChoiceModel.empty());
    if (choice.attrId != "") return true;
    return false;
  }

  _buildImageGallery() {
    List<GalleryExampleItem> list = [];
    var total = selectedVariant?.images.length;
    for (var i = 0; i < total!; i++) {
      list.add(GalleryExampleItem(
        id: "img" + i.toString(),
        resource: Endpoints.getDownloadUrl(selectedVariant?.images[i]),
      ));
    }
    return list;
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Platform.isIOS ? 125.0 : 115.0,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: Platform.isIOS ? 10 : 0),
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey, blurRadius: 2.0, offset: Offset(0.0, 0.5))
      ], color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyLabelWidget(
                text: "Quantity",
                style: AppStyles.textStyle16Medium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedIconButton(
                    icon: Icons.remove,
                    iconSize: 25,
                    onPress: () {
                      if (total == 1) return;
                      setState(() {
                        total = total - 1;
                      });
                      setState(() {
                        totalPrice = total * (selectedVariant?.price ?? 0);
                      });
                    },
                  ),
                  Container(
                    width: 25,
                    child: Text(
                      '$total',
                      style: TextStyle(
                        fontSize: 25 * 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RoundedIconButton(
                    icon: Icons.add,
                    iconSize: 25,
                    onPress: () {
                      setState(() {
                        total = total + 1;
                      });
                      setState(() {
                        totalPrice = total * (selectedVariant?.price ?? 0);
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButtonWidget(
                buttonWidth: (MediaQuery.of(context).size.width - 70) / 2,
                buttonHeight: 48,
                buttonText:
                    'Buy now ${CurrencyFormat.usd(totalPrice.toString())}',
                linearGradient: LinearGradient(colors: [
                  AppColors.btnBuyNowColor,
                  AppColors.btnBuyNowColor
                ]),
                onPressed: () {
                  this._addToCart().then((item) {
                    _cartStore.addToCart(item);
                    NavigationService.push(context, DetailCartScreen());
                  }).catchError((error) {
                    FlashMessageWidget.flashError(context, error.toString());
                  });
                },
              ),
              RoundedButtonWidget(
                buttonWidth: (MediaQuery.of(context).size.width - 70) / 2,
                buttonHeight: 48,
                buttonText: "Add to cart",
                linearGradient: LinearGradient(colors: [
                  AppColors.btnAddToCardColor,
                  AppColors.btnAddToCardColor
                ]),
                onPressed: () {
                  this._addToCart().then((item) {
                    _cartStore.addToCart(item);
                    FlashMessageWidget.flashSuccessFromTop(
                        context, "Add to cart successful!");
                  }).catchError((error) {
                    FlashMessageWidget.flashError(context, error.toString());
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Future<CartItem> _addToCart() {
    CartItem item = CartItem(
      id: selectedVariant?.id ?? "",
      name: selectedVariant?.name ?? "",
      qty: total,
      price: selectedVariant?.price ?? 0,
      providerId: currentProduct.provider?.id ?? "",
      providerName: currentProduct.provider?.name ?? "",
      attrs: selectedAttributes.map((e) => e.attrValueName).join(", "),
      image: selectedVariant?.images[0] ?? "",
    );
    Cart? cart = _cartStore.cart;
    cart?.items = _cartStore.list?.toList() ?? [];
    cart?.items.add(item);
    return _repository.updateCart(cart!).then((value) => item);
  }
}
