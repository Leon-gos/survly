import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class PreviewSurveyBloc extends Cubit<PreviewSurveyState> {
  PreviewSurveyBloc(Survey survey)
      : super(PreviewSurveyState.ds(survey: survey)) {
    fetchLatestRequest();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchLatestRequest() async {
    var request = await domainManager.surveyRequest.fetchLatestRequest(
      surveyId: state.survey.surveyId,
      userId: UserBaseSingleton.instance().userBase!.id,
    );
    emit(state.copyWith(latestRequest: request));
  }

  Future<void> requestSurvey() async {
    try {
      var newRequest = SurveyRequest(
        requestId: "",
        surveyId: state.survey.surveyId,
        userId: UserBaseSingleton.instance().userBase!.id,
        dateRequest: DateTime.now().toString(),
        status: SurveyRequestStatus.pending.value,
        message: state.requestMessage,
      );
      await domainManager.surveyRequest.requestSurvey(newRequest);
      emit(
        state.copyWith(
          latestRequest: newRequest,
          requestMessage: "",
        ),
      );
      Fluttertoast.showToast(msg: "Request successfully");
    } catch (e) {
      Logger().e("Request survey failed", error: e);
      Fluttertoast.showToast(msg: "Request failed");
    }
  }

  void onRequestMessageChange(String text) {
    emit(state.copyWith(requestMessage: text));
  }

  Future<void> cancelRequest() async {
    try {
      await domainManager.surveyRequest
          .cancelRequestSurvey(state.latestRequest!);
      emit(state.removeRequest());
      Fluttertoast.showToast(msg: "Cancel successfully");
    } catch (e) {
      Logger().e("Request survey failed", error: e);
      Fluttertoast.showToast(msg: "Cancel failed");
    }
  }
}
