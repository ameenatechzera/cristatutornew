// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/diary/presentation/cubit/diary_cubit.dart';
// import 'package:cristalteacher/features/diary/presentation/screens/creatediarydetails_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Values taken from the diary being edited. Keeps the response entity type
// /// confined to the listener, so nothing else has to know about it.
// class _EditingDiary {
//   final int? standardId;
//   final int? divisionId;
//   final int? subjectId;
//   final String? diaryTitle;
//   final String? description;
//   final String? diaryDate;
//   final String? dueDate;
//   final bool? isFavourite;
//   final List<String> files;

//   const _EditingDiary({
//     required this.standardId,
//     required this.divisionId,
//     required this.subjectId,
//     required this.diaryTitle,
//     required this.description,
//     required this.diaryDate,
//     required this.dueDate,
//     required this.isFavourite,
//     required this.files,
//   });
// }

// class CreateDiaryScreen extends StatefulWidget {
//   final int? diaryId;

//   const CreateDiaryScreen({super.key, this.diaryId});

//   @override
//   State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
// }

// class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
//   int? selectedStandardId;
//   int? selectedDivisionId;
//   int? selectedSubjectId;

//   String? selectedStandard;
//   String? selectedDivision;
//   String? selectedSubject;

//   DateTime? diaryDate;
//   DateTime? dueDate;

//   bool isFavourite = false;

//   List<TutorshipClass> tutorshipClasses = [];
//   List<TutorshipClass> standardList = [];
//   List<DivisionDetails> divisions = [];
//   List<SubjectDetails> subjects = [];

//   /// Diary loaded for editing. Also carries the title, description and
//   /// existing attachments over to the details screen.
//   _EditingDiary? _editingDiary;

//   /// True while fetchDiaryUpdateListing is in flight, so the form is not
//   /// shown with the default (wrong) selection first.
//   bool _isLoadingDiary = false;

//   bool get isEditMode => widget.diaryId != null;

//   List<int> get standardIds {
//     final Set<int> ids = {};

//     for (final TutorshipClass item in standardList) {
//       final int? standardId = item.standardId;

//       if (standardId != null) {
//         ids.add(standardId);
//       }
//     }

//     return ids.toList();
//   }

//   @override
//   void initState() {
//     super.initState();

//     final DateTime today = DateTime.now();

//     diaryDate = DateTime(today.year, today.month, today.day);

//     dueDate = diaryDate!.add(const Duration(days: 1));

//     // Load and automatically select Standard,
//     // Division and Subject from AppData.
//     _loadInitialClassData();

//     // Edit flow. The class data above is already in memory, so the diary
//     // can be applied the moment the API answers.
//     if (isEditMode) {
//       _isLoadingDiary = true;

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;

//         _fetchDiaryForEdit();
//       });
//     }
//   }

//   void _fetchDiaryForEdit() {
//     debugPrint('====================================');
//     debugPrint('OPENING DIARY FOR EDIT');
//     debugPrint('Diary ID: ${widget.diaryId}');
//     debugPrint('====================================');

//     context.read<DiaryCubit>().fetchDiaryUpdateListing(widget.diaryId!);
//   }

//   void _loadInitialClassData() {
//     tutorshipClasses = List<TutorshipClass>.from(AppData.tutorshipClasses);

//     standardList = List<TutorshipClass>.from(
//       AppData.standards.isNotEmpty
//           ? AppData.standards
//           : AppData.tutorshipClasses,
//     );

//     if (tutorshipClasses.isEmpty && standardList.isEmpty) {
//       debugPrint('====================================');
//       debugPrint('NO CLASS DATA FOUND IN APPDATA');
//       debugPrint('====================================');
//       return;
//     }

//     /*
//      * Prefer the first Tutorship Class because it normally
//      * contains the teacher's assigned Standard and Division.
//      *
//      * If Tutorship Class is empty, use the first item from
//      * the complete Standard list.
//      */
//     final TutorshipClass initialTutorship = tutorshipClasses.isNotEmpty
//         ? tutorshipClasses.first
//         : standardList.first;

//     final int? initialStandardId = initialTutorship.standardId;

//     if (initialStandardId == null) {
//       debugPrint('Initial Standard ID is null');
//       return;
//     }

//     TutorshipClass? initialStandard;

//     for (final TutorshipClass item in standardList) {
//       if (item.standardId == initialStandardId) {
//         initialStandard = item;
//         break;
//       }
//     }

//     initialStandard ??= initialTutorship;

//     selectedStandardId = initialStandard.standardId;

//     selectedStandard = initialStandard.standard?.trim();

//     // Load Divisions from the matching Standard.
//     divisions = _divisionsFor(initialStandard);

//     if (divisions.isNotEmpty) {
//       final DivisionDetails initialDivision = divisions.first;

//       selectedDivisionId = initialDivision.divisionId;

//       selectedDivision = initialDivision.division?.trim();

//       subjects = List<SubjectDetails>.from(initialDivision.subject ?? []);

//       if (subjects.isNotEmpty) {
//         final SubjectDetails initialSubject = subjects.first;

//         selectedSubjectId = initialSubject.subjectId;

//         selectedSubject = initialSubject.subject?.trim();
//       }
//     }

//     debugPrint('====================================');
//     debugPrint('INITIAL CLASS VALUES FROM APPDATA');
//     debugPrint(
//       'Standard: $selectedStandard '
//       '($selectedStandardId)',
//     );
//     debugPrint(
//       'Division: $selectedDivision '
//       '($selectedDivisionId)',
//     );
//     debugPrint(
//       'Subject: $selectedSubject '
//       '($selectedSubjectId)',
//     );
//     debugPrint('====================================');
//   }

