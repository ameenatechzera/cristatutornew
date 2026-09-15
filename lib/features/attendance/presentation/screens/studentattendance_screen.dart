// // import 'package:cristalteacher/core/appdata/appdata.dart';
// // import 'package:cristalteacher/features/attendance/domain/entities/fetch_attendancedetails_entity.dart';
// // import 'package:cristalteacher/features/attendance/domain/entities/studentattendance_response_enttiy.dart';
// // import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
// // import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
// // import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';
// // import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_svg/flutter_svg.dart';

// // class StudentAttendanceScreen extends StatefulWidget {
// //   final int? studentAttendanceMasterId;
// //   final DateTime attendanceDate;
// //   final int standardId;
// //   final String standard;
// //   final int divisionId;
// //   final String division;
// //   final String section;
// //   final String narration;

// //   const StudentAttendanceScreen({
// //     super.key,
// //     this.studentAttendanceMasterId,
// //     required this.attendanceDate,
// //     required this.standardId,
// //     required this.standard,
// //     required this.divisionId,
// //     required this.division,
// //     required this.section,
// //     required this.narration,
// //   });

// //   @override
// //   State<StudentAttendanceScreen> createState() =>
// //       _StudentAttendanceScreenState();
// // }

// // class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
// //   final TextEditingController searchController = TextEditingController();

// //   String searchText = '';
// //   bool showSearchField = false;

// //   // Admission number is used as the unique key.
// //   final Map<String, bool> attendanceStatus = {};
// //   final Map<String, String?> leaveTypes = {};
// //   final Map<String, String> remarks = {};

// //   // Add mode student list.
// //   List<AttendanceDetailsData> addModeStudents = [];

// //   // Edit mode student list.
// //   List<StudentAttendanceDetailEntity> editModeStudents = [];

// //   bool addDataInitialized = false;
// //   bool editDataInitialized = false;

// //   bool get isEditMode => widget.studentAttendanceMasterId != null;

// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _fetchStudents();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     super.dispose();
// //   }

// //   // ============================================================
// //   // FETCH STUDENTS
// //   // ============================================================

// //   void _fetchStudents() {
// //     if (isEditMode) {
// //       _fetchEditAttendance();
// //     } else {
// //       _fetchAddAttendanceStudents();
// //     }
// //   }

// //   void _fetchAddAttendanceStudents() {
// //     final String? accYear = AppData.accYear;

// //     if (accYear == null || accYear.trim().isEmpty) {
// //       _showMessage('Academic year is not available');
// //       return;
// //     }

// //     final request = AttendanceDetailsRequest(
// //       accyear: accYear,
// //       standard: widget.standardId,
// //       division: widget.divisionId,
// //       gender: AppData.gender,
// //       sortBy: 'alphabetic',
// //     );

// //     debugPrint('==========================================');
// //     debugPrint('ADD MODE - FETCH ATTENDANCE DETAILS');
// //     debugPrint('Request: ${request.toJson()}');
// //     debugPrint('==========================================');

// //     context.read<AttendanceCubit>().fetchAttendanceDetails(request);
// //   }

// //   void _fetchEditAttendance() {
// //     final int? masterId = widget.studentAttendanceMasterId;

// //     if (masterId == null) {
// //       _showMessage('Attendance ID is not available');
// //       return;
// //     }

// //     debugPrint('==========================================');
// //     debugPrint('EDIT MODE - FETCH STUDENT ATTENDANCE');
// //     debugPrint('Master ID: $masterId');
// //     debugPrint('==========================================');

// //     context.read<AttendanceCubit>().fetchStudentAttendance(masterId);
// //   }

// //   // ============================================================
// //   // INITIALIZE ADD MODE DATA
// //   // ============================================================

// //   void _initializeAddMode(AttendanceDetailsEntity response) {
// //     final students = response.data ?? [];

// //     attendanceStatus.clear();
// //     leaveTypes.clear();
// //     remarks.clear();

// //     for (final student in students) {
// //       final String key = _addStudentKey(student);

// //       attendanceStatus[key] = true;
// //       leaveTypes[key] = null;
// //       remarks[key] = '';
// //     }

// //     setState(() {
// //       addModeStudents = students;
// //       addDataInitialized = true;
// //     });
// //   }

// //   // ============================================================
// //   // INITIALIZE EDIT MODE DATA
// //   // ============================================================

// //   void _initializeEditMode(StudentAttendanceResponseEntity response) {
// //     final details = response.data?.details ?? [];

// //     attendanceStatus.clear();
// //     leaveTypes.clear();
// //     remarks.clear();

// //     for (final detail in details) {
// //       final String key = _editStudentKey(detail);

// //       attendanceStatus[key] = detail.status ?? true;
// //       leaveTypes[key] = detail.leaveTypeId;
// //       remarks[key] = detail.remarks ?? '';
// //     }

// //     setState(() {
// //       editModeStudents = details;
// //       editDataInitialized = true;
// //     });
// //   }

// //   // ============================================================
// //   // STUDENT KEYS
// //   // ============================================================

// //   String _addStudentKey(AttendanceDetailsData student) {
// //     final String admissionNo = student.admno?.trim() ?? '';

