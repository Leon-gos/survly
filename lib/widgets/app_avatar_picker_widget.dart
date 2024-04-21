import 'package:flutter/material.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class AppAvatarPickerWidget extends StatelessWidget {
  final String avatarUrl;
  final Border? border;
  final double size;
  final String? avatarLocalPath;
  final Function() onPickImage;

  const AppAvatarPickerWidget({
    super.key,
    required this.avatarUrl,
    this.border,
    this.size = 64,
    this.avatarLocalPath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: 128,
        height: 128,
        margin: const EdgeInsets.only(bottom: 32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppAvatarWidget(
              avatarUrl: avatarUrl,
              avatarLocalPath: avatarLocalPath,
              size: 128,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
