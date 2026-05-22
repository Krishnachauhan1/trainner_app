import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'room_meta.freezed.dart';
part 'room_meta.g.dart';

@freezed
class RoomMeta with _$RoomMeta {
  const factory RoomMeta({
    required String roomId,
    required String templateId,
    required String memberId,
    required String trainerId,
    required UserRole memberRole,
    required DateTime scheduledAt,
    String? callRequestId,
  }) = _RoomMeta;

  factory RoomMeta.fromJson(Map<String, dynamic> json) =>
      _$RoomMetaFromJson(json);
}
