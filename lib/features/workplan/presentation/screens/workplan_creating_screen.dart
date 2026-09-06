// import 'dart:io';

// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/workplan/domain/entities/workplan_response_entity.dart';
// import 'package:cristalteacher/features/workplan/domain/parameters/fetch_workplan_parameter.dart';
// import 'package:cristalteacher/features/workplan/domain/parameters/save_workplan_parameter.dart';
// import 'package:cristalteacher/features/workplan/presentation/cubit/workplan_cubit.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WorkPlanCreatingScreen extends StatefulWidget {
//   const WorkPlanCreatingScreen({super.key});

//   @override
//   State<WorkPlanCreatingScreen> createState() => _WorkPlanCreatingScreenState();
// }

// class _WorkPlanCreatingScreenState extends State<WorkPlanCreatingScreen> {
//   static const Color primaryColor = Color(0xFF0758C9);
//   static const Color backgroundColor = Color(0xFFF8F8FF);
//   static const Color borderColor = Color(0xFFD7DDEA);
//   static const Color textColor = Color(0xFF29272E);

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   final TextEditingController durationController = TextEditingController();

//   final TextEditingController allottedPeriodsController =
//       TextEditingController();

//   final TextEditingController topicController = TextEditingController();

//   final TextEditingController activityController = TextEditingController();

//   final TextEditingController teachingAidsController = TextEditingController();

//   final TextEditingController conclusionController = TextEditingController();

//   final List<WorkPlanData> workPlans = [];

//   final List<TutorshipClass> standards = [];
//   final List<DivisionDetails> divisions = [];
//   final List<SubjectDetails> subjects = [];

//   int? selectedWorkPlanId;
//   int? selectedStandardId;
//   int? selectedDivisionId;
//   int? selectedSubjectId;

//   File? selectedFile;
//   String? selectedFileName;

//   bool isWorkPlanLoading = false;
//   bool isSaving = false;

//   @override
//   void initState() {
//     super.initState();

//     standards.addAll(AppData.tutorshipClasses);

//     _setInitialClassSelection();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       _fetchWorkPlans();
//     });
//   }

//   void _setInitialClassSelection() {
//     if (standards.isEmpty || selectedStandardId != null) {
//       return;
//     }

//     for (final standard in standards) {
//       final standardDivisions = standard.division ?? <DivisionDetails>[];

//       if (standardDivisions.isEmpty) {
//         continue;
//       }

//       selectedStandardId = standard.standardId;

//       divisions
//         ..clear()
//         ..addAll(standardDivisions);

//       final division = standardDivisions.first;

//       selectedDivisionId = division.divisionId;

//       final divisionSubjects = division.subject ?? <SubjectDetails>[];

//       subjects
//         ..clear()
//         ..addAll(divisionSubjects);

//       if (divisionSubjects.isNotEmpty) {
//         selectedSubjectId = divisionSubjects.first.subjectId;
//       }

//       break;
//     }
//   }

//   void _fetchWorkPlans() {
//     final DateTime now = DateTime.now();

//     final String currentDateTime =
//         '${now.year.toString().padLeft(4, '0')}-'
//         '${now.month.toString().padLeft(2, '0')}-'
//         '${now.day.toString().padLeft(2, '0')} '
//         '${now.hour.toString().padLeft(2, '0')}:'
//         '${now.minute.toString().padLeft(2, '0')}:'
//         '${now.second.toString().padLeft(2, '0')}';

//     final request = FetchWorkPlanParameter(
//       branchId: 1,
//       accYear: AppData.accYear,
//       fromDate: null,
//       toDate: null,
//       status: 'Open',
//       currentDateTime: currentDateTime,
//     );

//     context.read<WorkplanCubit>().fetchWorkPlans(request);
//   }

//   void _selectStandard(int? standardId) {
//     setState(() {
//       selectedStandardId = standardId;
//       selectedDivisionId = null;
//       selectedSubjectId = null;

//       divisions.clear();
//       subjects.clear();

//       if (standardId == null) return;

//       for (final standard in standards) {
//         if (standard.standardId == standardId) {
//           divisions.addAll(standard.division ?? <DivisionDetails>[]);
//           break;
//         }
//       }
//     });
//   }

//   void _selectDivision(int? divisionId) {
//     setState(() {
//       selectedDivisionId = divisionId;
//       selectedSubjectId = null;

//       subjects.clear();

//       if (divisionId == null) return;

//       for (final division in divisions) {
//         if (division.divisionId == divisionId) {
//           subjects.addAll(division.subject ?? <SubjectDetails>[]);
//           break;
//         }
//       }
//     });
//   }

//   Future<void> _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.any,
//     );

//     if (result == null ||
//         result.files.isEmpty ||
//         result.files.single.path == null) {
//       return;
//     }

//     setState(() {
//       selectedFile = File(result.files.single.path!);
//       selectedFileName = result.files.single.name;
//     });
//   }

//   void _savePlan() {
//     FocusScope.of(context).unfocus();

//     if (!(formKey.currentState?.validate() ?? false)) {
//       return;
//     }

