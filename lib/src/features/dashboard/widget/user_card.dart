import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class UserCard extends StatelessWidget {
  final User user;
  final Function()? onPressed;

  const UserCard({
    super.key,
    required this.user,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatarWidget(
                  avatarUrl: user.avatar,
                  size: 48,
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(user.email),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${user.balance / 1000}${S.of(context).thousand}",
                    style: const TextStyle(color: AppColors.white),
                  ),
                )
              ],
            ),
            const Divider(
              height: 32,
            ),
            Row(
              children: [
                Text("Joined on "),
                Text("11/04/2024"),
              ],
            ),
            Row(
              children: [
                Text("Live in "),
                Text("Bình Dương"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
