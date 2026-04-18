import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

/// Extension methods for [DateTime] to provide additional functionality for date manipulation.
extension DateHelpers on DateTime {
  /// Gets the current UTC time.
  static DateTime get now => DateTime.now().toUtc();

  /// Checks if the date is today.
  bool isToday() {
    final DateTime now = DateTime.now().toUtc();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if the date is tomorrow.
  bool isTomorrow() {
    final DateTime tomorrow = DateTime.now().toUtc().add(
          const Duration(days: 1),
        );
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Checks if the date is yesterday.
  bool isYesterday() {
    final DateTime yesterday = DateTime.now().toUtc().subtract(
          const Duration(days: 1),
        );
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns the start of the day (00:00:00).
  DateTime startOfDay() => DateTime.utc(year, month, day);

  /// Returns the end of the day (23:59:59.999).
  DateTime endOfDay() => DateTime.utc(year, month, day, 23, 59, 59, 999, 999);

  /// Returns the start of the week.
  ///
  /// [startWithMonday] determines if the week starts on Monday (true) or Sunday (false).
  DateTime startOfWeek({bool startWithMonday = false}) {
    final int daysToSubtract =
        weekday - (startWithMonday ? DateTime.monday : DateTime.sunday);
    return subtract(Duration(days: daysToSubtract)).startOfDay();
  }

  /// Returns the end of the week.
  ///
  /// [startWithMonday] determines if the week starts on Monday (true) or Sunday (false).
  DateTime endOfWeek({bool startWithMonday = false}) {
    final int daysToAdd =
        (startWithMonday ? DateTime.sunday : DateTime.saturday) - weekday;
    return add(Duration(days: daysToAdd)).endOfDay();
  }

  /// Returns the start of the month.
  DateTime startOfMonth() => DateTime.utc(year, month);

  /// Returns the end of the month.
  DateTime endOfMonth() {
    final DateTime lastDay = DateTime.utc(year, month + 1, 0);
    return lastDay.endOfDay();
  }

  /// Returns the start of the year.
  DateTime startOfYear() => DateTime.utc(year);

  /// Returns the end of the year.
  DateTime endOfYear() => DateTime.utc(year, 12, 31).endOfDay();

  /// Checks if two dates are on the same day.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns true if the date is a weekend (Saturday or Sunday).
  bool isWeekend() =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns true if the date is a weekday (Monday-Friday).
  bool isWeekday() => !isWeekend();

  /// Returns the number of days in the current month.
  int daysInMonth() => DateTime.utc(year, month + 1, 0).day;

  /// Returns true if the year is a leap year.
  bool isLeapYear() {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// Returns the quarter (1-4) that this date falls in.
  int quarter() => ((month - 1) ~/ 3) + 1;

  /// Returns a new [DateTime] with the time portion set to a specific time.
  DateTime setTime({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) {
    return DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Returns a new [DateTime] with any specified fields updated.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime.utc(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Returns the difference between two dates in whole days (absolute value).
  int daysBetween(DateTime other) {
    final DateTime date1 = startOfDay();
    final DateTime date2 = other.startOfDay();
    return date1.difference(date2).inDays.abs();
  }

  /// Returns the difference between two dates in whole days (absolute value).
  int hoursBetween(DateTime other) {
    final DateTime date1 = startOfDay();
    final DateTime date2 = other.startOfDay();
    return date1.difference(date2).inHours.abs();
  }

  /// Returns true if this date falls between [start] and [end] inclusive.
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start.subtract(const Duration(seconds: 1))) &&
        isBefore(end.add(const Duration(seconds: 1)));
  }

  /// Returns a new [DateTime] with the specified duration added.
  DateTime addDuration({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
  }) {
    DateTime result = this;

    // Add years
    if (years != 0) {
      result = DateTime.utc(
        result.year + years,
        result.month,
        result.day,
        result.hour,
        result.minute,
        result.second,
        result.millisecond,
        result.microsecond,
      );
    }

    // Add months
    if (months != 0) {
      int newMonth = result.month + months;
      final int yearsToAdd = (newMonth - 1) ~/ 12;
      newMonth = ((newMonth - 1) % 12) + 1;

      result = DateTime.utc(
        result.year + yearsToAdd,
        newMonth,
        result.day,
        result.hour,
        result.minute,
        result.second,
        result.millisecond,
        result.microsecond,
      );
    }

    // Add remaining days/hours/minutes/seconds
    if (days != 0 || hours != 0 || minutes != 0 || seconds != 0) {
      result = result.add(
        Duration(days: days, hours: hours, minutes: minutes, seconds: seconds),
      );
    }

    return result;
  }

  /// A simple custom formatter using manual pattern replacement.
  /// For more robust and localized formatting, use [DateFormat].
  String format({String pattern = 'yyyy-MM-dd'}) {
    final Map<String, String> formats = <String, String>{
      'yyyy': year.toString().padLeft(4, '0'),
      'MM': month.toString().padLeft(2, '0'),
      'dd': day.toString().padLeft(2, '0'),
      'HH': hour.toString().padLeft(2, '0'),
      'mm': minute.toString().padLeft(2, '0'),
      'ss': second.toString().padLeft(2, '0'),
    };

    String result = pattern;
    formats.forEach((String key, String value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }
}

DateTime getNow() => DateTime.now().toUtc();

DateTime getToday() {
  final DateTime now = getNow();
  return DateTime(now.year, now.month, now.day);
}

DateTime getTomorrow() {
  final DateTime now = getNow();
  return DateTime(now.year, now.month, now.day + 1);
}

DateTime getDaysAgo(int days) {
  final DateTime now = getNow();
  return DateTime(now.year, now.month, now.day).subtract(Duration(days: days));
}

DateTime getFirstDayOfWeek() {
  final DateTime today = getToday();
  return today.subtract(Duration(days: today.weekday)); // Simple approach
}

DateTime getLastDayOfWeek({int offset = 1}) {
  final DateTime today = getToday();
  final DateTime lastDayOfWeek = today.add(
    Duration(days: DateTime.sunday - today.weekday),
  );
  return DateTime(
    lastDayOfWeek.year,
    lastDayOfWeek.month,
    lastDayOfWeek.day + offset,
  );
}

// getDifferenceTime
int getDifferenceTimeEpoch({DateTime? startTime, DateTime? endTime}) {
  return endTime!.millisecondsSinceEpoch - startTime!.millisecondsSinceEpoch;
}

// getDifferenceTime
String getDifferenceTime({DateTime? startTime, DateTime? endTime}) {
  // convert result to string
  final Duration difference = endTime!.difference(startTime!);
  // convert to days hours and minutes
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String twoDigitMinutes = twoDigits(difference.inMinutes.remainder(60));
  final String twoDigitSeconds = twoDigits(difference.inSeconds.remainder(60));

  return '${twoDigits(difference.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

/// Convert a [DateTime] to ISO 8601 string in UTC.
String toIso8601String(DateTime date) => date.toUtc().toIso8601String();

/// Parse an ISO 8601 string into a UTC [DateTime].
DateTime fromIso8601String(String date) => DateTime.parse(date).toUtc();

/// Parse a standard date [String] into a [DateTime].
DateTime fromString(String date) => DateTime.parse(date);

/// Format a [DateTime] using the [intl] package with a given `format` pattern and the current locale.
String? formatDateTime(
  DateTime date, {
  String? format = 'yyyy-MM-dd',
  bool addSuffix = false,
  Locale? localeOverride, // optional override
}) {
  const String
      loc = /*localeOverride?.toString() ?? EasyLocalization.of(Get.context)?.locale.toString() ?? */
      'en_US';
  final DateFormat formatter = DateFormat(format, loc);

  final String formatted = formatter.format(date);

  if (addSuffix) {
    final int dayNumber = int.parse(DateFormat('d', loc).format(date));
    final String suffix = getDaySuffix(dayNumber);
    return '$formatted$suffix';
  }
  return formatted;
}

/// Get an English ordinal suffix (st, nd, rd, th). If you have translations for suffixes, adjust accordingly.
String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

/// Format a date for article usage, example: "Mon, Mar 7, 2025"
String formatArticleDate(DateTime dateTime) {
  // For a short weekday + day + short month + year: EEE, d MMM yyyy
  return DateFormat(
    'EEE, d MMM yyyy',
    Get.context?.locale.toString() ?? 'en_US',
  ).format(dateTime);
}

/// Convert an epoch (in seconds) to a UTC [DateTime].
DateTime epochToDateTime(int epoch) {
  // If the epoch is in seconds, multiply by 1000 for milliseconds.
  final int timezone = DateTime.now().timeZoneOffset.inSeconds;
  final int milliseconds = (epoch + timezone) * 1000;
  return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
}

/// Example localized "time ago" function:
String dateTimeToTimeAgo(DateTime dateTime) {
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(dateTime);
  // Use your translation keys below
  if (difference.inSeconds < 60) {
    // "timeAgo.now" -> "just now" or "الآن"
    return tr('date.timeAgo.now');
  } else if (difference.inMinutes < 60) {
    // "timeAgo.xMinutes" -> "x minutes ago" or "منذ x دقيقة"
    return tr(
      'date.timeAgo.xMinutes',
      args: <String>[difference.inMinutes.toString()],
    );
  } else if (difference.inHours < 24) {
    // "timeAgo.xHours" -> "x hours ago"
    return tr(
      'date.timeAgo.xHours',
      args: <String>[difference.inHours.toString()],
    );
  } else if (difference.inDays == 1) {
    // "timeAgo.yesterdayAt" -> "Yesterday at HH:mm"
    final String time = DateFormat(
      'HH:mm aa' /* context.locale.toString()*/,
    ).format(dateTime);
    return tr('date.timeAgo.yesterdayAt', args: <String>[time]);
  } else if (difference.inDays < 3) {
    // "timeAgo.xDaysAtTime" -> "2 days ago at HH:mm"
    final String time = DateFormat(
      'HH:mm aa' /*context.locale.toString()*/,
    ).format(dateTime);
    return tr(
      'date.timeAgo.xDaysAtTime',
      args: <String>[difference.inDays.toString(), time],
    );
  } else {
    // For older dates, show an article date format
    return formatArticleDate(dateTime);
  }
}

/// Convert days to months/years with translation.
String daysToMonthsOrYears(int days) {
  if (days < 30) {
    // "common.xDays" -> "X days" or "x يوم"
    return tr('date.xDays', args: <String>[days.toString()]);
  } else if (days < 365) {
    final int months = (days / 30).floor();
    // "common.xMonths" -> "X months" or "x شهر"
    return tr('date.xMonths', args: <String>[months.toString()]);
  } else {
    final int years = (days / 365).floor();
    // "common.xYears" -> "X years" or "x سنة"
    return tr('date.xYears', args: <String>[years.toString()]);
  }
}

/// Returns the sun phase percentage (0..100) between [sunrise] and [sunset].
///
/// - If [now] is before [sunrise], returns 0.0.
/// - If [now] is after [sunset], returns 100.0.
/// - Otherwise, returns the percentage of the day elapsed since sunrise.
double getSunPhasePercentage({
  required DateTime sunrise,
  required DateTime sunset,
  DateTime? now,
}) {
  // Default [now] to current local time if not provided.
  final DateTime current = now ?? DateTime.now();

  // Safety checks
  if (sunrise.isAtSameMomentAs(sunset) || sunrise.isAfter(sunset)) {
    // If sunrise == sunset or sunrise is after sunset, the times are invalid.
    // You can return 0.0 or throw an exception based on your needs.
    return 0.0;
  }

  if (current.isBefore(sunrise)) {
    return 0.0;
  }
  if (current.isAfter(sunset)) {
    return 100.0;
  }

  final int totalSeconds = sunset.difference(sunrise).inSeconds;
  final int elapsedSeconds = current.difference(sunrise).inSeconds;
  final double percentage = (elapsedSeconds / totalSeconds) * 100.0;

  return percentage;
}
