import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';

class DoSurveyTrackingState extends Equatable {
  final DoSurvey? doSurvey;
  final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? snapshotSub;
  final GoogleMapController? mapController;

  const DoSurveyTrackingState({
    required this.doSurvey,
    required this.snapshotSub,
    required this.mapController,
  });

  factory DoSurveyTrackingState.ds() => const DoSurveyTrackingState(
        doSurvey: null,
        snapshotSub: null,
        mapController: null,
      );

  @override
  List<Object?> get props => [doSurvey, mapController, snapshotSub];

  DoSurveyTrackingState copyWith({
    DoSurvey? doSurvey,
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? snapshotSub,
    GoogleMapController? mapController,
  }) {
    return DoSurveyTrackingState(
      doSurvey: doSurvey ?? this.doSurvey,
      snapshotSub: snapshotSub ?? this.snapshotSub,
      mapController: mapController ?? this.mapController,
    );
  }
}
