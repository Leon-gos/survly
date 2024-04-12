import 'package:flutter/material.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking({super.key});

  @override
  State<StatefulWidget> createState() => LocationTrackingState();
}

class LocationTrackingState extends State<LocationTracking> {
  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text("Lat: $lat"), Text("Long: $long")],
      ),
    );
  }
}
