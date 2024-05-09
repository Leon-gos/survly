import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/notification_list/logic/notification_list_bloc.dart';
import 'package:survly/src/features/notification_list/logic/notification_list_state.dart';
import 'package:survly/src/features/notification_list/widget/noti_card.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

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
            body: state.isLoading ? const AppLoadingCircle() : _buildNotiList(),
          );
        },
      ),
    );
  }

  Widget _buildNotiList() {
    return BlocBuilder<NotificationListBloc, NotificationListState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.notiList.length,
          itemBuilder: (BuildContext context, int index) {
            var noti = state.notiList[index];
            return NotiCard(notification: noti);
          },
        );
      },
    );
  }
}
