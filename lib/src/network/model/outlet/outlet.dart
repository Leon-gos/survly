class Outlet {
  String outletId;
  String? address;
  double latitude;
  double longitude;

  Outlet({
    this.outletId = "",
    this.address,
    required this.latitude,
    required this.longitude,
  });
}
