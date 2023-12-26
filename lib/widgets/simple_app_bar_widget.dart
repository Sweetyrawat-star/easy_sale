import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? rightButton;
  final VoidCallback? onBack;

  const SimpleAppBar({
    Key? key,
    String this.title = "",
    this.rightButton,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 123.0,
      padding: EdgeInsets.only(left: 15),
      child: Container(
        padding: EdgeInsets.only(top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              child: Image.asset(Assets.backIcon, height: 30, width: 30,),
              onTap: () {
                if (this.onBack != null) {
                  this.onBack!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(width: 12,),
            Container(
              width: 249.0,
              child: MyLabelWidget(
                text: this.title ?? "",
                style: AppStyles.textStyle24Bold,
              ),
            ),
            Expanded(
              flex: 2,
                child: rightButton ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(123.0);
}