//     if (AppData.employeeId == null) {
//       _showMessage('Employee ID is unavailable', isError: true);
//       return;
//     }

//     if (AppData.userId == null) {
//       _showMessage('User ID is unavailable', isError: true);
//       return;
//     }

//     final request = SaveWorkPlanParameter(
//       masterId: selectedWorkPlanId!,
//       employeeId: AppData.employeeId!,
//       standardId: selectedStandardId!,
//       divisionId: selectedDivisionId!,
//       subjectId: selectedSubjectId!,
//       duration: durationController.text.trim(),
//       periods: allottedPeriodsController.text.trim(),
//       topic: topicController.text.trim(),
//       activity: activityController.text.trim(),
//       tools: teachingAidsController.text.trim(),
//       remarks: conclusionController.text.trim(),
//       branchId: 1,
//       createdUser: AppData.userId.toString(),
//       attachment: selectedFile,
//     );

//     context.read<WorkplanCubit>().saveWorkPlan(request);
//   }

//   void _clearForm() {
//     formKey.currentState?.reset();

//     durationController.clear();
//     allottedPeriodsController.clear();
//     topicController.clear();
//     activityController.clear();
//     teachingAidsController.clear();
//     conclusionController.clear();

//     setState(() {
//       selectedWorkPlanId = null;
//       selectedStandardId = null;
//       selectedDivisionId = null;
//       selectedSubjectId = null;

//       selectedFile = null;
//       selectedFileName = null;

//       divisions.clear();
//       subjects.clear();

//       _setInitialClassSelection();
//     });
//   }

//   void _showMessage(String message, {bool isError = false}) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: isError ? Colors.red : Colors.green,
//         ),
//       );
//   }

//   InputDecoration fieldDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: Color(0xFFAAA6AE), fontSize: 13),
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: borderColor),
//       ),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: borderColor),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: primaryColor, width: 1.2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//     );
//   }

//   Widget _label(String text, {bool required = false}) {
//     return Text.rich(
//       TextSpan(
//         text: text,
//         style: const TextStyle(
//           color: textColor,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         children: required
//             ? const [
//                 TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ]
//             : const [],
//       ),
//     );
//   }

//   Widget _sectionContainer({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x10000000),
//             blurRadius: 15,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _requiredTextField({
//     required String label,
//     required String hint,
//     required TextEditingController controller,
//     TextInputType? keyboardType,
//     int minLines = 1,
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _label(label, required: true),
//         const SizedBox(height: 9),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           minLines: minLines,
//           maxLines: maxLines,
//           textInputAction: maxLines > 1
//               ? TextInputAction.newline
//               : TextInputAction.next,
//           style: const TextStyle(fontSize: 13),
//           decoration: fieldDecoration(hint),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Please enter ${label.toLowerCase()}';
//             }

//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _optionalTextField({
//     required String label,
//     required String hint,
//     required TextEditingController controller,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _label(label),
//         const SizedBox(height: 9),
//         TextFormField(
//           controller: controller,
//           minLines: 3,
//           maxLines: 6,
//           keyboardType: TextInputType.multiline,
//           textInputAction: TextInputAction.newline,
//           style: const TextStyle(fontSize: 13),
//           decoration: fieldDecoration(hint),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     durationController.dispose();
//     allottedPeriodsController.dispose();
//     topicController.dispose();
//     activityController.dispose();
//     teachingAidsController.dispose();
//     conclusionController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<WorkplanCubit, WorkplanState>(
//       listener: (context, state) {
//         if (!mounted) return;

//         if (state is FetchWorkPlanLoading) {
//           setState(() {
//             isWorkPlanLoading = true;
//           });
//         }

//         if (state is FetchWorkPlanSuccess) {
//           final data = state.response.data ?? [];

//           setState(() {
//             isWorkPlanLoading = false;

//             workPlans
//               ..clear()
//               ..addAll(data);

//             final selectionExists = workPlans.any(
//               (item) => item.id == selectedWorkPlanId,
//             );

//             if (!selectionExists) {
//               selectedWorkPlanId = null;
//             }
//           });
//         }

//         if (state is FetchWorkPlanFailure) {
//           setState(() {
//             isWorkPlanLoading = false;
//           });

//           _showMessage(state.message, isError: true);
//         }

//         if (state is SaveWorkPlanLoading) {
//           setState(() {
//             isSaving = true;
//           });
//         }

//         if (state is SaveWorkPlanSuccess) {
//           setState(() {
//             isSaving = false;
//           });

//           final String message =
//               state.response.message?.toString().trim() ?? '';

//           _showMessage(
//             message.isEmpty ? 'Class plan saved successfully' : message,
//           );

//           _clearForm();
//         }

//         if (state is SaveWorkPlanFailure) {
//           setState(() {
//             isSaving = false;
//           });