//   /// Divisions of [standard]. The complete Standard list often carries no
//   /// divisions, so it falls back to the Tutorship Class with the same id.
//   List<DivisionDetails> _divisionsFor(TutorshipClass standard) {
//     final List<DivisionDetails> own = List<DivisionDetails>.from(
//       standard.division ?? [],
//     );

//     if (own.isNotEmpty) {
//       return own;
//     }

//     for (final TutorshipClass item in tutorshipClasses) {
//       if (item.standardId == standard.standardId) {
//         return List<DivisionDetails>.from(item.division ?? []);
//       }
//     }

//     return [];
//   }

//   /// Puts the fetched diary onto the form. Falls back to the first
//   /// available option at each level when the saved id is no longer
//   /// present, so the form is never left in a half-selected state.
//   void _applyEditPrefill(_EditingDiary diary) {
//     final int? diaryStandardId = diary.standardId;

//     TutorshipClass? standard;

//     if (diaryStandardId != null) {
//       standard = _findStandard(diaryStandardId);

//       // The complete Standard list may not hold this class — try the
//       // teacher's own tutorship classes as well.
//       if (standard == null) {
//         for (final TutorshipClass item in tutorshipClasses) {
//           if (item.standardId == diaryStandardId) {
//             standard = item;
//             break;
//           }
//         }
//       }
//     }

//     if (standard == null) {
//       debugPrint('EDIT PREFILL: standard ${diary.standardId} not found');

//       _showMessage('This diary belongs to a class that is not assigned to you');

//       // Dates and favourite are still worth restoring.
//       setState(() {
//         diaryDate = DateTime.tryParse(diary.diaryDate ?? '') ?? diaryDate;
//         dueDate = DateTime.tryParse(diary.dueDate ?? '') ?? dueDate;
//         isFavourite = diary.isFavourite ?? false;
//       });

//       return;
//     }

//     final List<DivisionDetails> newDivisions = _divisionsFor(standard);

//     DivisionDetails? division;

//     for (final DivisionDetails item in newDivisions) {
//       if (item.divisionId == diary.divisionId) {
//         division = item;
//         break;
//       }
//     }

//     division ??= newDivisions.isNotEmpty ? newDivisions.first : null;

//     final List<SubjectDetails> newSubjects = List<SubjectDetails>.from(
//       division?.subject ?? [],
//     );

//     SubjectDetails? subject;

//     for (final SubjectDetails item in newSubjects) {
//       if (item.subjectId == diary.subjectId) {
//         subject = item;
//         break;
//       }
//     }

//     subject ??= newSubjects.isNotEmpty ? newSubjects.first : null;

//     setState(() {
//       selectedStandardId = standard!.standardId;
//       selectedStandard = standard.standard?.trim();

//       divisions = newDivisions;

//       selectedDivisionId = division?.divisionId;
//       selectedDivision = division?.division?.trim();

//       subjects = newSubjects;

//       selectedSubjectId = subject?.subjectId;
//       selectedSubject = subject?.subject?.trim();

//       diaryDate = DateTime.tryParse(diary.diaryDate ?? '') ?? diaryDate;
//       dueDate = DateTime.tryParse(diary.dueDate ?? '') ?? dueDate;

//       isFavourite = diary.isFavourite ?? false;
//     });

//     debugPrint('====================================');
//     debugPrint('EDIT PREFILL APPLIED');
//     debugPrint(
//       'Standard: $selectedStandard '
//       '($selectedStandardId)',
//     );
//     debugPrint(
//       'Division: $selectedDivision '
//       '($selectedDivisionId)',
//     );
//     debugPrint(
//       'Subject: $selectedSubject '
//       '($selectedSubjectId)',
//     );
//     debugPrint('Diary Date: $diaryDate');
//     debugPrint('Due Date  : $dueDate');
//     debugPrint('Favourite : $isFavourite');
//     debugPrint('Files     : ${diary.files.length}');
//     debugPrint('====================================');
//   }

//   TutorshipClass? _findStandard(int standardId) {
//     for (final TutorshipClass item in standardList) {
//       if (item.standardId == standardId) {
//         return item;
//       }
//     }

//     return null;
//   }

//   DivisionDetails? _findDivision(int divisionId) {
//     for (final DivisionDetails item in divisions) {
//       if (item.divisionId == divisionId) {
//         return item;
//       }
//     }

//     return null;
//   }

//   SubjectDetails? _findSubject(int subjectId) {
//     for (final SubjectDetails item in subjects) {
//       if (item.subjectId == subjectId) {
//         return item;
//       }
//     }

//     return null;
//   }

//   String _standardName(int standardId) {
//     final TutorshipClass? standard = _findStandard(standardId);

//     final String name = standard?.standard?.trim() ?? '';

//     if (name.isEmpty) {
//       return 'Standard $standardId';
//     }

//     return name;
//   }

//   void _selectStandard(int? standardId) {
//     if (standardId == null) return;

//     final TutorshipClass? standard = _findStandard(standardId);

//     if (standard == null) {
//       _showMessage('Selected standard was not found');
//       return;
//     }

//     final List<DivisionDetails> newDivisions = _divisionsFor(standard);

//     int? newDivisionId;
//     String? newDivisionName;

//     List<SubjectDetails> newSubjects = [];

//     int? newSubjectId;
//     String? newSubjectName;

//     /*
//      * Automatically select the first Division and Subject
//      * whenever the Standard changes.
//      */
//     if (newDivisions.isNotEmpty) {
//       final DivisionDetails firstDivision = newDivisions.first;

