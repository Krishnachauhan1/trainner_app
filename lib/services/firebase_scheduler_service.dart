import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../firebase/firestore_mappers.dart';
import '../firebase/firestore_paths.dart';
import '../models/call_request.dart';
import '../models/room_meta.dart';
import '../models/user.dart';
import '../utils/app_logger.dart';
import '../utils/date_utils.dart';
import '../utils/seed_data.dart';
import 'chat_service.dart';
import 'hive_persistence.dart';
import 'scheduler_service.dart';

class FirebaseSchedulerService implements SchedulerService {
  FirebaseSchedulerService(this._chat, this._persist);

  final ChatService _chat;
  final HivePersistence _persist;
  final _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();
  final _controller = StreamController<List<CallRequest>>.broadcast();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestorePaths.callRequests);

  void startListening() {
    _sub?.cancel();
    _sub = _col.orderBy('createdAt', descending: true).snapshots().listen((snap) {
      final list = snap.docs.map(FirestoreMappers.callRequestFromDoc).toList();
      _controller.add(list);
    });
  }

  @override
  Stream<List<CallRequest>> get requestsStream {
    startListening();
    return _controller.stream;
  }

  @override
  Future<List<CallRequest>> getRequests({
    String? trainerId,
    String? memberId,
  }) async {
    Query<Map<String, dynamic>> q = _col.orderBy('createdAt', descending: true);
    if (trainerId != null) {
      q = q.where('trainerId', isEqualTo: trainerId);
    }
    if (memberId != null) {
      q = q.where('memberId', isEqualTo: memberId);
    }
    final snap = await q.get();
    final list = snap.docs.map(FirestoreMappers.callRequestFromDoc).toList();
    _controller.add(list);
    return list;
  }

  Future<List<CallRequest>> _allApproved() async {
    final snap = await _col
        .where('status', isEqualTo: CallRequestStatus.approved.name)
        .get();
    return snap.docs.map(FirestoreMappers.callRequestFromDoc).toList();
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
    final approved = await _allApproved();
    if (hasConflict(approved, slotStart, slotEnd)) {
      throw SchedulerValidationException(
        'This slot is no longer available.',
      );
    }
    final id = _uuid.v4();
    final req = CallRequest(
      id: id,
      memberId: memberId,
      memberName: memberName,
      trainerId: trainerId,
      slotStart: slotStart,
      slotEnd: slotEnd,
      note: note.length > 140 ? note.substring(0, 140) : note,
      status: CallRequestStatus.pending,
      createdAt: DateTime.now(),
    );
    await _col.doc(id).set(FirestoreMappers.callRequestToMap(req));
    AppLogger.instance.log(
      LogCategory.schedule,
      'Firebase request ${AppDateUtils.formatSlot(slotStart)}',
    );
    return req;
  }

  @override
  Future<CallRequest> approve(
    String requestId, {
    required String templateId,
  }) async {
    final doc = await _col.doc(requestId).get();
    if (!doc.exists) {
      throw SchedulerValidationException('Request not found');
    }
    final req = FirestoreMappers.callRequestFromDoc(doc);
    final approved = await _allApproved();
    if (hasConflict(
      approved.where((r) => r.id != requestId).toList(),
      req.slotStart,
      req.slotEnd,
    )) {
      throw SchedulerValidationException('Slot conflict with another approval.');
    }
    final roomId = 'room_${_uuid.v4()}';
    await _col.doc(requestId).update({
      'status': CallRequestStatus.approved.name,
      'roomId': roomId,
    });
    final updated = req.copyWith(
      status: CallRequestStatus.approved,
      roomId: roomId,
    );
    final meta = RoomMeta(
      roomId: roomId,
      templateId: templateId,
      memberId: req.memberId,
      trainerId: req.trainerId,
      memberRole: UserRole.member,
      scheduledAt: req.slotStart,
      callRequestId: req.id,
    );
    final date = AppDateUtils.formatSlot(req.slotStart);
    await _chat.sendSystemMessage(
      SeedData.conversationIdFor(req.trainerId),
      'Call approved for $date.',
    );
    await _persist.saveRoomMeta(meta.roomId, meta.toJson());
    AppLogger.instance.log(LogCategory.schedule, 'Approved $requestId');
    return updated;
  }

  @override
  Future<CallRequest> decline(String requestId, String reason) async {
    await _col.doc(requestId).update({
      'status': CallRequestStatus.declined.name,
      'declineReason': reason,
    });
    final doc = await _col.doc(requestId).get();
    return FirestoreMappers.callRequestFromDoc(doc);
  }

  @override
  bool hasConflict(
    List<CallRequest> requests,
    DateTime slotStart,
    DateTime slotEnd,
  ) {
    for (final r in requests) {
      if (r.status != CallRequestStatus.approved) continue;
      final overlap =
          slotStart.isBefore(r.slotEnd) && slotEnd.isAfter(r.slotStart);
      if (overlap) return true;
    }
    return false;
  }

  @override
  List<DateTime> availableSlots(DateTime day) {
    final base = DateTime(day.year, day.month, day.day, 9);
    return List.generate(16, (i) => base.add(Duration(minutes: 30 * i)))
        .where((s) => s.hour < 17)
        .toList();
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
