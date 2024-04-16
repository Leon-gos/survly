import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';

class DoSurveyState extends Equatable {
  static const Duration updateDuration = Duration(seconds: 1);

  final DoSurvey doSurvey;
  final Location location;

  const DoSurveyState({
    required this.doSurvey,
    required this.location,
  });

  factory DoSurveyState.ds({required DoSurvey doSurvey}) {
    return DoSurveyState(
      doSurvey: doSurvey,
      location: Location(),
    );
  }

  @override
  List<Object?> get props => [doSurvey, location];

  DoSurveyState copyWith({
    DoSurvey? doSurvey,
    Location? location,
  }) {
    return DoSurveyState(
      doSurvey: doSurvey ?? this.doSurvey,
      location: location ?? this.location,
    );
  }
}
