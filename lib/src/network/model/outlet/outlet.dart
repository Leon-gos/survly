import 'dart:convert';

class Outlet {
  String? address;
  double latitude;
  double longitude;

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

  factory Outlet.fromMap(Map<String, dynamic> map) {
    return Outlet(
      address: map['address'] != null ? map['address'] as String : null,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Outlet.fromJson(String source) =>
      Outlet.fromMap(json.decode(source) as Map<String, dynamic>);
}
