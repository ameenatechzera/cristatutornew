// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
// import 'package:cristalteacher/features/exam/presentation/cubit/exammanagement_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AddExamScreen extends StatefulWidget {
//   const AddExamScreen({super.key});

//   @override
//   State<AddExamScreen> createState() => _AddExamScreenState();
// }

// class _AddExamScreenState extends State<AddExamScreen> {
//   static const Color primaryColor = Color(0xFF9B73E6);
//   static const Color fieldColor = Color(0xFFF0F4FF);

//   final TextEditingController examNameController = TextEditingController();

//   final List<dynamic> examTerms = [];
//   final List<dynamic> examTypes = [];

//   int? selectedExamTermId;
//   int? selectedExamTypeId;

//   String? selectedExamTermName;
//   String? selectedExamTypeName;

//   bool isExamTermsLoading = true;
//   bool isExamTypesLoading = true;
//   bool isSaving = false;

//   bool isOpen = true;
//   bool publish = false;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ExamManagementCubit>().getExamTerms();
//       context.read<ExamManagementCubit>().getExamTypes();
//     });
//   }

//   @override
//   void dispose() {
//     examNameController.dispose();
//     super.dispose();
//   }

//   void _saveExam() {
//     final examName = examNameController.text.trim();

//     if (examName.isEmpty) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('Please enter Exam Name'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       return;
//     }

//     if (selectedExamTermId == null) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('Please select Exam Term'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       return;
//     }

//     if (selectedExamTypeId == null) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('Please select Exam Type'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       return;
//     }

//     final parameter = SaveExamParameter(
//       examName: examName,
//       examTermId: selectedExamTermId!,
//       examTypeId: selectedExamTypeId!,
//       isOpen: isOpen,
//       isPublish: publish,
//       branchId: AppData.branchId ?? 1,
//       createdUser: AppData.userId!,
//     );

//     context.read<ExamManagementCubit>().saveExam(parameter);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<ExamManagementCubit, ExamManagementState>(
//           listener: (context, state) {
//             if (state is ExamTermsLoading) {
//               setState(() {
//                 isExamTermsLoading = true;
//               });
//             }

//             if (state is ExamTermsSuccess) {
//               setState(() {
//                 examTerms
//                   ..clear()
//                   ..addAll(state.response.data ?? []);

//                 isExamTermsLoading = false;
//               });
//             }

//             if (state is ExamTermsFailure) {
//               setState(() {
//                 isExamTermsLoading = false;
//               });

//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(
//                     content: Text(state.message),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//             }
//           },
//         ),

//         BlocListener<ExamManagementCubit, ExamManagementState>(
//           listener: (context, state) {
//             if (state is ExamTypesLoading) {
//               setState(() {
//                 isExamTypesLoading = true;
//               });
//             }

//             if (state is ExamTypesSuccess) {
//               setState(() {
//                 examTypes
//                   ..clear()
//                   ..addAll(state.response.data ?? []);

//                 isExamTypesLoading = false;
//               });
//             }

//             if (state is ExamTypesFailure) {
//               setState(() {
//                 isExamTypesLoading = false;
//               });

//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(
//                     content: Text(state.message),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//             }
//           },
//         ),

//         // SAVE EXAM LISTENER
//         BlocListener<ExamManagementCubit, ExamManagementState>(
//           listener: (context, state) {
//             if (state is SaveExamLoading) {
//               setState(() {
//                 isSaving = true;
//               });
//             }

//             if (state is SaveExamSuccess) {
//               setState(() {
//                 isSaving = false;
//               });

//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   const SnackBar(
//                     content: Text('Exam added successfully'),
//                     backgroundColor: Colors.green,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );

//               Navigator.pop(context, true);
//             }

//             if (state is SaveExamFailure) {
//               setState(() {
//                 isSaving = false;
//               });

//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(
//                     content: Text(state.message),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           surfaceTintColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.maybePop(context);
//             },
//             icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
//           ),
//           title: const Text(
//             'Add Exam',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: SafeArea(
//           top: false,
//           child: Column(
//             children: [
//               const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

