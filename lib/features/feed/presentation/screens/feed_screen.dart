// // import 'package:cristalteacher/core/appdata/appdata.dart';
// // import 'package:cristalteacher/features/feed/domain/parameters/fetch_feed_parameter.dart';
// // import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
// // import 'package:cristalteacher/features/feed/presentation/screens/addfeed_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_svg/flutter_svg.dart';

// // class FeedScreen extends StatefulWidget {
// //   const FeedScreen({super.key});

// //   @override
// //   State<FeedScreen> createState() => _FeedScreenState();
// // }

// // class _FeedScreenState extends State<FeedScreen> {
// //   static const Color primaryColor = Color(0xff9b6ce3);
// //   static const Color borderColor = Color(0xFFE8E8E8);

// //   DateTime? fromDate;
// //   DateTime? toDate;

// //   @override
// //   void initState() {
// //     super.initState();

// //     final now = DateTime.now();
// //     fromDate = DateTime(now.year, now.month, now.day);
// //     toDate = DateTime(now.year, now.month, now.day);

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!mounted) return;
// //       _fetchFeed();
// //     });
// //   }

// //   String _formatApiDate(DateTime date) {
// //     return '${date.year.toString().padLeft(4, '0')}-'
// //         '${date.month.toString().padLeft(2, '0')}-'
// //         '${date.day.toString().padLeft(2, '0')}';
// //   }

// //   String _formatDisplayDate(DateTime date) {
// //     return '${date.day.toString().padLeft(2, '0')}-'
// //         '${date.month.toString().padLeft(2, '0')}-'
// //         '${date.year}';
// //   }

// //   void _fetchFeed() {
// //     if (fromDate == null || toDate == null) return;

// //     context.read<FeedCubit>().fetchFeed(
// //       FetchFeedParams(
// //         accYear: AppData.accYear,
// //         standardId: AppData.studentStdId,
// //         divisionId: AppData.studentDivId,
// //         fromDate: _formatApiDate(fromDate!),
// //         toDate: _formatApiDate(toDate!),
// //       ),
// //     );
// //   }

// //   Future<void> _selectDate({required bool isFromDate}) async {
// //     final pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: isFromDate
// //           ? fromDate ?? DateTime.now()
// //           : toDate ?? fromDate ?? DateTime.now(),
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2035),
// //       builder: (context, child) {
// //         return Theme(
// //           data: Theme.of(context).copyWith(
// //             colorScheme: const ColorScheme.light(
// //               primary: primaryColor,
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );

// //     if (pickedDate == null || !mounted) return;

// //     final selectedDate = DateTime(
// //       pickedDate.year,
// //       pickedDate.month,
// //       pickedDate.day,
// //     );

// //     if (isFromDate) {
// //       setState(() {
// //         fromDate = selectedDate;
// //       });

// //       // Do not clear toDate and do not call the API here.
// //       return;
// //     }

// //     if (fromDate == null) {
// //       ScaffoldMessenger.of(context)
// //         ..hideCurrentSnackBar()
// //         ..showSnackBar(
// //           const SnackBar(content: Text('Please select from date first')),
// //         );
// //       return;
// //     }

// //     if (selectedDate.isBefore(fromDate!)) {
// //       ScaffoldMessenger.of(context)
// //         ..hideCurrentSnackBar()
// //         ..showSnackBar(
// //           const SnackBar(content: Text('To date cannot be before from date')),
// //         );
// //       return;
// //     }

// //     setState(() {
// //       toDate = selectedDate;
// //     });

// //     // API is called only after selecting the to date.
// //     _fetchFeed();
// //   }
// //   // Future<void> _selectDate({required bool isFromDate}) async {
// //   //   final pickedDate = await showDatePicker(
// //   //     context: context,
// //   //     initialDate: isFromDate
// //   //         ? fromDate ?? DateTime.now()
// //   //         : toDate ?? fromDate ?? DateTime.now(),
// //   //     firstDate: DateTime(2020),
// //   //     lastDate: DateTime(2035),
// //   //     builder: (context, child) {
// //   //       return Theme(
// //   //         data: Theme.of(context).copyWith(
// //   //           colorScheme: const ColorScheme.light(
// //   //             primary: primaryColor,
// //   //             onPrimary: Colors.white,
// //   //             surface: Colors.white,
// //   //             onSurface: Colors.black,
// //   //           ),
// //   //         ),
// //   //         child: child!,
// //   //       );
// //   //     },
// //   //   );

// //   //   if (pickedDate == null || !mounted) return;

// //   //   final selectedDate = DateTime(
// //   //     pickedDate.year,
// //   //     pickedDate.month,
// //   //     pickedDate.day,
// //   //   );

// //   //   if (isFromDate) {
// //   //     setState(() {
// //   //       fromDate = selectedDate;
// //   //       toDate = null;
// //   //     });

// //   //     return;
// //   //   } else {
// //   //     if (fromDate == null) {
// //   //       ScaffoldMessenger.of(context)
// //   //         ..hideCurrentSnackBar()
// //   //         ..showSnackBar(
// //   //           const SnackBar(content: Text('Please select from date first')),
// //   //         );
// //   //       return;
// //   //     }

// //   //     if (selectedDate.isBefore(fromDate!)) {
// //   //       ScaffoldMessenger.of(context)
// //   //         ..hideCurrentSnackBar()
// //   //         ..showSnackBar(
// //   //           const SnackBar(content: Text('To date cannot be before from date')),
// //   //         );
// //   //       return;
// //   //     }

// //   //     setState(() {
// //   //       toDate = selectedDate;
// //   //     });
// //   //   }

// //   //   _fetchFeed();
// //   // }

