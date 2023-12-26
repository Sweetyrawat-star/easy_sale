import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/material.dart';

class OrderStatusIconWidget extends StatelessWidget {
  final String status;

  const OrderStatusIconWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.green[500]!;
    var textString = '';
    if (status == 'created') {
      textColor = AppColors.greyPrice;
      textString = "Waiting for Confirmation";
    } else if (['verified'].contains(status)) {
      textColor = Colors.blue;
      textString = "Confirmed";
    } else if (['shipped'].contains(status)) {
      textColor = Colors.orangeAccent;
      textString = "Shipped";
    } else if (status == 'delivered') {
      textString = "Delivery successful";
    } else if (['canceled'].contains(status)) {
      textColor = Colors.redAccent;
      textString = "Canceled";
    } else if (['returned'].contains(status)) {
      textColor = Colors.red;
      textString = "Returned";
    }

    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(color: textColor)
      ),
      child: Text(textString, style: TextStyle(color: textColor),),
    );
  }
}
