import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatChatTime(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) {
      return DateFormat.jm().format(dt);
    }
    if (now.difference(dt).inDays < 7) {
      return DateFormat.E().add_jm().format(dt);
    }
    return DateFormat.MMMd().format(dt);
  }

  static String formatSlot(DateTime dt) =>
      DateFormat('EEE, MMM d • h:mm a').format(dt);

  static int sessionDurationSeconds(DateTime start, DateTime end) =>
      end.difference(start).inSeconds.clamp(0, 86400);
}
