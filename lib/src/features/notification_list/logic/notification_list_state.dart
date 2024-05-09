import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/notification/notification.dart';

class NotificationListState extends Equatable {
  final List<Notification> notiList;
  final bool isLoading;

  const NotificationListState({
    required this.notiList,
    required this.isLoading,
  });

  factory NotificationListState.ds() {
    return const NotificationListState(
      notiList: [],
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        notiList,
        isLoading,
      ];

  NotificationListState copyWith({
    List<Notification>? notiList,
    bool? isLoading,
  }) {
    return NotificationListState(
      notiList: notiList ?? this.notiList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
