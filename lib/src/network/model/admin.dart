import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';
part 'admin.g.dart';

@freezed
class Admin with _$Admin {

  const factory Admin({
    String? adminId,
    required String fullname,
    required String email,
    required String avatar,
    required String gender,
    required String birthDate,
    required String phone,
  }) = _Admin;

  factory Admin.fromJson(Map<String, Object?> json) => _$AdminFromJson(json);
}
