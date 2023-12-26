import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import 'custom_search_input_widget.dart';

class SearchHeaderWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback onPlus;
  final ValueChanged<String> onSearch;
  final int totalSelectedShop;

  const SearchHeaderWidget({
    Key? key,
    required this.hintText,
    required this.onPlus,
    required this.onSearch,
    this.totalSelectedShop = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: AppColors.green[200],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.green[200]!.withOpacity(0.3),
              AppColors.green[200]!.withOpacity(0.2),
            ],
          )
      ),
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: CustomSearchInputWidget(
                hintText: hintText,
                onChanged: onSearch,
              ),
            ),
            SizedBox(width: 10,),
            Container(
              height: 40.0,
              width: totalSelectedShop > 0 ? 180.0 : 60.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.green[400]!, AppColors.green[200]!]),
                  borderRadius: BorderRadius.circular(20.0)),
              child: ElevatedButton(
                onPressed: onPlus,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                child: totalSelectedShop > 0 ? MyLabelWidget(text: "Create routing($totalSelectedShop)", style: AppStyles.textStyle16Regular400.merge(TextStyle(color: Colors.white))) : Image.asset(Assets.plusIcon, height: 22.0, width: 22.0,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
