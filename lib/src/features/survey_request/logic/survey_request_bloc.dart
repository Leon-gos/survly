import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/notification/noti_request_body.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/src/service/notification_service.dart';

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
      NotificationService.sendNotiToUserById(
        requestBody: NotiRequestBody(
          notification: Notification(
            title: S.text.notiTitleResponseUserRequest(status.value),
            body: S.text.notiBodyResponseUserRequest(
              status.value,
              state.survey.title,
            ),
          ),
          data: {
            NotiDataField.type: NotiType.adminResponseUserRequest.value,
            NotiDataField.data: {
              NotiDataDataKey.surveyId: state.survey.surveyId,
            },
          },
        ),
        userId: request.userId,
      );

      Fluttertoast.showToast(msg: S.text.toastResponseSurveySuccess);
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.toastResponseSurveyFail);
      Logger().e("Something went wrong", error: e);
    }
    emit(state.copyWith(isLoading: false));
  }
}
