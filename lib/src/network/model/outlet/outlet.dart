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
      return "Outlet empty";
    }
    return null;
  }
}
