// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/attendance/domain/entities/fetch_attendancedetails_entity.dart';
// import 'package:cristalteacher/features/attendance/domain/entities/studentattendance_response_enttiy.dart';
// import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
// import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
// import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';
// import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class StudentAttendanceScreen extends StatefulWidget {
//   final int? studentAttendanceMasterId;
//   final DateTime attendanceDate;
//   final int standardId;
//   final String standard;
//   final int divisionId;
//   final String division;
//   final String section;
//   final String narration;

//   const StudentAttendanceScreen({
//     super.key,
//     this.studentAttendanceMasterId,
//     required this.attendanceDate,
//     required this.standardId,
//     required this.standard,
//     required this.divisionId,
//     required this.division,
//     required this.section,
//     required this.narration,
//   });

//   @override
//   State<StudentAttendanceScreen> createState() =>
//       _StudentAttendanceScreenState();
// }

// class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
//   final TextEditingController searchController = TextEditingController();

//   String searchText = '';
//   bool showSearchField = false;

//   // Admission number is used as the unique key.
//   final Map<String, bool> attendanceStatus = {};
//   final Map<String, String?> leaveTypes = {};
//   final Map<String, String> remarks = {};

//   // Add mode student list.
//   List<AttendanceDetailsData> addModeStudents = [];

//   // Edit mode student list.
//   List<StudentAttendanceDetailEntity> editModeStudents = [];

//   bool addDataInitialized = false;
//   bool editDataInitialized = false;

//   bool get isEditMode => widget.studentAttendanceMasterId != null;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchStudents();
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   // ============================================================
//   // FETCH STUDENTS
//   // ============================================================

//   void _fetchStudents() {
//     if (isEditMode) {
//       _fetchEditAttendance();
//     } else {
//       _fetchAddAttendanceStudents();
//     }
//   }

//   void _fetchAddAttendanceStudents() {
//     final String? accYear = AppData.accYear;

//     if (accYear == null || accYear.trim().isEmpty) {
//       _showMessage('Academic year is not available');
//       return;
//     }

//     final request = AttendanceDetailsRequest(
//       accyear: accYear,
//       standard: widget.standardId,
//       division: widget.divisionId,
//       gender: AppData.gender,
//       sortBy: 'alphabetic',
//     );

//     debugPrint('==========================================');
//     debugPrint('ADD MODE - FETCH ATTENDANCE DETAILS');
//     debugPrint('Request: ${request.toJson()}');
//     debugPrint('==========================================');

//     context.read<AttendanceCubit>().fetchAttendanceDetails(request);
//   }

//   void _fetchEditAttendance() {
//     final int? masterId = widget.studentAttendanceMasterId;

//     if (masterId == null) {
//       _showMessage('Attendance ID is not available');
//       return;
//     }

//     debugPrint('==========================================');
//     debugPrint('EDIT MODE - FETCH STUDENT ATTENDANCE');
//     debugPrint('Master ID: $masterId');
//     debugPrint('==========================================');

//     context.read<AttendanceCubit>().fetchStudentAttendance(masterId);
//   }

//   // ============================================================
//   // INITIALIZE ADD MODE DATA
//   // ============================================================

//   void _initializeAddMode(AttendanceDetailsEntity response) {
//     final students = response.data ?? [];

//     attendanceStatus.clear();
//     leaveTypes.clear();
//     remarks.clear();

//     for (final student in students) {
//       final String key = _addStudentKey(student);

//       attendanceStatus[key] = true;
//       leaveTypes[key] = null;
//       remarks[key] = '';
//     }

//     setState(() {
//       addModeStudents = students;
//       addDataInitialized = true;
//     });
//   }

//   // ============================================================
//   // INITIALIZE EDIT MODE DATA
//   // ============================================================

//   void _initializeEditMode(StudentAttendanceResponseEntity response) {
//     final details = response.data?.details ?? [];

//     attendanceStatus.clear();
//     leaveTypes.clear();
//     remarks.clear();

//     for (final detail in details) {
//       final String key = _editStudentKey(detail);

//       attendanceStatus[key] = detail.status ?? true;
//       leaveTypes[key] = detail.leaveTypeId;
//       remarks[key] = detail.remarks ?? '';
//     }

//     setState(() {
//       editModeStudents = details;
//       editDataInitialized = true;
//     });
//   }

//   // ============================================================
//   // STUDENT KEYS
//   // ============================================================

//   String _addStudentKey(AttendanceDetailsData student) {
//     final String admissionNo = student.admno?.trim() ?? '';

//     if (admissionNo.isNotEmpty) {
//       return admissionNo;
//     }

//     return 'student_${student.admissionId ?? 0}';
//   }

//   String _editStudentKey(StudentAttendanceDetailEntity student) {
//     final String admissionNo = student.admissionNo?.trim() ?? '';

//     if (admissionNo.isNotEmpty) {
//       return admissionNo;
//     }

//     return 'detail_${student.studentAttendanceDetailsId ?? 0}';
//   }

//   // ============================================================
//   // SAVE OR UPDATE
//   // ============================================================

//   void _submitAttendance() {
//     if (isEditMode) {
//       _updateAttendance();
//     } else {
//       _saveAttendance();
//     }
//   }

//   // ============================================================
//   // SAVE ATTENDANCE
//   // ============================================================

//   void _saveAttendance() {
//     if (addModeStudents.isEmpty) {
//       _showMessage('No students available');
//       return;
//     }

