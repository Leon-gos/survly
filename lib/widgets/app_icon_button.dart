import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';

class AppIconButton extends StatelessWidget {
  final Function() onPressed;
  final String label;
  final Widget icon;
  final Color? backgroundColor;
  final Color? labelColor;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        backgroundColor: backgroundColor ?? AppColors.secondary,
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: labelColor ?? AppColors.white,
        ),
      ),
    );
  }
}
