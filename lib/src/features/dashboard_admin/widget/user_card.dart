import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Row(
        children: [
          AppAvatarWidget(
            avatarUrl: user.avatar,
            size: 48,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
    );
  }
}