// //   void showDeleteDialog(int feedId) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       barrierColor: Colors.black.withOpacity(0.35),
// //       builder: (BuildContext dialogContext) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           insetPadding: const EdgeInsets.symmetric(horizontal: 34),
// //           child: Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(28),
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 const Text(
// //                   "Are You Sure You Want To\nDelete This Post?",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.w600,
// //                     color: Colors.black,
// //                     height: 1.3,
// //                   ),
// //                 ),

// //                 const SizedBox(height: 30),

// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     SizedBox(
// //                       width: 92,
// //                       height: 38,
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           Navigator.pop(dialogContext);
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xffe9e9e9),
// //                           foregroundColor: Colors.black,
// //                           elevation: 0,
// //                           shadowColor: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "NO",
// //                           style: TextStyle(
// //                             fontSize: 11,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ),
// //                     ),

// //                     const SizedBox(width: 18),

// //                     SizedBox(
// //                       width: 92,
// //                       height: 38,
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           Navigator.pop(dialogContext);

// //                           context.read<FeedCubit>().deleteFeed(feedId);
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xff8f83dc),
// //                           foregroundColor: Colors.white,
// //                           elevation: 0,
// //                           shadowColor: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "Yes",
// //                           style: TextStyle(
// //                             fontSize: 11,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xfff7f7f7),

// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         centerTitle: true,
// //         surfaceTintColor: Colors.white,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //         title: const Text(
// //           "Feed",
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontSize: 18,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //       ),

// //       // body: feedItems.isEmpty
// //       //     ? const Center(
// //       //         child: Text(
// //       //           "No Feed Available",
// //       //           style: TextStyle(
// //       //             fontSize: 14,
// //       //             color: Colors.black54,
// //       //             fontWeight: FontWeight.w500,
// //       //           ),
// //       //         ),
// //       //       )
// //       //     : ListView.builder(
// //       //         padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
// //       //         itemCount: feedItems.length,
// //       //         itemBuilder: (context, index) {
// //       //           final item = feedItems[index];

// //       //           return FeedCard(
// //       //             title: item["title"]!,
// //       //             date: item["date"]!,
// //       //             imagePath: item["image"]!,
// //       //             onEdit: () {
// //       //               debugPrint("Edit tapped");
// //       //             },
// //       //             onDelete: () {
// //       //               showDeleteDialog(index);
// //       //             },
// //       //           );
// //       //         },
// //       //       ),
// //       body: Column(
// //         children: [
// //           _buildDatePicker(),
// //           Expanded(
// //             child: BlocConsumer<FeedCubit, FeedState>(
// //               listener: (context, state) {
// //                 if (state is FetchFeedFailure) {
// //                   ScaffoldMessenger.of(
// //                     context,
// //                   ).showSnackBar(SnackBar(content: Text(state.message)));
// //                 }
// //                 if (state is SaveFeedSuccess) {
// //                   _fetchFeed();
// //                 }

// //                 if (state is SaveFeedFailure) {
// //                   ScaffoldMessenger.of(
// //                     context,
// //                   ).showSnackBar(SnackBar(content: Text(state.message)));
// //                 }
// //                 if (state is DeleteFeedSuccess) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text(
// //                         state.response.message ?? 'Feed deleted successfully',
// //                       ),
// //                     ),
// //                   );

// //                   _fetchFeed();
// //                 }

// //                 if (state is DeleteFeedFailure) {
// //                   ScaffoldMessenger.of(
// //                     context,
// //                   ).showSnackBar(SnackBar(content: Text(state.message)));
// //                 }
// //               },
// //               builder: (context, state) {
// //                 if (state is FetchFeedLoading) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 if (state is FetchFeedSuccess) {
// //                   final feeds = state.response.data ?? [];

// //                   if (feeds.isEmpty) {
// //                     return const Center(child: Text("No Feed Available"));
// //                   }

// //                   return ListView.builder(
// //                     padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
// //                     itemCount: feeds.length,
// //                     itemBuilder: (context, index) {
// //                       final item = feeds[index];

// //                       // return FeedCard(
// //                       //   title: item.feedText ?? "",
// //                       //   date: item.createdDateFormatted ?? "",
// //                       //   imagePath: item.files != null && item.files!.isNotEmpty
// //                       //       ? item.files!.first.image ?? ""
// //                       //       : "",
// //                       //   onEdit: () {},
// //                       //   onDelete: () {
// //                       //     showDeleteDialog(index);
// //                       //   },
// //                       // );
// //                       return FeedCard(
// //                         title: (item.feedText ?? "")
// //                             .replaceAll(
// //                               RegExp(r'</?p\b[^>]*>', caseSensitive: false),
// //                               '',
// //                             )
// //                             .trim(),
// //                         date: item.createdDateFormatted ?? "",
// //                         imagePath: item.files != null && item.files!.isNotEmpty
// //                             ? item.files!.first.image ?? ""
// //                             : "",
// //                         onEdit: () async {
// //                           final feedId = item.feedId;

// //                           if (feedId == null || feedId <= 0) {
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               const SnackBar(content: Text('Invalid feed ID')),
// //                             );
// //                             return;
// //                           }

// //                           final feedCubit = context.read<FeedCubit>();

// //                           await Navigator.of(context).push(
// //                             MaterialPageRoute(
// //                               builder: (_) => BlocProvider.value(
// //                                 value: feedCubit,
// //                                 child: AddFeedScreen(feedId: feedId),
// //                               ),
// //                             ),
// //                           );

// //                           if (!mounted) return;

// //                           _fetchFeed();
// //                         },
// //                         onDelete: () {
// //                           showDeleteDialog(item.feedId!);
// //                         },
// //                       );
// //                     },
// //                   );
// //                 }

// //                 return const SizedBox();
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: const Color(0xff9b6ce3),
// //         elevation: 4,
// //         shape: const CircleBorder(),
// //         onPressed: () async {
// //           final result = await Navigator.of(context).push(
// //             MaterialPageRoute(
// //               builder: (context) {
// //                 return AddFeedScreen();
// //               },
// //             ),
// //           );

// //           if (!mounted) return;

// //           if (result == true) {
// //             _fetchFeed();
// //           }
// //         },
// //         child: const Icon(Icons.add, color: Colors.white, size: 34),
// //       ),
// //     );
// //   }

