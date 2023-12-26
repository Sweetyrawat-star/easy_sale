import 'package:flutter/material.dart';


class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final int maxLength;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: textController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        autofocus: autoFocus,
        textInputAction: inputAction,
        obscureText: this.isObscure,
        maxLength: maxLength,
        keyboardType: this.inputType,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 0.0, style: BorderStyle.none)
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14),
          hintText: hint,
          fillColor: fillColor,
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: '',
          prefixIconConstraints: BoxConstraints(maxHeight: 24, maxWidth: 24)
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  const TextFieldWidget({
    Key? key,
    required this.icon,
    required this.errorText,
    required this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.maxLength = 25,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

}