//     final String? accYear = AppData.accYear;
//     final int? userId = AppData.userId;
//     final int branchId = AppData.branchId ?? 1;

//     if (accYear == null || accYear.trim().isEmpty) {
//       _showMessage('Academic year is not available');
//       return;
//     }

//     if (userId == null) {
//       _showMessage('User ID is not available');
//       return;
//     }

//     final List<StudentAttendanceDetailRequest> details = [];

//     for (final student in addModeStudents) {
//       final String key = _addStudentKey(student);
//       final String admissionNo = student.admno?.trim() ?? '';
//       final bool isPresent = attendanceStatus[key] ?? true;

//       if (admissionNo.isEmpty) {
//         _showMessage(
//           'Admission number is missing for ${student.name ?? 'student'}',
//         );
//         return;
//       }

//       details.add(
//         StudentAttendanceDetailRequest(
//           admissionNo: admissionNo,
//           sessionName: widget.section,
//           status: isPresent ? 'Present' : 'Absent',
//           leaveTypeId: isPresent ? null : leaveTypes[key],
//           remarks: isPresent ? null : (remarks[key] ?? ''),
//         ),
//       );
//     }

//     final request = SaveAttendanceRequest(
//       date: _formatApiDate(widget.attendanceDate),
//       accYear: accYear,
//       narration: widget.narration,
//       standardId: widget.standardId,
//       divisionId: widget.divisionId,
//       branchId: branchId,
//       createdUser: userId.toString(),
//       studentAttendanceDetails: details,
//     );

//     debugPrint('==========================================');
//     debugPrint('SAVE ATTENDANCE');
//     debugPrint(request.toJson().toString());
//     debugPrint('==========================================');

//     context.read<AttendanceCubit>().saveAttendance(request);
//   }

//   // ============================================================
//   // UPDATE ATTENDANCE
//   // ============================================================

//   void _updateAttendance() {
//     if (editModeStudents.isEmpty) {
//       _showMessage('No students available');
//       return;
//     }

//     final int? masterId = widget.studentAttendanceMasterId;
//     final String? accYear = AppData.accYear;
//     final int? userId = AppData.userId;
//     final int branchId = AppData.branchId ?? 1;

//     if (masterId == null) {
//       _showMessage('Attendance ID is not available');
//       return;
//     }

//     if (accYear == null || accYear.trim().isEmpty) {
//       _showMessage('Academic year is not available');
//       return;
//     }

//     if (userId == null) {
//       _showMessage('User ID is not available');
//       return;
//     }

//     final List<StudentAttendanceDetailParameter> details = [];

//     for (final student in editModeStudents) {
//       final String key = _editStudentKey(student);
//       final String admissionNo = student.admissionNo?.trim() ?? '';
//       final bool isPresent = attendanceStatus[key] ?? true;

//       if (admissionNo.isEmpty) {
//         _showMessage(
//           'Admission number is missing for ${student.name ?? 'student'}',
//         );
//         return;
//       }

//       details.add(
//         StudentAttendanceDetailParameter(
//           admissionNo: admissionNo,
//           sessionName: student.sessionName?.trim().isNotEmpty == true
//               ? student.sessionName!
//               : widget.section,
//           status: isPresent ? 'Present' : 'Absent',
//           leaveTypeId: isPresent ? '' : (leaveTypes[key] ?? ''),
//           remarks: isPresent ? '' : (remarks[key] ?? ''),
//         ),
//       );
//     }

//     final request = UpdateStudentAttendanceParameter(
//       date: _formatApiDate(widget.attendanceDate),
//       accYear: accYear,
//       narration: widget.narration,
//       standardId: widget.standardId,
//       divisionId: widget.divisionId,
//       branchId: branchId,
//       modifiedUser: userId.toString(),
//       studentAttendanceDetails: details,
//     );

//     debugPrint('==========================================');
//     debugPrint('UPDATE ATTENDANCE');
//     debugPrint('Master ID: $masterId');
//     debugPrint(request.toJson().toString());
//     debugPrint('==========================================');

//     context.read<AttendanceCubit>().updateStudentAttendance(request, masterId);
//   }

//   // ============================================================
//   // COUNTS
//   // ============================================================

//   int get totalStudentCount {
//     return isEditMode ? editModeStudents.length : addModeStudents.length;
//   }

//   int get presentStudentCount {
//     int count = 0;

//     if (isEditMode) {
//       for (final student in editModeStudents) {
//         final String key = _editStudentKey(student);

//         if (attendanceStatus[key] ?? true) {
//           count++;
//         }
//       }
//     } else {
//       for (final student in addModeStudents) {
//         final String key = _addStudentKey(student);

//         if (attendanceStatus[key] ?? true) {
//           count++;
//         }
//       }
//     }

//     return count;
//   }

//   int get absentStudentCount {
//     return totalStudentCount - presentStudentCount;
//   }

//   double get attendancePercentage {
//     if (totalStudentCount == 0) {
//       return 0;
//     }

//     return (presentStudentCount / totalStudentCount) * 100;
//   }

//   // ============================================================
//   // FILTERED LISTS
//   // ============================================================

//   List<AttendanceDetailsData> get filteredAddStudents {
//     final String query = searchText.trim().toLowerCase();

//     if (query.isEmpty) {
//       return addModeStudents;
//     }

//     return addModeStudents.where((student) {
//       final String name = student.name?.toLowerCase() ?? '';
//       final String admissionNo = student.admno?.toLowerCase() ?? '';
//       final String admissionId = student.admissionId?.toString() ?? '';