// //   Widget _buildDatePicker() {
// //     return Container(
// //       color: Colors.white,
// //       padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: _buildDateField(
// //               title: 'From date',
// //               date: fromDate,
// //               onTap: () => _selectDate(isFromDate: true),
// //             ),
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: _buildDateField(
// //               title: 'To date',
// //               date: toDate,
// //               onTap: () => _selectDate(isFromDate: false),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDateField({
// //     required String title,
// //     required DateTime? date,
// //     required VoidCallback onTap,
// //   }) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(11),
// //       child: Container(
// //         height: 44,
// //         padding: const EdgeInsets.symmetric(horizontal: 9),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(11),
// //           border: Border.all(color: borderColor),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 28,
// //               height: 28,
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFF7F3FF),
// //                 borderRadius: BorderRadius.circular(7),
// //               ),
// //               alignment: Alignment.center,
// //               child: SvgPicture.asset(
// //                 'assets/icons/Group (15).svg',
// //                 width: 15,
// //                 height: 15,
// //                 colorFilter: const ColorFilter.mode(
// //                   Color(0xFF8561E1),
// //                   BlendMode.srcIn,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: Text(
// //                 date == null ? title : _formatDisplayDate(date),
// //                 overflow: TextOverflow.ellipsis,
// //                 style: TextStyle(
// //                   fontSize: 11,
// //                   color: date == null
// //                       ? const Color(0xFF666666)
// //                       : Colors.black87,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class FeedCard extends StatelessWidget {
// //   final String title;
// //   final String date;
// //   final String imagePath;
// //   final VoidCallback onEdit;
// //   final VoidCallback onDelete;

// //   const FeedCard({
// //     super.key,
// //     required this.title,
// //     required this.date,
// //     required this.imagePath,
// //     required this.onEdit,
// //     required this.onDelete,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 120,
// //       margin: const EdgeInsets.only(bottom: 18),
// //       padding: const EdgeInsets.all(10),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(13),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.16),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           SizedBox(
// //             width: 150,
// //             height: 100,
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(9),
// //               child: imagePath.isNotEmpty
// //                   ? Image.network(
// //                       imagePath,
// //                       fit: BoxFit.cover,
// //                       loadingBuilder: (context, child, loadingProgress) {
// //                         if (loadingProgress == null) return child;

// //                         return const Center(
// //                           child: CircularProgressIndicator(strokeWidth: 2),
// //                         );
// //                       },
// //                       errorBuilder: (context, error, stackTrace) {
// //                         return Container(
// //                           color: Colors.grey.shade300,
// //                           child: const Icon(
// //                             Icons.image_not_supported,
// //                             color: Colors.grey,
// //                             size: 35,
// //                           ),
// //                         );
// //                       },
// //                     )
// //                   : Container(
// //                       color: Colors.grey.shade300,
// //                       child: const Icon(
// //                         Icons.image,
// //                         color: Colors.grey,
// //                         size: 35,
// //                       ),
// //                     ),
// //             ),
// //           ),

// //           const SizedBox(width: 12),

// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Align(
// //                   alignment: Alignment.topRight,
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       _ActionCircleButton(
// //                         svgIcon: "assets/icons/Group (6).svg",
// //                         onTap: onEdit,
// //                       ),
// //                       const SizedBox(width: 8),
// //                       _ActionCircleButton(
// //                         svgIcon: "assets/icons/Group (7).svg",
// //                         onTap: onDelete,
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 const SizedBox(height: 10),

// //                 Expanded(
// //                   child: Text(
// //                     title,
// //                     maxLines: 3,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: const TextStyle(
// //                       fontSize: 11.5,
// //                       height: 1.25,
// //                       color: Colors.black87,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),

// //                 Align(
// //                   alignment: Alignment.bottomRight,
// //                   child: Text(
// //                     date,
// //                     style: const TextStyle(
// //                       fontSize: 9.5,
// //                       color: Colors.black87,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _ActionCircleButton extends StatelessWidget {
// //   final String svgIcon;
// //   final VoidCallback onTap;

// //   const _ActionCircleButton({required this.svgIcon, required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(50),
// //       child: Container(
// //         width: 24,
// //         height: 24,
// //         decoration: const BoxDecoration(
// //           color: Color(0xffdec9ff),
// //           shape: BoxShape.circle,
// //         ),
// //         child: Center(child: SvgPicture.asset(svgIcon, width: 14, height: 14)),
// //       ),
// //     );
// //   }
// // }
// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/feed/domain/parameters/fetch_feed_parameter.dart';
// import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
// import 'package:cristalteacher/features/feed/presentation/screens/addfeed_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({super.key});

//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   static const Color primaryColor = Color(0xff9b6ce3);
//   static const Color borderColor = Color(0xFFE8E8E8);

//   DateTime? fromDate;
//   DateTime? toDate;

//   // Standard / division come from AppData, cached when the class details
//   // are fetched at login. No API call from this screen.

//   /// Teacher's own classes. Only used as a fallback source of divisions,
//   /// and to decide which standard opens first.
//   final List<TutorshipClass> tutorshipClasses = [];

//   /// Every standard in the branch. Falls back to the tutorship classes
//   /// when the full list was never cached.
//   final List<TutorshipClass> standardList = [];

//   int? selectedStandardId;
//   int? selectedDivisionId;

//   @override
//   void initState() {
//     super.initState();

//     final now = DateTime.now();
//     fromDate = DateTime(now.year, now.month, now.day);
//     toDate = DateTime(now.year, now.month, now.day);

//     tutorshipClasses.addAll(AppData.tutorshipClasses);

//     standardList.addAll(
//       AppData.standards.isNotEmpty
//           ? AppData.standards
//           : AppData.tutorshipClasses,
//     );

//     // Open with the first class already chosen instead of empty hints.
//     setInitialClassSelection();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       _fetchFeed();
//     });
//   }

//   /// Every standard, the full list first and the teacher's own classes
//   /// merged in behind it, so nothing is lost when one list misses a class.
//   List<TutorshipClass> get allStandards {
//     final Map<int, TutorshipClass> unique = {};

//     for (final TutorshipClass item in standardList) {
//       if (item.standardId != null) {
//         unique[item.standardId!] = item;
//       }
//     }

//     for (final TutorshipClass item in tutorshipClasses) {
//       if (item.standardId != null) {
//         unique.putIfAbsent(item.standardId!, () => item);
//       }
//     }

//     return unique.values.toList();
//   }

//   /// Divisions of [standard]. The complete standard list often carries no
//   /// divisions, so it falls back to the tutorship class with the same id.
//   List<DivisionDetails> divisionsFor(TutorshipClass standard) {
//     final List<DivisionDetails> own = List<DivisionDetails>.from(
//       standard.division ?? const <DivisionDetails>[],
//     );

//     if (own.isNotEmpty) {
//       return own;
//     }

//     for (final TutorshipClass item in tutorshipClasses) {
//       if (item.standardId == standard.standardId) {
//         return List<DivisionDetails>.from(
//           item.division ?? const <DivisionDetails>[],
//         );
//       }
//     }

//     return <DivisionDetails>[];
//   }

//   TutorshipClass? findStandard(int? standardId) {
//     if (standardId == null) return null;

//     for (final TutorshipClass item in standardList) {
//       if (item.standardId == standardId) {
//         return item;
//       }
//     }

//     // The full list may not hold this class - try the teacher's own
//     // tutorship classes as well.
//     for (final TutorshipClass item in tutorshipClasses) {
//       if (item.standardId == standardId) {
//         return item;
//       }
//     }

//     return null;
//   }

//   /// Picks the teacher's own class when there is one, otherwise the first
//   /// standard that actually has a division, then its first division, so
//   /// the filters are never blank on open.
//   void setInitialClassSelection() {
//     if (selectedStandardId != null) {
//       return;
//     }

//     // The teacher's own class is the one worth opening on.
//     for (final TutorshipClass standard in tutorshipClasses) {
//       final List<DivisionDetails> divisions = divisionsFor(standard);

//       if (divisions.isEmpty) {
//         continue;
//       }

//       selectedStandardId = standard.standardId;
//       selectedDivisionId = divisions.first.divisionId;

//       break;
//     }

//     // Nothing assigned - fall back to the first standard in the full list
//     // that carries a division.
//     if (selectedStandardId == null) {
//       for (final TutorshipClass standard in allStandards) {
//         final List<DivisionDetails> divisions = divisionsFor(standard);

//         if (divisions.isEmpty) {
//           continue;
//         }

//         selectedStandardId = standard.standardId;
//         selectedDivisionId = divisions.first.divisionId;

//         break;
//       }
//     }

//     debugPrint('');
//     debugPrint('======================================');
//     debugPrint('DEFAULT FEED CLASS SELECTION');
//     debugPrint('Standard Count: ${allStandards.length}');
//     debugPrint('Standard ID: $selectedStandardId');
//     debugPrint('Division ID: $selectedDivisionId');
//     debugPrint('======================================');
//   }

//   String _formatApiDate(DateTime date) {
//     return '${date.year.toString().padLeft(4, '0')}-'
//         '${date.month.toString().padLeft(2, '0')}-'
//         '${date.day.toString().padLeft(2, '0')}';
//   }

//   String _formatDisplayDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}-'
//         '${date.month.toString().padLeft(2, '0')}-'
//         '${date.year}';
//   }

//   void _fetchFeed() {
//     if (fromDate == null || toDate == null) return;

//     context.read<FeedCubit>().fetchFeed(
//       FetchFeedParams(
//         accYear: AppData.accYear,
//         standardId: selectedStandardId.toString(),
//         divisionId: selectedDivisionId.toString(),
//         fromDate: _formatApiDate(fromDate!),
//         toDate: _formatApiDate(toDate!),
//       ),
//     );
//   }

//   Future<void> _selectDate({required bool isFromDate}) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: isFromDate
//           ? fromDate ?? DateTime.now()
//           : toDate ?? fromDate ?? DateTime.now(),
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

//     if (pickedDate == null || !mounted) return;

//     final selectedDate = DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//     );

//     if (isFromDate) {
//       setState(() {
//         fromDate = selectedDate;
//       });

//       // Do not clear toDate and do not call the API here.
//       return;
//     }

//     if (fromDate == null) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(content: Text('Please select from date first')),
//         );
//       return;
//     }

//     if (selectedDate.isBefore(fromDate!)) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(content: Text('To date cannot be before from date')),
//         );
//       return;
//     }

//     setState(() {
//       toDate = selectedDate;
//     });

//     // API is called only after selecting the to date.
//     _fetchFeed();
//   }

//   // Future<void> _selectDate({required bool isFromDate}) async {
//   //   final pickedDate = await showDatePicker(
//   //     context: context,
//   //     initialDate: isFromDate
//   //         ? fromDate ?? DateTime.now()
//   //         : toDate ?? fromDate ?? DateTime.now(),
//   //     firstDate: DateTime(2020),
//   //     lastDate: DateTime(2035),
//   //     builder: (context, child) {
//   //       return Theme(
//   //         data: Theme.of(context).copyWith(
//   //           colorScheme: const ColorScheme.light(
//   //             primary: primaryColor,
//   //             onPrimary: Colors.white,
//   //             surface: Colors.white,
//   //             onSurface: Colors.black,
//   //           ),
//   //         ),
//   //         child: child!,
//   //       );
//   //     },
//   //   );

//   //   if (pickedDate == null || !mounted) return;

//   //   final selectedDate = DateTime(
//   //     pickedDate.year,
//   //     pickedDate.month,
//   //     pickedDate.day,
//   //   );

//   //   if (isFromDate) {
//   //     setState(() {
//   //       fromDate = selectedDate;
//   //       toDate = null;
//   //     });

//   //     return;
//   //   } else {
//   //     if (fromDate == null) {
//   //       ScaffoldMessenger.of(context)
//   //         ..hideCurrentSnackBar()
//   //         ..showSnackBar(
//   //           const SnackBar(content: Text('Please select from date first')),
//   //         );
//   //       return;
//   //     }

//   //     if (selectedDate.isBefore(fromDate!)) {
//   //       ScaffoldMessenger.of(context)
//   //         ..hideCurrentSnackBar()
//   //         ..showSnackBar(
//   //           const SnackBar(content: Text('To date cannot be before from date')),
//   //         );
//   //       return;
//   //     }

//   //     setState(() {
//   //       toDate = selectedDate;
//   //     });
//   //   }

//   //   _fetchFeed();
//   // }

//   void showDeleteDialog(int feedId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.black.withOpacity(0.35),
//       builder: (BuildContext dialogContext) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 34),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(28),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Are You Sure You Want To\nDelete This Post?",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                     height: 1.3,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 92,
//                       height: 38,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(dialogContext);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xffe9e9e9),
//                           foregroundColor: Colors.black,
//                           elevation: 0,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: const Text(
//                           "NO",
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 18),
//                     SizedBox(
//                       width: 92,
//                       height: 38,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(dialogContext);

