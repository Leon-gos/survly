import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';

enum SortBy {
  name(value: "name"),
  dateCreate(value: "dateCreate");

  final String value;

  const SortBy({required this.value});
}

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;
  final bool isShowMySurvey;
  final SortBy sortBy;
  final bool isShowingFilterSheet;

  const SurveyListState({
    required this.surveyList,
    required this.isLoading,
    required this.isShowMySurvey,
    required this.sortBy,
    required this.isShowingFilterSheet,
  });

  factory SurveyListState.ds() => const SurveyListState(
        surveyList: [],
        isLoading: true,
        isShowMySurvey: false,
        sortBy: SortBy.name,
        isShowingFilterSheet: false,
      );

  List<Survey> get surveyFilterList {
    List<Survey> filteredList = [];
    if (isShowMySurvey) {
      for (var survey in surveyList) {
        if (survey.adminId == UserBaseSingleton.instance().userBase?.id) {
          filteredList.add(survey);
        }
      }
    } else {
      filteredList.addAll(surveyList);
    }
    if (sortBy == SortBy.name) {
      filteredList.sort((s1, s2) {
        return s1.title.compareTo(s2.title);
      });
    } else if (sortBy == SortBy.dateCreate) {
      filteredList.sort((s1, s2) {
        return s1.dateCreate.compareTo(s2.dateCreate);
      });
    }
    return filteredList;
  }

  SurveyListState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
    bool? isShowMySurvey,
    SortBy? sortBy,
    bool? isShowingFilterSheet,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
      isShowMySurvey: isShowMySurvey ?? this.isShowMySurvey,
      sortBy: sortBy ?? this.sortBy,
      isShowingFilterSheet: isShowingFilterSheet ?? this.isShowingFilterSheet,
    );
  }

  @override
  List<Object?> get props => [
        surveyList,
        surveyFilterList,
        isLoading,
        isShowMySurvey,
        sortBy,
        isShowingFilterSheet,
      ];
}
