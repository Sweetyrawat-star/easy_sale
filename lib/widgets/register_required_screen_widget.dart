import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class RegisterRequiredScreenWidget extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback onPressed;

  const RegisterRequiredScreenWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Container(
        margin: EdgeInsets.only(top: 123.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 76.0,
              width: 76.0,
              child: Image.asset(Assets.mcpUser),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 31, 20, 0),
              child: Text(
                "You need to register for the job first",
                style: TextStyle(fontSize: 16, height: 1.6),//line height = height in pixel/font size
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 44),
              child: RoundedButtonWidget(
                buttonText: "Register now",
                onPressed: onPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
