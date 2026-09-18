import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/monthlyAttendanceRequest.dart';
import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:cristalteacher/features/attendance/presentation/widgets/attendanceRowWrapper.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/appdata/appdata.dart';
import 'monthly_attendance_report_screen.dart';

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------
const _purple = Color(0xFF7B6EF6);
const _purpleDark = Color(0xFF6C5CE7);
const _presentGreenBg = Color(0xFFE3F7EA);
const _presentGreenText = Color(0xFF2FAE60);
const _absentRedBg = Color(0xFFFCEAEA);
const _absentRedText = Color(0xFFE05656);
const _bg = Color(0xFFF6F5FB);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class MonthlyAttendanceScreen extends StatefulWidget {
  const MonthlyAttendanceScreen({super.key});

  static const double _nameColWidth = 150;
  static const double _dayColWidth = 40;

  @override
  State<MonthlyAttendanceScreen> createState() => _MonthlyAttendanceScreenState();
}
List<TutorshipClass> tutorshipClasses = [];
List<TutorshipClass> standards = [];

List<DivisionDetails> divisions = [];
int? selectedStandardId;
int? selectedDivisionId;
String? selectedDivision;
String? selectedStandard;
class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {
  // Keep the last-requested params around so we know which month/accYear to
  // use when turning "DayN" keys into real weekday labels.
  late MonthlyAttendanceRequest _currentRequest;

  @override
  void initState() {
    super.initState();
    tutorshipClasses = List<TutorshipClass>.from(AppData.tutorshipClasses);
    print('tutorshipClasses ${tutorshipClasses.first}');
    standards = _uniqueStandards();
    if (standards.isNotEmpty) {
      TutorshipClass? firstStandard;
      DivisionDetails? firstDivision;


      List<DivisionDetails> firstDivisions = [];

      for (final standard in standards) {
        final List<DivisionDetails> standardDivisions = _divisionsFor(
          standard.standardId,
        );

        if (standardDivisions.isNotEmpty) {
          firstStandard = standard;
          firstDivisions = standardDivisions;
          firstDivision = standardDivisions.first;
          break;
        }
      }

      if (firstStandard != null && firstDivision != null) {
        selectedStandardId = firstStandard.standardId;
        selectedStandard = firstStandard.standard;

        divisions = firstDivisions;

        selectedDivisionId = firstDivision.divisionId;
        selectedDivision = firstDivision.division;
      }
    }
    _currentRequest = MonthlyAttendanceRequest(
      month: 9,
      accYear: '2026-2027',
      standardId: null,
      divisionId: null,
      branchId: 1,
    );
    context.read<AttendanceCubit>().fetchMonthlyAttendanceReport(_currentRequest);
  }
  void _selectStandard(int? standardId) {
    if (standardId == null) {
      return;
    }

    TutorshipClass? selectedItem;

    for (final standard in standards) {
      if (standard.standardId == standardId) {
        selectedItem = standard;
        break;
      }
    }

    if (selectedItem == null) {
      return;
    }

    final List<DivisionDetails> newDivisions = _divisionsFor(standardId);

    setState(() {
      selectedStandardId = selectedItem!.standardId;
      selectedStandard = selectedItem.standard;

      divisions = newDivisions;

      if (newDivisions.isNotEmpty) {
        selectedDivisionId = newDivisions.first.divisionId;
        selectedDivision = newDivisions.first.division;
      } else {
        selectedDivisionId = null;
        selectedDivision = null;
      }
    });
  }