// //     if (admissionNo.isNotEmpty) {
// //       return admissionNo;
// //     }

// //     return 'student_${student.admissionId ?? 0}';
// //   }

// //   String _editStudentKey(StudentAttendanceDetailEntity student) {
// //     final String admissionNo = student.admissionNo?.trim() ?? '';

// //     if (admissionNo.isNotEmpty) {
// //       return admissionNo;
// //     }

// //     return 'detail_${student.studentAttendanceDetailsId ?? 0}';
// //   }

// //   // ============================================================
// //   // SAVE OR UPDATE
// //   // ============================================================

// //   void _submitAttendance() {
// //     if (isEditMode) {
// //       _updateAttendance();
// //     } else {
// //       _saveAttendance();
// //     }
// //   }

// //   // ============================================================
// //   // SAVE ATTENDANCE
// //   // ============================================================

// //   void _saveAttendance() {
// //     if (addModeStudents.isEmpty) {
// //       _showMessage('No students available');
// //       return;
// //     }

// //     final String? accYear = AppData.accYear;
// //     final int? userId = AppData.userId;
// //     final int branchId = AppData.branchId ?? 1;

// //     if (accYear == null || accYear.trim().isEmpty) {
// //       _showMessage('Academic year is not available');
// //       return;
// //     }

// //     if (userId == null) {
// //       _showMessage('User ID is not available');
// //       return;
// //     }

// //     final List<StudentAttendanceDetailRequest> details = [];

// //     for (final student in addModeStudents) {
// //       final String key = _addStudentKey(student);
// //       final String admissionNo = student.admno?.trim() ?? '';
// //       final bool isPresent = attendanceStatus[key] ?? true;

// //       if (admissionNo.isEmpty) {
// //         _showMessage(
// //           'Admission number is missing for ${student.name ?? 'student'}',
// //         );
// //         return;
// //       }

// //       details.add(
// //         StudentAttendanceDetailRequest(
// //           admissionNo: admissionNo,
// //           sessionName: widget.section,
// //           status: isPresent ? 'Present' : 'Absent',
// //           leaveTypeId: isPresent ? null : leaveTypes[key],
// //           remarks: isPresent ? null : (remarks[key] ?? ''),
// //         ),
// //       );
// //     }

// //     final request = SaveAttendanceRequest(
// //       date: _formatApiDate(widget.attendanceDate),
// //       accYear: accYear,
// //       narration: widget.narration,
// //       standardId: widget.standardId,
// //       divisionId: widget.divisionId,
// //       branchId: branchId,
// //       createdUser: userId.toString(),
// //       studentAttendanceDetails: details,
// //     );

// //     debugPrint('==========================================');
// //     debugPrint('SAVE ATTENDANCE');
// //     debugPrint(request.toJson().toString());
// //     debugPrint('==========================================');

// //     context.read<AttendanceCubit>().saveAttendance(request);
// //   }

// //   // ============================================================
// //   // UPDATE ATTENDANCE
// //   // ============================================================

// //   void _updateAttendance() {
// //     if (editModeStudents.isEmpty) {
// //       _showMessage('No students available');
// //       return;
// //     }

// //     final int? masterId = widget.studentAttendanceMasterId;
// //     final String? accYear = AppData.accYear;
// //     final int? userId = AppData.userId;
// //     final int branchId = AppData.branchId ?? 1;

// //     if (masterId == null) {
// //       _showMessage('Attendance ID is not available');
// //       return;
// //     }

// //     if (accYear == null || accYear.trim().isEmpty) {
// //       _showMessage('Academic year is not available');
// //       return;
// //     }

// //     if (userId == null) {
// //       _showMessage('User ID is not available');
// //       return;
// //     }

// //     final List<StudentAttendanceDetailParameter> details = [];

// //     for (final student in editModeStudents) {
// //       final String key = _editStudentKey(student);
// //       final String admissionNo = student.admissionNo?.trim() ?? '';
// //       final bool isPresent = attendanceStatus[key] ?? true;

// //       if (admissionNo.isEmpty) {
// //         _showMessage(
// //           'Admission number is missing for ${student.name ?? 'student'}',
// //         );
// //         return;
// //       }

// //       details.add(
// //         StudentAttendanceDetailParameter(
// //           admissionNo: admissionNo,
// //           sessionName: student.sessionName?.trim().isNotEmpty == true
// //               ? student.sessionName!
// //               : widget.section,
// //           status: isPresent ? 'Present' : 'Absent',
// //           leaveTypeId: isPresent ? '' : (leaveTypes[key] ?? ''),
// //           remarks: isPresent ? '' : (remarks[key] ?? ''),
// //         ),
// //       );
// //     }

// //     final request = UpdateStudentAttendanceParameter(
// //       date: _formatApiDate(widget.attendanceDate),
// //       accYear: accYear,
// //       narration: widget.narration,
// //       standardId: widget.standardId,
// //       divisionId: widget.divisionId,
// //       branchId: branchId,
// //       modifiedUser: userId.toString(),
// //       studentAttendanceDetails: details,
// //     );

