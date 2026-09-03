// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/exams/domain/entities/fetchexam_entity.dart';
// import 'package:cristalteacher/features/exams/domain/parameters/fetch_exam_parameter.dart';
// import 'package:cristalteacher/features/exams/presentation/cubit/exam_cubit.dart';
// import 'package:cristalteacher/features/exams/presentation/screens/selectexam_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class ExamScreen extends StatefulWidget {
//   const ExamScreen({super.key});

//   @override
//   State<ExamScreen> createState() => _ExamScreenState();
// }

// class _ExamScreenState extends State<ExamScreen> {
//   static const Color primaryColor = Color(0xFF5A20E7);
//   static const Color lightPurple = Color(0xFFF7F3FF);
//   static const Color borderColor = Color(0xFFE8E8E8);

//   final TextEditingController searchController = TextEditingController();

//   int? selectedStandardId;
//   String? selectedStandardName;

//   DateTime? fromDate;
//   DateTime? toDate;

//   List<MarkEntryEntity> exams = [];

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchTutorshipClasses();
//       _fetchExams();
//     });
//   }

//   void _fetchTutorshipClasses() {
//     final request = FetchTutorshipClassRequest(
//       accyear: AppData.accYear,
//       employeeId: AppData.employeeId,
//       userId: AppData.userId,
//     );

//     debugPrint('==========================================');
//     debugPrint('📘 FETCH TUTORSHIP CLASS');
//     debugPrint('Request: ${request.toJson()}');
//     debugPrint('==========================================');

//     context.read<AuthenticationCubit>().fetchTutorshipClass(request);
//   }

//   String? _formatApiDate(DateTime? date) {
//     if (date == null) return null;

//     return '${date.year.toString().padLeft(4, '0')}-'
//         '${date.month.toString().padLeft(2, '0')}-'
//         '${date.day.toString().padLeft(2, '0')}';
//   }

//   Future<void> _fetchExams() async {
//     final String? selectedFromDate = _formatApiDate(fromDate);
//     final String? selectedToDate = _formatApiDate(toDate);

//     final request = FetchMarkEntryParameter(
//       accYear: AppData.accYear ?? '',
//       branchId: AppData.branchId ?? 1,
//       standardId: selectedStandardId,
//       divisionId: null,
//       subjectId: null,
//       examTermId: null,
//       examTypeId: null,

//       // Logged-in teacher.
//       employeeId: AppData.employeeId,

//       fromDate: selectedFromDate,
//       toDate: selectedToDate,
//     );

//     debugPrint('==========================================');
//     debugPrint('📘 FETCH MARK ENTRY');
//     debugPrint('AccYear: ${AppData.accYear}');
//     debugPrint('BranchId: ${AppData.branchId ?? 1}');
//     debugPrint('StandardId: $selectedStandardId');
//     debugPrint('FromDate: $selectedFromDate');
//     debugPrint('ToDate: $selectedToDate');
//     debugPrint('Request: ${request.toJson()}');
//     debugPrint('==========================================');

//     await context.read<ExamCubit>().fetchMarkEntry(request);
//   }

//   List<MarkEntryEntity> get filteredExams {
//     final query = searchController.text.trim().toLowerCase();

//     return exams.where((exam) {
//       final matchesSearch =
//           query.isEmpty ||
//           (exam.examName ?? '').toLowerCase().contains(query) ||
//           (exam.standard ?? '').toLowerCase().contains(query) ||
//           (exam.division ?? '').toLowerCase().contains(query) ||
//           (exam.subjectName ?? '').toLowerCase().contains(query) ||
//           (exam.gradePlanName ?? '').toLowerCase().contains(query);

//       final examDate = _parseDate(exam.examDate);

//       final matchesFromDate =
//           fromDate == null ||
//           examDate == null ||
//           !examDate.isBefore(_dateOnly(fromDate!));

//       final matchesToDate =
//           toDate == null ||
//           examDate == null ||
//           !examDate.isAfter(_dateOnly(toDate!));

//       final matchesStandard =
//           selectedStandardId == null || exam.standardId == selectedStandardId;

//       return matchesSearch &&
//           matchesFromDate &&
//           matchesToDate &&
//           matchesStandard;
//     }).toList();
//   }

//   DateTime _dateOnly(DateTime date) {
//     return DateTime(date.year, date.month, date.day);
//   }

//   DateTime? _parseDate(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return null;
//     }

