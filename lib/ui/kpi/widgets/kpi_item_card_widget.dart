import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

class KpiItemModel {
  Color bgColor;
  String title;
  String desc;
  String resultValue;
  String totalValue;

  KpiItemModel({
    required this.bgColor,
    required this.title,
    required this.desc,
    required this.resultValue,
    this.totalValue = "",
  });
}

class KpiItemCardWidget extends StatelessWidget {
  final KpiItemModel data;

  const KpiItemCardWidget({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ((MediaQuery.of(context).size.width - 50) / 2) + 10,
      decoration: BoxDecoration(
        color: this.data.bgColor,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 40.0, left: 20, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyLabelWidget(text: this.data.resultValue, style: AppStyles.textStyle24Medium,),
              flex: 2,
            ),
            Row(
              children: [
                MyLabelWidget(text: this.data.title, style: AppStyles.textStyle18Medium),
                // MyLabelWidget(text: "/" + this.data.totalValue.toString(), style: AppStyles.textStyle18Medium.merge(TextStyle(color: AppColors.textGreyColor)))
              ],
            ),
            SizedBox(height: 10,),
            MyLabelWidget(text: this.data.desc, style: AppStyles.textStyle14Regular.merge(TextStyle(height: 1.35)),)
          ],
        ),
      ),
    );
  }
}
