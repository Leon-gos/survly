import 'package:survly/src/network/model/location_log/location_log.dart';

abstract class LocationLogRepository {
  Future<void> addLocationLog(LocationLog locationLog);
}