//     try {
//       return DateTime.parse(value.replaceFirst(' ', 'T'));
//     } catch (_) {
//       return null;
//     }
//   }

//   String _formatDisplayDate(String? value) {
//     final date = _parseDate(value);

//     if (date == null) {
//       return value?.isNotEmpty == true ? value! : '--';
//     }

//     return '${date.day.toString().padLeft(2, '0')}-'
//         '${date.month.toString().padLeft(2, '0')}-'
//         '${date.year}';
//   }

//   Future<void> _selectDate({required bool isFromDate}) async {
//     final DateTime initialDate = isFromDate
//         ? fromDate ?? DateTime.now()
//         : toDate ?? fromDate ?? DateTime.now();

//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2035),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: primaryColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (selectedDate == null || !mounted) return;

//     final DateTime selectedDateOnly = _dateOnly(selectedDate);

//     if (isFromDate) {
//       setState(() {
//         fromDate = selectedDateOnly;

//         if (toDate != null && selectedDateOnly.isAfter(toDate!)) {
//           toDate = null;
//         }
//       });
//     } else {
//       if (fromDate != null && selectedDateOnly.isBefore(fromDate!)) {
//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(
//             const SnackBar(content: Text('To date cannot be before from date')),
//           );

//         return;
//       }

//       setState(() {
//         toDate = selectedDateOnly;
//       });
//     }

//     await _fetchExams();
//   }

//   Future<void> _clearFromDate() async {
//     setState(() {
//       fromDate = null;
//     });

//     await _fetchExams();
//   }

//   Future<void> _clearToDate() async {
//     setState(() {
//       toDate = null;
//     });

//     await _fetchExams();
//   }

//   Future<void> _editExam(MarkEntryEntity exam) async {
//     final result = await Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (_) => SelectExamScreen(exam: exam)));

//     if (!mounted) return;

//     if (result == true) {
//       await _fetchExams();
//     }
//   }

//   void _deleteExam(MarkEntryEntity exam) {
//     showDialog<void>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text('Delete exam'),
//           content: Text(
//             'Are you sure you want to delete '
//             '${exam.examName ?? 'this exam'}?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);

