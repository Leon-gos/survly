import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/router/coordinator.dart';

class DoSurveyTrackingBloc extends Cubit<DoSurveyTrackingState> {
  DoSurveyTrackingBloc(
    String? doSurveyId,
    GeoPoint outletPoint,
  ) : super(DoSurveyTrackingState.ds(outletPoint)) {
    if (doSurveyId == null) {
      Fluttertoast.showToast(msg: S.text.errorGeneral);
      AppCoordinator.pop();
      return;
    }
    fetchDoSurvey(doSurveyId);
  }
  GoogleMapController? mapController;

  Future<void> fetchDoSurvey(String doSurveyId) async {
    var doSurvey = await DoSurveyRepositoryImpl().getDoSurvey(doSurveyId);
    var snapshot = DoSurveyRepositoryImpl().getDoSurveySnapshot(doSurvey);
    var snapshotSub = snapshot.listen((event) {
      try {
        var latLng = LatLng(event.data()?[DoSurveyCollection.fieldCurrentLat],
            event.data()?[DoSurveyCollection.fieldCurrentLng]);

        var newDoSurvey = state.doSurvey?.copyWith(
          currentLat: latLng.latitude,
          currentLng: latLng.longitude,
        );

        emit(state.copyWith(doSurvey: newDoSurvey));

        moveCamera();

        Logger().d("(${latLng.latitude} , ${latLng.longitude})");
      } catch (e) {
        Logger().e("lat lng not found", error: e);
        Fluttertoast.showToast(msg: S.text.toastUserNotYetDoSurvey);
        AppCoordinator.pop();
      }
    });

    emit(state.copyWith(
      doSurvey: doSurvey,
      snapshotSub: snapshotSub,
    ));
  }

  void onMapControllerChange(GoogleMapController controller) {
    mapController = controller;
  }

  void isShowUserLocationChanged() {
    emit(
      state.copyWith(isShowUserLocation: !state.isShowUserLocation),
    );
    moveCamera();
  }

  @override
  Future<void> close() {
    state.snapshotSub?.cancel();
    Logger().d("dispose");
    return super.close();
  }

  void moveCamera() {
    if (state.isShowUserLocation &&
        state.doSurvey?.currentLat != null &&
        state.doSurvey?.currentLng != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(
              state.doSurvey!.currentLat!,
              state.doSurvey!.currentLng!,
            ),
            15),
      );
      Logger().d("move to user location");
    } else {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(state.outletLocation, 15),
      );
      Logger().d("move to outlet location");
    }
  }
}