//               Expanded(
//                 child: SingleChildScrollView(
//                   keyboardDismissBehavior:
//                       ScrollViewKeyboardDismissBehavior.onDrag,
//                   padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // EXAM NAME
//                       RichText(
//                         text: const TextSpan(
//                           text: 'Exam Name',
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       TextField(
//                         controller: examNameController,
//                         textInputAction: TextInputAction.next,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.black,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Enter Exam Name',
//                           hintStyle: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black45,
//                           ),
//                           filled: true,
//                           fillColor: fieldColor,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 14,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                               color: primaryColor,
//                               width: 1.2,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // EXAM TERM
//                       RichText(
//                         text: const TextSpan(
//                           text: 'Exam Term',
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       DropdownButtonFormField<int>(
//                         value: selectedExamTermId,
//                         isExpanded: true,
//                         icon: isExamTermsLoading
//                             ? const SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: primaryColor,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: Colors.black54,
//                               ),
//                         decoration: InputDecoration(
//                           hintText: isExamTermsLoading
//                               ? 'Loading Exam Terms...'
//                               : examTerms.isEmpty
//                               ? 'No Exam Terms Available'
//                               : 'Select Exam Term',
//                           hintStyle: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black45,
//                           ),
//                           filled: true,
//                           fillColor: fieldColor,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 14,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                               color: primaryColor,
//                               width: 1.2,
//                             ),
//                           ),
//                         ),
//                         items: examTerms.map((term) {
//                           return DropdownMenuItem<int>(
//                             value: term.examTermId,
//                             child: Text(
//                               term.examTermName ?? '',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: isExamTermsLoading || examTerms.isEmpty
//                             ? null
//                             : (value) {
//                                 final selectedTerm = examTerms.firstWhere(
//                                   (term) => term.examTermId == value,
//                                 );

//                                 setState(() {
//                                   selectedExamTermId = value;
//                                   selectedExamTermName =
//                                       selectedTerm.examTermName;
//                                 });
//                               },
//                       ),

//                       const SizedBox(height: 20),

//                       // EXAM TYPE
//                       RichText(
//                         text: const TextSpan(
//                           text: 'Exam Type',
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       DropdownButtonFormField<int>(
//                         value: selectedExamTypeId,
//                         isExpanded: true,
//                         icon: isExamTypesLoading
//                             ? const SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: primaryColor,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: Colors.black54,
//                               ),
//                         decoration: InputDecoration(
//                           hintText: isExamTypesLoading
//                               ? 'Loading Exam Types...'
//                               : examTypes.isEmpty
//                               ? 'No Exam Types Available'
//                               : 'Select Exam Type',
//                           hintStyle: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black45,
//                           ),
//                           filled: true,
//                           fillColor: fieldColor,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 14,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                               color: primaryColor,
//                               width: 1.2,
//                             ),
//                           ),
//                         ),
//                         items: examTypes.map((type) {
//                           return DropdownMenuItem<int>(
//                             value: type.examTypeId,
//                             child: Text(
//                               type.examTypeName ?? '',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: isExamTypesLoading || examTypes.isEmpty
//                             ? null
//                             : (value) {
//                                 final selectedType = examTypes.firstWhere(
//                                   (type) => type.examTypeId == value,
//                                 );

//                                 setState(() {
//                                   selectedExamTypeId = value;
//                                   selectedExamTypeName =
//                                       selectedType.examTypeName;
//                                 });
//                               },
//                       ),

//                       const SizedBox(height: 18),

//                       // IS OPEN
//                       InkWell(
//                         onTap: isSaving
//                             ? null
//                             : () {
//                                 setState(() {
//                                   isOpen = !isOpen;
//                                 });
//                               },
//                         borderRadius: BorderRadius.circular(6),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 30,
//                               height: 36,
//                               child: Checkbox(
//                                 value: isOpen,
//                                 activeColor: primaryColor,
//                                 checkColor: Colors.white,
//                                 side: const BorderSide(
//                                   color: Colors.black38,
//                                   width: 1.2,
//                                 ),
//                                 onChanged: isSaving
//                                     ? null
//                                     : (value) {
//                                         setState(() {
//                                           isOpen = value ?? false;
//                                         });
//                                       },
//                               ),
//                             ),
//                             const SizedBox(width: 3),
//                             const Text(
//                               'Is Open',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // PUBLISH
//                       InkWell(
//                         onTap: isSaving
//                             ? null
//                             : () {
//                                 setState(() {
//                                   publish = !publish;
//                                 });
//                               },
//                         borderRadius: BorderRadius.circular(6),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 30,
//                               height: 36,
//                               child: Checkbox(
//                                 value: publish,
//                                 activeColor: primaryColor,
//                                 checkColor: Colors.white,
//                                 side: const BorderSide(
//                                   color: Colors.black38,
//                                   width: 1.2,
//                                 ),
//                                 onChanged: isSaving
//                                     ? null
//                                     : (value) {
//                                         setState(() {
//                                           publish = value ?? false;
//                                         });
//                                       },
//                               ),
//                             ),
//                             const SizedBox(width: 3),
//                             const Text(
//                               'Publish',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // SAVE BUTTON
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
//                 ),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed:
//                         isExamTermsLoading || isExamTypesLoading || isSaving
//                         ? null
//                         : _saveExam,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       foregroundColor: Colors.white,
//                       disabledBackgroundColor: primaryColor.withOpacity(0.6),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: isSaving
//                         ? const SizedBox(
//                             width: 21,
//                             height: 21,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Save',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
import 'package:cristalteacher/features/exam/presentation/cubit/exammanagement_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamScreen extends StatefulWidget {
  /// Pass [examId] (and the other values) to open this screen in edit mode.
  /// Leave them null for the normal "Add Exam" flow.
  final int? examId;
  final String? examName;
  final int? examTermId;
  final int? examTypeId;
  final bool? isOpen;
  final bool? isPublish;

  const AddExamScreen({
    super.key,
    this.examId,
    this.examName,
    this.examTermId,
    this.examTypeId,
    this.isOpen,
    this.isPublish,
  });

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  static const Color primaryColor = Color(0xFF9B73E6);
  static const Color fieldColor = Color(0xFFF0F4FF);

  final TextEditingController examNameController = TextEditingController();

  final List<dynamic> examTerms = [];
  final List<dynamic> examTypes = [];

  int? selectedExamTermId;
  int? selectedExamTypeId;

  String? selectedExamTermName;
  String? selectedExamTypeName;

  bool isExamTermsLoading = true;
  bool isExamTypesLoading = true;
  bool isSaving = false;

  bool isOpen = true;
  bool publish = false;

  /// Edit mode is driven purely by the exam id being passed in.
  bool get isEditMode => widget.examId != null && widget.examId! > 0;

  @override
  void initState() {
    super.initState();

    // Prefill when editing. In add mode these stay at their defaults.
    examNameController.text = widget.examName ?? '';
    selectedExamTermId = widget.examTermId;
    selectedExamTypeId = widget.examTypeId;
    isOpen = widget.isOpen ?? true;
    publish = widget.isPublish ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamManagementCubit>().getExamTerms();
      context.read<ExamManagementCubit>().getExamTypes();
    });
  }

  @override
  void dispose() {
    examNameController.dispose();
    super.dispose();
  }

  void _saveExam() {
    final examName = examNameController.text.trim();

    if (examName.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please enter Exam Name'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    if (selectedExamTermId == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please select Exam Term'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    if (selectedExamTypeId == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please select Exam Type'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    final parameter = SaveExamParameter(
      examName: examName,
      examTermId: selectedExamTermId!,
      examTypeId: selectedExamTypeId!,
      isOpen: isOpen,
      isPublish: publish,
      branchId: AppData.branchId ?? 1,
      createdUser: AppData.userId!,
    );

    if (isEditMode) {
      context.read<ExamManagementCubit>().updateExam(widget.examId!, parameter);
    } else {
      context.read<ExamManagementCubit>().saveExam(parameter);
    }
  }

  @override
  Widget build(BuildContext context) {
    // A DropdownButtonFormField asserts that its `value` matches exactly one
    // item. While the lists are still loading in edit mode the prefilled id
    // has no matching item yet, so hold the value back until it does.
    final int? termDropdownValue =
        examTerms.any((term) => term.examTermId == selectedExamTermId)
        ? selectedExamTermId
        : null;

    final int? typeDropdownValue =
        examTypes.any((type) => type.examTypeId == selectedExamTypeId)
        ? selectedExamTypeId
        : null;

    return MultiBlocListener(
      listeners: [
        BlocListener<ExamManagementCubit, ExamManagementState>(
          listener: (context, state) {
            if (state is ExamTermsLoading) {
              setState(() {
                isExamTermsLoading = true;
              });
            }

            if (state is ExamTermsSuccess) {
              setState(() {
                examTerms
                  ..clear()
                  ..addAll(state.response.data ?? []);

                isExamTermsLoading = false;
              });
            }

            if (state is ExamTermsFailure) {
              setState(() {
                isExamTermsLoading = false;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
        ),

        BlocListener<ExamManagementCubit, ExamManagementState>(
          listener: (context, state) {
            if (state is ExamTypesLoading) {
              setState(() {
                isExamTypesLoading = true;
              });
            }

            if (state is ExamTypesSuccess) {
              setState(() {
                examTypes
                  ..clear()
                  ..addAll(state.response.data ?? []);

                isExamTypesLoading = false;
              });
            }

            if (state is ExamTypesFailure) {
              setState(() {
                isExamTypesLoading = false;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
        ),

        // SAVE EXAM LISTENER
        BlocListener<ExamManagementCubit, ExamManagementState>(
          listener: (context, state) {
            if (state is SaveExamLoading) {
              setState(() {
                isSaving = true;
              });
            }

            if (state is SaveExamSuccess) {
              setState(() {
                isSaving = false;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Exam added successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

              Navigator.pop(context, true);
            }

            if (state is SaveExamFailure) {
              setState(() {
                isSaving = false;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
        ),

        // UPDATE EXAM LISTENER
        BlocListener<ExamManagementCubit, ExamManagementState>(
          listener: (context, state) {
            if (state is UpdateExamLoading) {
              setState(() {
                isSaving = true;
              });
            }

            if (state is UpdateExamSuccess) {
              setState(() {
                isSaving = false;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Exam updated successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

              Navigator.pop(context, true);
            }

            if (state is UpdateExamFailure) {
              setState(() {
                isSaving = false;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
          ),
          title: Text(
            isEditMode ? 'Edit Exam' : 'Add Exam',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // EXAM NAME
                      RichText(
                        text: const TextSpan(
                          text: 'Exam Name',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: examNameController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Exam Name',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                          filled: true,
                          fillColor: fieldColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // EXAM TERM
                      RichText(
                        text: const TextSpan(
                          text: 'Exam Term',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        value: termDropdownValue,
                        isExpanded: true,
                        icon: isExamTermsLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryColor,
                                ),
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.black54,
                              ),
                        decoration: InputDecoration(
                          hintText: isExamTermsLoading
                              ? 'Loading Exam Terms...'
                              : examTerms.isEmpty
                              ? 'No Exam Terms Available'
                              : 'Select Exam Term',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                          filled: true,
                          fillColor: fieldColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.2,
                            ),
                          ),
                        ),
                        items: examTerms.map((term) {
                          return DropdownMenuItem<int>(
                            value: term.examTermId,
                            child: Text(
                              term.examTermName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: isExamTermsLoading || examTerms.isEmpty
                            ? null
                            : (value) {
                                final selectedTerm = examTerms.firstWhere(
                                  (term) => term.examTermId == value,
                                );

                                setState(() {
                                  selectedExamTermId = value;
                                  selectedExamTermName =
                                      selectedTerm.examTermName;
                                });
                              },
                      ),

                      const SizedBox(height: 20),

                      // EXAM TYPE
                      RichText(
                        text: const TextSpan(
                          text: 'Exam Type',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        value: typeDropdownValue,
                        isExpanded: true,
                        icon: isExamTypesLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryColor,
                                ),
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.black54,
                              ),
                        decoration: InputDecoration(
                          hintText: isExamTypesLoading
                              ? 'Loading Exam Types...'
                              : examTypes.isEmpty
                              ? 'No Exam Types Available'
                              : 'Select Exam Type',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                          filled: true,
                          fillColor: fieldColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.2,
                            ),
                          ),
                        ),
                        items: examTypes.map((type) {
                          return DropdownMenuItem<int>(
                            value: type.examTypeId,
                            child: Text(
                              type.examTypeName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: isExamTypesLoading || examTypes.isEmpty
                            ? null
                            : (value) {
                                final selectedType = examTypes.firstWhere(
                                  (type) => type.examTypeId == value,
                                );

                                setState(() {
                                  selectedExamTypeId = value;
                                  selectedExamTypeName =
                                      selectedType.examTypeName;
                                });
                              },
                      ),

                      const SizedBox(height: 18),

                      // IS OPEN
                      InkWell(
                        onTap: isSaving
                            ? null
                            : () {
                                setState(() {
                                  isOpen = !isOpen;
                                });
                              },
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 36,
                              child: Checkbox(
                                value: isOpen,
                                activeColor: primaryColor,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.black38,
                                  width: 1.2,
                                ),
                                onChanged: isSaving
                                    ? null
                                    : (value) {
                                        setState(() {
                                          isOpen = value ?? false;
                                        });
                                      },
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              'Is Open',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // PUBLISH
                      InkWell(
                        onTap: isSaving
                            ? null
                            : () {
                                setState(() {
                                  publish = !publish;
                                });
                              },
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 36,
                              child: Checkbox(
                                value: publish,
                                activeColor: primaryColor,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.black38,
                                  width: 1.2,
                                ),
                                onChanged: isSaving
                                    ? null
                                    : (value) {
                                        setState(() {
                                          publish = value ?? false;
                                        });
                                      },
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              'Publish',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SAVE BUTTON
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        isExamTermsLoading || isExamTypesLoading || isSaving
                        ? null
                        : _saveExam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEditMode ? 'Update' : 'Save',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
