import 'dart:collection';

enum LogCategory { chat, rtc, schedule, auth, general }

class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  final _entries = ListQueue<String>();
  static const _maxEntries = 200;

  List<String> get last20 =>
      _entries.toList().reversed.take(20).toList().reversed.toList();

  List<String> get chatLogs =>
      _entries.where((e) => e.startsWith('[CHAT]')).toList().reversed.take(20).toList();

  List<String> get rtcLogs =>
      _entries.where((e) => e.startsWith('[RTC]')).toList().reversed.take(20).toList();

  void log(LogCategory category, String message) {
    final prefix = switch (category) {
      LogCategory.chat => '[CHAT]',
      LogCategory.rtc => '[RTC]',
      LogCategory.schedule => '[SCHEDULE]',
      LogCategory.auth => '[AUTH]',
      LogCategory.general => '[APP]',
    };
    final line = '$prefix ${DateTime.now().toIso8601String()} $message';
    _entries.addLast(line);
    while (_entries.length > _maxEntries) {
      _entries.removeFirst();
    }
    // ignore: avoid_print
    print(line);
  }

  void clear() => _entries.clear();
}
