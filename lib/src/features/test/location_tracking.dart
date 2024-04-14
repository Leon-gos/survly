import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

class LocationTracking extends StatefulWidget {
  LocationTracking({super.key});

  DoSurvey doSurvey = DoSurvey(
    doSurveyId: "Ermd203XOKlrg1A1QdWu",
    status: "doing",
    currentLat: 13.933145,
    currentLng: -85.70168,
  );

  @override
  State<StatefulWidget> createState() => LocationTrackingState();
}

class LocationTrackingState extends State<LocationTracking> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot;

  late LatLng latLng;

  @override
  void initState() {
    super.initState();
    latLng = LatLng(
        widget.doSurvey.currentLat ?? 0, widget.doSurvey.currentLng ?? 0);
    snapshot = DoSurveyRepositoryImpl().getDoSurveySnapshot(widget.doSurvey);
    snapshot.listen((event) {
      setState(() {
        latLng = LatLng(event.data()?[DoSurveyCollection.fieldCurrentLat],
            event.data()?[DoSurveyCollection.fieldCurrentLng]);
        Logger().d("(${latLng.latitude} , ${latLng.longitude})");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latLng.latitude, latLng.longitude),
        ),
        markers: {
          Marker(markerId: const MarkerId("currentLocation"), position: latLng),
        },
      ),
    );
  }
}
