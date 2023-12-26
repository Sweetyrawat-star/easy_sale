import 'package:boilerplate/stores/cart/cart_store.dart';
import 'package:boilerplate/ui/cart/detail_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../utils/shared/nav_service.dart';

class CartIconWidget extends StatefulWidget {
  const CartIconWidget();
  @override
  State<StatefulWidget> createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget> {
  late CartStore _cartStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<CartStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            height: 32,
            child: Image.asset(Assets.cart),
          ),
          Observer(
            builder: (context) {
              return _cartStore.total != 0 ? Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: AppColors.badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: new Text(
                    _cartStore.total.toString(),
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) : Container(
                width: 15,
                height: 15,
              );
            },
          ),

        ],
      ),
      onTap: () {
        NavigationService.push(context, DetailCartScreen());
      },
    );
  }
}
