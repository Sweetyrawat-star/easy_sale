import 'package:flutter/material.dart';

class MyLabelWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int? maxLines;

  const MyLabelWidget({
    Key? key,
    required this.text,
    required this.style,
    this.maxLines = -1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.maxLines != -1 ? RichText(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
        overflow: TextOverflow.ellipsis
    ) : RichText(
        text: TextSpan(text: text, style: style),
    );
  }
}
