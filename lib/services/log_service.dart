import 'dart:async';

import 'package:uuid/uuid.dart';

import '../models/session_log.dart';
import '../utils/app_logger.dart';
import '../utils/date_utils.dart';

enum SessionLogFilter { all, last7Days, thisMonth }

abstract class LogService {
  Stream<List<SessionLog>> get logsStream;
  Future<List<SessionLog>> getLogs({
    String? memberId,
    String? trainerId,
    SessionLogFilter filter = SessionLogFilter.all,
  });
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
  });
}

class LocalLogService implements LogService {
  LocalLogService(this._persist);

  final LogPersistence _persist;
  final _uuid = const Uuid();
  final _controller = StreamController<List<SessionLog>>.broadcast();

  @override
  Stream<List<SessionLog>> get logsStream => _controller.stream;

  @override
  Future<List<SessionLog>> getLogs({
    String? memberId,
    String? trainerId,
    SessionLogFilter filter = SessionLogFilter.all,
  }) async {
    var list = await _persist.getLogs();
    if (memberId != null) {
      list = list.where((l) => l.memberId == memberId).toList();
    }
    if (trainerId != null) {
      list = list.where((l) => l.trainerId == trainerId).toList();
    }
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
    list.sort((a, b) => b.startedAt.compareTo(a.startedAt));
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
    final all = await _persist.getLogs();
    all.add(log);
    await _persist.saveLogs(all);
    _controller.add(all);
    AppLogger.instance.log(
      LogCategory.general,
      'Session log ${log.durationSeconds}s',
    );
    return log;
  }
}

abstract class LogPersistence {
  Future<List<SessionLog>> getLogs();
  Future<void> saveLogs(List<SessionLog> logs);
}
