import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';

class DoSurveyTrackingState extends Equatable {
  final DoSurvey? doSurvey;
  final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? snapshotSub;
  final bool isShowUserLocation;

  const DoSurveyTrackingState({
    required this.doSurvey,
    required this.snapshotSub,
    required this.isShowUserLocation,
  });

  factory DoSurveyTrackingState.ds() => const DoSurveyTrackingState(
        doSurvey: null,
        snapshotSub: null,
        isShowUserLocation: true,
      );

  @override
  List<Object?> get props => [
        doSurvey,
        snapshotSub,
        isShowUserLocation,
      ];

  DoSurveyTrackingState copyWith({
    DoSurvey? doSurvey,
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? snapshotSub,
    bool? isShowUserLocation,
  }) {
    return DoSurveyTrackingState(
      doSurvey: doSurvey ?? this.doSurvey,
      snapshotSub: snapshotSub ?? this.snapshotSub,
      isShowUserLocation: isShowUserLocation ?? this.isShowUserLocation,
    );
  }
}
