import 'package:survly/src/network/model/notification/noti_request.dart';

abstract class NotiRequestRepository {
  Future<void> createNotiRequest(NotiRequest notiRequest);
  Future<NotiRequest?> fetchNotiRequestById(String notiRequestId);
  Future<NotiRequest?> fetchNotiRequestByNotiId(String notiId);
}
