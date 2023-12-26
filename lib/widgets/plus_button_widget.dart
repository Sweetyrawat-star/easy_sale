import 'package:flutter/material.dart';
import '../constants/assets.dart';

class PlusButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 60.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF37C086), Color(0xFFC1DE58)]),
          borderRadius: BorderRadius.circular(20.0)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: Image.asset(Assets.plusIcon, height: 22.0, width: 22.0,),
      ),
    );
  }
}
