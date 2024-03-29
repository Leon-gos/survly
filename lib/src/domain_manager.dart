import 'package:survly/src/network/data/sign_up/authentication_repository_impl.dart';

class DomainManager {
  factory DomainManager() {
    _internal ??= DomainManager._();
    return _internal!;
  }
  DomainManager._();
  static DomainManager? _internal;

  final authentication = AuthenticationRepositoryImpl();
}