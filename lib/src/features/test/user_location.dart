import 'package:flutter/material.dart';
// import 'package:location/location.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  State<StatefulWidget> createState() => UserLocationScreenState();
}

class UserLocationScreenState extends State<UserLocationScreen> {
  double lat = 0;
  double long = 0;
  // Location location = Location();

  @override
  void initState() {
    super.initState();
    // location.onLocationChanged.listen((event) {
    //   setState(() {
    //     lat = event.latitude ?? 0;
    //     long = event.longitude ?? 0;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [Text("Lat: $lat"), Text("Long: $long")],
      ),
    );
  }
}
