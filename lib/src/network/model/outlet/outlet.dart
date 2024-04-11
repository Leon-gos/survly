import 'package:survly/src/localization/localization_utils.dart';

class Outlet {
  String? address;
  double? latitude;
  double? longitude;

  Outlet({
    this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String? getError() {
    if (latitude == null || longitude == null) {
      return S.text.errorOutletEmpty;
    }
    return null;
  }

  bool hasCoordinate() {
    return latitude != null && longitude != null;
  }
}
