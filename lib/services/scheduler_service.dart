import 'dart:async';

import 'package:uuid/uuid.dart';

import '../models/call_request.dart';
import '../models/room_meta.dart';
import '../models/user.dart';
import '../utils/app_logger.dart';
import '../utils/date_utils.dart';

abstract class SchedulerService {
  Stream<List<CallRequest>> get requestsStream;
  Future<List<CallRequest>> getRequests({String? trainerId, String? memberId});
  Future<CallRequest> createRequest({
    required String memberId,
    required String memberName,
    required String trainerId,
    required DateTime slotStart,
    required String note,
  });
  Future<CallRequest> approve(String requestId, {required String templateId});
  Future<CallRequest> decline(String requestId, String reason);
  bool hasConflict(List<CallRequest> requests, DateTime slotStart, DateTime slotEnd);
  List<DateTime> availableSlots(DateTime day);
}

class SchedulerValidationException implements Exception {
  SchedulerValidationException(this.message);
  final String message;
  @override
  String toString() => message;
}

class LocalSchedulerService implements SchedulerService {
  LocalSchedulerService(this._persist, this._onApproved);

  final SchedulerPersistence _persist;
  final Future<void> Function(CallRequest, RoomMeta) _onApproved;
  final _uuid = const Uuid();
  final _controller = StreamController<List<CallRequest>>.broadcast();

  @override
  Stream<List<CallRequest>> get requestsStream => _controller.stream;

  @override
  Future<List<CallRequest>> getRequests({
    String? trainerId,
    String? memberId,
  }) async {
    var list = await _persist.getRequests();
    if (trainerId != null) {
      list = list.where((r) => r.trainerId == trainerId).toList();
    }
    if (memberId != null) {
      list = list.where((r) => r.memberId == memberId).toList();
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _controller.add(list);
    return list;
  }

  @override
  Future<CallRequest> createRequest({
    required String memberId,
    required String memberName,
    required String trainerId,
    required DateTime slotStart,
    required String note,
  }) async {
    final slotEnd = slotStart.add(const Duration(minutes: 30));
    final all = await _persist.getRequests();
    if (hasConflict(all, slotStart, slotEnd)) {
      throw SchedulerValidationException(
        'This slot is no longer available.',
      );
    }
    final req = CallRequest(
      id: _uuid.v4(),
      memberId: memberId,
      memberName: memberName,
      trainerId: trainerId,
      slotStart: slotStart,
      slotEnd: slotEnd,
      note: note.length > 140 ? note.substring(0, 140) : note,
      status: CallRequestStatus.pending,
      createdAt: DateTime.now(),
    );
    all.add(req);
    await _persist.saveRequests(all);
    _controller.add(all);
    AppLogger.instance.log(
      LogCategory.schedule,
      'Request created ${AppDateUtils.formatSlot(slotStart)}',
    );
    return req;
  }

  @override
  Future<CallRequest> approve(
    String requestId, {
    required String templateId,
  }) async {
    final all = await _persist.getRequests();
    final idx = all.indexWhere((r) => r.id == requestId);
    if (idx < 0) throw SchedulerValidationException('Request not found');
    final req = all[idx];
    if (hasConflict(
      all.where((r) => r.id != requestId).toList(),
      req.slotStart,
      req.slotEnd,
    )) {
      throw SchedulerValidationException('Slot conflict with another approval.');
    }
    final roomId = 'room_${_uuid.v4()}';
    final updated = req.copyWith(
      status: CallRequestStatus.approved,
      roomId: roomId,
    );
    all[idx] = updated;
    await _persist.saveRequests(all);
    _controller.add(all);
    final meta = RoomMeta(
      roomId: roomId,
      templateId: templateId,
      memberId: req.memberId,
      trainerId: req.trainerId,
      memberRole: UserRole.member,
      scheduledAt: req.slotStart,
      callRequestId: req.id,
    );
    await _onApproved(updated, meta);
    AppLogger.instance.log(LogCategory.schedule, 'Approved $requestId');
    return updated;
  }

  @override
  Future<CallRequest> decline(String requestId, String reason) async {
    final all = await _persist.getRequests();
    final idx = all.indexWhere((r) => r.id == requestId);
    if (idx < 0) throw SchedulerValidationException('Request not found');
    final updated = all[idx].copyWith(
      status: CallRequestStatus.declined,
      declineReason: reason,
    );
    all[idx] = updated;
    await _persist.saveRequests(all);
    _controller.add(all);
    AppLogger.instance.log(LogCategory.schedule, 'Declined $requestId');
    return updated;
  }

  @override
  bool hasConflict(
    List<CallRequest> requests,
    DateTime slotStart,
    DateTime slotEnd,
  ) {
    for (final r in requests) {
      if (r.status != CallRequestStatus.approved) continue;
      final overlap = slotStart.isBefore(r.slotEnd) && slotEnd.isAfter(r.slotStart);
      if (overlap) return true;
    }
    return false;
  }

  @override
  List<DateTime> availableSlots(DateTime day) {
    final base = DateTime(day.year, day.month, day.day, 9);
    return List.generate(
      16,
      (i) => base.add(Duration(minutes: 30 * i)),
    ).where((s) => s.hour < 17).toList();
  }
}

abstract class SchedulerPersistence {
  Future<List<CallRequest>> getRequests();
  Future<void> saveRequests(List<CallRequest> requests);
}
