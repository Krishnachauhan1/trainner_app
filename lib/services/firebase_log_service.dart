import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../firebase/firestore_mappers.dart';
import '../firebase/firestore_paths.dart';
import '../models/session_log.dart';
import '../utils/app_logger.dart';
import '../utils/date_utils.dart';
import 'log_service.dart';

class FirebaseLogService implements LogService {
  final _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();
  final _controller = StreamController<List<SessionLog>>.broadcast();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestorePaths.sessionLogs);

  void _listen({String? memberId, String? trainerId}) {
    _sub?.cancel();
    Query<Map<String, dynamic>> q =
        _col.orderBy('startedAt', descending: true);
    if (memberId != null) {
      q = q.where('memberId', isEqualTo: memberId);
    } else if (trainerId != null) {
      q = q.where('trainerId', isEqualTo: trainerId);
    }
    _sub = q.snapshots().listen((snap) {
      final list = snap.docs.map(FirestoreMappers.sessionLogFromDoc).toList();
      _controller.add(list);
    });
  }

  @override
  Stream<List<SessionLog>> get logsStream => _controller.stream;

  @override
  Future<List<SessionLog>> getLogs({
    String? memberId,
    String? trainerId,
    SessionLogFilter filter = SessionLogFilter.all,
  }) async {
    _listen(memberId: memberId, trainerId: trainerId);
    Query<Map<String, dynamic>> q =
        _col.orderBy('startedAt', descending: true);
    if (memberId != null) {
      q = q.where('memberId', isEqualTo: memberId);
    } else if (trainerId != null) {
      q = q.where('trainerId', isEqualTo: trainerId);
    }
    final snap = await q.get();
    var list = snap.docs.map(FirestoreMappers.sessionLogFromDoc).toList();
    final now = DateTime.now();
    list = switch (filter) {
      SessionLogFilter.all => list,
      SessionLogFilter.last7Days => list
          .where((l) => now.difference(l.startedAt).inDays <= 7)
          .toList(),
      SessionLogFilter.thisMonth => list
          .where(
            (l) =>
                l.startedAt.year == now.year &&
                l.startedAt.month == now.month,
          )
          .toList(),
    };
    _controller.add(list);
    return list;
  }

  @override
  Future<SessionLog> createFromCall({
    required String memberId,
    required String memberName,
    required String trainerId,
    required String trainerName,
    required String roomId,
    required DateTime startedAt,
    required DateTime endedAt,
    String? notes,
    int memberRating = 0,
    int trainerRating = 0,
  }) async {
    final log = SessionLog(
      id: _uuid.v4(),
      memberId: memberId,
      memberName: memberName,
      trainerId: trainerId,
      trainerName: trainerName,
      roomId: roomId,
      startedAt: startedAt,
      endedAt: endedAt,
      durationSeconds:
          AppDateUtils.sessionDurationSeconds(startedAt, endedAt),
      notes: notes,
      memberRating: memberRating,
      trainerRating: trainerRating,
    );
    await _col.doc(log.id).set(FirestoreMappers.sessionLogToMap(log));
    AppLogger.instance.log(LogCategory.general, 'Firebase session log saved');
    return log;
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
