// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionLogImpl _$$SessionLogImplFromJson(Map<String, dynamic> json) =>
    _$SessionLogImpl(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      trainerId: json['trainerId'] as String,
      trainerName: json['trainerName'] as String,
      roomId: json['roomId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      notes: json['notes'] as String?,
      memberRating: (json['memberRating'] as num?)?.toInt() ?? 0,
      trainerRating: (json['trainerRating'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SessionLogImplToJson(_$SessionLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'trainerId': instance.trainerId,
      'trainerName': instance.trainerName,
      'roomId': instance.roomId,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'notes': instance.notes,
      'memberRating': instance.memberRating,
      'trainerRating': instance.trainerRating,
    };
