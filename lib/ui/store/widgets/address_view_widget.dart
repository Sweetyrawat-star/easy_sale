import 'package:flutter/material.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/my_label_widget.dart';

class AddressViewWidget extends StatelessWidget {
  final String addressText;

  const AddressViewWidget({
    Key? key,
    required this.addressText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(Assets.locationIcon, height: 24,),
          SizedBox(width: 5,),
          Container(
            width: MediaQuery.of(context).size.width - 69,
            child: MyLabelWidget(
                text: addressText,
                style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor, height: 1.43))
            ),
          ),

        ]
    );
  }
}