//       newDivisionId = firstDivision.divisionId;
//       newDivisionName = firstDivision.division?.trim();

//       newSubjects = List<SubjectDetails>.from(firstDivision.subject ?? []);

//       if (newSubjects.isNotEmpty) {
//         final SubjectDetails firstSubject = newSubjects.first;

//         newSubjectId = firstSubject.subjectId;
//         newSubjectName = firstSubject.subject?.trim();
//       }
//     }

//     setState(() {
//       selectedStandardId = standard.standardId;

//       selectedStandard = standard.standard?.trim();

//       divisions = newDivisions;

//       selectedDivisionId = newDivisionId;
//       selectedDivision = newDivisionName;

//       subjects = newSubjects;

//       selectedSubjectId = newSubjectId;
//       selectedSubject = newSubjectName;
//     });

//     debugPrint('====================================');
//     debugPrint('STANDARD CHANGED');
//     debugPrint(
//       'Standard: $selectedStandard '
//       '($selectedStandardId)',
//     );
//     debugPrint(
//       'Division: $selectedDivision '
//       '($selectedDivisionId)',
//     );
//     debugPrint(
//       'Subject: $selectedSubject '
//       '($selectedSubjectId)',
//     );
//     debugPrint('====================================');
//   }

//   void _selectDivision(int? divisionId) {
//     if (divisionId == null) return;

//     final DivisionDetails? division = _findDivision(divisionId);

//     if (division == null) {
//       _showMessage('Selected division was not found');
//       return;
//     }

//     final List<SubjectDetails> newSubjects = List<SubjectDetails>.from(
//       division.subject ?? [],
//     );

//     int? newSubjectId;
//     String? newSubjectName;

//     /*
//      * Automatically select the first Subject whenever
//      * the Division changes.
//      */
//     if (newSubjects.isNotEmpty) {
//       final SubjectDetails firstSubject = newSubjects.first;

//       newSubjectId = firstSubject.subjectId;
//       newSubjectName = firstSubject.subject?.trim();
//     }

//     setState(() {
//       selectedDivisionId = division.divisionId;

//       selectedDivision = division.division?.trim();

//       subjects = newSubjects;

//       selectedSubjectId = newSubjectId;
//       selectedSubject = newSubjectName;
//     });

//     debugPrint('====================================');
//     debugPrint('DIVISION CHANGED');
//     debugPrint(
//       'Division: $selectedDivision '
//       '($selectedDivisionId)',
//     );
//     debugPrint(
//       'Subject: $selectedSubject '
//       '($selectedSubjectId)',
//     );
//     debugPrint('====================================');
//   }

//   void _selectSubject(int? subjectId) {
//     if (subjectId == null) return;

//     final SubjectDetails? subject = _findSubject(subjectId);

//     if (subject == null) {
//       _showMessage('Selected subject was not found');
//       return;
//     }

//     setState(() {
//       selectedSubjectId = subject.subjectId;

//       selectedSubject = subject.subject?.trim();
//     });

//     debugPrint('====================================');
//     debugPrint('SUBJECT CHANGED');
//     debugPrint(
//       'Subject: $selectedSubject '
//       '($selectedSubjectId)',
//     );
//     debugPrint('====================================');
//   }

//   Future<void> pickDate({required bool isDiaryDate}) async {
//     final DateTime initialDate = isDiaryDate
//         ? diaryDate ?? DateTime.now()
//         : dueDate ?? diaryDate ?? DateTime.now();

//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2035),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xff9D75E8),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (selectedDate == null || !mounted) {
//       return;
//     }

//     final DateTime selectedDateOnly = DateTime(
//       selectedDate.year,
//       selectedDate.month,
//       selectedDate.day,
//     );

//     if (!isDiaryDate &&
//         diaryDate != null &&
//         selectedDateOnly.isBefore(_dateOnly(diaryDate!))) {
//       _showMessage('Due Date cannot be before Diary Date');
//       return;
//     }

//     setState(() {
//       if (isDiaryDate) {
//         diaryDate = selectedDateOnly;

//         // Automatically set Due Date to the next day.
//         dueDate = selectedDateOnly.add(const Duration(days: 1));
//       } else {
//         dueDate = selectedDateOnly;
//       }
//     });
//   }

//   DateTime _dateOnly(DateTime date) {
//     return DateTime(date.year, date.month, date.day);
//   }

//   String formatDate(DateTime? date, String placeholder) {
//     if (date == null) {
//       return placeholder;
//     }

//     final String day = date.day.toString().padLeft(2, '0');

//     final String month = date.month.toString().padLeft(2, '0');

//     return '$day-$month-${date.year}';
//   }

//   String formatApiDate(DateTime date) {
//     final String month = date.month.toString().padLeft(2, '0');

//     final String day = date.day.toString().padLeft(2, '0');

//     return '${date.year}-$month-$day';
//   }

//   void goNext() {
//     if (selectedStandardId == null ||
//         selectedStandard == null ||
//         selectedStandard!.isEmpty) {
//       _showMessage('Please select Standard');
//       return;
//     }

//     if (selectedDivisionId == null ||
//         selectedDivision == null ||
//         selectedDivision!.isEmpty) {
//       _showMessage('Please select Division');
//       return;
//     }

//     if (selectedSubjectId == null ||
//         selectedSubject == null ||
//         selectedSubject!.isEmpty) {
//       _showMessage('Please select Subject');
//       return;
//     }

//     if (diaryDate == null) {
//       _showMessage('Please select Diary Date');
//       return;
//     }

