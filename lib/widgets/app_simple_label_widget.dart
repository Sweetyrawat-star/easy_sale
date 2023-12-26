import 'package:boilerplate/constants/styles.dart';
import 'package:flutter/material.dart';

class AppSimpleLabelWidget extends StatelessWidget {
  final String text;

  const AppSimpleLabelWidget(this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: text,
            style: AppStyles.textStyle16Regular400.merge(TextStyle(height: 1.875))
        ));
  }
}
