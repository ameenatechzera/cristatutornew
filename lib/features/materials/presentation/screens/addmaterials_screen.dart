// // import 'dart:io';
// // import 'dart:ui';

// // import 'package:cristalteacher/core/appdata/appdata.dart';
// // import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// // import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// // import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// // import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
// // import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
// // import 'package:file_picker/file_picker.dart';

// // // Change these imports if your material folder path is different.

// // import 'package:flutter/material.dart' hide MaterialState;
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class AddMaterialPage extends StatefulWidget {
// //   const AddMaterialPage({super.key});

// //   @override
// //   State<AddMaterialPage> createState() => _AddMaterialPageState();
// // }

// // class _AddMaterialPageState extends State<AddMaterialPage> {
// //   static const Color primaryColor = Color(0xFF9B73E6);
// //   static const Color fieldColor = Color(0xFFF0F4FF);
// //   static const Color darkColor = Colors.black;
// //   static const int maxUploadSizeBytes = 5 * 1024 * 1024;

// //   int selectedTab = 0;
// //   File? selectedFile;

// //   final List<String> tabs = const ['Documents', 'Links', 'Notes'];

// //   final TextEditingController linkController = TextEditingController();
// //   final TextEditingController notesController = TextEditingController();

// //   List<TutorshipClass> tutorshipClasses = [];
// //   List<DivisionDetails> divisions = [];
// //   List<SubjectDetails> subjects = [];

// //   int? selectedStandardId;
// //   int? selectedDivisionId;
// //   int? selectedSubjectId;

// //   String? selectedStandard;
// //   String? selectedDivision;
// //   String? selectedSubject;

// //   // Connect these with FilePicker when uploading is implemented.
// //   String? selectedFileName;
// //   String? selectedFilePath;

// //   final List<Map<String, dynamic>> selectedClasses = [];
// //   String _formatFileSize(int bytes) {
// //     return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
// //   }

// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _fetchTutorshipClasses();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     linkController.dispose();
// //     notesController.dispose();
// //     super.dispose();
// //   }

// //   void _fetchTutorshipClasses() {
// //     context.read<AuthenticationCubit>().fetchTutorshipClass(
// //       FetchTutorshipClassRequest(
// //         accyear: AppData.accYear,
// //         employeeId: AppData.employeeId,
// //         userId: AppData.userId,
// //       ),
// //     );
// //   }

// //   List<TutorshipClass> get standards {
// //     final Map<int, TutorshipClass> uniqueStandards = {};

// //     for (final TutorshipClass item in tutorshipClasses) {
// //       final int? standardId = item.standardId;

// //       if (standardId != null) {
// //         uniqueStandards[standardId] = item;
// //       }
// //     }

// //     return uniqueStandards.values.toList();
// //   }

// //   List<Map<String, dynamic>> get classList {
// //     final List<Map<String, dynamic>> items = [];

// //     for (final TutorshipClass standard in tutorshipClasses) {
// //       final int? standardId = standard.standardId;

// //       if (standardId == null) continue;

// //       for (final DivisionDetails division
// //           in standard.division ?? <DivisionDetails>[]) {
// //         if (division.divisionId == null) continue;

// //         items.add({
// //           'standardId': standardId,
// //           'standardName': standard.standard,
// //           'division': division,
// //         });
// //       }
// //     }

// //     return items;
// //   }

// //   void _selectStandard(int? standardId) {
// //     if (standardId == null) return;

// //     final TutorshipClass standard = tutorshipClasses.firstWhere(
// //       (item) => item.standardId == standardId,
// //     );

// //     setState(() {
// //       selectedStandardId = standard.standardId;
// //       selectedStandard = standard.standard;

// //       divisions = standard.division ?? [];
// //       subjects = [];

// //       selectedDivisionId = null;
// //       selectedDivision = null;

// //       selectedSubjectId = null;
// //       selectedSubject = null;
// //     });
// //   }

// //   void _selectDivision(int? divisionId) {
// //     if (divisionId == null) return;

// //     final DivisionDetails division = divisions.firstWhere(
// //       (item) => item.divisionId == divisionId,
// //     );

// //     setState(() {
// //       selectedDivisionId = division.divisionId;
// //       selectedDivision = division.division;

// //       subjects = division.subject ?? [];

// //       selectedSubjectId = null;
// //       selectedSubject = null;
// //     });
// //   }

// //   void _selectSubject(int? subjectId) {
// //     if (subjectId == null) return;

// //     final SubjectDetails subject = subjects.firstWhere(
// //       (item) => item.subjectId == subjectId,
// //     );

// //     setState(() {
// //       selectedSubjectId = subject.subjectId;
// //       selectedSubject = subject.subject;
// //     });
// //   }

// //   Future<void> _chooseFile() async {
// //     try {
// //       FocusScope.of(context).unfocus();

// //       final FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
// //         allowMultiple: false,
// //         withData: false,
// //       );

// //       // The user closed the picker.
// //       if (result == null || result.files.isEmpty) {
// //         return;
// //       }

// //       final PlatformFile pickedFile = result.files.first;
// //       final String? filePath = pickedFile.path;

// //       if (filePath == null || filePath.isEmpty) {
// //         _showMessage('Unable to access the selected file');
// //         return;
// //       }

// //       final File file = File(filePath);

// //       if (!await file.exists()) {
// //         _showMessage('The selected file is no longer available');
// //         return;
// //       }

// //       final int fileSize = await file.length();

// //       if (fileSize > maxUploadSizeBytes) {
// //         _showMessage(
// //           '${pickedFile.name} is ${_formatFileSize(fileSize)}. '
// //           'Please select a file below 5 MB.',
// //         );
// //         return;
// //       }

// //       if (!mounted) return;

// //       setState(() {
// //         selectedFile = file;
// //         selectedFileName = pickedFile.name;
// //         selectedFilePath = filePath;
// //       });

// //       debugPrint('Selected filename: ${pickedFile.name}');
// //       debugPrint('Selected file path: $filePath');
// //       debugPrint('Selected file size: ${_formatFileSize(fileSize)}');
// //     } catch (error, stackTrace) {
// //       debugPrint('FilePicker error: $error');
// //       debugPrintStack(stackTrace: stackTrace);

// //       if (!mounted) return;

// //       _showMessage('Unable to select the file: $error');
// //     }
// //   }

// //   String get _selectedNotes =>
// //       selectedTab == 2 ? notesController.text.trim() : '';

// //   Future<void> _saveMaterial() async {
// //     FocusScope.of(context).unfocus();

// //     final String? accYear = AppData.accYear;
// //     final int? employeeId = AppData.employeeId;
// //     final int? branchId = AppData.branchId;
// //     final int? userId = AppData.userId;
// //     final File? uploadFile = selectedFile;

// //     if (accYear == null || accYear.trim().isEmpty) {
// //       _showMessage('Academic year is unavailable');
// //       return;
// //     }

// //     if (employeeId == null) {
// //       _showMessage('Employee ID is unavailable');
// //       return;
// //     }

// //     // if (branchId == null) {
// //     //   _showMessage('Branch ID is unavailable');
// //     //   return;
// //     // }

// //     if (userId == null) {
// //       _showMessage('User ID is unavailable');
// //       return;
// //     }

// //     if (selectedStandardId == null) {
// //       _showMessage('Please select Standard');
// //       return;
// //     }

// //     if (selectedDivisionId == null) {
// //       _showMessage('Please select Division');
// //       return;
// //     }

// //     if (selectedSubjectId == null) {
// //       _showMessage('Please select Subject');
// //       return;
// //     }

// //     if (selectedTab == 0) {
// //       if (uploadFile == null) {
// //         _showMessage('Please choose a file');
// //         return;
// //       }

// //       if (!await uploadFile.exists()) {
// //         if (!mounted) return;

// //         setState(() {
// //           selectedFile = null;
// //           selectedFileName = null;
// //           selectedFilePath = null;
// //         });

// //         _showMessage(
// //           'The selected file is unavailable. Please choose it again.',
// //         );
// //         return;
// //       }

// //       final int fileSize = await uploadFile.length();

// //       if (fileSize > maxUploadSizeBytes) {
// //         _showMessage(
// //           'The selected file is ${_formatFileSize(fileSize)}. '
// //           'Please select a file below 5 MB.',
// //         );
// //         return;
// //       }
// //     }

// //     if (selectedTab == 1) {
// //       final String link = linkController.text.trim();

// //       if (link.isEmpty) {
// //         _showMessage('Please enter a link');
// //         return;
// //       }

// //       final Uri? uri = Uri.tryParse(link);

// //       if (uri == null ||
// //           !uri.hasScheme ||
// //           (uri.scheme != 'http' && uri.scheme != 'https')) {
// //         _showMessage(
// //           'Please enter a valid link starting with http:// or https://',
// //         );
// //         return;
// //       }
// //     }

// //     if (selectedTab == 2 && notesController.text.trim().isEmpty) {
// //       _showMessage('Please enter a note');
// //       return;
// //     }

// //     if (!mounted) return;

// //     // context.read<MaterialCubit>().saveMaterial(
// //     //   SaveMaterialParameter(
// //     //     materials: selectedTab == 0 && uploadFile != null
// //     //         ? <File>[uploadFile]
// //     //         : <File>[],
// //     //     staffId: employeeId,
// //     //     accYear: accYear,
// //     //     // standardId: selectedStandardId!,
// //     //     // divisionId: selectedDivisionId!,
// //     //     subjectId: selectedSubjectId!,
// //     //     branchId: 1,
// //     //     createdUser: userId.toString(),
// //     //     documentName: selectedTab == 0
// //     //         ? selectedFileName ?? ''
// //     //         : selectedTab == 1
// //     //         ? 'Link Material'
// //     //         : 'Note Material',
// //     //     notes: _selectedNotes,
// //     //     link: selectedTab == 1 ? linkController.text.trim() : '',
// //     //     favorite: false, standardDivisionList: [],
// //     //   ),
// //     // );
// //     context.read<MaterialCubit>().saveMaterial(
// //       SaveMaterialParameter(
// //         materials: selectedTab == 0 && uploadFile != null
// //             ? <File>[uploadFile]
// //             : <File>[],
// //         staffId: employeeId,
// //         accYear: accYear,
// //         subjectId: selectedSubjectId!,
// //         branchId: 1,
// //         createdUser: userId.toString(),
// //         documentName: selectedTab == 0
// //             ? selectedFileName ?? ''
// //             : selectedTab == 1
// //             ? 'Link Material'
// //             : 'Note Material',
// //         notes: _selectedNotes,
// //         link: selectedTab == 1 ? linkController.text.trim() : '',
// //         favorite: false,
// //         standardDivisionList: [
// //           StandardDivisionPair(
// //             standardId: selectedStandardId!,
// //             divisionId: selectedDivisionId!,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _clearForm() {
// //     linkController.clear();
// //     notesController.clear();

// //     setState(() {
// //       selectedTab = 0;

// //       selectedStandardId = null;
// //       selectedStandard = null;

// //       selectedDivisionId = null;
// //       selectedDivision = null;

// //       selectedSubjectId = null;
// //       selectedSubject = null;

// //       divisions = [];
// //       subjects = [];

// //       selectedFile = null;
// //       selectedFileName = null;
// //       selectedFilePath = null;
// //     });
// //   }

// //   void _showMessage(String message, {Color backgroundColor = Colors.red}) {
// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context)
// //       ..hideCurrentSnackBar()
// //       ..showSnackBar(
// //         SnackBar(
// //           content: Text(message),
// //           backgroundColor: backgroundColor,
// //           behavior: SnackBarBehavior.floating,
// //         ),
// //       );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiBlocListener(
// //       listeners: [
// //         BlocListener<AuthenticationCubit, AuthenticationState>(
// //           listenWhen: (previous, current) {
// //             return current is FetchTutorshipClassSuccess;
// //           },
// //           listener: (context, state) {
// //             if (state is FetchTutorshipClassSuccess) {
// //               setState(() {
// //                 tutorshipClasses = state.response.data?.tutorshipClass ?? [];

// //                 divisions = [];
// //                 subjects = [];

// //                 selectedStandardId = null;
// //                 selectedStandard = null;

// //                 selectedDivisionId = null;
// //                 selectedDivision = null;

// //                 selectedSubjectId = null;
// //                 selectedSubject = null;
// //               });
// //             }
// //           },
// //         ),
// //         BlocListener<MaterialCubit, MaterialState>(
// //           listener: (context, state) {
// //             // if (state is SaveMaterialSuccess) {
// //             //   // _showMessage(
// //             //   //   'Material saved successfully',
// //             //   //   backgroundColor: Colors.green,
// //             //   // );

// //             //   // _clearForm();
// //             //   if (!mounted) return;

// //             //   Navigator.of(context).pop(true);
// //             // }
// //             if (state is SaveMaterialSuccess) {
// //               Navigator.pop(context, true);
// //             }
// //             if (state is SaveMaterialFailure) {
// //               _showMessage(state.message);

// //               // Use this if the screen should close after success:
// //               // Navigator.pop(context, true);
// //             }

// //             if (state is SaveMaterialFailure) {
// //               _showMessage(state.message);
// //             }
// //           },
// //         ),
// //       ],
// //       child: BlocBuilder<MaterialCubit, MaterialState>(
// //         builder: (context, materialState) {
// //           final bool isSaving = materialState is SaveMaterialLoading;

// //           return Scaffold(
// //             backgroundColor: Colors.white,
// //             resizeToAvoidBottomInset: true,
// //             body: SafeArea(
// //               child: Column(
// //                 children: [
// //                   _buildHeader(),
// //                   const SizedBox(height: 18),
// //                   _buildTabBar(isSaving),
// //                   const SizedBox(height: 18),
// //                   Expanded(
// //                     child:
// //                         BlocBuilder<AuthenticationCubit, AuthenticationState>(
// //                           builder: (context, authenticationState) {
// //                             if (authenticationState
// //                                     is FetchTutorshipClassLoading &&
// //                                 tutorshipClasses.isEmpty) {
// //                               return const Center(
// //                                 child: CircularProgressIndicator(
// //                                   color: primaryColor,
// //                                 ),
// //                               );
// //                             }

// //                             if (authenticationState
// //                                     is FetchTutorshipClassFailure &&
// //                                 tutorshipClasses.isEmpty) {
// //                               return _ApiErrorView(
// //                                 message: authenticationState.message,
// //                                 onRetry: _fetchTutorshipClasses,
// //                               );
// //                             }

// //                             if (tutorshipClasses.isEmpty) {
// //                               return _ApiErrorView(
// //                                 message: 'No class details found',
// //                                 onRetry: _fetchTutorshipClasses,
// //                               );
// //                             }

// //                             return SingleChildScrollView(
// //                               physics: const BouncingScrollPhysics(),
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 20,
// //                               ),
// //                               child: _buildSelectedTab(isSaving),
// //                             );
// //                           },
// //                         ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.fromLTRB(20, 10, 20, 58),
// //                     child: _buildSaveButton(isSaving),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildSelectedTab(bool isSaving) {
// //     switch (selectedTab) {
// //       case 0:
// //         return _buildDocumentsTab(isSaving);

// //       case 1:
// //         return _buildLinksTab(isSaving);

// //       case 2:
// //         return _buildNotesTab(isSaving);

// //       default:
// //         return const SizedBox.shrink();
// //     }
// //   }

// //   Widget _buildHeader() {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
// //       child: Row(
// //         children: [
// //           GestureDetector(
// //             onTap: () => Navigator.maybePop(context),
// //             child: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
// //           ),
// //           const Expanded(
// //             child: Center(
// //               child: Text(
// //                 'Add Material',
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w700,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 22),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTabBar(bool isSaving) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20),
// //       height: 42,
// //       padding: const EdgeInsets.all(4),
// //       decoration: BoxDecoration(
// //         color: darkColor,
// //         borderRadius: BorderRadius.circular(25),
// //       ),
// //       child: Row(
// //         children: List.generate(tabs.length, (index) {
// //           final bool isSelected = selectedTab == index;

