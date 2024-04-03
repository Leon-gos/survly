import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final List<Survey> mySurveyList;

  const SurveyListState({required this.surveyList, required this.mySurveyList});

  factory SurveyListState.ds() => const SurveyListState(surveyList: [], mySurveyList: []);

  SurveyListState copyWith({
    List<Survey>? surveyList,
    List<Survey>? mySurveyList,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      mySurveyList: mySurveyList ?? this.mySurveyList,
    );
  }

  @override
  List<Object?> get props => [surveyList, mySurveyList];
}
