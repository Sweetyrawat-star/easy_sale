import 'dart:io';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/models/cart/cart.dart';
import 'package:boilerplate/stores/cart/cart_store.dart';
import 'package:boilerplate/ui/cart/ship_info_2.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/confirm_dialog_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../data/network/constants/endpoints.dart';
import '../../stores/visit/visit_store.dart';
import '../../utils/shared/nav_service.dart';
import '../../utils/shared/text_format.dart';
import '../../widgets/common_dialog_widget.dart';
import '../../widgets/no_data_screen_widget.dart';
import '../../widgets/rounded_button_widget.dart';
import '../../widgets/rounded_icon_button_widget.dart';
import '../my_home.dart';

class CartModel {
  String providerId;
  String providerName;
  String providerLogo;
  List<CartItem> items;

  CartModel({
    required this.providerId,
    required this.providerName,
    required this.providerLogo,
    required this.items,
  });
}

class DetailCartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailCartScreenState();
}

class _DetailCartScreenState extends State<DetailCartScreen> {
  late CartStore _cartStore;
  late VisitStore _visitStore;
  late List<CartModel> cartModels = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<CartStore>(context);
    _visitStore = Provider.of<VisitStore>(context);
    this.reloadCart();
  }

  void reloadCart() {
    List<CartModel> tmp = [];
    if (_cartStore.list?.length != 0) {
      _cartStore.list?.forEach((item) {
        CartModel? model = tmp.firstWhereOrNull(
            (element) => element.providerName == item.providerName);
        if (model != null) {
          model.items.add(item);
        } else {
          model = CartModel(
            providerId: item.providerId,
            providerName: item.providerName,
            providerLogo: "",
            items: [item],
          );
          tmp.add(model);
        }
        print('current $tmp');
        setState(() {
          cartModels = tmp;
        });
      });
    } else {
      setState(() {
        cartModels = tmp;
      });
    }
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
      appBar: SimpleAppBar(
        title: "My cart",
      ),
      body:
          cartModels.length != 0 ? _buildProductDetailsPage() : _buildNoItem(),
      bottomNavigationBar:
          cartModels.length != 0 ? _buildBottomNavigationBar() : null,
    );
  }

  _buildNoItem() {
    return NoDataScreenWidget(
      height:
          MediaQuery.of(context).size.height - AppDimens.primaryAppBarHeight,
      width: MediaQuery.of(context).size.width,
      contentText: "No item!",
      actionButtonText: "Explore products now!",
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHome(
                      tabIndex: 3,
                    )),
            (route) => false);
      },
    );
  }

  _buildProductDetailsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      Assets.checkedIcon,
                      height: 22,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    MyLabelWidget(
                        text: "All (" +
                            (_cartStore.list?.length.toString() ?? "") +
                            " items)",
                        style: AppStyles.textStyle16Regular400.merge(TextStyle(
                            height: 1.1, color: AppColors.textGreyColor)))
                  ],
                ),
                InkWell(
                  child: MyLabelWidget(
                      text: "Remove all",
                      style: AppStyles.textStyle16Medium.merge(TextStyle(
                          height: 1.1, color: AppColors.redLightColor))),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ConfirmDialogWidget(
                              titleText: "Confirmation",
                              contentText:
                                  "Are you sure you want to remove ALL ITEMS from your cart?",
                              confirmText: "Yes",
                              cancelText: "No",
                              onConfirmed: () {
                                _cartStore.emptyCart();
                                this.reloadCart();
                              },
                            ));
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              children: List.from(cartModels.map((e) => _buildCartModel(e))),
            ),
          ),
        ],
      ),
    );
  }

  _buildCartModel(CartModel cartModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 42),
          height: 40,
          color: AppColors.bgGreyColor,
          child: Row(
            children: [
              Image.asset(Assets.houseItem),
              SizedBox(
                width: 5,
              ),
              MyLabelWidget(
                  text: cartModel.providerName,
                  style: AppStyles.textStyle16Medium)
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: List.from(cartModel.items.mapIndexed((index, e) =>
              _buildCartModelItem(e, index + 1 == cartModel.items.length))),
        )
      ],
    );
  }

  _buildCartModelItem(CartItem cartItem, bool isLast) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                Assets.checkedIcon,
                height: 22,
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: 92.0,
                width: 76.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        Endpoints.getDownloadUrl(cartItem.image),
                      )),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 102,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 153,
                      child: MyLabelWidget(
                        text: cartItem.name,
                        style: AppStyles.textStyle16Regular400,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 10),
                    MyLabelWidget(
                        text: CurrencyFormat.usd(cartItem.price.toString()),
                        style: AppStyles.textStyle18RegularBold.merge(TextStyle(
                            height: 1.1, color: AppColors.redLightColor))),
                    Expanded(
                      child: SizedBox(),
                      flex: 1,
                    ),
                    MyLabelWidget(
                        text: cartItem.attrs,
                        style: AppStyles.textStyle14Regular.merge(TextStyle(
                            height: 1.1, color: AppColors.greyPrice))),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedIconButton(
                      icon: Icons.remove,
                      iconSize: 25,
                      onPress: () {
                        if (cartItem.qty == 1) {
                          showDialog(
                              context: context,
                              builder: (_) => ConfirmDialogWidget(
                                    titleText: "Confirmation",
                                    contentText:
                                        "Are you sure you want to remove this item from your cart?",
                                    confirmText: "Yes",
                                    cancelText: "No",
                                    onConfirmed: () {
                                      _cartStore.updateCart(cartItem.id, -1);
                                      this.reloadCart();
                                    },
                                  ));
                        } else {
                          _cartStore.updateCart(cartItem.id, -1);
                          this.reloadCart();
                        }
                      },
                    ),
                    Container(
                      width: 25,
                      child: Text(
                        cartItem.qty.toString(),
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
                        _cartStore.updateCart(cartItem.id, 1);
                        this.reloadCart();
                      },
                    ),
                  ],
                ),
                InkWell(
                  child: MyLabelWidget(
                      text: "Remove",
                      style: AppStyles.textStyle16Medium.merge(TextStyle(
                          height: 1.1, color: AppColors.redLightColor))),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ConfirmDialogWidget(
                          titleText: "Confirmation",
                          contentText:
                          "Are you sure you want to remove this item from your cart?",
                          confirmText: "Yes",
                          cancelText: "No",
                          onConfirmed: () {
                            _cartStore.updateCart(
                                cartItem.id, -cartItem.qty);
                            this.reloadCart();
                          },
                        ));
                  },
                )
              ],
            ),
          ),
          isLast
              ? SizedBox()
              : Divider(thickness: 1.0, color: AppColors.lineGreyColor),
        ],
      ),
    );
  }

  _getTotalPrice() {
    return _cartStore.list?.length != 0
        ? _cartStore.list
            ?.map((element) => element.qty * element.price)
            .reduce((value, element) => value + element)
        : 0;
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Platform.isIOS ? 80.0 : 70.0,
      padding: EdgeInsets.only(left: 30, right: 20, top: 10, bottom: Platform.isIOS ? 10 : 0),
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey, blurRadius: 5.0, offset: Offset(0.0, 0.75))
      ], color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyLabelWidget(
                  text: "Total", style: AppStyles.textStyle16Regular400),
              SizedBox(
                height: 5,
              ),
              MyLabelWidget(
                  text: CurrencyFormat.usd(_getTotalPrice().toString()),
                  style: AppStyles.textStyle18Medium.merge(
                      TextStyle(height: 1.1, color: AppColors.redLightColor))),
            ],
          ),
          Column(
            children: [
              RoundedButtonWidget(
                buttonWidth: (MediaQuery.of(context).size.width - 70) / 2,
                buttonHeight: 48,
                buttonText: 'Place order(' +
                    (_cartStore.list?.length.toString() ?? "") +
                    ')',
                linearGradient: LinearGradient(
                    colors: [AppColors.redLightColor, AppColors.redLightColor]),
                onPressed: () {
                  if (_visitStore.checkedIn) {
                    NavigationService.push(
                        context,
                        ShipInfoScreen2(
                          cartModels: cartModels,
                        ));
                  } else {
                    CommonDialogWidget.confirmDialog(
                      context,
                      "Warning!",
                      "You must perform a Check-In at a store before placing an order.",
                      "Check-In",
                      "Later",
                      () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MyHome(
                                  tabIndex: 1,
                                )));
                      },
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
