import 'package:flutter/material.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class RequestCard extends StatelessWidget {
  final SurveyRequest request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatarWidget(
          avatarUrl: request.user?.avatar ?? "",
          size: 32,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(request.user?.fullname ?? ""),
            Text(request.user?.email ?? ""),
            Text(request.dateRequest),
            Text(request.status),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }
}