// //     debugPrint('==========================================');
// //     debugPrint('UPDATE ATTENDANCE');
// //     debugPrint('Master ID: $masterId');
// //     debugPrint(request.toJson().toString());
// //     debugPrint('==========================================');

// //     context.read<AttendanceCubit>().updateStudentAttendance(request, masterId);
// //   }

// //   // ============================================================
// //   // COUNTS
// //   // ============================================================

// //   int get totalStudentCount {
// //     return isEditMode ? editModeStudents.length : addModeStudents.length;
// //   }

// //   int get presentStudentCount {
// //     int count = 0;

// //     if (isEditMode) {
// //       for (final student in editModeStudents) {
// //         final String key = _editStudentKey(student);

// //         if (attendanceStatus[key] ?? true) {
// //           count++;
// //         }
// //       }
// //     } else {
// //       for (final student in addModeStudents) {
// //         final String key = _addStudentKey(student);

// //         if (attendanceStatus[key] ?? true) {
// //           count++;
// //         }
// //       }
// //     }

// //     return count;
// //   }

// //   int get absentStudentCount {
// //     return totalStudentCount - presentStudentCount;
// //   }

// //   double get attendancePercentage {
// //     if (totalStudentCount == 0) {
// //       return 0;
// //     }

// //     return (presentStudentCount / totalStudentCount) * 100;
// //   }

// //   // ============================================================
// //   // FILTERED LISTS
// //   // ============================================================

// //   List<AttendanceDetailsData> get filteredAddStudents {
// //     final String query = searchText.trim().toLowerCase();

// //     if (query.isEmpty) {
// //       return addModeStudents;
// //     }

// //     return addModeStudents.where((student) {
// //       final String name = student.name?.toLowerCase() ?? '';
// //       final String admissionNo = student.admno?.toLowerCase() ?? '';
// //       final String admissionId = student.admissionId?.toString() ?? '';

// //       return name.contains(query) ||
// //           admissionNo.contains(query) ||
// //           admissionId.contains(query);
// //     }).toList();
// //   }

// //   List<StudentAttendanceDetailEntity> get filteredEditStudents {
// //     final String query = searchText.trim().toLowerCase();

// //     if (query.isEmpty) {
// //       return editModeStudents;
// //     }

// //     return editModeStudents.where((student) {
// //       final String name = student.name?.toLowerCase() ?? '';
// //       final String admissionNo = student.admissionNo?.toLowerCase() ?? '';

// //       return name.contains(query) || admissionNo.contains(query);
// //     }).toList();
// //   }

