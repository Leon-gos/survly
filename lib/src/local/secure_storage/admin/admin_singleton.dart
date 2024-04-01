import 'package:survly/src/network/model/admin.dart';

class AdminSingleton {

  static AdminSingleton? _instance;
  late final Admin? admin;

  factory AdminSingleton.instance() {
    _instance ??= AdminSingleton._();
    return _instance!;
  }

  AdminSingleton._();
}