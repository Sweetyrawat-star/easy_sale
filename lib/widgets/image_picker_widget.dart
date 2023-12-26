import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class ImagePickerWidget extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback onTap;

  const ImagePickerWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: this.height,
        width: this.width,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyBorder),
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Center(
          child: Image.asset(Assets.photoIcon, height: 32, width: 35,),
        ),
      ),
      onTap: onTap,
    );
  }
}
