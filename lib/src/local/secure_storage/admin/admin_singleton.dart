import 'package:flutter_geo_hash/geohash.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

class UserBaseSingleton {
  static UserBaseSingleton? _instance;
  UserBase? userBase;
  GeoPoint? geoPoint;

  factory UserBaseSingleton.instance() {
    _instance ??= UserBaseSingleton._();
    return _instance!;
  }

  UserBaseSingleton._();
}
