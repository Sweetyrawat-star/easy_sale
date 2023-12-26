import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:flutter/material.dart';

class AppSimpleInputWidget extends StatelessWidget {
  final String text;
  final TextEditingController textController;
  final ValueChanged? onChanged;
  final bool isObscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final double? height;
  final String? initValue;
  final bool? enabled;
  final TextInputType? keyboardType;

  const AppSimpleInputWidget(
    this.text, {
    Key? key,
    required this.textController,
    this.onChanged,
    this.isObscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.height = 48,
    this.initValue,
    this.enabled = true,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(width: 0.0, style: BorderStyle.none)),
            filled: true,
            hintStyle: AppStyles.textStyle16Regular400
                .merge(TextStyle(color: AppColors.greyPrice)),
            hintText: this.text,
            isCollapsed: true,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: this.prefixIcon,
            suffixIcon: this.suffixIcon),
        textAlignVertical: TextAlignVertical.center,
        controller: this.textController,
        onChanged: this.onChanged,
        obscureText: this.isObscure,
        maxLines: maxLines,
        initialValue: initValue,
        enabled: enabled,
        keyboardType: keyboardType,
      ),
    );
  }
}
