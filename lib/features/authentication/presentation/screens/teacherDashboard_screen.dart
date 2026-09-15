import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/attendance/presentation/screens/attendance_report_new.dart';
import 'package:cristalteacher/features/attendance/presentation/screens/attendance_report_screen.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/authentication/domain/entities/teacher_dashboard_result.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_teacherdashboard_request.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/diary/presentation/screens/diary_screen.dart';
import 'package:cristalteacher/features/earlygoing/presentation/screens/gatepass_screen.dart';
import 'package:cristalteacher/features/exam/presentation/screens/exam_listing_screen.dart';
import 'package:cristalteacher/features/exams/presentation/screens/exam_screen.dart';
import 'package:cristalteacher/features/feed/presentation/screens/feed_screen.dart';
import 'package:cristalteacher/features/materials/presentation/screens/materials_screen.dart';
import 'package:cristalteacher/features/timetable/presentation/screens/timetable_screen.dart';
import 'package:cristalteacher/features/tutorprofile/presentation/screens/tutor_profile_screen.dart';
import 'package:cristalteacher/features/workplan/presentation/screens/workplan_detials_screen.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: point this at wherever TeacherDashboardResult / Datum / TodayPeriod
// actually live in your project (the model you pasted earlier).

class TeacherDashboardNewPage extends StatefulWidget {
  const TeacherDashboardNewPage({super.key});

  @override
  State<TeacherDashboardNewPage> createState() =>
      _TeacherDashboardNewPageState();
}

