import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> orange = const <int, Color>{
    50: const Color(0xFFFCF2E7),
    100: const Color(0xFFF8DEC3),
    200: const Color(0xFFF3C89C),
    300: const Color(0xFFEEB274),
    400: const Color(0xFFEAA256),
    500: const Color(0xFFE69138),
    600: const Color(0xFFE38932),
    700: const Color(0xFFDF7E2B),
    800: const Color(0xFFDB7424),
    900: const Color(0xFFD56217)
  };

  static const Map<int, Color> green = const <int, Color>{
    50: const Color(0xFFFCF2E7),
    100: const Color(0xFFF8DEC3),
    200: const Color(0xFF39c5f3),
    300: const Color(0xFFEEB274),
    400: const Color(0xFF1c6db2),
    500: const Color(0xFF2ea3db),
    600: const Color(0xFF143A20),
    700: const Color(0xFFDF7E2B),
    800: const Color(0xFFDB7424),
    900: const Color(0xFFD56217)
  };

  static const textColor = Color(0xFF373737);
  static const badgeColor = Color(0xFFEA6940);
  static const bgGreyColor = Color(0xFFF9F9F9);
  static const disableBgColor = Color(0xFFDBDBDB);
  static const redLightColor = Color(0xFFEA6940);
  static const greyPrice = Color(0xFFA3A3A3);
  static const bonusColor1 = Color(0xFFF7774E);
  static const bonusColor2 = Color(0xFFFFA7A7);
  static const quoteBgColor = Color(0xFFF1F6FF);
  static const link = Color(0xFF33B1F9);
  static const greyBorder = Color(0xFFE5E5E5);
  static const bgLightBlue = Color(0xFFE9F4FF);
  static const textGreyColor = Color(0xFF636363);
  static const btnBuyNowColor = Color(0xFF39c5f3);
  static const btnAddToCardColor = Color(0xFFEA6940);
  static const lineGreyColor = Color(0xFFF0F0F0);
  static const checkedInBlockColor = Color(0xFFE6F3FF);
}
