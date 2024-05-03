import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/localization/localization_utils.dart';

class Outlet {
  String? address;
  // double? latitude;
  // double? longitude;
  GeoPoint? geoPoint;
  String? geoHash;

  double? get latitude => geoPoint?.latitude;
  double? get longitude => geoPoint?.longitude;

  Outlet({
    this.address,
    // required this.latitude,
    // required this.longitude,
    this.geoHash,
    this.geoPoint,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      // 'latitude': latitude,
      // 'longitude': longitude,
      'geoHash': geoHash,
      'geoPoint': geoPoint,
    };
  }

  String? getError() {
    // if (latitude == null || longitude == null) {
    //   return S.text.errorOutletEmpty;
    // }
    if (geoPoint == null) {
      return S.text.errorOutletEmpty;
    }
    return null;
  }

  bool hasCoordinate() {
    // return latitude != null && longitude != null;
    return geoPoint != null;
  }
}
