import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

// Test only
// TODO: do later
class DoSurveyScreen extends StatefulWidget {
  const DoSurveyScreen({super.key});

  @override
  State<StatefulWidget> createState() => DoSurveyScreenState();
}

class DoSurveyScreenState extends State<DoSurveyScreen> {
  static const Duration updateDuration = Duration(seconds: 1);
  late DoSurvey doSurvey;
  Location location = Location();

  late Timer timer;
  late StreamSubscription<LocationData> locationSub;

  @override
  void initState() {
    super.initState();
    doSurvey = DoSurvey(
      doSurveyId: "Ermd203XOKlrg1A1QdWu",
      status: DoSurveyStatus.doing.value,
    );

    timer = Timer.periodic(
      updateDuration,
      (timer) async {
        var event = await location.getLocation();
        setState(() {
          doSurvey.currentLat = event.latitude;
          doSurvey.currentLng = event.longitude;
          DoSurveyRepositoryImpl().updateCurrentLocation(doSurvey);
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Lat: ${doSurvey.currentLat}"),
          Text("Long: ${doSurvey.currentLng}"),
        ],
      ),
    );
  }
}
