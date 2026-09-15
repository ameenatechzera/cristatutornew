import 'package:flutter/material.dart';

void main() {
  runApp(const AttendanceDemoApp());
}

class AttendanceDemoApp extends StatelessWidget {
  const AttendanceDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F8FA),
        fontFamily: 'Roboto',
      ),
      home: const AttendanceScreen(),
    );
  }
}

enum AttendanceStatus { present, absent, holiday }

class AttendanceStudent {
  AttendanceStudent({
    required this.name,
    required this.avatarColor,
    required this.attendance,
  });

  final String name;
  final Color avatarColor;
  final List<AttendanceStatus> attendance;
}

class AttendanceDay {
  const AttendanceDay(this.date, this.day, {this.isWeekend = false});

  final String date;
  final String day;
  final bool isWeekend;
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  static const Color purple = Color(0xFF8580DB);
  static const Color strongPurple = Color(0xFF7657E8);
  static const double nameWidth = 116;
  static const double dayWidth = 38;
  static const double rowHeight = 43;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _headerController = ScrollController();
  final ScrollController _bodyController = ScrollController();
  final ScrollController _summaryController = ScrollController();
  String _query = '';

  final List<AttendanceDay> _days = const [
    AttendanceDay('01', 'Mon'),
    AttendanceDay('02', 'Tue'),
    AttendanceDay('03', 'Wed'),
    AttendanceDay('04', 'Thu'),
    AttendanceDay('05', 'Fri'),
    AttendanceDay('06', 'Sat'),
    AttendanceDay('07', 'Sun', isWeekend: true),
    AttendanceDay('08', 'Mon'),
    AttendanceDay('09', 'Tue'),
  ];

  late final List<AttendanceStudent> _students = [
    _student('Serin Johnson', const Color(0xFF2699BD), [
      1,
      0,
      0,
      0,
      0,
      0,
      2,
      0,
      0,
    ]),
    _student('Ahamd A\nAlimen Azar', const Color(0xFF5741A3), [
      0,
      0,
      0,
      1,
      0,
      0,
      2,
      0,
      0,
    ]),
    _student('Ameola K', const Color(0xFF075FD0), [0, 0, 1, 0, 0, 0, 2, 0, 0]),
    _student('Apooeyt M', const Color(0xFFE84C55), [0, 0, 0, 0, 0, 0, 2, 0, 0]),
    _student('Isha Mariam', const Color(0xFF63145D), [
      0,
      1,
      0,
      0,
      0,
      0,
      2,
      0,
      0,
    ]),
    _student('Sahala', const Color(0xFF47BE88), [0, 0, 0, 0, 1, 0, 2, 0, 0]),
    _student('Sala M', const Color(0xFF0929B7), [0, 0, 0, 0, 1, 0, 2, 0, 0]),
    _student('Casemero', const Color(0xFF62C633), [0, 0, 0, 1, 0, 0, 2, 0, 0]),
    _student('Montiyal', const Color(0xFFBE8B43), [0, 1, 0, 0, 0, 0, 2, 1, 0]),
    _student('Leo', const Color(0xFF8C0DA5), [0, 0, 0, 0, 0, 0, 2, 0, 0]),
    _student('Abraha', const Color(0xFFC8A77C), [0, 0, 0, 1, 0, 0, 2, 0, 0]),
    _student('Uday Kv', const Color(0xFF20C56D), [0, 0, 1, 0, 0, 0, 2, 0, 0]),
    _student('Abiya', const Color(0xFFC8A77C), [0, 0, 0, 1, 0, 0, 2, 0, 0]),
    _student('Ulakna Kv', const Color(0xFF20C56D), [0, 0, 1, 0, 0, 0, 2, 0, 0]),
  ];

  AttendanceStudent _student(String name, Color color, List<int> values) {
    return AttendanceStudent(
      name: name,
      avatarColor: color,
      attendance: values.map((value) {
        if (value == 1) return AttendanceStatus.absent;
        if (value == 2) return AttendanceStatus.holiday;
        return AttendanceStatus.present;
      }).toList(),
    );
  }