// //   // ============================================================
// //   // BUILD
// //   // ============================================================

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocConsumer<AttendanceCubit, AttendanceState>(
// //       listener: (context, state) {
// //         if (state is AttendanceSuccess && !isEditMode) {
// //           _initializeAddMode(state.response);
// //         }

// //         if (state is StudentAttendanceSuccess && isEditMode) {
// //           _initializeEditMode(state.response);
// //         }

// //         if (state is AttendanceFailure) {
// //           _showMessage(state.message);
// //         }

// //         if (state is StudentAttendanceFailure) {
// //           _showMessage(state.message);
// //         }

// //         if (state is SaveAttendanceFailure) {
// //           _showMessage(state.message);
// //         }

// //         if (state is UpdateStudentAttendanceFailure) {
// //           _showMessage(state.message);
// //         }

// //         if (state is SaveAttendanceSuccess) {
// //           _showMessage('Attendance saved successfully');

// //           Future.delayed(const Duration(milliseconds: 400), () {
// //             if (!mounted) {
// //               return;
// //             }

// //             // StudentAttendanceScreen -> AttendanceScreen
// //             Navigator.of(context).pop();

// //             // AttendanceScreen -> AttendanceReportScreen
// //             Navigator.of(context).pop(true);
// //           });
// //         }

// //         if (state is UpdateStudentAttendanceSuccess) {
// //           _showMessage('Attendance updated successfully');

// //           Future.delayed(const Duration(milliseconds: 400), () {
// //             if (!mounted) {
// //               return;
// //             }

// //             // Directly returns to AttendanceReportScreen.
// //             Navigator.of(context).pop(true);
// //           });
// //         }
// //       },
// //       builder: (context, state) {
// //         final bool isLoading =
// //             state is AttendanceLoading || state is StudentAttendanceLoading;

// //         final bool isSubmitting =
// //             state is SaveAttendanceLoading ||
// //             state is UpdateStudentAttendanceLoading;

// //         return Scaffold(
// //           backgroundColor: Colors.white,
// //           appBar: AppBar(
// //             backgroundColor: Colors.white,
// //             surfaceTintColor: Colors.white,
// //             elevation: 0,
// //             centerTitle: true,
// //             leading: IconButton(
// //               onPressed: isSubmitting
// //                   ? null
// //                   : () {
// //                       Navigator.maybePop(context);
// //                     },
// //               icon: const Icon(
// //                 Icons.arrow_back,
// //                 size: 27,
// //                 color: Color(0xFF202020),
// //               ),
// //             ),
// //             title: Text(
// //               isEditMode ? 'Update Attendance' : 'Attendance',
// //               style: const TextStyle(
// //                 color: Color(0xFF111111),
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w700,
// //               ),
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: totalStudentCount == 0 || isSubmitting
// //                     ? null
// //                     : _submitAttendance,
// //                 child: isSubmitting
// //                     ? const SizedBox(
// //                         width: 19,
// //                         height: 19,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Color(0xFF8069E8),
// //                         ),
// //                       )
// //                     : Text(
// //                         isEditMode ? 'Update' : 'Save',
// //                         style: TextStyle(
// //                           color: totalStudentCount == 0
// //                               ? Colors.grey
// //                               : const Color(0xFF8069E8),
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //               ),
// //               const SizedBox(width: 8),
// //             ],
// //           ),
// //           body: SafeArea(
// //             top: false,
// //             child: _buildBody(state: state, isLoading: isLoading),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // ============================================================
// //   // BODY
// //   // ============================================================

// //   Widget _buildBody({required AttendanceState state, required bool isLoading}) {
// //     if (isLoading) {
// //       return const Center(
// //         child: CircularProgressIndicator(color: Color(0xFF8069E8)),
// //       );
// //     }

// //     if (state is AttendanceFailure) {
// //       return _buildErrorView(state.message);
// //     }

// //     if (state is StudentAttendanceFailure) {
// //       return _buildErrorView(state.message);
// //     }

// //     if (totalStudentCount == 0) {
// //       if (!addDataInitialized && !editDataInitialized) {
// //         return const Center(
// //           child: CircularProgressIndicator(color: Color(0xFF8069E8)),
// //         );
// //       }

// //       return _buildEmptyView();
// //     }

// //     return RefreshIndicator(
// //       color: const Color(0xFF8069E8),
// //       onRefresh: () async {
// //         _fetchStudents();
// //       },
// //       child: SingleChildScrollView(
// //         physics: const AlwaysScrollableScrollPhysics(),
// //         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
// //         padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
// //         child: Column(
// //           children: [
// //             _buildSummaryCard(),

// //             const SizedBox(height: 20),

// //             _buildSearchSection(),

// //             const SizedBox(height: 18),

// //             if (isEditMode) _buildEditStudentList() else _buildAddStudentList(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // ADD STUDENT LIST
// //   // ============================================================

// //   Widget _buildAddStudentList() {
// //     final students = filteredAddStudents;

// //     if (students.isEmpty) {
// //       return const Padding(
// //         padding: EdgeInsets.symmetric(vertical: 70),
// //         child: Text(
// //           'No students found',
// //           style: TextStyle(color: Colors.grey, fontSize: 14),
// //         ),
// //       );
// //     }

// //     return ListView.separated(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: students.length,
// //       separatorBuilder: (_, __) {
// //         return const SizedBox(height: 18);
// //       },
// //       itemBuilder: (context, index) {
// //         final student = students[index];
// //         final int originalIndex = addModeStudents.indexOf(student);

// //         return _buildStudentCard(
// //           index: originalIndex >= 0 ? originalIndex : index,
// //           name: student.name ?? '',
// //           admissionNo: student.admno ?? '',
// //           studentKey: _addStudentKey(student),
// //         );
// //       },
// //     );
// //   }

// //   // ============================================================
// //   // EDIT STUDENT LIST
// //   // ============================================================

// //   Widget _buildEditStudentList() {
// //     final students = filteredEditStudents;

// //     if (students.isEmpty) {
// //       return const Padding(
// //         padding: EdgeInsets.symmetric(vertical: 70),
// //         child: Text(
// //           'No students found',
// //           style: TextStyle(color: Colors.grey, fontSize: 14),
// //         ),
// //       );
// //     }

// //     return ListView.separated(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: students.length,
// //       separatorBuilder: (_, __) {
// //         return const SizedBox(height: 18);
// //       },
// //       itemBuilder: (context, index) {
// //         final student = students[index];
// //         final int originalIndex = editModeStudents.indexOf(student);

// //         return _buildStudentCard(
// //           index: originalIndex >= 0 ? originalIndex : index,
// //           name: student.name ?? '',
// //           admissionNo: student.admissionNo ?? '',
// //           studentKey: _editStudentKey(student),
// //         );
// //       },
// //     );
// //   }

// //   // ============================================================
// //   // SUMMARY CARD
// //   // ============================================================

// //   Widget _buildSummaryCard() {
// //     return Container(
// //       width: double.infinity,
// //       height: 150,
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF102F82), Color(0xFF1C4DA8)],
// //           begin: Alignment.centerLeft,
// //           end: Alignment.centerRight,
// //         ),
// //         borderRadius: BorderRadius.circular(24),
// //       ),
// //       child: Stack(
// //         children: [
// //           Positioned(
// //             left: 105,
// //             top: 6,
// //             child: Container(
// //               width: 110,
// //               height: 130,
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.04),
// //                 shape: BoxShape.circle,
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             right: 0,
// //             top: 0,
// //             bottom: 0,
// //             child: Container(
// //               width: 125,
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFF506FC6).withOpacity(0.88),
// //                 borderRadius: BorderRadius.circular(24),
// //               ),
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       _buildStatItem(
// //                         title: 'Present',
// //                         value: presentStudentCount.toString(),
// //                       ),
// //                       _buildStatItem(
// //                         title: 'Absent',
// //                         value: absentStudentCount.toString(),
// //                       ),
// //                     ],
// //                   ),
// //                   const Spacer(),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       _buildStatItem(
// //                         title: 'Total',
// //                         value: totalStudentCount.toString(),
// //                       ),
// //                       _buildStatItem(
// //                         title: 'Attendance',
// //                         value: '${attendancePercentage.toStringAsFixed(0)}%',
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             left: 16,
// //             top: 18,
// //             right: 125,
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       flex: 6,
// //                       child: _buildInfoItem(
// //                         iconPath: 'assets/icons/Group (12).svg',
// //                         iconColor: const Color(0xFFFCFFBB),
// //                         label: 'Date',
// //                         value: _formatDisplayDate(widget.attendanceDate),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       flex: 5,
// //                       child: _buildInfoItem(
// //                         iconPath: 'assets/icons/Group (13).svg',
// //                         iconColor: const Color(0xFFC5E5FF),
// //                         label: 'Section',
// //                         value: widget.section,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 28),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       flex: 6,
// //                       child: _buildInfoItem(
// //                         iconPath: 'assets/icons/Group 950.svg',
// //                         iconColor: const Color(0xFF98FFEE),
// //                         label: 'Standard',
// //                         value: widget.standard,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       flex: 5,
// //                       child: _buildInfoItem(
// //                         iconPath: 'assets/icons/Vector (2).svg',
// //                         iconColor: const Color(0xFFFFA5A5),
// //                         label: 'Division',
// //                         value: widget.division,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildInfoItem({
// //     required String iconPath,
// //     required Color iconColor,
// //     required String label,
// //     required String value,
// //   }) {
// //     return Row(
// //       children: [
// //         Container(
// //           width: 32,
// //           height: 32,
// //           decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
// //           alignment: Alignment.center,
// //           child: SvgPicture.asset(iconPath, width: 17, height: 17),
// //         ),
// //         const SizedBox(width: 7),
// //         Flexible(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 label,
// //                 maxLines: 1,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 11,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               FittedBox(
// //                 fit: BoxFit.scaleDown,
// //                 alignment: Alignment.centerLeft,
// //                 child: Text(
// //                   value,
// //                   maxLines: 1,
// //                   style: const TextStyle(color: Colors.white, fontSize: 12),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildStatItem({required String title, required String value}) {
// //     final bool isAbsent = title == 'Absent';

// //     return SizedBox(
// //       width: 48,
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(title, style: const TextStyle(color: Colors.white, fontSize: 9)),
// //           const SizedBox(height: 7),
// //           SizedBox(
// //             width: 28,
// //             height: 28,
// //             child: isAbsent
// //                 ? Container(
// //                     alignment: Alignment.center,
// //                     decoration: const BoxDecoration(
// //                       color: Colors.white,
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: Text(
// //                       value,
// //                       style: const TextStyle(
// //                         color: Color(0xFFFF3B30),
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                     ),
// //                   )
// //                 : Center(
// //                     child: Text(
// //                       value,
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                     ),
// //                   ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // SEARCH
// //   // ============================================================

