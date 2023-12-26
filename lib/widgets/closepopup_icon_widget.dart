import 'package:flutter/material.dart';
import '../constants/assets.dart';

class ClosePopupIconWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ClosePopupIconWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.asset(Assets.xIcon, width: 27, height: 27,),
      onTap: onTap
    );
  }
}
