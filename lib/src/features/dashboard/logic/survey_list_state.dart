import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final bool isShowMySurvey;

  const SurveyListState({
    required this.surveyList,
    required this.isShowMySurvey,
  });

  factory SurveyListState.ds() => const SurveyListState(
        surveyList: [],
        isShowMySurvey: false,
      );

  List<Survey> get surveyFilterList {
    if (isShowMySurvey) {
      List<Survey> mySurveyList = [];
      for (var survey in surveyList) {
        if (survey.adminId == AdminSingleton.instance().admin?.id) {
          mySurveyList.add(survey);
        }
      }
      return mySurveyList;
    }
    return surveyList;
  }

  SurveyListState copyWith({
    List<Survey>? surveyList,
    bool? isShowMySurvey,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      isShowMySurvey: isShowMySurvey ?? this.isShowMySurvey,
    );
  }

  @override
  List<Object?> get props => [surveyList, surveyFilterList, isShowMySurvey];
}
