// import 'dart:io';

// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';
// import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';

// class AddFeedScreen extends StatefulWidget {
//   const AddFeedScreen({super.key});

//   @override
//   State<AddFeedScreen> createState() => _AddFeedScreenState();
// }

// class _AddFeedScreenState extends State<AddFeedScreen> {
//   final TextEditingController captionController = TextEditingController();
//   final List<Map<String, dynamic>> selectedClasses = [];
//   File? selectedFile;
//   String? selectedFileName;
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchTutorshipClasses();
//     });
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

//   @override
//   void dispose() {
//     captionController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
//       );

//       if (result == null || result.files.isEmpty) {
//         return;
//       }

//       final pickedFile = result.files.single;

//       if (pickedFile.path == null) {
//         _showMessage('Unable to access selected file');
//         return;
//       }

//       setState(() {
//         selectedFile = File(pickedFile.path!);
//         selectedFileName = pickedFile.name;
//       });

//       debugPrint('======================================');
//       debugPrint('📎 FILE SELECTED');
//       debugPrint('Name: ${pickedFile.name}');
//       debugPrint('Path: ${pickedFile.path}');
//       debugPrint('Size: ${pickedFile.size}');
//       debugPrint('======================================');
//     } catch (e) {
//       debugPrint('❌ File picker error: $e');
//       _showMessage('Unable to select file');
//     }
//   }

//   void _showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<FeedCubit, FeedState>(
//       listener: (context, state) {
//         if (state is SaveFeedSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 state.response.message ?? "Feed Saved Successfully",
//               ),
//             ),
//           );

//           Navigator.pop(context, true);
//         }

//         if (state is SaveFeedFailure) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: Colors.white,

//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             surfaceTintColor: Colors.white,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             title: const Text(
//               "Add  Feed",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),

//           body: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: _pickFile,
//                   child: CustomPaint(
//                     painter: DashedBorderPainter(
//                       color: Colors.black54,
//                       strokeWidth: 1.2,
//                       radius: 12,
//                       dashWidth: 7,
//                       dashSpace: 6,
//                     ),
//                     child: Container(
//                       width: double.infinity,
//                       height: 150,
//                       decoration: BoxDecoration(
//                         color: const Color(0xffeef3ff),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icons/Group (9).svg',
//                             // width: 14,
//                             // height: 14,
//                             colorFilter: const ColorFilter.mode(
//                               Color(0xff2E5CE9), // Your desired color
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           Text(
//                             "Choose File",
//                             style: TextStyle(
//                               color: Color(0xff1f60ff),
//                               fontSize: 11,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Color(0xff1f60ff),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 17),

//                 Container(
//                   width: double.infinity,
//                   height: 150,
//                   padding: const EdgeInsets.fromLTRB(12, 5, 12, 10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xffeef3ff),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Stack(
//                     children: [
//                       TextField(
//                         controller: captionController,
//                         maxLines: null,
//                         expands: true,
//                         textAlignVertical: TextAlignVertical.top,
//                         decoration: const InputDecoration(
//                           hintText: "Add A Caption",
//                           hintStyle: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(right: 28, top: 0),
//                         ),
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                         ),
//                       ),

//                       Positioned(
//                         top: 5,
//                         right: 2,
//                         child: Container(
//                           width: 13,
//                           height: 13,
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(3),
//                           ),
//                           child: Center(
//                             child: SvgPicture.asset(
//                               'assets/icons/Group (8).svg',
//                               width: 14,
//                               height: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 23),

//                 const Text(
//                   "Select You Classes",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 BlocBuilder<AuthenticationCubit, AuthenticationState>(
//                   builder: (context, state) {
//                     if (state is FetchTutorshipClassLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (state is FetchTutorshipClassSuccess) {
//                       final classes = state.response.data?.tutorshipClass ?? [];
//                       final List<Map<String, dynamic>> classList = [];

//                       for (final standard in classes) {
//                         for (final division in standard.division ?? []) {
//                           classList.add({
//                             "standardId": standard.standardId,
//                             "standardName": standard.standard,
//                             "division": division,
//                           });
//                         }
//                       }
//                       return GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: classList.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               mainAxisExtent: 46,
//                               crossAxisSpacing: 28,
//                             ),
//                         itemBuilder: (context, index) {
//                           final item = classList[index];