// //   Widget _buildSearchSection() {
// //     return Column(
// //       children: [
// //         Row(
// //           children: [
// //             const Expanded(
// //               child: Text(
// //                 'Attendance Details',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF333333),
// //                 ),
// //               ),
// //             ),
// //             InkWell(
// //               onTap: () {
// //                 setState(() {
// //                   showSearchField = !showSearchField;

// //                   if (!showSearchField) {
// //                     searchController.clear();
// //                     searchText = '';
// //                   }
// //                 });
// //               },
// //               borderRadius: BorderRadius.circular(24),
// //               child: Container(
// //                 width: 42,
// //                 height: 42,
// //                 decoration: const BoxDecoration(
// //                   color: Color(0xFF7A6AE6),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(
// //                   showSearchField ? Icons.close : Icons.search_rounded,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         if (showSearchField) ...[
// //           const SizedBox(height: 14),
// //           TextField(
// //             controller: searchController,
// //             autofocus: true,
// //             onChanged: (value) {
// //               setState(() {
// //                 searchText = value;
// //               });
// //             },
// //             decoration: InputDecoration(
// //               hintText: 'Search student',
// //               prefixIcon: const Icon(Icons.search),
// //               suffixIcon: searchText.isEmpty
// //                   ? null
// //                   : IconButton(
// //                       onPressed: () {
// //                         searchController.clear();

// //                         setState(() {
// //                           searchText = '';
// //                         });
// //                       },
// //                       icon: const Icon(Icons.close),
// //                     ),
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ],
// //     );
// //   }

// //   // ============================================================
// //   // STUDENT CARD
// //   // ============================================================

// //   Widget _buildStudentCard({
// //     required int index,
// //     required String name,
// //     required String admissionNo,
// //     required String studentKey,
// //   }) {
// //     final bool isPresent = attendanceStatus[studentKey] ?? true;

// //     final Color backgroundColor = isPresent
// //         ? const Color(0xFFF6F6FF)
// //         : const Color(0xFFFFE3E5);

