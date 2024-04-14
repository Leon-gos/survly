import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_bloc.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_state.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DoSurveyTrackingScreen extends StatefulWidget {
  const DoSurveyTrackingScreen({super.key});

  @override
  State<StatefulWidget> createState() => DoSurveyTrackingScreenState();
}

class DoSurveyTrackingScreenState extends State<DoSurveyTrackingScreen> {
  // late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot;
  // GoogleMapController? mapController;
  // DoSurvey? doSurvey;
  double zoomRatio = 15;

  // Future<void> getDoSurvey() async {
  //   // doSurvey =
  //   //     await DoSurveyRepositoryImpl().getDoSurvey("Ermd203XOKlrg1A1QdWu");
  //   snapshot = DoSurveyRepositoryImpl().getDoSurveySnapshot(doSurvey!);
  //   snapshot.listen((event) {
  //     setState(() {
  //       var latLng = LatLng(event.data()?[DoSurveyCollection.fieldCurrentLat],
  //           event.data()?[DoSurveyCollection.fieldCurrentLng]);

  //       doSurvey?.currentLat = latLng.latitude;
  //       doSurvey?.currentLng = latLng.longitude;
  //       mapController?.animateCamera(
  //         CameraUpdate.newLatLngZoom(latLng, zoomRatio),
  //       );
  //       Logger().d("(${latLng.latitude} , ${latLng.longitude})");
  //     });
  //   });
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // getDoSurvey();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoSurveyTrackingBloc("Ermd203XOKlrg1A1QdWu"),
      child: BlocBuilder<DoSurveyTrackingBloc, DoSurveyTrackingState>(
        builder: (context, state) {
          if (state.doSurvey == null) {
            return const AppLoadingCircle();
          }
          var latLng = LatLng(
              state.doSurvey!.currentLat ?? 0, state.doSurvey!.currentLng ?? 0);
          return Scaffold(
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLng,
                zoom: zoomRatio,
              ),
              onMapCreated: (controller) {
                context
                    .read<DoSurveyTrackingBloc>()
                    .onMapControllerChange(controller);
                // mapController = controller;
                // controller.animateCamera(
                //   CameraUpdate.newLatLngZoom(latLng, zoomRatio),
                // );
              },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: latLng,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