//                           final int standardId = item["standardId"];
//                           final String standardName = item["standardName"];

//                           final DivisionDetails division =
//                               item["division"] as DivisionDetails;
//                           final isSelected = selectedClasses.any(
//                             (e) =>
//                                 e["standardId"] == standardId &&
//                                 e["divisionId"] == division.divisionId,
//                           );

//                           return Row(
//                             children: [
//                               SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: Checkbox(
//                                   value: isSelected,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         selectedClasses.add({
//                                           "standardId": standardId,
//                                           "divisionId": division.divisionId,
//                                         });
//                                       } else {
//                                         selectedClasses.removeWhere(
//                                           (e) =>
//                                               e["standardId"] == standardId &&
//                                               e["divisionId"] ==
//                                                   division.divisionId,
//                                         );
//                                       }
//                                     });
//                                   },
//                                   activeColor: const Color(0xff8f83dc),
//                                   checkColor: Colors.black,
//                                 ),
//                               ),

//                               const SizedBox(width: 8),

//                               Expanded(
//                                 child: Text(
//                                   "$standardName ${division.division}",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: isSelected
//                                         ? const Color(0xff7d6dff)
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }

//                     return const SizedBox();
//                   },
//                 ),

//                 const SizedBox(height: 28),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (captionController.text.trim().isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Please enter feed caption"),
//                           ),
//                         );
//                         return;
//                       }

//                       if (selectedClasses.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Please select at least one class"),
//                           ),
//                         );
//                         return;
//                       }

//                       context.read<FeedCubit>().saveFeed(
//                         SaveFeedParameter(
//                           feedText: captionController.text.trim(),
//                           feedTarget: "Student",
//                           standardId: selectedClasses
//                               .map(
//                                 (e) => FeedStandardParameter(
//                                   standardId: e["standardId"],
//                                   divisionId: e["divisionId"],
//                                 ),
//                               )
//                               .toList(),
//                           userId: AppData.userId.toString(),
//                           branchId: AppData.branchId ?? 1,
//                           createdUser: AppData.userId.toString(),
//                           accYear: AppData.accYear ?? '1',
//                           feedMasterFiles: selectedFile == null
//                               ? []
//                               : [
//                                   FeedMasterFileParameter(
//                                     file: selectedFile!.path,
//                                   ),
//                                 ],
//                           //feedMasterFiles: [],
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff9b78dc),
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class DashedBorderPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double radius;
//   final double dashWidth;
//   final double dashSpace;

//   DashedBorderPainter({
//     required this.color,
//     required this.strokeWidth,
//     required this.radius,
//     required this.dashWidth,
//     required this.dashSpace,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;

//     final rect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Radius.circular(radius),
//     );

//     final path = Path()..addRRect(rect);
//     final pathMetrics = path.computeMetrics();

//     for (final metric in pathMetrics) {
//       double distance = 0;

//       while (distance < metric.length) {
//         final nextDistance = distance + dashWidth;
//         final dashPath = metric.extractPath(
//           distance,
//           nextDistance.clamp(0, metric.length),
//         );

//         canvas.drawPath(dashPath, paint);
//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
// import 'dart:io';
// import 'dart:ui';

// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';
// import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';

// class AddFeedScreen extends StatefulWidget {
//   const AddFeedScreen({super.key});

//   @override
//   State<AddFeedScreen> createState() => _AddFeedScreenState();
// }

// class _AddFeedScreenState extends State<AddFeedScreen> {
//   final TextEditingController captionController = TextEditingController();

//   final List<Map<String, dynamic>> selectedClasses = [];

//   File? selectedFile;
//   String? selectedFileName;

//   bool _isPickingFile = false;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       _fetchTutorshipClasses();
//     });
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

//   @override
//   void dispose() {
//     captionController.dispose();
//     super.dispose();
//   }

//   // ============================================================
//   // PICK FILE
//   // ============================================================

