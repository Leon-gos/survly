import 'package:flutter/material.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class RequestCard extends StatelessWidget {
  final SurveyRequest request;

  const RequestCard({super.key, required this.request});

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
      return const Icon(
        Icons.check_circle_outline_outlined,
        color: AppColors.primary,
      );
    }
    if (request.status == SurveyRequestStatus.denied.value) {
      return const Icon(
        Icons.disabled_by_default_outlined,
        color: AppColors.negative,
      );
    }
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.more_vert),
    );
  }
}