// //     return AnimatedContainer(
// //       duration: const Duration(milliseconds: 250),
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: backgroundColor,
// //         borderRadius: BorderRadius.circular(18),
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       '#${index + 1}',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 9),
// //                     Text(
// //                       name,
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 9),
// //                     Text(admissionNo, style: const TextStyle(fontSize: 14)),
// //                   ],
// //                 ),
// //               ),
// //               Column(
// //                 children: [
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 16,
// //                       vertical: 7,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: isPresent
// //                           ? const Color(0xFFA5FF91)
// //                           : const Color(0xFFF0222E),
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Text(
// //                       isPresent ? 'Present' : 'Absent',
// //                       style: TextStyle(
// //                         color: isPresent
// //                             ? const Color(0xFF174F0E)
// //                             : Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                   Switch(
// //                     value: isPresent,
// //                     activeTrackColor: const Color(0xFF28D10C),
// //                     inactiveTrackColor: const Color(0xFFF0222E),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         attendanceStatus[studentKey] = value;

// //                         if (value) {
// //                           leaveTypes[studentKey] = null;
// //                           remarks[studentKey] = '';
// //                         }
// //                       });
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           if (!isPresent) ...[
// //             const SizedBox(height: 18),
// //             Row(
// //               children: [
// //                 Expanded(child: _buildLeaveDropdown(studentKey)),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: TextFormField(
// //                     key: ValueKey('${studentKey}_${remarks[studentKey] ?? ''}'),
// //                     initialValue: remarks[studentKey] ?? '',
// //                     onChanged: (value) {
// //                       remarks[studentKey] = value;
// //                     },
// //                     decoration: const InputDecoration(hintText: 'Remark'),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildLeaveDropdown(String studentKey) {
// //     const List<String> defaultLeaveTypes = [
// //       'Sick Leave',
// //       'Casual Leave',
// //       'Emergency Leave',
// //     ];

// //     final String? currentValue = leaveTypes[studentKey];
// //     final List<String> options = [...defaultLeaveTypes];

// //     // Prevent DropdownButton assertion when API returns values such as "NA".
// //     if (currentValue != null &&
// //         currentValue.trim().isNotEmpty &&
// //         !options.contains(currentValue)) {
// //       options.insert(0, currentValue);
// //     }

// //     final String? dropdownValue =
// //         currentValue == null || currentValue.trim().isEmpty
// //         ? null
// //         : currentValue;

// //     return DropdownButtonFormField<String>(
// //       value: dropdownValue,
// //       // Without this the button sizes itself to its widest menu item
// //       // instead of to the width it was given, which overflows on small
// //       // screens.
// //       isExpanded: true,
// //       hint: const Text('Select Leave Type', overflow: TextOverflow.ellipsis),
// //       items: options.map((leaveType) {
// //         return DropdownMenuItem<String>(
// //           value: leaveType,
// //           child: Text(leaveType, overflow: TextOverflow.ellipsis),
// //         );
// //       }).toList(),
// //       onChanged: (value) {
// //         setState(() {
// //           leaveTypes[studentKey] = value;
// //         });
// //       },
// //     );
// //   }

// //   // ============================================================
// //   // DATE
// //   // ============================================================

// //   String _formatDisplayDate(DateTime date) {
// //     final String day = date.day.toString().padLeft(2, '0');
// //     final String month = date.month.toString().padLeft(2, '0');

// //     return '$day/$month/${date.year}';
// //   }

// //   String _formatApiDate(DateTime date) {
// //     final String month = date.month.toString().padLeft(2, '0');
// //     final String day = date.day.toString().padLeft(2, '0');

// //     return '${date.year}-$month-$day';
// //   }

// //   // ============================================================
// //   // ERROR AND EMPTY
// //   // ============================================================

// //   Widget _buildErrorView(String message) {
// //     return Center(
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(message),
// //           const SizedBox(height: 18),
// //           ElevatedButton(onPressed: _fetchStudents, child: const Text('Retry')),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyView() {
// //     return const Center(child: Text('No students found'));
// //   }

// //   void _showMessage(String message) {
// //     if (!mounted) {
// //       return;
// //     }

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
// //     );
// //   }
// // }
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

// /// One row of the absentee summary shown before saving.
// class AbsentStudent {
//   final String name;
//   final String admissionNo;
//   final String? leaveType;
//   final String remark;

//   const AbsentStudent({
//     required this.name,
//     required this.admissionNo,
//     required this.leaveType,
//     required this.remark,
//   });
// }

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
//   // ABSENTEES
//   // ============================================================

//   /// Everyone currently switched to absent, in list order. Read from the
//   /// full student list, not the filtered one, so a search does not hide
//   /// anybody from the summary.
//   List<AbsentStudent> get absentStudents {
//     final List<AbsentStudent> absentees = [];

//     if (isEditMode) {
//       for (final student in editModeStudents) {
//         final String key = _editStudentKey(student);

//         if (attendanceStatus[key] ?? true) {
//           continue;
//         }

//         absentees.add(
//           AbsentStudent(
//             name: student.name ?? '',
//             admissionNo: student.admissionNo ?? '',
//             leaveType: leaveTypes[key],
//             remark: remarks[key] ?? '',
//           ),
//         );
//       }
//     } else {
//       for (final student in addModeStudents) {
//         final String key = _addStudentKey(student);

//         if (attendanceStatus[key] ?? true) {
//           continue;
//         }

//         absentees.add(
//           AbsentStudent(
//             name: student.name ?? '',
//             admissionNo: student.admno ?? '',
//             leaveType: leaveTypes[key],
//             remark: remarks[key] ?? '',
//           ),
//         );
//       }
//     }

//     return absentees;
//   }

//   /// Asked before a student is switched to absent. Returns false when the
//   /// dialog is dismissed, so the switch stays where it was.
//   Future<bool> _confirmMarkAbsent(String name) async {
//     final String studentName = name.trim().isEmpty ? 'this student' : name;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             'Mark absent',
//             style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//           ),
//           content: Text(
//             'Mark $studentName as absent?',
//             style: const TextStyle(fontSize: 14),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext, false);
//               },
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Color(0xFF666666)),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext, true);
//               },
//               child: const Text(
//                 'Mark absent',
//                 style: TextStyle(
//                   color: Color(0xFFF0222E),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     return confirmed ?? false;
//   }

