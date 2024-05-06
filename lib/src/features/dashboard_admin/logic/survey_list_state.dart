import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';

enum FilterByStatus {
  all,
  public,
  draft;
}

enum SortBy {
  dateCreate,
  title;
}

class SurveyListState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;
  final FilterByStatus filterByStatus;
  final SortBy sortBy;
  final String searchKeyWord;

  const SurveyListState({
    required this.surveyList,
    required this.isLoading,
    required this.searchKeyWord,
    required this.sortBy,
    required this.filterByStatus,
  });

  factory SurveyListState.ds() => const SurveyListState(
        surveyList: [],
        isLoading: true,
        searchKeyWord: "",
        filterByStatus: FilterByStatus.all,
        sortBy: SortBy.dateCreate,
      );

  SurveyStatus? get filterSurveyStatus {
    switch (filterByStatus) {
      case FilterByStatus.draft:
        return SurveyStatus.draft;
      case FilterByStatus.public:
        return SurveyStatus.public;
      default:
        return null;
    }
  }

  SurveyListState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
    String? searchKeyWord,
    FilterByStatus? filterByStatus,
    SortBy? sortBy,
  }) {
    return SurveyListState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
      filterByStatus: filterByStatus ?? this.filterByStatus,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
        surveyList,
        isLoading,
        searchKeyWord,
        filterByStatus,
        sortBy,
      ];
}