//   Future<void> _pickFile() async {
//     if (_isPickingFile) return;

//     try {
//       setState(() {
//         _isPickingFile = true;
//       });

//       debugPrint('======================================');
//       debugPrint('📎 OPENING FILE PICKER');
//       debugPrint('======================================');

//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
//         withData: false,
//       );

//       if (result == null) {
//         debugPrint('❌ User cancelled file picker');

//         if (mounted) {
//           setState(() {
//             _isPickingFile = false;
//           });
//         }

//         return;
//       }

//       if (result.files.isEmpty) {
//         debugPrint('❌ No file returned from picker');

//         if (mounted) {
//           setState(() {
//             _isPickingFile = false;
//           });
//         }

//         _showMessage('No file selected');
//         return;
//       }

//       final PlatformFile pickedFile = result.files.single;

//       debugPrint('======================================');
//       debugPrint('📎 FILE PICKER RESULT');
//       debugPrint('Name     : ${pickedFile.name}');
//       debugPrint('Path     : ${pickedFile.path}');
//       debugPrint('Size     : ${pickedFile.size}');
//       debugPrint('Extension: ${pickedFile.extension}');
//       debugPrint('Bytes    : ${pickedFile.bytes != null}');
//       debugPrint('======================================');

//       // --------------------------------------------------------
//       // PATH CHECK
//       // --------------------------------------------------------

//       if (pickedFile.path == null || pickedFile.path!.isEmpty) {
//         debugPrint('❌ File path is NULL or EMPTY');

//         if (mounted) {
//           setState(() {
//             _isPickingFile = false;
//           });
//         }

//         _showMessage(
//           'Unable to access the selected file. Please select the file again.',
//         );

//         return;
//       }

//       final File file = File(pickedFile.path!);

//       // --------------------------------------------------------
//       // CHECK FILE EXISTS
//       // --------------------------------------------------------

//       final bool exists = await file.exists();

//       debugPrint('📂 File exists: $exists');

//       if (!exists) {
//         debugPrint('❌ Selected file does not exist at path');
//         debugPrint(pickedFile.path!);

//         if (mounted) {
//           setState(() {
//             _isPickingFile = false;
//           });
//         }

//         _showMessage('Selected file could not be accessed.');

//         return;
//       }

//       // --------------------------------------------------------
//       // FILE SIZE
//       // --------------------------------------------------------

//       final int fileSize = await file.length();

//       debugPrint('📦 Actual file size: $fileSize bytes');

//       // --------------------------------------------------------
//       // SAVE FILE
//       // --------------------------------------------------------

//       if (!mounted) return;

//       setState(() {
//         selectedFile = file;
//         selectedFileName = pickedFile.name;
//         _isPickingFile = false;
//       });

//       debugPrint('======================================');
//       debugPrint('✅ FILE SUCCESSFULLY SELECTED');
//       debugPrint('Name: $selectedFileName');
//       debugPrint('Path: ${selectedFile!.path}');
//       debugPrint('Size: $fileSize bytes');
//       debugPrint('======================================');
//     } catch (e, stackTrace) {
//       debugPrint('======================================');
//       debugPrint('❌ FILE PICKER ERROR');
//       debugPrint(e.toString());
//       debugPrint(stackTrace.toString());
//       debugPrint('======================================');

//       if (mounted) {
//         setState(() {
//           _isPickingFile = false;
//         });
//       }

//       _showMessage('Unable to select file. Please try again.');
//     }
//   }

//   // ============================================================
//   // REMOVE SELECTED FILE
//   // ============================================================

//   void _removeSelectedFile() {
//     setState(() {
//       selectedFile = null;
//       selectedFileName = null;
//     });

//     debugPrint('🗑️ Selected file removed');
//   }

//   // ============================================================
//   // FILE ICON
//   // ============================================================

//   IconData _getFileIcon() {
//     final String extension =
//         selectedFileName?.split('.').last.toLowerCase() ?? '';

//     switch (extension) {
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//         return Icons.image_rounded;

//       case 'pdf':
//         return Icons.picture_as_pdf_rounded;

