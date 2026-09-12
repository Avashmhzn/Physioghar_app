// import 'package:intl/intl.dart';

// class DateFormatter {
//   static String formatFullDate(DateTime date) {
//     return DateFormat('EEEE, d MMMM yyyy').format(date);
//   }

//   static String formatShortDate(DateTime date) {
//     return DateFormat('d MMM yyyy').format(date);
//   }

//   static String formatTime(DateTime date) {
//     return DateFormat('hh:mm a').format(date);
//   }

//   static String formatDayOfWeek(DateTime date) {
//     return DateFormat('EEE').format(date);
//   }

//   static String formatDayNumber(DateTime date) {
//     return DateFormat('d').format(date);
//   }

//   static String formatMonthYear(DateTime date) {
//     return DateFormat('MMMM yyyy').format(date);
//   }

//   static List<DateTime> getWeekDates(DateTime anchor) {
//     // Find the Monday of the current week
//     final int difference = anchor.weekday - DateTime.monday;
//     final DateTime monday = anchor.subtract(Duration(days: difference));

//     return List.generate(7, (index) => monday.add(Duration(days: index)));
//   }

//   static bool isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }
// }

import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String formatDayNumber(DateTime date) {
    return DateFormat('d').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Home header style: THURSDAY, 12 OCT 2026
  static String formatHomeHeaderDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy').format(date).toUpperCase();
  }

  static List<DateTime> getWeekDates(DateTime anchor) {
    // Find the Monday of the current week
    final int difference = anchor.weekday - DateTime.monday;
    final DateTime monday = anchor.subtract(Duration(days: difference));

    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
