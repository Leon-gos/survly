import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';

class AppAvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final Border? border;
  final double? size;

  const AppAvatarWidget({
    super.key,
    required this.avatarUrl,
    this.border,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        image: DecorationImage(
          image: NetworkImage(avatarUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: border ?? Border.all(
          color: AppColors.primary,
          width: 1.0,
        ),
      ),
    );
  }
}
