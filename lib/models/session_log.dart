import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_log.freezed.dart';
part 'session_log.g.dart';

@freezed
class SessionLog with _$SessionLog {
  const factory SessionLog({
    required String id,
    required String memberId,
    required String memberName,
    required String trainerId,
    required String trainerName,
    required String roomId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    String? notes,
    @Default(0) int memberRating,
    @Default(0) int trainerRating,
  }) = _SessionLog;

  factory SessionLog.fromJson(Map<String, dynamic> json) =>
      _$SessionLogFromJson(json);
}
