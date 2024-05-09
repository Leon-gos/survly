import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/notification_list/logic/notification_list_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';

class NotificationListBloc extends Cubit<NotificationListState> {
  NotificationListBloc() : super(NotificationListState.ds()) {
    fetchNotiList();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchNotiList() async {
    try {
      var notiList =
          await domainManager.notification.fetchAllNotificationOfUser(
        UserBaseSingleton.instance().userBase!.id,
      );
      Logger().d("noti list length ${notiList.length}");
      emit(state.copyWith(notiList: notiList, isLoading: false));
    } catch (e) {
      Logger().e("fetch noti list error", error: e);
      Fluttertoast.showToast(msg: "Cannot get your notification list");
    }
  }
}
