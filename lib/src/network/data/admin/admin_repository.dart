import 'package:survly/src/network/model/admin.dart';

abstract class AdminRepository {
  Future<Admin?> getAdminByEmail(String email);
}