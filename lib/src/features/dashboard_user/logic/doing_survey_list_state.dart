import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class DoingSurveyListState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;

  const DoingSurveyListState({
    required this.surveyList,
    required this.isLoading,
  });

  factory DoingSurveyListState.ds() => const DoingSurveyListState(
        surveyList: [],
        isLoading: true,
      );

  DoingSurveyListState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
  }) {
    return DoingSurveyListState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [surveyList, isLoading];
}