//       return name.contains(query) ||
//           admissionNo.contains(query) ||
//           admissionId.contains(query);
//     }).toList();
//   }

//   List<StudentAttendanceDetailEntity> get filteredEditStudents {
//     final String query = searchText.trim().toLowerCase();

//     if (query.isEmpty) {
//       return editModeStudents;
//     }

//     return editModeStudents.where((student) {
//       final String name = student.name?.toLowerCase() ?? '';
//       final String admissionNo = student.admissionNo?.toLowerCase() ?? '';

//       return name.contains(query) || admissionNo.contains(query);
//     }).toList();
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AttendanceCubit, AttendanceState>(
//       listener: (context, state) {
//         if (state is AttendanceSuccess && !isEditMode) {
//           _initializeAddMode(state.response);
//         }

//         if (state is StudentAttendanceSuccess && isEditMode) {
//           _initializeEditMode(state.response);
//         }

//         if (state is AttendanceFailure) {
//           _showMessage(state.message);
//         }

//         if (state is StudentAttendanceFailure) {
//           _showMessage(state.message);
//         }

//         if (state is SaveAttendanceFailure) {
//           _showMessage(state.message);
//         }

//         if (state is UpdateStudentAttendanceFailure) {
//           _showMessage(state.message);
//         }

//         if (state is SaveAttendanceSuccess) {
//           _showMessage('Attendance saved successfully');

//           Future.delayed(const Duration(milliseconds: 400), () {
//             if (!mounted) {
//               return;
//             }

//             // StudentAttendanceScreen -> AttendanceScreen
//             Navigator.of(context).pop();

//             // AttendanceScreen -> AttendanceReportScreen
//             Navigator.of(context).pop(true);
//           });
//         }

//         if (state is UpdateStudentAttendanceSuccess) {
//           _showMessage('Attendance updated successfully');

//           Future.delayed(const Duration(milliseconds: 400), () {
//             if (!mounted) {
//               return;
//             }

//             // Directly returns to AttendanceReportScreen.
//             Navigator.of(context).pop(true);
//           });
//         }
//       },
//       builder: (context, state) {
//         final bool isLoading =
//             state is AttendanceLoading || state is StudentAttendanceLoading;

//         final bool isSubmitting =
//             state is SaveAttendanceLoading ||
//             state is UpdateStudentAttendanceLoading;

//         return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             surfaceTintColor: Colors.white,
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               onPressed: isSubmitting
//                   ? null
//                   : () {
//                       Navigator.maybePop(context);
//                     },
//               icon: const Icon(
//                 Icons.arrow_back,
//                 size: 27,
//                 color: Color(0xFF202020),
//               ),
//             ),
//             title: Text(
//               isEditMode ? 'Update Attendance' : 'Attendance',
//               style: const TextStyle(
//                 color: Color(0xFF111111),
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: totalStudentCount == 0 || isSubmitting
//                     ? null
//                     : _submitAttendance,
//                 child: isSubmitting
//                     ? const SizedBox(
//                         width: 19,
//                         height: 19,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Color(0xFF8069E8),
//                         ),
//                       )
//                     : Text(
//                         isEditMode ? 'Update' : 'Save',
//                         style: TextStyle(
//                           color: totalStudentCount == 0
//                               ? Colors.grey
//                               : const Color(0xFF8069E8),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//           body: SafeArea(
//             top: false,
//             child: _buildBody(state: state, isLoading: isLoading),
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // BODY
//   // ============================================================

//   Widget _buildBody({required AttendanceState state, required bool isLoading}) {
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Color(0xFF8069E8)),
//       );
//     }

//     if (state is AttendanceFailure) {
//       return _buildErrorView(state.message);
//     }

//     if (state is StudentAttendanceFailure) {
//       return _buildErrorView(state.message);
//     }

//     if (totalStudentCount == 0) {
//       if (!addDataInitialized && !editDataInitialized) {
//         return const Center(
//           child: CircularProgressIndicator(color: Color(0xFF8069E8)),
//         );
//       }

//       return _buildEmptyView();
//     }

//     return RefreshIndicator(
//       color: const Color(0xFF8069E8),
//       onRefresh: () async {
//         _fetchStudents();
//       },
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
//         child: Column(
//           children: [
//             _buildSummaryCard(),

//             const SizedBox(height: 20),

//             _buildSearchSection(),

//             const SizedBox(height: 18),

//             if (isEditMode) _buildEditStudentList() else _buildAddStudentList(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // ADD STUDENT LIST
//   // ============================================================

//   Widget _buildAddStudentList() {
//     final students = filteredAddStudents;

//     if (students.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 70),
//         child: Text(
//           'No students found',
//           style: TextStyle(color: Colors.grey, fontSize: 14),
//         ),
//       );
//     }

//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: students.length,
//       separatorBuilder: (_, __) {
//         return const SizedBox(height: 18);
//       },
//       itemBuilder: (context, index) {
//         final student = students[index];
//         final int originalIndex = addModeStudents.indexOf(student);

//         return _buildStudentCard(
//           index: originalIndex >= 0 ? originalIndex : index,
//           name: student.name ?? '',
//           admissionNo: student.admno ?? '',
//           studentKey: _addStudentKey(student),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // EDIT STUDENT LIST
//   // ============================================================

//   Widget _buildEditStudentList() {
//     final students = filteredEditStudents;

