import 'package:flutter/material.dart';

enum DayAttendanceStatus { present, absent, holiday }

class DayRecord {
  final String dateLabel; // "01"
  final String dayLabel; // "Mon"
  final DayAttendanceStatus status;

  const DayRecord({
    required this.dateLabel,
    required this.dayLabel,
    required this.status,
  });
}

class StudentAttendance {
  final String id;
  final String name;
  final Color avatarColor;
  final List<DayRecord> days;

  const StudentAttendance({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.days,
  });

  String get initial => name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
}

/// Converts the raw `List<Map<String, String>>` rows coming back in
/// `MonthlyAttendanceResult.data` into the student/day models the table
/// widgets consume.
///
/// Matches the real API row shape:
///   { "Admno": "1003", "Name": "MOHAMMED FADHIL KT", "Gender": "Boy",
///     "Day1": null, "Day2": "Present", ..., "Day31": null,
///     "TotalAttendance": "7", "TotalAbsent": "0" }
///
/// - id: "Admno"
/// - name: "Name"
/// - each day: key "Day1".."Day31", value "Present" (present) or
///   empty/null->"" (absent), except Sundays which are always shown as holiday
class AttendanceRowMapper {
  static const _idKey = 'Admno';
  static const _nameKey = 'Name';
  static const _dayKeyPrefix = 'Day';
  static const _presentValue = 'Present';

  static const _palette = [
    Colors.teal, Colors.indigo, Colors.deepPurple, Colors.red,
    Colors.purple, Colors.green, Colors.blue, Colors.brown,
    Colors.cyan, Colors.pink, Colors.orange, Colors.blueGrey,
  ];

  /// All "DayN" keys present in the rows, sorted ascending by day number,
  /// limited to the actual number of days in the given month/year.
  static List<String> dayKeys(List<Map<String, String>> data, int month, String accYear) {
    final daysInMonth = _daysInMonth(month, _calendarYearFor(month, accYear));
    return List.generate(daysInMonth, (i) => '$_dayKeyPrefix${i + 1}');
  }

  static int _daysInMonth(int month, int year) {
    final firstOfNextMonth = month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    return firstOfNextMonth.subtract(const Duration(days: 1)).day;
  }

  /// Resolves the calendar year for a given [month] number (1-12) given an
  /// academic-year string like "2025-26". Assumes the academic year starts
  /// in June (months Jun-Dec -> start year, Jan-May -> start year + 1).
  /// Adjust if your school year starts a different month.
  static int _calendarYearFor(int month, String accYear) {
    final startYear = int.tryParse(accYear.split('-').first) ?? DateTime.now().year;
    return month >= 6 ? startYear : startYear + 1;
  }

  static String _weekdayAbbrev(DateTime date) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[date.weekday - 1];
  }

  /// Builds the ordered list of (dateLabel, dayLabel) columns for the header row.
  static List<DayColumn> buildColumns(List<Map<String, String>> data, int month, String accYear) {
    final year = _calendarYearFor(month, accYear);
    return dayKeys(data, month, accYear).map((key) {
      final dayNum = int.parse(key.substring(_dayKeyPrefix.length));
      final date = DateTime(year, month, dayNum);
      return DayColumn(
        dateLabel: dayNum.toString().padLeft(2, '0'),
        dayLabel: _weekdayAbbrev(date),
        isSunday: date.weekday == DateTime.sunday,
        rawKey: key,
      );
    }).toList();
  }

  static List<StudentAttendance> mapRows(
      List<Map<String, String>> data,
      List<DayColumn> columns,
      ) {
    return List.generate(data.length, (i) {
      final row = data[i];
      final id = (row[_idKey] ?? '').isNotEmpty ? row[_idKey]! : 'student_$i';
      final name = (row[_nameKey] ?? '').isNotEmpty ? row[_nameKey]! : 'Unknown';

      final days = columns.map((col) {
        final raw = (row[col.rawKey] ?? '').trim();
        final status = col.isSunday
            ? DayAttendanceStatus.holiday
            : raw == _presentValue
            ? DayAttendanceStatus.present
            : raw.isEmpty
            ? DayAttendanceStatus.holiday // no record yet / not marked
            : DayAttendanceStatus.absent;
        return DayRecord(dateLabel: col.dateLabel, dayLabel: col.dayLabel, status: status);
      }).toList();

      return StudentAttendance(
        id: id,
        name: name,
        avatarColor: _palette[id.hashCode.abs() % _palette.length],
        days: days,
      );
    });
  }

  static List<int> presentTotalsPerDay(List<StudentAttendance> students, int dayCount) {
    return List.generate(
      dayCount,
          (i) => students.where((s) => s.days[i].status == DayAttendanceStatus.present).length,
    );
  }

  static List<int> absentTotalsPerDay(List<StudentAttendance> students, int dayCount) {
    return List.generate(
      dayCount,
          (i) => students.where((s) => s.days[i].status == DayAttendanceStatus.absent).length,
    );
  }
}

class DayColumn {
  final String dateLabel;
  final String dayLabel;
  final bool isSunday;
  final String rawKey;

  const DayColumn({
    required this.dateLabel,
    required this.dayLabel,
    required this.isSunday,
    required this.rawKey,
  });
}