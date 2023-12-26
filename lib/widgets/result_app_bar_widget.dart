import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/assets.dart';

class ResultAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.0,
      decoration: BoxDecoration(
        color: AppColors.green[200],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.green[200]!,
              AppColors.green[200]!.withOpacity(0),
            ],
          )
      ),
      child: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Image.asset(Assets.successIcon, height: 70,),
            SizedBox(height: 20,),
            MyLabelWidget(text: "Successful", style: AppStyles.textStyle20RegularBold.merge(TextStyle(color: Colors.green)))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(300.0);
}
