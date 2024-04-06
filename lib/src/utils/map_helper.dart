import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class MapHelper {
  MapHelper._(); // Private constructor

  static Future<void> openMap() async {
    Uri googleUrl = Uri(
      scheme: "https",
      host: "google.com",
      path: "/maps/",
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  static Future<void> openMapWithLocation({
    required double latitude,
    required double longitude,
  }) async {
    Uri googleUrl = Uri(
      scheme: "https",
      host: "google.com",
      path: "/maps/search/",
      query: "api=1&query=$latitude,$longitude",
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }
}