//     if (students.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 70),
//         child: Text(
//           'No students found',
//           style: TextStyle(color: Colors.grey, fontSize: 14),
//         ),
//       );
//     }

//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: students.length,
//       separatorBuilder: (_, __) {
//         return const SizedBox(height: 18);
//       },
//       itemBuilder: (context, index) {
//         final student = students[index];
//         final int originalIndex = editModeStudents.indexOf(student);

//         return _buildStudentCard(
//           index: originalIndex >= 0 ? originalIndex : index,
//           name: student.name ?? '',
//           admissionNo: student.admissionNo ?? '',
//           studentKey: _editStudentKey(student),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // SUMMARY CARD
//   // ============================================================

//   Widget _buildSummaryCard() {
//     return Container(
//       width: double.infinity,
//       height: 150,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF102F82), Color(0xFF1C4DA8)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             left: 105,
//             top: 6,
//             child: Container(
//               width: 110,
//               height: 130,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.04),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Positioned(
//             right: 0,
//             top: 0,
//             bottom: 0,
//             child: Container(
//               width: 125,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF506FC6).withOpacity(0.88),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildStatItem(
//                         title: 'Present',
//                         value: presentStudentCount.toString(),
//                       ),
//                       _buildStatItem(
//                         title: 'Absent',
//                         value: absentStudentCount.toString(),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildStatItem(
//                         title: 'Total',
//                         value: totalStudentCount.toString(),
//                       ),
//                       _buildStatItem(
//                         title: 'Attendance',
//                         value: '${attendancePercentage.toStringAsFixed(0)}%',
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 16,
//             top: 18,
//             right: 125,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 6,
//                       child: _buildInfoItem(
//                         iconPath: 'assets/icons/Group (12).svg',
//                         iconColor: const Color(0xFFFCFFBB),
//                         label: 'Date',
//                         value: _formatDisplayDate(widget.attendanceDate),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       flex: 5,
//                       child: _buildInfoItem(
//                         iconPath: 'assets/icons/Group (13).svg',
//                         iconColor: const Color(0xFFC5E5FF),
//                         label: 'Section',
//                         value: widget.section,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 28),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 6,
//                       child: _buildInfoItem(
//                         iconPath: 'assets/icons/Group 950.svg',
//                         iconColor: const Color(0xFF98FFEE),
//                         label: 'Standard',
//                         value: widget.standard,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       flex: 5,
//                       child: _buildInfoItem(
//                         iconPath: 'assets/icons/Vector (2).svg',
//                         iconColor: const Color(0xFFFFA5A5),
//                         label: 'Division',
//                         value: widget.division,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoItem({
//     required String iconPath,
//     required Color iconColor,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
//           alignment: Alignment.center,
//           child: SvgPicture.asset(iconPath, width: 17, height: 17),
//         ),
//         const SizedBox(width: 7),
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 maxLines: 1,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               FittedBox(
//                 fit: BoxFit.scaleDown,
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   value,
//                   maxLines: 1,
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatItem({required String title, required String value}) {
//     final bool isAbsent = title == 'Absent';

//     return SizedBox(
//       width: 48,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(title, style: const TextStyle(color: Colors.white, fontSize: 9)),
//           const SizedBox(height: 7),
//           SizedBox(
//             width: 28,
//             height: 28,
//             child: isAbsent
//                 ? Container(
//                     alignment: Alignment.center,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       value,
//                       style: const TextStyle(
//                         color: Color(0xFFFF3B30),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   )
//                 : Center(
//                     child: Text(
//                       value,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SEARCH
//   // ============================================================

//   Widget _buildSearchSection() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 'Attendance Details',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF333333),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 setState(() {
//                   showSearchField = !showSearchField;

//                   if (!showSearchField) {
//                     searchController.clear();
//                     searchText = '';
//                   }
//                 });
//               },
//               borderRadius: BorderRadius.circular(24),
//               child: Container(
//                 width: 42,
//                 height: 42,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF7A6AE6),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   showSearchField ? Icons.close : Icons.search_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (showSearchField) ...[
//           const SizedBox(height: 14),
//           TextField(
//             controller: searchController,
//             autofocus: true,
//             onChanged: (value) {
//               setState(() {
//                 searchText = value;
//               });
//             },
//             decoration: InputDecoration(
//               hintText: 'Search student',
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: searchText.isEmpty
//                   ? null
//                   : IconButton(
//                       onPressed: () {
//                         searchController.clear();

//                         setState(() {
//                           searchText = '';
//                         });
//                       },
//                       icon: const Icon(Icons.close),
//                     ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   // ============================================================
//   // STUDENT CARD
//   // ============================================================

//   Widget _buildStudentCard({
//     required int index,
//     required String name,
//     required String admissionNo,
//     required String studentKey,
//   }) {
//     final bool isPresent = attendanceStatus[studentKey] ?? true;

//     final Color backgroundColor = isPresent
//         ? const Color(0xFFF6F6FF)
//         : const Color(0xFFFFE3E5);

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '#${index + 1}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 9),
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 9),
//                     Text(admissionNo, style: const TextStyle(fontSize: 14)),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 7,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isPresent
//                           ? const Color(0xFFA5FF91)
//                           : const Color(0xFFF0222E),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       isPresent ? 'Present' : 'Absent',
//                       style: TextStyle(
//                         color: isPresent
//                             ? const Color(0xFF174F0E)
//                             : Colors.white,
//                       ),
//                     ),
//                   ),
//                   Switch(
//                     value: isPresent,
//                     activeTrackColor: const Color(0xFF28D10C),
//                     inactiveTrackColor: const Color(0xFFF0222E),
//                     onChanged: (value) {
//                       setState(() {
//                         attendanceStatus[studentKey] = value;

//                         if (value) {
//                           leaveTypes[studentKey] = null;
//                           remarks[studentKey] = '';
//                         }
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           if (!isPresent) ...[
//             const SizedBox(height: 18),
//             Row(
//               children: [
//                 Expanded(child: _buildLeaveDropdown(studentKey)),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextFormField(
//                     key: ValueKey('${studentKey}_${remarks[studentKey] ?? ''}'),
//                     initialValue: remarks[studentKey] ?? '',
//                     onChanged: (value) {
//                       remarks[studentKey] = value;
//                     },
//                     decoration: const InputDecoration(hintText: 'Remark'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildLeaveDropdown(String studentKey) {
//     const List<String> defaultLeaveTypes = [
//       'Sick Leave',
//       'Casual Leave',
//       'Emergency Leave',
//     ];

//     final String? currentValue = leaveTypes[studentKey];
//     final List<String> options = [...defaultLeaveTypes];

//     // Prevent DropdownButton assertion when API returns values such as "NA".
//     if (currentValue != null &&
//         currentValue.trim().isNotEmpty &&
//         !options.contains(currentValue)) {
//       options.insert(0, currentValue);
//     }

//     final String? dropdownValue =
//         currentValue == null || currentValue.trim().isEmpty
//         ? null
//         : currentValue;

//     return DropdownButtonFormField<String>(
//       value: dropdownValue,
//       hint: const Text('Select Leave Type'),
//       items: options.map((leaveType) {
//         return DropdownMenuItem<String>(
//           value: leaveType,
//           child: Text(leaveType, overflow: TextOverflow.ellipsis),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           leaveTypes[studentKey] = value;
//         });
//       },
//     );
//   }

//   // ============================================================
//   // DATE
//   // ============================================================

//   String _formatDisplayDate(DateTime date) {
//     final String day = date.day.toString().padLeft(2, '0');
//     final String month = date.month.toString().padLeft(2, '0');

//     return '$day/$month/${date.year}';
//   }

//   String _formatApiDate(DateTime date) {
//     final String month = date.month.toString().padLeft(2, '0');
//     final String day = date.day.toString().padLeft(2, '0');

//     return '${date.year}-$month-$day';
//   }

//   // ============================================================
//   // ERROR AND EMPTY
//   // ============================================================

//   Widget _buildErrorView(String message) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(message),
//           const SizedBox(height: 18),
//           ElevatedButton(onPressed: _fetchStudents, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyView() {
//     return const Center(child: Text('No students found'));
//   }

//   void _showMessage(String message) {
//     if (!mounted) {
//       return;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/attendance/domain/entities/fetch_attendancedetails_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/studentattendance_response_enttiy.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';
import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final int? studentAttendanceMasterId;
  final DateTime attendanceDate;
  final int standardId;
  final String standard;
  final int divisionId;
  final String division;
  final String section;
  final String narration;

  const StudentAttendanceScreen({
    super.key,
    this.studentAttendanceMasterId,
    required this.attendanceDate,
    required this.standardId,
    required this.standard,
    required this.divisionId,
    required this.division,
    required this.section,
    required this.narration,
  });

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  bool showSearchField = false;

  // Admission number is used as the unique key.
  final Map<String, bool> attendanceStatus = {};
  final Map<String, String?> leaveTypes = {};
  final Map<String, String> remarks = {};

  // Add mode student list.
  List<AttendanceDetailsData> addModeStudents = [];

  // Edit mode student list.
  List<StudentAttendanceDetailEntity> editModeStudents = [];

  bool addDataInitialized = false;
  bool editDataInitialized = false;

  bool get isEditMode => widget.studentAttendanceMasterId != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudents();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FETCH STUDENTS
  // ============================================================

  void _fetchStudents() {
    if (isEditMode) {
      _fetchEditAttendance();
    } else {
      _fetchAddAttendanceStudents();
    }
  }

  void _fetchAddAttendanceStudents() {
    final String? accYear = AppData.accYear;

    if (accYear == null || accYear.trim().isEmpty) {
      _showMessage('Academic year is not available');
      return;
    }

    final request = AttendanceDetailsRequest(
      accyear: accYear,
      standard: widget.standardId,
      division: widget.divisionId,
      gender: AppData.gender,
      sortBy: 'alphabetic',
    );

    debugPrint('==========================================');
    debugPrint('ADD MODE - FETCH ATTENDANCE DETAILS');
    debugPrint('Request: ${request.toJson()}');
    debugPrint('==========================================');

    context.read<AttendanceCubit>().fetchAttendanceDetails(request);
  }

  void _fetchEditAttendance() {
    final int? masterId = widget.studentAttendanceMasterId;

    if (masterId == null) {
      _showMessage('Attendance ID is not available');
      return;
    }

    debugPrint('==========================================');
    debugPrint('EDIT MODE - FETCH STUDENT ATTENDANCE');
    debugPrint('Master ID: $masterId');
    debugPrint('==========================================');

    context.read<AttendanceCubit>().fetchStudentAttendance(masterId);
  }

  // ============================================================
  // INITIALIZE ADD MODE DATA
  // ============================================================

  void _initializeAddMode(AttendanceDetailsEntity response) {
    final students = response.data ?? [];

    attendanceStatus.clear();
    leaveTypes.clear();
    remarks.clear();

    for (final student in students) {
      final String key = _addStudentKey(student);

      attendanceStatus[key] = true;
      leaveTypes[key] = null;
      remarks[key] = '';
    }

    setState(() {
      addModeStudents = students;
      addDataInitialized = true;
    });
  }

  // ============================================================
  // INITIALIZE EDIT MODE DATA
  // ============================================================

  void _initializeEditMode(StudentAttendanceResponseEntity response) {
    final details = response.data?.details ?? [];

    attendanceStatus.clear();
    leaveTypes.clear();
    remarks.clear();

    for (final detail in details) {
      final String key = _editStudentKey(detail);

      attendanceStatus[key] = detail.status ?? true;
      leaveTypes[key] = detail.leaveTypeId;
      remarks[key] = detail.remarks ?? '';
    }

    setState(() {
      editModeStudents = details;
      editDataInitialized = true;
    });
  }

  // ============================================================
  // STUDENT KEYS
  // ============================================================

  String _addStudentKey(AttendanceDetailsData student) {
    final String admissionNo = student.admno?.trim() ?? '';

    if (admissionNo.isNotEmpty) {
      return admissionNo;
    }

    return 'student_${student.admissionId ?? 0}';
  }

  String _editStudentKey(StudentAttendanceDetailEntity student) {
    final String admissionNo = student.admissionNo?.trim() ?? '';

    if (admissionNo.isNotEmpty) {
      return admissionNo;
    }

    return 'detail_${student.studentAttendanceDetailsId ?? 0}';
  }

  // ============================================================
  // SAVE OR UPDATE
  // ============================================================

  void _submitAttendance() {
    if (isEditMode) {
      _updateAttendance();
    } else {
      _saveAttendance();
    }
  }

  // ============================================================
  // SAVE ATTENDANCE
  // ============================================================

  void _saveAttendance() {
    if (addModeStudents.isEmpty) {
      _showMessage('No students available');
      return;
    }

    final String? accYear = AppData.accYear;
    final int? userId = AppData.userId;
    final int branchId = AppData.branchId ?? 1;

    if (accYear == null || accYear.trim().isEmpty) {
      _showMessage('Academic year is not available');
      return;
    }

    if (userId == null) {
      _showMessage('User ID is not available');
      return;
    }

    final List<StudentAttendanceDetailRequest> details = [];

    for (final student in addModeStudents) {
      final String key = _addStudentKey(student);
      final String admissionNo = student.admno?.trim() ?? '';
      final bool isPresent = attendanceStatus[key] ?? true;

      if (admissionNo.isEmpty) {
        _showMessage(
          'Admission number is missing for ${student.name ?? 'student'}',
        );
        return;
      }

      details.add(
        StudentAttendanceDetailRequest(
          admissionNo: admissionNo,
          sessionName: widget.section,
          status: isPresent ? 'Present' : 'Absent',
          leaveTypeId: isPresent ? null : leaveTypes[key],
          remarks: isPresent ? null : (remarks[key] ?? ''),
        ),
      );
    }

    final request = SaveAttendanceRequest(
      date: _formatApiDate(widget.attendanceDate),
      accYear: accYear,
      narration: widget.narration,
      standardId: widget.standardId,
      divisionId: widget.divisionId,
      branchId: branchId,
      createdUser: userId.toString(),
      studentAttendanceDetails: details,
    );

    debugPrint('==========================================');
    debugPrint('SAVE ATTENDANCE');
    debugPrint(request.toJson().toString());
    debugPrint('==========================================');

    context.read<AttendanceCubit>().saveAttendance(request);
  }

  // ============================================================
  // UPDATE ATTENDANCE
  // ============================================================

  void _updateAttendance() {
    if (editModeStudents.isEmpty) {
      _showMessage('No students available');
      return;
    }

    final int? masterId = widget.studentAttendanceMasterId;
    final String? accYear = AppData.accYear;
    final int? userId = AppData.userId;
    final int branchId = AppData.branchId ?? 1;

    if (masterId == null) {
      _showMessage('Attendance ID is not available');
      return;
    }

    if (accYear == null || accYear.trim().isEmpty) {
      _showMessage('Academic year is not available');
      return;
    }

    if (userId == null) {
      _showMessage('User ID is not available');
      return;
    }

    final List<StudentAttendanceDetailParameter> details = [];

    for (final student in editModeStudents) {
      final String key = _editStudentKey(student);
      final String admissionNo = student.admissionNo?.trim() ?? '';
      final bool isPresent = attendanceStatus[key] ?? true;

      if (admissionNo.isEmpty) {
        _showMessage(
          'Admission number is missing for ${student.name ?? 'student'}',
        );
        return;
      }

      details.add(
        StudentAttendanceDetailParameter(
          admissionNo: admissionNo,
          sessionName: student.sessionName?.trim().isNotEmpty == true
              ? student.sessionName!
              : widget.section,
          status: isPresent ? 'Present' : 'Absent',
          leaveTypeId: isPresent ? '' : (leaveTypes[key] ?? ''),
          remarks: isPresent ? '' : (remarks[key] ?? ''),
        ),
      );
    }

    final request = UpdateStudentAttendanceParameter(
      date: _formatApiDate(widget.attendanceDate),
      accYear: accYear,
      narration: widget.narration,
      standardId: widget.standardId,
      divisionId: widget.divisionId,
      branchId: branchId,
      modifiedUser: userId.toString(),
      studentAttendanceDetails: details,
    );

    debugPrint('==========================================');
    debugPrint('UPDATE ATTENDANCE');
    debugPrint('Master ID: $masterId');
    debugPrint(request.toJson().toString());
    debugPrint('==========================================');

    context.read<AttendanceCubit>().updateStudentAttendance(request, masterId);
  }

  // ============================================================
  // COUNTS
  // ============================================================

  int get totalStudentCount {
    return isEditMode ? editModeStudents.length : addModeStudents.length;
  }

  int get presentStudentCount {
    int count = 0;

    if (isEditMode) {
      for (final student in editModeStudents) {
        final String key = _editStudentKey(student);

        if (attendanceStatus[key] ?? true) {
          count++;
        }
      }
    } else {
      for (final student in addModeStudents) {
        final String key = _addStudentKey(student);

        if (attendanceStatus[key] ?? true) {
          count++;
        }
      }
    }

    return count;
  }

  int get absentStudentCount {
    return totalStudentCount - presentStudentCount;
  }

  double get attendancePercentage {
    if (totalStudentCount == 0) {
      return 0;
    }

    return (presentStudentCount / totalStudentCount) * 100;
  }

  // ============================================================
  // FILTERED LISTS
  // ============================================================

  List<AttendanceDetailsData> get filteredAddStudents {
    final String query = searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return addModeStudents;
    }

    return addModeStudents.where((student) {
      final String name = student.name?.toLowerCase() ?? '';
      final String admissionNo = student.admno?.toLowerCase() ?? '';
      final String admissionId = student.admissionId?.toString() ?? '';

      return name.contains(query) ||
          admissionNo.contains(query) ||
          admissionId.contains(query);
    }).toList();
  }

  List<StudentAttendanceDetailEntity> get filteredEditStudents {
    final String query = searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return editModeStudents;
    }

    return editModeStudents.where((student) {
      final String name = student.name?.toLowerCase() ?? '';
      final String admissionNo = student.admissionNo?.toLowerCase() ?? '';

      return name.contains(query) || admissionNo.contains(query);
    }).toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess && !isEditMode) {
          _initializeAddMode(state.response);
        }

        if (state is StudentAttendanceSuccess && isEditMode) {
          _initializeEditMode(state.response);
        }

        if (state is AttendanceFailure) {
          _showMessage(state.message);
        }

        if (state is StudentAttendanceFailure) {
          _showMessage(state.message);
        }

        if (state is SaveAttendanceFailure) {
          _showMessage(state.message);
        }

        if (state is UpdateStudentAttendanceFailure) {
          _showMessage(state.message);
        }

        if (state is SaveAttendanceSuccess) {
          _showMessage('Attendance saved successfully');

          Future.delayed(const Duration(milliseconds: 400), () {
            if (!mounted) {
              return;
            }

            // StudentAttendanceScreen -> AttendanceScreen
            Navigator.of(context).pop();

            // AttendanceScreen -> AttendanceReportScreen
            Navigator.of(context).pop(true);
          });
        }

        if (state is UpdateStudentAttendanceSuccess) {
          _showMessage('Attendance updated successfully');

          Future.delayed(const Duration(milliseconds: 400), () {
            if (!mounted) {
              return;
            }

            // Directly returns to AttendanceReportScreen.
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        final bool isLoading =
            state is AttendanceLoading || state is StudentAttendanceLoading;

        final bool isSubmitting =
            state is SaveAttendanceLoading ||
            state is UpdateStudentAttendanceLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: isSubmitting
                  ? null
                  : () {
                      Navigator.maybePop(context);
                    },
              icon: const Icon(
                Icons.arrow_back,
                size: 27,
                color: Color(0xFF202020),
              ),
            ),
            title: Text(
              isEditMode ? 'Update Attendance' : 'Attendance',
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: totalStudentCount == 0 || isSubmitting
                    ? null
                    : _submitAttendance,
                child: isSubmitting
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF8069E8),
                        ),
                      )
                    : Text(
                        isEditMode ? 'Update' : 'Save',
                        style: TextStyle(
                          color: totalStudentCount == 0
                              ? Colors.grey
                              : const Color(0xFF8069E8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: _buildBody(state: state, isLoading: isLoading),
          ),
        );
      },
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody({required AttendanceState state, required bool isLoading}) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF8069E8)),
      );
    }

    if (state is AttendanceFailure) {
      return _buildErrorView(state.message);
    }

    if (state is StudentAttendanceFailure) {
      return _buildErrorView(state.message);
    }

    if (totalStudentCount == 0) {
      if (!addDataInitialized && !editDataInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF8069E8)),
        );
      }

      return _buildEmptyView();
    }

    return RefreshIndicator(
      color: const Color(0xFF8069E8),
      onRefresh: () async {
        _fetchStudents();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          children: [
            _buildSummaryCard(),

            const SizedBox(height: 20),

            _buildSearchSection(),

            const SizedBox(height: 18),

            if (isEditMode) _buildEditStudentList() else _buildAddStudentList(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD STUDENT LIST
  // ============================================================

  Widget _buildAddStudentList() {
    final students = filteredAddStudents;

    if (students.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 70),
        child: Text(
          'No students found',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 18);
      },
      itemBuilder: (context, index) {
        final student = students[index];
        final int originalIndex = addModeStudents.indexOf(student);

        return _buildStudentCard(
          index: originalIndex >= 0 ? originalIndex : index,
          name: student.name ?? '',
          admissionNo: student.admno ?? '',
          studentKey: _addStudentKey(student),
        );
      },
    );
  }

  // ============================================================
  // EDIT STUDENT LIST
  // ============================================================

  Widget _buildEditStudentList() {
    final students = filteredEditStudents;

    if (students.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 70),
        child: Text(
          'No students found',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 18);
      },
      itemBuilder: (context, index) {
        final student = students[index];
        final int originalIndex = editModeStudents.indexOf(student);

        return _buildStudentCard(
          index: originalIndex >= 0 ? originalIndex : index,
          name: student.name ?? '',
          admissionNo: student.admissionNo ?? '',
          studentKey: _editStudentKey(student),
        );
      },
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102F82), Color(0xFF1C4DA8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 105,
            top: 6,
            child: Container(
              width: 110,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 125,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF506FC6).withOpacity(0.88),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        title: 'Present',
                        value: presentStudentCount.toString(),
                      ),
                      _buildStatItem(
                        title: 'Absent',
                        value: absentStudentCount.toString(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        title: 'Total',
                        value: totalStudentCount.toString(),
                      ),
                      _buildStatItem(
                        title: 'Attendance',
                        value: '${attendancePercentage.toStringAsFixed(0)}%',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 18,
            right: 125,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildInfoItem(
                        iconPath: 'assets/icons/Group (12).svg',
                        iconColor: const Color(0xFFFCFFBB),
                        label: 'Date',
                        value: _formatDisplayDate(widget.attendanceDate),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildInfoItem(
                        iconPath: 'assets/icons/Group (13).svg',
                        iconColor: const Color(0xFFC5E5FF),
                        label: 'Section',
                        value: widget.section,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildInfoItem(
                        iconPath: 'assets/icons/Group 950.svg',
                        iconColor: const Color(0xFF98FFEE),
                        label: 'Standard',
                        value: widget.standard,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildInfoItem(
                        iconPath: 'assets/icons/Vector (2).svg',
                        iconColor: const Color(0xFFFFA5A5),
                        label: 'Division',
                        value: widget.division,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String iconPath,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: SvgPicture.asset(iconPath, width: 17, height: 17),
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({required String title, required String value}) {
    final bool isAbsent = title == 'Absent';

    return SizedBox(
      width: 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 9)),
          const SizedBox(height: 7),
          SizedBox(
            width: 28,
            height: 28,
            child: isAbsent
                ? Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFFFF3B30),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchSection() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Attendance Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  showSearchField = !showSearchField;

                  if (!showSearchField) {
                    searchController.clear();
                    searchText = '';
                  }
                });
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF7A6AE6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  showSearchField ? Icons.close : Icons.search_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (showSearchField) ...[
          const SizedBox(height: 14),
          TextField(
            controller: searchController,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search student',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchText.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();

                        setState(() {
                          searchText = '';
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // STUDENT CARD
  // ============================================================

  Widget _buildStudentCard({
    required int index,
    required String name,
    required String admissionNo,
    required String studentKey,
  }) {
    final bool isPresent = attendanceStatus[studentKey] ?? true;

    final Color backgroundColor = isPresent
        ? const Color(0xFFF6F6FF)
        : const Color(0xFFFFE3E5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(admissionNo, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isPresent
                          ? const Color(0xFFA5FF91)
                          : const Color(0xFFF0222E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPresent ? 'Present' : 'Absent',
                      style: TextStyle(
                        color: isPresent
                            ? const Color(0xFF174F0E)
                            : Colors.white,
                      ),
                    ),
                  ),
                  Switch(
                    value: isPresent,
                    activeTrackColor: const Color(0xFF28D10C),
                    inactiveTrackColor: const Color(0xFFF0222E),
                    onChanged: (value) {
                      setState(() {
                        attendanceStatus[studentKey] = value;

                        if (value) {
                          leaveTypes[studentKey] = null;
                          remarks[studentKey] = '';
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          if (!isPresent) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _buildLeaveDropdown(studentKey)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('${studentKey}_${remarks[studentKey] ?? ''}'),
                    initialValue: remarks[studentKey] ?? '',
                    onChanged: (value) {
                      remarks[studentKey] = value;
                    },
                    decoration: const InputDecoration(hintText: 'Remark'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeaveDropdown(String studentKey) {
    const List<String> defaultLeaveTypes = [
      'Sick Leave',
      'Casual Leave',
      'Emergency Leave',
    ];

    final String? currentValue = leaveTypes[studentKey];
    final List<String> options = [...defaultLeaveTypes];

    // Prevent DropdownButton assertion when API returns values such as "NA".
    if (currentValue != null &&
        currentValue.trim().isNotEmpty &&
        !options.contains(currentValue)) {
      options.insert(0, currentValue);
    }

    final String? dropdownValue =
        currentValue == null || currentValue.trim().isEmpty
        ? null
        : currentValue;

    return DropdownButtonFormField<String>(
      value: dropdownValue,
      // Without this the button sizes itself to its widest menu item
      // instead of to the width it was given, which overflows on small
      // screens.
      isExpanded: true,
      hint: const Text('Select Leave Type', overflow: TextOverflow.ellipsis),
      items: options.map((leaveType) {
        return DropdownMenuItem<String>(
          value: leaveType,
          child: Text(leaveType, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          leaveTypes[studentKey] = value;
        });
      },
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDisplayDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatApiDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  // ============================================================
  // ERROR AND EMPTY
  // ============================================================

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _fetchStudents, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(child: Text('No students found'));
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