//       case 'doc':
//       case 'docx':
//         return Icons.description_rounded;

//       default:
//         return Icons.insert_drive_file_rounded;
//     }
//   }

//   // ============================================================
//   // FILE CONTAINER
//   // ============================================================

//   Widget _buildFilePickerContainer() {
//     return GestureDetector(
//       onTap: _isPickingFile ? null : _pickFile,
//       child: CustomPaint(
//         painter: DashedBorderPainter(
//           color: Colors.black54,
//           strokeWidth: 1.2,
//           radius: 12,
//           dashWidth: 7,
//           dashSpace: 6,
//         ),
//         child: Container(
//           width: double.infinity,
//           height: 150,
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
//           decoration: BoxDecoration(
//             color: const Color(0xffeef3ff),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: selectedFile == null
//               ? _buildChooseFileContent()
//               : _buildSelectedFileContent(),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // CHOOSE FILE UI
//   // ============================================================

//   Widget _buildChooseFileContent() {
//     if (_isPickingFile) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 25,
//               height: 25,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.5,
//                 color: Color(0xff2E5CE9),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Selecting file...',
//               style: TextStyle(
//                 color: Color(0xff2E5CE9),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SvgPicture.asset(
//           'assets/icons/Group (9).svg',
//           width: 30,
//           height: 30,
//           colorFilter: const ColorFilter.mode(
//             Color(0xff2E5CE9),
//             BlendMode.srcIn,
//           ),
//         ),

//         const SizedBox(height: 7),

//         const Text(
//           'Choose File',
//           style: TextStyle(
//             color: Color(0xff1f60ff),
//             fontSize: 11,
//             decoration: TextDecoration.underline,
//             decorationColor: Color(0xff1f60ff),
//             fontWeight: FontWeight.w500,
//           ),
//         ),

//         const SizedBox(height: 5),

//         const Text(
//           'JPG, PNG, PDF, DOC, DOCX',
//           style: TextStyle(color: Colors.black45, fontSize: 9),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // SELECTED FILE UI
//   // ============================================================

//   Widget _buildSelectedFileContent() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(_getFileIcon(), size: 28, color: const Color(0xff2E5CE9)),
//         ),

//         const SizedBox(height: 10),

//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 35),
//           child: Text(
//             selectedFileName ?? 'Selected file',
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.black87,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),

//         const SizedBox(height: 4),

//         const Text(
//           'Tap to replace file',
//           style: TextStyle(color: Color(0xff2E5CE9), fontSize: 9),
//         ),

//         const SizedBox(height: 5),

//         GestureDetector(
//           onTap: _removeSelectedFile,
//           child: const Text(
//             'Remove',
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: 9,
//               fontWeight: FontWeight.w500,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // MESSAGE
//   // ============================================================

//   void _showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//     );
//   }

//   // ============================================================
//   // SAVE
//   // ============================================================

//   Future<void> _saveFeed() async {
//     if (_isSaving) return;

//     // ----------------------------------------------------------
//     // CAPTION
//     // ----------------------------------------------------------

//     if (captionController.text.trim().isEmpty) {
//       _showMessage('Please enter feed caption');
//       return;
//     }

//     // ----------------------------------------------------------
//     // CLASS
//     // ----------------------------------------------------------

//     if (selectedClasses.isEmpty) {
//       _showMessage('Please select at least one class');
//       return;
//     }

//     // ----------------------------------------------------------
//     // FILE DEBUG
//     // ----------------------------------------------------------

//     if (selectedFile != null) {
//       final bool exists = await selectedFile!.exists();

//       debugPrint('======================================');
//       debugPrint('📎 FILE BEFORE SAVE');
//       debugPrint('Name: $selectedFileName');
//       debugPrint('Path: ${selectedFile!.path}');
//       debugPrint('Exists: $exists');
//       debugPrint('======================================');

//       if (!exists) {
//         _showMessage(
//           'Selected file is no longer available. Please select it again.',
//         );
//         return;
//       }
//     } else {
//       debugPrint('📎 No file selected');
//     }

//     // ----------------------------------------------------------
//     // REQUEST
//     // ----------------------------------------------------------

