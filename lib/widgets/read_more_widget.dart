import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../constants/styles.dart';
import 'my_label_widget.dart';

class ReadMoreWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ReadMoreWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          MyLabelWidget(text: "Read more", style: AppStyles.textStyle14Regular,),
          SizedBox(width: 7),
          Image.asset(Assets.greaterIcon, width: 11.0,),
        ],
      ),
      onTap: onPressed,
    );
  }
}
