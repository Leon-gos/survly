import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_bloc.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_state.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DoSurveyTrackingScreen extends StatefulWidget {
  const DoSurveyTrackingScreen({super.key, this.doSurveyId});

  final String? doSurveyId;

  @override
  State<StatefulWidget> createState() => DoSurveyTrackingScreenState();
}

class DoSurveyTrackingScreenState extends State<DoSurveyTrackingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoSurveyTrackingBloc(widget.doSurveyId), //test only
      child: BlocBuilder<DoSurveyTrackingBloc, DoSurveyTrackingState>(
        buildWhen: (previous, current) => previous.doSurvey != current.doSurvey,
        builder: (context, state) {
          if (state.doSurvey == null) {
            return const AppLoadingCircle();
          }
          var latLng = LatLng(
              state.doSurvey?.currentLat ?? 0, state.doSurvey?.currentLng ?? 0);
          return Scaffold(
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLng,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                context
                    .read<DoSurveyTrackingBloc>()
                    .onMapControllerChange(controller);
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
