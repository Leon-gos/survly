class Outlet {
  String outletId;
  String? address;
  double latitude;
  double longitude;
  String surveyId;

  Outlet({
    this.outletId = "",
    this.address,
    required this.latitude,
    required this.longitude,
    this.surveyId = "",
  });
}
