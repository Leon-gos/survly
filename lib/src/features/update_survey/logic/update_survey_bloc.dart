import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/update_survey/logic/update_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateSurveyBloc extends Cubit<UpdateSurveyState> {
  UpdateSurveyBloc() : super(UpdateSurveyState.ds()) {
    fetchSurveyDetail();
  }

  get domainManager => DomainManager();

  Future<void> onPickImage() async {
    var imagePath = await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(state.copyWith(imageLocalPath: imagePath?.path));
  }

  void onDateRangeChange(PickerDateRange dateRange) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          dateStart: DateHelper.getDateOnly(dateRange.startDate!),
          dateEnd: DateHelper.getDateOnly(dateRange.endDate!),
        ),
      ),
    );
  }

  void onTitleChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(title: newText)),
    );
  }

  void onDescriptionChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(description: newText)),
    );
  }

  void onRespondentNumberChange(String newText) {
    try {
      emit(
        state.copyWith(
          survey: state.survey.copyWith(respondentMax: int.parse(newText)),
        ),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onCostChange(String newText) {
    try {
      emit(
        state.copyWith(survey: state.survey.copyWith(cost: int.parse(newText))),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onQuestionListItemChange(Question oldQuestion, Question newQuestion) {
    var list = List.of(state.questionList);
    list[list.indexOf(oldQuestion)] = newQuestion;
    emit(state.copyWith(questionList: list));
  }

  Future<void> saveSurvey() async {
    try {
      await domainManager.survey.createSurvey(
        survey: state.survey,
        fileLocalPath: state.imageLocalPath,
        questionList: state.questionList,
      );
      AppCoordinator.pop();
    } catch (e) {
      Logger().e(e);
    }
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
      var question = QuestionWithOption(
        questionIndex: list.length + 1,
        questionType: questionType.value,
        question: "${S.text.questionSampleText} ${list.length + 1}",
        optionList: [],
      );
      list.add(question);
    }
    emit(state.copyWith(questionList: list));
  }

  void removeQuestion(Question question) {
    var list = List.of(state.questionList);
    list.remove(question);
    for (int i = 0; i < list.length; i++) {
      list[i].questionIndex = i + 1;
    }
    emit(state.copyWith(questionList: list));
  }

  void onOutletLocationChange(Outlet? outlet) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(outlet: outlet),
      ),
    );
  }

  void fetchSurveyDetail() {}
}
