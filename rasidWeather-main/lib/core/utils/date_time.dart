import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  // الصيغ الأساسية للتواريخ
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat _humanFormat = DateFormat('MMM dd, yyyy');

  // تحويل الوقت من ثواني لصيغة دقائق:ثواني
  static String formatTimeInSeconds(int timeInSeconds) {
    final int sec = timeInSeconds % 60;
    final int min = (timeInSeconds / 60).floor();
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  static String formatDateForApi(DateTime date) => _dateFormat.format(date);

  static String formatDateHumanReadable(DateTime date) => _humanFormat.format(date);

  static String formatTime(DateTime time) => _timeFormat.format(time);

  static String formatDateTime(DateTime dt) => _dateTimeFormat.format(dt);

  static DateTime? parseDateFromApi(String date) {
    try {
      return _dateFormat.parse(date);
    } catch (_) {
      return null;
    }
  }

  static DateTime? parseDateTimeFromApi(String dt) {
    try {
      return _dateTimeFormat.parse(dt);
    } catch (_) {
      return null;
    }
  }

  // تنسيق نسبي للوقت (منذ ساعتين، أمس، الخ)
  static String getRelativeTime(DateTime dt) {
    final Duration diff = DateTime.now().difference(dt);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} years ago';
    }
    if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} months ago';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) => DateTime(date.year, date.month, date.day, 23, 59, 59);

  static DateTime startOfWeek(DateTime date) => date.subtract(Duration(days: date.weekday % 7));

  static DateTime endOfWeek(DateTime date) {
    final DateTime end = date.add(Duration(days: 6 - (date.weekday % 7)));
    return endOfDay(end);
  }

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month);

  static DateTime endOfMonth(DateTime date) => endOfDay(DateTime(date.year, date.month + 1, 0));

  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  static DateTime timeOfDayToDateTime(TimeOfDay t) {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  static TimeOfDay? parseTimeOfDay(String time) {
    try {
      final DateTime dt = _timeFormat.parse(time);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {
      return null;
    }
  }

  // تنسيق مدى زمني (مثل 1-5 يناير 2025)
  static String formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('d, yyyy').format(end)}';
    }
    if (start.year == end.year) {
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
    }
    return '${DateFormat('MMM d, yyyy').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
  }

  static int getAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static bool isLeapYear(int year) => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  static int getDaysInMonth(int year, int month) {
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }
    const List<int> days = <int>[31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }
}
