import 'package:flutter/material.dart';

class BottomNavbarItemIconWidget extends StatelessWidget {
  final image;

  const BottomNavbarItemIconWidget({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: 26,
    );
  }
}
