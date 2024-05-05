import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/gen/assets.gen.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_bloc.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DoSurveyTrackingScreen extends StatefulWidget {
  static const String extraDoSurveyId = "extraDoSurveyId";
  static const String extraOutletLocation = "extraOutletLocation";

  const DoSurveyTrackingScreen({
    super.key,
    this.doSurveyId,
    required this.outletLocation,
  });

  final String? doSurveyId;
  final GeoPoint outletLocation;

  @override
  State<StatefulWidget> createState() => DoSurveyTrackingScreenState();
}

class DoSurveyTrackingScreenState extends State<DoSurveyTrackingScreen> {
  Uint8List? markerIcon;

  @override
  void initState() {
    super.initState();
    createMarkerIcon();
  }

  Future<void> createMarkerIcon() async {
    Logger().d(Assets.images.currentLocationIcon.path);
    var markerIcon =
        await getImages(Assets.images.currentLocationIcon.path, 96);
    setState(() {
      this.markerIcon = markerIcon;
    });
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
              state.doSurvey!.currentLat ?? 0, state.doSurvey!.currentLng ?? 0);
          return Scaffold(
              body: Stack(
            children: [
              GoogleMap(
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
                    markerId: const MarkerId("outletLocation"),
                    position: LatLng(
                      widget.outletLocation.latitude,
                      widget.outletLocation.longitude,
                    ),
                    infoWindow: InfoWindow(
                      title: S.of(context).labelOutletLocation,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: latLng,
                    infoWindow: InfoWindow(
                      title: S.of(context).labelUserCurrentLocation,
                    ),
                    icon: markerIcon != null
                        ? BitmapDescriptor.fromBytes(markerIcon!)
                        : BitmapDescriptor.defaultMarker,
                  ),
                },
              ),
            ],
          ));
        },
      ),
    );
  }
}
