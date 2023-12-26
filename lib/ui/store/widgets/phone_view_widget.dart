import 'package:boilerplate/utils/shared/text_format.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/my_label_widget.dart';

const IconData call = IconData(0xe126, fontFamily: 'MaterialIcons');

class PhoneViewWidget extends StatelessWidget {
  final String phoneText;

  const PhoneViewWidget({
    Key? key,
    required this.phoneText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(call, size: 24, color: AppColors.disableBgColor,),
          SizedBox(width: 5,),
          Container(
            width: MediaQuery.of(context).size.width - 69,
            child: MyLabelWidget(
                text: PhoneFormat.vn(phoneText),
                style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor, height: 1.43))
            ),
          ),

        ]
    );
  }
}
