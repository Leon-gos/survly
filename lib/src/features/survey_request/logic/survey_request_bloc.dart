import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/notification/noti_request.dart';
import 'package:survly/src/service/notification/model/noti_request_body.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/src/service/notification/service/notification_service.dart';

class SurveyRequestBloc extends Cubit<SurveyRequestState> {
  SurveyRequestBloc(Survey survey) : super(SurveyRequestState.ds(survey)) {
    fetchRequestList(survey.surveyId);
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchRequestList(String? surveyId) async {
    if (surveyId == null) {
      return;
    }
    var list = await domainManager.surveyRequest.fetchRequestOfSurvey(surveyId);
    emit(state.copyWith(surveyRequestList: list));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> reponseRequest(
    SurveyRequest request,
    SurveyRequestStatus status,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await domainManager.surveyRequest.responseSurveyRequest(
        requestId: request.requestId,
        status: status,
      );

      if (status == SurveyRequestStatus.accepted) {
        await domainManager.doSurvey.createDoSurvey(DoSurvey.init(
          surveyId: state.survey.surveyId,
          userId: request.userId,
        ));
      }

      // refresh request list
      List<SurveyRequest> newList = List.of(state.surveyRequestList);
      newList[state.surveyRequestList.indexOf(request)] =
          request.copyWith(status: status.value);
      emit(state.copyWith(surveyRequestList: newList));

      // send noti
      sendNoti(request, status);

      Fluttertoast.showToast(msg: S.text.toastResponseSurveySuccess);
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.toastResponseSurveyFail);
      Logger().e("Something went wrong", error: e);
    }
    emit(state.copyWith(isLoading: false));
  }

  void sendNoti(
    SurveyRequest request,
    SurveyRequestStatus status,
  ) {
    String notiTitle = S.text.notiTitleResponseUserRequest(status.value);
    String notiBody = S.text.notiBodyResponseUserRequest(
      status.value,
      state.survey.title,
    );
    String notiType = NotiType.adminResponseUserRequest.value;
    String requestId = request.requestId;
    String fromUserId = UserBaseSingleton.instance().userBase!.id;
    String toUserId = request.userId;

    NotificationService.sendNotiToUserById(
      requestBody: NotiRequestBody(
        notification: Notification(
          title: notiTitle,
          body: notiBody,
        ),
        data: {
          NotiDataField.type: notiType,
          NotiDataField.data: {
            NotiDataDataKey.surveyId: state.survey.surveyId,
          },
        },
      ),
      userId: toUserId,
    );

    domainManager.notification.createNoti(NotiRequest.init(
      title: notiTitle,
      body: notiBody,
      type: notiType,
      fromUserId: fromUserId,
      toUserId: toUserId,
      requestId: requestId,
    ));
  }
}
