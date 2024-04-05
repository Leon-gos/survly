import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_state.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateSurveyBloc extends Cubit<CreateSurveyState> {
  CreateSurveyBloc() : super(CreateSurveyState.ds());

  DomainManager domainManager = DomainManager();

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
    // var newSurvey = state.survey.copyWith();
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
    emit(
      state.copyWith(
        survey: state.survey.copyWith(respondentMax: int.parse(newText)),
      ),
    );
  }

  void onCostChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(cost: int.parse(newText))),
    );
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
            question: "Question ${list.length + 1}"),
      );
    } else {
      var question = QuestionWithOption(
        questionIndex: list.length + 1,
        questionType: questionType.value,
        question: "Question ${list.length + 1}",
        optionList: [],
      );
      question.addOption();
      question.addOption();
      question.addOption();
      list.add(question);
    }
    emit(state.copyWith(questionList: list));
    Logger().d(
      "Question #${state.questionList[state.questionList.length - 1].questionIndex}}",
    );
  }
}
