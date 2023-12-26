import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final double buttonWidth;
  final double buttonHeight;
  final VoidCallback onPressed;
  final LinearGradient? linearGradient;

  const RoundedButtonWidget({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.buttonWidth = 191.0,
    this.buttonHeight = 48.0,
    this.linearGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
          gradient: linearGradient ?? LinearGradient(colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor]),
          borderRadius: BorderRadius.circular(30.0)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: Text(buttonText, style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
      ),
    );
  }
}
