import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class ExploreSurveyState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;
  final bool isShowMySurvey;

  const ExploreSurveyState({
    required this.surveyList,
    required this.isLoading,
    required this.isShowMySurvey,
  });

  factory ExploreSurveyState.ds() => const ExploreSurveyState(
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

  ExploreSurveyState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
    bool? isShowMySurvey,
  }) {
    return ExploreSurveyState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
      isShowMySurvey: isShowMySurvey ?? this.isShowMySurvey,
    );
  }

  @override
  List<Object?> get props =>
      [surveyList, surveyFilterList, isLoading, isShowMySurvey];
}
