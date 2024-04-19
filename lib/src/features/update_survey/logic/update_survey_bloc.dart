import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/update_survey/logic/update_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/service/picker_service.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateSurveyBloc extends Cubit<UpdateSurveyState> {
  UpdateSurveyBloc(Survey survey)
      : super(UpdateSurveyState.ds(survey: survey)) {
    fetchSurveyDetail();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> onPickImage() async {
    var imagePath = await PickerService.pickImageFromGallery();
    emit(state.copyWith(
      imageLocalPath: imagePath?.path,
      isChanged: true,
    ));
  }

  void onDateRangeChange(PickerDateRange dateRange) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          dateStart: DateHelper.getDateOnly(dateRange.startDate!),
          dateEnd: DateHelper.getDateOnly(dateRange.endDate!),
        ),
        isChanged: true,
      ),
    );
  }

  void onTitleChange(String newText) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(title: newText),
        isChanged: true,
      ),
    );
  }

  void onDescriptionChange(String newText) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(description: newText),
        isChanged: true,
      ),
    );
  }

  void onRespondentNumberChange(String newText) {
    try {
      emit(
        state.copyWith(
          survey: state.survey.copyWith(respondentMax: int.parse(newText)),
          isChanged: true,
        ),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onCostChange(String newText) {
    try {
      emit(
        state.copyWith(
          survey: state.survey.copyWith(cost: int.parse(newText)),
          isChanged: true,
        ),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onQuestionListItemChange(Question oldQuestion, Question newQuestion) {
    var list = List.of(state.questionList);
    list[list.indexOf(oldQuestion)] = newQuestion;
    emit(state.copyWith(
      questionList: list,
      isChanged: true,
    ));
  }

  Future<void> saveSurvey() async {
    emit(state.copyWith(isLoading: true));
    try {
      await domainManager.survey.updateSurvey(
        survey: state.survey,
        fileLocalPath: state.imageLocalPath,
        questionList: state.questionList,
      );
      Fluttertoast.showToast(msg: S.text.toastUpdateSurveySuccess);
      popScreen();
    } catch (e) {
      Logger().e(e);
    }
    emit(state.copyWith(isLoading: false));
  }

  void addQuestion(QuestionType questionType) {
    List<Question> list = List.of(state.questionList);
    if (questionType == QuestionType.text) {
      list.add(
        Question(
            questionIndex: list.length + 1,
            questionType: questionType.value,
            question: "${S.text.questionSampleText} ${list.length + 1}"),
      );
    } else {
      var question = QuestionWithOption.sample(
        questionIndex: list.length + 1,
        questionType: questionType.value,
        question: "${S.text.questionSampleText} ${list.length + 1}",
        optionList: [],
      );
      list.add(question);
    }
    emit(state.copyWith(
      questionList: list,
      isChanged: true,
    ));
  }

  void removeQuestion(Question question) {
    var list = List.of(state.questionList);
    list.remove(question);
    for (int i = 0; i < list.length; i++) {
      list[i].questionIndex = i + 1;
    }
    emit(state.copyWith(
      questionList: list,
      isChanged: true,
    ));
  }

  void onOutletLocationChange(Outlet? outlet) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(outlet: outlet),
        isChanged: true,
      ),
    );
  }

  Future<void> fetchSurveyDetail() async {
    emit(
      state.copyWith(
        questionList: await domainManager.question
            .fetchAllQuestionOfSurvey(state.survey.surveyId),
      ),
    );
  }

  void popScreen() {
    AppCoordinator.pop(state.isChanged);
  }
}
