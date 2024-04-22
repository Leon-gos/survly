import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';

class ResponseButtonWidget extends StatelessWidget {
  const ResponseButtonWidget(
      {super.key,
      required this.labelText,
      required this.onPressed,
      this.themeColor});

  final String labelText;
  final void Function() onPressed;
  final Color? themeColor;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor ?? AppColors.primary,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Text(labelText),
      ),
    );
  }
}
