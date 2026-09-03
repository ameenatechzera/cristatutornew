// import 'dart:io';
// import 'dart:ui';

// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
// import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
// import 'package:file_picker/file_picker.dart';

// // Change these imports if your material folder path is different.

// import 'package:flutter/material.dart' hide MaterialState;
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AddMaterialPage extends StatefulWidget {
//   const AddMaterialPage({super.key});

//   @override
//   State<AddMaterialPage> createState() => _AddMaterialPageState();
// }

// class _AddMaterialPageState extends State<AddMaterialPage> {
//   static const Color primaryColor = Color(0xFF9B73E6);
//   static const Color fieldColor = Color(0xFFF0F4FF);
//   static const Color darkColor = Colors.black;
//   static const int maxUploadSizeBytes = 5 * 1024 * 1024;

//   int selectedTab = 0;
//   File? selectedFile;

//   final List<String> tabs = const ['Documents', 'Links', 'Notes'];

//   final TextEditingController linkController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();

//   List<TutorshipClass> tutorshipClasses = [];
//   List<DivisionDetails> divisions = [];
//   List<SubjectDetails> subjects = [];

//   int? selectedStandardId;
//   int? selectedDivisionId;
//   int? selectedSubjectId;

//   String? selectedStandard;
//   String? selectedDivision;
//   String? selectedSubject;

//   // Connect these with FilePicker when uploading is implemented.
//   String? selectedFileName;
//   String? selectedFilePath;

//   String _formatFileSize(int bytes) {
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
//   }

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchTutorshipClasses();
//     });
//   }

//   @override
//   void dispose() {
//     linkController.dispose();
//     notesController.dispose();
//     super.dispose();
//   }

//   void _fetchTutorshipClasses() {
//     context.read<AuthenticationCubit>().fetchTutorshipClass(
//       FetchTutorshipClassRequest(
//         accyear: AppData.accYear,
//         employeeId: AppData.employeeId,
//         userId: AppData.userId,
//       ),
//     );
//   }

//   List<TutorshipClass> get standards {
//     final Map<int, TutorshipClass> uniqueStandards = {};

//     for (final TutorshipClass item in tutorshipClasses) {
//       final int? standardId = item.standardId;

//       if (standardId != null) {
//         uniqueStandards[standardId] = item;
//       }
//     }

//     return uniqueStandards.values.toList();
//   }

//   void _selectStandard(int? standardId) {
//     if (standardId == null) return;

//     final TutorshipClass standard = tutorshipClasses.firstWhere(
//       (item) => item.standardId == standardId,
//     );

//     setState(() {
//       selectedStandardId = standard.standardId;
//       selectedStandard = standard.standard;

//       divisions = standard.division ?? [];
//       subjects = [];

//       selectedDivisionId = null;
//       selectedDivision = null;

//       selectedSubjectId = null;
//       selectedSubject = null;
//     });
//   }

//   void _selectDivision(int? divisionId) {
//     if (divisionId == null) return;

//     final DivisionDetails division = divisions.firstWhere(
//       (item) => item.divisionId == divisionId,
//     );

//     setState(() {
//       selectedDivisionId = division.divisionId;
//       selectedDivision = division.division;

//       subjects = division.subject ?? [];

//       selectedSubjectId = null;
//       selectedSubject = null;
//     });
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
//     try {
//       FocusScope.of(context).unfocus();

//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//         allowMultiple: false,
//         withData: false,
//       );

//       // The user closed the picker.
//       if (result == null || result.files.isEmpty) {
//         return;
//       }

//       final PlatformFile pickedFile = result.files.first;
//       final String? filePath = pickedFile.path;

//       if (filePath == null || filePath.isEmpty) {
//         _showMessage('Unable to access the selected file');
//         return;
//       }

//       final File file = File(filePath);

//       if (!await file.exists()) {
//         _showMessage('The selected file is no longer available');
//         return;
//       }

//       final int fileSize = await file.length();

//       if (fileSize > maxUploadSizeBytes) {
//         _showMessage(
//           '${pickedFile.name} is ${_formatFileSize(fileSize)}. '
//           'Please select a file below 5 MB.',
//         );
//         return;
//       }

//       if (!mounted) return;

//       setState(() {
//         selectedFile = file;
//         selectedFileName = pickedFile.name;
//         selectedFilePath = filePath;
//       });

//       debugPrint('Selected filename: ${pickedFile.name}');
//       debugPrint('Selected file path: $filePath');
//       debugPrint('Selected file size: ${_formatFileSize(fileSize)}');
//     } catch (error, stackTrace) {
//       debugPrint('FilePicker error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       if (!mounted) return;

//       _showMessage('Unable to select the file: $error');
//     }
//   }

//   String get _selectedNotes =>
//       selectedTab == 2 ? notesController.text.trim() : '';

//   Future<void> _saveMaterial() async {
//     FocusScope.of(context).unfocus();

//     final String? accYear = AppData.accYear;
//     final int? employeeId = AppData.employeeId;
//     final int? branchId = AppData.branchId;
//     final int? userId = AppData.userId;
//     final File? uploadFile = selectedFile;

//     if (accYear == null || accYear.trim().isEmpty) {
//       _showMessage('Academic year is unavailable');
//       return;
//     }

//     if (employeeId == null) {
//       _showMessage('Employee ID is unavailable');
//       return;
//     }

//     // if (branchId == null) {
//     //   _showMessage('Branch ID is unavailable');
//     //   return;
//     // }

//     if (userId == null) {
//       _showMessage('User ID is unavailable');
//       return;
//     }

//     if (selectedStandardId == null) {
//       _showMessage('Please select Standard');
//       return;
//     }

//     if (selectedDivisionId == null) {
//       _showMessage('Please select Division');
//       return;
//     }

//     if (selectedSubjectId == null) {
//       _showMessage('Please select Subject');
//       return;
//     }

//     if (selectedTab == 0) {
//       if (uploadFile == null) {
//         _showMessage('Please choose a file');
//         return;
//       }

//       if (!await uploadFile.exists()) {
//         if (!mounted) return;

//         setState(() {
//           selectedFile = null;
//           selectedFileName = null;
//           selectedFilePath = null;
//         });

//         _showMessage(
//           'The selected file is unavailable. Please choose it again.',
//         );
//         return;
//       }

//       final int fileSize = await uploadFile.length();

//       if (fileSize > maxUploadSizeBytes) {
//         _showMessage(
//           'The selected file is ${_formatFileSize(fileSize)}. '
//           'Please select a file below 5 MB.',
//         );
//         return;
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

//     context.read<MaterialCubit>().saveMaterial(
//       SaveMaterialParameter(
//         materials: selectedTab == 0 && uploadFile != null
//             ? <File>[uploadFile]
//             : <File>[],
//         staffId: employeeId,
//         accYear: accYear,
//         standardId: selectedStandardId!,
//         divisionId: selectedDivisionId!,
//         subjectId: selectedSubjectId!,
//         branchId: 1,
//         createdUser: userId.toString(),
//         documentName: selectedTab == 0
//             ? selectedFileName ?? ''
//             : selectedTab == 1
//             ? 'Link Material'
//             : 'Note Material',
//         notes: _selectedNotes,
//         link: selectedTab == 1 ? linkController.text.trim() : '',
//         favorite: false,
//       ),
//     );
//   }

//   void _clearForm() {
//     linkController.clear();
//     notesController.clear();

//     setState(() {
//       selectedTab = 0;

//       selectedStandardId = null;
//       selectedStandard = null;

//       selectedDivisionId = null;
//       selectedDivision = null;

//       selectedSubjectId = null;
//       selectedSubject = null;

//       divisions = [];
//       subjects = [];

//       selectedFile = null;
//       selectedFileName = null;
//       selectedFilePath = null;
//     });
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
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AuthenticationCubit, AuthenticationState>(
//           listenWhen: (previous, current) {
//             return current is FetchTutorshipClassSuccess;
//           },
//           listener: (context, state) {
//             if (state is FetchTutorshipClassSuccess) {
//               setState(() {
//                 tutorshipClasses = state.response.data?.tutorshipClass ?? [];

//                 divisions = [];
//                 subjects = [];

//                 selectedStandardId = null;
//                 selectedStandard = null;

//                 selectedDivisionId = null;
//                 selectedDivision = null;

//                 selectedSubjectId = null;
//                 selectedSubject = null;
//               });
//             }
//           },
//         ),
//         BlocListener<MaterialCubit, MaterialState>(
//           listener: (context, state) {
//             // if (state is SaveMaterialSuccess) {
//             //   // _showMessage(
//             //   //   'Material saved successfully',
//             //   //   backgroundColor: Colors.green,
//             //   // );

//             //   // _clearForm();
//             //   if (!mounted) return;

//             //   Navigator.of(context).pop(true);
//             // }
//             if (state is SaveMaterialSuccess) {
//               Navigator.pop(context, true);
//             }
//             if (state is SaveMaterialFailure) {
//               _showMessage(state.message);

//               // Use this if the screen should close after success:
//               // Navigator.pop(context, true);
//             }

//             if (state is SaveMaterialFailure) {
//               _showMessage(state.message);
//             }
//           },
//         ),
//       ],
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
//                     child:
//                         BlocBuilder<AuthenticationCubit, AuthenticationState>(
//                           builder: (context, authenticationState) {
//                             if (authenticationState
//                                     is FetchTutorshipClassLoading &&
//                                 tutorshipClasses.isEmpty) {
//                               return const Center(
//                                 child: CircularProgressIndicator(
//                                   color: primaryColor,
//                                 ),
//                               );
//                             }

//                             if (authenticationState
//                                     is FetchTutorshipClassFailure &&
//                                 tutorshipClasses.isEmpty) {
//                               return _ApiErrorView(
//                                 message: authenticationState.message,
//                                 onRetry: _fetchTutorshipClasses,
//                               );
//                             }

//                             if (tutorshipClasses.isEmpty) {
//                               return _ApiErrorView(
//                                 message: 'No class details found',
//                                 onRetry: _fetchTutorshipClasses,
//                               );
//                             }

//                             return SingleChildScrollView(
//                               physics: const BouncingScrollPhysics(),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                               ),
//                               child: _buildSelectedTab(isSaving),
//                             );
//                           },
//                         ),
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
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: _buildDropdownField<int>(
//                 hint: 'Standard',
//                 value: selectedStandardId,
//                 items: standards.map((item) {
//                   return DropdownMenuItem<int>(
//                     value: item.standardId,
//                     child: Text(
//                       item.standard ?? '',
//                       style: const TextStyle(fontSize: 13),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: isSaving ? null : _selectStandard,
//                 isRequired: true,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: _buildDropdownField<int>(
//                 hint: 'Division',
//                 value: selectedDivisionId,
//                 items: divisions.map((item) {
//                   return DropdownMenuItem<int>(
//                     value: item.divisionId,
//                     child: Text(
//                       item.division ?? '',
//                       style: const TextStyle(fontSize: 13),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: isSaving || selectedStandardId == null
//                     ? null
//                     : _selectDivision,
//                 isRequired: true,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         _buildDropdownField<int>(
//           hint: 'Subject',
//           value: selectedSubjectId,
//           items: subjects.map((item) {
//             return DropdownMenuItem<int>(
//               value: item.subjectId,
//               child: Text(
//                 item.subject ?? '',
//                 style: const TextStyle(fontSize: 13),
//               ),
//             );
//           }).toList(),
//           onChanged: isSaving || selectedDivisionId == null
//               ? null
//               : _selectSubject,
//           isRequired: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildUploadBox(bool isSaving) {
//     final bool hasSelectedFile = selectedFile != null;

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: isSaving ? null : _chooseFile,
//       child: CustomPaint(
//         painter: DashedBorderPainter(),
//         child: Container(
//           width: double.infinity,
//           height: 108,
//           decoration: BoxDecoration(
//             color: fieldColor,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   hasSelectedFile
//                       ? Icons.check_circle_outline
//                       : Icons.cloud_upload_outlined,
//                   color: hasSelectedFile ? Colors.green : Colors.blue.shade600,
//                   size: 28,
//                 ),
//                 const SizedBox(height: 4),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     selectedFileName ?? 'Choose File',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: hasSelectedFile
//                           ? Colors.green.shade700
//                           : Colors.blue.shade700,
//                       decoration: hasSelectedFile
//                           ? TextDecoration.none
//                           : TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//                 if (hasSelectedFile) ...[
//                   const SizedBox(height: 5),
//                   Text(
//                     'Tap to change file',
//                     style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField<T>({
//     required String hint,
//     required T? value,
//     required List<DropdownMenuItem<T>> items,
//     required ValueChanged<T?>? onChanged,
//     bool isRequired = false,
//   }) {
//     final bool hasValidValue =
//         value == null || items.any((item) => item.value == value);

//     return Container(
//       height: 46,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: fieldColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<T>(
//           value: hasValidValue ? value : null,
//           isExpanded: true,
//           icon: const Icon(
//             Icons.keyboard_arrow_down_rounded,
//             color: Colors.black54,
//           ),
//           hint: _requiredText(hint, isRequired),
//           items: items,
//           onChanged: onChanged,
//           dropdownColor: Colors.white,
//           borderRadius: BorderRadius.circular(8),
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

// class _ApiErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const _ApiErrorView({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 13, color: Colors.red),
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: onRetry,
//               child: const Text(
//                 'Retry',
//                 style: TextStyle(color: Color(0xFF9B73E6)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
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
import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMaterialPage extends StatefulWidget {
  const AddMaterialPage({super.key});

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  static const Color primaryColor = Color(0xFF9B73E6);
  static const Color fieldColor = Color(0xFFF0F4FF);
  static const Color darkColor = Colors.black;
  static const int maxUploadSizeBytes = 5 * 1024 * 1024;

  int selectedTab = 0;
  File? selectedFile;

  final List<String> tabs = const ['Documents', 'Links', 'Notes'];

  final TextEditingController linkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<TutorshipClass> tutorshipClasses = [];
  List<DivisionDetails> divisions = [];
  List<SubjectDetails> subjects = [];

  int? selectedStandardId;
  int? selectedDivisionId;
  int? selectedSubjectId;

  String? selectedStandard;
  String? selectedDivision;
  String? selectedSubject;

  String? selectedFileName;
  String? selectedFilePath;

  @override
  void initState() {
    super.initState();

    tutorshipClasses = List<TutorshipClass>.from(AppData.standards);

    if (tutorshipClasses.isNotEmpty) {
      final TutorshipClass firstStandard = tutorshipClasses.first;

      selectedStandardId = firstStandard.standardId;
      selectedStandard = firstStandard.standard;

      divisions = List<DivisionDetails>.from(
        firstStandard.division ?? <DivisionDetails>[],
      );

      if (divisions.isNotEmpty) {
        final DivisionDetails firstDivision = divisions.first;

        selectedDivisionId = firstDivision.divisionId;
        selectedDivision = firstDivision.division;

        subjects = List<SubjectDetails>.from(
          firstDivision.subject ?? <SubjectDetails>[],
        );

        if (subjects.isNotEmpty) {
          final SubjectDetails firstSubject = subjects.first;

          selectedSubjectId = firstSubject.subjectId;
          selectedSubject = firstSubject.subject;
        }
      }
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

  List<TutorshipClass> get standards {
    final Map<int, TutorshipClass> uniqueStandards = {};

    for (final TutorshipClass item in tutorshipClasses) {
      final int? standardId = item.standardId;

      if (standardId != null) {
        uniqueStandards[standardId] = item;
      }
    }

    return uniqueStandards.values.toList();
  }

  void _selectStandard(int? standardId) {
    if (standardId == null) return;

    final TutorshipClass standard = tutorshipClasses.firstWhere(
      (item) => item.standardId == standardId,
    );

    setState(() {
      selectedStandardId = standard.standardId;
      selectedStandard = standard.standard;

      divisions = standard.division ?? [];
      subjects = [];

      selectedDivisionId = null;
      selectedDivision = null;

      selectedSubjectId = null;
      selectedSubject = null;
    });
  }

  void _selectDivision(int? divisionId) {
    if (divisionId == null) return;

    final DivisionDetails division = divisions.firstWhere(
      (item) => item.divisionId == divisionId,
    );

    setState(() {
      selectedDivisionId = division.divisionId;
      selectedDivision = division.division;

      subjects = division.subject ?? [];

      selectedSubjectId = null;
      selectedSubject = null;
    });
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
    try {
      FocusScope.of(context).unfocus();

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final PlatformFile pickedFile = result.files.first;
      final String? filePath = pickedFile.path;

      if (filePath == null || filePath.isEmpty) {
        _showMessage('Unable to access the selected file');
        return;
      }

      final File file = File(filePath);

      if (!await file.exists()) {
        _showMessage('The selected file is no longer available');
        return;
      }

      final int fileSize = await file.length();

      if (fileSize > maxUploadSizeBytes) {
        _showMessage(
          '${pickedFile.name} is ${_formatFileSize(fileSize)}. '
          'Please select a file below 5 MB.',
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        selectedFile = file;
        selectedFileName = pickedFile.name;
        selectedFilePath = filePath;
      });

      debugPrint('Selected filename: ${pickedFile.name}');
      debugPrint('Selected file path: $filePath');
      debugPrint('Selected file size: ${_formatFileSize(fileSize)}');
    } catch (error, stackTrace) {
      debugPrint('FilePicker error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage('Unable to select the file: $error');
    }
  }

  Future<void> _saveMaterial() async {
    FocusScope.of(context).unfocus();

    final String? accYear = AppData.accYear;
    final int? employeeId = AppData.employeeId;
    final int? userId = AppData.userId;
    final File? uploadFile = selectedFile;

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

    if (selectedStandardId == null) {
      _showMessage('Please select Standard');
      return;
    }

    if (selectedDivisionId == null) {
      _showMessage('Please select Division');
      return;
    }

    if (selectedSubjectId == null) {
      _showMessage('Please select Subject');
      return;
    }

    if (selectedTab == 0) {
      if (uploadFile == null) {
        _showMessage('Please choose a file');
        return;
      }

      if (!await uploadFile.exists()) {
        if (!mounted) return;

        setState(() {
          selectedFile = null;
          selectedFileName = null;
          selectedFilePath = null;
        });

        _showMessage(
          'The selected file is unavailable. Please choose it again.',
        );
        return;
      }

      final int fileSize = await uploadFile.length();

      if (fileSize > maxUploadSizeBytes) {
        _showMessage(
          'The selected file is ${_formatFileSize(fileSize)}. '
          'Please select a file below 5 MB.',
        );
        return;
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

    context.read<MaterialCubit>().saveMaterial(
      SaveMaterialParameter(
        materials: selectedTab == 0 && uploadFile != null
            ? <File>[uploadFile]
            : <File>[],
        staffId: employeeId,
        accYear: accYear,
        standardId: selectedStandardId!,
        divisionId: selectedDivisionId!,
        subjectId: selectedSubjectId!,
        branchId: AppData.branchId ?? 1,
        createdUser: userId.toString(),
        documentName: selectedTab == 0
            ? selectedFileName ?? ''
            : selectedTab == 1
            ? 'Link Material'
            : 'Note Material',
        notes: selectedTab == 2 ? notesController.text.trim() : '',
        link: selectedTab == 1 ? linkController.text.trim() : '',
        favorite: false,
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

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildTabBar(isSaving),
                  const SizedBox(height: 18),
                  Expanded(
                    child: tutorshipClasses.isEmpty
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
          const Expanded(
            child: Center(
              child: Text(
                'Add Material',
                style: TextStyle(
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
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<int>(
                hint: 'Standard',
                value: selectedStandardId,
                items: standards.map((item) {
                  return DropdownMenuItem<int>(
                    value: item.standardId,
                    child: Text(
                      item.standard ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: isSaving ? null : _selectStandard,
                isRequired: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDropdownField<int>(
                hint: 'Division',
                value: selectedDivisionId,
                items: divisions.map((item) {
                  return DropdownMenuItem<int>(
                    value: item.divisionId,
                    child: Text(
                      item.division ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: isSaving || selectedStandardId == null
                    ? null
                    : _selectDivision,
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDropdownField<int>(
          hint: 'Subject',
          value: selectedSubjectId,
          items: subjects.map((item) {
            return DropdownMenuItem<int>(
              value: item.subjectId,
              child: Text(
                item.subject ?? '',
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: isSaving || selectedDivisionId == null
              ? null
              : _selectSubject,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildUploadBox(bool isSaving) {
    final bool hasSelectedFile = selectedFile != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSaving ? null : _chooseFile,
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          height: 108,
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasSelectedFile
                      ? Icons.check_circle_outline
                      : Icons.cloud_upload_outlined,
                  color: hasSelectedFile ? Colors.green : Colors.blue.shade600,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    selectedFileName ?? 'Choose File',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasSelectedFile
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                      decoration: hasSelectedFile
                          ? TextDecoration.none
                          : TextDecoration.underline,
                    ),
                  ),
                ),
                if (hasSelectedFile) ...[
                  const SizedBox(height: 5),
                  Text(
                    'Tap to change file',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDropdownField<T>({
  //   required String hint,
  //   required T? value,
  //   required List<DropdownMenuItem<T>> items,
  //   required ValueChanged<T?>? onChanged,
  //   bool isRequired = false,
  // }) {
  //   final bool hasValidValue =
  //       value == null || items.any((item) => item.value == value);

  //   return Container(
  //     height: 46,
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: fieldColor,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<T>(
  //         value: hasValidValue ? value : null,
  //         isExpanded: true,
  //         icon: const Icon(
  //           Icons.keyboard_arrow_down_rounded,
  //           color: Colors.black54,
  //         ),
  //         hint: _requiredText(hint, isRequired),
  //         items: items,
  //         onChanged: onChanged,
  //         dropdownColor: Colors.white,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildDropdownField<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
    bool isRequired = false,
  }) {
    final DropdownMenuItem<T>? selectedItem = selectedItemOf<T>(items, value);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null
          ? null
          : () async {
              final PickerSelection<T>? result = await showOptionPickerSheet<T>(
                context: context,
                title: 'Select $hint',
                items: items,
                selectedValue: value,
              );

              if (!mounted || result == null) {
                return;
              }

              onChanged(result.value);
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
              child: selectedItem != null
                  ? DefaultTextStyle(
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: selectedItem.child,
                    )
                  : _requiredText(hint, isRequired),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black54,
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
            : const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
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