class _TeacherDashboardNewPageState extends State<TeacherDashboardNewPage> {
  @override
  void initState() {
    AppData.teacherSubject = '';
    _loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const TeacherDashboardScreen(),
    );
  }

  Future<void> _loadInitialData() async {
    final pref = SharedPreferenceHelper();

    final login = await pref.getLoginResponse();

    if (login == null) return;

    AppData.employeeId = login.data?.user?.employeeId;
    AppData.userId = login.data?.user?.id;
    AppData.teacherName = login.data?.user!.name;

    // NOTE: fetchTeacherDashboard needs AppData.accYear, which fetchAccYear()
    // sets asynchronously. Do NOT call fetchTeacherDashboard here — it must
    // fire only after FetchAccYearSuccess arrives (see the listener below),
    // otherwise AppData.accYear! will throw a null-check error.
    context.read<AuthenticationCubit>().fetchAccYear();
  }
}

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  static const Color deepBlue = Color(0xFF1B2A6B);
  static const Color accentPurple = Color(0xFF6C4CE0);
  static const Color cardNavy = Color(0xFF25336E);

  // Populated once FetchTeacherDashboardSuccess arrives — kept in State so
  // the values survive later bloc state changes (e.g. loading states).
  String _classInCharge = '';
  String _divisionInCharge = '';
  int _studentCount = 0;
  String _staffCode = '';
  List<TodayPeriod> _todayPeriods = [];
  bool _dashboardLoading = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is FetchAccYearSuccess) {
          final academicYears = state.response.data ?? [];

          String? activeAccYear;

          for (final year in academicYears) {
            if (year.status == true) {
              activeAccYear = year.accYear;
              break;
            }
          }

          if (activeAccYear == null && academicYears.isNotEmpty) {
            activeAccYear = academicYears.first.accYear;
          }

          if (activeAccYear != null) {
            AppData.accYear = activeAccYear;

            debugPrint("Academic Year : ${AppData.accYear}");

            context.read<AuthenticationCubit>().fetchTutorshipClass(
              FetchTutorshipClassRequest(
                accyear: AppData.accYear,
                employeeId: AppData.employeeId,
                userId: AppData.userId,
              ),
            );

            // Fired here — the first point where AppData.accYear and
            // AppData.employeeId are guaranteed to be non-null.
            context.read<AuthenticationCubit>().fetchTeacherDashboard(
              TeacherDashboardRequest(
                accYear: AppData.accYear!,
                employeeId: AppData.employeeId!,
                branchId: 1,
              ),
            );
          }
        }

        if (state is FetchAccYearFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is FetchTutorshipClassSuccess) {
          final responseData = state.response.data;

          AppData.saveTutorshipData(
            tutorshipList: responseData?.tutorshipClass ?? <TutorshipClass>[],
            standardList: responseData?.standard ?? <TutorshipClass>[],
          );

          debugPrint('===================================');
          debugPrint('TUTORSHIP DATA SAVED');
          debugPrint('Employee ID: ${AppData.employeeId}');
          debugPrint('Tutorship classes: ${AppData.tutorshipClasses.length}');
          debugPrint('Standards: ${AppData.standards.length}');
          debugPrint('===================================');
        }

        if (state is FetchTutorshipClassFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        // ---- Teacher dashboard result: drives the stats + class cards ----
        if (state is FetchDashboardSuccess) {
          final TeacherDashboardResult result = state.response;
          final list = result.data;
          if (list.isNotEmpty) {
            final datum = list.first;
            setState(() {
              _classInCharge = datum.classInCharge;
              _divisionInCharge = datum.divisionInCharge;
              _studentCount = datum.studentCountInCharge;
              _staffCode = datum.employeeCode;
              _todayPeriods = datum.todayPeriods;
              _dashboardLoading = false;
              AppData.teacherSubject = datum.classChargeSubjects;
            });
          } else {
            setState(() => _dashboardLoading = false);
          }
          debugPrint("Teacher Dashboard Loaded");
        }

        if (state is FetchDashboardFailure) {
          setState(() => _dashboardLoading = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: SingleChildScrollView(
            child: Container(
              // ---- Single continuous gradient for the whole page ----
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF004BBC),
                    Color(0xFF9BB9E5),
                    Color(0xFFF4F6FB),
                  ],
                  stops: [0.0, 0.42, 0.78],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _ProfileRow(),
                          const SizedBox(height: 20),
                          _dashboardLoading
                              ? const _CardLoadingSkeleton()
                              : _CombinedCard(
                                  accentPurple: accentPurple,
                                  cardNavy: cardNavy,
                                  classAndDivision: _classInCharge.isEmpty
                                      ? '-'
                                      : '$_classInCharge $_divisionInCharge',
                                  studentCount: _studentCount,
                                  staffCode: _staffCode.isEmpty
                                      ? '-'
                                      : _staffCode,
                                  todayPeriods: _todayPeriods,
                                ),
                          const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                  // ---- Quick Access ----
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Access',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 0),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.98,
                          children: const [
                            _QuickAccessItem(
                              imagePath: 'assets/images/diary.png',
                              label: 'Diary',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/material.png',
                              label: 'Material',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/feed.png',
                              label: 'Feed',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/attendance.png',
                              label: 'Attendance',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/exam.png',
                              label: 'MarkEntry',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/timetable.png',
                              label: 'Time Table',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/gatepass.png',
                              label: 'Gate Pass',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/workplan.png',
                              label: 'Work Plan',
                            ),
                            _QuickAccessItem(
                              imagePath: 'assets/images/exam.png',
                              label: 'Exam',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeacherProfileScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            Container(
              // Outer white ring
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                // Inner white ring (creates the "layered" double-ring look)
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                    'assets/images/defaultstudent.png',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppData.teacherName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppData.teacherSubject!,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown in place of the card while the teacher-dashboard request is
/// in flight, so the layout doesn't jump once data arrives.
class _CardLoadingSkeleton extends StatelessWidget {
  const _CardLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: Colors.white),
    );
  }
}

/// One rounded card containing BOTH the white stats section on top and the
/// dark navy schedule section on the bottom, with a single sharp boundary
/// between them (no gap, no blur, no color bleed) and one outer shadow.
class _CombinedCard extends StatelessWidget {
  final Color accentPurple;
  final Color cardNavy;
  final String classAndDivision;
  final int studentCount;
  final String staffCode;
  final List<TodayPeriod> todayPeriods;

  const _CombinedCard({
    required this.accentPurple,
    required this.cardNavy,
    required this.classAndDivision,
    required this.studentCount,
    required this.staffCode,
    required this.todayPeriods,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- White stats section (top) ----
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    icon: Icons.apartment_rounded,
                    label: 'Class & Division',
                    value: classAndDivision,
                    accentPurple: accentPurple,
                  ),
                  _VerticalDivider(),
                  _StatItem(
                    icon: Icons.groups_rounded,
                    label: 'Students',
                    value: '$studentCount',
                    accentPurple: accentPurple,
                  ),
                  _VerticalDivider(),
                  _StatItem(
                    icon: Icons.badge_rounded,
                    label: 'Staff Code',
                    value: staffCode,
                    accentPurple: accentPurple,
                  ),
                ],
              ),
            ),
            // ---- Dark navy schedule section (bottom) ----
            Container(
              width: double.infinity,
              color: Color(0xFF004BBC),

              padding: const EdgeInsets.all(18),
              child: _ScheduleContent(todayPeriods: todayPeriods),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 60, width: 1, color: Colors.grey.shade200);
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentPurple;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentPurple,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A6B),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drop-in replacement for _ScheduleContent, _DottedConnector, and _ClassCard
// in your TeacherDashboardNewPage file. Matches the screenshot:
//   - "Today You Have" + "View Full Schedule" link restored
//   - Each class card shows TIME on top, then bold Class/Division, then Subject
//   - Cards have a subtle blue gradient + rounded border (not flat white24)
//   - Green check badge overlaps the bottom edge of the card
//   - Dotted connector between cards
//
// ⚠️ TODO: Replace `p.startTimeDisplay` below with whatever your TodayPeriod
// model actually calls its start-time field (e.g. p.startTime, p.fromTime,
// p.periodTime). I used a placeholder name since I don't have that model.
// ---------------------------------------------------------------------------

class _ScheduleContent extends StatelessWidget {
  final List<TodayPeriod> todayPeriods;

  const _ScheduleContent({required this.todayPeriods});

  static const double _rowHeight = 130;
  static const double _cardHeight = 118;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFF004BBC),
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Today You Have',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TimeTableScreen()),
                );
              },
              child: const Text(
                'View Full Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Text(
            '${todayPeriods.length} Classes',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (todayPeriods.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No classes scheduled today',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          )
        else
          SizedBox(
            height: _rowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: todayPeriods.length,
              separatorBuilder: (_, __) => const SizedBox(
                width: 27,
                height: _rowHeight,
                // Pin the connector to the SAME reference frame as the card
                // (top-aligned, exactly _cardHeight tall) instead of letting
                // it center inside the full 130px row.
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: _cardHeight,
                    child: _DottedConnector(),
                  ),
                ),
              ),
              itemBuilder: (context, index) {
                final p = todayPeriods[index];
                final classAndDivision = [
                  p.todayPeriodClass,
                  p.division,
                ].where((s) => s.trim().isNotEmpty).join(' ');
                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 90,
                    height: _cardHeight, // <- exact content height, not 130
                    child: _ClassCard(
                      time: '', // TODO: p.startTime / whatever your field is
                      classAndDivision: classAndDivision.isEmpty
                          ? '-'
                          : classAndDivision,
                      subject: p.subject,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Horizontal dashed line, positioned so its dots sit at the SAME vertical
/// center as the green badge below each card (badge sits ~6px below the
/// card's bottom edge — this mirrors that offset, adjusted for the dot's
/// own (smaller) height so the visual centers line up).
class _DottedConnector extends StatelessWidget {
  const _DottedConnector();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 52, // tweak by eye ±2px if it's not dead-center on the badge
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String time;
  final String classAndDivision;
  final String subject;

  const _ClassCard({
    required this.time,
    required this.classAndDivision,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 90,
          height: 118,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.14),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white38, width: 1.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  time,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  classAndDivision,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subject,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        // Explicit left/right + Center — no longer relies on Stack alignment.
        Positioned(
          bottom: -10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF25336E), width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// Time is intentionally skipped — shows only the combined class/division
/// (e.g. "10 A") and the subject.
// class _ClassCard extends StatelessWidget {
//   final String classAndDivision;
//   final String subject;
//
//   const _ClassCard({
//     required this.classAndDivision,
//     required this.subject,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.bottomCenter,
//       children: [
//         // Fixed size for every card, regardless of text length — long
//         // subject names truncate with an ellipsis instead of overflowing.
//         SizedBox(
//           width: 110,
//           height: 125,
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white24),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   classAndDivision,
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   subject,
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Colors.white70, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 10,
//           child: Container(
//             padding: const EdgeInsets.all(3),
//             decoration: const BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.check, color: Colors.white, size: 15),
//           ),
//         ),
//       ],
//     );
//   }
// }

class _QuickAccessItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;

  const _QuickAccessItem({this.icon, this.imagePath, required this.label})
    : assert(
        icon != null || imagePath != null,
        'Provide either an icon or an imagePath',
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (label == 'Material') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MaterialsScreen()),
              );
            }
            if (label == 'Feed') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FeedScreen()),
              );
            }
            if (label == 'Diary') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DiaryTypeScreen()),
              );
            }
            if (label == 'Attendance') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AttendanceReportScreen()),
                //AttendanceDemoApp()),
                //AttendanceReportScreen()),
              );
            }
            if (label == 'MarkEntry') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExamScreen()),
              );
            }
            if (label == 'Time Table') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TimeTableScreen()),
              );
            }
            if (label == 'Gate Pass') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GatePassScreen()),
              );
            }
            if (label == 'Work Plan') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WorkplanDetialsScreen()),
              );
            }
            if (label == 'Exam') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExamListingScreen()),
              );
            }
          },
          child: Container(
            height: 76,
            width: 76,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(16),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.06),
            //       blurRadius: 8,
            //       offset: const Offset(0, 4),
            //     ),
            //   ],
            // ),
            child: imagePath != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, right: 8),
                    child: Image.asset(imagePath!, fit: BoxFit.contain),
                  )
                : Icon(icon, color: const Color(0xFF6C4CE0), size: 26),
          ),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
