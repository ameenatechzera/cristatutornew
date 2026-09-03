// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/exams/domain/entities/fetch_gradeplan_entity.dart';
// import 'package:cristalteacher/features/exams/domain/entities/fetchexam_entity.dart';
// import 'package:cristalteacher/features/exams/domain/entities/get_all_exam_entity.dart';
// import 'package:cristalteacher/features/exams/presentation/cubit/exam_cubit.dart';
// import 'package:cristalteacher/features/exams/presentation/screens/exam_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class SelectExamScreen extends StatefulWidget {
//   const SelectExamScreen({super.key, this.onNext, this.exam});

//   final VoidCallback? onNext;
//   final MarkEntryEntity? exam;

//   @override
//   State<SelectExamScreen> createState() => _SelectExamScreenState();
// }

// class _SelectExamScreenState extends State<SelectExamScreen> {
//   static const Color primaryColor = Color(0xFF0758C9);
//   static const Color fieldColor = Color(0xFFF0F4FF);
//   static const Color purpleColor = Color(0xFF7265FF);
//   static const Color textColor = Color(0xFF414141);

//   final TextEditingController maxTeController = TextEditingController();
//   final TextEditingController maxCeController = TextEditingController();

//   List<GradePlanEntity> gradePlans = [];
//   List<GetAllExamData> exams = [];
//   List<TutorshipClass> tutorshipClasses = [];

//   int? markEntryId;

//   int? selectedExamId;
//   String? selectedExam;

//   int? selectedExamTermId;
//   int? selectedExamTypeId;

//   int? selectedGradePlanId;
//   String? selectedGrade;

//   DateTime? selectedDate;

//   int? selectedStandardId;
//   String? selectedStandard;

//   int? selectedDivisionId;
//   String? selectedDivision;

//   int? selectedSubjectId;
//   String? selectedSubject;

//   bool editDataInitialized = false;

//   bool get isEditMode => widget.exam != null;

//   GradePlanEntity? get selectedGradePlan {
//     for (final plan in gradePlans) {
//       if (plan.gradePlanId == selectedGradePlanId) {
//         return plan;
//       }
//     }

//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (isEditMode) {
//       populateEditData();
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       context.read<ExamCubit>().fetchGradePlan();
//       context.read<ExamCubit>().getAllExams();
//       fetchTutorshipClasses();
//     });
//   }

//   @override
//   void dispose() {
//     maxTeController.dispose();
//     maxCeController.dispose();
//     super.dispose();
//   }

//   void populateEditData() {
//     final exam = widget.exam;

//     if (exam == null || editDataInitialized) return;

//     editDataInitialized = true;

//     markEntryId = exam.markEntryId;

//     selectedExamId = exam.examId;
//     selectedExam = exam.examName;

//     selectedGradePlanId = exam.gradePlanId;
//     selectedGrade = exam.gradePlanName;

//     selectedStandardId = exam.standardId;
//     selectedStandard = exam.standard;

//     selectedDivisionId = exam.divisionId;
//     selectedDivision = exam.division;

//     selectedSubjectId = exam.subjectId;
//     selectedSubject = exam.subjectName;

//     maxTeController.text = exam.maxTE?.toString() ?? '';
//     maxCeController.text = exam.maxCE?.toString() ?? '';

//     selectedDate = parseExamDate(exam.examDate);
//   }

//   void fetchTutorshipClasses() {
//     final request = FetchTutorshipClassRequest(
//       accyear: AppData.accYear,
//       employeeId: AppData.employeeId,
//       userId: AppData.userId,
//     );

//     context.read<AuthenticationCubit>().fetchTutorshipClass(request);
//   }

//   DateTime? parseExamDate(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return null;
//     }

//     final formattedValue = value.trim().replaceFirst(' ', 'T');
//     final parsedDate = DateTime.tryParse(formattedValue);

//     if (parsedDate != null) {
//       return parsedDate;
//     }

//     final parts = value.trim().split('-');

//     if (parts.length == 3) {
//       final day = int.tryParse(parts[0]);
//       final month = int.tryParse(parts[1]);
//       final year = int.tryParse(parts[2]);

//       if (day != null && month != null && year != null) {
//         return DateTime(year, month, day);
//       }
//     }

//     return null;
//   }

//   String formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}-'
//         '${date.month.toString().padLeft(2, '0')}-'
//         '${date.year}';
//   }

//   List<DivisionDetails> get availableDivisions {
//     final divisions = <int, DivisionDetails>{};

//     for (final standard in tutorshipClasses) {
//       if (standard.standardId != selectedStandardId) {
//         continue;
//       }

//       for (final division in standard.division ?? <DivisionDetails>[]) {
//         if (division.divisionId != null) {
//           divisions[division.divisionId!] = division;
//         }
//       }
//     }

//     return divisions.values.toList();
//   }

//   List<SubjectDetails> get availableSubjects {
//     final subjects = <int, SubjectDetails>{};

//     for (final standard in tutorshipClasses) {
//       if (standard.standardId != selectedStandardId) {
//         continue;
//       }

//       for (final division in standard.division ?? <DivisionDetails>[]) {
//         if (division.divisionId != selectedDivisionId) {
//           continue;
//         }

//         for (final subject in division.subject ?? <SubjectDetails>[]) {
//           if (subject.subjectId != null) {
//             subjects[subject.subjectId!] = subject;
//           }
//         }
//       }
//     }

//     return subjects.values.toList();
//   }

//   void resolveTutorshipEditValues() {
//     if (!isEditMode) return;

//     for (final standard in tutorshipClasses) {
//       if (standard.standardId != widget.exam?.standardId) {
//         continue;
//       }

//       selectedStandardId = standard.standardId;
//       selectedStandard = standard.standard;

//       for (final division in standard.division ?? <DivisionDetails>[]) {
//         if (division.divisionId != widget.exam?.divisionId) {
//           continue;
//         }

//         selectedDivisionId = division.divisionId;
//         selectedDivision = division.division;

//         for (final subject in division.subject ?? <SubjectDetails>[]) {
//           if (subject.subjectId == widget.exam?.subjectId) {
//             selectedSubjectId = subject.subjectId;
//             selectedSubject = subject.subject;
//             break;
//           }
//         }

//         break;
//       }

//       break;
//     }
//   }

//   void resolveExamEditValue() {
//     if (!isEditMode || widget.exam == null) return;

//     final selectedMarkEntry = widget.exam!;

//     debugPrint('===== RESOLVING EDIT EXAM =====');
//     debugPrint('Mark Entry ID: ${selectedMarkEntry.markEntryId}');
//     debugPrint('Widget Exam ID: ${selectedMarkEntry.examId}');
//     debugPrint('Widget Exam Name: ${selectedMarkEntry.examName}');

//     // Keep the exam information from the selected mark entry.
//     selectedExamId = selectedMarkEntry.examId;
//     selectedExam = selectedMarkEntry.examName;

//     // Get only the additional IDs from the exam list.
//     for (final exam in exams) {
//       if (exam.examId == selectedMarkEntry.examId) {
//         selectedExamTermId = exam.examTermId;
//         selectedExamTypeId = exam.examTypeId;

//         debugPrint('Matched Exam API ID: ${exam.examId}');
//         debugPrint('Matched Exam API Name: ${exam.examName}');
//         debugPrint('Exam Term ID: ${exam.examTermId}');
//         debugPrint('Exam Type ID: ${exam.examTypeId}');