//     final SaveFeedParameter request = SaveFeedParameter(
//       feedText: captionController.text.trim(),
//       feedTarget: 'Student',

//       standardId: selectedClasses
//           .map(
//             (e) => FeedStandardParameter(
//               standardId: e['standardId'],
//               divisionId: e['divisionId'],
//             ),
//           )
//           .toList(),

//       userId: AppData.userId.toString(),

//       branchId: AppData.branchId ?? 1,

//       createdUser: AppData.userId.toString(),

//       accYear: AppData.accYear ?? '1',

//       feedMasterFiles: selectedFile == null
//           ? []
//           : [FeedMasterFileParameter(file: selectedFile!.path)],
//     );

//     debugPrint('======================================');
//     debugPrint('📤 SAVE FEED REQUEST');
//     debugPrint('Caption: ${captionController.text.trim()}');
//     debugPrint('Selected file: $selectedFileName');
//     debugPrint('Selected file path: ${selectedFile?.path}');
//     debugPrint('Selected classes: $selectedClasses');
//     debugPrint('Request: ${request.toJson()}');
//     debugPrint('======================================');

//     setState(() {
//       _isSaving = true;
//     });

//     context.read<FeedCubit>().saveFeed(request);
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<FeedCubit, FeedState>(
//       listener: (context, state) {
//         // ------------------------------------------------------
//         // SUCCESS
//         // ------------------------------------------------------

//         if (state is SaveFeedSuccess) {
//           if (mounted) {
//             setState(() {
//               _isSaving = false;
//             });
//           }

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 state.response.message ?? 'Feed Saved Successfully',
//               ),
//             ),
//           );

//           Navigator.pop(context, true);
//         }

//         // ------------------------------------------------------
//         // FAILURE
//         // ------------------------------------------------------

//         if (state is SaveFeedFailure) {
//           if (mounted) {
//             setState(() {
//               _isSaving = false;
//             });
//           }

//           _showMessage(state.message);
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: Colors.white,

//           // ====================================================
//           // APP BAR
//           // ====================================================
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             surfaceTintColor: Colors.white,
//             centerTitle: true,

//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),

//             title: const Text(
//               'Add Feed',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),

//           // ====================================================
//           // BODY
//           // ====================================================
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ==================================================
//                 // FILE PICKER
//                 // ==================================================
//                 _buildFilePickerContainer(),

//                 const SizedBox(height: 17),

//                 // ==================================================
//                 // CAPTION
//                 // ==================================================
//                 Container(
//                   width: double.infinity,
//                   height: 150,
//                   padding: const EdgeInsets.fromLTRB(12, 5, 12, 10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xffeef3ff),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Stack(
//                     children: [
//                       TextField(
//                         controller: captionController,
//                         maxLines: null,
//                         expands: true,
//                         textAlignVertical: TextAlignVertical.top,
//                         decoration: const InputDecoration(
//                           hintText: 'Add A Caption',
//                           hintStyle: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(right: 28, top: 0),
//                         ),
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                         ),
//                       ),

//                       Positioned(
//                         top: 5,
//                         right: 2,
//                         child: Container(
//                           width: 13,
//                           height: 13,
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(3),
//                           ),
//                           child: Center(
//                             child: SvgPicture.asset(
//                               'assets/icons/Group (8).svg',
//                               width: 14,
//                               height: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 23),

//                 // ==================================================
//                 // SELECT CLASSES
//                 // ==================================================
//                 const Text(
//                   'Select Your Classes',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 BlocBuilder<AuthenticationCubit, AuthenticationState>(
//                   builder: (context, state) {
//                     if (state is FetchTutorshipClassLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     // if (state is FetchTutorshipClassSuccess) {
//                     //   final classes = state.response.data?.tutorshipClass ?? [];

//                     //   final List<Map<String, dynamic>> classList = [];