// //           return Expanded(
// //             child: GestureDetector(
// //               onTap: isSaving
// //                   ? null
// //                   : () {
// //                       FocusScope.of(context).unfocus();

// //                       setState(() {
// //                         selectedTab = index;
// //                       });
// //                     },
// //               child: AnimatedContainer(
// //                 duration: const Duration(milliseconds: 220),
// //                 height: double.infinity,
// //                 decoration: BoxDecoration(
// //                   color: isSelected ? primaryColor : Colors.transparent,
// //                   borderRadius: BorderRadius.circular(22),
// //                 ),
// //                 child: Center(
// //                   child: Text(
// //                     tabs[index],
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 13,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }

// //   Widget _buildDocumentsTab(bool isSaving) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _buildUploadBox(isSaving),
// //         const SizedBox(height: 14),
// //         const Row(
// //           children: [
// //             Icon(Icons.info, size: 16, color: Colors.grey),
// //             SizedBox(width: 6),
// //             Expanded(
// //               child: Text(
// //                 'Allowed: PDF, DOC, DOCX, JPG and PNG',
// //                 style: TextStyle(fontSize: 12, color: Colors.black87),
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 16),
// //         _buildClassFields(isSaving),
// //       ],
// //     );
// //   }

// //   Widget _buildLinksTab(bool isSaving) {
// //     return Column(
// //       children: [
// //         _buildClassFields(isSaving),
// //         const SizedBox(height: 14),
// //         _buildTextField(
// //           controller: linkController,
// //           hint: 'Link',
// //           height: 48,
// //           maxLines: 1,
// //           enabled: !isSaving,
// //           keyboardType: TextInputType.url,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildNotesTab(bool isSaving) {
// //     return Column(
// //       children: [
// //         _buildClassFields(isSaving),
// //         const SizedBox(height: 14),
// //         _buildTextField(
// //           controller: notesController,
// //           hint: 'Enter your note here',
// //           height: 250,
// //           maxLines: 15,
// //           enabled: !isSaving,
// //           showBoldIcon: true,
// //         ),
// //       ],
// //     );
// //   }

// //   // Widget _buildClassFields(bool isSaving) {
// //   //   return Column(
// //   //     children: [
// //   //       Row(
// //   //         children: [
// //   //           Expanded(
// //   //             child: _buildDropdownField<int>(
// //   //               hint: 'Standard',
// //   //               value: selectedStandardId,
// //   //               items: standards.map((item) {
// //   //                 return DropdownMenuItem<int>(
// //   //                   value: item.standardId,
// //   //                   child: Text(
// //   //                     item.standard ?? '',
// //   //                     style: const TextStyle(fontSize: 13),
// //   //                   ),
// //   //                 );
// //   //               }).toList(),
// //   //               onChanged: isSaving ? null : _selectStandard,
// //   //               isRequired: true,
// //   //             ),
// //   //           ),
// //   //           const SizedBox(width: 10),
// //   //           Expanded(
// //   //             child: _buildDropdownField<int>(
// //   //               hint: 'Division',
// //   //               value: selectedDivisionId,
// //   //               items: divisions.map((item) {
// //   //                 return DropdownMenuItem<int>(
// //   //                   value: item.divisionId,
// //   //                   child: Text(
// //   //                     item.division ?? '',
// //   //                     style: const TextStyle(fontSize: 13),
// //   //                   ),
// //   //                 );
// //   //               }).toList(),
// //   //               onChanged: isSaving || selectedStandardId == null
// //   //                   ? null
// //   //                   : _selectDivision,
// //   //               isRequired: true,
// //   //             ),
// //   //           ),
// //   //         ],
// //   //       ),
// //   //       const SizedBox(height: 12),
// //   //       _buildDropdownField<int>(
// //   //         hint: 'Subject',
// //   //         value: selectedSubjectId,
// //   //         items: subjects.map((item) {
// //   //           return DropdownMenuItem<int>(
// //   //             value: item.subjectId,
// //   //             child: Text(
// //   //               item.subject ?? '',
// //   //               style: const TextStyle(fontSize: 13),
// //   //             ),
// //   //           );
// //   //         }).toList(),
// //   //         onChanged: isSaving || selectedDivisionId == null
// //   //             ? null
// //   //             : _selectSubject,
// //   //         isRequired: true,
// //   //       ),
// //   //     ],
// //   //   );
// //   // }
// //   Widget _buildClassFields(bool isSaving) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _buildDropdownField<int>(
// //           hint: 'Subject',
// //           value: selectedSubjectId,
// //           items: subjects.map((item) {
// //             return DropdownMenuItem<int>(
// //               value: item.subjectId,
// //               child: Text(item.subject ?? ''),
// //             );
// //           }).toList(),
// //           onChanged: isSaving ? null : _selectSubject,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 18),
// //         const Text(
// //           'Select Your Classes',
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontSize: 11.5,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //         const SizedBox(height: 14),
// //         _buildClassCheckboxes(isSaving),
// //       ],
// //     );
// //   }