//         break;
//       }
//     }

//     debugPrint('FINAL Exam ID: $selectedExamId');
//     debugPrint('FINAL Exam Name: $selectedExam');
//     debugPrint('================================');
//   }

//   void resolveGradePlanEditValue() {
//     if (!isEditMode) return;

//     for (final grade in gradePlans) {
//       if (grade.gradePlanId == widget.exam?.gradePlanId) {
//         selectedGradePlanId = grade.gradePlanId;
//         selectedGrade = grade.gradePlanName;
//         break;
//       }
//     }
//   }

//   Future<void> pickDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2040),
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

//     if (date == null || !mounted) return;

//     setState(() {
//       selectedDate = date;
//     });
//   }

//   Future<void> goToExamDetails() async {
//     final maxTe = int.tryParse(maxTeController.text.trim()) ?? 0;
//     final maxCe = int.tryParse(maxCeController.text.trim()) ?? 0;

//     if (selectedExamId == null ||
//         selectedExam == null ||
//         selectedExamTermId == null ||
//         selectedExamTypeId == null ||
//         selectedGradePlanId == null ||
//         selectedGrade == null ||
//         selectedDate == null ||
//         selectedStandardId == null ||
//         selectedStandard == null ||
//         selectedDivisionId == null ||
//         selectedDivision == null ||
//         selectedSubjectId == null ||
//         selectedSubject == null) {
//       showError('Please fill all the fields');
//       return;
//     }

//     if (maxTe < 0 || maxCe < 0) {
//       showError('Maximum marks cannot be negative');
//       return;
//     }

//     if (maxTe + maxCe <= 0) {
//       showError('Total maximum marks must be greater than zero');
//       return;
//     }

//     if (isEditMode && markEntryId == null) {
//       showError('Mark entry ID is unavailable');
//       return;
//     }

//     if (AppData.accYear == null) {
//       showError('Academic year is unavailable');
//       return;
//     }

//     final request = AttendanceDetailsRequest(
//       accyear: AppData.accYear!,
//       standard: selectedStandardId!,
//       division: selectedDivisionId!,
//       sortBy: 'alphabetic',
//     );

//     final result = await Navigator.of(context).push<bool>(
//       MaterialPageRoute(
//         builder: (_) => ExamDetailsScreen(
//           request: request,
//           examId: selectedExamId!,
//           examName: selectedExam!,
//           examTermId: selectedExamTermId!,
//           examTypeId: selectedExamTypeId!,
//           gradePlanId: selectedGradePlanId!,
//           gradePlanName: selectedGrade!,
//           gradeSettings: selectedGradePlan?.settings ?? const [],
//           examDate: selectedDate!,
//           standardId: selectedStandardId!,
//           standardName: selectedStandard!,
//           divisionId: selectedDivisionId!,
//           divisionName: selectedDivision!,
//           subjectId: selectedSubjectId!,
//           subjectName: selectedSubject!,
//           maxTe: maxTe,
//           maxCe: maxCe,
//           isEditMode: isEditMode,
//           markEntryId: markEntryId,
//         ),
//       ),
//     );

//     if (result == true && mounted) {
//       Navigator.pop(context, true);
//     }
//   }
//   // Future<void> goToExamDetails() async {
//   //   final maxTe = int.tryParse(maxTeController.text.trim());
//   //   final maxCe = int.tryParse(maxCeController.text.trim());

//   //   if (selectedExamId == null ||
//   //       selectedExam == null ||
//   //       selectedExamTermId == null ||
//   //       selectedExamTypeId == null ||
//   //       selectedGradePlanId == null ||
//   //       selectedGrade == null ||
//   //       selectedDate == null ||
//   //       selectedStandardId == null ||
//   //       selectedStandard == null ||
//   //       selectedDivisionId == null ||
//   //       selectedDivision == null ||
//   //       selectedSubjectId == null ||
//   //       selectedSubject == null ||
//   //       maxTe == null ||
//   //       maxCe == null) {
//   //     showError('Please fill all the fields');
//   //     return;
//   //   }

//   //   if (maxTe <= 0 || maxCe <= 0) {
//   //     showError('Maximum marks must be greater than zero');
//   //     return;
//   //   }

//   //   if (isEditMode && markEntryId == null) {
//   //     showError('Mark entry ID is unavailable');
//   //     return;
//   //   }

//   //   if (AppData.accYear == null) {
//   //     showError('Academic year is unavailable');
//   //     return;
//   //   }

//   //   final request = AttendanceDetailsRequest(
//   //     accyear: AppData.accYear!,
//   //     standard: selectedStandardId!,
//   //     division: selectedDivisionId!,
//   //     sortBy: 'alphabetic',
//   //   );

//   //   debugPrint('==========================================');
//   //   debugPrint(isEditMode ? 'EDIT EXAM DETAILS' : 'ADD EXAM DETAILS');
//   //   debugPrint('Mark Entry ID: $markEntryId');
//   //   debugPrint('Exam ID: $selectedExamId');
//   //   debugPrint('Exam Name: $selectedExam');
//   //   debugPrint('Exam Term ID: $selectedExamTermId');
//   //   debugPrint('Exam Type ID: $selectedExamTypeId');
//   //   debugPrint('Grade Plan ID: $selectedGradePlanId');
//   //   debugPrint('Grade Plan: $selectedGrade');
//   //   debugPrint('Date: ${formatDate(selectedDate!)}');
//   //   debugPrint('Standard ID: $selectedStandardId');
//   //   debugPrint('Standard: $selectedStandard');
//   //   debugPrint('Division ID: $selectedDivisionId');
//   //   debugPrint('Division: $selectedDivision');
//   //   debugPrint('Subject ID: $selectedSubjectId');
//   //   debugPrint('Subject: $selectedSubject');
//   //   debugPrint('Max TE: $maxTe');
//   //   debugPrint('Max CE: $maxCe');
//   //   debugPrint('Attendance request: ${request.toJson()}');
//   //   debugPrint('==========================================');

//   //   final result = await Navigator.of(context).push<bool>(
//   //     MaterialPageRoute(
//   //       builder: (_) => ExamDetailsScreen(
//   //         request: request,
//   //         examId: selectedExamId!,
//   //         examName: selectedExam!,
//   //         examTermId: selectedExamTermId!,
//   //         examTypeId: selectedExamTypeId!,
//   //         gradePlanId: selectedGradePlanId!,
//   //         gradePlanName: selectedGrade!,
//   //         gradeSettings: selectedGradePlan?.settings ?? const [],
//   //         examDate: selectedDate!,
//   //         standardId: selectedStandardId!,
//   //         standardName: selectedStandard!,
//   //         divisionId: selectedDivisionId!,
//   //         divisionName: selectedDivision!,
//   //         subjectId: selectedSubjectId!,
//   //         subjectName: selectedSubject!,
//   //         maxTe: maxTe,
//   //         maxCe: maxCe,
//   //         isEditMode: isEditMode,
//   //         markEntryId: markEntryId,
//   //       ),
//   //     ),
//   //   );

//   //   if (result == true && mounted) {
//   //     Navigator.pop(context, true);
//   //   }
//   // }

//   void showError(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.red),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthenticationCubit, AuthenticationState>(
//       listener: (context, state) {
//         if (state is FetchTutorshipClassSuccess) {
//           setState(() {
//             tutorshipClasses = state.response.data?.tutorshipClass ?? [];