//                     //   for (final standard in classes) {
//                     //     for (final division in standard.division ?? []) {
//                     //       classList.add({
//                     //         'standardId': standard.standardId,
//                     //         'standardName': standard.standard,
//                     //         'division': division,
//                     //       });
//                     //     }
//                     //   }
//                     if (state is FetchTutorshipClassSuccess) {
//                       final List<TutorshipClass> standards =
//                           state.response.data?.standard ?? [];

//                       final List<Map<String, dynamic>> classList = [];

//                       for (final standard in standards) {
//                         for (final division in standard.division ?? []) {
//                           classList.add({
//                             'standardId': standard.standardId,
//                             'standardName': standard.standard,
//                             'division': division,
//                           });
//                         }
//                       }
//                       if (classList.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'No classes found',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         );
//                       }
//                       return GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: classList.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               mainAxisExtent: 46,
//                               crossAxisSpacing: 28,
//                             ),
//                         itemBuilder: (context, index) {
//                           final item = classList[index];

//                           final int standardId = item['standardId'];

//                           final String standardName = item['standardName'];

//                           final DivisionDetails division =
//                               item['division'] as DivisionDetails;

//                           final bool isSelected = selectedClasses.any(
//                             (e) =>
//                                 e['standardId'] == standardId &&
//                                 e['divisionId'] == division.divisionId,
//                           );

//                           return Row(
//                             children: [
//                               SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: Checkbox(
//                                   value: isSelected,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         selectedClasses.add({
//                                           'standardId': standardId,
//                                           'divisionId': division.divisionId,
//                                         });
//                                       } else {
//                                         selectedClasses.removeWhere(
//                                           (e) =>
//                                               e['standardId'] == standardId &&
//                                               e['divisionId'] ==
//                                                   division.divisionId,
//                                         );
//                                       }
//                                     });
//                                   },
//                                   activeColor: const Color(0xff8f83dc),
//                                   checkColor: Colors.black,
//                                 ),
//                               ),

//                               const SizedBox(width: 8),

//                               Expanded(
//                                 child: Text(
//                                   '$standardName ${division.division}',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: isSelected
//                                         ? const Color(0xff7d6dff)
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }

//                     if (state is FetchTutorshipClassFailure) {
//                       return Center(
//                         child: Text(
//                           state.message,
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 12,
//                           ),
//                         ),
//                       );
//                     }

//                     return const SizedBox();
//                   },
//                 ),

//                 const SizedBox(height: 28),

//                 // ==================================================
//                 // SAVE BUTTON
//                 // ==================================================
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isSaving ? null : _saveFeed,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff9b78dc),
//                       disabledBackgroundColor: Colors.grey.shade400,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: _isSaving
//                         ? const SizedBox(
//                             width: 22,
//                             height: 22,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ================================================================
// // DASHED BORDER PAINTER
// // ================================================================

// class DashedBorderPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double radius;
//   final double dashWidth;
//   final double dashSpace;

//   DashedBorderPainter({
//     required this.color,
//     required this.strokeWidth,
//     required this.radius,
//     required this.dashWidth,
//     required this.dashSpace,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;

//     final RRect rect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Radius.circular(radius),
//     );

//     final Path path = Path()..addRRect(rect);

//     final Iterable<PathMetric> pathMetrics = path.computeMetrics();

//     for (final PathMetric metric in pathMetrics) {
//       double distance = 0;

//       while (distance < metric.length) {
//         final double nextDistance = distance + dashWidth;

//         final Path dashPath = metric.extractPath(
//           distance,
//           nextDistance.clamp(0, metric.length),
//         );

//         canvas.drawPath(dashPath, paint);

//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
import 'dart:io';
import 'dart:ui';