// //   Widget _buildClassCheckboxes(bool isSaving) {
// //     final List<Map<String, dynamic>> items = classList;

// //     if (items.isEmpty) {
// //       return const Center(
// //         child: Text(
// //           'No classes found',
// //           style: TextStyle(fontSize: 12, color: Colors.black54),
// //         ),
// //       );
// //     }

// //     return GridView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: items.length,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 3,
// //         mainAxisExtent: 46,
// //         crossAxisSpacing: 28,
// //       ),
// //       itemBuilder: (context, index) {
// //         final Map<String, dynamic> item = items[index];

// //         final int standardId = item['standardId'] as int;

// //         final String standardName = item['standardName'] as String? ?? '';

// //         final DivisionDetails division = item['division'] as DivisionDetails;

// //         final bool isSelected = selectedClasses.any(
// //           (e) =>
// //               e['standardId'] == standardId &&
// //               e['divisionId'] == division.divisionId,
// //         );

// //         return Row(
// //           children: [
// //             SizedBox(
// //               width: 18,
// //               height: 18,
// //               child: Checkbox(
// //                 value: isSelected,
// //                 onChanged: isSaving
// //                     ? null
// //                     : (value) {
// //                         FocusScope.of(context).unfocus();

// //                         setState(() {
// //                           if (value == true) {
// //                             selectedClasses.add({
// //                               'standardId': standardId,
// //                               'divisionId': division.divisionId,
// //                             });
// //                           } else {
// //                             selectedClasses.removeWhere(
// //                               (e) =>
// //                                   e['standardId'] == standardId &&
// //                                   e['divisionId'] == division.divisionId,
// //                             );
// //                           }
// //                         });
// //                       },
// //                 activeColor: const Color(0xff8f83dc),
// //                 checkColor: Colors.black,
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: Text(
// //                 '$standardName ${division.division ?? ''}',
// //                 overflow: TextOverflow.ellipsis,
// //                 style: TextStyle(
// //                   fontSize: 12,
// //                   color: isSelected ? const Color(0xff7d6dff) : Colors.black87,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildUploadBox(bool isSaving) {
// //     final bool hasSelectedFile = selectedFile != null;

// //     return GestureDetector(
// //       behavior: HitTestBehavior.opaque,
// //       onTap: isSaving ? null : _chooseFile,
// //       child: CustomPaint(
// //         painter: DashedBorderPainter(),
// //         child: Container(
// //           width: double.infinity,
// //           height: 108,
// //           decoration: BoxDecoration(
// //             color: fieldColor,
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   hasSelectedFile
// //                       ? Icons.check_circle_outline
// //                       : Icons.cloud_upload_outlined,
// //                   color: hasSelectedFile ? Colors.green : Colors.blue.shade600,
// //                   size: 28,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   child: Text(
// //                     selectedFileName ?? 'Choose File',
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: hasSelectedFile
// //                           ? Colors.green.shade700
// //                           : Colors.blue.shade700,
// //                       decoration: hasSelectedFile
// //                           ? TextDecoration.none
// //                           : TextDecoration.underline,
// //                     ),
// //                   ),
// //                 ),
// //                 if (hasSelectedFile) ...[
// //                   const SizedBox(height: 5),
// //                   Text(
// //                     'Tap to change file',
// //                     style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDropdownField<T>({
// //     required String hint,
// //     required T? value,
// //     required List<DropdownMenuItem<T>> items,
// //     required ValueChanged<T?>? onChanged,
// //     bool isRequired = false,
// //   }) {
// //     final bool hasValidValue =
// //         value == null || items.any((item) => item.value == value);

// //     return Container(
// //       height: 46,
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       decoration: BoxDecoration(
// //         color: fieldColor,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<T>(
// //           value: hasValidValue ? value : null,
// //           isExpanded: true,
// //           icon: const Icon(
// //             Icons.keyboard_arrow_down_rounded,
// //             color: Colors.black54,
// //           ),
// //           hint: _requiredText(hint, isRequired),
// //           items: items,
// //           onChanged: onChanged,
// //           dropdownColor: Colors.white,
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _requiredText(String text, bool isRequired) {
// //     if (!isRequired) {
// //       return Text(
// //         text,
// //         style: const TextStyle(fontSize: 13, color: Colors.black),
// //       );
// //     }

// //     return RichText(
// //       text: TextSpan(
// //         text: text,
// //         style: const TextStyle(fontSize: 13, color: Colors.black),
// //         children: const [
// //           TextSpan(
// //             text: '*',
// //             style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required String hint,
// //     required double height,
// //     required int maxLines,
// //     required bool enabled,
// //     TextInputType? keyboardType,
// //     bool showBoldIcon = false,
// //   }) {
// //     return Container(
// //       height: height,
// //       decoration: BoxDecoration(
// //         color: fieldColor,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: TextField(
// //         controller: controller,
// //         enabled: enabled,
// //         maxLines: maxLines,
// //         keyboardType: keyboardType,
// //         textAlignVertical: TextAlignVertical.top,
// //         decoration: InputDecoration(
// //           hintText: hint,
// //           hintStyle: const TextStyle(fontSize: 12, color: Colors.black87),
// //           border: InputBorder.none,
// //           contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
// //           suffixIcon: showBoldIcon
// //               ? Padding(
// //                   padding: const EdgeInsets.only(top: 10, right: 8),
// //                   child: Align(
// //                     alignment: Alignment.topRight,
// //                     widthFactor: 1,
// //                     heightFactor: 1,
// //                     child: Container(
// //                       height: 16,
// //                       width: 16,
// //                       decoration: BoxDecoration(
// //                         color: Colors.black,
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                       child: const Center(
// //                         child: Text(
// //                           'B',
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               : null,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSaveButton(bool isSaving) {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 48,
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: primaryColor,
// //           disabledBackgroundColor: primaryColor.withOpacity(0.65),
// //           elevation: 0,
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
// //         ),
// //         onPressed: isSaving ? null : _saveMaterial,
// //         child: isSaving
// //             ? const SizedBox(
// //                 width: 22,
// //                 height: 22,
// //                 child: CircularProgressIndicator(
// //                   color: Colors.white,
// //                   strokeWidth: 2.4,
// //                 ),
// //               )
// //             : const Text(
// //                 'Save',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //       ),
// //     );
// //   }
// // }

// // class _ApiErrorView extends StatelessWidget {
// //   final String message;
// //   final VoidCallback onRetry;

// //   const _ApiErrorView({required this.message, required this.onRetry});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Text(
// //               message,
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(fontSize: 13, color: Colors.red),
// //             ),
// //             const SizedBox(height: 12),
// //             TextButton(
// //               onPressed: onRetry,
// //               child: const Text(
// //                 'Retry',
// //                 style: TextStyle(color: Color(0xFF9B73E6)),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class DashedBorderPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     const double dashWidth = 7;
// //     const double dashSpace = 5;

// //     final Paint paint = Paint()
// //       ..color = Colors.black
// //       ..strokeWidth = 1
// //       ..style = PaintingStyle.stroke;

// //     final RRect roundedRect = RRect.fromRectAndRadius(
// //       Rect.fromLTWH(0, 0, size.width, size.height),
// //       const Radius.circular(8),
// //     );

// //     final Path path = Path()..addRRect(roundedRect);

// //     for (final PathMetric metric in path.computeMetrics()) {
// //       double distance = 0;

// //       while (distance < metric.length) {
// //         final double endDistance = (distance + dashWidth)
// //             .clamp(0.0, metric.length)
// //             .toDouble();

// //         canvas.drawPath(metric.extractPath(distance, endDistance), paint);

// //         distance += dashWidth + dashSpace;
// //       }
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// // }
// import 'dart:io';
// import 'dart:ui';

// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
// import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart' hide MaterialState;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:open_filex/open_filex.dart';

// /// One file chosen in the Documents tab. Keeps the picker's own name, the
// /// extension and the size next to the File, so the tiles can be drawn
// /// without parsing the path or hitting the disk again.
// class PickedMaterialFile {
//   final File file;
//   final String name;
//   final String extension;
//   final int size;

//   const PickedMaterialFile({
//     required this.file,
//     required this.name,
//     required this.extension,
//     required this.size,
//   });

//   String get path => file.path;

//   String get mimeType {
//     switch (extension.toLowerCase()) {
//       case 'pdf':
//         return 'application/pdf';
//       case 'doc':
//         return 'application/msword';
//       case 'docx':
//         return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       default:
//         return 'application/octet-stream';
//     }
//   }
// }

// class AddMaterialPage extends StatefulWidget {
//   const AddMaterialPage({super.key});

//   @override
//   State<AddMaterialPage> createState() => _AddMaterialPageState();
// }

// class _AddMaterialPageState extends State<AddMaterialPage> {
//   static const Color primaryColor = Color(0xFF9B73E6);
//   static const Color fieldColor = Color(0xFFF0F4FF);
//   static const Color darkColor = Colors.black;
//   static const Color tileBorderColor = Color(0xffB7C4D6);
//   static const int maxUploadSizeBytes = 5 * 1024 * 1024;

//   static const List<String> allowedExtensions = [
//     'pdf',
//     'doc',
//     'docx',
//     'jpg',
//     'jpeg',
//     'png',
//   ];

//   /// Extensions shown as a picture instead of an icon.
//   static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];

//   int selectedTab = 0;

//   /// Every file picked for the Documents tab. Multiple files are allowed.
//   final List<PickedMaterialFile> selectedFiles = [];

//   bool _isPickingFiles = false;

//   final List<String> tabs = const ['Documents', 'Links', 'Notes'];

//   final TextEditingController linkController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();

//   List<TutorshipClass> tutorshipClasses = [];
//   List<SubjectDetails> subjects = [];

//   /// Checked classes, each as {'standardId': int, 'divisionId': int}.
//   final List<Map<String, dynamic>> selectedClasses = [];

//   int? selectedSubjectId;
//   String? selectedSubject;

//   @override
//   void initState() {
//     super.initState();

//     tutorshipClasses = List<TutorshipClass>.from(AppData.standards);

//     final Map<int, SubjectDetails> uniqueSubjects = {};

//     for (final TutorshipClass standard in tutorshipClasses) {
//       for (final DivisionDetails division
//           in standard.division ?? <DivisionDetails>[]) {
//         for (final SubjectDetails subject
//             in division.subject ?? <SubjectDetails>[]) {
//           final int? subjectId = subject.subjectId;

//           if (subjectId != null) {
//             uniqueSubjects[subjectId] = subject;
//           }
//         }
//       }
//     }

//     subjects = uniqueSubjects.values.toList();

//     if (subjects.isNotEmpty) {
//       final SubjectDetails firstSubject = subjects.first;

//       selectedSubjectId = firstSubject.subjectId;
//       selectedSubject = firstSubject.subject;
//     }
//   }

//   @override
//   void dispose() {
//     linkController.dispose();
//     notesController.dispose();
//     super.dispose();
//   }

//   String _formatFileSize(int bytes) {
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
//   }

//   bool _isImage(String extension) {
//     return imageExtensions.contains(extension.toLowerCase());
//   }

//   String _extensionOf(String fileName) {
//     final int dotIndex = fileName.lastIndexOf('.');

//     if (dotIndex == -1) {
//       return '';
//     }

//     return fileName.substring(dotIndex + 1).toLowerCase();
//   }

//   IconData _getFileIcon(String extension) {
//     switch (extension.toLowerCase()) {
//       case 'pdf':
//         return Icons.picture_as_pdf_outlined;
//       case 'doc':
//       case 'docx':
//         return Icons.description_outlined;
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//         return Icons.image_outlined;
//       default:
//         return Icons.insert_drive_file_outlined;
//     }
//   }

//   List<Map<String, dynamic>> get classList {
//     final List<Map<String, dynamic>> items = [];

//     for (final TutorshipClass standard in tutorshipClasses) {
//       final int? standardId = standard.standardId;

//       if (standardId == null) continue;

//       for (final DivisionDetails division
//           in standard.division ?? <DivisionDetails>[]) {
//         if (division.divisionId == null) continue;

//         items.add({
//           'standardId': standardId,
//           'standardName': standard.standard,
//           'division': division,
//         });
//       }
//     }

//     return items;
//   }

//   void _selectSubject(int? subjectId) {
//     if (subjectId == null) return;

//     final SubjectDetails subject = subjects.firstWhere(
//       (item) => item.subjectId == subjectId,
//     );

//     setState(() {
//       selectedSubjectId = subject.subjectId;
//       selectedSubject = subject.subject;
//     });
//   }

//   Future<void> _chooseFile() async {
//     if (_isPickingFiles) return;

//     setState(() {
//       _isPickingFiles = true;
//     });

//     try {
//       FocusScope.of(context).unfocus();

//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: allowedExtensions,
//         allowMultiple: true,
//         withData: false,
//       );

//       // The user closed the picker.
//       if (result == null || result.files.isEmpty) {
//         return;
//       }

//       final List<PickedMaterialFile> accepted = [];

//       // Names of files that were skipped, reported together at the end so
//       // picking ten files cannot fire ten snackbars.
//       final List<String> tooLarge = [];
//       final List<String> unavailable = [];
//       final List<String> duplicates = [];

//       for (final PlatformFile pickedFile in result.files) {
//         final String? filePath = pickedFile.path;

//         if (filePath == null || filePath.isEmpty) {
//           unavailable.add(pickedFile.name);
//           continue;
//         }

//         final bool alreadyPicked =
//             selectedFiles.any((item) => item.path == filePath) ||
//             accepted.any((item) => item.path == filePath);

//         if (alreadyPicked) {
//           duplicates.add(pickedFile.name);
//           continue;
//         }

//         final File file = File(filePath);

//         if (!await file.exists()) {
//           unavailable.add(pickedFile.name);
//           continue;
//         }

//         final int fileSize = await file.length();

//         if (fileSize > maxUploadSizeBytes) {
//           tooLarge.add('${pickedFile.name} (${_formatFileSize(fileSize)})');
//           continue;
//         }

//         final String extension =
//             (pickedFile.extension ?? _extensionOf(pickedFile.name))
//                 .toLowerCase();

//         accepted.add(
//           PickedMaterialFile(
//             file: file,
//             name: pickedFile.name,
//             extension: extension,
//             size: fileSize,
//           ),
//         );
//       }

//       if (!mounted) return;

//       if (accepted.isNotEmpty) {
//         setState(() {
//           selectedFiles.addAll(accepted);
//         });
//       }

//       for (final PickedMaterialFile item in accepted) {
//         debugPrint('Selected filename: ${item.name}');
//         debugPrint('Selected file path: ${item.path}');
//         debugPrint('Selected file size: ${_formatFileSize(item.size)}');
//       }

//       final List<String> skipped = [];

//       if (tooLarge.isNotEmpty) {
//         skipped.add('over 5 MB: ${tooLarge.join(', ')}');
//       }

//       if (unavailable.isNotEmpty) {
//         skipped.add('not accessible: ${unavailable.join(', ')}');
//       }

//       if (duplicates.isNotEmpty) {
//         skipped.add('already added: ${duplicates.join(', ')}');
//       }

//       if (skipped.isNotEmpty) {
//         _showMessage('Skipped ${skipped.join(' | ')}');
//       }
//     } catch (error, stackTrace) {
//       debugPrint('FilePicker error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       if (!mounted) return;

//       _showMessage('Unable to select the file: $error');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isPickingFiles = false;
//         });
//       }
//     }
//   }

//   void _removeFileAt(int index) {
//     if (index < 0 || index >= selectedFiles.length) {
//       return;
//     }

//     setState(() {
//       selectedFiles.removeAt(index);
//     });
//   }

//   /// Shows the tapped picture on its own screen.
//   void _openImageViewer(ImageProvider image, String title) {
//     Navigator.of(context).push(
//       PageRouteBuilder<void>(
//         pageBuilder: (_, __, ___) {
//           return MaterialImageViewer(image: image, title: title);
//         },
//         transitionsBuilder: (_, animation, __, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 180),
//       ),
//     );
//   }

//   /// A PDF or document picked here. It is already a real file on disk, so
//   /// it goes straight to whichever app the device uses for that type.
//   Future<void> _openDocument(PickedMaterialFile item) async {
//     try {
//       final OpenResult result = await OpenFilex.open(
//         item.path,
//         type: item.mimeType,
//       );

//       if (result.type != ResultType.done) {
//         _showMessage('No app available to open ${item.name}');
//       }
//     } catch (error, stackTrace) {
//       debugPrint('Open picked attachment error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to open ${item.name}');
//     }
//   }

//   Future<void> _saveMaterial() async {
//     FocusScope.of(context).unfocus();

//     final String? accYear = AppData.accYear;
//     final int? employeeId = AppData.employeeId;
//     final int? userId = AppData.userId;

//     if (accYear == null || accYear.trim().isEmpty) {
//       _showMessage('Academic year is unavailable');
//       return;
//     }

//     if (employeeId == null) {
//       _showMessage('Employee ID is unavailable');
//       return;
//     }

//     if (userId == null) {
//       _showMessage('User ID is unavailable');
//       return;
//     }

//     if (selectedSubjectId == null) {
//       _showMessage('Please select Subject');
//       return;
//     }

//     if (selectedClasses.isEmpty) {
//       _showMessage('Please select at least one class');
//       return;
//     }

//     if (selectedTab == 0) {
//       if (selectedFiles.isEmpty) {
//         _showMessage('Please choose at least one file');
//         return;
//       }

//       // A file can be deleted between picking and saving.
//       final List<PickedMaterialFile> missingFiles = [];

//       for (final PickedMaterialFile item in selectedFiles) {
//         if (!await item.file.exists()) {
//           missingFiles.add(item);
//         }
//       }

//       if (missingFiles.isNotEmpty) {
//         if (!mounted) return;

//         setState(() {
//           selectedFiles.removeWhere((item) => missingFiles.contains(item));
//         });

//         _showMessage(
//           '${missingFiles.map((item) => item.name).join(', ')} '
//           'is no longer available. Please choose it again.',
//         );
//         return;
//       }

//       for (final PickedMaterialFile item in selectedFiles) {
//         final int fileSize = await item.file.length();

//         if (fileSize > maxUploadSizeBytes) {
//           _showMessage(
//             '${item.name} is ${_formatFileSize(fileSize)}. '
//             'Please select a file below 5 MB.',
//           );
//           return;
//         }
//       }
//     }

//     if (selectedTab == 1) {
//       final String link = linkController.text.trim();

//       if (link.isEmpty) {
//         _showMessage('Please enter a link');
//         return;
//       }

//       final Uri? uri = Uri.tryParse(link);

//       if (uri == null ||
//           !uri.hasScheme ||
//           (uri.scheme != 'http' && uri.scheme != 'https')) {
//         _showMessage(
//           'Please enter a valid link starting with http:// or https://',
//         );
//         return;
//       }
//     }

//     if (selectedTab == 2 && notesController.text.trim().isEmpty) {
//       _showMessage('Please enter a note');
//       return;
//     }

//     if (!mounted) return;

//     // One pair for every checked class.
//     final List<StandardDivisionPair> standardDivisionList = selectedClasses
//         .map(
//           (selectedClass) => StandardDivisionPair(
//             standardId: selectedClass['standardId'] as int,
//             divisionId: selectedClass['divisionId'] as int,
//           ),
//         )
//         .toList();

//     context.read<MaterialCubit>().saveMaterial(
//       SaveMaterialParameter(
//         materials: selectedTab == 0
//             ? selectedFiles.map((item) => item.file).toList()
//             : <File>[],
//         staffId: employeeId,
//         accYear: accYear,
//         subjectId: selectedSubjectId!,
//         branchId: 1,
//         createdUser: userId.toString(),
//         documentName: selectedTab == 0
//             ? selectedFiles.map((item) => item.name).join(', ')
//             : selectedTab == 1
//             ? 'Link Material'
//             : 'Note Material',
//         notes: selectedTab == 2 ? notesController.text.trim() : '',
//         link: selectedTab == 1 ? linkController.text.trim() : '',
//         favorite: false,
//         standardDivisionList: standardDivisionList,
//       ),
//     );
//   }

//   void _showMessage(String message, {Color backgroundColor = Colors.red}) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: backgroundColor,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MaterialCubit, MaterialState>(
//       listener: (context, state) {
//         if (state is SaveMaterialSuccess) {
//           Navigator.pop(context, true);
//         }

//         if (state is SaveMaterialFailure) {
//           _showMessage(state.message);
//         }
//       },
//       child: BlocBuilder<MaterialCubit, MaterialState>(
//         builder: (context, materialState) {
//           final bool isSaving = materialState is SaveMaterialLoading;

//           return Scaffold(
//             backgroundColor: Colors.white,
//             resizeToAvoidBottomInset: true,
//             body: SafeArea(
//               child: Column(
//                 children: [
//                   _buildHeader(),
//                   const SizedBox(height: 18),
//                   _buildTabBar(isSaving),
//                   const SizedBox(height: 18),
//                   Expanded(
//                     child: tutorshipClasses.isEmpty
//                         ? const Center(
//                             child: Text(
//                               'No class details found',
//                               style: TextStyle(fontSize: 13, color: Colors.red),
//                             ),
//                           )
//                         : SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: _buildSelectedTab(isSaving),
//                           ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 10, 20, 58),
//                     child: _buildSaveButton(isSaving),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSelectedTab(bool isSaving) {
//     switch (selectedTab) {
//       case 0:
//         return _buildDocumentsTab(isSaving);

//       case 1:
//         return _buildLinksTab(isSaving);

//       case 2:
//         return _buildNotesTab(isSaving);

//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.maybePop(context),
//             child: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
//           ),
//           const Expanded(
//             child: Center(
//               child: Text(
//                 'Add Material',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 22),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabBar(bool isSaving) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       height: 42,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: darkColor,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Row(
//         children: List.generate(tabs.length, (index) {
//           final bool isSelected = selectedTab == index;

//           return Expanded(
//             child: GestureDetector(
//               onTap: isSaving
//                   ? null
//                   : () {
//                       FocusScope.of(context).unfocus();

//                       setState(() {
//                         selectedTab = index;
//                       });
//                     },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 220),
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   color: isSelected ? primaryColor : Colors.transparent,
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: Center(
//                   child: Text(
//                     tabs[index],
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildDocumentsTab(bool isSaving) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildUploadBox(isSaving),
//         const SizedBox(height: 14),
//         const Row(
//           children: [
//             Icon(Icons.info, size: 16, color: Colors.grey),
//             SizedBox(width: 6),
//             Expanded(
//               child: Text(
//                 'Allowed: PDF, DOC, DOCX, JPG and PNG',
//                 style: TextStyle(fontSize: 12, color: Colors.black87),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         _buildClassFields(isSaving),
//       ],
//     );
//   }

//   Widget _buildLinksTab(bool isSaving) {
//     return Column(
//       children: [
//         _buildClassFields(isSaving),
//         const SizedBox(height: 14),
//         _buildTextField(
//           controller: linkController,
//           hint: 'Link',
//           height: 48,
//           maxLines: 1,
//           enabled: !isSaving,
//           keyboardType: TextInputType.url,
//         ),
//       ],
//     );
//   }

//   Widget _buildNotesTab(bool isSaving) {
//     return Column(
//       children: [
//         _buildClassFields(isSaving),
//         const SizedBox(height: 14),
//         _buildTextField(
//           controller: notesController,
//           hint: 'Enter your note here',
//           height: 250,
//           maxLines: 15,
//           enabled: !isSaving,
//           showBoldIcon: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildClassFields(bool isSaving) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildDropdownField<int>(
//           hint: 'Subject',
//           value: selectedSubjectId,
//           items: subjects.map((item) {
//             return DropdownMenuItem<int>(
//               value: item.subjectId,
//               child: Text(item.subject ?? ''),
//             );
//           }).toList(),
//           onChanged: isSaving ? null : _selectSubject,
//           isRequired: true,
//         ),
//         const SizedBox(height: 18),
//         const Text(
//           'Select Your Classes',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 11.5,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 14),
//         _buildClassCheckboxes(isSaving),
//       ],
//     );
//   }

//   Widget _buildClassCheckboxes(bool isSaving) {
//     final List<Map<String, dynamic>> items = classList;

//     if (items.isEmpty) {
//       return const Center(
//         child: Text(
//           'No classes found',
//           style: TextStyle(fontSize: 12, color: Colors.black54),
//         ),
//       );
//     }

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: items.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisExtent: 46,
//         crossAxisSpacing: 28,
//       ),
//       itemBuilder: (context, index) {
//         final Map<String, dynamic> item = items[index];

//         final int standardId = item['standardId'] as int;

//         final String standardName = item['standardName'] as String? ?? '';

//         final DivisionDetails division = item['division'] as DivisionDetails;

//         final bool isSelected = selectedClasses.any(
//           (e) =>
//               e['standardId'] == standardId &&
//               e['divisionId'] == division.divisionId,
//         );

//         return Row(
//           children: [
//             SizedBox(
//               width: 18,
//               height: 18,
//               child: Checkbox(
//                 value: isSelected,
//                 onChanged: isSaving
//                     ? null
//                     : (value) {
//                         FocusScope.of(context).unfocus();

//                         setState(() {
//                           if (value == true) {
//                             selectedClasses.add({
//                               'standardId': standardId,
//                               'divisionId': division.divisionId,
//                             });
//                           } else {
//                             selectedClasses.removeWhere(
//                               (e) =>
//                                   e['standardId'] == standardId &&
//                                   e['divisionId'] == division.divisionId,
//                             );
//                           }
//                         });
//                       },
//                 activeColor: const Color(0xff8f83dc),
//                 checkColor: Colors.black,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 '$standardName ${division.division ?? ''}',
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isSelected ? const Color(0xff7d6dff) : Colors.black87,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Empty: the upload prompt. With files: a row of thumbnails inside the
//   /// same dashed box, images shown as pictures.
//   Widget _buildUploadBox(bool isSaving) {
//     return CustomPaint(
//       painter: DashedBorderPainter(),
//       child: SizedBox(
//         width: double.infinity,
//         height: 108,
//         child: selectedFiles.isEmpty
//             ? _buildEmptyUploadBox(isSaving)
//             : _buildFilePreviews(isSaving),
//       ),
//     );
//   }

//   Widget _buildEmptyUploadBox(bool isSaving) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: isSaving || _isPickingFiles ? null : _chooseFile,
//       child: Container(
//         decoration: BoxDecoration(
//           color: fieldColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_isPickingFiles)
//               const SizedBox(
//                 width: 26,
//                 height: 26,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: primaryColor,
//                 ),
//               )
//             else
//               Icon(
//                 Icons.cloud_upload_outlined,
//                 color: Colors.blue.shade600,
//                 size: 28,
//               ),
//             const SizedBox(height: 4),
//             Text(
//               _isPickingFiles ? 'Selecting...' : 'Choose File',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.blue.shade700,
//                 decoration: _isPickingFiles
//                     ? TextDecoration.none
//                     : TextDecoration.underline,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               'You can select more than one file',
//               style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilePreviews(bool isSaving) {
//     return Container(
//       decoration: BoxDecoration(
//         color: fieldColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         children: [
//           for (int index = 0; index < selectedFiles.length; index++)
//             _fileTile(
//               preview: _filePreview(selectedFiles[index]),
//               onTap: _isImage(selectedFiles[index].extension)
//                   ? () => _openImageViewer(
//                       FileImage(selectedFiles[index].file),
//                       selectedFiles[index].name,
//                     )
//                   : () => _openDocument(selectedFiles[index]),
//               onRemove: isSaving ? null : () => _removeFileAt(index),
//             ),
//           _addMoreTile(isSaving),
//         ],
//       ),
//     );
//   }

//   /// Picked file: the picture itself for images, an icon otherwise.
//   Widget _filePreview(PickedMaterialFile item) {
//     if (_isImage(item.extension)) {
//       return Image.file(
//         item.file,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => _fileIconPreview(item.extension),
//       );
//     }

//     return _fileIconPreview(item.extension, label: item.extension);
//   }

//   Widget _fileIconPreview(String extension, {String? label}) {
//     return Container(
//       color: fieldColor,
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(_getFileIcon(extension), size: 26, color: primaryColor),
//           if ((label ?? extension).isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Text(
//               (label ?? extension).toUpperCase(),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff5C5C5C),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _fileTile({
//     required Widget preview,
//     required VoidCallback? onRemove,
//     VoidCallback? onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 9),
//       child: SizedBox(
//         width: 74,
//         child: Stack(
//           children: [
//             // Tapping opens the file: pictures full screen, PDFs and
//             // documents in the device's own viewer. It never reopens the
//             // file picker; that is the Add tile's job.
//             Positioned.fill(
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: onTap,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(7),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: fieldColor,
//                       border: Border.all(
//                         color: tileBorderColor.withOpacity(0.6),
//                       ),
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                     child: preview,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 2,
//               right: 2,
//               child: GestureDetector(
//                 onTap: onRemove,
//                 child: Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.55),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.close, size: 13, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _addMoreTile(bool isSaving) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: isSaving || _isPickingFiles ? null : _chooseFile,
//       child: SizedBox(
//         width: 74,
//         child: MaterialDottedTileBorder(
//           color: tileBorderColor,
//           child: Center(
//             child: _isPickingFiles
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: primaryColor,
//                     ),
//                   )
//                 : const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.add, size: 22, color: primaryColor),
//                       SizedBox(height: 3),
//                       Text(
//                         'Add',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Color(0xff5C5C5C),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// This screen's own dropdown-style field: flat 46px, no outline. Only the
//   /// option sheet is shared — see showOptionPickerSheet.
//   Widget _buildDropdownField<T>({
//     required String hint,
//     required T? value,
//     required List<DropdownMenuItem<T>> items,
//     required ValueChanged<T?>? onChanged,
//     bool isRequired = false,
//   }) {
//     // Null when the saved value is no longer in the list, which falls back
//     // to showing the hint.
//     final DropdownMenuItem<T>? selected = selectedItemOf(items, value);

//     final bool isEnabled = onChanged != null && items.isNotEmpty;

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: !isEnabled
//           ? null
//           : () async {
//               final PickerSelection<T>? picked = await showOptionPickerSheet<T>(
//                 context: context,
//                 title: 'Select $hint',
//                 items: items,
//                 selectedValue: value,
//               );

//               if (picked == null) return;

//               onChanged(picked.value);
//             },
//       child: Container(
//         height: 46,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: fieldColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: selected == null
//                   ? _requiredText(hint, isRequired)
//                   : DefaultTextStyle(
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: isEnabled ? Colors.black : Colors.grey,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       child: selected.child,
//                     ),
//             ),
//             Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: isEnabled ? Colors.black54 : Colors.grey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _requiredText(String text, bool isRequired) {
//     if (!isRequired) {
//       return Text(
//         text,
//         style: const TextStyle(fontSize: 13, color: Colors.black),
//       );
//     }

//     return RichText(
//       text: TextSpan(
//         text: text,
//         style: const TextStyle(fontSize: 13, color: Colors.black),
//         children: const [
//           TextSpan(
//             text: '*',
//             style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required double height,
//     required int maxLines,
//     required bool enabled,
//     TextInputType? keyboardType,
//     bool showBoldIcon = false,
//   }) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: fieldColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextField(
//         controller: controller,
//         enabled: enabled,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         textAlignVertical: TextAlignVertical.top,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(fontSize: 12, color: Colors.black87),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
//           suffixIcon: showBoldIcon
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 10, right: 8),
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     widthFactor: 1,
//                     heightFactor: 1,
//                     child: Container(
//                       height: 16,
//                       width: 16,
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'B',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : null,
//         ),
//       ),
//     );
//   }

//   Widget _buildSaveButton(bool isSaving) {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           disabledBackgroundColor: primaryColor.withOpacity(0.65),
//           elevation: 0,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         ),
//         onPressed: isSaving ? null : _saveMaterial,
//         child: isSaving
//             ? const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.4,
//                 ),
//               )
//             : const Text(
//                 'Save',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//       ),
//     );
//   }
// }

// /// Full screen look at one picked picture. Pinch or double tap to zoom,
// /// tap the backdrop or the close button to come back.
// class MaterialImageViewer extends StatelessWidget {
//   final ImageProvider image;
//   final String title;

//   const MaterialImageViewer({super.key, required this.image, this.title = ''});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: () {
//                   Navigator.of(context).maybePop();
//                 },
//                 child: InteractiveViewer(
//                   minScale: 1,
//                   maxScale: 4,
//                   child: Center(
//                     child: Image(
//                       image: image,
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) {
//                         return const Icon(
//                           Icons.broken_image_outlined,
//                           color: Colors.white54,
//                           size: 44,
//                         );
//                       },
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;

//                         return const SizedBox(
//                           width: 26,
//                           height: 26,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 10,
//               left: 12,
//               right: 12,
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).maybePop();
//                     },
//                     child: Container(
//                       width: 34,
//                       height: 34,
//                       decoration: const BoxDecoration(
//                         color: Colors.white24,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 19,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Dashed outline for the small "Add" tile.
// class MaterialDottedTileBorder extends StatelessWidget {
//   final Color color;
//   final Widget child;

//   const MaterialDottedTileBorder({
//     super.key,
//     required this.color,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _TileDashPainter(color: color),
//       child: child,
//     );
//   }
// }

// class _TileDashPainter extends CustomPainter {
//   final Color color;

//   const _TileDashPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     const double dashWidth = 5;
//     const double dashSpace = 4;

//     final Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     final Path path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(0, 0, size.width, size.height),
//           const Radius.circular(7),
//         ),
//       );

//     for (final PathMetric metric in path.computeMetrics()) {
//       double distance = 0;

//       while (distance < metric.length) {
//         final double endDistance = (distance + dashWidth)
//             .clamp(0.0, metric.length)
//             .toDouble();

//         canvas.drawPath(metric.extractPath(distance, endDistance), paint);

//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant _TileDashPainter oldDelegate) {
//     return oldDelegate.color != color;
//   }
// }

// class DashedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     const double dashWidth = 7;
//     const double dashSpace = 5;

//     final Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     final RRect roundedRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       const Radius.circular(8),
//     );

//     final Path path = Path()..addRRect(roundedRect);

//     for (final PathMetric metric in path.computeMetrics()) {
//       double distance = 0;

//       while (distance < metric.length) {
//         final double endDistance = (distance + dashWidth)
//             .clamp(0.0, metric.length)
//             .toDouble();

//         canvas.drawPath(metric.extractPath(distance, endDistance), paint);

//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'dart:io';
import 'dart:ui';

import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/entities/material_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

/// One file chosen in the Documents tab. Keeps the picker's own name, the
/// extension and the size next to the File, so the tiles can be drawn
/// without parsing the path or hitting the disk again.
class PickedMaterialFile {
  final File file;
  final String name;
  final String extension;
  final int size;

  const PickedMaterialFile({
    required this.file,
    required this.name,
    required this.extension,
    required this.size,
  });

  String get path => file.path;

  String get mimeType {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }
}

class AddMaterialPage extends StatefulWidget {
  final int? materialId;

  const AddMaterialPage({super.key, this.materialId});

  bool get isEditing => materialId != null && materialId! > 0;

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  static const Color primaryColor = Color(0xFF9B73E6);
  static const Color fieldColor = Color(0xFFF0F4FF);
  static const Color darkColor = Colors.black;
  static const Color tileBorderColor = Color(0xffB7C4D6);
  static const int maxUploadSizeBytes = 5 * 1024 * 1024;

  static const List<String> allowedExtensions = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png',
  ];

  /// Extensions shown as a picture instead of an icon.
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];

  int selectedTab = 0;

  /// Every file picked for the Documents tab. Multiple files are allowed.
  final List<PickedMaterialFile> selectedFiles = [];
  final List<String> existingMaterialUrls = [];

  bool _isPickingFiles = false;
  bool _isFetchingEditDetails = false;
  bool _isInitialDataApplied = false;
  bool isFavorite = false;

  final List<String> tabs = const ['Documents', 'Links', 'Notes'];

  final TextEditingController linkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<TutorshipClass> tutorshipClasses = [];
  List<SubjectDetails> subjects = [];

  /// Checked classes, each as {'standardId': int, 'divisionId': int}.
  final List<Map<String, dynamic>> selectedClasses = [];

  int? selectedSubjectId;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();

    tutorshipClasses = List<TutorshipClass>.from(AppData.standards);

    final Map<int, SubjectDetails> uniqueSubjects = {};

    for (final TutorshipClass standard in tutorshipClasses) {
      for (final DivisionDetails division
          in standard.division ?? <DivisionDetails>[]) {
        for (final SubjectDetails subject
            in division.subject ?? <SubjectDetails>[]) {
          final int? subjectId = subject.subjectId;

          if (subjectId != null) {
            uniqueSubjects[subjectId] = subject;
          }
        }
      }
    }

    subjects = uniqueSubjects.values.toList();

    if (!widget.isEditing && subjects.isNotEmpty) {
      final SubjectDetails firstSubject = subjects.first;

      selectedSubjectId = firstSubject.subjectId;
      selectedSubject = firstSubject.subject;
    }

    if (widget.isEditing) {
      _isFetchingEditDetails = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<MaterialCubit>().fetchMaterialDetails(widget.materialId!);
      });
    }
  }

  void _applyMaterialDetails(MaterialDetailsResponseEntity response) {
    if (_isInitialDataApplied) return;

    final MaterialDetailsEntity? material = response.data;
    if (material == null) {
      _isFetchingEditDetails = false;
      _showMessage('Material details not found');
      return;
    }

    _isInitialDataApplied = true;
    _isFetchingEditDetails = false;
    selectedSubjectId = material.subjectId;
    selectedSubject = null;

    for (final SubjectDetails subject in subjects) {
      if (subject.subjectId == material.subjectId) {
        selectedSubject = subject.subject;
        break;
      }
    }

    selectedClasses.clear();
    if (material.standardId != null && material.divisionId != null) {
      selectedClasses.add({
        'standardId': material.standardId!,
        'divisionId': material.divisionId!,
      });
    }

    notesController.text = material.notes ?? '';
    linkController.text = material.link ?? '';
    isFavorite = material.favorite ?? false;
    existingMaterialUrls
      ..clear()
      ..addAll(material.material);

    if (existingMaterialUrls.isNotEmpty) {
      selectedTab = 0;
    } else if (linkController.text.trim().isNotEmpty) {
      selectedTab = 1;
    } else if (notesController.text.trim().isNotEmpty) {
      selectedTab = 2;
    } else {
      selectedTab = 0;
    }
  }

  @override
  void dispose() {
    linkController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String _formatFileSize(int bytes) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  bool _isImage(String extension) {
    return imageExtensions.contains(extension.toLowerCase());
  }

  String _extensionOf(String fileName) {
    final int dotIndex = fileName.lastIndexOf('.');

    if (dotIndex == -1) {
      return '';
    }

    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  List<Map<String, dynamic>> get classList {
    final List<Map<String, dynamic>> items = [];

    for (final TutorshipClass standard in tutorshipClasses) {
      final int? standardId = standard.standardId;

      if (standardId == null) continue;

      for (final DivisionDetails division
          in standard.division ?? <DivisionDetails>[]) {
        if (division.divisionId == null) continue;

        items.add({
          'standardId': standardId,
          'standardName': standard.standard,
          'division': division,
        });
      }
    }

    return items;
  }

  void _selectSubject(int? subjectId) {
    if (subjectId == null) return;

    final SubjectDetails subject = subjects.firstWhere(
      (item) => item.subjectId == subjectId,
    );

    setState(() {
      selectedSubjectId = subject.subjectId;
      selectedSubject = subject.subject;
    });
  }

  Future<void> _chooseFile() async {
    if (_isPickingFiles) return;

    setState(() {
      _isPickingFiles = true;
    });

    try {
      FocusScope.of(context).unfocus();

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withData: false,
      );

      // The user closed the picker.
      if (result == null || result.files.isEmpty) {
        return;
      }

      final List<PickedMaterialFile> accepted = [];

      // Names of files that were skipped, reported together at the end so
      // picking ten files cannot fire ten snackbars.
      final List<String> tooLarge = [];
      final List<String> unavailable = [];
      final List<String> duplicates = [];

      for (final PlatformFile pickedFile in result.files) {
        final String? filePath = pickedFile.path;

        if (filePath == null || filePath.isEmpty) {
          unavailable.add(pickedFile.name);
          continue;
        }

        final bool alreadyPicked =
            selectedFiles.any((item) => item.path == filePath) ||
            accepted.any((item) => item.path == filePath);

        if (alreadyPicked) {
          duplicates.add(pickedFile.name);
          continue;
        }

        final File file = File(filePath);

        if (!await file.exists()) {
          unavailable.add(pickedFile.name);
          continue;
        }

        final int fileSize = await file.length();

        if (fileSize > maxUploadSizeBytes) {
          tooLarge.add('${pickedFile.name} (${_formatFileSize(fileSize)})');
          continue;
        }

        final String extension =
            (pickedFile.extension ?? _extensionOf(pickedFile.name))
                .toLowerCase();

        accepted.add(
          PickedMaterialFile(
            file: file,
            name: pickedFile.name,
            extension: extension,
            size: fileSize,
          ),
        );
      }

      if (!mounted) return;

      if (accepted.isNotEmpty) {
        setState(() {
          selectedFiles.addAll(accepted);
        });
      }

      for (final PickedMaterialFile item in accepted) {
        debugPrint('Selected filename: ${item.name}');
        debugPrint('Selected file path: ${item.path}');
        debugPrint('Selected file size: ${_formatFileSize(item.size)}');
      }

      final List<String> skipped = [];

      if (tooLarge.isNotEmpty) {
        skipped.add('over 5 MB: ${tooLarge.join(', ')}');
      }

      if (unavailable.isNotEmpty) {
        skipped.add('not accessible: ${unavailable.join(', ')}');
      }

      if (duplicates.isNotEmpty) {
        skipped.add('already added: ${duplicates.join(', ')}');
      }

      if (skipped.isNotEmpty) {
        _showMessage('Skipped ${skipped.join(' | ')}');
      }
    } catch (error, stackTrace) {
      debugPrint('FilePicker error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage('Unable to select the file: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFiles = false;
        });
      }
    }
  }

  void _removeFileAt(int index) {
    if (index < 0 || index >= selectedFiles.length) {
      return;
    }

    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  /// Shows the tapped picture on its own screen.
  void _openImageViewer(ImageProvider image, String title) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) {
          return MaterialImageViewer(image: image, title: title);
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 180),
      ),
    );
  }

  /// A PDF or document picked here. It is already a real file on disk, so
  /// it goes straight to whichever app the device uses for that type.
  Future<void> _openDocument(PickedMaterialFile item) async {
    try {
      final OpenResult result = await OpenFilex.open(
        item.path,
        type: item.mimeType,
      );

      if (result.type != ResultType.done) {
        _showMessage('No app available to open ${item.name}');
      }
    } catch (error, stackTrace) {
      debugPrint('Open picked attachment error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to open ${item.name}');
    }
  }

  Future<void> _saveMaterial() async {
    FocusScope.of(context).unfocus();

    final String? accYear = AppData.accYear;
    final int? employeeId = AppData.employeeId;
    final int? userId = AppData.userId;

    if (accYear == null || accYear.trim().isEmpty) {
      _showMessage('Academic year is unavailable');
      return;
    }

    if (employeeId == null) {
      _showMessage('Employee ID is unavailable');
      return;
    }

    if (userId == null) {
      _showMessage('User ID is unavailable');
      return;
    }

    if (selectedSubjectId == null) {
      _showMessage('Please select Subject');
      return;
    }

    if (selectedClasses.isEmpty) {
      _showMessage('Please select at least one class');
      return;
    }

    if (selectedTab == 0) {
      if (selectedFiles.isEmpty && existingMaterialUrls.isEmpty) {
        _showMessage('Please choose at least one file');
        return;
      }

      // A file can be deleted between picking and saving.
      final List<PickedMaterialFile> missingFiles = [];

      for (final PickedMaterialFile item in selectedFiles) {
        if (!await item.file.exists()) {
          missingFiles.add(item);
        }
      }

      if (missingFiles.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          selectedFiles.removeWhere((item) => missingFiles.contains(item));
        });

        _showMessage(
          '${missingFiles.map((item) => item.name).join(', ')} '
          'is no longer available. Please choose it again.',
        );
        return;
      }

      for (final PickedMaterialFile item in selectedFiles) {
        final int fileSize = await item.file.length();

        if (fileSize > maxUploadSizeBytes) {
          _showMessage(
            '${item.name} is ${_formatFileSize(fileSize)}. '
            'Please select a file below 5 MB.',
          );
          return;
        }
      }
    }

    if (selectedTab == 1) {
      final String link = linkController.text.trim();

      if (link.isEmpty) {
        _showMessage('Please enter a link');
        return;
      }

      final Uri? uri = Uri.tryParse(link);

      if (uri == null ||
          !uri.hasScheme ||
          (uri.scheme != 'http' && uri.scheme != 'https')) {
        _showMessage(
          'Please enter a valid link starting with http:// or https://',
        );
        return;
      }
    }

    if (selectedTab == 2 && notesController.text.trim().isEmpty) {
      _showMessage('Please enter a note');
      return;
    }

    if (!mounted) return;

    // One pair for every checked class.
    final List<StandardDivisionPair> standardDivisionList = selectedClasses
        .map(
          (selectedClass) => StandardDivisionPair(
            standardId: selectedClass['standardId'] as int,
            divisionId: selectedClass['divisionId'] as int,
          ),
        )
        .toList();

    context.read<MaterialCubit>().saveMaterial(
      SaveMaterialParameter(
        materials: selectedTab == 0
            ? selectedFiles.map((item) => item.file).toList()
            : <File>[],
        staffId: employeeId,
        accYear: accYear,
        subjectId: selectedSubjectId!,
        branchId: 1,
        createdUser: userId.toString(),
        documentName: selectedTab == 0
            ? selectedFiles.map((item) => item.name).join(', ')
            : selectedTab == 1
            ? 'Link Material'
            : 'Note Material',
        notes: selectedTab == 2 ? notesController.text.trim() : '',
        link: selectedTab == 1 ? linkController.text.trim() : '',
        favorite: isFavorite,
        standardDivisionList: standardDivisionList,
      ),
    );
  }

  void _showMessage(String message, {Color backgroundColor = Colors.red}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialCubit, MaterialState>(
      listener: (context, state) {
        if (state is FetchMaterialDetailsLoading && mounted) {
          setState(() => _isFetchingEditDetails = true);
        }

        if (state is FetchMaterialDetailsSuccess && mounted) {
          setState(() => _applyMaterialDetails(state.response));
        }

        if (state is FetchMaterialDetailsFailure && mounted) {
          setState(() => _isFetchingEditDetails = false);
          _showMessage(state.message);
        }

        if (state is SaveMaterialSuccess) {
          Navigator.pop(context, true);
        }

        if (state is SaveMaterialFailure) {
          _showMessage(state.message);
        }
      },
      child: BlocBuilder<MaterialCubit, MaterialState>(
        builder: (context, materialState) {
          final bool isSaving = materialState is SaveMaterialLoading;
          final bool isBusy = isSaving || _isFetchingEditDetails;

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildTabBar(isBusy),
                  const SizedBox(height: 18),
                  Expanded(
                    child: _isFetchingEditDetails
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : tutorshipClasses.isEmpty
                        ? const Center(
                            child: Text(
                              'No class details found',
                              style: TextStyle(fontSize: 13, color: Colors.red),
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildSelectedTab(isSaving),
                          ),
                  ),
                  if (!_isFetchingEditDetails)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 58),
                      child: _buildSaveButton(isSaving),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedTab(bool isSaving) {
    switch (selectedTab) {
      case 0:
        return _buildDocumentsTab(isSaving);

      case 1:
        return _buildLinksTab(isSaving);

      case 2:
        return _buildNotesTab(isSaving);

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.isEditing ? 'Edit Material' : 'Add Material',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isSaving) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final bool isSelected = selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: isSaving
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();

                      setState(() {
                        selectedTab = index;
                      });
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDocumentsTab(bool isSaving) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadBox(isSaving),
        const SizedBox(height: 14),
        const Row(
          children: [
            Icon(Icons.info, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Allowed: PDF, DOC, DOCX, JPG and PNG',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildClassFields(isSaving),
      ],
    );
  }

  Widget _buildLinksTab(bool isSaving) {
    return Column(
      children: [
        _buildClassFields(isSaving),
        const SizedBox(height: 14),
        _buildTextField(
          controller: linkController,
          hint: 'Link',
          height: 48,
          maxLines: 1,
          enabled: !isSaving,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildNotesTab(bool isSaving) {
    return Column(
      children: [
        _buildClassFields(isSaving),
        const SizedBox(height: 14),
        _buildTextField(
          controller: notesController,
          hint: 'Enter your note here',
          height: 250,
          maxLines: 15,
          enabled: !isSaving,
          showBoldIcon: true,
        ),
      ],
    );
  }

  Widget _buildClassFields(bool isSaving) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField<int>(
          hint: 'Subject',
          value: selectedSubjectId,
          items: subjects.map((item) {
            return DropdownMenuItem<int>(
              value: item.subjectId,
              child: Text(item.subject ?? ''),
            );
          }).toList(),
          onChanged: isSaving ? null : _selectSubject,
          isRequired: true,
        ),
        const SizedBox(height: 18),
        const Text(
          'Select Your Classes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        _buildClassCheckboxes(isSaving),
      ],
    );
  }

  Widget _buildClassCheckboxes(bool isSaving) {
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
        crossAxisSpacing: 28,
      ),
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = items[index];

        final int standardId = item['standardId'] as int;

        final String standardName = item['standardName'] as String? ?? '';

        final DivisionDetails division = item['division'] as DivisionDetails;

        final bool isSelected = selectedClasses.any(
          (e) =>
              e['standardId'] == standardId &&
              e['divisionId'] == division.divisionId,
        );

        return Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: isSelected,
                onChanged: isSaving
                    ? null
                    : (value) {
                        FocusScope.of(context).unfocus();

                        setState(() {
                          if (value == true) {
                            selectedClasses.add({
                              'standardId': standardId,
                              'divisionId': division.divisionId,
                            });
                          } else {
                            selectedClasses.removeWhere(
                              (e) =>
                                  e['standardId'] == standardId &&
                                  e['divisionId'] == division.divisionId,
                            );
                          }
                        });
                      },
                activeColor: const Color(0xff8f83dc),
                checkColor: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$standardName ${division.division ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? const Color(0xff7d6dff) : Colors.black87,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Empty: the upload prompt. With files: a row of thumbnails inside the
  /// same dashed box, images shown as pictures.
  Widget _buildUploadBox(bool isSaving) {
    final bool hasFiles =
        existingMaterialUrls.isNotEmpty || selectedFiles.isNotEmpty;

    return CustomPaint(
      painter: DashedBorderPainter(),
      child: SizedBox(
        width: double.infinity,
        height: 108,
        child: !hasFiles
            ? _buildEmptyUploadBox(isSaving)
            : _buildFilePreviews(isSaving),
      ),
    );
  }

  Widget _buildEmptyUploadBox(bool isSaving) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSaving || _isPickingFiles ? null : _chooseFile,
      child: Container(
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isPickingFiles)
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            else
              Icon(
                Icons.cloud_upload_outlined,
                color: Colors.blue.shade600,
                size: 28,
              ),
            const SizedBox(height: 4),
            Text(
              _isPickingFiles ? 'Selecting...' : 'Choose File',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
                decoration: _isPickingFiles
                    ? TextDecoration.none
                    : TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'You can select more than one file',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreviews(bool isSaving) {
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        children: [
          for (int index = 0; index < existingMaterialUrls.length; index++)
            _existingFileTile(existingMaterialUrls[index], index, isSaving),
          for (int index = 0; index < selectedFiles.length; index++)
            _fileTile(
              preview: _filePreview(selectedFiles[index]),
              onTap: _isImage(selectedFiles[index].extension)
                  ? () => _openImageViewer(
                      FileImage(selectedFiles[index].file),
                      selectedFiles[index].name,
                    )
                  : () => _openDocument(selectedFiles[index]),
              onRemove: isSaving ? null : () => _removeFileAt(index),
            ),
          _addMoreTile(isSaving),
        ],
      ),
    );
  }

  Widget _existingFileTile(String url, int index, bool isSaving) {
    final Uri? uri = Uri.tryParse(url);
    final String name = uri != null && uri.pathSegments.isNotEmpty
        ? Uri.decodeComponent(uri.pathSegments.last)
        : 'Attachment ${index + 1}';
    final String extension = _extensionOf(name);
    final bool isImage = _isImage(extension);

    return _fileTile(
      preview: isImage
          ? Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    ),
              errorBuilder: (_, __, ___) => _fileIconPreview(extension),
            )
          : _fileIconPreview(
              extension,
              label: extension.isEmpty ? 'FILE' : extension,
            ),
      onTap: isImage
          ? () => _openImageViewer(NetworkImage(url), name)
          : () => _showMessage(
              'Existing document: $name',
              backgroundColor: primaryColor,
            ),
      onRemove: isSaving
          ? null
          : () => setState(() => existingMaterialUrls.removeAt(index)),
    );
  }

  /// Picked file: the picture itself for images, an icon otherwise.
  Widget _filePreview(PickedMaterialFile item) {
    if (_isImage(item.extension)) {
      return Image.file(
        item.file,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fileIconPreview(item.extension),
      );
    }

    return _fileIconPreview(item.extension, label: item.extension);
  }

  Widget _fileIconPreview(String extension, {String? label}) {
    return Container(
      color: fieldColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(extension), size: 26, color: primaryColor),
          if ((label ?? extension).isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              (label ?? extension).toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xff5C5C5C),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _fileTile({
    required Widget preview,
    required VoidCallback? onRemove,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: SizedBox(
        width: 74,
        child: Stack(
          children: [
            // Tapping opens the file: pictures full screen, PDFs and
            // documents in the device's own viewer. It never reopens the
            // file picker; that is the Add tile's job.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    decoration: BoxDecoration(
                      color: fieldColor,
                      border: Border.all(
                        color: tileBorderColor.withOpacity(0.6),
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: preview,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMoreTile(bool isSaving) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSaving || _isPickingFiles ? null : _chooseFile,
      child: SizedBox(
        width: 74,
        child: MaterialDottedTileBorder(
          color: tileBorderColor,
          child: Center(
            child: _isPickingFiles
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 22, color: primaryColor),
                      SizedBox(height: 3),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xff5C5C5C),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// This screen's own dropdown-style field: flat 46px, no outline. Only the
  /// option sheet is shared — see showOptionPickerSheet.
  Widget _buildDropdownField<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
    bool isRequired = false,
  }) {
    // Null when the saved value is no longer in the list, which falls back
    // to showing the hint.
    final DropdownMenuItem<T>? selected = selectedItemOf(items, value);

    final bool isEnabled = onChanged != null && items.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !isEnabled
          ? null
          : () async {
              final PickerSelection<T>? picked = await showOptionPickerSheet<T>(
                context: context,
                title: 'Select $hint',
                items: items,
                selectedValue: value,
              );

              if (picked == null) return;

              onChanged(picked.value);
            },
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: selected == null
                  ? _requiredText(hint, isRequired)
                  : DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 13,
                        color: isEnabled ? Colors.black : Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: selected.child,
                    ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isEnabled ? Colors.black54 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _requiredText(String text, bool isRequired) {
    if (!isRequired) {
      return Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black),
      );
    }

    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 13, color: Colors.black),
        children: const [
          TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double height,
    required int maxLines,
    required bool enabled,
    TextInputType? keyboardType,
    bool showBoldIcon = false,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Colors.black87),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          suffixIcon: showBoldIcon
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, right: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isSaving) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.65),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: isSaving ? null : _saveMaterial,
        child: isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Text(
                widget.isEditing ? 'Update' : 'Save',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// Full screen look at one picked picture. Pinch or double tap to zoom,
/// tap the backdrop or the close button to come back.
class MaterialImageViewer extends StatelessWidget {
  final ImageProvider image;
  final String title;

  const MaterialImageViewer({super.key, required this.image, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                          size: 44,
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
}

/// Dashed outline for the small "Add" tile.
class MaterialDottedTileBorder extends StatelessWidget {
  final Color color;
  final Widget child;

  const MaterialDottedTileBorder({
    super.key,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TileDashPainter(color: color),
      child: child,
    );
  }
}

class _TileDashPainter extends CustomPainter {
  final Color color;

  const _TileDashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 5;
    const double dashSpace = 4;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(7),
        ),
      );

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double endDistance = (distance + dashWidth)
            .clamp(0.0, metric.length)
            .toDouble();

        canvas.drawPath(metric.extractPath(distance, endDistance), paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TileDashPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 7;
    const double dashSpace = 5;

    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    final Path path = Path()..addRRect(roundedRect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double endDistance = (distance + dashWidth)
            .clamp(0.0, metric.length)
            .toDouble();

        canvas.drawPath(metric.extractPath(distance, endDistance), paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
