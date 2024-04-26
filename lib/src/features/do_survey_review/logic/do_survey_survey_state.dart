import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

enum PageType {
  intro,
  question,
  outlet;
}

class DoSurveyReviewState extends Equatable {
  final Survey? survey;
  final DoSurvey? doSurvey;
  final List<Question> questionList;
  final List<Set<String>> answerList;
  final int currentPage;

  const DoSurveyReviewState({
    required this.survey,
    required this.doSurvey,
    required this.questionList,
    required this.answerList,
    required this.currentPage,
  });

  factory DoSurveyReviewState.ds() {
    return const DoSurveyReviewState(
      survey: null,
      doSurvey: null,
      questionList: [],
      answerList: [],
      currentPage: 0,
    );
  }

  @override
  List<Object?> get props => [
        survey,
        doSurvey,
        questionList,
        answerList,
        currentPage,
      ];

  bool get isResponsed {
    return doSurvey?.status != DoSurveyStatus.submitted.value;
  }

  DoSurveyReviewState copyWith({
    Survey? survey,
    DoSurvey? doSurvey,
    List<Question>? questionList,
    List<Set<String>>? answerList,
    int? currentPage,
  }) {
    return DoSurveyReviewState(
      survey: survey ?? this.survey,
      doSurvey: doSurvey ?? this.doSurvey,
      questionList: questionList ?? this.questionList,
      answerList: answerList ?? this.answerList,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  PageType get getPageType {
    if (currentPage == 0) {
      return PageType.intro;
    } else if (currentPage <= questionList.length) {
      return PageType.question;
    }
    return PageType.outlet;
  }
}