//                 context.read<ExamCubit>().deleteExamMark(exam.markEntryId);
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _addExam() async {
//     final result = await Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (_) => const SelectExamScreen()));

//     if (!mounted) return;

//     if (result == true) {
//       await _fetchExams();
//     }
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: const Text(
//           'Details',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           _buildFilterSection(),
//           Expanded(
//             child: BlocConsumer<ExamCubit, ExamState>(
//               listener: (context, state) async {
//                 if (state is ExamSuccess) {
//                   setState(() {
//                     exams = state.response.data ?? [];
//                   });
//                 }

//                 if (state is ExamFailure && exams.isNotEmpty) {
//                   ScaffoldMessenger.of(context)
//                     ..hideCurrentSnackBar()
//                     ..showSnackBar(SnackBar(content: Text(state.message)));
//                 }

//                 if (state is DeleteExamMarkSuccess) {
//                   ScaffoldMessenger.of(context)
//                     ..hideCurrentSnackBar()
//                     ..showSnackBar(
//                       const SnackBar(
//                         content: Text('Exam deleted successfully'),
//                       ),
//                     );

//                   await _fetchExams();
//                 }

//                 if (state is DeleteExamMarkFailure) {
//                   ScaffoldMessenger.of(context)
//                     ..hideCurrentSnackBar()
//                     ..showSnackBar(SnackBar(content: Text(state.message)));
//                 }

//                 if (state is SaveExamMarksSuccess ||
//                     state is UpdateMarkEntrySuccess) {
//                   await _fetchExams();
//                 }
//               },
//               builder: (context, state) {
//                 if (state is ExamLoading && exams.isEmpty) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: primaryColor),
//                   );
//                 }

//                 if (state is ExamFailure && exams.isEmpty) {
//                   return _buildFailureView(state.message);
//                 }

//                 return _buildExamList(isRefreshing: state is ExamLoading);
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addExam,
//         backgroundColor: const Color(0xFF075BBF),
//         shape: const CircleBorder(),
//         child: const Icon(Icons.add, color: Colors.white, size: 34),
//       ),
//     );
//   }

//   Widget _buildFilterSection() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(28, 12, 28, 18),
//       child: Column(
//         children: [
//           _buildStandardDropdown(),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   title: 'From date',
//                   date: fromDate,
//                   onTap: () {
//                     _selectDate(isFromDate: true);
//                   },
//                   onClear: _clearFromDate,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _buildDateField(
//                   title: 'To date',
//                   date: toDate,
//                   onTap: () {
//                     _selectDate(isFromDate: false);
//                   },
//                   onClear: _clearToDate,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildSearchField(),
//         ],
//       ),
//     );
//   }

//   Widget _buildStandardDropdown() {
//     return BlocBuilder<AuthenticationCubit, AuthenticationState>(
//       builder: (context, state) {
//         if (state is FetchTutorshipClassLoading) {
//           return _buildStandardLoadingField();
//         }

//         if (state is FetchTutorshipClassFailure) {
//           return InkWell(
//             onTap: _fetchTutorshipClasses,
//             borderRadius: BorderRadius.circular(11),
//             child: InputDecorator(
//               decoration: _standardDecoration(),
//               child: const Text(
//                 'Unable to load standards. Tap to retry',
//                 style: TextStyle(fontSize: 12, color: Colors.red),
//               ),
//             ),
//           );
//         }

//         List<TutorshipClass> standards = [];

//         if (state is FetchTutorshipClassSuccess) {
//           standards = state.response.data?.tutorshipClass ?? [];
//         }

//         final uniqueStandards = <int, TutorshipClass>{};

//         for (final item in standards) {
//           final id = item.standardId;

//           if (id != null) {
//             uniqueStandards[id] = item;
//           }
//         }

//         final standardList = uniqueStandards.values.toList();

//         final valueExists = standardList.any(
//           (item) => item.standardId == selectedStandardId,
//         );

//         return DropdownButtonFormField<int>(
//           value: valueExists ? selectedStandardId : null,
//           isExpanded: true,
//           icon: const Icon(Icons.keyboard_arrow_down, color: primaryColor),
//           hint: const Text(
//             'Standard',
//             style: TextStyle(fontSize: 12, color: Color(0xFF4B4B4B)),
//           ),
//           decoration: _standardDecoration(),
//           items: [
//             const DropdownMenuItem<int>(
//               value: -1,
//               child: Text('All standards'),
//             ),
//             ...standardList.map((item) {
//               return DropdownMenuItem<int>(
//                 value: item.standardId,
//                 child: Text(
//                   item.standard ?? 'Standard',
//                   style: const TextStyle(fontSize: 12, color: Colors.black87),
//                 ),
//               );
//             }),
//           ],
//           onChanged: (value) async {
//             TutorshipClass? selectedItem;

//             for (final item in standardList) {
//               if (item.standardId == value) {
//                 selectedItem = item;
//                 break;
//               }
//             }

//             setState(() {
//               if (value == -1) {
//                 selectedStandardId = null;
//                 selectedStandardName = null;
//               } else {
//                 selectedStandardId = value;
//                 selectedStandardName = selectedItem?.standard;
//               }
//             });

//             await _fetchExams();
//           },
//         );
//       },
//     );
//   }

//   InputDecoration _standardDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       prefixIcon: Padding(
//         padding: const EdgeInsets.only(left: 12, right: 6),
//         child: SvgPicture.asset(
//           'assets/icons/Group (14).svg',
//           width: 14,
//           height: 14,
//           fit: BoxFit.contain,
//         ),
//       ),
//       prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 30),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(11),
//         borderSide: const BorderSide(color: borderColor),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(11),
//         borderSide: const BorderSide(color: primaryColor),
//       ),
//     );
//   }

//   Widget _buildStandardLoadingField() {
//     return InputDecorator(
//       decoration: _standardDecoration(),
//       child: const Row(
//         children: [
//           SizedBox(
//             width: 15,
//             height: 15,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               color: primaryColor,
//             ),
//           ),
//           SizedBox(width: 10),
//           Text(
//             'Loading standards...',
//             style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: searchController,
//       onChanged: (_) {
//         setState(() {});
//       },
//       decoration: InputDecoration(
//         hintText: 'Search',
//         hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
//         prefixIcon: const Icon(
//           Icons.search,
//           size: 19,
//           color: Color(0xFF777777),
//         ),
//         suffixIcon: searchController.text.isNotEmpty
//             ? IconButton(
//                 onPressed: () {
//                   searchController.clear();
//                   setState(() {});
//                 },
//                 icon: const Icon(Icons.close, size: 18),
//               )
//             : null,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 12,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(11),
//           borderSide: const BorderSide(color: borderColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(11),
//           borderSide: const BorderSide(color: primaryColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildExamList({required bool isRefreshing}) {
//     final examList = filteredExams;

//     if (examList.isEmpty) {
//       return RefreshIndicator(
//         color: primaryColor,
//         onRefresh: _fetchExams,
//         child: ListView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           children: const [
//             SizedBox(height: 180),
//             Center(
//               child: Text(
//                 'No exams found',
//                 style: TextStyle(color: Colors.grey, fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         RefreshIndicator(
//           color: primaryColor,
//           onRefresh: _fetchExams,
//           child: ListView.separated(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.fromLTRB(30, 18, 30, 90),
//             itemCount: examList.length,
//             separatorBuilder: (_, __) {
//               return const SizedBox(height: 12);
//             },
//             itemBuilder: (context, index) {
//               return _buildExamCard(examList[index]);
//             },
//           ),
//         ),
//         if (isRefreshing)
//           const Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: LinearProgressIndicator(minHeight: 2, color: primaryColor),
//           ),
//       ],
//     );
//   }

//   Widget _buildFailureView(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
//             const SizedBox(height: 12),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _fetchExams,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField({
//     required String title,
//     required DateTime? date,
//     required VoidCallback onTap,
//     required VoidCallback onClear,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(11),
//       child: Container(
//         height: 42,
//         padding: const EdgeInsets.symmetric(horizontal: 9),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(11),
//           border: Border.all(color: borderColor),
//         ),
//         child: Row(
//           children: [
//             buildPurpleIcon(
//               'assets/icons/Group (15).svg',
//               iconColor: const Color(0xFF8561E1),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 date == null
//                     ? title
//                     : '${date.day.toString().padLeft(2, '0')}-'
//                           '${date.month.toString().padLeft(2, '0')}-'
//                           '${date.year}',
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: date == null
//                       ? const Color(0xFF666666)
//                       : Colors.black87,
//                 ),
//               ),
//             ),
//             if (date != null)
//               IconButton(
//                 constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
//                 padding: EdgeInsets.zero,
//                 splashRadius: 16,
//                 onPressed: onClear,
//                 icon: const Icon(Icons.close, size: 15, color: Colors.grey),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildPurpleIcon(
//     String assetPath, {
//     double size = 28,
//     double iconSize = 15,
//     Color iconColor = primaryColor,
//     Color backgroundColor = lightPurple,
//   }) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(7),
//       ),
//       alignment: Alignment.center,
//       child: SvgPicture.asset(
//         assetPath,
//         width: iconSize,
//         height: iconSize,
//         colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
//       ),
//     );
//   }

//   Widget _buildExamCard(MarkEntryEntity exam) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 13, 14, 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(11),
//         border: Border.all(color: const Color(0xFFDEDEDE)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 7,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   exam.examName ?? 'Exam',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => _editExam(exam),
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                   child: Text(
//                     'Edit',
//                     style: TextStyle(color: Color(0xFF32B900), fontSize: 9),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => _deleteExam(exam),
//                 child: const Padding(
//                   padding: EdgeInsets.only(left: 5, top: 2, bottom: 2),
//                   child: Text(
//                     'Delete',
//                     style: TextStyle(color: Colors.red, fontSize: 9),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 7),
//           Text(
//             _formatDisplayDate(exam.examDate),
//             style: const TextStyle(color: Color(0xFF6D6D6D), fontSize: 10),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             height: 64,
//             decoration: BoxDecoration(
//               color: lightPurple,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildExamInfo(
//                     assetPath: 'assets/icons/Group 951.svg',
//                     title: 'Class',
//                     value: exam.standard ?? '--',
//                   ),
//                 ),
//                 _buildDivider(),
//                 Expanded(
//                   child: _buildExamInfo(
//                     assetPath: 'assets/icons/Group (17).svg',
//                     title: 'Division',
//                     value: exam.division ?? '--',
//                   ),
//                 ),
//                 _buildDivider(),
//                 Expanded(
//                   child: _buildExamInfo(
//                     assetPath: 'assets/icons/Group (18).svg',
//                     title: 'Subject',
//                     value: exam.subjectName ?? '--',
//                     valueFontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExamInfo({
//     required String assetPath,
//     required String title,
//     required String value,
//     double valueFontSize = 14,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 24,
//                 height: 24,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 alignment: Alignment.center,
//                 child: SvgPicture.asset(assetPath, width: 13, height: 13),
//               ),
//               const SizedBox(width: 5),
//               Flexible(
//                 child: Text(
//                   title,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Color(0xFF555555), fontSize: 9),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: const Color(0xFF4D21DB),
//               fontSize: valueFontSize,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Container(width: 1, height: 38, color: const Color(0xFFE8E0F8));
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/exams/domain/entities/fetchexam_entity.dart';
import 'package:cristalteacher/features/exams/domain/parameters/fetch_exam_parameter.dart';
import 'package:cristalteacher/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:cristalteacher/features/exams/presentation/screens/selectexam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  static const Color primaryColor = Color(0xFF5A20E7);
  static const Color lightPurple = Color(0xFFF7F3FF);
  static const Color borderColor = Color(0xFFE8E8E8);

  final TextEditingController searchController = TextEditingController();

  int? selectedStandardId;
  String? selectedStandardName;

  DateTime? fromDate;
  DateTime? toDate;

  List<MarkEntryEntity> exams = [];

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    fromDate = today;
    toDate = today;

    final Map<int, TutorshipClass> uniqueStandards = {};

    for (final TutorshipClass item in AppData.standards) {
      final int? standardId = item.standardId;

      if (standardId != null) {
        uniqueStandards[standardId] = item;
      }
    }

    final List<TutorshipClass> standardList = uniqueStandards.values.toList();

    if (standardList.isNotEmpty) {
      final TutorshipClass firstStandard = standardList.first;

      selectedStandardId = firstStandard.standardId;
      selectedStandardName = firstStandard.standard;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fetchExams();
    });
  }

  String? _formatApiDate(DateTime? date) {
    if (date == null) return null;

    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _fetchExams() async {
    final String? selectedFromDate = _formatApiDate(fromDate);
    final String? selectedToDate = _formatApiDate(toDate);

    final request = FetchMarkEntryParameter(
      accYear: AppData.accYear ?? '',
      branchId: AppData.branchId ?? 1,
      standardId: selectedStandardId,
      divisionId: null,
      subjectId: null,
      examTermId: null,
      examTypeId: null,
      employeeId: AppData.employeeId,
      fromDate: selectedFromDate,
      toDate: selectedToDate,
    );

    debugPrint('==========================================');
    debugPrint('📘 FETCH MARK ENTRY');
    debugPrint('AccYear: ${AppData.accYear}');
    debugPrint('BranchId: ${AppData.branchId ?? 1}');
    debugPrint('StandardId: $selectedStandardId');
    debugPrint('FromDate: $selectedFromDate');
    debugPrint('ToDate: $selectedToDate');
    debugPrint('Request: ${request.toJson()}');
    debugPrint('==========================================');

    await context.read<ExamCubit>().fetchMarkEntry(request);
  }

  List<MarkEntryEntity> get filteredExams {
    final String query = searchController.text.trim().toLowerCase();

    return exams.where((exam) {
      final bool matchesSearch =
          query.isEmpty ||
          (exam.examName ?? '').toLowerCase().contains(query) ||
          (exam.standard ?? '').toLowerCase().contains(query) ||
          (exam.division ?? '').toLowerCase().contains(query) ||
          (exam.subjectName ?? '').toLowerCase().contains(query) ||
          (exam.gradePlanName ?? '').toLowerCase().contains(query);

      final DateTime? examDate = _parseDate(exam.examDate);

      final bool matchesFromDate =
          fromDate == null ||
          examDate == null ||
          !examDate.isBefore(_dateOnly(fromDate!));

      final bool matchesToDate =
          toDate == null ||
          examDate == null ||
          !examDate.isAfter(_dateOnly(toDate!));

      final bool matchesStandard =
          selectedStandardId == null || exam.standardId == selectedStandardId;

      return matchesSearch &&
          matchesFromDate &&
          matchesToDate &&
          matchesStandard;
    }).toList();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value.replaceFirst(' ', 'T'));
    } catch (_) {
      return null;
    }
  }

  String _formatDisplayDate(String? value) {
    final DateTime? date = _parseDate(value);

    if (date == null) {
      return value?.isNotEmpty == true ? value! : '--';
    }

    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
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

    if (selectedDate == null || !mounted) return;

    final DateTime selectedDateOnly = _dateOnly(selectedDate);

    if (isFromDate) {
      setState(() {
        fromDate = selectedDateOnly;

        if (toDate != null && selectedDateOnly.isAfter(toDate!)) {
          toDate = null;
        }
      });
    } else {
      if (fromDate != null && selectedDateOnly.isBefore(fromDate!)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('To date cannot be before from date')),
          );

        return;
      }

      setState(() {
        toDate = selectedDateOnly;
      });
    }

    await _fetchExams();
  }

  Future<void> _clearFromDate() async {
    setState(() {
      fromDate = null;
    });

    await _fetchExams();
  }

  Future<void> _clearToDate() async {
    setState(() {
      toDate = null;
    });

    await _fetchExams();
  }

  Future<void> _editExam(MarkEntryEntity exam) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SelectExamScreen(exam: exam)));

    if (!mounted) return;

    if (result == true) {
      await _fetchExams();
    }
  }

  void _deleteExam(MarkEntryEntity exam) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete exam'),
          content: Text(
            'Are you sure you want to delete '
            '${exam.examName ?? 'this exam'}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<ExamCubit>().deleteExamMark(exam.markEntryId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addExam() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SelectExamScreen()));

    if (!mounted) return;

    if (result == true) {
      await _fetchExams();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: BlocConsumer<ExamCubit, ExamState>(
              listener: (context, state) async {
                if (state is ExamSuccess) {
                  setState(() {
                    exams = state.response.data ?? [];
                  });
                }

                if (state is ExamFailure && exams.isNotEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is DeleteExamMarkSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Exam deleted successfully'),
                      ),
                    );

                  await _fetchExams();
                }

                if (state is DeleteExamMarkFailure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is SaveExamMarksSuccess ||
                    state is UpdateMarkEntrySuccess) {
                  await _fetchExams();
                }
              },
              builder: (context, state) {
                if (state is ExamLoading && exams.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (state is ExamFailure && exams.isEmpty) {
                  return _buildFailureView(state.message);
                }

                return _buildExamList(isRefreshing: state is ExamLoading);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExam,
        backgroundColor: const Color(0xFF075BBF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 34),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 18),
      child: Column(
        children: [
          _buildStandardDropdown(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  title: 'From date',
                  date: fromDate,
                  onTap: () {
                    _selectDate(isFromDate: true);
                  },
                  onClear: _clearFromDate,
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
                  onClear: _clearToDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSearchField(),
        ],
      ),
    );
  }

  // Widget _buildStandardDropdown() {
  //   final Map<int, TutorshipClass> uniqueStandards = {};

  //   for (final TutorshipClass item in AppData.standards) {
  //     final int? standardId = item.standardId;

  //     if (standardId != null) {
  //       uniqueStandards[standardId] = item;
  //     }
  //   }

  //   final List<TutorshipClass> standardList = uniqueStandards.values.toList();

  //   final bool valueExists = standardList.any(
  //     (item) => item.standardId == selectedStandardId,
  //   );

  //   return DropdownButtonFormField<int>(
  //     value: valueExists ? selectedStandardId : null,
  //     isExpanded: true,
  //     icon: const Icon(Icons.keyboard_arrow_down, color: primaryColor),
  //     hint: const Text(
  //       'Standard',
  //       style: TextStyle(fontSize: 12, color: Color(0xFF4B4B4B)),
  //     ),
  //     decoration: _standardDecoration(),
  //     items: [
  //       const DropdownMenuItem<int>(value: -1, child: Text('All standards')),
  //       ...standardList.map((item) {
  //         return DropdownMenuItem<int>(
  //           value: item.standardId,
  //           child: Text(
  //             item.standard ?? 'Standard',
  //             style: const TextStyle(fontSize: 12, color: Colors.black87),
  //           ),
  //         );
  //       }),
  //     ],
  //     onChanged: (value) async {
  //       TutorshipClass? selectedItem;

  //       for (final item in standardList) {
  //         if (item.standardId == value) {
  //           selectedItem = item;
  //           break;
  //         }
  //       }

  //       setState(() {
  //         if (value == -1) {
  //           selectedStandardId = null;
  //           selectedStandardName = null;
  //         } else {
  //           selectedStandardId = value;
  //           selectedStandardName = selectedItem?.standard;
  //         }
  //       });

  //       await _fetchExams();
  //     },
  //   );
  // }
  Widget _buildStandardDropdown() {
    final Map<int, TutorshipClass> uniqueStandards = {};

    for (final TutorshipClass item in AppData.standards) {
      final int? standardId = item.standardId;

      if (standardId != null) {
        uniqueStandards[standardId] = item;
      }
    }

    final List<TutorshipClass> standardList = uniqueStandards.values.toList();

    final List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem<int>(
        value: -1,
        child: Text(
          'All standards',
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ),
      ...standardList.map((item) {
        return DropdownMenuItem<int>(
          value: item.standardId,
          child: Text(
            item.standard ?? 'Standard',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        );
      }),
    ];

    final int pickerValue = selectedStandardId ?? -1;

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      pickerValue,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: items.isEmpty
          ? null
          : () async {
              final PickerSelection<int>? result =
                  await showOptionPickerSheet<int>(
                    context: context,
                    title: 'Select Standard',
                    items: items,
                    selectedValue: pickerValue,
                  );

              if (!mounted || result == null || result.value == null) {
                return;
              }

              final int selectedValue = result.value!;

              TutorshipClass? selectedStandard;

              for (final TutorshipClass item in standardList) {
                if (item.standardId == selectedValue) {
                  selectedStandard = item;
                  break;
                }
              }

              setState(() {
                if (selectedValue == -1) {
                  selectedStandardId = null;
                  selectedStandardName = null;
                } else {
                  selectedStandardId = selectedValue;
                  selectedStandardName = selectedStandard?.standard;
                }
              });

              await _fetchExams();
            },
      child: InputDecorator(
        decoration: _standardDecoration(),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  const Text(
                    'Standard',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4B4B4B)),
                  ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: primaryColor),
          ],
        ),
      ),
    );
  }

  InputDecoration _standardDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 6),
        child: SvgPicture.asset(
          'assets/icons/Group (14).svg',
          width: 14,
          height: 14,
          fit: BoxFit.contain,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: primaryColor),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
        prefixIcon: const Icon(
          Icons.search,
          size: 19,
          color: Color(0xFF777777),
        ),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close, size: 18),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildExamList({required bool isRefreshing}) {
    final List<MarkEntryEntity> examList = filteredExams;

    if (examList.isEmpty) {
      return RefreshIndicator(
        color: primaryColor,
        onRefresh: _fetchExams,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Center(
              child: Text(
                'No exams found',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: primaryColor,
          onRefresh: _fetchExams,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(30, 18, 30, 90),
            itemCount: examList.length,
            separatorBuilder: (_, __) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              return _buildExamCard(examList[index]);
            },
          ),
        ),
        if (isRefreshing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2, color: primaryColor),
          ),
      ],
    );
  }

  Widget _buildFailureView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchExams,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
    required VoidCallback onClear,
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
                date == null
                    ? title
                    : '${date.day.toString().padLeft(2, '0')}-'
                          '${date.month.toString().padLeft(2, '0')}-'
                          '${date.year}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: date == null
                      ? const Color(0xFF666666)
                      : Colors.black87,
                ),
              ),
            ),
            if (date != null)
              IconButton(
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                padding: EdgeInsets.zero,
                splashRadius: 16,
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 15, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildExamCard(MarkEntryEntity exam) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFDEDEDE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  exam.examName ?? 'Exam',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _editExam(exam),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Color(0xFF32B900), fontSize: 9),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _deleteExam(exam),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5, top: 2, bottom: 2),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red, fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            _formatDisplayDate(exam.examDate),
            style: const TextStyle(color: Color(0xFF6D6D6D), fontSize: 10),
          ),
          const SizedBox(height: 20),
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildExamInfo(
                    assetPath: 'assets/icons/Group 951.svg',
                    title: 'Class',
                    value: exam.standard ?? '--',
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: _buildExamInfo(
                    assetPath: 'assets/icons/Group (17).svg',
                    title: 'Division',
                    value: exam.division ?? '--',
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: _buildExamInfo(
                    assetPath: 'assets/icons/Group (18).svg',
                    title: 'Subject',
                    value: exam.subjectName ?? '--',
                    valueFontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamInfo({
    required String assetPath,
    required String title,
    required String value,
    double valueFontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
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
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF555555), fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF4D21DB),
              fontSize: valueFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 38, color: const Color(0xFFE8E0F8));
  }
}
