import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';

class DoSurveyTrackingState extends Equatable {
  final DoSurvey? doSurvey;
  final Stream<DocumentSnapshot<Map<String, dynamic>>>? snapshot;
  final GoogleMapController? mapController;

  const DoSurveyTrackingState({
    required this.doSurvey,
    required this.snapshot,
    required this.mapController,
  });

  factory DoSurveyTrackingState.ds() => const DoSurveyTrackingState(
        doSurvey: null,
        snapshot: null,
        mapController: null,
      );

  @override
  List<Object?> get props => [doSurvey];

  DoSurveyTrackingState copyWith({
    DoSurvey? doSurvey,
    Stream<DocumentSnapshot<Map<String, dynamic>>>? snapshot,
    GoogleMapController? mapController,
  }) {
    return DoSurveyTrackingState(
      doSurvey: doSurvey ?? this.doSurvey,
      snapshot: snapshot ?? this.snapshot,
      mapController: mapController ?? this.mapController,
    );
  }
}
