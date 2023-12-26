import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  final image;
  final height;
  final width;

  const AppIconWidget({
    Key? key,
    this.image,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: height,
      width: width,
    );
  }
}
