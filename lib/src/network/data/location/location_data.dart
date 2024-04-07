import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:survly/src/network/model/fild_place/find_place_response.dart';
import 'package:survly/src/network/model/fild_place/find_text_response.dart';

class LocationData {
  Future<FindPlaceResponse> findPlace(String text) async {
    http.Response response;

    response = await http.get(
      Uri(
        scheme: "https",
        host: "maps.googleapis.com",
        path: "/maps/api/place/findplacefromtext/json",
        queryParameters: {
          "fields": "formatted_address,name,rating,opening_hours,geometry",
          "input": text,
          "inputtype": "textquery",
          "key": dotenv.get("API_KEY"),
        },
      ),
    );

    Logger().d(jsonDecode(response.body));
    return FindPlaceResponse.fromJson(jsonDecode(response.body));
  }

  Future<FindTextResponse> findText(String text, LatLng currentLocation) async {
    http.Response response;

    response = await http.get(
      Uri(
        scheme: "https",
        host: "maps.googleapis.com",
        path: "/maps/api/place/textsearch/json",
        queryParameters: {
          "query": text,
          "language": "vi",
          "location":
              "${currentLocation.latitude},${currentLocation.longitude}",
          "key": dotenv.get("API_KEY"),
        },
      ),
    );

    Logger().d(jsonDecode(response.body));
    return FindTextResponse.fromJson(jsonDecode(response.body));
  }
}
