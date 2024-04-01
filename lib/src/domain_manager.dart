import 'package:survly/src/network/data/admin/admin_repository_impl.dart';
import 'package:survly/src/network/data/authentication/authentication_repository_impl.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository_impl.dart' as authentication_local;

class DomainManager {
  factory DomainManager() {
    _internal ??= DomainManager._();
    return _internal!;
  }
  DomainManager._();
  static DomainManager? _internal;

  final authentication = AuthenticationRepositoryImpl();
  final authenticationLocal = authentication_local.AuthenticationRepositoryImpl();
  final admin = AdminRepositoryImpl();
}