import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_state.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';

class DoSurveyTrackingBloc extends Cubit<DoSurveyTrackingState> {
  DoSurveyTrackingBloc(String doSurveyId) : super(DoSurveyTrackingState.ds()) {
    fetchDoSurvey(doSurveyId);
  }

  Future<void> fetchDoSurvey(String doSurveyId) async {
    var doSurvey = await DoSurveyRepositoryImpl().getDoSurvey(doSurveyId);
    var snapshot = DoSurveyRepositoryImpl().getDoSurveySnapshot(doSurvey);

    snapshot.listen((event) {
      var latLng = LatLng(event.data()?[DoSurveyCollection.fieldCurrentLat],
          event.data()?[DoSurveyCollection.fieldCurrentLng]);

      state.doSurvey?.currentLat = latLng.latitude;
      state.doSurvey?.currentLng = latLng.longitude;
      state.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
      Logger().d("(${latLng.latitude} , ${latLng.longitude})");
    });

    emit(state.copyWith(
      doSurvey: doSurvey,
      snapshot: snapshot,
    ));
  }

  void onMapControllerChange(GoogleMapController controller) {
    emit(state.copyWith(mapController: controller));
  }
}