//           _showMessage(state.message, isError: true);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           toolbarHeight: 70,
//           backgroundColor: Colors.white,
//           surfaceTintColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           leadingWidth: 65,
//           leading: IconButton(
//             onPressed: isSaving ? null : () => Navigator.maybePop(context),
//             icon: const Icon(Icons.arrow_back, color: primaryColor, size: 25),
//           ),
//           title: const Text(
//             'Create Class Plan',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         body: SafeArea(
//           top: false,
//           child: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Primary Selection',
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 17),
//                   _sectionContainer(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _label('Work Plan', required: true),
//                         const SizedBox(height: 9),

//                         // WORK PLAN PICKER
//                         FormField<int>(
//                           key: ValueKey(
//                             'workPlan-'
//                             '$selectedWorkPlanId-'
//                             '${workPlans.length}',
//                           ),
//                           initialValue:
//                               workPlans.any(
//                                 (item) => item.id == selectedWorkPlanId,
//                               )
//                               ? selectedWorkPlanId
//                               : null,
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Please select work plan';
//                             }

//                             return null;
//                           },
//                           builder: (field) {
//                             final List<DropdownMenuItem<int>> items = workPlans
//                                 .where((item) => item.id != null)
//                                 .map(
//                                   (item) => DropdownMenuItem<int>(
//                                     value: item.id,
//                                     child: Text(
//                                       item.weekName ?? 'Work Plan',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                         color: textColor,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList();

//                             final DropdownMenuItem<int>? selectedItem =
//                                 selectedItemOf<int>(items, field.value);

//                             return GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap:
//                                   isWorkPlanLoading || isSaving || items.isEmpty
//                                   ? null
//                                   : () async {
//                                       final PickerSelection<int>? result =
//                                           await showOptionPickerSheet<int>(
//                                             context: context,
//                                             title: 'Select Work Plan',
//                                             items: items,
//                                             selectedValue: field.value,
//                                           );

//                                       if (!mounted || result == null) {
//                                         return;
//                                       }

//                                       field.didChange(result.value);

//                                       setState(() {
//                                         selectedWorkPlanId = result.value;
//                                       });
//                                     },
//                               child: InputDecorator(
//                                 decoration: fieldDecoration(
//                                   '',
//                                 ).copyWith(errorText: field.errorText),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child:
//                                           selectedItem?.child ??
//                                           Text(
//                                             isWorkPlanLoading
//                                                 ? 'Loading work plans...'
//                                                 : 'Select Work Plan',
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                               color: Color(0xFF9B98A1),
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                     ),
//                                     if (isWorkPlanLoading)
//                                       const SizedBox(
//                                         width: 18,
//                                         height: 18,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: primaryColor,
//                                         ),
//                                       )
//                                     else
//                                       const Icon(
//                                         Icons.keyboard_arrow_down_rounded,
//                                         color: Color(0xFF78737E),
//                                         size: 23,
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Curriculum Details',
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 17),
//                   _sectionContainer(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _label('Standard', required: true),
//                         const SizedBox(height: 9),

//                         // STANDARD PICKER
//                         FormField<int>(
//                           key: ValueKey(
//                             'standard-'
//                             '$selectedStandardId',
//                           ),
//                           initialValue:
//                               standards.any(
//                                 (item) => item.standardId == selectedStandardId,
//                               )
//                               ? selectedStandardId
//                               : null,
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Please select standard';
//                             }

//                             return null;
//                           },
//                           builder: (field) {
//                             final List<DropdownMenuItem<int>> items = standards
//                                 .where((item) => item.standardId != null)
//                                 .map(
//                                   (item) => DropdownMenuItem<int>(
//                                     value: item.standardId,
//                                     child: Text(
//                                       item.standard ?? 'Standard',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(fontSize: 13),
//                                     ),
//                                   ),
//                                 )
//                                 .toList();

//                             final DropdownMenuItem<int>? selectedItem =
//                                 selectedItemOf<int>(items, field.value);

//                             return GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap: isSaving || items.isEmpty
//                                   ? null
//                                   : () async {
//                                       final PickerSelection<int>? result =
//                                           await showOptionPickerSheet<int>(
//                                             context: context,
//                                             title: 'Select Standard',
//                                             items: items,
//                                             selectedValue: field.value,
//                                           );

//                                       if (!mounted || result == null) {
//                                         return;
//                                       }

//                                       field.didChange(result.value);

//                                       _selectStandard(result.value);
//                                     },
//                               child: InputDecorator(
//                                 decoration: fieldDecoration(
//                                   '',
//                                 ).copyWith(errorText: field.errorText),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child:
//                                           selectedItem?.child ??
//                                           const Text(
//                                             'Select Standard',
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: Color(0xFF9B98A1),
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                     ),
//                                     const Icon(
//                                       Icons.keyboard_arrow_down_rounded,
//                                       color: Color(0xFF78737E),
//                                       size: 23,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 17),
//                         _label('Division', required: true),
//                         const SizedBox(height: 9),

//                         // DIVISION PICKER
//                         FormField<int>(
//                           key: ValueKey(
//                             'division-'
//                             '$selectedStandardId-'
//                             '$selectedDivisionId',
//                           ),
//                           initialValue:
//                               divisions.any(
//                                 (item) => item.divisionId == selectedDivisionId,
//                               )
//                               ? selectedDivisionId
//                               : null,
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Please select division';
//                             }