//             if (isEditMode) {
//               resolveTutorshipEditValues();
//             } else {
//               selectedStandardId = null;
//               selectedStandard = null;
//               selectedDivisionId = null;
//               selectedDivision = null;
//               selectedSubjectId = null;
//               selectedSubject = null;
//             }
//           });
//         }

//         if (state is FetchTutorshipClassFailure) {
//           showError(state.message);
//         }
//       },
//       child: BlocConsumer<ExamCubit, ExamState>(
//         listenWhen: (previous, current) {
//           return current is FetchGradePlanSuccess ||
//               current is FetchGradePlanFailure ||
//               current is GetAllExamSuccess ||
//               current is GetAllExamFailure;
//         },
//         listener: (context, state) {
//           if (state is FetchGradePlanSuccess) {
//             setState(() {
//               gradePlans = state.response.data ?? [];

//               if (isEditMode) {
//                 resolveGradePlanEditValue();
//               } else if (gradePlans.isNotEmpty) {
//                 selectedGradePlanId = gradePlans.first.gradePlanId;
//                 selectedGrade = gradePlans.first.gradePlanName;
//               }
//             });
//           }

//           if (state is FetchGradePlanFailure) {
//             showError(state.message);
//           }

//           if (state is GetAllExamSuccess) {
//             setState(() {
//               exams = state.response.data ?? [];

//               if (isEditMode) {
//                 resolveExamEditValue();
//               } else {
//                 selectedExamId = null;
//                 selectedExam = null;
//                 selectedExamTermId = null;
//                 selectedExamTypeId = null;
//               }
//             });
//           }

//           if (state is GetAllExamFailure) {
//             showError(state.message);
//           }
//         },
//         builder: (context, state) {
//           final isGradeLoading = state is FetchGradePlanLoading;

//           final isExamLoading = state is GetAllExamLoading;

//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               backgroundColor: Colors.white,
//               surfaceTintColor: Colors.white,
//               elevation: 0,
//               centerTitle: true,
//               leadingWidth: 65,
//               leading: IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                   size: 22,
//                 ),
//               ),
//               title: Text(
//                 isEditMode ? 'Edit Exam' : 'Select Exam',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             body: SafeArea(
//               top: false,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Exam information',
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     buildExamDropdown(isLoading: isExamLoading),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: buildGradeDropdown(isLoading: isGradeLoading),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(child: buildDateField()),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Class And Subject',
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     BlocBuilder<AuthenticationCubit, AuthenticationState>(
//                       builder: (context, authState) {
//                         final isTutorshipLoading =
//                             authState is FetchTutorshipClassLoading;

//                         return Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: buildStandardDropdown(
//                                     isLoading: isTutorshipLoading,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: buildDivisionDropdown(
//                                     isLoading: isTutorshipLoading,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             buildSubjectDropdown(isLoading: isTutorshipLoading),
//                           ],
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: buildTextField(
//                             controller: maxTeController,
//                             hint: 'MAX TE',
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: buildTextField(
//                             controller: maxCeController,
//                             hint: 'MAX CE',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 66),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: goToExamDetails,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         child: Text(
//                           'Next',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildExamDropdown({required bool isLoading}) {
//     final validValue = exams.any((exam) => exam.examId == selectedExamId);

//     return DropdownButtonFormField<int>(
//       value: validValue ? selectedExamId : null,
//       isExpanded: true,
//       icon: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: purpleColor,
//               ),
//             )
//           : const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: purpleColor,
//               size: 21,
//             ),
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       menuMaxHeight: 300,
//       hint: Text(
//         isLoading ? 'Loading...' : 'Select Exam',
//         style: const TextStyle(color: textColor, fontSize: 11),
//       ),
//       decoration: dropdownDecoration(),
//       items: exams.where((exam) => exam.examId != null).map((exam) {
//         return DropdownMenuItem<int>(
//           value: exam.examId,
//           child: Text(
//             exam.examName ?? '',
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: textColor, fontSize: 11),
//           ),
//         );
//       }).toList(),
//       onChanged: isLoading
//           ? null
//           : (value) {
//               if (value == null) return;

//               GetAllExamData? selectedItem;

//               for (final exam in exams) {
//                 if (exam.examId == value) {
//                   selectedItem = exam;
//                   break;
//                 }
//               }

//               if (selectedItem == null) return;

//               setState(() {
//                 selectedExamId = selectedItem!.examId;
//                 selectedExam = selectedItem.examName;
//                 selectedExamTermId = selectedItem.examTermId;
//                 selectedExamTypeId = selectedItem.examTypeId;
//               });
//             },
//     );
//   }

//   Widget buildGradeDropdown({required bool isLoading}) {
//     final validValue = gradePlans.any(
//       (grade) => grade.gradePlanId == selectedGradePlanId,
//     );

//     return DropdownButtonFormField<int>(
//       value: validValue ? selectedGradePlanId : null,
//       isExpanded: true,
//       icon: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: purpleColor,
//               ),
//             )
//           : const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: purpleColor,
//               size: 21,
//             ),
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       menuMaxHeight: 300,
//       hint: Text(
//         isLoading ? 'Loading...' : 'Grade',
//         style: const TextStyle(color: textColor, fontSize: 11),
//       ),
//       decoration: dropdownDecoration(),
//       items: gradePlans.where((grade) => grade.gradePlanId != null).map((
//         grade,
//       ) {
//         return DropdownMenuItem<int>(
//           value: grade.gradePlanId,
//           child: Text(
//             grade.gradePlanName ?? '',
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: textColor, fontSize: 11),
//           ),
//         );
//       }).toList(),
//       onChanged: isLoading
//           ? null
//           : (value) {
//               if (value == null) return;

//               GradePlanEntity? selectedItem;

//               for (final grade in gradePlans) {
//                 if (grade.gradePlanId == value) {
//                   selectedItem = grade;
//                   break;
//                 }
//               }

//               if (selectedItem == null) return;

//               setState(() {
//                 selectedGradePlanId = selectedItem!.gradePlanId;
//                 selectedGrade = selectedItem.gradePlanName;
//               });
//             },
//     );
//   }

//   Widget buildStandardDropdown({required bool isLoading}) {
//     final uniqueStandards = <int, TutorshipClass>{};

//     for (final standard in tutorshipClasses) {
//       if (standard.standardId != null) {
//         uniqueStandards[standard.standardId!] = standard;
//       }
//     }

//     final standards = uniqueStandards.values.toList();

//     final validValue = standards.any(
//       (standard) => standard.standardId == selectedStandardId,
//     );

//     return DropdownButtonFormField<int>(
//       value: validValue ? selectedStandardId : null,
//       isExpanded: true,
//       icon: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: purpleColor,
//               ),
//             )
//           : const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: purpleColor,
//               size: 21,
//             ),
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       menuMaxHeight: 300,
//       hint: Text(
//         isLoading ? 'Loading...' : 'Standard',
//         style: const TextStyle(color: textColor, fontSize: 11),
//       ),
//       decoration: dropdownDecoration(),
//       items: standards.map((standard) {
//         return DropdownMenuItem<int>(
//           value: standard.standardId,
//           child: Text(
//             standard.standard ?? '',
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: textColor, fontSize: 11),
//           ),
//         );
//       }).toList(),
//       onChanged: isLoading
//           ? null
//           : (value) {
//               if (value == null) return;

//               TutorshipClass? selectedItem;

