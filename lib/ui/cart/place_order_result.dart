import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../../models/order/order.dart';
import '../../widgets/result_app_bar_widget.dart';
import '../my_home.dart';
import '../order/list_order.dart';

class PlaceOrderResultScreen extends StatelessWidget {
  final List<Order> orders;

  PlaceOrderResultScreen({Key? key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResultAppBar(),
      body: ListOrderScreen(orders: orders,),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: PrimaryButtonWidget(
          buttonText: 'Go to Home',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHome()),
                (route) => false);
          },
        ),
      ),
    );
  }
}
