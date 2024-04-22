import 'dart:io';

import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';

class AppAvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final String? avatarLocalPath;
  final Border? border;
  final double size;

  const AppAvatarWidget({
    super.key,
    required this.avatarUrl,
    this.avatarLocalPath,
    this.border,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider image = NetworkImage(avatarUrl);
    if (avatarLocalPath != null && avatarLocalPath != "") {
      image = FileImage(File(avatarLocalPath!));
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        border: border ??
            Border.all(
              color: AppColors.primary,
              width: 1.0,
            ),
      ),
    );
  }
}
