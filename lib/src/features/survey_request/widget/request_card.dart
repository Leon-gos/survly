import 'package:flutter/material.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class RequestCard extends StatelessWidget {
  final SurveyRequest request;
  final Function()? onAccept;
  final Function()? onDeny;

  const RequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                avatarUrl: request.user?.avatar ?? "",
                size: 48,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.user?.fullname ?? "Leon",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(request.user?.email ?? "aaa@gmail.com"),
                  // Text(request.dateRequest),
                  // Text(request.status),
                ],
              ),
              const Spacer(),
              _buildStatusIcon(),
            ],
          ),
          const Divider(
            height: 32,
          ),
          Row(
            children: [
              const Text("Request on "),
              Text(request.dateRequest),
            ],
          ),
          if (request.message != "") ...[
            const Text("Message: "),
            Text(
              request.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (request.status == SurveyRequestStatus.accepted.value) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(
          Icons.check_box_outlined,
          color: AppColors.primary,
        ),
      );
    }
    if (request.status == SurveyRequestStatus.denied.value) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(
          Icons.disabled_by_default_outlined,
          color: AppColors.negative,
        ),
      );
    }
    if (onAccept != null && onDeny != null) {
      return PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.white,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: onAccept,
              child: const ListTile(
                title: Text("Accept"),
                leading: Icon(Icons.check_box_outlined),
              ),
            ),
            PopupMenuItem(
              onTap: onDeny,
              child: const ListTile(
                title: Text("Deny"),
                leading: Icon(Icons.disabled_by_default_outlined),
              ),
            ),
          ];
        },
      );
    }
    return const SizedBox();
  }
}
