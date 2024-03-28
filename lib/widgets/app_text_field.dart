import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {

  final String? hintText;
  final Widget? trailing;
  final Function(String newText)? onTextChange;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    this.hintText,
    this.trailing,
    this.onTextChange,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black)),
        hintText: hintText,
      ),
      onChanged: onTextChange,
      textInputAction: textInputAction ?? TextInputAction.done,
    );
  }
}
