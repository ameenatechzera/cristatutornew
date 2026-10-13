import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/attendance_report_parameter.dart';
import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:cristalteacher/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:cristalteacher/features/attendance/presentation/screens/studentattendance_screen.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  static const Color primaryColor = Color(0xFF5D24F4);
  static const Color blueColor = Color(0xFF0758C9);
  static const Color lightPurple = Color(0xFFF7F3FF);
  static const Color borderColor = Color(0xFFE1E1E1);

  String? selectedStandardId;

  // ============================================================
  // DATE VARIABLES
  // ============================================================

  late DateTime fromDate;
  late DateTime toDate;

  List<TutorshipClass> tutorshipClasses = [];

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // SET CURRENT DATE INITIALLY
    // ==========================================================

    final today = DateTime.now();

    fromDate = DateTime(today.year, today.month, today.day);

    toDate = DateTime(today.year, today.month, today.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  // ============================================================
  // INITIAL API CALLS
  // ============================================================

  void _fetchInitialData() {
    _fetchTutorshipClasses();

    // Fetch attendance for today's date
    _fetchAttendanceReport();
  }

  // ============================================================
  // FETCH TUTORSHIP CLASSES
  // ============================================================

  void _fetchTutorshipClasses() {
    debugPrint('📘 Fetching Tutorship Classes');

    context.read<AuthenticationCubit>().fetchTutorshipClass(
      FetchTutorshipClassRequest(
        accyear: AppData.accYear,
        employeeId: AppData.employeeId,
        userId: AppData.userId,
      ),
    );
  }

  // ============================================================
  // FETCH ATTENDANCE REPORT
  // ============================================================

  void _fetchAttendanceReport() {
    final String from = _formatApiDate(fromDate);
    final String to = _formatApiDate(toDate);

    debugPrint('====================================');
    debugPrint('📘 Fetching Attendance Report');
    debugPrint('From Date : $from');
    debugPrint('To Date   : $to');
    debugPrint('====================================');

    final request = AttendanceReportParameter(
      branchId: AppData.branchId ?? 1,
      fromDate: from,
      toDate: to,
      userId: AppData.userId!,
      accYear: AppData.accYear!,
    );

    context.read<AttendanceCubit>().fetchAttendanceReport(request);
  }

  // ============================================================
  // API DATE FORMAT
  // ============================================================

  String _formatApiDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ========================================================
        // TUTORSHIP LISTENER
        // ========================================================
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is FetchTutorshipClassSuccess) {
              debugPrint('✅ Tutorship Class Loaded');

              setState(() {
                tutorshipClasses = state.response.data?.tutorshipClass ?? [];
              });
            }

            if (state is FetchTutorshipClassFailure) {
              debugPrint('❌ Tutorship Class Failed: ${state.message}');

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),

        // ========================================================
        // ATTENDANCE LISTENER
        // ========================================================
        BlocListener<AttendanceCubit, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceReportSuccess) {
              debugPrint('✅ Attendance Report Loaded');

              debugPrint('Total reports: ${state.response.data?.length ?? 0}');
            }

            if (state is AttendanceReportFailure) {
              debugPrint('❌ Attendance Report Failed: ${state.message}');

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }

            // if (state is SaveAttendanceSuccess) {
            //   _fetchAttendanceReport();
            // }
          },
        ),
      ],

      // ==========================================================
      // ATTENDANCE BUILDER
      // ==========================================================
      child: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, attendanceState) {
          return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),

            // ====================================================
            // APP BAR
            // ====================================================
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 58,

              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 23,
                ),
              ),

              title: const Text(
                'Attendance',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ====================================================
            // BODY
            // ====================================================
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  // ==================================================
                  // FILTER SECTION
                  // ==================================================
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),

                    child: Column(
                      children: [
                        // ==================================================
                        // STANDARD DROPDOWN
                        // ==================================================

                        // _buildStandardDropdown(),
                        const SizedBox(height: 12),

                        // ==================================================
                        // DATE FILTERS
                        // ==================================================
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                title: 'From date',
                                date: fromDate,
                                onTap: () {
                                  _selectDate(isFromDate: true);
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _buildDateField(
                                title: 'To date',
                                date: toDate,
                                onTap: () {
                                  _selectDate(isFromDate: false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // REPORT LIST
                  // ==================================================
                  Expanded(child: _buildAttendanceReports(attendanceState)),
                ],
              ),
            ),

            // ====================================================
            // ADD ATTENDANCE
            // ====================================================
            floatingActionButton: SizedBox(
              width: 56,
              height: 56,

              child: FloatingActionButton(
                onPressed: _addAttendance,
                backgroundColor: blueColor,
                elevation: 4,
                shape: const CircleBorder(),

                child: const Icon(Icons.add, color: Colors.white, size: 34),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // ATTENDANCE REPORT LIST
  // ============================================================

  Widget _buildAttendanceReports(AttendanceState state) {
    // ==========================================================
    // LOADING
    // ==========================================================

    if (state is AttendanceReportLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    if (state is AttendanceReportFailure) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // ==========================================================
    // NO DATA
    // ==========================================================

    if (state is! AttendanceReportSuccess) {
      return const Center(
        child: Text(
          'No attendance reports found',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // ==========================================================
    // API RESPONSE
    // ==========================================================

    final attendanceData = state.response.data ?? [];

    debugPrint('Displaying ${attendanceData.length} reports');

    // ==========================================================
    // EMPTY RESPONSE
    // ==========================================================

    if (attendanceData.isEmpty) {
      return const Center(
        child: Text(
          'No attendance reports found',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // ==========================================================
    // DISPLAY API RESPONSE DIRECTLY
    // ==========================================================

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),

      itemCount: attendanceData.length,

      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        final report = attendanceData[index];

        return _buildAttendanceCard(report);
      },
    );
  }

  // ============================================================
  // ATTENDANCE CARD
  // ============================================================

  Widget _buildAttendanceCard(dynamic report) {
    final reportDate = _parseDate(report.date);

    return InkWell(
      onTap: () {
        debugPrint(
          'Attendance ID: '
          '${report.studentattendanceMasterId}',
        );
      },

      borderRadius: BorderRadius.circular(12),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.fromLTRB(11, 11, 11, 9),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: const Color(0xFFDDDDDD)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // ID
            // ==================================================
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 5,
            //         vertical: 2,
            //       ),

            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF2EEFF),
            //         borderRadius: BorderRadius.circular(3),
            //       ),

            //       child: Text(
            //         '#${report.studentattendanceMasterId ?? ''}',

            //         style: const TextStyle(
            //           color: primaryColor,
            //           fontSize: 13,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEFF),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '#${report.studentattendanceMasterId ?? ''}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () async {
                    final int? masterId = int.tryParse(
                      report.studentattendanceMasterId.toString(),
                    );

                    final int standardId =
                        int.tryParse(report.standardId.toString()) ?? 0;

                    final int divisionId =
                        int.tryParse(report.divisionId.toString()) ?? 0;

                    final DateTime attendanceDate = _parseDate(report.date);

                    if (masterId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Attendance ID is not available'),
                        ),
                      );

                      return;
                    }

                    await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => StudentAttendanceScreen(
                          // This tells the screen it is edit mode.
                          studentAttendanceMasterId: masterId,

                          attendanceDate: attendanceDate,
                          standardId: standardId,
                          standard: report.standard?.toString() ?? '',
                          divisionId: divisionId,
                          division: report.division?.toString() ?? '',
                          section: 'Morning',
                          narration: report.narration?.toString() ?? '',
                        ),
                      ),
                    );

                    if (!mounted) {
                      return;
                    }
                    _fetchAttendanceReport();
                  },
                  // onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  //   return StudentAttendanceScreen(attendanceDate: attendanceDate, standardId: standardId, standard: standard, divisionId: divisionId, division: division, section: section, narration: narration)
                  // }))},
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9B8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Group (6).svg',
                          width: 13,
                          height: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // ==================================================
            // DATE
            // ==================================================
            Text(
              _formatDate(reportDate),

              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Attendance',

              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 11),

            // ==================================================
            // STANDARD / DIVISION / SECTION
            // ==================================================
            Container(
              height: 64,

              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: _buildAttendanceInfo(
                      assetPath: 'assets/icons/Group 951.svg',
                      title: 'Standard',
                      value: report.standard ?? '',
                    ),
                  ),

                  _buildDivider(),

                  Expanded(
                    child: _buildAttendanceInfo(
                      assetPath: 'assets/icons/Group (17).svg',
                      title: 'Division',
                      value: report.division ?? '',
                    ),
                  ),

                  _buildDivider(),

                  Expanded(
                    child: _buildAttendanceInfo(
                      assetPath: 'assets/icons/Group (18).svg',
                      title: 'Section',
                      value: '-',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ATTENDANCE INFO
  // ============================================================

  Widget _buildAttendanceInfo({
    required String assetPath,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 25,
                height: 25,

                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),

                alignment: Alignment.center,

                child: SvgPicture.asset(assetPath, width: 13, height: 13),
              ),

              const SizedBox(width: 5),

              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(color: Color(0xFF666666), fontSize: 9),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE FIELD
  // ============================================================

  Widget _buildDateField({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),

      child: Container(
        height: 42,

        padding: const EdgeInsets.symmetric(horizontal: 9),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: borderColor),
        ),

        child: Row(
          children: [
            buildPurpleIcon(
              'assets/icons/Group (15).svg',
              iconColor: const Color(0xFF8561E1),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                _formatDate(date),
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate({required bool isFromDate}) async {
    final DateTime initialDate = isFromDate ? fromDate : toDate;

    final DateTime? selectedDate = await showDatePicker(
      context: context,

      initialDate: initialDate,

      firstDate: DateTime(2020),

      lastDate: DateTime(2040),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),

          child: child!,
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    // ==========================================================
    // FROM DATE
    // ==========================================================

    if (isFromDate) {
      if (selectedDate.isAfter(toDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('From date cannot be after to date')),
        );

        return;
      }

      setState(() {
        fromDate = selectedDate;
      });

      // Fetch API with new date range.
      _fetchAttendanceReport();

      return;
    }

    // ==========================================================
    // TO DATE
    // ==========================================================

    if (selectedDate.isBefore(fromDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('To date cannot be before from date')),
      );

      return;
    }

    setState(() {
      toDate = selectedDate;
    });

    // Fetch API with new date range.
    _fetchAttendanceReport();
  }

  // ============================================================
  // PARSE DATE
  // ============================================================

  DateTime _parseDate(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime.now();
    }

    return DateTime.tryParse(date) ?? DateTime.now();
  }

  // ============================================================
  // DISPLAY DATE
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  // ============================================================
  // PURPLE ICON
  // ============================================================

  Widget buildPurpleIcon(
    String assetPath, {
    double size = 28,
    double iconSize = 15,
    Color iconColor = primaryColor,
    Color backgroundColor = lightPurple,
  }) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),

      alignment: Alignment.center,

      child: SvgPicture.asset(
        assetPath,
        width: iconSize,
        height: iconSize,

        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }

  // ============================================================
  // ADD ATTENDANCE
  // ============================================================

  Future<void> _addAttendance() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AttendanceScreen()));

    if (!mounted) {
      return;
    }

    _fetchAttendanceReport();
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return Container(width: 1, height: 39, color: const Color(0xFFE9E1FA));
  }
}
