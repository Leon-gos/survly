import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppMapCardWidget extends StatelessWidget {
  const AppMapCardWidget({super.key, required this.locationCoordinate});

  final LatLng locationCoordinate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              locationCoordinate.latitude,
              locationCoordinate.longitude,
            ),
            zoom: 15,
          ),
          markers: {
            Marker(
                markerId: const MarkerId("place"),
                position: LatLng(
                  locationCoordinate.latitude,
                  locationCoordinate.longitude,
                ))
          },
        ),
      ),
    );
  }
}
