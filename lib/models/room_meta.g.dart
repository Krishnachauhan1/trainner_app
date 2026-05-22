// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomMetaImpl _$$RoomMetaImplFromJson(Map<String, dynamic> json) =>
    _$RoomMetaImpl(
      roomId: json['roomId'] as String,
      templateId: json['templateId'] as String,
      memberId: json['memberId'] as String,
      trainerId: json['trainerId'] as String,
      memberRole: $enumDecode(_$UserRoleEnumMap, json['memberRole']),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      callRequestId: json['callRequestId'] as String?,
    );

Map<String, dynamic> _$$RoomMetaImplToJson(_$RoomMetaImpl instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'templateId': instance.templateId,
      'memberId': instance.memberId,
      'trainerId': instance.trainerId,
      'memberRole': _$UserRoleEnumMap[instance.memberRole]!,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'callRequestId': instance.callRequestId,
    };

const _$UserRoleEnumMap = {
  UserRole.member: 'member',
  UserRole.trainer: 'trainer',
};