//                           context.read<FeedCubit>().deleteFeed(feedId);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xff8f83dc),
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: const Text(
//                           "Yes",
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TutorshipClass? selectedStandard = findStandard(selectedStandardId);

//     final List<DivisionDetails> divisions = selectedStandard == null
//         ? <DivisionDetails>[]
//         : divisionsFor(selectedStandard);

//     return Scaffold(
//       backgroundColor: const Color(0xfff7f7f7),

//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         surfaceTintColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Feed",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       // body: feedItems.isEmpty
//       //     ? const Center(
//       //         child: Text(
//       //           "No Feed Available",
//       //           style: TextStyle(
//       //             fontSize: 14,
//       //             color: Colors.black54,
//       //             fontWeight: FontWeight.w500,
//       //           ),
//       //         ),
//       //       )
//       //     : ListView.builder(
//       //         padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
//       //         itemCount: feedItems.length,
//       //         itemBuilder: (context, index) {
//       //           final item = feedItems[index];

//       //           return FeedCard(
//       //             title: item["title"]!,
//       //             date: item["date"]!,
//       //             imagePath: item["image"]!,
//       //             onEdit: () {
//       //               debugPrint("Edit tapped");
//       //             },
//       //             onDelete: () {
//       //               showDeleteDialog(index);
//       //             },
//       //           );
//       //         },
//       //       ),
//       body: Column(
//         children: [
//           _buildDatePicker(),

//           // Standard and Division dropdowns
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Builder(
//                     builder: (context) {
//                       final List<DropdownMenuItem<int>> items = allStandards
//                           .where((item) => item.standardId != null)
//                           .map((item) {
//                             return DropdownMenuItem<int>(
//                               value: item.standardId,
//                               child: Text(
//                                 item.standard ?? '',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             );
//                           })
//                           .toList();

//                       final DropdownMenuItem<int>? selectedItem =
//                           selectedItemOf<int>(items, selectedStandardId);

//                       return GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: items.isEmpty
//                             ? null
//                             : () async {
//                                 final PickerSelection<int>? result =
//                                     await showOptionPickerSheet<int>(
//                                       context: context,
//                                       title: 'Select Standard',
//                                       items: items,
//                                       selectedValue: selectedStandardId,
//                                     );

//                                 if (!mounted || result == null) {
//                                   return;
//                                 }

//                                 setState(() {
//                                   selectedStandardId = result.value;
//                                   selectedDivisionId = null;
//                                 });

//                                 _fetchFeed();
//                               },
//                         child: InputDecorator(
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 11,
//                               vertical: 14,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(11),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFE5E2EA),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(11),
//                               borderSide: const BorderSide(color: primaryColor),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child:
//                                     selectedItem?.child ??
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                           'assets/icons/Clip path group (1).svg',
//                                           width: 14,
//                                           height: 14,
//                                           fit: BoxFit.contain,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         const Text(
//                                           'Standard',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                               ),
//                               const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: primaryColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Builder(
//                     builder: (context) {
//                       final List<DropdownMenuItem<int>> items = divisions
//                           .where((item) => item.divisionId != null)
//                           .map((item) {
//                             return DropdownMenuItem<int>(
//                               value: item.divisionId,
//                               child: Text(
//                                 item.division ?? '',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             );
//                           })
//                           .toList();

//                       final DropdownMenuItem<int>? selectedItem =
//                           selectedItemOf<int>(items, selectedDivisionId);

//                       return GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: selectedStandardId == null || items.isEmpty
//                             ? null
//                             : () async {
//                                 final PickerSelection<int>? result =
//                                     await showOptionPickerSheet<int>(
//                                       context: context,
//                                       title: 'Select Division',
//                                       items: items,
//                                       selectedValue: selectedDivisionId,
//                                     );

//                                 if (!mounted || result == null) {
//                                   return;
//                                 }

//                                 setState(() {
//                                   selectedDivisionId = result.value;
//                                 });

//                                 _fetchFeed();
//                               },
//                         child: InputDecorator(
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 11,
//                               vertical: 14,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(11),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFE5E2EA),
//                               ),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(11),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFE5E2EA),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(11),
//                               borderSide: const BorderSide(color: primaryColor),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child:
//                                     selectedItem?.child ??
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                           'assets/icons/Clip path group (1).svg',
//                                           width: 14,
//                                           height: 14,
//                                           fit: BoxFit.contain,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         const Text(
//                                           'Division',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                               ),
//                               const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: primaryColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: BlocConsumer<FeedCubit, FeedState>(
//               listener: (context, state) {
//                 if (state is FetchFeedFailure) {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//                 if (state is SaveFeedSuccess) {
//                   _fetchFeed();
//                 }

//                 if (state is SaveFeedFailure) {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//                 if (state is DeleteFeedSuccess) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         state.response.message ?? 'Feed deleted successfully',
//                       ),
//                     ),
//                   );

//                   _fetchFeed();
//                 }

//                 if (state is DeleteFeedFailure) {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//               },
//               builder: (context, state) {
//                 if (state is FetchFeedLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (state is FetchFeedSuccess) {
//                   final feeds = state.response.data ?? [];

//                   if (feeds.isEmpty) {
//                     return const Center(child: Text("No Feed Available"));
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
//                     itemCount: feeds.length,
//                     itemBuilder: (context, index) {
//                       final item = feeds[index];

//                       // return FeedCard(
//                       //   title: item.feedText ?? "",
//                       //   date: item.createdDateFormatted ?? "",
//                       //   imagePath: item.files != null && item.files!.isNotEmpty
//                       //       ? item.files!.first.image ?? ""
//                       //       : "",
//                       //   onEdit: () {},
//                       //   onDelete: () {
//                       //     showDeleteDialog(index);
//                       //   },
//                       // );
//                       return FeedCard(
//                         title: (item.feedText ?? "")
//                             .replaceAll(
//                               RegExp(r'</?p\b[^>]*>', caseSensitive: false),
//                               '',
//                             )
//                             .trim(),
//                         date: item.createdDateFormatted ?? "",
//                         imagePath: item.files != null && item.files!.isNotEmpty
//                             ? item.files!.first.image ?? ""
//                             : "",
//                         onEdit: () async {
//                           final feedId = item.feedId;

//                           if (feedId == null || feedId <= 0) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Invalid feed ID')),
//                             );
//                             return;
//                           }

//                           final feedCubit = context.read<FeedCubit>();

//                           await Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => BlocProvider.value(
//                                 value: feedCubit,
//                                 child: AddFeedScreen(feedId: feedId),
//                               ),
//                             ),
//                           );

//                           if (!mounted) return;

//                           _fetchFeed();
//                         },
//                         onDelete: () {
//                           showDeleteDialog(item.feedId!);
//                         },
//                       );
//                     },
//                   );
//                 }

//                 return const SizedBox();
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xff9b6ce3),
//         elevation: 4,
//         shape: const CircleBorder(),
//         onPressed: () async {
//           final result = await Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) {
//                 return AddFeedScreen();
//               },
//             ),
//           );

//           if (!mounted) return;

//           if (result == true) {
//             _fetchFeed();
//           }
//         },
//         child: const Icon(Icons.add, color: Colors.white, size: 34),
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildDateField(
//               title: 'From date',
//               date: fromDate,
//               onTap: () => _selectDate(isFromDate: true),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _buildDateField(
//               title: 'To date',
//               date: toDate,
//               onTap: () => _selectDate(isFromDate: false),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField({
//     required String title,
//     required DateTime? date,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(11),
//       child: Container(
//         height: 44,
//         padding: const EdgeInsets.symmetric(horizontal: 9),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(11),
//           border: Border.all(color: borderColor),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 28,
//               height: 28,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF7F3FF),
//                 borderRadius: BorderRadius.circular(7),
//               ),
//               alignment: Alignment.center,
//               child: SvgPicture.asset(
//                 'assets/icons/Group (15).svg',
//                 width: 15,
//                 height: 15,
//                 colorFilter: const ColorFilter.mode(
//                   Color(0xFF8561E1),
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 date == null ? title : _formatDisplayDate(date),
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: date == null
//                       ? const Color(0xFF666666)
//                       : Colors.black87,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FeedCard extends StatelessWidget {
//   final String title;
//   final String date;
//   final String imagePath;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const FeedCard({
//     super.key,
//     required this.title,
//     required this.date,
//     required this.imagePath,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.only(bottom: 18),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(13),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.16),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 150,
//             height: 100,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(9),
//               child: imagePath.isNotEmpty
//                   ? Image.network(
//                       imagePath,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;

//                         return const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey.shade300,
//                           child: const Icon(
//                             Icons.image_not_supported,
//                             color: Colors.grey,
//                             size: 35,
//                           ),
//                         );
//                       },
//                     )
//                   : Container(
//                       color: Colors.grey.shade300,
//                       child: const Icon(
//                         Icons.image,
//                         color: Colors.grey,
//                         size: 35,
//                       ),
//                     ),
//             ),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _ActionCircleButton(
//                         svgIcon: "assets/icons/Group (6).svg",
//                         onTap: onEdit,
//                       ),
//                       const SizedBox(width: 8),
//                       _ActionCircleButton(
//                         svgIcon: "assets/icons/Group (7).svg",
//                         onTap: onDelete,
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 Expanded(
//                   child: Text(
//                     title,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 11.5,
//                       height: 1.25,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),

//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     date,
//                     style: const TextStyle(
//                       fontSize: 9.5,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionCircleButton extends StatelessWidget {
//   final String svgIcon;
//   final VoidCallback onTap;

//   const _ActionCircleButton({required this.svgIcon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(50),
//       child: Container(
//         width: 24,
//         height: 24,
//         decoration: const BoxDecoration(
//           color: Color(0xffdec9ff),
//           shape: BoxShape.circle,
//         ),
//         child: Center(child: SvgPicture.asset(svgIcon, width: 14, height: 14)),
//       ),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/feed/domain/parameters/fetch_feed_parameter.dart';
import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:cristalteacher/features/feed/presentation/screens/addfeed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const Color primaryColor = Color(0xff9b6ce3);
  static const Color borderColor = Color(0xFFE8E8E8);

  DateTime? fromDate;
  DateTime? toDate;

  final List<TutorshipClass> tutorshipClasses = [];

  final List<TutorshipClass> standardList = [];

  int? selectedStandardId;
  int? selectedDivisionId;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, now.day);
    toDate = DateTime(now.year, now.month, now.day);

    tutorshipClasses.addAll(AppData.tutorshipClasses);

    standardList.addAll(
      AppData.standards.isNotEmpty
          ? AppData.standards
          : AppData.tutorshipClasses,
    );

    // Initially NO standard/division is selected.
    // API will be called with standardId = null
    // and divisionId = null.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchFeed();
    });
  }

  List<TutorshipClass> get allStandards {
    final Map<int, TutorshipClass> unique = {};

    for (final TutorshipClass item in standardList) {
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

  List<DivisionDetails> divisionsFor(TutorshipClass standard) {
    final List<DivisionDetails> own = List<DivisionDetails>.from(
      standard.division ?? const <DivisionDetails>[],
    );

    if (own.isNotEmpty) {
      return own;
    }

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId == standard.standardId) {
        return List<DivisionDetails>.from(
          item.division ?? const <DivisionDetails>[],
        );
      }
    }

    return <DivisionDetails>[];
  }

  TutorshipClass? findStandard(int? standardId) {
    if (standardId == null) return null;

    for (final TutorshipClass item in standardList) {
      if (item.standardId == standardId) {
        return item;
      }
    }

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId == standardId) {
        return item;
      }
    }

    return null;
  }

  String _formatApiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDisplayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  void _fetchFeed() {
    if (fromDate == null || toDate == null) return;

    debugPrint('');
    debugPrint('======================================');
    debugPrint('FETCH FEED');
    debugPrint('Standard ID: $selectedStandardId');
    debugPrint('Division ID: $selectedDivisionId');
    debugPrint('From Date: ${_formatApiDate(fromDate!)}');
    debugPrint('To Date: ${_formatApiDate(toDate!)}');
    debugPrint('======================================');

    context.read<FeedCubit>().fetchFeed(
      FetchFeedParams(
        accYear: AppData.accYear,

        // IMPORTANT:
        // Initial call sends null, NOT "null"
        standardId: selectedStandardId?.toString(),
        divisionId: selectedDivisionId?.toString(),

        fromDate: _formatApiDate(fromDate!),
        toDate: _formatApiDate(toDate!),
      ),
    );
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? fromDate ?? DateTime.now()
          : toDate ?? fromDate ?? DateTime.now(),
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

    if (pickedDate == null || !mounted) return;

    final selectedDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );

    if (isFromDate) {
      setState(() {
        fromDate = selectedDate;
      });

      // Do not call API when only From Date changes.
      return;
    }

    if (fromDate == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Please select from date first')),
        );
      return;
    }

    if (selectedDate.isBefore(fromDate!)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('To date cannot be before from date')),
        );
      return;
    }

    setState(() {
      toDate = selectedDate;
    });

    // Date API call.
    // If no standard/division is selected, null/null is sent.
    // If both are selected, their IDs are sent.
    _fetchFeed();
  }

  void showDeleteDialog(int feedId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 34),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are You Sure You Want To\nDelete This Post?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 92,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffe9e9e9),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "NO",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    SizedBox(
                      width: 92,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);

                          context.read<FeedCubit>().deleteFeed(feedId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff8f83dc),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    final TutorshipClass? selectedStandard = findStandard(selectedStandardId);

    final List<DivisionDetails> divisions = selectedStandard == null
        ? <DivisionDetails>[]
        : divisionsFor(selectedStandard);

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Feed",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildDatePicker(),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final List<DropdownMenuItem<int>> items = allStandards
                          .where((item) => item.standardId != null)
                          .map((item) {
                            return DropdownMenuItem<int>(
                              value: item.standardId,
                              child: Text(
                                item.standard ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          })
                          .toList();

                      final DropdownMenuItem<int>? selectedItem =
                          selectedItemOf<int>(items, selectedStandardId);

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
                                      selectedValue: selectedStandardId,
                                    );

                                if (!mounted || result == null) {
                                  return;
                                }

                                setState(() {
                                  selectedStandardId = result.value;

                                  // Clear division when standard changes.
                                  // API will NOT be called here.
                                  selectedDivisionId = null;
                                });

                                debugPrint(
                                  'Standard selected: $selectedStandardId',
                                );
                                debugPrint(
                                  'Division cleared. Waiting for division selection.',
                                );
                              },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E2EA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    selectedItem?.child ??
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Clip path group (1).svg',
                                          width: 14,
                                          height: 14,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Standard',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final List<DropdownMenuItem<int>> items = divisions
                          .where((item) => item.divisionId != null)
                          .map((item) {
                            return DropdownMenuItem<int>(
                              value: item.divisionId,
                              child: Text(
                                item.division ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          })
                          .toList();

                      final DropdownMenuItem<int>? selectedItem =
                          selectedItemOf<int>(items, selectedDivisionId);

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: selectedStandardId == null || items.isEmpty
                            ? null
                            : () async {
                                final PickerSelection<int>? result =
                                    await showOptionPickerSheet<int>(
                                      context: context,
                                      title: 'Select Division',
                                      items: items,
                                      selectedValue: selectedDivisionId,
                                    );

                                if (!mounted || result == null) {
                                  return;
                                }

                                setState(() {
                                  selectedDivisionId = result.value;
                                });

                                debugPrint('Standard ID: $selectedStandardId');
                                debugPrint('Division ID: $selectedDivisionId');

                                // API is called ONLY here,
                                // after both Standard and Division are selected.
                                _fetchFeed();
                              },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E2EA),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E2EA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    selectedItem?.child ??
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Clip path group (1).svg',
                                          width: 14,
                                          height: 14,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Division',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocConsumer<FeedCubit, FeedState>(
              listener: (context, state) {
                if (state is FetchFeedFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is SaveFeedSuccess) {
                  _fetchFeed();
                }

                if (state is SaveFeedFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is DeleteFeedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.response.message ?? 'Feed deleted successfully',
                      ),
                    ),
                  );

                  _fetchFeed();
                }

                if (state is DeleteFeedFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is FetchFeedLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FetchFeedSuccess) {
                  final feeds = state.response.data ?? [];

                  if (feeds.isEmpty) {
                    return const Center(child: Text("No Feed Available"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      final item = feeds[index];

                      return FeedCard(
                        key: ValueKey(item.feedId),
                        title: (item.feedText ?? "")
                            .replaceAll(
                              RegExp(r'</?p\b[^>]*>', caseSensitive: false),
                              '',
                            )
                            .trim(),
                        date: item.createdDateFormatted ?? "",
                        imagePaths: [
                          if (item.files != null)
                            for (final file in item.files!)
                              if ((file.image ?? '').trim().isNotEmpty)
                                file.image!.trim(),
                        ],
                        onEdit: () async {
                          final feedId = item.feedId;

                          if (feedId == null || feedId <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid feed ID')),
                            );
                            return;
                          }

                          final feedCubit = context.read<FeedCubit>();

                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: feedCubit,
                                child: AddFeedScreen(feedId: feedId),
                              ),
                            ),
                          );

                          if (!mounted) return;

                          _fetchFeed();
                        },
                        onDelete: () {
                          showDeleteDialog(item.feedId!);
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff9b6ce3),
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddFeedScreen();
              },
            ),
          );

          if (!mounted) return;

          if (result == true) {
            _fetchFeed();
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 34),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField(
              title: 'From date',
              date: fromDate,
              onTap: () => _selectDate(isFromDate: true),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDateField(
              title: 'To date',
              date: toDate,
              onTap: () => _selectDate(isFromDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3FF),
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/Group (15).svg',
                width: 15,
                height: 15,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF8561E1),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date == null ? title : _formatDisplayDate(date),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: date == null
                      ? const Color(0xFF666666)
                      : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class FeedCard extends StatelessWidget {
//   final String title;
//   final String date;
//   final String imagePath;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const FeedCard({
//     super.key,
//     required this.title,
//     required this.date,
//     required this.imagePath,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.only(bottom: 18),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(13),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.16),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 150,
//             height: 100,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(9),
//               child: imagePath.isNotEmpty
//                   ? Image.network(
//                       imagePath,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) {
//                           return child;
//                         }

//                         return const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey.shade300,
//                           child: const Icon(
//                             Icons.image_not_supported,
//                             color: Colors.grey,
//                             size: 35,
//                           ),
//                         );
//                       },
//                     )
//                   : Container(
//                       color: Colors.grey.shade300,
//                       child: const Icon(
//                         Icons.image,
//                         color: Colors.grey,
//                         size: 35,
//                       ),
//                     ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _ActionCircleButton(
//                         svgIcon: "assets/icons/Group (6).svg",
//                         onTap: onEdit,
//                       ),
//                       const SizedBox(width: 8),
//                       _ActionCircleButton(
//                         svgIcon: "assets/icons/Group (7).svg",
//                         onTap: onDelete,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: Text(
//                     title,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 11.5,
//                       height: 1.25,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     date,
//                     style: const TextStyle(
//                       fontSize: 9.5,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class FeedCard extends StatefulWidget {
  final String title;
  final String date;
  final List<String> imagePaths;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FeedCard({
    super.key,
    required this.title,
    required this.date,
    required this.imagePaths,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  int _currentImageIndex = 0;

  @override
  void didUpdateWidget(covariant FeedCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_sameImages(oldWidget.imagePaths, widget.imagePaths)) {
      _currentImageIndex = 0;
    }
  }

  bool _sameImages(List<String> first, List<String> second) {
    if (first.length != second.length) return false;

    for (int index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }

    return true;
  }

  Widget _placeholder({bool failed = false}) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: Icon(
        failed ? Icons.image_not_supported : Icons.image,
        color: Colors.grey,
        size: 35,
      ),
    );
  }

  Widget _networkImage(String url) {
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stackTrace) {
        return _placeholder(failed: true);
      },
    );
  }

  Widget _buildImages() {
    final List<String> images = widget.imagePaths;

    if (images.isEmpty) {
      return _placeholder();
    }

    if (images.length == 1) {
      return _networkImage(images.first);
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: images.length == 2 ? 2 : 2,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: _networkImage(images[index]),
        );
      },
    );
  }
  // Widget _buildImages() {
  //   final List<String> images = widget.imagePaths;

  //   if (images.isEmpty) {
  //     return _placeholder();
  //   }

  //   if (images.length == 1) {
  //     return _networkImage(images.first);
  //   }

  //   return Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       PageView.builder(
  //         key: ValueKey<String>(images.join('|')),
  //         itemCount: images.length,
  //         onPageChanged: (index) {
  //           setState(() {
  //             _currentImageIndex = index;
  //           });
  //         },
  //         itemBuilder: (context, index) {
  //           return _networkImage(images[index]);
  //         },
  //       ),
  //       Positioned(
  //         top: 5,
  //         right: 5,
  //         child: IgnorePointer(
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
  //             decoration: BoxDecoration(
  //               color: Colors.black.withOpacity(0.65),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Text(
  //               '${_currentImageIndex + 1}/${images.length}',
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 9,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         bottom: 5,
  //         left: 0,
  //         right: 0,
  //         child: IgnorePointer(
  //           child: Center(
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
  //               decoration: BoxDecoration(
  //                 color: Colors.black.withOpacity(0.55),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: const Text(
  //                 'Swipe ↔',
  //                 style: TextStyle(color: Colors.white, fontSize: 9),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: _buildImages(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionCircleButton(
                        svgIcon: 'assets/icons/Group (6).svg',
                        onTap: widget.onEdit,
                      ),
                      const SizedBox(width: 8),
                      _ActionCircleButton(
                        svgIcon: 'assets/icons/Group (7).svg',
                        onTap: widget.onDelete,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.25,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.date,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  final String svgIcon;
  final VoidCallback onTap;

  const _ActionCircleButton({required this.svgIcon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xffdec9ff),
          shape: BoxShape.circle,
        ),
        child: Center(child: SvgPicture.asset(svgIcon, width: 14, height: 14)),
      ),
    );
  }
}