//                             return null;
//                           },
//                           builder: (field) {
//                             final List<DropdownMenuItem<int>> items = divisions
//                                 .where((item) => item.divisionId != null)
//                                 .map(
//                                   (item) => DropdownMenuItem<int>(
//                                     value: item.divisionId,
//                                     child: Text(
//                                       item.division ?? 'Division',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(fontSize: 13),
//                                     ),
//                                   ),
//                                 )
//                                 .toList();

//                             final DropdownMenuItem<int>? selectedItem =
//                                 selectedItemOf<int>(items, field.value);

//                             return GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap:
//                                   selectedStandardId == null ||
//                                       isSaving ||
//                                       items.isEmpty
//                                   ? null
//                                   : () async {
//                                       final PickerSelection<int>? result =
//                                           await showOptionPickerSheet<int>(
//                                             context: context,
//                                             title: 'Select Division',
//                                             items: items,
//                                             selectedValue: field.value,
//                                           );

//                                       if (!mounted || result == null) {
//                                         return;
//                                       }

//                                       field.didChange(result.value);

//                                       _selectDivision(result.value);
//                                     },
//                               child: InputDecorator(
//                                 decoration: fieldDecoration(
//                                   '',
//                                 ).copyWith(errorText: field.errorText),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child:
//                                           selectedItem?.child ??
//                                           const Text(
//                                             'Select Division',
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: Color(0xFF9B98A1),
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                     ),
//                                     const Icon(
//                                       Icons.keyboard_arrow_down_rounded,
//                                       color: Color(0xFF78737E),
//                                       size: 23,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 17),
//                         _label('Subject', required: true),
//                         const SizedBox(height: 9),

//                         // SUBJECT PICKER
//                         FormField<int>(
//                           key: ValueKey(
//                             'subject-'
//                             '$selectedDivisionId-'
//                             '$selectedSubjectId',
//                           ),
//                           initialValue:
//                               subjects.any(
//                                 (item) => item.subjectId == selectedSubjectId,
//                               )
//                               ? selectedSubjectId
//                               : null,
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Please select subject';
//                             }

//                             return null;
//                           },
//                           builder: (field) {
//                             final List<DropdownMenuItem<int>> items = subjects
//                                 .where((item) => item.subjectId != null)
//                                 .map(
//                                   (item) => DropdownMenuItem<int>(
//                                     value: item.subjectId,
//                                     child: Text(
//                                       item.subject ?? 'Subject',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(fontSize: 13),
//                                     ),
//                                   ),
//                                 )
//                                 .toList();

//                             final DropdownMenuItem<int>? selectedItem =
//                                 selectedItemOf<int>(items, field.value);

//                             return GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap:
//                                   selectedDivisionId == null ||
//                                       isSaving ||
//                                       items.isEmpty
//                                   ? null
//                                   : () async {
//                                       final PickerSelection<int>? result =
//                                           await showOptionPickerSheet<int>(
//                                             context: context,
//                                             title: 'Select Subject',
//                                             items: items,
//                                             selectedValue: field.value,
//                                           );

//                                       if (!mounted || result == null) {
//                                         return;
//                                       }

//                                       field.didChange(result.value);