//     if (dueDate == null) {
//       _showMessage('Please select Due Date');
//       return;
//     }

//     debugPrint('====================================');
//     debugPrint(isEditMode ? 'EDIT DIARY VALUES' : 'CREATE DIARY VALUES');
//     debugPrint(
//       'Standard: $selectedStandard '
//       '($selectedStandardId)',
//     );
//     debugPrint(
//       'Division: $selectedDivision '
//       '($selectedDivisionId)',
//     );
//     debugPrint(
//       'Subject: $selectedSubject '
//       '($selectedSubjectId)',
//     );
//     debugPrint(
//       'Diary Date: '
//       '${formatApiDate(diaryDate!)}',
//     );
//     debugPrint(
//       'Due Date: '
//       '${formatApiDate(dueDate!)}',
//     );
//     debugPrint('Favourite: $isFavourite');
//     debugPrint('Diary ID: ${widget.diaryId}');
//     debugPrint('====================================');

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => SelectYourClassScreen(
//           diaryId: widget.diaryId,
//           standardId: selectedStandardId!,
//           standardName: selectedStandard!,
//           divisionId: selectedDivisionId!,
//           divisionName: selectedDivision!,
//           subjectId: selectedSubjectId!,
//           subjectName: selectedSubject!,
//           diaryDate: diaryDate!,
//           dueDate: dueDate!,
//           isFavourite: isFavourite,

//           // Carried from the diary fetched here, so the details screen
//           // never has to call the API itself.
//           initialTitle: _editingDiary?.diaryTitle ?? '',
//           initialDescription: _editingDiary?.description ?? '',
//           existingFiles: _editingDiary?.files ?? const <String>[],
//         ),
//       ),
//     );
//   }

//   void _showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffFCF8FF),
//       body: SafeArea(
//         child: BlocListener<DiaryCubit, DiaryState>(
//           listenWhen: (previous, current) {
//             return current is FetchDiaryUpdateListingSuccess ||
//                 current is FetchDiaryUpdateListingFailure;
//           },
//           listener: (context, state) {
//             if (state is FetchDiaryUpdateListingSuccess) {
//               // The only place that touches the response entity type.
//               final data = state.response.data;

//               setState(() {
//                 _isLoadingDiary = false;
//               });

//               if (data == null) {
//                 _showMessage('Diary details are not available');
//                 return;
//               }

//               _editingDiary = _EditingDiary(
//                 standardId: data.standardId,
//                 divisionId: data.divisionId,
//                 subjectId: data.subjectId,
//                 diaryTitle: data.diaryTitle,
//                 description: data.description,
//                 diaryDate: data.diaryDate,
//                 dueDate: data.dueDate,
//                 isFavourite: data.isFavourite,
//                 files: List<String>.from(data.files ?? const []),
//               );

//               _applyEditPrefill(_editingDiary!);
//             }

//             if (state is FetchDiaryUpdateListingFailure) {
//               setState(() {
//                 _isLoadingDiary = false;
//               });

//               _showMessage(state.message);
//             }
//           },
//           child: Column(
//             children: [
//               _TopBar(isEditMode: isEditMode),
//               Expanded(
//                 child: standardList.isEmpty
//                     ? const _NoClassDataView()
//                     : _isLoadingDiary
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: Color(0xff9D75E8),
//                         ),
//                       )
//                     : _buildForm(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomDropdownField<int>(
//             hint: 'Standard',
//             value: selectedStandardId,
//             items: standardIds.map((int standardId) {
//               return DropdownMenuItem<int>(
//                 value: standardId,
//                 child: Text(_standardName(standardId)),
//               );
//             }).toList(),
//             onChanged: _selectStandard,
//           ),
//           const SizedBox(height: 20),
//           CustomDropdownField<int>(
//             hint: 'Division',
//             value: selectedDivisionId,
//             items: divisions
//                 .where((DivisionDetails item) => item.divisionId != null)
//                 .map((DivisionDetails item) {
//                   return DropdownMenuItem<int>(
//                     value: item.divisionId,
//                     child: Text(item.division ?? ''),
//                   );
//                 })
//                 .toList(),
//             onChanged: selectedStandardId == null ? null : _selectDivision,
//           ),
//           const SizedBox(height: 20),
//           CustomDropdownField<int>(
//             hint: 'Subject',
//             value: selectedSubjectId,
//             items: subjects
//                 .where((SubjectDetails item) => item.subjectId != null)
//                 .map((SubjectDetails item) {
//                   return DropdownMenuItem<int>(
//                     value: item.subjectId,
//                     child: Text(item.subject ?? ''),
//                   );
//                 })
//                 .toList(),
//             onChanged: selectedDivisionId == null ? null : _selectSubject,
//           ),
//           const SizedBox(height: 26),
//           const Text(
//             'Expiry Date',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w800,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 14),
//           CustomDateField(
//             text: formatDate(diaryDate, 'Diary Date'),
//             onTap: () {
//               pickDate(isDiaryDate: true);
//             },
//           ),
//           const SizedBox(height: 20),
//           CustomDateField(
//             text: formatDate(dueDate, 'Due Date'),
//             onTap: () {
//               pickDate(isDiaryDate: false);
//             },
//           ),
//           const SizedBox(height: 28),
//           InkWell(
//             onTap: () {
//               setState(() {
//                 isFavourite = !isFavourite;
//               });
//             },
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               height: 58,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xffEEF3FC),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
//               ),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     value: isFavourite,
//                     activeColor: const Color(0xff9D75E8),
//                     checkColor: Colors.white,
//                     side: const BorderSide(
//                       color: Color(0xff5F6368),
//                       width: 1.5,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isFavourite = value ?? false;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 2),
//                   const Expanded(
//                     child: Text(
//                       'Is Favourite',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 112),
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: ElevatedButton(
//               onPressed: goNext,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xff9D75E8),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//               ),
//               child: const Text(
//                 'Next',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TopBar extends StatelessWidget {
//   final bool isEditMode;

//   const _TopBar({required this.isEditMode});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 64,
//       color: const Color(0xffFCF8FF),
//       padding: const EdgeInsets.symmetric(horizontal: 22),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.maybePop(context);
//             },
//             child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 isEditMode ? 'Edit Diary' : 'Create Diary',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xff222222),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 24),
//         ],
//       ),
//     );
//   }
// }

// /// Dropdown-style field in this screen's look: 58px, #EEF3FC fill, grey
// /// outline. Only the option sheet is shared — screens with a different
// /// field style write their own and call [showOptionPickerSheet] the same way.
// class CustomDropdownField<T> extends StatelessWidget {
//   final String hint;
//   final T? value;
//   final List<DropdownMenuItem<T>> items;
//   final ValueChanged<T?>? onChanged;

//   const CustomDropdownField({
//     super.key,
//     required this.hint,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   bool get _isEnabled => onChanged != null && items.isNotEmpty;

//   Future<void> _openPicker(BuildContext context) async {
//     if (!_isEnabled) return;

//     final PickerSelection<T>? picked = await showOptionPickerSheet<T>(
//       context: context,
//       title: 'Select $hint',
//       items: items,
//       selectedValue: value,
//     );

//     if (picked == null) return;

//     onChanged!(picked.value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Null when the saved value is no longer in the list, which falls back
//     // to showing the hint.
//     final DropdownMenuItem<T>? selected = selectedItemOf(items, value);

//     final Color textColor = _isEnabled ? Colors.black : Colors.grey;

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         _openPicker(context);
//       },
//       child: Container(
//         height: 58,
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xffEEF3FC),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: selected == null
//                   ? Text(
//                       hint,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     )
//                   : DefaultTextStyle(
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       child: selected.child,
//                     ),
//             ),
//             Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: _isEnabled ? const Color(0xff5F6368) : Colors.grey,
//               size: 24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomDateField extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;