//               for (final standard in standards) {
//                 if (standard.standardId == value) {
//                   selectedItem = standard;
//                   break;
//                 }
//               }

//               if (selectedItem == null) return;

//               setState(() {
//                 selectedStandardId = selectedItem!.standardId;
//                 selectedStandard = selectedItem.standard;

//                 selectedDivisionId = null;
//                 selectedDivision = null;

//                 selectedSubjectId = null;
//                 selectedSubject = null;
//               });
//             },
//     );
//   }

//   Widget buildDivisionDropdown({required bool isLoading}) {
//     final divisions = availableDivisions;

//     final validValue = divisions.any(
//       (division) => division.divisionId == selectedDivisionId,
//     );

//     return DropdownButtonFormField<int>(
//       value: validValue ? selectedDivisionId : null,
//       isExpanded: true,
//       icon: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: purpleColor,
//               ),
//             )
//           : const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: purpleColor,
//               size: 21,
//             ),
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       menuMaxHeight: 300,
//       hint: Text(
//         isLoading ? 'Loading...' : 'Division',
//         style: const TextStyle(color: textColor, fontSize: 11),
//       ),
//       decoration: dropdownDecoration(),
//       items: divisions.where((division) => division.divisionId != null).map((
//         division,
//       ) {
//         return DropdownMenuItem<int>(
//           value: division.divisionId,
//           child: Text(
//             division.division ?? '',
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: textColor, fontSize: 11),
//           ),
//         );
//       }).toList(),
//       onChanged: isLoading
//           ? null
//           : (value) {
//               if (value == null) return;

//               DivisionDetails? selectedItem;

//               for (final division in divisions) {
//                 if (division.divisionId == value) {
//                   selectedItem = division;
//                   break;
//                 }
//               }

//               if (selectedItem == null) return;

//               setState(() {
//                 selectedDivisionId = selectedItem!.divisionId;
//                 selectedDivision = selectedItem.division;

//                 selectedSubjectId = null;
//                 selectedSubject = null;
//               });
//             },
//     );
//   }

//   Widget buildSubjectDropdown({required bool isLoading}) {
//     final subjects = availableSubjects;

//     final validValue = subjects.any(
//       (subject) => subject.subjectId == selectedSubjectId,
//     );

//     return DropdownButtonFormField<int>(
//       value: validValue ? selectedSubjectId : null,
//       isExpanded: true,
//       icon: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: purpleColor,
//               ),
//             )
//           : const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: purpleColor,
//               size: 21,
//             ),
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       menuMaxHeight: 300,
//       hint: Text(
//         isLoading ? 'Loading...' : 'Select Subject',
//         style: const TextStyle(color: textColor, fontSize: 11),
//       ),
//       decoration: dropdownDecoration(),
//       items: subjects.where((subject) => subject.subjectId != null).map((
//         subject,
//       ) {
//         return DropdownMenuItem<int>(
//           value: subject.subjectId,
//           child: Text(
//             subject.subject ?? '',
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: textColor, fontSize: 11),
//           ),
//         );
//       }).toList(),
//       onChanged: isLoading
//           ? null
//           : (value) {
//               if (value == null) return;

//               SubjectDetails? selectedItem;

//               for (final subject in subjects) {
//                 if (subject.subjectId == value) {
//                   selectedItem = subject;
//                   break;
//                 }
//               }

//               if (selectedItem == null) return;

//               setState(() {
//                 selectedSubjectId = selectedItem!.subjectId;
//                 selectedSubject = selectedItem.subject;
//               });
//             },
//     );
//   }

//   Widget buildTextField({
//     required TextEditingController controller,
//     required String hint,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       style: const TextStyle(
//         color: textColor,
//         fontSize: 11,
//         fontWeight: FontWeight.w400,
//       ),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(
//           color: textColor,
//           fontSize: 11,
//           fontWeight: FontWeight.w400,
//         ),
//         filled: true,
//         fillColor: fieldColor,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 11,
//           vertical: 13,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(11),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(11),
//           borderSide: const BorderSide(color: purpleColor, width: 1),
//         ),
//       ),
//     );
//   }

//   Widget buildDateField() {
//     return InkWell(
//       onTap: pickDate,
//       borderRadius: BorderRadius.circular(11),
//       child: Container(
//         height: 41,
//         padding: const EdgeInsets.symmetric(horizontal: 11),
//         decoration: BoxDecoration(
//           color: fieldColor,
//           borderRadius: BorderRadius.circular(11),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 selectedDate == null ? 'Date' : formatDate(selectedDate!),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   color: textColor,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 5),
//             buildPurpleIcon(
//               'assets/icons/Group (15).svg',
//               iconColor: Colors.grey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration dropdownDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: fieldColor,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(11),
//         borderSide: BorderSide.none,
//       ),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(11),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(11),
//         borderSide: const BorderSide(color: purpleColor),
//       ),
//     );
//   }

//   Widget buildPurpleIcon(
//     String assetPath, {
//     double size = 28,
//     double iconSize = 15,
//     Color iconColor = primaryColor,
//     Color backgroundColor = Colors.transparent,
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
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/exams/domain/entities/fetch_gradeplan_entity.dart';
import 'package:cristalteacher/features/exams/domain/entities/fetchexam_entity.dart';
import 'package:cristalteacher/features/exams/domain/entities/get_all_exam_entity.dart';
import 'package:cristalteacher/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:cristalteacher/features/exams/presentation/screens/exam_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectExamScreen extends StatefulWidget {
  const SelectExamScreen({super.key, this.onNext, this.exam});

  final VoidCallback? onNext;
  final MarkEntryEntity? exam;

  @override
  State<SelectExamScreen> createState() => _SelectExamScreenState();
}

class _SelectExamScreenState extends State<SelectExamScreen> {
  static const Color primaryColor = Color(0xFF0758C9);
  static const Color fieldColor = Color(0xFFF0F4FF);
  static const Color purpleColor = Color(0xFF7265FF);
  static const Color textColor = Color(0xFF414141);

  final TextEditingController maxTeController = TextEditingController();
  final TextEditingController maxCeController = TextEditingController();

  List<GradePlanEntity> gradePlans = [];
  List<GetAllExamData> exams = [];

  // Standard / division / subject come from AppData, cached when the
  // tutorship classes are fetched at login. No API call from this screen.
  List<TutorshipClass> tutorshipClasses = [];

  int? markEntryId;

  int? selectedExamId;
  String? selectedExam;

  int? selectedExamTermId;
  int? selectedExamTypeId;

  int? selectedGradePlanId;
  String? selectedGrade;

  DateTime? selectedDate;

  int? selectedStandardId;
  String? selectedStandard;

  int? selectedDivisionId;
  String? selectedDivision;

  int? selectedSubjectId;
  String? selectedSubject;

  bool editDataInitialized = false;

  bool get isEditMode => widget.exam != null;

