import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import 'cart_icon_widget.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 100.0,
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
            Expanded(
              flex: 2,
              child: Container(
                child: MyLabelWidget(
                  text: "MCP",
                  style: AppStyles.textStyle24Medium,
                ),
              ),
            ),
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
  Size get preferredSize => Size.fromHeight(100.0);
}
