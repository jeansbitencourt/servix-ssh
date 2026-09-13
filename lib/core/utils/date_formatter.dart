import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss');

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime.toLocal());
  }

  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime.toLocal());
  }

  static String formatDuration(int durationMs) {
    if (durationMs < 1000) {
      return '${durationMs}ms';
    } else {
      final seconds = (durationMs / 1000).toStringAsFixed(2);
      return '${seconds}s';
    }
  }
}
