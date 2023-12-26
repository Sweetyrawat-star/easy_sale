import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class CircleLogoWidget extends StatelessWidget {
  final double height;
  final double width;

  const CircleLogoWidget({
    Key? key,
    this.height = 50,
    this.width = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: new BoxDecoration(
            color: AppColors.bgGreyColor,
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
          child: AppIconWidget(image: Assets.appLogo, height: 60.0,),
          top: 25,
          left: 25,
        )
      ],
    );
  }
}
