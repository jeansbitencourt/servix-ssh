import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime, String locale) {
    return DateFormat.yMd(locale).add_jms().format(dateTime.toLocal());
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime.toLocal());
  }

  static String formatDuration(int durationMs, [String locale = 'en']) {
    if (durationMs < 1000) {
      return '${durationMs}ms';
    }

    final seconds = NumberFormat('0.00', locale).format(durationMs / 1000);
    return '${seconds}s';
  }
}
