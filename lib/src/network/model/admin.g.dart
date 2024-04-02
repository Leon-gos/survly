// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminImpl _$$AdminImplFromJson(Map<String, dynamic> json) => _$AdminImpl(
      adminId: json['adminId'] as String?,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      gender: json['gender'] as String,
      birthDate: json['birthDate'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$$AdminImplToJson(_$AdminImpl instance) =>
    <String, dynamic>{
      'adminId': instance.adminId,
      'fullname': instance.fullname,
      'email': instance.email,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'phone': instance.phone,
    };
