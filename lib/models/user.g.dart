// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  avatarUrl: json['avatarUrl'] as String?,
  trainerId: json['trainerId'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'avatarUrl': instance.avatarUrl,
      'trainerId': instance.trainerId,
    };

const _$UserRoleEnumMap = {
  UserRole.member: 'member',
  UserRole.trainer: 'trainer',
};
