import 'package:flutter/material.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class ResponseCard extends StatelessWidget {
  final DoSurvey response;

  const ResponseCard({
    super.key,
    required this.response,
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
                avatarUrl: response.user?.avatar ?? "",
                size: 48,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response.user?.fullname ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(response.user?.email ?? ""),
                ],
              ),
              const Spacer(),
              _buildStatusIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (response.status == DoSurveyStatus.approved.value) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(
          Icons.check_box_outlined,
          color: AppColors.primary,
        ),
      );
    }
    if (response.status == DoSurveyStatus.ignored.value) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(
          Icons.disabled_by_default_outlined,
          color: AppColors.negative,
        ),
      );
    }
    return const SizedBox();
  }
}
