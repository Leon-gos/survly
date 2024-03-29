import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';

class AppButton extends StatelessWidget {
  final Function() onPressed;
  final String label;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        backgroundColor: AppColors.secondary,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
