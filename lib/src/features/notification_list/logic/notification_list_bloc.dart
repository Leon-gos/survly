import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/notification_list/logic/notification_list_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/notification/notification.dart';

class NotificationListBloc extends Cubit<NotificationListState> {
  NotificationListBloc() : super(NotificationListState.ds()) {
    fetchNotiList();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchNotiList() async {
    emit(state.copyWith(isLoading: true));
    try {
      var notiList =
          await domainManager.notification.fetchAllNotificationOfUser(
        UserBaseSingleton.instance().userBase!.id,
      );
      Logger().d("noti list length ${notiList.length}");
      emit(state.copyWith(notiList: notiList));
    } catch (e) {
      Logger().e("fetch noti list error", error: e);
      Fluttertoast.showToast(msg: "Cannot get your notification list");
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> readNoti(Notification notification) async {
    try {
      await domainManager.notification.readNoti(notification.notiId);
      List<Notification> newList = List.from(state.notiList);
      emit(state.copyWith(notiList: []));
      newList[newList.indexOf(notification)].isRead = true;
      emit(state.copyWith(notiList: newList));
    } catch (e) {
      Fluttertoast.showToast(msg: "Cannot read noti");
    }
  }
}
