import 'package:flutter/material.dart';

import '../constants/colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String buttonText;
  final double buttonWidth;
  final VoidCallback onPressed;

  const PrimaryButtonWidget({
    Key? key,
    required this.buttonText,
    this.buttonWidth = 191,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: buttonWidth,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.green[400]!, AppColors.green[500]!]),
          borderRadius: BorderRadius.circular(5.0)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: Text(buttonText, style: TextStyle(fontSize: 16, color: Colors.white),),
      ),
    );
  }
}
