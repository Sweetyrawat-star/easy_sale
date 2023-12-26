import 'package:flutter/material.dart';


class CustomSearchInputWidget extends StatelessWidget {
  final String? hintText;
  final Widget? leftIcon;
  final double? height;
  final double? width;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const CustomSearchInputWidget({
    Key? key,
    this.hintText,
    this.leftIcon,
    this.height = 40,
    this.width,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: BorderSide(width: 0.0, style: BorderStyle.none)
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14),
          hintText: this.hintText,
          fillColor: Colors.white70,
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          prefixIcon: this.leftIcon
        ),
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          onTap != null ? onTap!() : onChanged!(value);
        },
        onTap: onTap != null ? onTap : () {},
      ),
    );
  }
}
