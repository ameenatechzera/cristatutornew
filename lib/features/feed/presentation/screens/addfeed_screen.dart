// import 'dart:io';
// import 'dart:ui';
// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
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
//   void dispose() {
//     captionController.dispose();
//     super.dispose();
//   }

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

//       final int fileSize = await file.length();

//       debugPrint('📦 Actual file size: $fileSize bytes');

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

//   void _removeSelectedFile() {
//     setState(() {
//       selectedFile = null;
//       selectedFileName = null;
//     });

//     debugPrint('🗑️ Selected file removed');
//   }

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

//   // Widget _buildFilePickerContainer() {
//   //   return GestureDetector(
//   //     onTap: _isPickingFile ? null : _pickFile,
//   //     child: CustomPaint(
//   //       painter: DashedBorderPainter(
//   //         color: Colors.black54,
//   //         strokeWidth: 1.2,
//   //         radius: 12,
//   //         dashWidth: 7,
//   //         dashSpace: 6,
//   //       ),
//   //       child: Container(
//   //         width: double.infinity,
//   //         height: 150,
//   //         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
//   //         decoration: BoxDecoration(
//   //           color: const Color(0xffeef3ff),
//   //           borderRadius: BorderRadius.circular(12),
//   //         ),
//   //         child: selectedFile == null
//   //             ? _buildChooseFileContent()
//   //             : _buildSelectedFileContent(),
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget _buildFilePickerContainer() {
//     return GestureDetector(
//       onTap: selectedFile == null && !_isPickingFile ? _pickFile : null,
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

//   // Widget _buildSelectedFileContent() {
//   //   return Column(
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       Container(
//   //         width: 48,
//   //         height: 48,
//   //         decoration: BoxDecoration(
//   //           color: Colors.white,
//   //           borderRadius: BorderRadius.circular(12),
//   //         ),
//   //         child: Icon(_getFileIcon(), size: 28, color: const Color(0xff2E5CE9)),
//   //       ),
//   //       const SizedBox(height: 10),
//   //       Padding(
//   //         padding: const EdgeInsets.symmetric(horizontal: 35),
//   //         child: Text(
//   //           selectedFileName ?? 'Selected file',
//   //           maxLines: 1,
//   //           overflow: TextOverflow.ellipsis,
//   //           textAlign: TextAlign.center,
//   //           style: const TextStyle(
//   //             color: Colors.black87,
//   //             fontSize: 11,
//   //             fontWeight: FontWeight.w600,
//   //           ),
//   //         ),
//   //       ),
//   //       const SizedBox(height: 4),
//   //       const Text(
//   //         'Tap to replace file',
//   //         style: TextStyle(color: Color(0xff2E5CE9), fontSize: 9),
//   //       ),
//   //       const SizedBox(height: 5),
//   //       GestureDetector(
//   //         onTap: _removeSelectedFile,
//   //         child: const Text(
//   //           'Remove',
//   //           style: TextStyle(
//   //             color: Colors.red,
//   //             fontSize: 9,
//   //             fontWeight: FontWeight.w500,
//   //             decoration: TextDecoration.underline,
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//   Widget _buildSelectedFileContent() {
//     final String fileName = (selectedFileName ?? '').toLowerCase();

//     final bool isImageFile =
//         fileName.endsWith('.jpg') ||
//         fileName.endsWith('.jpeg') ||
//         fileName.endsWith('.png');

//     return Row(
//       children: [
//         GestureDetector(
//           onTap: isImageFile
//               ? () {
//                   showDialog<void>(
//                     context: context,
//                     barrierColor: Colors.black,
//                     builder: (dialogContext) {
//                       return Dialog.fullscreen(
//                         backgroundColor: Colors.black,
//                         child: SafeArea(
//                           child: Stack(
//                             children: [
//                               Positioned.fill(
//                                 child: InteractiveViewer(
//                                   minScale: 0.5,
//                                   maxScale: 5,
//                                   child: Center(
//                                     child: Image.file(
//                                       selectedFile!,
//                                       width: double.infinity,
//                                       height: double.infinity,
//                                       fit: BoxFit.contain,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                             return const Icon(
//                                               Icons.broken_image_outlined,
//                                               color: Colors.white,
//                                               size: 50,
//                                             );
//                                           },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(dialogContext);
//                                   },
//                                   style: IconButton.styleFrom(
//                                     backgroundColor: Colors.black.withOpacity(
//                                       0.55,
//                                     ),
//                                   ),
//                                   icon: const Icon(
//                                     Icons.close,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               : null,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               width: 85,
//               height: 85,
//               color: Colors.white,
//               child: isImageFile
//                   ? Image.file(
//                       selectedFile!,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(
//                           Icons.broken_image_outlined,
//                           color: Colors.red,
//                           size: 30,
//                         );
//                       },
//                     )
//                   : Icon(
//                       _getFileIcon(),
//                       size: 35,
//                       color: const Color(0xff2E5CE9),
//                     ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 selectedFileName ?? 'Selected file',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 7),
//               if (isImageFile)
//                 const Text(
//                   'Tap image to preview',
//                   style: TextStyle(color: Colors.black54, fontSize: 9),
//                 ),
//               const SizedBox(height: 7),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: _isPickingFile ? null : _pickFile,
//                     child: const Text(
//                       'Change file',
//                       style: TextStyle(
//                         color: Color(0xff2E5CE9),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 18),
//                   GestureDetector(
//                     onTap: _removeSelectedFile,
//                     child: const Text(
//                       'Remove',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
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

//   Future<void> _saveFeed() async {
//     if (_isSaving) return;

//     if (captionController.text.trim().isEmpty) {
//       _showMessage('Please enter feed caption');
//       return;
//     }

//     if (selectedClasses.isEmpty) {
//       _showMessage('Please select at least one class');
//       return;
//     }

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

//     final SaveFeedParameter request = SaveFeedParameter(
//       feedText: captionController.text.trim(),
//       feedTarget: 'Student',
//       standardId: selectedClasses.map((e) {
//         return FeedStandardParameter(
//           standardId: e['standardId'],
//           divisionId: e['divisionId'],
//         );
//       }).toList(),
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

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<FeedCubit, FeedState>(
//       listener: (context, state) {
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
//         final List<TutorshipClass> standards = AppData.standards;
//         final List<Map<String, dynamic>> classList = [];

//         for (final TutorshipClass standard in standards) {
//           for (final DivisionDetails division
//               in standard.division ?? <DivisionDetails>[]) {
//             classList.add({
//               'standardId': standard.standardId,
//               'standardName': standard.standard,
//               'division': division,
//             });
//           }
//         }

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
//               'Add Feed',
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
//                 _buildFilePickerContainer(),
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
//                 const Text(
//                   'Select Your Classes',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 if (classList.isEmpty)
//                   const Center(
//                     child: Text(
//                       'No classes found',
//                       style: TextStyle(fontSize: 12, color: Colors.black54),
//                     ),
//                   )
//                 else
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: classList.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           mainAxisExtent: 46,
//                           crossAxisSpacing: 28,
//                         ),
//                     itemBuilder: (context, index) {
//                       final Map<String, dynamic> item = classList[index];

//                       final int standardId = item['standardId'] as int;

//                       final String standardName =
//                           item['standardName'] as String? ?? '';

//                       final DivisionDetails division =
//                           item['division'] as DivisionDetails;

//                       final bool isSelected = selectedClasses.any(
//                         (e) =>
//                             e['standardId'] == standardId &&
//                             e['divisionId'] == division.divisionId,
//                       );

//                       return Row(
//                         children: [
//                           SizedBox(
//                             width: 18,
//                             height: 18,
//                             child: Checkbox(
//                               value: isSelected,
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value == true) {
//                                     selectedClasses.add({
//                                       'standardId': standardId,
//                                       'divisionId': division.divisionId,
//                                     });
//                                   } else {
//                                     selectedClasses.removeWhere(
//                                       (e) =>
//                                           e['standardId'] == standardId &&
//                                           e['divisionId'] ==
//                                               division.divisionId,
//                                     );
//                                   }
//                                 });
//                               },
//                               activeColor: const Color(0xff8f83dc),
//                               checkColor: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               '$standardName ${division.division ?? ''}',
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: isSelected
//                                     ? const Color(0xff7d6dff)
//                                     : Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 const SizedBox(height: 28),
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
import 'package:open_filex/open_filex.dart';

/// One file chosen for the feed. Keeps the picker's own name, the extension
/// and the size next to the File, so the tiles can be drawn without parsing
/// the path or hitting the disk again.
class PickedFeedFile {
  final File file;
  final String name;
  final String extension;
  final int size;

  const PickedFeedFile({
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

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  static const Color accentColor = Color(0xff2E5CE9);
  static const Color fieldColor = Color(0xffeef3ff);
  static const Color tileBorderColor = Color(0xffB7C4D6);

  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'pdf',
    'doc',
    'docx',
  ];

  /// Extensions shown as a picture instead of an icon.
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];

  final TextEditingController captionController = TextEditingController();

  final List<Map<String, dynamic>> selectedClasses = [];

  /// Every file picked for this feed. Multiple files are allowed.
  final List<PickedFeedFile> selectedFiles = [];

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
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        withData: false,
      );

      if (result == null) {
        debugPrint('❌ User cancelled file picker');
        return;
      }

      if (result.files.isEmpty) {
        debugPrint('❌ No file returned from picker');

        _showMessage('No file selected');
        return;
      }

      final List<PickedFeedFile> accepted = [];

      // Names of files that were skipped, reported together at the end so
      // picking ten files cannot fire ten snackbars.
      final List<String> unavailable = [];
      final List<String> duplicates = [];

      for (final PlatformFile pickedFile in result.files) {
        debugPrint('======================================');
        debugPrint('📎 FILE PICKER RESULT');
        debugPrint('Name     : ${pickedFile.name}');
        debugPrint('Path     : ${pickedFile.path}');
        debugPrint('Size     : ${pickedFile.size}');
        debugPrint('Extension: ${pickedFile.extension}');
        debugPrint('Bytes    : ${pickedFile.bytes != null}');
        debugPrint('======================================');

        final String? filePath = pickedFile.path;

        if (filePath == null || filePath.isEmpty) {
          debugPrint('❌ File path is NULL or EMPTY');

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
        final bool exists = await file.exists();

        debugPrint('📂 File exists: $exists');

        if (!exists) {
          debugPrint('❌ Selected file does not exist at path');
          debugPrint(filePath);

          unavailable.add(pickedFile.name);
          continue;
        }

        final int fileSize = await file.length();

        debugPrint('📦 Actual file size: $fileSize bytes');

        final String extension =
            (pickedFile.extension ?? _extensionOf(pickedFile.name))
                .toLowerCase();

        accepted.add(
          PickedFeedFile(
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

      debugPrint('======================================');
      debugPrint('✅ ${accepted.length} FILE(S) SUCCESSFULLY SELECTED');

      for (final PickedFeedFile item in accepted) {
        debugPrint('Name: ${item.name}');
        debugPrint('Path: ${item.path}');
        debugPrint('Size: ${item.size} bytes');
      }

      debugPrint('======================================');

      final List<String> skipped = [];

      if (unavailable.isNotEmpty) {
        skipped.add('not accessible: ${unavailable.join(', ')}');
      }

      if (duplicates.isNotEmpty) {
        skipped.add('already added: ${duplicates.join(', ')}');
      }

      if (skipped.isNotEmpty) {
        _showMessage('Skipped ${skipped.join(' | ')}');
      }
    } catch (e, stackTrace) {
      debugPrint('======================================');
      debugPrint('❌ FILE PICKER ERROR');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      debugPrint('======================================');

      _showMessage('Unable to select file. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFile = false;
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

    debugPrint('🗑️ Selected file removed');
  }

  String _extensionOf(String fileName) {
    final int dotIndex = fileName.lastIndexOf('.');

    if (dotIndex == -1) {
      return '';
    }

    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  bool _isImage(String extension) {
    return imageExtensions.contains(extension.toLowerCase());
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
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

  /// Shows the tapped picture on its own screen.
  void _openImageViewer(ImageProvider image, String title) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) {
          return FeedImageViewer(image: image, title: title);
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
  Future<void> _openDocument(PickedFeedFile item) async {
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

  /// Empty: the upload prompt. With files: a row of thumbnails inside the
  /// same dashed box, images shown as pictures.
  Widget _buildFilePickerContainer() {
    return CustomPaint(
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
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: selectedFiles.isEmpty
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _isPickingFile ? null : _pickFile,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  child: _buildChooseFileContent(),
                ),
              )
            : _buildFilePreviews(),
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
                color: accentColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Selecting file...',
              style: TextStyle(
                color: accentColor,
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
          colorFilter: const ColorFilter.mode(accentColor, BlendMode.srcIn),
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
        const SizedBox(height: 4),
        const Text(
          'You can select more than one file',
          style: TextStyle(color: Colors.black45, fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildFilePreviews() {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      children: [
        for (int index = 0; index < selectedFiles.length; index++)
          _fileTile(
            preview: _filePreview(selectedFiles[index]),
            onTap: _isImage(selectedFiles[index].extension)
                ? () => _openImageViewer(
                    FileImage(selectedFiles[index].file),
                    selectedFiles[index].name,
                  )
                : () => _openDocument(selectedFiles[index]),
            onRemove: _isSaving ? null : () => _removeFileAt(index),
          ),

        _addMoreTile(),
      ],
    );
  }

  /// Picked file: the picture itself for images, an icon otherwise.
  Widget _filePreview(PickedFeedFile item) {
    if (_isImage(item.extension)) {
      return Image.file(
        item.file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _fileIconPreview(item.extension);
        },
      );
    }

    return _fileIconPreview(item.extension, label: item.extension);
  }

  Widget _fileIconPreview(String extension, {String? label}) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(extension), size: 30, color: accentColor),
          if ((label ?? extension).isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              (label ?? extension).toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
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
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 90,
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
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: tileBorderColor.withOpacity(0.6),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: preview,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 3,
              right: 3,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 21,
                  height: 21,
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

  Widget _addMoreTile() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _isPickingFile || _isSaving ? null : _pickFile,
      child: SizedBox(
        width: 90,
        child: FeedDottedTileBorder(
          color: tileBorderColor,
          child: Center(
            child: _isPickingFile
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: accentColor,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 24, color: accentColor),
                      SizedBox(height: 3),
                      Text(
                        'Add',
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
          ),
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

    if (selectedFiles.isNotEmpty) {
      // A file can be deleted between picking and saving.
      final List<PickedFeedFile> missing = [];

      for (final PickedFeedFile item in selectedFiles) {
        final bool exists = await item.file.exists();

        debugPrint('======================================');
        debugPrint('📎 FILE BEFORE SAVE');
        debugPrint('Name: ${item.name}');
        debugPrint('Path: ${item.path}');
        debugPrint('Exists: $exists');
        debugPrint('======================================');

        if (!exists) {
          missing.add(item);
        }
      }

      if (missing.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          selectedFiles.removeWhere(missing.contains);
        });

        _showMessage(
          '${missing.map((item) => item.name).join(', ')} '
          'is no longer available. Please select it again.',
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
      feedMasterFiles: selectedFiles.map((item) {
        return FeedMasterFileParameter(file: item.path);
      }).toList(),
    );

    debugPrint('======================================');
    debugPrint('📤 SAVE FEED REQUEST');
    debugPrint('Caption: ${captionController.text.trim()}');
    debugPrint('Selected files: ${selectedFiles.length}');

    for (final PickedFeedFile item in selectedFiles) {
      debugPrint('  ${item.name} -> ${item.path}');
    }

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

/// Full screen look at one picked picture. Pinch or double tap to zoom,
/// tap the backdrop or the close button to come back.
class FeedImageViewer extends StatelessWidget {
  final ImageProvider image;
  final String title;

  const FeedImageViewer({super.key, required this.image, this.title = ''});

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
                  maxScale: 5,
                  child: Center(
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                          size: 50,
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
class FeedDottedTileBorder extends StatelessWidget {
  final Color color;
  final Widget child;

  const FeedDottedTileBorder({
    super.key,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: color,
        strokeWidth: 1,
        radius: 10,
        dashWidth: 5,
        dashSpace: 4,
      ),
      child: child,
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