//   const CustomDateField({super.key, required this.text, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 58,
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xffEEF3FC),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             const Icon(
//               Icons.calendar_month,
//               size: 22,
//               color: Color(0xff5F6368),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NoClassDataView extends StatelessWidget {
//   const _NoClassDataView();

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Text(
//           'Class data is not available',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 13, color: Colors.red),
//         ),
//       ),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/diary/presentation/cubit/diary_cubit.dart';
import 'package:cristalteacher/features/diary/presentation/screens/creatediarydetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Values taken from the diary being edited. Keeps the response entity type
/// confined to the listener, so nothing else has to know about it.
class _EditingDiary {
  final int? standardId;
  final int? divisionId;
  final int? subjectId;
  final String? diaryTitle;
  final String? description;
  final String? diaryDate;
  final String? dueDate;
  final bool? isFavourite;
  final List<String> files;

  const _EditingDiary({
    required this.standardId,
    required this.divisionId,
    required this.subjectId,
    required this.diaryTitle,
    required this.description,
    required this.diaryDate,
    required this.dueDate,
    required this.isFavourite,
    required this.files,
  });
}

class CreateDiaryScreen extends StatefulWidget {
  final int? diaryId;

  const CreateDiaryScreen({super.key, this.diaryId});

  @override
  State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  int? selectedSubjectId;

  String? selectedSubject;

  /// Standard + Division pairs ticked in the class grid. Every entry holds
  /// standardId, standardName, divisionId and divisionName.
  final List<Map<String, dynamic>> selectedClasses = [];

  DateTime? diaryDate;
  DateTime? dueDate;

  bool isFavourite = false;

  List<TutorshipClass> tutorshipClasses = [];
  List<TutorshipClass> standardList = [];
  List<SubjectDetails> subjects = [];

  /// Diary loaded for editing. Also carries the title, description and
  /// existing attachments over to the details screen.
  _EditingDiary? _editingDiary;

  /// True while fetchDiaryUpdateListing is in flight, so the form is not
  /// shown with the default (wrong) selection first.
  bool _isLoadingDiary = false;

  bool get isEditMode => widget.diaryId != null;

  /// Every Standard + Division pair the teacher can post a diary to. One
  /// checkbox is drawn per entry.
  List<Map<String, dynamic>> get classList {
    final List<Map<String, dynamic>> items = [];

    final Set<String> added = {};

    for (final TutorshipClass standard in standardList) {
      final int? standardId = standard.standardId;

      if (standardId == null) continue;

      for (final DivisionDetails division in _divisionsFor(standard)) {
        final int? divisionId = division.divisionId;

        if (divisionId == null) continue;

        if (!added.add('$standardId-$divisionId')) continue;

        items.add({
          'standardId': standardId,
          'standardName': _standardName(standardId),
          'divisionId': divisionId,
          'divisionName': division.division?.trim() ?? '',
        });
      }
    }

    return items;
  }

  bool _isClassSelected(int standardId, int divisionId) {
    return selectedClasses.any(
      (item) =>
          item['standardId'] == standardId && item['divisionId'] == divisionId,
    );
  }

  /// Subjects of every Division available to the teacher, de-duplicated by
  /// subjectId. The Subject field no longer depends on a Division being
  /// picked, so the list is built once.
  List<SubjectDetails> _allSubjects() {
    final Map<int, SubjectDetails> unique = {};

    for (final TutorshipClass standard in standardList) {
      for (final DivisionDetails division in _divisionsFor(standard)) {
        for (final SubjectDetails subject
            in division.subject ?? <SubjectDetails>[]) {
          final int? subjectId = subject.subjectId;

          if (subjectId != null) {
            unique[subjectId] = subject;
          }
        }
      }
    }

    return unique.values.toList();
  }

  @override
  void initState() {
    super.initState();

    final DateTime today = DateTime.now();

    diaryDate = DateTime(today.year, today.month, today.day);

    dueDate = diaryDate!.add(const Duration(days: 1));

    // Load and automatically select Standard,
    // Division and Subject from AppData.
    _loadInitialClassData();

    // Edit flow. The class data above is already in memory, so the diary
    // can be applied the moment the API answers.
    if (isEditMode) {
      _isLoadingDiary = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _fetchDiaryForEdit();
      });
    }
  }

  void _fetchDiaryForEdit() {
    debugPrint('====================================');
    debugPrint('OPENING DIARY FOR EDIT');
    debugPrint('Diary ID: ${widget.diaryId}');
    debugPrint('====================================');

    context.read<DiaryCubit>().fetchDiaryUpdateListing(widget.diaryId!);
  }

  void _loadInitialClassData() {
    tutorshipClasses = List<TutorshipClass>.from(AppData.tutorshipClasses);

    standardList = List<TutorshipClass>.from(
      AppData.standards.isNotEmpty
          ? AppData.standards
          : AppData.tutorshipClasses,
    );

    if (tutorshipClasses.isEmpty && standardList.isEmpty) {
      debugPrint('====================================');
      debugPrint('NO CLASS DATA FOUND IN APPDATA');
      debugPrint('====================================');
      return;
    }

    /*
     * Prefer the first Tutorship Class because it normally
     * contains the teacher's assigned Standard and Division.
     *
     * If Tutorship Class is empty, use the first item from
     * the complete Standard list.
     */
    final TutorshipClass initialTutorship = tutorshipClasses.isNotEmpty
        ? tutorshipClasses.first
        : standardList.first;

    final int? initialStandardId = initialTutorship.standardId;

    if (initialStandardId == null) {
      debugPrint('Initial Standard ID is null');
      return;
    }

    TutorshipClass? initialStandard;

    for (final TutorshipClass item in standardList) {
      if (item.standardId == initialStandardId) {
        initialStandard = item;
        break;
      }
    }

    initialStandard ??= initialTutorship;

    subjects = _allSubjects();

    if (subjects.isNotEmpty) {
      final SubjectDetails initialSubject = subjects.first;

      selectedSubjectId = initialSubject.subjectId;

      selectedSubject = initialSubject.subject?.trim();
    }

    // Tick the teacher's own class by default.
    final List<DivisionDetails> initialDivisions = _divisionsFor(
      initialStandard,
    );

    if (initialDivisions.isNotEmpty) {
      final DivisionDetails initialDivision = initialDivisions.first;

      final int? initialDivisionId = initialDivision.divisionId;

      if (initialDivisionId != null) {
        selectedClasses.add({
          'standardId': initialStandardId,
          'standardName': initialStandard.standard?.trim() ?? '',
          'divisionId': initialDivisionId,
          'divisionName': initialDivision.division?.trim() ?? '',
        });
      }
    }

    debugPrint('====================================');
    debugPrint('INITIAL CLASS VALUES FROM APPDATA');
    debugPrint('Classes: $selectedClasses');
    debugPrint(
      'Subject: $selectedSubject '
      '($selectedSubjectId)',
    );
    debugPrint('====================================');
  }

  /// Divisions of [standard]. The complete Standard list often carries no
  /// divisions, so it falls back to the Tutorship Class with the same id.
  List<DivisionDetails> _divisionsFor(TutorshipClass standard) {
    final List<DivisionDetails> own = List<DivisionDetails>.from(
      standard.division ?? [],
    );

    if (own.isNotEmpty) {
      return own;
    }

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId == standard.standardId) {
        return List<DivisionDetails>.from(item.division ?? []);
      }
    }

    return [];
  }

  /// Puts the fetched diary onto the form. Falls back to the first
  /// available option at each level when the saved id is no longer
  /// present, so the form is never left in a half-selected state.
  void _applyEditPrefill(_EditingDiary diary) {
    final int? diaryStandardId = diary.standardId;

    TutorshipClass? standard;

    if (diaryStandardId != null) {
      standard = _findStandard(diaryStandardId);

      // The complete Standard list may not hold this class — try the
      // teacher's own tutorship classes as well.
      if (standard == null) {
        for (final TutorshipClass item in tutorshipClasses) {
          if (item.standardId == diaryStandardId) {
            standard = item;
            break;
          }
        }
      }
    }

    if (standard == null) {
      debugPrint('EDIT PREFILL: standard ${diary.standardId} not found');

      _showMessage('This diary belongs to a class that is not assigned to you');

      // Dates and favourite are still worth restoring.
      setState(() {
        diaryDate = DateTime.tryParse(diary.diaryDate ?? '') ?? diaryDate;
        dueDate = DateTime.tryParse(diary.dueDate ?? '') ?? dueDate;
        isFavourite = diary.isFavourite ?? false;
      });

      return;
    }

    final List<DivisionDetails> newDivisions = _divisionsFor(standard);

    DivisionDetails? division;

    for (final DivisionDetails item in newDivisions) {
      if (item.divisionId == diary.divisionId) {
        division = item;
        break;
      }
    }

    division ??= newDivisions.isNotEmpty ? newDivisions.first : null;

    SubjectDetails? subject;

    for (final SubjectDetails item in subjects) {
      if (item.subjectId == diary.subjectId) {
        subject = item;
        break;
      }
    }

    subject ??= subjects.isNotEmpty ? subjects.first : null;

    // The class this diary belongs to. Null when the saved division is no
    // longer available, which simply leaves the grid unticked.
    final Map<String, dynamic>? diaryClass = division?.divisionId == null
        ? null
        : {
            'standardId': standard.standardId,
            'standardName': standard.standard?.trim() ?? '',
            'divisionId': division!.divisionId,
            'divisionName': division.division?.trim() ?? '',
          };

    setState(() {
      // Only the class this diary belongs to stays ticked.
      selectedClasses.clear();

      if (diaryClass != null) {
        selectedClasses.add(diaryClass);
      }

      selectedSubjectId = subject?.subjectId;
      selectedSubject = subject?.subject?.trim();

      diaryDate = DateTime.tryParse(diary.diaryDate ?? '') ?? diaryDate;
      dueDate = DateTime.tryParse(diary.dueDate ?? '') ?? dueDate;

      isFavourite = diary.isFavourite ?? false;
    });

    debugPrint('====================================');
    debugPrint('EDIT PREFILL APPLIED');
    debugPrint('Classes: $selectedClasses');
    debugPrint(
      'Subject: $selectedSubject '
      '($selectedSubjectId)',
    );
    debugPrint('Diary Date: $diaryDate');
    debugPrint('Due Date  : $dueDate');
    debugPrint('Favourite : $isFavourite');
    debugPrint('Files     : ${diary.files.length}');
    debugPrint('====================================');
  }

  TutorshipClass? _findStandard(int standardId) {
    for (final TutorshipClass item in standardList) {
      if (item.standardId == standardId) {
        return item;
      }
    }

    return null;
  }

  SubjectDetails? _findSubject(int subjectId) {
    for (final SubjectDetails item in subjects) {
      if (item.subjectId == subjectId) {
        return item;
      }
    }

    return null;
  }

  String _standardName(int standardId) {
    final TutorshipClass? standard = _findStandard(standardId);

    final String name = standard?.standard?.trim() ?? '';

    if (name.isEmpty) {
      return 'Standard $standardId';
    }

    return name;
  }

  void _selectSubject(int? subjectId) {
    if (subjectId == null) return;

    final SubjectDetails? subject = _findSubject(subjectId);

    if (subject == null) {
      _showMessage('Selected subject was not found');
      return;
    }

    setState(() {
      selectedSubjectId = subject.subjectId;

      selectedSubject = subject.subject?.trim();
    });

    debugPrint('====================================');
    debugPrint('SUBJECT CHANGED');
    debugPrint(
      'Subject: $selectedSubject '
      '($selectedSubjectId)',
    );
    debugPrint('====================================');
  }

  Future<void> pickDate({required bool isDiaryDate}) async {
    final DateTime initialDate = isDiaryDate
        ? diaryDate ?? DateTime.now()
        : dueDate ?? diaryDate ?? DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff9D75E8),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    final DateTime selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (!isDiaryDate &&
        diaryDate != null &&
        selectedDateOnly.isBefore(_dateOnly(diaryDate!))) {
      _showMessage('Due Date cannot be before Diary Date');
      return;
    }

    setState(() {
      if (isDiaryDate) {
        diaryDate = selectedDateOnly;

        // Automatically set Due Date to the next day.
        dueDate = selectedDateOnly.add(const Duration(days: 1));
      } else {
        dueDate = selectedDateOnly;
      }
    });
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String formatDate(DateTime? date, String placeholder) {
    if (date == null) {
      return placeholder;
    }

    final String day = date.day.toString().padLeft(2, '0');

    final String month = date.month.toString().padLeft(2, '0');

    return '$day-$month-${date.year}';
  }

  String formatApiDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');

    final String day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  void goNext() {
    if (selectedClasses.isEmpty) {
      _showMessage('Please select at least one class');
      return;
    }

    if (selectedSubjectId == null ||
        selectedSubject == null ||
        selectedSubject!.isEmpty) {
      _showMessage('Please select Subject');
      return;
    }

    if (diaryDate == null) {
      _showMessage('Please select Diary Date');
      return;
    }

    if (dueDate == null) {
      _showMessage('Please select Due Date');
      return;
    }

    final Map<String, dynamic> firstSelectedClass = selectedClasses.first;

    debugPrint('====================================');
    debugPrint(isEditMode ? 'EDIT DIARY VALUES' : 'CREATE DIARY VALUES');
    debugPrint('Classes: $selectedClasses');
    debugPrint(
      'Subject: $selectedSubject '
      '($selectedSubjectId)',
    );
    debugPrint(
      'Diary Date: '
      '${formatApiDate(diaryDate!)}',
    );
    debugPrint(
      'Due Date: '
      '${formatApiDate(dueDate!)}',
    );
    debugPrint('Favourite: $isFavourite');
    debugPrint('Diary ID: ${widget.diaryId}');
    debugPrint('====================================');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectYourClassScreen(
          diaryId: widget.diaryId,
          standardId: firstSelectedClass['standardId'] as int,
          standardName: firstSelectedClass['standardName'] as String,
          divisionId: firstSelectedClass['divisionId'] as int,
          divisionName: firstSelectedClass['divisionName'] as String,
          subjectId: selectedSubjectId!,
          subjectName: selectedSubject!,
          diaryDate: diaryDate!,
          dueDate: dueDate!,
          isFavourite: isFavourite,

          // Carried from the diary fetched here, so the details screen
          // never has to call the API itself.
          initialTitle: _editingDiary?.diaryTitle ?? '',
          initialDescription: _editingDiary?.description ?? '',
          existingFiles: _editingDiary?.files ?? const <String>[],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF8FF),
      body: SafeArea(
        child: BlocListener<DiaryCubit, DiaryState>(
          listenWhen: (previous, current) {
            return current is FetchDiaryUpdateListingSuccess ||
                current is FetchDiaryUpdateListingFailure;
          },
          listener: (context, state) {
            if (state is FetchDiaryUpdateListingSuccess) {
              // The only place that touches the response entity type.
              final data = state.response.data;

              setState(() {
                _isLoadingDiary = false;
              });

              if (data == null) {
                _showMessage('Diary details are not available');
                return;
              }

              _editingDiary = _EditingDiary(
                standardId: data.standardId,
                divisionId: data.divisionId,
                subjectId: data.subjectId,
                diaryTitle: data.diaryTitle,
                description: data.description,
                diaryDate: data.diaryDate,
                dueDate: data.dueDate,
                isFavourite: data.isFavourite,
                files: List<String>.from(data.files ?? const []),
              );

              _applyEditPrefill(_editingDiary!);
            }

            if (state is FetchDiaryUpdateListingFailure) {
              setState(() {
                _isLoadingDiary = false;
              });

              _showMessage(state.message);
            }
          },
          child: Column(
            children: [
              _TopBar(isEditMode: isEditMode),
              Expanded(
                child: standardList.isEmpty
                    ? const _NoClassDataView()
                    : _isLoadingDiary
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff9D75E8),
                        ),
                      )
                    : _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCheckboxes() {
    final List<Map<String, dynamic>> items = classList;

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No classes found',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 46,
        crossAxisSpacing: 18,
      ),
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = items[index];

        final int standardId = item['standardId'] as int;
        final int divisionId = item['divisionId'] as int;

        final String standardName = item['standardName'] as String;
        final String divisionName = item['divisionName'] as String;

        final bool isSelected = _isClassSelected(standardId, divisionId);

        return Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: isSelected,
                activeColor: const Color(0xff9D75E8),
                checkColor: Colors.white,
                side: const BorderSide(color: Color(0xff5F6368), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedClasses.add(item);
                    } else {
                      selectedClasses.removeWhere(
                        (selected) =>
                            selected['standardId'] == standardId &&
                            selected['divisionId'] == divisionId,
                      );
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$standardName $divisionName'.trim(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xff9D75E8) : Colors.black87,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdownField<int>(
            hint: 'Subject',
            value: selectedSubjectId,
            items: subjects
                .where((SubjectDetails item) => item.subjectId != null)
                .map((SubjectDetails item) {
                  return DropdownMenuItem<int>(
                    value: item.subjectId,
                    child: Text(item.subject ?? ''),
                  );
                })
                .toList(),
            onChanged: _selectSubject,
          ),
          const SizedBox(height: 26),
          const Text(
            'Expiry Date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          CustomDateField(
            text: formatDate(diaryDate, 'Diary Date'),
            onTap: () {
              pickDate(isDiaryDate: true);
            },
          ),
          const SizedBox(height: 20),
          CustomDateField(
            text: formatDate(dueDate, 'Due Date'),
            onTap: () {
              pickDate(isDiaryDate: false);
            },
          ),
          const SizedBox(height: 28),
          InkWell(
            onTap: () {
              setState(() {
                isFavourite = !isFavourite;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xffEEF3FC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isFavourite,
                    activeColor: const Color(0xff9D75E8),
                    checkColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xff5F6368),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        isFavourite = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 2),
                  const Expanded(
                    child: Text(
                      'Is Favourite',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Select Your Classes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          _buildClassCheckboxes(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: goNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff9D75E8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool isEditMode;

  const _TopBar({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: const Color(0xffFCF8FF),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.maybePop(context);
            },
            child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
          Expanded(
            child: Center(
              child: Text(
                isEditMode ? 'Edit Diary' : 'Create Diary',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff222222),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

/// Dropdown-style field in this screen's look: 58px, #EEF3FC fill, grey
/// outline. Only the option sheet is shared — screens with a different
/// field style write their own and call [showOptionPickerSheet] the same way.
class CustomDropdownField<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  bool get _isEnabled => onChanged != null && items.isNotEmpty;

  Future<void> _openPicker(BuildContext context) async {
    if (!_isEnabled) return;

    final PickerSelection<T>? picked = await showOptionPickerSheet<T>(
      context: context,
      title: 'Select $hint',
      items: items,
      selectedValue: value,
    );

    if (picked == null) return;

    onChanged!(picked.value);
  }

  @override
  Widget build(BuildContext context) {
    // Null when the saved value is no longer in the list, which falls back
    // to showing the hint.
    final DropdownMenuItem<T>? selected = selectedItemOf(items, value);

    final Color textColor = _isEnabled ? Colors.black : Colors.grey;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _openPicker(context);
      },
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xffEEF3FC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
        ),
        child: Row(
          children: [
            Expanded(
              child: selected == null
                  ? Text(
                      hint,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    )
                  : DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: selected.child,
                    ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _isEnabled ? const Color(0xff5F6368) : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomDateField({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xffEEF3FC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_month,
              size: 22,
              color: Color(0xff5F6368),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoClassDataView extends StatelessWidget {
  const _NoClassDataView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Class data is not available',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.red),
        ),
      ),
    );
  }
}
