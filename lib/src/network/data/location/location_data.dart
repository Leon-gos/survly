import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LocationData {
  Future<http.Response> getLocationData(String text) async {
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
    return response;
  }
}
