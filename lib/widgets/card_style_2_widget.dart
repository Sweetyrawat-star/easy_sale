import 'package:flutter/material.dart';

class CardStyle2Widget extends StatelessWidget {
  final ImageProvider bgImage;
  final VoidCallback onPressed;

  const CardStyle2Widget({
    Key? key,
    required this.bgImage,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127.0,
      width: 374.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: bgImage),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: InkWell(
        onTap: this.onPressed,
      ),
    );
  }
}
