import 'package:survly/src/network/model/user_base/user_base.dart';

class UserBaseSingleton {
  static UserBaseSingleton? _instance;
  UserBase? userBase;

  factory UserBaseSingleton.instance() {
    _instance ??= UserBaseSingleton._();
    return _instance!;
  }

  UserBaseSingleton._();
}
