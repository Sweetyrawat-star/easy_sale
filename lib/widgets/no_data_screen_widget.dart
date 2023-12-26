import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class NoDataScreenWidget extends StatelessWidget {
  final double height;
  final double width;
  final String? actionButtonText;
  final VoidCallback? onPressed;
  final String? contentText;
  final Image? image;

  const NoDataScreenWidget({
    Key? key,
    required this.height,
    required this.width,
    this.actionButtonText,
    this.onPressed,
    this.contentText,
    this.image,
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
              height: 56.0,
              width: 56.0,
              child: image ?? Image.asset(Assets.noDataIcon),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 31, 20, 0),
              child: Text(
                contentText ?? "No data!",
                style: TextStyle(fontSize: 16, height: 1.6),//line height = height in pixel/font size
                textAlign: TextAlign.center,
              ),
            ),
            actionButtonText != null ? Container(
              padding: EdgeInsets.only(top: 24),
              child: RoundedButtonWidget(
                buttonText: actionButtonText ?? "",
                onPressed: onPressed ?? () {},
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }
}
