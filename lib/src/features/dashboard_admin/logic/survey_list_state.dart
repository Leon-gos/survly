import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;
  final bool isShowMySurvey;

  const SurveyListState({
    required this.surveyList,
    required this.isLoading,
    required this.isShowMySurvey,
  });

  factory SurveyListState.ds() => const SurveyListState(
        surveyList: [],
        isLoading: true,
        isShowMySurvey: false,
      );

  List<Survey> get surveyFilterList {
    if (isShowMySurvey) {
      List<Survey> mySurveyList = [];
      for (var survey in surveyList) {
        if (survey.adminId == UserBaseSingleton.instance().userBase?.id) {
          mySurveyList.add(survey);
        }
      }
      return mySurveyList;
    }
    return surveyList;
  }

  SurveyListState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
    bool? isShowMySurvey,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
      isShowMySurvey: isShowMySurvey ?? this.isShowMySurvey,
    );
  }

  @override
  List<Object?> get props =>
      [surveyList, surveyFilterList, isLoading, isShowMySurvey];
}
