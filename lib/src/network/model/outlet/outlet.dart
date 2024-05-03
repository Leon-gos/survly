import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/localization/localization_utils.dart';

class Outlet {
  String? address;
  GeoPoint? geoPoint;
  String? geoHash;

  double? get latitude => geoPoint?.latitude;
  double? get longitude => geoPoint?.longitude;

  Outlet({
    this.address,
    this.geoHash,
    this.geoPoint,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'geoHash': geoHash,
      'geoPoint': geoPoint,
    };
  }

  String? getError() {
    if (geoPoint == null) {
      return S.text.errorOutletEmpty;
    }
    return null;
  }

  bool hasCoordinate() {
    return geoPoint != null;
  }
}
