import 'package:survly/src/network/model/admin/admin.dart';

class AdminSingleton {

  static AdminSingleton? _instance;
  Admin? admin;

  factory AdminSingleton.instance() {
    _instance ??= AdminSingleton._();
    return _instance!;
  }

  AdminSingleton._();
}