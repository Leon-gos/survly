import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';

enum SortBy {
  name(value: "name"),
  dateCreate(value: "dateCreate");

  final String value;

  const SortBy({required this.value});
}

enum FilterByStatus {
  all,
  public,
  draft;
}

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;
  final bool isShowMySurvey;
  final SortBy sortBy;
  final bool isShowingFilterSheet;
  final FilterByStatus filterByStatus;
  final String searchKeyWord;

  const SurveyListState({
    required this.surveyList,
    required this.isLoading,
    required this.isShowMySurvey,
    required this.sortBy,
    required this.isShowingFilterSheet,
    required this.searchKeyWord,
    required this.filterByStatus,
  });

  factory SurveyListState.ds() => const SurveyListState(
        surveyList: [],
        isLoading: true,
        isShowMySurvey: false,
        sortBy: SortBy.dateCreate,
        isShowingFilterSheet: false,
        searchKeyWord: "",
        filterByStatus: FilterByStatus.all,
      );

  List<Survey> get surveyFilterList {
    List<Survey> filteredList = List.from(surveyList);

    if (isShowMySurvey) {
      for (var survey in filteredList) {
        if (survey.adminId != UserBaseSingleton.instance().userBase?.id) {
          filteredList.remove(survey);
        }
      }
    }

    if (filterByStatus == FilterByStatus.public) {
      for (var survey in List.from(filteredList)) {
        if (survey.status != SurveyStatus.public.value) {
          filteredList.remove(survey);
        }
      }
    } else if (filterByStatus == FilterByStatus.draft) {
      for (var survey in List.from(filteredList)) {
        if (survey.status != SurveyStatus.draft.value) {
          filteredList.remove(survey);
        }
      }
    }

    return filteredList;
  }

  SurveyListState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
    bool? isShowMySurvey,
    SortBy? sortBy,
    bool? isShowingFilterSheet,
    String? searchKeyWord,
    FilterByStatus? filterByStatus,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
      isShowMySurvey: isShowMySurvey ?? this.isShowMySurvey,
      sortBy: sortBy ?? this.sortBy,
      isShowingFilterSheet: isShowingFilterSheet ?? this.isShowingFilterSheet,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
      filterByStatus: filterByStatus ?? this.filterByStatus,
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
        searchKeyWord,
        filterByStatus,
      ];
}
