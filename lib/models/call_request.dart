import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_request.freezed.dart';
part 'call_request.g.dart';

enum CallRequestStatus { pending, approved, declined }

@freezed
class CallRequest with _$CallRequest {
  const factory CallRequest({
    required String id,
    required String memberId,
    required String memberName,
    required String trainerId,
    required DateTime slotStart,
    required DateTime slotEnd,
    required String note,
    required CallRequestStatus status,
    required DateTime createdAt,
    String? declineReason,
    String? roomId,
  }) = _CallRequest;

  factory CallRequest.fromJson(Map<String, dynamic> json) =>
      _$CallRequestFromJson(json);
}
