import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  // const AppTextField({super.key});

  final String? hintText;
  final Widget? trailing;

  const AppTextField({
    super.key,
    this.hintText,
    this.trailing,
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
    );
  }
}