//   /// The last look before the attendance is sent: who is absent, with the
//   /// leave type and remark entered for each.
//   Future<bool> _confirmAbsentees() async {
//     final List<AbsentStudent> absentees = absentStudents;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           titlePadding: const EdgeInsets.fromLTRB(22, 20, 22, 8),
//           contentPadding: const EdgeInsets.fromLTRB(22, 0, 22, 4),
//           title: Text(
//             isEditMode ? 'Update attendance' : 'Save attendance',
//             style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//           ),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Present ${presentStudentCount}   •   '
//                   'Absent ${absentees.length}   •   '
//                   'Total $totalStudentCount',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF555555),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 if (absentees.isEmpty)
//                   const Text(
//                     'All students are marked present.',
//                     style: TextStyle(fontSize: 14),
//                   )
//                 else ...[
//                   const Text(
//                     'Absentees',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFFF0222E),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Constrained so a long list scrolls inside the dialog
//                   // instead of overflowing it.
//                   ConstrainedBox(
//                     constraints: const BoxConstraints(maxHeight: 260),
//                     child: Scrollbar(
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: absentees.length,
//                         separatorBuilder: (_, __) {
//                           return const Divider(height: 14);
//                         },
//                         itemBuilder: (_, index) {
//                           return _buildAbsenteeRow(index, absentees[index]);
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext, false);
//               },
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Color(0xFF666666)),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext, true);
//               },
//               child: Text(
//                 isEditMode ? 'Update' : 'Save',
//                 style: const TextStyle(
//                   color: Color(0xFF8069E8),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     return confirmed ?? false;
//   }

//   Widget _buildAbsenteeRow(int index, AbsentStudent student) {
//     final String leaveType = student.leaveType?.trim() ?? '';
//     final String remark = student.remark.trim();

//     final List<String> extras = [
//       if (leaveType.isNotEmpty) leaveType,
//       if (remark.isNotEmpty) remark,
//     ];

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '${index + 1}.',
//           style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 student.name.trim().isEmpty ? 'Student' : student.name,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               if (student.admissionNo.trim().isNotEmpty) ...[
//                 const SizedBox(height: 2),
//                 Text(
//                   student.admissionNo,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF666666),
//                   ),
//                 ),
//               ],
//               if (extras.isNotEmpty) ...[
//                 const SizedBox(height: 2),
//                 Text(
//                   extras.join('  •  '),
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: Color(0xFF888888),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // SAVE OR UPDATE
//   // ============================================================

//   Future<void> _submitAttendance() async {
//     if (totalStudentCount == 0) {
//       _showMessage('No students available');
//       return;
//     }

//     final bool confirmed = await _confirmAbsentees();

//     if (!confirmed || !mounted) {
//       return;
//     }

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
//                     onChanged: (value) async {
//                       // Marking absent is confirmed first; switching back
//                       // to present needs no confirmation.
//                       if (!value) {
//                         final bool confirmed = await _confirmMarkAbsent(name);

//                         if (!confirmed || !mounted) {
//                           return;
//                         }
//                       }

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
//       // Without this the button sizes itself to its widest menu item
//       // instead of to the width it was given, which overflows on small
//       // screens.
//       isExpanded: true,
//       hint: const Text('Select Leave Type', overflow: TextOverflow.ellipsis),
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

/// One row of the absentee summary shown before saving.
class AbsentStudent {
  final String name;
  final String admissionNo;
  final String? leaveType;
  final String remark;

