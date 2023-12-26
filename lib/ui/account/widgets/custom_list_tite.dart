import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.bgGreyColor)),
        ),
        child: InkWell(
            splashColor: Colors.orangeAccent,
            onTap: onTap,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          color: AppColors.bgGreyColor,
                          shape: BoxShape.circle,
                        ),
                        child: icon,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      Text(
                        text,
                        style: AppStyles.textStyle16Regular400,
                      ),
                    ],
                  ),
                  Image.asset(
                    Assets.greaterIcon,
                    width: 15,
                  )
                ],
              ),
            ),
        ),
      ),
    );
  }
}