  GradePlanEntity? get selectedGradePlan {
    for (final plan in gradePlans) {
      if (plan.gradePlanId == selectedGradePlanId) {
        return plan;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    tutorshipClasses = AppData.tutorshipClasses;

    if (isEditMode) {
      populateEditData();

      // The class list is already here, so the names can be resolved
      // straight away instead of waiting on an API response.
      resolveTutorshipEditValues();
    } else {
      // Open with the first class already chosen instead of empty hints.
      setInitialClassSelection();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ExamCubit>().fetchGradePlan();
      context.read<ExamCubit>().getAllExams();
    });
  }

  @override
  void dispose() {
    maxTeController.dispose();
    maxCeController.dispose();
    super.dispose();
  }

  void populateEditData() {
    final exam = widget.exam;

    if (exam == null || editDataInitialized) return;

    editDataInitialized = true;

    markEntryId = exam.markEntryId;

    selectedExamId = exam.examId;
    selectedExam = exam.examName;

    selectedGradePlanId = exam.gradePlanId;
    selectedGrade = exam.gradePlanName;

    selectedStandardId = exam.standardId;
    selectedStandard = exam.standard;

    selectedDivisionId = exam.divisionId;
    selectedDivision = exam.division;

    selectedSubjectId = exam.subjectId;
    selectedSubject = exam.subjectName;

    maxTeController.text = exam.maxTE?.toString() ?? '';
    maxCeController.text = exam.maxCE?.toString() ?? '';

    selectedDate = parseExamDate(exam.examDate);
  }

  /// Picks the first standard that actually has a division, then its
  /// first division and first subject, so the fields are never blank
  /// on a fresh screen.
  void setInitialClassSelection() {
    if (tutorshipClasses.isEmpty || selectedStandardId != null) {
      return;
    }

    for (final standard in tutorshipClasses) {
      final divisions = standard.division ?? <DivisionDetails>[];

      if (divisions.isEmpty) {
        continue;
      }

      final division = divisions.first;
      final subjects = division.subject ?? <SubjectDetails>[];

      selectedStandardId = standard.standardId;
      selectedStandard = standard.standard;

      selectedDivisionId = division.divisionId;
      selectedDivision = division.division;

      if (subjects.isNotEmpty) {
        selectedSubjectId = subjects.first.subjectId;
        selectedSubject = subjects.first.subject;
      }

      break;
    }
  }

  DateTime? parseExamDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final formattedValue = value.trim().replaceFirst(' ', 'T');
    final parsedDate = DateTime.tryParse(formattedValue);

    if (parsedDate != null) {
      return parsedDate;
    }

    final parts = value.trim().split('-');

    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  List<DivisionDetails> get availableDivisions {
    final divisions = <int, DivisionDetails>{};

    for (final standard in tutorshipClasses) {
      if (standard.standardId != selectedStandardId) {
        continue;
      }

      for (final division in standard.division ?? <DivisionDetails>[]) {
        if (division.divisionId != null) {
          divisions[division.divisionId!] = division;
        }
      }
    }

    return divisions.values.toList();
  }

  List<SubjectDetails> get availableSubjects {
    final subjects = <int, SubjectDetails>{};

    for (final standard in tutorshipClasses) {
      if (standard.standardId != selectedStandardId) {
        continue;
      }

      for (final division in standard.division ?? <DivisionDetails>[]) {
        if (division.divisionId != selectedDivisionId) {
          continue;
        }

        for (final subject in division.subject ?? <SubjectDetails>[]) {
          if (subject.subjectId != null) {
            subjects[subject.subjectId!] = subject;
          }
        }
      }
    }

    return subjects.values.toList();
  }

  void resolveTutorshipEditValues() {
    if (!isEditMode) return;

    for (final standard in tutorshipClasses) {
      if (standard.standardId != widget.exam?.standardId) {
        continue;
      }

      selectedStandardId = standard.standardId;
      selectedStandard = standard.standard;

      for (final division in standard.division ?? <DivisionDetails>[]) {
        if (division.divisionId != widget.exam?.divisionId) {
          continue;
        }

        selectedDivisionId = division.divisionId;
        selectedDivision = division.division;

        for (final subject in division.subject ?? <SubjectDetails>[]) {
          if (subject.subjectId == widget.exam?.subjectId) {
            selectedSubjectId = subject.subjectId;
            selectedSubject = subject.subject;
            break;
          }
        }

        break;
      }

      break;
    }
  }

  void resolveExamEditValue() {
    if (!isEditMode || widget.exam == null) return;

    final selectedMarkEntry = widget.exam!;

    debugPrint('===== RESOLVING EDIT EXAM =====');
    debugPrint('Mark Entry ID: ${selectedMarkEntry.markEntryId}');
    debugPrint('Widget Exam ID: ${selectedMarkEntry.examId}');
    debugPrint('Widget Exam Name: ${selectedMarkEntry.examName}');

    // Keep the exam information from the selected mark entry.
    selectedExamId = selectedMarkEntry.examId;
    selectedExam = selectedMarkEntry.examName;

    // Get only the additional IDs from the exam list.
    for (final exam in exams) {
      if (exam.examId == selectedMarkEntry.examId) {
        selectedExamTermId = exam.examTermId;
        selectedExamTypeId = exam.examTypeId;

        debugPrint('Matched Exam API ID: ${exam.examId}');
        debugPrint('Matched Exam API Name: ${exam.examName}');
        debugPrint('Exam Term ID: ${exam.examTermId}');
        debugPrint('Exam Type ID: ${exam.examTypeId}');

        break;
      }
    }

    debugPrint('FINAL Exam ID: $selectedExamId');
    debugPrint('FINAL Exam Name: $selectedExam');
    debugPrint('================================');
  }

  void resolveGradePlanEditValue() {
    if (!isEditMode) return;

    for (final grade in gradePlans) {
      if (grade.gradePlanId == widget.exam?.gradePlanId) {
        selectedGradePlanId = grade.gradePlanId;
        selectedGrade = grade.gradePlanName;
        break;
      }
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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

    if (date == null || !mounted) return;

    setState(() {
      selectedDate = date;
    });
  }

  Future<void> goToExamDetails() async {
    final maxTe = int.tryParse(maxTeController.text.trim()) ?? 0;
    final maxCe = int.tryParse(maxCeController.text.trim()) ?? 0;

    if (selectedExamId == null ||
        selectedExam == null ||
        selectedExamTermId == null ||
        selectedExamTypeId == null ||
        selectedGradePlanId == null ||
        selectedGrade == null ||
        selectedDate == null ||
        selectedStandardId == null ||
        selectedStandard == null ||
        selectedDivisionId == null ||
        selectedDivision == null ||
        selectedSubjectId == null ||
        selectedSubject == null) {
      showError('Please fill all the fields');
      return;
    }

    if (maxTe < 0 || maxCe < 0) {
      showError('Maximum marks cannot be negative');
      return;
    }

    if (maxTe + maxCe <= 0) {
      showError('Total maximum marks must be greater than zero');
      return;
    }

    if (isEditMode && markEntryId == null) {
      showError('Mark entry ID is unavailable');
      return;
    }

    if (AppData.accYear == null) {
      showError('Academic year is unavailable');
      return;
    }

    final request = AttendanceDetailsRequest(
      accyear: AppData.accYear!,
      standard: selectedStandardId!,
      division: selectedDivisionId!,
      sortBy: 'alphabetic',
    );

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ExamDetailsScreen(
          request: request,
          examId: selectedExamId!,
          examName: selectedExam!,
          examTermId: selectedExamTermId!,
          examTypeId: selectedExamTypeId!,
          gradePlanId: selectedGradePlanId!,
          gradePlanName: selectedGrade!,
          gradeSettings: selectedGradePlan?.settings ?? const [],
          examDate: selectedDate!,
          standardId: selectedStandardId!,
          standardName: selectedStandard!,
          divisionId: selectedDivisionId!,
          divisionName: selectedDivision!,
          subjectId: selectedSubjectId!,
          subjectName: selectedSubject!,
          maxTe: maxTe,
          maxCe: maxCe,
          isEditMode: isEditMode,
          markEntryId: markEntryId,
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }
  // Future<void> goToExamDetails() async {
  //   final maxTe = int.tryParse(maxTeController.text.trim());
  //   final maxCe = int.tryParse(maxCeController.text.trim());

  //   if (selectedExamId == null ||
  //       selectedExam == null ||
  //       selectedExamTermId == null ||
  //       selectedExamTypeId == null ||
  //       selectedGradePlanId == null ||
  //       selectedGrade == null ||
  //       selectedDate == null ||
  //       selectedStandardId == null ||
  //       selectedStandard == null ||
  //       selectedDivisionId == null ||
  //       selectedDivision == null ||
  //       selectedSubjectId == null ||
  //       selectedSubject == null ||
  //       maxTe == null ||
  //       maxCe == null) {
  //     showError('Please fill all the fields');
  //     return;
  //   }

  //   if (maxTe <= 0 || maxCe <= 0) {
  //     showError('Maximum marks must be greater than zero');
  //     return;
  //   }

  //   if (isEditMode && markEntryId == null) {
  //     showError('Mark entry ID is unavailable');
  //     return;
  //   }

  //   if (AppData.accYear == null) {
  //     showError('Academic year is unavailable');
  //     return;
  //   }

  //   final request = AttendanceDetailsRequest(
  //     accyear: AppData.accYear!,
  //     standard: selectedStandardId!,
  //     division: selectedDivisionId!,
  //     sortBy: 'alphabetic',
  //   );

  //   debugPrint('==========================================');
  //   debugPrint(isEditMode ? 'EDIT EXAM DETAILS' : 'ADD EXAM DETAILS');
  //   debugPrint('Mark Entry ID: $markEntryId');
  //   debugPrint('Exam ID: $selectedExamId');
  //   debugPrint('Exam Name: $selectedExam');
  //   debugPrint('Exam Term ID: $selectedExamTermId');
  //   debugPrint('Exam Type ID: $selectedExamTypeId');
  //   debugPrint('Grade Plan ID: $selectedGradePlanId');
  //   debugPrint('Grade Plan: $selectedGrade');
  //   debugPrint('Date: ${formatDate(selectedDate!)}');
  //   debugPrint('Standard ID: $selectedStandardId');
  //   debugPrint('Standard: $selectedStandard');
  //   debugPrint('Division ID: $selectedDivisionId');
  //   debugPrint('Division: $selectedDivision');
  //   debugPrint('Subject ID: $selectedSubjectId');
  //   debugPrint('Subject: $selectedSubject');
  //   debugPrint('Max TE: $maxTe');
  //   debugPrint('Max CE: $maxCe');
  //   debugPrint('Attendance request: ${request.toJson()}');
  //   debugPrint('==========================================');

  //   final result = await Navigator.of(context).push<bool>(
  //     MaterialPageRoute(
  //       builder: (_) => ExamDetailsScreen(
  //         request: request,
  //         examId: selectedExamId!,
  //         examName: selectedExam!,
  //         examTermId: selectedExamTermId!,
  //         examTypeId: selectedExamTypeId!,
  //         gradePlanId: selectedGradePlanId!,
  //         gradePlanName: selectedGrade!,
  //         gradeSettings: selectedGradePlan?.settings ?? const [],
  //         examDate: selectedDate!,
  //         standardId: selectedStandardId!,
  //         standardName: selectedStandard!,
  //         divisionId: selectedDivisionId!,
  //         divisionName: selectedDivision!,
  //         subjectId: selectedSubjectId!,
  //         subjectName: selectedSubject!,
  //         maxTe: maxTe,
  //         maxCe: maxCe,
  //         isEditMode: isEditMode,
  //         markEntryId: markEntryId,
  //       ),
  //     ),
  //   );

  //   if (result == true && mounted) {
  //     Navigator.pop(context, true);
  //   }
  // }

  void showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCubit, ExamState>(
      listenWhen: (previous, current) {
        return current is FetchGradePlanSuccess ||
            current is FetchGradePlanFailure ||
            current is GetAllExamSuccess ||
            current is GetAllExamFailure;
      },
      listener: (context, state) {
        if (state is FetchGradePlanSuccess) {
          setState(() {
            gradePlans = state.response.data ?? [];

            if (isEditMode) {
              resolveGradePlanEditValue();
            } else if (gradePlans.isNotEmpty) {
              selectedGradePlanId = gradePlans.first.gradePlanId;
              selectedGrade = gradePlans.first.gradePlanName;
            }
          });
        }

        if (state is FetchGradePlanFailure) {
          showError(state.message);
        }

        if (state is GetAllExamSuccess) {
          setState(() {
            exams = state.response.data ?? [];

            if (isEditMode) {
              resolveExamEditValue();
            } else {
              selectedExamId = null;
              selectedExam = null;
              selectedExamTermId = null;
              selectedExamTypeId = null;
            }
          });
        }

        if (state is GetAllExamFailure) {
          showError(state.message);
        }
      },
      builder: (context, state) {
        final isGradeLoading = state is FetchGradePlanLoading;

        final isExamLoading = state is GetAllExamLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leadingWidth: 65,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
            ),
            title: Text(
              isEditMode ? 'Edit Exam' : 'Select Exam',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exam information',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildExamDropdown(isLoading: isExamLoading),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: buildGradeDropdown(isLoading: isGradeLoading),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: buildDateField()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Class And Subject',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Local data, so these never show a loading state.
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildStandardDropdown(isLoading: false),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildDivisionDropdown(isLoading: false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      buildSubjectDropdown(isLoading: false),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          controller: maxTeController,
                          hint: 'MAX TE',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buildTextField(
                          controller: maxCeController,
                          hint: 'MAX CE',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 66),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: goToExamDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  // Widget buildExamDropdown({required bool isLoading}) {
  //   final validValue = exams.any((exam) => exam.examId == selectedExamId);

  //   return DropdownButtonFormField<int>(
  //     value: validValue ? selectedExamId : null,
  //     isExpanded: true,
  //     icon: isLoading
  //         ? const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: purpleColor,
  //             ),
  //           )
  //         : const Icon(
  //             Icons.keyboard_arrow_down_rounded,
  //             color: purpleColor,
  //             size: 21,
  //           ),
  //     dropdownColor: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     menuMaxHeight: 300,
  //     hint: Text(
  //       isLoading ? 'Loading...' : 'Select Exam',
  //       style: const TextStyle(color: textColor, fontSize: 11),
  //     ),
  //     decoration: dropdownDecoration(),
  //     items: exams.where((exam) => exam.examId != null).map((exam) {
  //       return DropdownMenuItem<int>(
  //         value: exam.examId,
  //         child: Text(
  //           exam.examName ?? '',
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: textColor, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: isLoading
  //         ? null
  //         : (value) {
  //             if (value == null) return;

  //             GetAllExamData? selectedItem;

  //             for (final exam in exams) {
  //               if (exam.examId == value) {
  //                 selectedItem = exam;
  //                 break;
  //               }
  //             }

  //             if (selectedItem == null) return;

  //             setState(() {
  //               selectedExamId = selectedItem!.examId;
  //               selectedExam = selectedItem.examName;
  //               selectedExamTermId = selectedItem.examTermId;
  //               selectedExamTypeId = selectedItem.examTypeId;
  //             });
  //           },
  //   );
  // }

  // Widget buildGradeDropdown({required bool isLoading}) {
  //   final validValue = gradePlans.any(
  //     (grade) => grade.gradePlanId == selectedGradePlanId,
  //   );

  //   return DropdownButtonFormField<int>(
  //     value: validValue ? selectedGradePlanId : null,
  //     isExpanded: true,
  //     icon: isLoading
  //         ? const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: purpleColor,
  //             ),
  //           )
  //         : const Icon(
  //             Icons.keyboard_arrow_down_rounded,
  //             color: purpleColor,
  //             size: 21,
  //           ),
  //     dropdownColor: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     menuMaxHeight: 300,
  //     hint: Text(
  //       isLoading ? 'Loading...' : 'Grade',
  //       style: const TextStyle(color: textColor, fontSize: 11),
  //     ),
  //     decoration: dropdownDecoration(),
  //     items: gradePlans.where((grade) => grade.gradePlanId != null).map((
  //       grade,
  //     ) {
  //       return DropdownMenuItem<int>(
  //         value: grade.gradePlanId,
  //         child: Text(
  //           grade.gradePlanName ?? '',
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: textColor, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: isLoading
  //         ? null
  //         : (value) {
  //             if (value == null) return;

  //             GradePlanEntity? selectedItem;

  //             for (final grade in gradePlans) {
  //               if (grade.gradePlanId == value) {
  //                 selectedItem = grade;
  //                 break;
  //               }
  //             }

  //             if (selectedItem == null) return;

  //             setState(() {
  //               selectedGradePlanId = selectedItem!.gradePlanId;
  //               selectedGrade = selectedItem.gradePlanName;
  //             });
  //           },
  //   );
  // }

  // Widget buildStandardDropdown({required bool isLoading}) {
  //   final uniqueStandards = <int, TutorshipClass>{};

  //   for (final standard in tutorshipClasses) {
  //     if (standard.standardId != null) {
  //       uniqueStandards[standard.standardId!] = standard;
  //     }
  //   }

  //   final standards = uniqueStandards.values.toList();

  //   final validValue = standards.any(
  //     (standard) => standard.standardId == selectedStandardId,
  //   );

  //   return DropdownButtonFormField<int>(
  //     value: validValue ? selectedStandardId : null,
  //     isExpanded: true,
  //     icon: isLoading
  //         ? const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: purpleColor,
  //             ),
  //           )
  //         : const Icon(
  //             Icons.keyboard_arrow_down_rounded,
  //             color: purpleColor,
  //             size: 21,
  //           ),
  //     dropdownColor: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     menuMaxHeight: 300,
  //     hint: Text(
  //       isLoading ? 'Loading...' : 'Standard',
  //       style: const TextStyle(color: textColor, fontSize: 11),
  //     ),
  //     decoration: dropdownDecoration(),
  //     items: standards.map((standard) {
  //       return DropdownMenuItem<int>(
  //         value: standard.standardId,
  //         child: Text(
  //           standard.standard ?? '',
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: textColor, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: isLoading
  //         ? null
  //         : (value) {
  //             if (value == null) return;

  //             TutorshipClass? selectedItem;

  //             for (final standard in standards) {
  //               if (standard.standardId == value) {
  //                 selectedItem = standard;
  //                 break;
  //               }
  //             }

  //             if (selectedItem == null) return;

  //             setState(() {
  //               selectedStandardId = selectedItem!.standardId;
  //               selectedStandard = selectedItem.standard;

  //               selectedDivisionId = null;
  //               selectedDivision = null;

  //               selectedSubjectId = null;
  //               selectedSubject = null;
  //             });
  //           },
  //   );
  // }

  // Widget buildDivisionDropdown({required bool isLoading}) {
  //   final divisions = availableDivisions;

  //   final validValue = divisions.any(
  //     (division) => division.divisionId == selectedDivisionId,
  //   );

  //   return DropdownButtonFormField<int>(
  //     value: validValue ? selectedDivisionId : null,
  //     isExpanded: true,
  //     icon: isLoading
  //         ? const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: purpleColor,
  //             ),
  //           )
  //         : const Icon(
  //             Icons.keyboard_arrow_down_rounded,
  //             color: purpleColor,
  //             size: 21,
  //           ),
  //     dropdownColor: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     menuMaxHeight: 300,
  //     hint: Text(
  //       isLoading ? 'Loading...' : 'Division',
  //       style: const TextStyle(color: textColor, fontSize: 11),
  //     ),
  //     decoration: dropdownDecoration(),
  //     items: divisions.where((division) => division.divisionId != null).map((
  //       division,
  //     ) {
  //       return DropdownMenuItem<int>(
  //         value: division.divisionId,
  //         child: Text(
  //           division.division ?? '',
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: textColor, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: isLoading
  //         ? null
  //         : (value) {
  //             if (value == null) return;

  //             DivisionDetails? selectedItem;

  //             for (final division in divisions) {
  //               if (division.divisionId == value) {
  //                 selectedItem = division;
  //                 break;
  //               }
  //             }

  //             if (selectedItem == null) return;

  //             setState(() {
  //               selectedDivisionId = selectedItem!.divisionId;
  //               selectedDivision = selectedItem.division;

  //               selectedSubjectId = null;
  //               selectedSubject = null;
  //             });
  //           },
  //   );
  // }

  // Widget buildSubjectDropdown({required bool isLoading}) {
  //   final subjects = availableSubjects;

  //   final validValue = subjects.any(
  //     (subject) => subject.subjectId == selectedSubjectId,
  //   );

  //   return DropdownButtonFormField<int>(
  //     value: validValue ? selectedSubjectId : null,
  //     isExpanded: true,
  //     icon: isLoading
  //         ? const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: purpleColor,
  //             ),
  //           )
  //         : const Icon(
  //             Icons.keyboard_arrow_down_rounded,
  //             color: purpleColor,
  //             size: 21,
  //           ),
  //     dropdownColor: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     menuMaxHeight: 300,
  //     hint: Text(
  //       isLoading ? 'Loading...' : 'Select Subject',
  //       style: const TextStyle(color: textColor, fontSize: 11),
  //     ),
  //     decoration: dropdownDecoration(),
  //     items: subjects.where((subject) => subject.subjectId != null).map((
  //       subject,
  //     ) {
  //       return DropdownMenuItem<int>(
  //         value: subject.subjectId,
  //         child: Text(
  //           subject.subject ?? '',
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: textColor, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: isLoading
  //         ? null
  //         : (value) {
  //             if (value == null) return;

  //             SubjectDetails? selectedItem;

  //             for (final subject in subjects) {
  //               if (subject.subjectId == value) {
  //                 selectedItem = subject;
  //                 break;
  //               }
  //             }

  //             if (selectedItem == null) return;

  //             setState(() {
  //               selectedSubjectId = selectedItem!.subjectId;
  //               selectedSubject = selectedItem.subject;
  //             });
  //           },
  //   );
  // }
  Widget buildExamDropdown({required bool isLoading}) {
    final List<DropdownMenuItem<int>> items = exams
        .where((exam) => exam.examId != null)
        .map((exam) {
          return DropdownMenuItem<int>(
            value: exam.examId,
            child: Text(
              exam.examName ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: textColor, fontSize: 11),
            ),
          );
        })
        .toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedExamId,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading || items.isEmpty
          ? null
          : () async {
              final PickerSelection<int>? result =
                  await showOptionPickerSheet<int>(
                    context: context,
                    title: 'Select Exam',
                    items: items,
                    selectedValue: selectedExamId,
                  );

              if (!mounted || result == null || result.value == null) {
                return;
              }

              GetAllExamData? selectedItem;

              for (final GetAllExamData exam in exams) {
                if (exam.examId == result.value) {
                  selectedItem = exam;
                  break;
                }
              }

              if (selectedItem == null) return;

              setState(() {
                selectedExamId = selectedItem!.examId;
                selectedExam = selectedItem.examName;
                selectedExamTermId = selectedItem.examTermId;
                selectedExamTypeId = selectedItem.examTypeId;
              });
            },
      child: InputDecorator(
        decoration: dropdownDecoration(),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  Text(
                    isLoading ? 'Loading...' : 'Select Exam',
                    style: const TextStyle(color: textColor, fontSize: 11),
                  ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: purpleColor,
                ),
              )
            else
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: purpleColor,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildGradeDropdown({required bool isLoading}) {
    final List<DropdownMenuItem<int>> items = gradePlans
        .where((grade) => grade.gradePlanId != null)
        .map((grade) {
          return DropdownMenuItem<int>(
            value: grade.gradePlanId,
            child: Text(
              grade.gradePlanName ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: textColor, fontSize: 11),
            ),
          );
        })
        .toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedGradePlanId,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading || items.isEmpty
          ? null
          : () async {
              final PickerSelection<int>? result =
                  await showOptionPickerSheet<int>(
                    context: context,
                    title: 'Select Grade',
                    items: items,
                    selectedValue: selectedGradePlanId,
                  );

              if (!mounted || result == null || result.value == null) {
                return;
              }

              GradePlanEntity? selectedItem;

              for (final GradePlanEntity grade in gradePlans) {
                if (grade.gradePlanId == result.value) {
                  selectedItem = grade;
                  break;
                }
              }

              if (selectedItem == null) return;

              setState(() {
                selectedGradePlanId = selectedItem!.gradePlanId;
                selectedGrade = selectedItem.gradePlanName;
              });
            },
      child: InputDecorator(
        decoration: dropdownDecoration(),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  Text(
                    isLoading ? 'Loading...' : 'Grade',
                    style: const TextStyle(color: textColor, fontSize: 11),
                  ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: purpleColor,
                ),
              )
            else
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: purpleColor,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildStandardDropdown({required bool isLoading}) {
    final Map<int, TutorshipClass> uniqueStandards = {};

    for (final TutorshipClass standard in tutorshipClasses) {
      if (standard.standardId != null) {
        uniqueStandards[standard.standardId!] = standard;
      }
    }

    final List<TutorshipClass> standards = uniqueStandards.values.toList();

    final List<DropdownMenuItem<int>> items = standards.map((standard) {
      return DropdownMenuItem<int>(
        value: standard.standardId,
        child: Text(
          standard.standard ?? '',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: textColor, fontSize: 11),
        ),
      );
    }).toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedStandardId,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading || items.isEmpty
          ? null
          : () async {
              final PickerSelection<int>? result =
                  await showOptionPickerSheet<int>(
                    context: context,
                    title: 'Select Standard',
                    items: items,
                    selectedValue: selectedStandardId,
                  );

              if (!mounted || result == null || result.value == null) {
                return;
              }

              TutorshipClass? selectedItem;

              for (final TutorshipClass standard in standards) {
                if (standard.standardId == result.value) {
                  selectedItem = standard;
                  break;
                }
              }

              if (selectedItem == null) return;

              setState(() {
                selectedStandardId = selectedItem!.standardId;
                selectedStandard = selectedItem.standard;

                selectedDivisionId = null;
                selectedDivision = null;

                selectedSubjectId = null;
                selectedSubject = null;
              });
            },
      child: InputDecorator(
        decoration: dropdownDecoration(),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  Text(
                    isLoading ? 'Loading...' : 'Standard',
                    style: const TextStyle(color: textColor, fontSize: 11),
                  ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: purpleColor,
                ),
              )
            else
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: purpleColor,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDivisionDropdown({required bool isLoading}) {
    final List<DivisionDetails> divisions = availableDivisions;

    final List<DropdownMenuItem<int>> items = divisions
        .where((division) => division.divisionId != null)
        .map((division) {
          return DropdownMenuItem<int>(
            value: division.divisionId,
            child: Text(
              division.division ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: textColor, fontSize: 11),
            ),
          );
        })
        .toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedDivisionId,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading || items.isEmpty
          ? null
          : () async {
              final PickerSelection<int>? result =
                  await showOptionPickerSheet<int>(
                    context: context,
                    title: 'Select Division',
                    items: items,
                    selectedValue: selectedDivisionId,
                  );

              if (!mounted || result == null || result.value == null) {
                return;
              }

              DivisionDetails? selectedItem;

              for (final DivisionDetails division in divisions) {
                if (division.divisionId == result.value) {
                  selectedItem = division;
                  break;
                }
              }

              if (selectedItem == null) return;

              setState(() {
                selectedDivisionId = selectedItem!.divisionId;
                selectedDivision = selectedItem.division;

                selectedSubjectId = null;
                selectedSubject = null;
              });
            },
      child: InputDecorator(
        decoration: dropdownDecoration(),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  Text(
                    isLoading ? 'Loading...' : 'Division',
                    style: const TextStyle(color: textColor, fontSize: 11),
                  ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: purpleColor,
                ),
              )
            else
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: purpleColor,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSubjectDropdown({required bool isLoading}) {
    final List<SubjectDetails> subjects = availableSubjects;

    final List<DropdownMenuItem<int>> items = subjects
        .where((subject) => subject.subjectId != null)
        .map((subject) {
          return DropdownMenuItem<int>(
            value: subject.subjectId,
            child: Text(
              subject.subject ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: textColor, fontSize: 11),
            ),
          );
        })
        .toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedSubjectId,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading || items.isEmpty
          ? null
          : () async {
              final PickerSelection<int>? result =
                  await showOptionPickerSheet<int>(
                    context: context,
                    title: 'Select Subject',
                    items: items,
                    selectedValue: selectedSubjectId,
                  );

              if (!mounted || result == null || result.value == null) {
                return;
              }

              SubjectDetails? selectedItem;

              for (final SubjectDetails subject in subjects) {
                if (subject.subjectId == result.value) {
                  selectedItem = subject;
                  break;
                }
              }

              if (selectedItem == null) return;

              setState(() {
                selectedSubjectId = selectedItem!.subjectId;
                selectedSubject = selectedItem.subject;
              });
            },
      child: InputDecorator(
        decoration: dropdownDecoration(),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  Text(
                    isLoading ? 'Loading...' : 'Select Subject',
                    style: const TextStyle(color: textColor, fontSize: 11),
                  ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: purpleColor,
                ),
              )
            else
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: purpleColor,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: textColor,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: purpleColor, width: 1),
        ),
      ),
    );
  }

  Widget buildDateField() {
    return InkWell(
      onTap: pickDate,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate == null ? 'Date' : formatDate(selectedDate!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 5),
            buildPurpleIcon(
              'assets/icons/Group (15).svg',
              iconColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: fieldColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: purpleColor),
      ),
    );
  }

  Widget buildPurpleIcon(
    String assetPath, {
    double size = 28,
    double iconSize = 15,
    Color iconColor = primaryColor,
    Color backgroundColor = Colors.transparent,
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
}
