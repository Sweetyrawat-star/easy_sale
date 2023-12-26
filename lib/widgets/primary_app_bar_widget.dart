import 'dart:io';
import 'package:boilerplate/widgets/cart_icon_widget.dart';
import 'package:boilerplate/widgets/primary_search_input_widget.dart';
import 'package:flutter/material.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';

// ignore: must_be_immutable
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  late double paddingTop = 20.0;
  late double appBarHeight = 100.0;

  PrimaryAppBar({
    Key? key,
    this.onSearchTap
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      paddingTop = 40.0;
      appBarHeight = 120.0;
    }
    return Container(
      padding: EdgeInsets.only(top: paddingTop),
      height: appBarHeight,
      decoration: BoxDecoration(
        color: AppColors.green[200],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.green[200]!,
              AppColors.green[200]!.withOpacity(0.5),
            ],
          )
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(Assets.logoSmall),
            SizedBox(width: 10,),
            Expanded(
              flex: 2,
              child: Container(child: PrimarySearchInputWidget(
                hintText: "What are you looking today?",
                leftIcon: Image.asset(Assets.glass),
              ),),
            ),
            SizedBox(width: 10,),
            Stack(
              children: <Widget>[
                Container(
                  height: 32,
                  child: Image.asset(Assets.bell),
                ),
                Container(
                  width: 15,
                  height: 15,
                )
                // Positioned(
                //   right: 0,
                //   top: 0,
                //   child: new Container(
                //     padding: EdgeInsets.all(1),
                //     decoration: new BoxDecoration(
                //       color: AppColors.badgeColor,
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     constraints: BoxConstraints(
                //       minWidth: 15,
                //       minHeight: 15,
                //     ),
                //     child: new Text(
                //       '10',
                //       style: new TextStyle(
                //         color: Colors.white,
                //         fontSize: 10,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // )
              ],
            ),
            CartIconWidget(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
