import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoordinateHelper {
  static double calculateDistance({
    required LatLng pointA,
    required LatLng pointB,
  }) {
    return sqrt(pow(pointA.latitude - pointB.latitude, 2) +
        pow(pointA.longitude - pointB.longitude, 2));
  }

  static double? getDistanceFromLatLngInKm({
    double? lat1,
    double? lng1,
    double? lat2,
    double? lng2,
  }) {
    if (lat1 == null || lng1 == null || lat2 == null || lng2 == null) {
      return null;
    }
    double deg2rad(double deg) => deg * (pi / 180);
    const R = 6371; // Radius of the earth in km
    final double dLat = (lat2 - lat1) * (pi / 180);

    final double dLng = deg2rad(lng2 - lng1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double d = R * c; // Distance in km
    return d;
  }
}
