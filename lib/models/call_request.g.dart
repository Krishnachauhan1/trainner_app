// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallRequestImpl _$$CallRequestImplFromJson(Map<String, dynamic> json) =>
    _$CallRequestImpl(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      trainerId: json['trainerId'] as String,
      slotStart: DateTime.parse(json['slotStart'] as String),
      slotEnd: DateTime.parse(json['slotEnd'] as String),
      note: json['note'] as String,
      status: $enumDecode(_$CallRequestStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      declineReason: json['declineReason'] as String?,
      roomId: json['roomId'] as String?,
    );

Map<String, dynamic> _$$CallRequestImplToJson(_$CallRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'trainerId': instance.trainerId,
      'slotStart': instance.slotStart.toIso8601String(),
      'slotEnd': instance.slotEnd.toIso8601String(),
      'note': instance.note,
      'status': _$CallRequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'declineReason': instance.declineReason,
      'roomId': instance.roomId,
    };

const _$CallRequestStatusEnumMap = {
  CallRequestStatus.pending: 'pending',
  CallRequestStatus.approved: 'approved',
  CallRequestStatus.declined: 'declined',
};
