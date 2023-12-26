import 'package:boilerplate/widgets/read_more_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/styles.dart';
import 'my_label_widget.dart';

class BlockHeaderWidget extends StatelessWidget {
  final String titleText;
  final Widget leftIcon;
  final VoidCallback? onReadmorePressed;

  const BlockHeaderWidget({
    Key? key,
    required this.titleText,
    required this.leftIcon,
    this.onReadmorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              leftIcon,
              SizedBox(width: 12),
              MyLabelWidget(text: titleText, style: AppStyles.textStyle16Medium)
            ],
          ),
          onReadmorePressed != null ? ReadMoreWidget(onPressed: onReadmorePressed!,) : SizedBox()
        ],
      );
  }
}
