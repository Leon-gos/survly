import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  State<StatefulWidget> createState() => UserLocationScreenState();
}

class UserLocationScreenState extends State<UserLocationScreen> {
  late DoSurvey doSurvey;
  Location location = Location();

  late Timer timer;
  late StreamSubscription<LocationData> locationSub;

  @override
  void initState() {
    super.initState();
    doSurvey = DoSurvey(doSurveyId: "Ermd203XOKlrg1A1QdWu", status: "doing");
    // locationSub = location.onLocationChanged.listen((event) {
    //   doSurvey.currentLat = event.latitude;
    //   doSurvey.currentLng = event.longitude;
    //   DoSurveyRepositoryImpl().updateCurrentLocation(doSurvey);
    //   setState(() {
    //     doSurvey.currentLat = event.latitude;
    //     doSurvey.currentLng = event.longitude;
    //     // DoSurveyRepositoryImpl().updateCurrentLocation(doSurvey);
    //   });
    // });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        var event = await location.getLocation();
        doSurvey.currentLat = event.latitude;
        doSurvey.currentLng = event.longitude;
        DoSurveyRepositoryImpl().updateCurrentLocation(doSurvey);
        setState(() {
          doSurvey.currentLat = event.latitude;
          doSurvey.currentLng = event.longitude;
        });
        // Logger().d("blahaaaa");
      },
    );

    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   var event = await location.getLocation();
    //   DoSurveyRepositoryImpl().updateCurrentLocation(doSurvey);
    //   setState(() {
    //     doSurvey.currentLat = event.latitude;
    //     doSurvey.currentLng = event.longitude;
    //   });
    // });
  }

  @override
  void dispose() {
    timer.cancel();
    // locationSub.cancel();
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
          // TextButton(
          //   onPressed: () {
          //     Logger().d("blah bla");
          //   },
          //   child: Text("Click me"),
          // )
        ],
      ),
    );
  }
}