  List<AttendanceStudent> get _filteredStudents {
    if (_query.trim().isEmpty) return _students;
    return _students
        .where(
          (student) =>
              student.name.toLowerCase().contains(_query.toLowerCase().trim()),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _headerController.addListener(_syncHeaderToBody);
    _bodyController.addListener(_syncBodyToHeader);
  }

  bool _syncing = false;

  void _syncHeaderToBody() {
    if (_syncing || !_bodyController.hasClients) return;
    _syncing = true;
    _bodyController.jumpTo(_headerController.offset);
    if (_summaryController.hasClients) {
      _summaryController.jumpTo(_headerController.offset);
    }
    _syncing = false;
  }

  void _syncBodyToHeader() {
    if (_syncing || !_headerController.hasClients) return;
    _syncing = true;
    _headerController.jumpTo(_bodyController.offset);
    if (_summaryController.hasClients) {
      _summaryController.jumpTo(_bodyController.offset);
    }
    _syncing = false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headerController.dispose();
    _bodyController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final students = _filteredStudents;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearch(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildTableHeader(),
                    Expanded(child: _buildStudentRows(students)),
                    _buildSummary(students),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 65,
      color: purple,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              '10A Attendance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(
                Icons.filter_alt_rounded,
                size: 20,
                color: Color(0xFF504D67),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 21),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  icon: const Icon(Icons.close, size: 18),
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE4E4E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: purple, width: 1.3),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Container(
            width: nameWidth,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 18),
            decoration: _cellBorder(),
            child: const Text(
              'Student',
              style: TextStyle(color: strongPurple, fontSize: 11),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _headerController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _days.map((day) {
                  final color = day.isWeekend
                      ? const Color(0xFFBDB9C7)
                      : strongPurple;
                  return Container(
                    width: dayWidth,
                    decoration: _cellBorder(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.date,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day.day,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRows(List<AttendanceStudent> students) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: nameWidth,
            child: Column(children: students.map(_buildNameCell).toList()),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _bodyController,
              scrollDirection: Axis.horizontal,
              child: Column(
                children: students.asMap().entries.map((entry) {
                  return Row(
                    children: entry.value.attendance.asMap().entries.map((
                      statusEntry,
                    ) {
                      return _buildAttendanceCell(
                        entry.key,
                        statusEntry.key,
                        statusEntry.value,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCell(AttendanceStudent student) {
    final initial = student.name.trim().isEmpty
        ? '?'
        : student.name.trim()[0].toUpperCase();
    return Container(
      height: rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: _cellBorder(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: student.avatarColor,
            child: Text(
              initial,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              student.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9.5, color: Color(0xFF34323C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCell(
    int filteredStudentIndex,
    int dayIndex,
    AttendanceStatus status,
  ) {
    final filteredStudent = _filteredStudents[filteredStudentIndex];
    final originalIndex = _students.indexOf(filteredStudent);
    return InkWell(
      onTap: status == AttendanceStatus.holiday
          ? null
          : () {
              setState(() {
                _students[originalIndex].attendance[dayIndex] =
                    status == AttendanceStatus.present
                    ? AttendanceStatus.absent
                    : AttendanceStatus.present;
              });
            },
      child: Container(
        width: dayWidth,
        height: rowHeight,
        alignment: Alignment.center,
        decoration: _cellBorder(),
        child: _statusBadge(status),
      ),
    );
  }

  Widget _statusBadge(AttendanceStatus status) {
    if (status == AttendanceStatus.holiday) {
      return const Text(
        '–',
        style: TextStyle(color: Color(0xFFB8B5C1), fontWeight: FontWeight.w700),
      );
    }
    final absent = status == AttendanceStatus.absent;
    return Container(
      width: 21,
      height: 21,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: absent ? const Color(0xFFFFE8E8) : const Color(0xFFEAF9EC),
      ),
      child: Text(
        absent ? 'A' : 'P',
        style: TextStyle(
          color: absent ? const Color(0xFFFF4040) : const Color(0xFF22A934),
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSummary(List<AttendanceStudent> students) {
    final presentCounts = List<int>.generate(_days.length, (dayIndex) {
      return students
          .where((s) => s.attendance[dayIndex] == AttendanceStatus.present)
          .length;
    });
    final absentCounts = List<int>.generate(_days.length, (dayIndex) {
      return students
          .where((s) => s.attendance[dayIndex] == AttendanceStatus.absent)
          .length;
    });

    return Container(
      color: strongPurple,
      child: Row(
        children: [
          SizedBox(
            width: nameWidth,
            child: Column(
              children: [_summaryLabel('Present'), _summaryLabel('Absent')],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _summaryController,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: presentCounts
                        .map((count) => _summaryNumber(count))
                        .toList(),
                  ),
                  Row(
                    children: absentCounts
                        .map((count) => _summaryNumber(count))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryLabel(String text) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: _summaryBorder(),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _summaryNumber(int number) {
    return Container(
      width: dayWidth,
      height: 48,
      alignment: Alignment.center,
      decoration: _summaryBorder(),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration _cellBorder() {
    return const BoxDecoration(
      color: Colors.white,
      border: Border(
        right: BorderSide(color: Color(0xFFECEBF0), width: .7),
        bottom: BorderSide(color: Color(0xFFECEBF0), width: .7),
      ),
    );
  }

  BoxDecoration _summaryBorder() {
    return BoxDecoration(
      border: Border(
        right: BorderSide(color: Colors.white.withValues(alpha: .3), width: .7),
        bottom: BorderSide(
          color: Colors.white.withValues(alpha: .3),
          width: .7,
        ),
      ),
    );
  }
}
