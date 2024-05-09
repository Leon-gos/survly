import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/notification_list/logic/notification_list_bloc.dart';
import 'package:survly/src/features/notification_list/logic/notification_list_state.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationListBloc(),
      child: BlocBuilder<NotificationListBloc, NotificationListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              backgroundColor: AppColors.backgroundBrightness,
              title: "Your notification",
              titleColor: AppColors.black,
              leadingColor: AppColors.black,
            ),
          );
        },
      ),
    );
  }
}
