import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard_admin/logic/survey_list_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/utils/debouncer.dart';

class SurveyListBloc extends Cubit<SurveyListState> {
  SurveyListBloc() : super(SurveyListState.ds()) {
    fetchFirstPageSurvey();
  }

  final Debouncer _debounce = Debouncer(milliseconds: 100);

  DomainManager domainManager = DomainManager();

  @override
  Future<void> close() {
    _debounce.dispose();
    return super.close();
  }

  void concatSurveyList(List<Survey> list) {
    List<Survey> newList = List.from(state.surveyList);
    newList.addAll(list);
    emit(state.copyWith(surveyList: newList, isLoading: false));
  }

  Future<void> fetchFirstPageSurvey() async {
    emit(state.copyWith(surveyList: []));
    try {
      var surveyList = await domainManager.survey
          .fetchFirstPageSurvey(searchKeyword: state.searchKeyWord);
      concatSurveyList(surveyList);
    } catch (e) {
      Logger().e("Failed to fetch first page of surveys", error: e);
      emit(
        state.copyWith(isLoading: false),
      );
    }
  }

  Future<void> fetchMoreSurvey() async {
    _debounce.run(() async {
      if (state.surveyList.length - 1 >= 0) {
        try {
          List<Survey> surveyList = await domainManager.survey.fetchMoreSurvey(
            lastSurvey: state.surveyList[state.surveyList.length - 1],
            searchKeyword: state.searchKeyWord,
          );
          Logger().d(surveyList.length);
          concatSurveyList(surveyList);
        } catch (e) {
          Logger().e("Failed to fetch more surveys", error: e);
        }
      }
    });
  }

  void showOnlyMySurvey({bool? isShowMySurvey}) {
    emit(state.copyWith(
      isShowMySurvey: isShowMySurvey ?? !state.isShowMySurvey,
    ));
  }

  void filterBySurveyStatus(FilterByStatus? status) {
    emit(state.copyWith(filterByStatus: status));
  }

  void onSurveyListItemChange(Survey oldSurvey, Survey newSurvey) {
    try {
      List<Survey> newList = List.from(state.surveyList);
      newList[state.surveyList.indexOf(oldSurvey)] = newSurvey;
      emit(state.copyWith(surveyList: newList));
    } catch (e) {
      Logger().e(S.text.errorGeneral, error: e);
    }
  }

  void archiveSurvey(Survey survey) {
    try {
      List<Survey> newList = List.from(state.surveyList);
      newList.removeAt(state.surveyList.indexOf(survey));
      emit(state.copyWith(surveyList: newList));
    } catch (e) {
      Logger().e(S.text.errorGeneral, error: e);
    }
  }

  void onSearchKeywordChange(String text) {
    emit(state.copyWith(searchKeyWord: text));
  }

  void searchSurvey() {
    fetchFirstPageSurvey();
  }
}