  const AbsentStudent({
    required this.name,
    required this.admissionNo,
    required this.leaveType,
    required this.remark,
  });
}

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
  // ABSENTEES
  // ============================================================

  /// Everyone currently switched to absent, in list order. Read from the
  /// full student list, not the filtered one, so a search does not hide
  /// anybody from the summary.
  List<AbsentStudent> get absentStudents {
    final List<AbsentStudent> absentees = [];

    if (isEditMode) {
      for (final student in editModeStudents) {
        final String key = _editStudentKey(student);

        if (attendanceStatus[key] ?? true) {
          continue;
        }

        absentees.add(
          AbsentStudent(
            name: student.name ?? '',
            admissionNo: student.admissionNo ?? '',
            leaveType: leaveTypes[key],
            remark: remarks[key] ?? '',
          ),
        );
      }
    } else {
      for (final student in addModeStudents) {
        final String key = _addStudentKey(student);

        if (attendanceStatus[key] ?? true) {
          continue;
        }

        absentees.add(
          AbsentStudent(
            name: student.name ?? '',
            admissionNo: student.admno ?? '',
            leaveType: leaveTypes[key],
            remark: remarks[key] ?? '',
          ),
        );
      }
    }

    return absentees;
  }

  /// Asked before a student is switched to absent. Returns false when the
  /// dialog is dismissed, so the switch stays where it was.
  Future<bool> _confirmMarkAbsent(String name) async {
    final String studentName = name.trim().isEmpty ? 'this student' : name;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Same red family as the absent card and the Absent pill.
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE3E5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_off_outlined,
                    color: Color(0xFFF0222E),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mark as absent?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  studentName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                // const SizedBox(height: 6),
                // const Text(
                //   'You can switch the student back to present at any time.',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                // ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _dialogOutlinedButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dialogFilledButton(
                        label: 'Mark Absent',
                        color: const Color(0xFFF0222E),
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return confirmed ?? false;
  }

  /// The last look before the attendance is sent: who is absent, with the
  /// leave type and remark entered for each.
  Future<bool> _confirmAbsentees() async {
    final List<AbsentStudent> absentees = absentStudents;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              _buildDialogStats(absentees.length),
              if (absentees.isEmpty)
                _buildAllPresentView()
              else
                Flexible(child: _buildAbsenteeList(absentees)),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: _dialogOutlinedButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dialogFilledButton(
                        label: 'Ok',
                        color: const Color(0xFF8069E8),
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return confirmed ?? false;
  }

  /// Carries the gradient of the summary card into the dialog, with the
  /// same date / section / class line the card shows.
  Widget _buildDialogHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF102F82), Color(0xFF1C4DA8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/Group (12).svg',
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditMode ? 'Update Attendance' : 'Save Attendance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_formatDisplayDate(widget.attendanceDate)}   |   '
                  '${widget.section}   |   '
                  '${widget.standard} ${widget.division}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogStats(int absentCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      child: Row(
        children: [
          Expanded(
            child: _buildStatPill(
              label: 'Present',
              value: presentStudentCount.toString(),
              textColor: const Color(0xFF174F0E),
              backgroundColor: const Color(0xFFEAFBE6),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatPill(
              label: 'Absent',
              value: absentCount.toString(),
              textColor: const Color(0xFFF0222E),
              backgroundColor: const Color(0xFFFFE3E5),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatPill(
              label: 'Total',
              value: totalStudentCount.toString(),
              textColor: const Color(0xFF3B3B6B),
              backgroundColor: const Color(0xFFF6F6FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required String label,
    required String value,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: textColor.withOpacity(0.75),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllPresentView() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 22, 20, 6),
      child: Column(
        children: [
          Icon(Icons.verified_rounded, size: 40, color: Color(0xFF28D10C)),
          SizedBox(height: 10),
          Text(
            'All students are marked present',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Nothing to review before saving.',
            style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenteeList(List<AbsentStudent> absentees) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0222E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Absentees (${absentees.length})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF0222E),
                ),
              ),
            ],
          ),
        ),

        // Capped so a large class scrolls inside the dialog instead of
        // pushing the buttons off screen.
        Flexible(
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              itemCount: absentees.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: 8);
              },
              itemBuilder: (_, index) {
                return _buildAbsenteeRow(index, absentees[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAbsenteeRow(int index, AbsentStudent student) {
    final String leaveType = student.leaveType?.trim() ?? '';
    final String remark = student.remark.trim();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE3E5).withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFFF0222E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  student.name.trim().isEmpty ? 'Student' : student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                if (student.admissionNo.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    student.admissionNo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ],
                if (leaveType.isNotEmpty || remark.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (leaveType.isNotEmpty)
                        _buildDetailChip(
                          icon: Icons.event_busy_rounded,
                          label: leaveType,
                        ),
                      if (remark.isNotEmpty)
                        _buildDetailChip(
                          icon: Icons.sticky_note_2_outlined,
                          label: remark,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF8069E8)),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogOutlinedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF666666),
          side: const BorderSide(color: Color(0xFFDDDDE6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _dialogFilledButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ============================================================
  // SAVE OR UPDATE
  // ============================================================

  Future<void> _submitAttendance() async {
    if (totalStudentCount == 0) {
      _showMessage('No students available');
      return;
    }

    final bool confirmed = await _confirmAbsentees();

    if (!confirmed || !mounted) {
      return;
    }

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
                    onChanged: (value) async {
                      // Marking absent is confirmed first; switching back
                      // to present needs no confirmation.
                      if (!value) {
                        final bool confirmed = await _confirmMarkAbsent(name);

                        if (!confirmed || !mounted) {
                          return;
                        }
                      }

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