import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';
import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  final TextEditingController captionController = TextEditingController();

  final List<Map<String, dynamic>> selectedClasses = [];

  File? selectedFile;
  String? selectedFileName;

  bool _isPickingFile = false;
  bool _isSaving = false;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (_isPickingFile) return;

    try {
      setState(() {
        _isPickingFile = true;
      });

      debugPrint('======================================');
      debugPrint('📎 OPENING FILE PICKER');
      debugPrint('======================================');

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        withData: false,
      );

      if (result == null) {
        debugPrint('❌ User cancelled file picker');

        if (mounted) {
          setState(() {
            _isPickingFile = false;
          });
        }

        return;
      }

      if (result.files.isEmpty) {
        debugPrint('❌ No file returned from picker');

        if (mounted) {
          setState(() {
            _isPickingFile = false;
          });
        }

        _showMessage('No file selected');
        return;
      }

      final PlatformFile pickedFile = result.files.single;

      debugPrint('======================================');
      debugPrint('📎 FILE PICKER RESULT');
      debugPrint('Name     : ${pickedFile.name}');
      debugPrint('Path     : ${pickedFile.path}');
      debugPrint('Size     : ${pickedFile.size}');
      debugPrint('Extension: ${pickedFile.extension}');
      debugPrint('Bytes    : ${pickedFile.bytes != null}');
      debugPrint('======================================');

      if (pickedFile.path == null || pickedFile.path!.isEmpty) {
        debugPrint('❌ File path is NULL or EMPTY');

        if (mounted) {
          setState(() {
            _isPickingFile = false;
          });
        }

        _showMessage(
          'Unable to access the selected file. Please select the file again.',
        );

        return;
      }

      final File file = File(pickedFile.path!);
      final bool exists = await file.exists();

      debugPrint('📂 File exists: $exists');

      if (!exists) {
        debugPrint('❌ Selected file does not exist at path');
        debugPrint(pickedFile.path!);

        if (mounted) {
          setState(() {
            _isPickingFile = false;
          });
        }

        _showMessage('Selected file could not be accessed.');
        return;
      }

      final int fileSize = await file.length();

      debugPrint('📦 Actual file size: $fileSize bytes');

      if (!mounted) return;

      setState(() {
        selectedFile = file;
        selectedFileName = pickedFile.name;
        _isPickingFile = false;
      });

      debugPrint('======================================');
      debugPrint('✅ FILE SUCCESSFULLY SELECTED');
      debugPrint('Name: $selectedFileName');
      debugPrint('Path: ${selectedFile!.path}');
      debugPrint('Size: $fileSize bytes');
      debugPrint('======================================');
    } catch (e, stackTrace) {
      debugPrint('======================================');
      debugPrint('❌ FILE PICKER ERROR');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      debugPrint('======================================');

      if (mounted) {
        setState(() {
          _isPickingFile = false;
        });
      }

      _showMessage('Unable to select file. Please try again.');
    }
  }

  void _removeSelectedFile() {
    setState(() {
      selectedFile = null;
      selectedFileName = null;
    });

    debugPrint('🗑️ Selected file removed');
  }

  IconData _getFileIcon() {
    final String extension =
        selectedFileName?.split('.').last.toLowerCase() ?? '';

    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_rounded;

      case 'pdf':
        return Icons.picture_as_pdf_rounded;

      case 'doc':
      case 'docx':
        return Icons.description_rounded;

      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Widget _buildFilePickerContainer() {
    return GestureDetector(
      onTap: _isPickingFile ? null : _pickFile,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: Colors.black54,
          strokeWidth: 1.2,
          radius: 12,
          dashWidth: 7,
          dashSpace: 6,
        ),
        child: Container(
          width: double.infinity,
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xffeef3ff),
            borderRadius: BorderRadius.circular(12),
          ),
          child: selectedFile == null
              ? _buildChooseFileContent()
              : _buildSelectedFileContent(),
        ),
      ),
    );
  }

  Widget _buildChooseFileContent() {
    if (_isPickingFile) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xff2E5CE9),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Selecting file...',
              style: TextStyle(
                color: Color(0xff2E5CE9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/Group (9).svg',
          width: 30,
          height: 30,
          colorFilter: const ColorFilter.mode(
            Color(0xff2E5CE9),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Choose File',
          style: TextStyle(
            color: Color(0xff1f60ff),
            fontSize: 11,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xff1f60ff),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'JPG, PNG, PDF, DOC, DOCX',
          style: TextStyle(color: Colors.black45, fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildSelectedFileContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getFileIcon(), size: 28, color: const Color(0xff2E5CE9)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            selectedFileName ?? 'Selected file',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap to replace file',
          style: TextStyle(color: Color(0xff2E5CE9), fontSize: 9),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: _removeSelectedFile,
          child: const Text(
            'Remove',
            style: TextStyle(
              color: Colors.red,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
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

  Future<void> _saveFeed() async {
    if (_isSaving) return;

    if (captionController.text.trim().isEmpty) {
      _showMessage('Please enter feed caption');
      return;
    }

    if (selectedClasses.isEmpty) {
      _showMessage('Please select at least one class');
      return;
    }

    if (selectedFile != null) {
      final bool exists = await selectedFile!.exists();

      debugPrint('======================================');
      debugPrint('📎 FILE BEFORE SAVE');
      debugPrint('Name: $selectedFileName');
      debugPrint('Path: ${selectedFile!.path}');
      debugPrint('Exists: $exists');
      debugPrint('======================================');

      if (!exists) {
        _showMessage(
          'Selected file is no longer available. Please select it again.',
        );
        return;
      }
    } else {
      debugPrint('📎 No file selected');
    }

    final SaveFeedParameter request = SaveFeedParameter(
      feedText: captionController.text.trim(),
      feedTarget: 'Student',
      standardId: selectedClasses.map((e) {
        return FeedStandardParameter(
          standardId: e['standardId'],
          divisionId: e['divisionId'],
        );
      }).toList(),
      userId: AppData.userId.toString(),
      branchId: AppData.branchId ?? 1,
      createdUser: AppData.userId.toString(),
      accYear: AppData.accYear ?? '1',
      feedMasterFiles: selectedFile == null
          ? []
          : [FeedMasterFileParameter(file: selectedFile!.path)],
    );

    debugPrint('======================================');
    debugPrint('📤 SAVE FEED REQUEST');
    debugPrint('Caption: ${captionController.text.trim()}');
    debugPrint('Selected file: $selectedFileName');
    debugPrint('Selected file path: ${selectedFile?.path}');
    debugPrint('Selected classes: $selectedClasses');
    debugPrint('Request: ${request.toJson()}');
    debugPrint('======================================');

    setState(() {
      _isSaving = true;
    });

    context.read<FeedCubit>().saveFeed(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedCubit, FeedState>(
      listener: (context, state) {
        if (state is SaveFeedSuccess) {
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message ?? 'Feed Saved Successfully',
              ),
            ),
          );

          Navigator.pop(context, true);
        }

        if (state is SaveFeedFailure) {
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }

          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        final List<TutorshipClass> standards = AppData.standards;
        final List<Map<String, dynamic>> classList = [];

        for (final TutorshipClass standard in standards) {
          for (final DivisionDetails division
              in standard.division ?? <DivisionDetails>[]) {
            classList.add({
              'standardId': standard.standardId,
              'standardName': standard.standard,
              'division': division,
            });
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Add Feed',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilePickerContainer(),
                const SizedBox(height: 17),
                Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.fromLTRB(12, 5, 12, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xffeef3ff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: captionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Add A Caption',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(right: 28, top: 0),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 2,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/Group (8).svg',
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                const Text(
                  'Select Your Classes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                if (classList.isEmpty)
                  const Center(
                    child: Text(
                      'No classes found',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: classList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 46,
                          crossAxisSpacing: 28,
                        ),
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> item = classList[index];

                      final int standardId = item['standardId'] as int;

                      final String standardName =
                          item['standardName'] as String? ?? '';

                      final DivisionDetails division =
                          item['division'] as DivisionDetails;

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
                              onChanged: (value) {
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
                                          e['divisionId'] ==
                                              division.divisionId,
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
                                color: isSelected
                                    ? const Color(0xff7d6dff)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveFeed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9b78dc),
                      disabledBackgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rect);

    final Iterable<PathMetric> pathMetrics = path.computeMetrics();

    for (final PathMetric metric in pathMetrics) {
      double distance = 0;

      while (distance < metric.length) {
        final double nextDistance = distance + dashWidth;

        final Path dashPath = metric.extractPath(
          distance,
          nextDistance.clamp(0, metric.length),
        );

        canvas.drawPath(dashPath, paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
