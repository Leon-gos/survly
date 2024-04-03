import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final List<Survey> mySurveyList;
  final bool isShowMySurvey;

  const SurveyListState(
      {required this.surveyList,
      required this.mySurveyList,
      required this.isShowMySurvey});

  factory SurveyListState.ds() => const SurveyListState(
        surveyList: [],
        mySurveyList: [],
        isShowMySurvey: false,
      );

  SurveyListState copyWith({
    List<Survey>? surveyList,
    List<Survey>? mySurveyList,
    bool? isShowMySurvey,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      mySurveyList: mySurveyList ?? this.mySurveyList,
      isShowMySurvey: isShowMySurvey ?? this.isShowMySurvey,
    );
  }

  @override
  List<Object?> get props => [surveyList, mySurveyList, isShowMySurvey];
}
