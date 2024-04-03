import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final Widget? trailing;
  final Function(String newText)? onTextChange;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool? obscureText;
  final String? errorText;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    this.hintText,
    this.trailing,
    this.onTextChange,
    this.textInputAction,
    this.textInputType,
    this.obscureText,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        prefixIconColor: Colors.grey,
      ),
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      onChanged: onTextChange,
      textInputAction: textInputAction ?? TextInputAction.done,
    );
  }
}
