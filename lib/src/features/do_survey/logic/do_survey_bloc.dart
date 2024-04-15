import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/location_log/location_log_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/location_log/location_log.dart';

class DoSurveyBloc extends Cubit<DoSurveyState> {
  DoSurveyBloc(DoSurvey doSurvey)
      : super(DoSurveyState.ds(doSurvey: doSurvey)) {
    var timer = Timer.periodic(
      DoSurveyState.updateDuration,
      (timer) async {
        var event = await state.location.getLocation();

        var newDs = state.doSurvey.copyWith(
          currentLat: event.latitude,
          currentLng: event.longitude,
        );

        emit(state.copyWith(doSurvey: newDs));

        DoSurveyRepositoryImpl().updateCurrentLocation(newDs);
        try {
          LocationLogRepositoryImpl().addLocationLog(
            LocationLog(
              doSurveyId: newDs.doSurveyId,
              dateCreate: DateTime.now().toString(),
              latitude: event.latitude!,
              longitude: event.longitude!,
            ),
          );
        } catch (e) {
          Logger().e("add location log failed", error: e);
        }
      },
    );
    emit(state.copyWith(timer: timer));
  }

  @override
  Future<void> close() {
    state.timer?.cancel();
    return super.close();
  }
}
