import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

enum PageType {
  intro,
  question,
  outlet;
}

class ResponseUserSurveyState extends Equatable {
  final Survey survey;
  final DoSurvey? doSurvey;
  final Location location;
  final List<Question> questionList;
  final List<Set<String>> answerList;
  final int currentPage;
  final String outletPath;
  final bool isSaved;

  const ResponseUserSurveyState({
    required this.survey,
    required this.doSurvey,
    required this.location,
    required this.questionList,
    required this.answerList,
    required this.currentPage,
    required this.outletPath,
    required this.isSaved,
  });

  factory ResponseUserSurveyState.ds({
    required Survey survey,
    required DoSurvey doSurvey,
  }) {
    return ResponseUserSurveyState(
      survey: survey,
      doSurvey: doSurvey,
      location: Location(),
      questionList: const [],
      answerList: const [],
      currentPage: 0,
      outletPath: "",
      isSaved: true,
    );
  }

  @override
  List<Object?> get props => [
        survey,
        doSurvey,
        location,
        questionList,
        answerList,
        currentPage,
        outletPath,
        isSaved,
      ];

  bool get isResponsed {
    return doSurvey?.status != DoSurveyStatus.submitted.value;
  }

  ResponseUserSurveyState copyWith({
    Survey? survey,
    DoSurvey? doSurvey,
    Location? location,
    List<Question>? questionList,
    List<Set<String>>? answerList,
    int? currentPage,
    String? outletPath,
    bool? isSaved,
  }) {
    return ResponseUserSurveyState(
      survey: survey ?? this.survey,
      doSurvey: doSurvey ?? this.doSurvey,
      location: location ?? this.location,
      questionList: questionList ?? this.questionList,
      answerList: answerList ?? this.answerList,
      currentPage: currentPage ?? this.currentPage,
      outletPath: outletPath ?? this.outletPath,
      isSaved: isSaved ?? this.isSaved,
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

  int pageNotComplete() {
    for (int i = 0; i < answerList.length; i++) {
      if (answerList[i].isEmpty || answerList[i].first == "") {
        return i + 1;
      }
    }
    if (doSurvey?.photoOutlet == null && outletPath.isEmpty) {
      return questionList.length + 1;
    }
    return -1;
  }
}