  void _selectDivision(int? divisionId) {
    if (divisionId == null) {
      return;
    }

    DivisionDetails? selectedItem;

    for (final division in divisions) {
      if (division.divisionId == divisionId) {
        selectedItem = division;
        break;
      }
    }

    if (selectedItem == null) {
      return;
    }

    setState(() {
      selectedDivisionId = selectedItem!.divisionId;
      selectedDivision = selectedItem.division;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _purple,
        elevation: 0,
        titleSpacing: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('10A Attendance',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.tune, color: _purple),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter row
          Container(
            color: _purple,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(child: _FilterBox(icon: Icons.calendar_month, label: 'Month')),
                    SizedBox(width: 10),
                    Expanded(child: _FilterBox(icon: Icons.calendar_today, label: 'Academic Year')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child:_buildStandardDropdown()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildDivisionDropdown()),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black38),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Search', border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Table + footer, both driven off the SAME BlocConsumer so the
          // footer's day columns always match the table's day columns.
          Expanded(
            child: BlocConsumer<AttendanceCubit, AttendanceState>(
              listener: (context, state) {
                if (state is MonthlyAttendanceReportFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is MonthlyAttendanceReportLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MonthlyAttendanceReportFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                          const SizedBox(height: 12),
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.read<AttendanceCubit>().fetchMonthlyAttendanceReport(_currentRequest),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is! MonthlyAttendanceReportSuccess) {
                  // Initial / not-yet-loaded state
                  return const Center(child: CircularProgressIndicator());
                }

                final result = state.response;

                // *** dates now come from the result, not a hardcoded list ***
                final columns = AttendanceRowMapper.buildColumns(
                  result.data,
                  _currentRequest.month,
                  _currentRequest.accYear,
                );
                final students = AttendanceRowMapper.mapRows(result.data, columns);

                if (columns.isEmpty || students.isEmpty) {
                  return const Center(child: Text('No attendance data for this selection.'));
                }

                final presentTotals = AttendanceRowMapper.presentTotalsPerDay(students, columns.length);
                final absentTotals = AttendanceRowMapper.absentTotalsPerDay(students, columns.length);

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MonthlyAttendanceScreen._nameColWidth + MonthlyAttendanceScreen._dayColWidth * columns.length,
                          child: Column(
                            children: [
                              _HeaderRow(
                                columns: columns,
                                nameColWidth: MonthlyAttendanceScreen._nameColWidth,
                                dayColWidth: MonthlyAttendanceScreen._dayColWidth,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: students.length,
                                  itemBuilder: (context, index) => _StudentRow(
                                    student: students[index],
                                    columns: columns,
                                    index: index,
                                    nameColWidth: MonthlyAttendanceScreen._nameColWidth,
                                    dayColWidth: MonthlyAttendanceScreen._dayColWidth,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: _purple,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MonthlyAttendanceScreen._nameColWidth + MonthlyAttendanceScreen._dayColWidth * columns.length,
                          child: Column(
                            children: [
                              _TotalsRow(
                                label: 'Present',
                                totals: presentTotals,
                                columns: columns,
                                colWidth: MonthlyAttendanceScreen._dayColWidth,
                                nameColWidth: MonthlyAttendanceScreen._nameColWidth,
                              ),
                              _TotalsRow(
                                label: 'Absent',
                                totals: absentTotals,
                                columns: columns,
                                colWidth: MonthlyAttendanceScreen._dayColWidth,
                                nameColWidth: MonthlyAttendanceScreen._nameColWidth,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStandardDropdown() {
    final List<DropdownMenuItem<int>> items = standards.map((standard) {
      return DropdownMenuItem<int>(
        value: standard.standardId,
        child: Text(
          standard.standard ?? '',
          style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
        ),
      );
    }).toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedStandardId,
    );

    return _buildFilterStyleDropdown(
      icon: Icons.class_,
      label: 'Standard',
      child: InkWell(
        onTap: items.isEmpty
            ? null
            : () async {
          final PickerSelection<int>? result =
          await showOptionPickerSheet<int>(
            context: context,
            title: 'Select Standard',
            items: items,
            selectedValue: selectedStandardId,
          );

          if (!mounted || result == null) return;
          _selectStandard(result.value);
        },
        child: Row(
          children: [
            Expanded(
              child: selectedItem?.child ??
                  const Text('Select', style: TextStyle(fontSize: 14, color: Color(0xFF777777))),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
          ],
        ),
      ),
    );
  }
  Widget _buildDivisionDropdown() {
    final List<DropdownMenuItem<int>> items = divisions.map((division) {
      return DropdownMenuItem<int>(
        value: division.divisionId,
        child: Text(
          division.division ?? '',
          style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
        ),
      );
    }).toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedDivisionId,
    );

    return _buildFilterStyleDropdown(
      icon: Icons.groups,
      label: 'Division',
      child: InkWell(
        onTap: items.isEmpty
            ? null
            : () async {
          final PickerSelection<int>? result =
          await showOptionPickerSheet<int>(
            context: context,
            title: 'Select Division',
            items: items,
            selectedValue: selectedDivisionId,
          );

          if (!mounted || result == null) return;
          _selectDivision(result.value);
        },
        child: Row(
          children: [
            Expanded(
              child: selectedItem?.child ??
                  const Text('Select', style: TextStyle(fontSize: 14, color: Color(0xFF777777))),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
          ],
        ),
      ),
    );
  }
  List<TutorshipClass> _uniqueStandards() {
    final Map<int, TutorshipClass> unique = {};

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId != null) {
        unique.putIfAbsent(item.standardId!, () => item);
      }
    }

    return unique.values.toList();
  }
  /// Every division of [standardId], merged across all entries that carry
  /// that standard and deduplicated by division id.
  List<DivisionDetails> _divisionsFor(int? standardId) {
    if (standardId == null) {
      return <DivisionDetails>[];
    }

    final Map<int, DivisionDetails> unique = {};

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId != standardId) {
        continue;
      }

      for (final DivisionDetails division
      in item.division ?? const <DivisionDetails>[]) {
        if (division.divisionId != null) {
          unique.putIfAbsent(division.divisionId!, () => division);
        }
      }
    }

    return unique.values.toList();
  }

  Widget _buildFilterStyleDropdown({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _purple),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}


Widget _buildDropdownContainer({
  required String label,
  required Widget child,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 6, bottom: 10),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: child,
      ),
    ],
  );
}
// ---------------------------------------------------------------------------
// Pieces
// ---------------------------------------------------------------------------
class _FilterBox extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FilterBox({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _purple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final List<DayColumn> columns;
  final double nameColWidth;
  final double dayColWidth;
  const _HeaderRow({required this.columns, required this.nameColWidth, required this.dayColWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: _bg,
      child: Row(
        children: [
          SizedBox(
            width: nameColWidth,
            child: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Student', style: TextStyle(color: _purple, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          for (final col in columns)
            SizedBox(
              width: dayColWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(col.dateLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: col.isSunday ? Colors.black26 : _purpleDark,
                      )),
                  Text(col.dayLabel,
                      style: TextStyle(fontSize: 10, color: col.isSunday ? Colors.black26 : Colors.black45)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final StudentAttendance student;
  final List<DayColumn> columns;
  final int index;
  final double nameColWidth;
  final double dayColWidth;

  const _StudentRow({
    required this.student,
    required this.columns,
    required this.index,
    required this.nameColWidth,
    required this.dayColWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bg = index.isEven ? Colors.white : const Color(0xFFF6F5FB);
    return Container(
      height: 56,
      color: bg,
      child: Row(
        children: [
          SizedBox(
            width: nameColWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: student.avatarColor,
                    child: Text(
                      student.initial,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      student.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // student.days is already aligned 1:1 with `columns`
          for (final day in student.days)
            SizedBox(
              width: dayColWidth,
              child: Center(child: _StatusChip(status: day.status)),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DayAttendanceStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    print('status $status');
    switch (status) {
      case DayAttendanceStatus.present:
        return _chip('P', _presentGreenBg, _presentGreenText);
      case DayAttendanceStatus.absent:
        return _chip('A', _absentRedBg, _absentRedText);
      case DayAttendanceStatus.holiday:
        return const Text('—', style: TextStyle(color: Colors.black26));
    }
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String label;
  final List<int> totals;
  final List<DayColumn> columns;
  final double colWidth;
  final double nameColWidth;
  const _TotalsRow({
    required this.label,
    required this.totals,
    required this.columns,
    required this.colWidth,
    required this.nameColWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white24, width: 0.6))),
      child: Row(
        children: [
          SizedBox(
            width: nameColWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          for (int i = 0; i < totals.length; i++)
            SizedBox(
              width: colWidth,
              child: Center(
                child: columns[i].isSunday
                    ? const Text('—', style: TextStyle(color: Colors.white38))
                    : Text('${totals[i]}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}