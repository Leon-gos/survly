import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard_user/logic/explore_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/utils/debouncer.dart';

class ExploreSurveyBloc extends Cubit<ExploreSurveyState> {
  ExploreSurveyBloc() : super(ExploreSurveyState.ds()) {
    fetchFirstPageSurvey();
  }

  final Debouncer _debounce = Debouncer(milliseconds: 100);
  double distanceInKm = 300;

  DomainManager domainManager = DomainManager();

  void concatSurveyList(List<Survey> list) {
    List<Survey> newList = List.from(state.surveyList);
    newList.addAll(list);
    emit(state.copyWith(surveyList: newList, isLoading: false));
  }

  Future<void> fetchFirstPageSurvey() async {
    emit(state.copyWith(surveyList: []));
    try {
      List<Survey> surveyList = [];
      if (state.isShowSurveyNearby) {
        surveyList =
            await domainManager.survey.fetchFirstPageExploreSurveyNearBy(
          km: distanceInKm,
          geoPoint: UserBaseSingleton.instance().geoPoint!,
        );
        Logger().d("fetch nearby ${surveyList.length} ");
      } else {
        surveyList = await domainManager.survey.fetchFirstPageExploreSurvey();
        Logger().d("fetch all ${surveyList.length}");
      }
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
          List<Survey> surveyList = [];
          if (state.isShowSurveyNearby) {
            surveyList = surveyList =
                await domainManager.survey.fetchMoreExploreSurveyNearBy(
              km: distanceInKm,
              geoPoint: UserBaseSingleton.instance().geoPoint!,
              lastSurvey: state.surveyList[state.surveyList.length - 1],
            );
            Logger().d("fetch nearby ${surveyList.length}");
          } else {
            surveyList = await domainManager.survey.fetchMoreExploreSurvey(
              lastSurvey: state.surveyList[state.surveyList.length - 1],
            );
            Logger().d("fetch all ${surveyList.length}");
          }
          concatSurveyList(surveyList);
        } catch (e) {
          Logger().e("Failed to fetch more surveys", error: e);
        }
      }
    });
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

  void onSearchKeywordChange(String text) {
    emit(state.copyWith(searchKeyWord: text));
  }

  void onShowingFilterSheetChange(bool value) {
    emit(state.copyWith(isShowingFilterSheet: value));
  }

  void searchSurvey() {
    //TODO: search survey
  }

  void showSurveyNearbyChanged(bool value) {
    emit(state.copyWith(isShowSurveyNearby: value));
    fetchFirstPageSurvey();
  }
}
