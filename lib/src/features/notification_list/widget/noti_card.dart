import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:survly/src/network/model/notification/notification.dart'
    as my_noti;
import 'package:survly/src/theme/colors.dart';

class NotiCard extends StatelessWidget {
  const NotiCard({
    super.key,
    required this.notification,
    this.onNotiTap,
  });

  final my_noti.Notification notification;
  final void Function()? onNotiTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNotiTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        color: notification.isRead ? null : AppColors.backgroundNotiCard,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? null : FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    notification.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            notification.isRead
                ? const Icon(
                    Icons.check_circle_outline_outlined,
                    color: Colors.grey,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
