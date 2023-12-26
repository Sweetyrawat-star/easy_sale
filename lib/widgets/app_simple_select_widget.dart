import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class AppSimpleSelectWidget extends StatelessWidget {
  final String text;

  const AppSimpleSelectWidget(this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(width: 0.0, style: BorderStyle.none)
            ),
            filled: true,
            hintStyle: AppStyles.textStyle16Regular400.merge(TextStyle(color: AppColors.greyPrice)),
            hintText: this.text,
            isCollapsed: true,
            contentPadding: EdgeInsets.all(15.0),
            suffixIcon: RotatedBox(
              quarterTurns: 3,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset(Assets.backIcon, height: 22, width: 22,)
              ),
            )
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