//                                       setState(() {
//                                         selectedSubjectId = result.value;
//                                       });
//                                     },
//                               child: InputDecorator(
//                                 decoration: fieldDecoration(
//                                   '',
//                                 ).copyWith(errorText: field.errorText),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child:
//                                           selectedItem?.child ??
//                                           const Text(
//                                             'Select Subject',
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: Color(0xFF9B98A1),
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                     ),
//                                     const Icon(
//                                       Icons.keyboard_arrow_down_rounded,
//                                       color: Color(0xFF78737E),
//                                       size: 23,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Class Plan',
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 17),
//                   _sectionContainer(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _requiredTextField(
//                           label: 'Duration',
//                           hint: 'Enter duration',
//                           controller: durationController,
//                         ),
//                         const SizedBox(height: 17),
//                         _requiredTextField(
//                           label: 'Allotted Periods',
//                           hint: 'Enter allotted periods',
//                           controller: allottedPeriodsController,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 17),
//                         _requiredTextField(
//                           label: 'Topic',
//                           hint: 'Enter topic',
//                           controller: topicController,
//                           keyboardType: TextInputType.multiline,
//                           minLines: 2,
//                           maxLines: 4,
//                         ),
//                         const SizedBox(height: 17),
//                         _optionalTextField(
//                           label: 'Activity & Presentation',
//                           hint: 'Enter activity and presentation',
//                           controller: activityController,
//                         ),
//                         const SizedBox(height: 17),
//                         _optionalTextField(
//                           label: 'Teaching Aids',
//                           hint: 'Enter teaching aids',
//                           controller: teachingAidsController,
//                         ),
//                         const SizedBox(height: 17),
//                         _optionalTextField(
//                           label: 'Conclusion & Assessment',
//                           hint: 'Enter conclusion and assessment',
//                           controller: conclusionController,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Attachment',
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 17),
//                   _sectionContainer(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _label('Select file'),
//                         const SizedBox(height: 10),
//                         InkWell(
//                           onTap: isSaving ? null : _pickFile,
//                           borderRadius: BorderRadius.circular(8),
//                           child: Container(
//                             width: double.infinity,
//                             height: 145,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: borderColor),
//                             ),
//                             child: selectedFile == null
//                                 ? const Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: Color(0xFFEAF2FF),
//                                         child: Icon(
//                                           Icons.cloud_upload_outlined,
//                                           color: primaryColor,
//                                         ),
//                                       ),
//                                       SizedBox(height: 10),
//                                       Text(
//                                         'Tap to select file',
//                                         style: TextStyle(
//                                           color: Color(0xFF88838D),
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : Row(
//                                     children: [
//                                       const SizedBox(width: 16),
//                                       const Icon(
//                                         Icons.insert_drive_file,
//                                         color: primaryColor,
//                                         size: 30,
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Text(
//                                           selectedFileName ?? '',
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed: isSaving
//                                             ? null
//                                             : () {
//                                                 setState(() {
//                                                   selectedFile = null;
//                                                   selectedFileName = null;
//                                                 });
//                                               },
//                                         icon: const Icon(
//                                           Icons.close,
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(height: 17),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: isSaving ? null : _savePlan,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryColor,
//                               foregroundColor: Colors.white,
//                               disabledBackgroundColor: primaryColor.withOpacity(
//                                 0.60,
//                               ),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(7),
//                               ),
//                             ),
//                             child: isSaving
//                                 ? const SizedBox(
//                                     width: 22,
//                                     height: 22,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                 : const Text(
//                                     'Save Plan',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/workplan/domain/entities/workplan_response_entity.dart';
import 'package:cristalteacher/features/workplan/domain/parameters/fetch_workplan_parameter.dart';
import 'package:cristalteacher/features/workplan/domain/parameters/save_workplan_parameter.dart';
import 'package:cristalteacher/features/workplan/presentation/cubit/workplan_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkPlanCreatingScreen extends StatefulWidget {
  const WorkPlanCreatingScreen({super.key});

  @override
  State<WorkPlanCreatingScreen> createState() => _WorkPlanCreatingScreenState();
}

class _WorkPlanCreatingScreenState extends State<WorkPlanCreatingScreen> {
  static const Color primaryColor = Color(0xFF0758C9);
  static const Color backgroundColor = Color(0xFFF8F8FF);
  static const Color borderColor = Color(0xFFD7DDEA);
  static const Color textColor = Color(0xFF29272E);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController durationController = TextEditingController();

  final TextEditingController allottedPeriodsController =
      TextEditingController();

  final TextEditingController topicController = TextEditingController();

  final TextEditingController activityController = TextEditingController();

  final TextEditingController teachingAidsController = TextEditingController();

  final TextEditingController conclusionController = TextEditingController();

  final List<WorkPlanData> workPlans = [];

  /// Every standard in the branch, with the teacher's own classes merged
  /// in behind it. This is what the Standard picker lists.
  final List<TutorshipClass> standards = [];

  /// Teacher's own classes. Only a fallback source of divisions, for
  /// standards that come from the full list without their own.
  final List<TutorshipClass> tutorshipClasses = [];

  final List<DivisionDetails> divisions = [];
  final List<SubjectDetails> subjects = [];

  int? selectedWorkPlanId;
  int? selectedStandardId;
  int? selectedDivisionId;
  int? selectedSubjectId;

  File? selectedFile;
  String? selectedFileName;

  bool isWorkPlanLoading = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    tutorshipClasses.addAll(AppData.tutorshipClasses);

    standards.addAll(_buildStandardList());

    _setInitialClassSelection();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fetchWorkPlans();
    });
  }

  /// The full standard list first, the teacher's own classes merged in
  /// behind it, deduplicated by standard id.
  List<TutorshipClass> _buildStandardList() {
    final Map<int, TutorshipClass> unique = {};

    final List<TutorshipClass> source = AppData.standards.isNotEmpty
        ? AppData.standards
        : AppData.tutorshipClasses;

    for (final TutorshipClass item in source) {
      if (item.standardId != null) {
        unique[item.standardId!] = item;
      }
    }

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId != null) {
        unique.putIfAbsent(item.standardId!, () => item);
      }
    }

    return unique.values.toList();
  }

  /// Both lists, searched together. A standard can appear more than once -
  /// the class list carries one entry per standard/division pair - so every
  /// entry has to be visited, not just the first match.
  List<TutorshipClass> get _classSources => [...standards, ...tutorshipClasses];

  /// Every division of [standardId], merged across all entries that carry
  /// that standard and deduplicated by division id.
  List<DivisionDetails> _divisionsFor(int? standardId) {
    if (standardId == null) {
      return <DivisionDetails>[];
    }

    final Map<int, DivisionDetails> unique = {};

    for (final TutorshipClass item in _classSources) {
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

  /// Every subject of [divisionId] under [standardId], merged the same way.
  List<SubjectDetails> _subjectsFor(int? standardId, int? divisionId) {
    if (standardId == null || divisionId == null) {
      return <SubjectDetails>[];
    }

    final Map<int, SubjectDetails> unique = {};

    for (final TutorshipClass item in _classSources) {
      if (item.standardId != standardId) {
        continue;
      }

      for (final DivisionDetails division
          in item.division ?? const <DivisionDetails>[]) {
        if (division.divisionId != divisionId) {
          continue;
        }

        for (final SubjectDetails subject
            in division.subject ?? const <SubjectDetails>[]) {
          if (subject.subjectId != null) {
            unique.putIfAbsent(subject.subjectId!, () => subject);
          }
        }
      }
    }

    return unique.values.toList();
  }

  void _setInitialClassSelection() {
    if (standards.isEmpty || selectedStandardId != null) {
      return;
    }

    // The teacher's own classes come first, so the screen still opens on
    // the same class it did before the list was widened.
    final List<TutorshipClass> ordered = [...tutorshipClasses, ...standards];

    for (final standard in ordered) {
      final standardDivisions = _divisionsFor(standard.standardId);

      if (standardDivisions.isEmpty) {
        continue;
      }

      selectedStandardId = standard.standardId;

      divisions
        ..clear()
        ..addAll(standardDivisions);

      final division = standardDivisions.first;

      selectedDivisionId = division.divisionId;

      final divisionSubjects = _subjectsFor(
        selectedStandardId,
        selectedDivisionId,
      );

      subjects
        ..clear()
        ..addAll(divisionSubjects);

      if (divisionSubjects.isNotEmpty) {
        selectedSubjectId = divisionSubjects.first.subjectId;
      }

      break;
    }
  }

  void _fetchWorkPlans() {
    final DateTime now = DateTime.now();

    final String currentDateTime =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    final request = FetchWorkPlanParameter(
      branchId: 1,
      accYear: AppData.accYear,
      fromDate: null,
      toDate: null,
      status: 'Open',
      currentDateTime: currentDateTime,
    );

    context.read<WorkplanCubit>().fetchWorkPlans(request);
  }

  void _selectStandard(int? standardId) {
    setState(() {
      selectedStandardId = standardId;
      selectedDivisionId = null;
      selectedSubjectId = null;

      divisions.clear();
      subjects.clear();

      if (standardId == null) return;

      divisions.addAll(_divisionsFor(standardId));
    });
  }

  void _selectDivision(int? divisionId) {
    setState(() {
      selectedDivisionId = divisionId;
      selectedSubjectId = null;

      subjects.clear();

      if (divisionId == null) return;

      subjects.addAll(_subjectsFor(selectedStandardId, divisionId));
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      return;
    }

    setState(() {
      selectedFile = File(result.files.single.path!);
      selectedFileName = result.files.single.name;
    });
  }

  void _savePlan() {
    FocusScope.of(context).unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (AppData.employeeId == null) {
      _showMessage('Employee ID is unavailable', isError: true);
      return;
    }

    if (AppData.userId == null) {
      _showMessage('User ID is unavailable', isError: true);
      return;
    }

    final request = SaveWorkPlanParameter(
      masterId: selectedWorkPlanId!,
      employeeId: AppData.employeeId!,
      standardId: selectedStandardId!,
      divisionId: selectedDivisionId!,
      subjectId: selectedSubjectId!,
      duration: durationController.text.trim(),
      periods: allottedPeriodsController.text.trim(),
      topic: topicController.text.trim(),
      activity: activityController.text.trim(),
      tools: teachingAidsController.text.trim(),
      remarks: conclusionController.text.trim(),
      branchId: 1,
      createdUser: AppData.userId.toString(),
      attachment: selectedFile,
    );

    context.read<WorkplanCubit>().saveWorkPlan(request);
  }

  void _clearForm() {
    formKey.currentState?.reset();

    durationController.clear();
    allottedPeriodsController.clear();
    topicController.clear();
    activityController.clear();
    teachingAidsController.clear();
    conclusionController.clear();

    setState(() {
      selectedWorkPlanId = null;
      selectedStandardId = null;
      selectedDivisionId = null;
      selectedSubjectId = null;

      selectedFile = null;
      selectedFileName = null;

      divisions.clear();
      subjects.clear();

      _setInitialClassSelection();
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAA6AE), fontSize: 13),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : const [],
      ),
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _requiredTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: true),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          textInputAction: maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next,
          style: const TextStyle(fontSize: 13),
          decoration: fieldDecoration(hint),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter ${label.toLowerCase()}';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _optionalTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          style: const TextStyle(fontSize: 13),
          decoration: fieldDecoration(hint),
        ),
      ],
    );
  }

  @override
  void dispose() {
    durationController.dispose();
    allottedPeriodsController.dispose();
    topicController.dispose();
    activityController.dispose();
    teachingAidsController.dispose();
    conclusionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkplanCubit, WorkplanState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is FetchWorkPlanLoading) {
          setState(() {
            isWorkPlanLoading = true;
          });
        }

        if (state is FetchWorkPlanSuccess) {
          final data = state.response.data ?? [];

          setState(() {
            isWorkPlanLoading = false;

            workPlans
              ..clear()
              ..addAll(data);

            final selectionExists = workPlans.any(
              (item) => item.id == selectedWorkPlanId,
            );

            if (!selectionExists) {
              selectedWorkPlanId = null;
            }
          });
        }

        if (state is FetchWorkPlanFailure) {
          setState(() {
            isWorkPlanLoading = false;
          });

          _showMessage(state.message, isError: true);
        }

        if (state is SaveWorkPlanLoading) {
          setState(() {
            isSaving = true;
          });
        }

        if (state is SaveWorkPlanSuccess) {
          setState(() {
            isSaving = false;
          });

          final String message =
              state.response.message?.toString().trim() ?? '';

          _showMessage(
            message.isEmpty ? 'Class plan saved successfully' : message,
          );

          _clearForm();
        }

        if (state is SaveWorkPlanFailure) {
          setState(() {
            isSaving = false;
          });

          _showMessage(state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 65,
          leading: IconButton(
            onPressed: isSaving ? null : () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: primaryColor, size: 25),
          ),
          title: const Text(
            'Create Class Plan',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Primary Selection',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 17),
                  _sectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Work Plan', required: true),
                        const SizedBox(height: 9),

                        // WORK PLAN PICKER
                        FormField<int>(
                          key: ValueKey(
                            'workPlan-'
                            '$selectedWorkPlanId-'
                            '${workPlans.length}',
                          ),
                          initialValue:
                              workPlans.any(
                                (item) => item.id == selectedWorkPlanId,
                              )
                              ? selectedWorkPlanId
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select work plan';
                            }

                            return null;
                          },
                          builder: (field) {
                            final List<DropdownMenuItem<int>> items = workPlans
                                .where((item) => item.id != null)
                                .map(
                                  (item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(
                                      item.weekName ?? 'Work Plan',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: textColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();

                            final DropdownMenuItem<int>? selectedItem =
                                selectedItemOf<int>(items, field.value);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap:
                                  isWorkPlanLoading || isSaving || items.isEmpty
                                  ? null
                                  : () async {
                                      final PickerSelection<int>? result =
                                          await showOptionPickerSheet<int>(
                                            context: context,
                                            title: 'Select Work Plan',
                                            items: items,
                                            selectedValue: field.value,
                                          );

                                      if (!mounted || result == null) {
                                        return;
                                      }

                                      field.didChange(result.value);

                                      setState(() {
                                        selectedWorkPlanId = result.value;
                                      });
                                    },
                              child: InputDecorator(
                                decoration: fieldDecoration(
                                  '',
                                ).copyWith(errorText: field.errorText),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:
                                          selectedItem?.child ??
                                          Text(
                                            isWorkPlanLoading
                                                ? 'Loading work plans...'
                                                : 'Select Work Plan',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF9B98A1),
                                              fontSize: 13,
                                            ),
                                          ),
                                    ),
                                    if (isWorkPlanLoading)
                                      const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primaryColor,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFF78737E),
                                        size: 23,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Curriculum Details',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 17),
                  _sectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Standard', required: true),
                        const SizedBox(height: 9),

                        // STANDARD PICKER
                        FormField<int>(
                          key: ValueKey(
                            'standard-'
                            '$selectedStandardId',
                          ),
                          initialValue:
                              standards.any(
                                (item) => item.standardId == selectedStandardId,
                              )
                              ? selectedStandardId
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select standard';
                            }

                            return null;
                          },
                          builder: (field) {
                            final List<DropdownMenuItem<int>> items = standards
                                .where((item) => item.standardId != null)
                                .map(
                                  (item) => DropdownMenuItem<int>(
                                    value: item.standardId,
                                    child: Text(
                                      item.standard ?? 'Standard',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                .toList();

                            final DropdownMenuItem<int>? selectedItem =
                                selectedItemOf<int>(items, field.value);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: isSaving || items.isEmpty
                                  ? null
                                  : () async {
                                      final PickerSelection<int>? result =
                                          await showOptionPickerSheet<int>(
                                            context: context,
                                            title: 'Select Standard',
                                            items: items,
                                            selectedValue: field.value,
                                          );

                                      if (!mounted || result == null) {
                                        return;
                                      }

                                      field.didChange(result.value);

                                      _selectStandard(result.value);
                                    },
                              child: InputDecorator(
                                decoration: fieldDecoration(
                                  '',
                                ).copyWith(errorText: field.errorText),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:
                                          selectedItem?.child ??
                                          const Text(
                                            'Select Standard',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color(0xFF9B98A1),
                                              fontSize: 13,
                                            ),
                                          ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF78737E),
                                      size: 23,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 17),
                        _label('Division', required: true),
                        const SizedBox(height: 9),

                        // DIVISION PICKER
                        FormField<int>(
                          key: ValueKey(
                            'division-'
                            '$selectedStandardId-'
                            '$selectedDivisionId',
                          ),
                          initialValue:
                              divisions.any(
                                (item) => item.divisionId == selectedDivisionId,
                              )
                              ? selectedDivisionId
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select division';
                            }

                            return null;
                          },
                          builder: (field) {
                            final List<DropdownMenuItem<int>> items = divisions
                                .where((item) => item.divisionId != null)
                                .map(
                                  (item) => DropdownMenuItem<int>(
                                    value: item.divisionId,
                                    child: Text(
                                      item.division ?? 'Division',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                .toList();

                            final DropdownMenuItem<int>? selectedItem =
                                selectedItemOf<int>(items, field.value);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap:
                                  selectedStandardId == null ||
                                      isSaving ||
                                      items.isEmpty
                                  ? null
                                  : () async {
                                      final PickerSelection<int>? result =
                                          await showOptionPickerSheet<int>(
                                            context: context,
                                            title: 'Select Division',
                                            items: items,
                                            selectedValue: field.value,
                                          );

                                      if (!mounted || result == null) {
                                        return;
                                      }

                                      field.didChange(result.value);

                                      _selectDivision(result.value);
                                    },
                              child: InputDecorator(
                                decoration: fieldDecoration(
                                  '',
                                ).copyWith(errorText: field.errorText),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:
                                          selectedItem?.child ??
                                          const Text(
                                            'Select Division',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color(0xFF9B98A1),
                                              fontSize: 13,
                                            ),
                                          ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF78737E),
                                      size: 23,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 17),
                        _label('Subject', required: true),
                        const SizedBox(height: 9),

                        // SUBJECT PICKER
                        FormField<int>(
                          key: ValueKey(
                            'subject-'
                            '$selectedDivisionId-'
                            '$selectedSubjectId',
                          ),
                          initialValue:
                              subjects.any(
                                (item) => item.subjectId == selectedSubjectId,
                              )
                              ? selectedSubjectId
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select subject';
                            }

                            return null;
                          },
                          builder: (field) {
                            final List<DropdownMenuItem<int>> items = subjects
                                .where((item) => item.subjectId != null)
                                .map(
                                  (item) => DropdownMenuItem<int>(
                                    value: item.subjectId,
                                    child: Text(
                                      item.subject ?? 'Subject',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                .toList();

                            final DropdownMenuItem<int>? selectedItem =
                                selectedItemOf<int>(items, field.value);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap:
                                  selectedDivisionId == null ||
                                      isSaving ||
                                      items.isEmpty
                                  ? null
                                  : () async {
                                      final PickerSelection<int>? result =
                                          await showOptionPickerSheet<int>(
                                            context: context,
                                            title: 'Select Subject',
                                            items: items,
                                            selectedValue: field.value,
                                          );

                                      if (!mounted || result == null) {
                                        return;
                                      }

                                      field.didChange(result.value);

                                      setState(() {
                                        selectedSubjectId = result.value;
                                      });
                                    },
                              child: InputDecorator(
                                decoration: fieldDecoration(
                                  '',
                                ).copyWith(errorText: field.errorText),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:
                                          selectedItem?.child ??
                                          const Text(
                                            'Select Subject',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color(0xFF9B98A1),
                                              fontSize: 13,
                                            ),
                                          ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF78737E),
                                      size: 23,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Class Plan',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 17),
                  _sectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _requiredTextField(
                          label: 'Duration',
                          hint: 'Enter duration',
                          controller: durationController,
                        ),
                        const SizedBox(height: 17),
                        _requiredTextField(
                          label: 'Allotted Periods',
                          hint: 'Enter allotted periods',
                          controller: allottedPeriodsController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 17),
                        _requiredTextField(
                          label: 'Topic',
                          hint: 'Enter topic',
                          controller: topicController,
                          keyboardType: TextInputType.multiline,
                          minLines: 2,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 17),
                        _optionalTextField(
                          label: 'Activity & Presentation',
                          hint: 'Enter activity and presentation',
                          controller: activityController,
                        ),
                        const SizedBox(height: 17),
                        _optionalTextField(
                          label: 'Teaching Aids',
                          hint: 'Enter teaching aids',
                          controller: teachingAidsController,
                        ),
                        const SizedBox(height: 17),
                        _optionalTextField(
                          label: 'Conclusion & Assessment',
                          hint: 'Enter conclusion and assessment',
                          controller: conclusionController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Attachment',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 17),
                  _sectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Select file'),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: isSaving ? null : _pickFile,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: 145,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: selectedFile == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Color(0xFFEAF2FF),
                                        child: Icon(
                                          Icons.cloud_upload_outlined,
                                          color: primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Tap to select file',
                                        style: TextStyle(
                                          color: Color(0xFF88838D),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.insert_drive_file,
                                        color: primaryColor,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          selectedFileName ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: isSaving
                                            ? null
                                            : () {
                                                setState(() {
                                                  selectedFile = null;
                                                  selectedFileName = null;
                                                });
                                              },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 17),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isSaving ? null : _savePlan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: primaryColor.withOpacity(
                                0.60,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save Plan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
