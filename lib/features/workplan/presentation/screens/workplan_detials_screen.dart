// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/workplan/domain/entities/workplan_response_entity.dart';
// import 'package:cristalteacher/features/workplan/domain/entities/workplandetails_response_entity.dart';
// import 'package:cristalteacher/features/workplan/domain/parameters/fetch_workplan_parameter.dart';
// import 'package:cristalteacher/features/workplan/domain/parameters/fetch_workplandetails_parameter.dart';
// import 'package:cristalteacher/features/workplan/presentation/cubit/workplan_cubit.dart';
// import 'package:cristalteacher/features/workplan/presentation/screens/workplan_creating_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';

// class WorkplanDetialsScreen extends StatefulWidget {
//   const WorkplanDetialsScreen({super.key});

//   @override
//   State<WorkplanDetialsScreen> createState() => _WorkplanDetialsScreenState();
// }

// class _WorkplanDetialsScreenState extends State<WorkplanDetialsScreen> {
//   static const Color primaryColor = Color(0xFF5735E5);
//   static const Color backgroundColor = Color(0xFFF8F7FF);
//   static const Color lightBlue = Color(0xFFE7F0FF);
//   static const Color blueColor = Color(0xFF0758C9);
//   static const Color textColor = Color(0xFF25232A);

//   final List<WorkPlanData> workPlans = [];
//   final List<WorkPlanDetailsData> workPlanDetails = [];

//   // Standard / division come from AppData, cached when the tutorship
//   // classes are fetched at login. No API call from this screen.
//   final List<TutorshipClass> tutorshipClasses = [];

//   String? selectedAccYear;

//   int? selectedWorkPlanId;
//   int? selectedStandardId;
//   int? selectedDivisionId;

//   bool isFetchingWorkPlans = false;
//   bool isFetchingDetails = false;

//   @override
//   void initState() {
//     super.initState();

//     tutorshipClasses.addAll(AppData.tutorshipClasses);

//     // Open with the first class already chosen instead of empty hints.
//     setInitialClassSelection();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       debugPrint('');
//       debugPrint('======================================');
//       debugPrint('FETCH INITIAL WORK PLAN DATA');
//       debugPrint('======================================');

//       // Academic year is still fetched; the classes are already local.
//       context.read<AuthenticationCubit>().fetchAccYear();

//       final now = DateTime.now();

//       final currentDateTime =
//           '${now.year.toString().padLeft(4, '0')}-'
//           '${now.month.toString().padLeft(2, '0')}-'
//           '${now.day.toString().padLeft(2, '0')} '
//           '${now.hour.toString().padLeft(2, '0')}:'
//           '${now.minute.toString().padLeft(2, '0')}:'
//           '${now.second.toString().padLeft(2, '0')}';

//       final workPlanRequest = FetchWorkPlanParameter(
//         branchId: 1,
//         accYear: null,
//         fromDate: null,
//         toDate: null,
//         status: 'Open',
//         currentDateTime: currentDateTime,
//       );

//       debugPrint('Work Plan Request: ${workPlanRequest.toJson()}');

//       context.read<WorkplanCubit>().fetchWorkPlans(workPlanRequest);

//       // Standard / division carry the default selection, so the list
//       // matches what the dropdowns are showing.
//       final detailsRequest = FetchWorkPlanDetailsParameter(
//         branchId: 1,
//         accYear: null,
//         workPlanId: null,
//         standardId: selectedStandardId,
//         divisionId: selectedDivisionId,
//         fromDate: null,
//         toDate: null,
//       );

//       debugPrint(
//         'Initial Details Request: '
//         '${detailsRequest.toJson()}',
//       );

//       context.read<WorkplanCubit>().fetchWorkPlanDetails(detailsRequest);
//     });
//   }

//   /// Picks the first standard that actually has a division, then its
//   /// first division, so the filters are never blank on open.
//   void setInitialClassSelection() {
//     if (tutorshipClasses.isEmpty || selectedStandardId != null) {
//       return;
//     }

//     for (final standard in tutorshipClasses) {
//       final divisions = standard.division ?? <DivisionDetails>[];

//       if (divisions.isEmpty) {
//         continue;
//       }

//       selectedStandardId = standard.standardId;
//       selectedDivisionId = divisions.first.divisionId;

//       break;
//     }

//     debugPrint('');
//     debugPrint('======================================');
//     debugPrint('DEFAULT CLASS SELECTION');
//     debugPrint('Standard ID: $selectedStandardId');
//     debugPrint('Division ID: $selectedDivisionId');
//     debugPrint('======================================');
//   }

//   Future<void> fetchDetails() async {
//     final request = FetchWorkPlanDetailsParameter(
//       branchId: 1,
//       accYear: selectedAccYear,
//       workPlanId: selectedWorkPlanId,
//       standardId: selectedStandardId,
//       divisionId: selectedDivisionId,
//       fromDate: null,
//       toDate: null,
//     );

//     debugPrint('');
//     debugPrint('======================================');
//     debugPrint('FETCH FILTERED WORK PLAN DETAILS');
//     debugPrint('Request: ${request.toJson()}');
//     debugPrint('======================================');

//     await context.read<WorkplanCubit>().fetchWorkPlanDetails(request);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedStandard = tutorshipClasses
//         .where((item) => item.standardId == selectedStandardId)
//         .toList();

//     final List<DivisionDetails> divisions = selectedStandard.isNotEmpty
//         ? selectedStandard.first.division ?? []
//         : [];

//     return BlocListener<AuthenticationCubit, AuthenticationState>(
//       listener: (context, state) {
//         if (state is FetchAccYearSuccess) {
//           String? activeAcademicYear;

//           for (final year in state.response.data ?? []) {
//             if (year.status == true) {
//               activeAcademicYear = year.accYear;
//               break;
//             }
//           }

//           activeAcademicYear ??= state.response.data?.isNotEmpty == true
//               ? state.response.data!.first.accYear
//               : null;

//           setState(() {
//             selectedAccYear = activeAcademicYear;
//           });

//           debugPrint('');
//           debugPrint('======================================');
//           debugPrint('ACADEMIC YEAR SUCCESS');
//           debugPrint('Selected Academic Year: $selectedAccYear');
//           debugPrint('======================================');
//         }

//         if (state is FetchAccYearFailure) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//         }
//       },
//       child: BlocConsumer<WorkplanCubit, WorkplanState>(
//         listener: (context, state) {
//           debugPrint('Workplan State: ${state.runtimeType}');

//           if (state is FetchWorkPlanLoading) {
//             setState(() {
//               isFetchingWorkPlans = true;
//             });
//           }

//           if (state is FetchWorkPlanSuccess) {
//             final data = state.response.data ?? [];

//             setState(() {
//               isFetchingWorkPlans = false;

//               workPlans
//                 ..clear()
//                 ..addAll(data);

//               // Initial value remains null.
//               // Details are fetched only when user selects.
//               selectedWorkPlanId = null;
//             });

//             debugPrint('');
//             debugPrint('======================================');
//             debugPrint('WORK PLANS SUCCESS');
//             debugPrint('Count: ${workPlans.length}');

//             for (final item in workPlans) {
//               debugPrint(
//                 'ID: ${item.id} | '
//                 'Week: ${item.weekName}',
//               );
//             }

//             debugPrint('======================================');
//           }

//           if (state is FetchWorkPlanFailure) {
//             setState(() {
//               isFetchingWorkPlans = false;
//             });

//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//           }

//           if (state is FetchWorkPlanDetailsLoading) {
//             setState(() {
//               isFetchingDetails = true;
//             });
//           }

//           if (state is FetchWorkPlanDetailsSuccess) {
//             final data = state.response.data ?? [];

//             setState(() {
//               isFetchingDetails = false;

//               workPlanDetails
//                 ..clear()
//                 ..addAll(data);
//             });

//             debugPrint('');
//             debugPrint('======================================');
//             debugPrint('WORK PLAN DETAILS SUCCESS');
//             debugPrint('Details Count: ${workPlanDetails.length}');

//             for (final item in workPlanDetails) {
//               debugPrint(
//                 'ID: ${item.id} | '
//                 'Master ID: ${item.masterId} | '
//                 'Week: ${item.weekName} | '
//                 'Standard: ${item.standard} | '
//                 'Division: ${item.division} | '
//                 'Subject: ${item.subjectName} | '
//                 'Topic: ${item.topic}',
//               );
//             }

//             debugPrint('======================================');
//           }

//           if (state is FetchWorkPlanDetailsFailure) {
//             setState(() {
//               isFetchingDetails = false;
//             });

//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: backgroundColor,
//             appBar: AppBar(
//               toolbarHeight: 72,
//               backgroundColor: Colors.white,
//               surfaceTintColor: Colors.white,
//               elevation: 0,
//               centerTitle: true,
//               leadingWidth: 68,
//               leading: IconButton(
//                 onPressed: () => Navigator.maybePop(context),
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                   size: 25,
//                 ),
//               ),
//               title: const Text(
//                 'Class Plan Details',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             body: SafeArea(
//               top: false,
//               child: Column(
//                 children: [
//                   Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
//                     child: Column(
//                       children: [
//                         Builder(
//                           builder: (context) {
//                             final List<DropdownMenuItem<int>> items = workPlans
//                                 .where((item) => item.id != null)
//                                 .map((item) {
//                                   return DropdownMenuItem<int>(
//                                     value: item.id,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 31,
//                                           height: 31,
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFFF0EDFF),
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           child: const Icon(
//                                             Icons.menu_book_rounded,
//                                             color: primaryColor,
//                                             size: 17,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 11),
//                                         Expanded(
//                                           child: Text(
//                                             item.weekName ?? 'Work Plan',
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                               color: textColor,
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 })
//                                 .toList();

//                             final DropdownMenuItem<int>? selectedItem =
//                                 selectedItemOf<int>(items, selectedWorkPlanId);

//                             return GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap: isFetchingWorkPlans || items.isEmpty
//                                   ? null
//                                   : () async {
//                                       final PickerSelection<int>? result =
//                                           await showOptionPickerSheet<int>(
//                                             context: context,
//                                             title: 'Select Work Plan',
//                                             items: items,
//                                             selectedValue: selectedWorkPlanId,
//                                           );

//                                       if (!mounted || result == null) {
//                                         return;
//                                       }

//                                       setState(() {
//                                         selectedWorkPlanId = result.value;
//                                       });

//                                       await fetchDetails();
//                                     },
//                               child: InputDecorator(
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 14,
//                                     vertical: 14,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(11),
//                                     borderSide: const BorderSide(
//                                       color: Color(0xFFE5E2EA),
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(11),
//                                     borderSide: const BorderSide(
//                                       color: primaryColor,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child:
//                                           selectedItem?.child ??
//                                           Row(
//                                             children: [
//                                               SvgPicture.asset(
//                                                 'assets/icons/Group (23).svg',
//                                                 width: 14,
//                                                 height: 14,
//                                                 fit: BoxFit.contain,
//                                               ),
//                                               const SizedBox(width: 8),
//                                               Text(
//                                                 isFetchingWorkPlans
//                                                     ? 'Loading work plans...'
//                                                     : 'Select Work Plan',
//                                                 style: const TextStyle(
//                                                   color: Color(0xFF77717D),
//                                                   fontSize: 13,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                     ),
//                                     if (isFetchingWorkPlans)
//                                       const SizedBox(
//                                         width: 19,
//                                         height: 19,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: primaryColor,
//                                         ),
//                                       )
//                                     else
//                                       const Icon(
//                                         Icons.keyboard_arrow_down_rounded,
//                                         color: primaryColor,
//                                         size: 25,
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Builder(
//                                 builder: (context) {
//                                   final List<DropdownMenuItem<int>> items =
//                                       tutorshipClasses
//                                           .where(
//                                             (item) => item.standardId != null,
//                                           )
//                                           .map((item) {
//                                             return DropdownMenuItem<int>(
//                                               value: item.standardId,
//                                               child: Text(
//                                                 item.standard ?? '',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             );
//                                           })
//                                           .toList();

//                                   final DropdownMenuItem<int>? selectedItem =
//                                       selectedItemOf<int>(
//                                         items,
//                                         selectedStandardId,
//                                       );

//                                   return GestureDetector(
//                                     behavior: HitTestBehavior.opaque,
//                                     onTap: items.isEmpty
//                                         ? null
//                                         : () async {
//                                             final PickerSelection<int>? result =
//                                                 await showOptionPickerSheet<
//                                                   int
//                                                 >(
//                                                   context: context,
//                                                   title: 'Select Standard',
//                                                   items: items,
//                                                   selectedValue:
//                                                       selectedStandardId,
//                                                 );

//                                             if (!mounted || result == null) {
//                                               return;
//                                             }

//                                             setState(() {
//                                               selectedStandardId = result.value;
//                                               selectedDivisionId = null;
//                                             });

//                                             await fetchDetails();
//                                           },
//                                     child: InputDecorator(
//                                       decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: Colors.white,
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                               horizontal: 11,
//                                               vertical: 14,
//                                             ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             11,
//                                           ),
//                                           borderSide: const BorderSide(
//                                             color: Color(0xFFE5E2EA),
//                                           ),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             11,
//                                           ),
//                                           borderSide: const BorderSide(
//                                             color: primaryColor,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child:
//                                                 selectedItem?.child ??
//                                                 Row(
//                                                   children: [
//                                                     SvgPicture.asset(
//                                                       'assets/icons/Clip path group (1).svg',
//                                                       width: 14,
//                                                       height: 14,
//                                                       fit: BoxFit.contain,
//                                                     ),
//                                                     const SizedBox(width: 8),
//                                                     const Text(
//                                                       'Standard',
//                                                       style: TextStyle(
//                                                         fontSize: 12,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                           ),
//                                           const Icon(
//                                             Icons.keyboard_arrow_down_rounded,
//                                             color: primaryColor,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 11),
//                             Expanded(
//                               child: Builder(
//                                 builder: (context) {
//                                   final List<DropdownMenuItem<int>> items =
//                                       divisions
//                                           .where(
//                                             (item) => item.divisionId != null,
//                                           )
//                                           .map((item) {
//                                             return DropdownMenuItem<int>(
//                                               value: item.divisionId,
//                                               child: Text(
//                                                 item.division ?? '',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             );
//                                           })
//                                           .toList();

//                                   final DropdownMenuItem<int>? selectedItem =
//                                       selectedItemOf<int>(
//                                         items,
//                                         selectedDivisionId,
//                                       );

//                                   return GestureDetector(
//                                     behavior: HitTestBehavior.opaque,
//                                     onTap:
//                                         selectedStandardId == null ||
//                                             items.isEmpty
//                                         ? null
//                                         : () async {
//                                             final PickerSelection<int>? result =
//                                                 await showOptionPickerSheet<
//                                                   int
//                                                 >(
//                                                   context: context,
//                                                   title: 'Select Division',
//                                                   items: items,
//                                                   selectedValue:
//                                                       selectedDivisionId,
//                                                 );

//                                             if (!mounted || result == null) {
//                                               return;
//                                             }

//                                             setState(() {
//                                               selectedDivisionId = result.value;
//                                             });

//                                             await fetchDetails();
//                                           },
//                                     child: InputDecorator(
//                                       decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: Colors.white,
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                               horizontal: 11,
//                                               vertical: 14,
//                                             ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             11,
//                                           ),
//                                           borderSide: const BorderSide(
//                                             color: Color(0xFFE5E2EA),
//                                           ),
//                                         ),
//                                         disabledBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             11,
//                                           ),
//                                           borderSide: const BorderSide(
//                                             color: Color(0xFFE5E2EA),
//                                           ),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             11,
//                                           ),
//                                           borderSide: const BorderSide(
//                                             color: primaryColor,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child:
//                                                 selectedItem?.child ??
//                                                 Row(
//                                                   children: [
//                                                     SvgPicture.asset(
//                                                       'assets/icons/Clip path group (1).svg',
//                                                       width: 14,
//                                                       height: 14,
//                                                       fit: BoxFit.contain,
//                                                     ),
//                                                     const SizedBox(width: 8),
//                                                     const Text(
//                                                       'Division',
//                                                       style: TextStyle(
//                                                         fontSize: 12,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                           ),
//                                           const Icon(
//                                             Icons.keyboard_arrow_down_rounded,
//                                             color: primaryColor,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     // child: Column(
//                     //   children: [
//                     //     DropdownButtonFormField<int>(
//                     //       value:
//                     //           workPlans.any(
//                     //             (item) => item.id == selectedWorkPlanId,
//                     //           )
//                     //           ? selectedWorkPlanId
//                     //           : null,
//                     //       isExpanded: true,
//                     //       itemHeight: 58,
//                     //       menuMaxHeight: 420,
//                     //       icon: isFetchingWorkPlans
//                     //           ? const SizedBox(
//                     //               width: 19,
//                     //               height: 19,
//                     //               child: CircularProgressIndicator(
//                     //                 strokeWidth: 2,
//                     //                 color: primaryColor,
//                     //               ),
//                     //             )
//                     //           : const Icon(
//                     //               Icons.keyboard_arrow_down_rounded,
//                     //               color: primaryColor,
//                     //               size: 25,
//                     //             ),
//                     //       hint: Row(
//                     //         children: [
//                     //           SvgPicture.asset(
//                     //             'assets/icons/Group (23).svg',
//                     //             width: 14,
//                     //             height: 14,
//                     //             fit: BoxFit.contain,
//                     //           ),
//                     //           const SizedBox(width: 8),
//                     //           Text(
//                     //             isFetchingWorkPlans
//                     //                 ? 'Loading work plans...'
//                     //                 : 'Select Work Plan',
//                     //             style: const TextStyle(
//                     //               color: Color(0xFF77717D),
//                     //               fontSize: 13,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //       decoration: InputDecoration(
//                     //         filled: true,
//                     //         fillColor: Colors.white,
//                     //         contentPadding: const EdgeInsets.symmetric(
//                     //           horizontal: 14,
//                     //           vertical: 14,
//                     //         ),
//                     //         enabledBorder: OutlineInputBorder(
//                     //           borderRadius: BorderRadius.circular(11),
//                     //           borderSide: const BorderSide(
//                     //             color: Color(0xFFE5E2EA),
//                     //           ),
//                     //         ),
//                     //         focusedBorder: OutlineInputBorder(
//                     //           borderRadius: BorderRadius.circular(11),
//                     //           borderSide: const BorderSide(color: primaryColor),
//                     //         ),
//                     //       ),
//                     //       items: workPlans.where((item) => item.id != null).map(
//                     //         (item) {
//                     //           return DropdownMenuItem<int>(
//                     //             value: item.id,
//                     //             child: Row(
//                     //               children: [
//                     //                 Container(
//                     //                   width: 31,
//                     //                   height: 31,
//                     //                   decoration: BoxDecoration(
//                     //                     color: const Color(0xFFF0EDFF),
//                     //                     borderRadius: BorderRadius.circular(8),
//                     //                   ),
//                     //                   child: const Icon(
//                     //                     Icons.menu_book_rounded,
//                     //                     color: primaryColor,
//                     //                     size: 17,
//                     //                   ),
//                     //                 ),
//                     //                 const SizedBox(width: 11),
//                     //                 Expanded(
//                     //                   child: Text(
//                     //                     item.weekName ?? 'Work Plan',
//                     //                     maxLines: 1,
//                     //                     overflow: TextOverflow.ellipsis,
//                     //                     style: const TextStyle(
//                     //                       color: textColor,
//                     //                       fontSize: 13,
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //               ],
//                     //             ),
//                     //           );
//                     //         },
//                     //       ).toList(),
//                     //       onChanged: isFetchingWorkPlans
//                     //           ? null
//                     //           : (value) {
//                     //               setState(() {
//                     //                 selectedWorkPlanId = value;
//                     //               });

//                     //               fetchDetails();
//                     //             },
//                     //     ),
//                     //     const SizedBox(height: 12),
//                     //     Row(
//                     //       children: [
//                     //         Expanded(
//                     //           child: DropdownButtonFormField<int>(
//                     //             value:
//                     //                 tutorshipClasses.any(
//                     //                   (item) =>
//                     //                       item.standardId == selectedStandardId,
//                     //                 )
//                     //                 ? selectedStandardId
//                     //                 : null,
//                     //             isExpanded: true,
//                     //             itemHeight: 58,
//                     //             icon: const Icon(
//                     //               Icons.keyboard_arrow_down_rounded,
//                     //               color: primaryColor,
//                     //             ),
//                     //             hint: Row(
//                     //               children: [
//                     //                 SvgPicture.asset(
//                     //                   'assets/icons/Clip path group (1).svg',
//                     //                   width: 14,
//                     //                   height: 14,
//                     //                   fit: BoxFit.contain,
//                     //                 ),
//                     //                 const SizedBox(width: 8),
//                     //                 const Text(
//                     //                   'Standard',
//                     //                   style: TextStyle(fontSize: 12),
//                     //                 ),
//                     //               ],
//                     //             ),
//                     //             decoration: InputDecoration(
//                     //               filled: true,
//                     //               fillColor: Colors.white,
//                     //               contentPadding: const EdgeInsets.symmetric(
//                     //                 horizontal: 11,
//                     //                 vertical: 14,
//                     //               ),
//                     //               enabledBorder: OutlineInputBorder(
//                     //                 borderRadius: BorderRadius.circular(11),
//                     //                 borderSide: const BorderSide(
//                     //                   color: Color(0xFFE5E2EA),
//                     //                 ),
//                     //               ),
//                     //               focusedBorder: OutlineInputBorder(
//                     //                 borderRadius: BorderRadius.circular(11),
//                     //                 borderSide: const BorderSide(
//                     //                   color: primaryColor,
//                     //                 ),
//                     //               ),
//                     //             ),
//                     //             items: tutorshipClasses
//                     //                 .where((item) => item.standardId != null)
//                     //                 .map((item) {
//                     //                   return DropdownMenuItem<int>(
//                     //                     value: item.standardId,
//                     //                     child: Text(
//                     //                       item.standard ?? '',
//                     //                       style: const TextStyle(fontSize: 12),
//                     //                     ),
//                     //                   );
//                     //                 })
//                     //                 .toList(),
//                     //             onChanged: (value) {
//                     //               setState(() {
//                     //                 selectedStandardId = value;

//                     //                 selectedDivisionId = null;
//                     //               });

//                     //               fetchDetails();
//                     //             },
//                     //           ),
//                     //         ),
//                     //         const SizedBox(width: 11),
//                     //         Expanded(
//                     //           child: DropdownButtonFormField<int>(
//                     //             value:
//                     //                 divisions.any(
//                     //                   (item) =>
//                     //                       item.divisionId == selectedDivisionId,
//                     //                 )
//                     //                 ? selectedDivisionId
//                     //                 : null,
//                     //             isExpanded: true,
//                     //             itemHeight: 58,
//                     //             icon: const Icon(
//                     //               Icons.keyboard_arrow_down_rounded,
//                     //               color: primaryColor,
//                     //             ),
//                     //             hint: Row(
//                     //               children: [
//                     //                 SvgPicture.asset(
//                     //                   'assets/icons/Clip path group (1).svg',
//                     //                   width: 14,
//                     //                   height: 14,
//                     //                   fit: BoxFit.contain,
//                     //                 ),
//                     //                 const SizedBox(width: 8),
//                     //                 const Text(
//                     //                   'Division',
//                     //                   style: TextStyle(fontSize: 12),
//                     //                 ),
//                     //               ],
//                     //             ),
//                     //             decoration: InputDecoration(
//                     //               filled: true,
//                     //               fillColor: Colors.white,
//                     //               contentPadding: const EdgeInsets.symmetric(
//                     //                 horizontal: 11,
//                     //                 vertical: 14,
//                     //               ),
//                     //               enabledBorder: OutlineInputBorder(
//                     //                 borderRadius: BorderRadius.circular(11),
//                     //                 borderSide: const BorderSide(
//                     //                   color: Color(0xFFE5E2EA),
//                     //                 ),
//                     //               ),
//                     //               focusedBorder: OutlineInputBorder(
//                     //                 borderRadius: BorderRadius.circular(11),
//                     //                 borderSide: const BorderSide(
//                     //                   color: primaryColor,
//                     //                 ),
//                     //               ),
//                     //             ),
//                     //             items: divisions
//                     //                 .where((item) => item.divisionId != null)
//                     //                 .map((item) {
//                     //                   return DropdownMenuItem<int>(
//                     //                     value: item.divisionId,
//                     //                     child: Text(
//                     //                       item.division ?? '',
//                     //                       style: const TextStyle(fontSize: 12),
//                     //                     ),
//                     //                   );
//                     //                 })
//                     //                 .toList(),
//                     //             onChanged: selectedStandardId == null
//                     //                 ? null
//                     //                 : (value) {
//                     //                     setState(() {
//                     //                       selectedDivisionId = value;
//                     //                     });

//                     //                     fetchDetails();
//                     //                   },
//                     //           ),
//                     //         ),
//                     //       ],
//                     //     ),
//                     //   ],
//                     // ),
//                   ),
//                   Expanded(
//                     child: isFetchingDetails
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                               color: primaryColor,
//                             ),
//                           )
//                         : workPlanDetails.isEmpty
//                         ? const Center(
//                             child: Text(
//                               'No class plans found',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           )
//                         : RefreshIndicator(
//                             color: primaryColor,
//                             onRefresh: fetchDetails,
//                             child: ListView.builder(
//                               physics: const AlwaysScrollableScrollPhysics(
//                                 parent: BouncingScrollPhysics(),
//                               ),
//                               padding: const EdgeInsets.fromLTRB(
//                                 20,
//                                 18,
//                                 20,
//                                 105,
//                               ),
//                               itemCount: workPlanDetails.length,
//                               itemBuilder: (context, index) {
//                                 final plan = workPlanDetails[index];

//                                 final createdDate = plan.createdDate ?? '';

//                                 String date = '';
//                                 String time = '';

//                                 if (createdDate.isNotEmpty) {
//                                   final parts = createdDate.split(' ');

//                                   date = parts.isNotEmpty ? parts.first : '';

//                                   time = parts.length > 1 ? parts[1] : '';
//                                 }

//                                 return Container(
//                                   margin: const EdgeInsets.only(bottom: 15),
//                                   padding: const EdgeInsets.fromLTRB(
//                                     14,
//                                     14,
//                                     13,
//                                     14,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(14),
//                                     boxShadow: const [
//                                       BoxShadow(
//                                         color: Color(0x10000000),
//                                         blurRadius: 14,
//                                         offset: Offset(0, 4),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 55,
//                                         height: 55,
//                                         decoration: const BoxDecoration(
//                                           color: lightBlue,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         alignment: Alignment.center,

//                                         // child: const Icon(
//                                         //   Icons.chair_alt_rounded,
//                                         //   color: blueColor,
//                                         //   size: 30,
//                                         // ),
//                                         child: SvgPicture.asset(
//                                           'assets/icons/Group 1165.svg',
//                                           width: 30,
//                                           height: 30,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 15),
//                                       Expanded(
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               plan.weekName ?? 'Work Plan',
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 color: textColor,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 11),
//                                             Wrap(
//                                               spacing: 12,
//                                               runSpacing: 5,
//                                               children: [
//                                                 Text(
//                                                   '${plan.standard ?? ''} ${plan.division ?? ''}',
//                                                   style: const TextStyle(
//                                                     color: blueColor,
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   plan.subjectName ?? '',
//                                                   style: const TextStyle(
//                                                     color: Color(0xFF77717D),
//                                                     fontSize: 11,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   date,
//                                                   style: const TextStyle(
//                                                     color: Color(0xFF77717D),
//                                                     fontSize: 11,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Align(
//                                         alignment: Alignment.topRight,
//                                         child: Text(
//                                           time,
//                                           style: const TextStyle(
//                                             color: Color(0xFF242129),
//                                             fontSize: 10,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//             floatingActionButton: SizedBox(
//               width: 60,
//               height: 60,
//               child: FloatingActionButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return const WorkPlanCreatingScreen();
//                       },
//                     ),
//                   );
//                 },
//                 elevation: 4,
//                 backgroundColor: primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: const CircleBorder(),
//                 child: const Icon(Icons.add, size: 37),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/workplan/domain/entities/workplan_response_entity.dart';
import 'package:cristalteacher/features/workplan/domain/entities/workplandetails_response_entity.dart';
import 'package:cristalteacher/features/workplan/domain/parameters/fetch_workplan_parameter.dart';
import 'package:cristalteacher/features/workplan/domain/parameters/fetch_workplandetails_parameter.dart';
import 'package:cristalteacher/features/workplan/presentation/cubit/workplan_cubit.dart';
import 'package:cristalteacher/features/workplan/presentation/screens/workplan_creating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class WorkplanDetialsScreen extends StatefulWidget {
  const WorkplanDetialsScreen({super.key});

  @override
  State<WorkplanDetialsScreen> createState() => _WorkplanDetialsScreenState();
}

class _WorkplanDetialsScreenState extends State<WorkplanDetialsScreen> {
  static const Color primaryColor = Color(0xFF5735E5);
  static const Color backgroundColor = Color(0xFFF8F7FF);
  static const Color lightBlue = Color(0xFFE7F0FF);
  static const Color blueColor = Color(0xFF0758C9);
  static const Color textColor = Color(0xFF25232A);

  final List<WorkPlanData> workPlans = [];
  final List<WorkPlanDetailsData> workPlanDetails = [];

  // Standard / division come from AppData, cached when the class details
  // are fetched at login. No API call from this screen.

  /// Teacher's own classes. Only used as a fallback source of divisions,
  /// and to decide which standard opens first.
  final List<TutorshipClass> tutorshipClasses = [];

  /// Every standard in the branch. Falls back to the tutorship classes
  /// when the full list was never cached.
  final List<TutorshipClass> standardList = [];

  String? selectedAccYear;

  int? selectedWorkPlanId;
  int? selectedStandardId;
  int? selectedDivisionId;

  bool isFetchingWorkPlans = false;
  bool isFetchingDetails = false;

  @override
  void initState() {
    super.initState();

    tutorshipClasses.addAll(AppData.tutorshipClasses);

    standardList.addAll(
      AppData.standards.isNotEmpty
          ? AppData.standards
          : AppData.tutorshipClasses,
    );

    // Open with the first class already chosen instead of empty hints.
    setInitialClassSelection();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      debugPrint('');
      debugPrint('======================================');
      debugPrint('FETCH INITIAL WORK PLAN DATA');
      debugPrint('======================================');

      // Academic year is still fetched; the classes are already local.
      context.read<AuthenticationCubit>().fetchAccYear();

      final now = DateTime.now();

      final currentDateTime =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';

      final workPlanRequest = FetchWorkPlanParameter(
        branchId: 1,
        accYear: null,
        fromDate: null,
        toDate: null,
        status: 'Open',
        currentDateTime: currentDateTime,
      );

      debugPrint('Work Plan Request: ${workPlanRequest.toJson()}');

      context.read<WorkplanCubit>().fetchWorkPlans(workPlanRequest);

      // Standard / division carry the default selection, so the list
      // matches what the dropdowns are showing.
      final detailsRequest = FetchWorkPlanDetailsParameter(
        branchId: 1,
        accYear: null,
        workPlanId: null,
        standardId: selectedStandardId,
        divisionId: selectedDivisionId,
        fromDate: null,
        toDate: null,
      );

      debugPrint(
        'Initial Details Request: '
        '${detailsRequest.toJson()}',
      );

      context.read<WorkplanCubit>().fetchWorkPlanDetails(detailsRequest);
    });
  }

  /// Every standard, the full list first and the teacher's own classes
  /// merged in behind it, so nothing is lost when one list misses a class.
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

  /// Divisions of [standard]. The complete standard list often carries no
  /// divisions, so it falls back to the tutorship class with the same id.
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

    // The full list may not hold this class - try the teacher's own
    // tutorship classes as well.
    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId == standardId) {
        return item;
      }
    }

    return null;
  }

  /// Picks the teacher's own class when there is one, otherwise the first
  /// standard that actually has a division, then its first division, so
  /// the filters are never blank on open.
  void setInitialClassSelection() {
    if (selectedStandardId != null) {
      return;
    }

    // The teacher's own class is the one worth opening on.
    for (final TutorshipClass standard in tutorshipClasses) {
      final List<DivisionDetails> divisions = divisionsFor(standard);

      if (divisions.isEmpty) {
        continue;
      }

      selectedStandardId = standard.standardId;
      selectedDivisionId = divisions.first.divisionId;

      break;
    }

    // Nothing assigned - fall back to the first standard in the full list
    // that carries a division.
    if (selectedStandardId == null) {
      for (final TutorshipClass standard in allStandards) {
        final List<DivisionDetails> divisions = divisionsFor(standard);

        if (divisions.isEmpty) {
          continue;
        }

        selectedStandardId = standard.standardId;
        selectedDivisionId = divisions.first.divisionId;

        break;
      }
    }

    debugPrint('');
    debugPrint('======================================');
    debugPrint('DEFAULT CLASS SELECTION');
    debugPrint('Standard Count: ${allStandards.length}');
    debugPrint('Standard ID: $selectedStandardId');
    debugPrint('Division ID: $selectedDivisionId');
    debugPrint('======================================');
  }

  Future<void> fetchDetails() async {
    final request = FetchWorkPlanDetailsParameter(
      branchId: 1,
      accYear: selectedAccYear,
      workPlanId: selectedWorkPlanId,
      standardId: selectedStandardId,
      divisionId: selectedDivisionId,
      fromDate: null,
      toDate: null,
    );

    debugPrint('');
    debugPrint('======================================');
    debugPrint('FETCH FILTERED WORK PLAN DETAILS');
    debugPrint('Request: ${request.toJson()}');
    debugPrint('======================================');

    await context.read<WorkplanCubit>().fetchWorkPlanDetails(request);
  }

  @override
  Widget build(BuildContext context) {
    final TutorshipClass? selectedStandard = findStandard(selectedStandardId);

    final List<DivisionDetails> divisions = selectedStandard == null
        ? <DivisionDetails>[]
        : divisionsFor(selectedStandard);

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is FetchAccYearSuccess) {
          String? activeAcademicYear;

          for (final year in state.response.data ?? []) {
            if (year.status == true) {
              activeAcademicYear = year.accYear;
              break;
            }
          }

          activeAcademicYear ??= state.response.data?.isNotEmpty == true
              ? state.response.data!.first.accYear
              : null;

          setState(() {
            selectedAccYear = activeAcademicYear;
          });

          debugPrint('');
          debugPrint('======================================');
          debugPrint('ACADEMIC YEAR SUCCESS');
          debugPrint('Selected Academic Year: $selectedAccYear');
          debugPrint('======================================');
        }

        if (state is FetchAccYearFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocConsumer<WorkplanCubit, WorkplanState>(
        listener: (context, state) {
          debugPrint('Workplan State: ${state.runtimeType}');

          if (state is FetchWorkPlanLoading) {
            setState(() {
              isFetchingWorkPlans = true;
            });
          }

          if (state is FetchWorkPlanSuccess) {
            final data = state.response.data ?? [];

            setState(() {
              isFetchingWorkPlans = false;

              workPlans
                ..clear()
                ..addAll(data);

              // Initial value remains null.
              // Details are fetched only when user selects.
              selectedWorkPlanId = null;
            });

            debugPrint('');
            debugPrint('======================================');
            debugPrint('WORK PLANS SUCCESS');
            debugPrint('Count: ${workPlans.length}');

            for (final item in workPlans) {
              debugPrint(
                'ID: ${item.id} | '
                'Week: ${item.weekName}',
              );
            }

            debugPrint('======================================');
          }

          if (state is FetchWorkPlanFailure) {
            setState(() {
              isFetchingWorkPlans = false;
            });

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }

          if (state is FetchWorkPlanDetailsLoading) {
            setState(() {
              isFetchingDetails = true;
            });
          }

          if (state is FetchWorkPlanDetailsSuccess) {
            final data = state.response.data ?? [];

            setState(() {
              isFetchingDetails = false;

              workPlanDetails
                ..clear()
                ..addAll(data);
            });

            debugPrint('');
            debugPrint('======================================');
            debugPrint('WORK PLAN DETAILS SUCCESS');
            debugPrint('Details Count: ${workPlanDetails.length}');

            for (final item in workPlanDetails) {
              debugPrint(
                'ID: ${item.id} | '
                'Master ID: ${item.masterId} | '
                'Week: ${item.weekName} | '
                'Standard: ${item.standard} | '
                'Division: ${item.division} | '
                'Subject: ${item.subjectName} | '
                'Topic: ${item.topic}',
              );
            }

            debugPrint('======================================');
          }

          if (state is FetchWorkPlanDetailsFailure) {
            setState(() {
              isFetchingDetails = false;
            });

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              toolbarHeight: 72,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leadingWidth: 68,
              leading: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              title: const Text(
                'Class Plan Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            final List<DropdownMenuItem<int>> items = workPlans
                                .where((item) => item.id != null)
                                .map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 31,
                                          height: 31,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0EDFF),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.menu_book_rounded,
                                            color: primaryColor,
                                            size: 17,
                                          ),
                                        ),
                                        const SizedBox(width: 11),
                                        Expanded(
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
                                      ],
                                    ),
                                  );
                                })
                                .toList();

                            final DropdownMenuItem<int>? selectedItem =
                                selectedItemOf<int>(items, selectedWorkPlanId);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: isFetchingWorkPlans || items.isEmpty
                                  ? null
                                  : () async {
                                      final PickerSelection<int>? result =
                                          await showOptionPickerSheet<int>(
                                            context: context,
                                            title: 'Select Work Plan',
                                            items: items,
                                            selectedValue: selectedWorkPlanId,
                                          );

                                      if (!mounted || result == null) {
                                        return;
                                      }

                                      setState(() {
                                        selectedWorkPlanId = result.value;
                                      });

                                      await fetchDetails();
                                    },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
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
                                    borderSide: const BorderSide(
                                      color: primaryColor,
                                    ),
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
                                                'assets/icons/Group (23).svg',
                                                width: 14,
                                                height: 14,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                isFetchingWorkPlans
                                                    ? 'Loading work plans...'
                                                    : 'Select Work Plan',
                                                style: const TextStyle(
                                                  color: Color(0xFF77717D),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                                    if (isFetchingWorkPlans)
                                      const SizedBox(
                                        width: 19,
                                        height: 19,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primaryColor,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: primaryColor,
                                        size: 25,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  // Every standard, not just the teacher's
                                  // own classes.
                                  final List<DropdownMenuItem<int>> items =
                                      allStandards
                                          .where(
                                            (item) => item.standardId != null,
                                          )
                                          .map((item) {
                                            return DropdownMenuItem<int>(
                                              value: item.standardId,
                                              child: Text(
                                                item.standard ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          })
                                          .toList();

                                  final DropdownMenuItem<int>? selectedItem =
                                      selectedItemOf<int>(
                                        items,
                                        selectedStandardId,
                                      );

                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: items.isEmpty
                                        ? null
                                        : () async {
                                            final PickerSelection<int>? result =
                                                await showOptionPickerSheet<
                                                  int
                                                >(
                                                  context: context,
                                                  title: 'Select Standard',
                                                  items: items,
                                                  selectedValue:
                                                      selectedStandardId,
                                                );

                                            if (!mounted || result == null) {
                                              return;
                                            }

                                            setState(() {
                                              selectedStandardId = result.value;
                                              selectedDivisionId = null;
                                            });

                                            await fetchDetails();
                                          },
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 11,
                                              vertical: 14,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E2EA),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          borderSide: const BorderSide(
                                            color: primaryColor,
                                          ),
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
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
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
                            const SizedBox(width: 11),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final List<DropdownMenuItem<int>> items =
                                      divisions
                                          .where(
                                            (item) => item.divisionId != null,
                                          )
                                          .map((item) {
                                            return DropdownMenuItem<int>(
                                              value: item.divisionId,
                                              child: Text(
                                                item.division ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          })
                                          .toList();

                                  final DropdownMenuItem<int>? selectedItem =
                                      selectedItemOf<int>(
                                        items,
                                        selectedDivisionId,
                                      );

                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap:
                                        selectedStandardId == null ||
                                            items.isEmpty
                                        ? null
                                        : () async {
                                            final PickerSelection<int>? result =
                                                await showOptionPickerSheet<
                                                  int
                                                >(
                                                  context: context,
                                                  title: 'Select Division',
                                                  items: items,
                                                  selectedValue:
                                                      selectedDivisionId,
                                                );

                                            if (!mounted || result == null) {
                                              return;
                                            }

                                            setState(() {
                                              selectedDivisionId = result.value;
                                            });

                                            await fetchDetails();
                                          },
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 11,
                                              vertical: 14,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E2EA),
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E2EA),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          borderSide: const BorderSide(
                                            color: primaryColor,
                                          ),
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
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
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
                      ],
                    ),
                    // child: Column(
                    //   children: [
                    //     DropdownButtonFormField<int>(
                    //       value:
                    //           workPlans.any(
                    //             (item) => item.id == selectedWorkPlanId,
                    //           )
                    //           ? selectedWorkPlanId
                    //           : null,
                    //       isExpanded: true,
                    //       itemHeight: 58,
                    //       menuMaxHeight: 420,
                    //       icon: isFetchingWorkPlans
                    //           ? const SizedBox(
                    //               width: 19,
                    //               height: 19,
                    //               child: CircularProgressIndicator(
                    //                 strokeWidth: 2,
                    //                 color: primaryColor,
                    //               ),
                    //             )
                    //           : const Icon(
                    //               Icons.keyboard_arrow_down_rounded,
                    //               color: primaryColor,
                    //               size: 25,
                    //             ),
                    //       hint: Row(
                    //         children: [
                    //           SvgPicture.asset(
                    //             'assets/icons/Group (23).svg',
                    //             width: 14,
                    //             height: 14,
                    //             fit: BoxFit.contain,
                    //           ),
                    //           const SizedBox(width: 8),
                    //           Text(
                    //             isFetchingWorkPlans
                    //                 ? 'Loading work plans...'
                    //                 : 'Select Work Plan',
                    //             style: const TextStyle(
                    //               color: Color(0xFF77717D),
                    //               fontSize: 13,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       decoration: InputDecoration(
                    //         filled: true,
                    //         fillColor: Colors.white,
                    //         contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 14,
                    //           vertical: 14,
                    //         ),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(11),
                    //           borderSide: const BorderSide(
                    //             color: Color(0xFFE5E2EA),
                    //           ),
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(11),
                    //           borderSide: const BorderSide(color: primaryColor),
                    //         ),
                    //       ),
                    //       items: workPlans.where((item) => item.id != null).map(
                    //         (item) {
                    //           return DropdownMenuItem<int>(
                    //             value: item.id,
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   width: 31,
                    //                   height: 31,
                    //                   decoration: BoxDecoration(
                    //                     color: const Color(0xFFF0EDFF),
                    //                     borderRadius: BorderRadius.circular(8),
                    //                   ),
                    //                   child: const Icon(
                    //                     Icons.menu_book_rounded,
                    //                     color: primaryColor,
                    //                     size: 17,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(width: 11),
                    //                 Expanded(
                    //                   child: Text(
                    //                     item.weekName ?? 'Work Plan',
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: const TextStyle(
                    //                       color: textColor,
                    //                       fontSize: 13,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       ).toList(),
                    //       onChanged: isFetchingWorkPlans
                    //           ? null
                    //           : (value) {
                    //               setState(() {
                    //                 selectedWorkPlanId = value;
                    //               });

                    //               fetchDetails();
                    //             },
                    //     ),
                    //     const SizedBox(height: 12),
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: DropdownButtonFormField<int>(
                    //             value:
                    //                 tutorshipClasses.any(
                    //                   (item) =>
                    //                       item.standardId == selectedStandardId,
                    //                 )
                    //                 ? selectedStandardId
                    //                 : null,
                    //             isExpanded: true,
                    //             itemHeight: 58,
                    //             icon: const Icon(
                    //               Icons.keyboard_arrow_down_rounded,
                    //               color: primaryColor,
                    //             ),
                    //             hint: Row(
                    //               children: [
                    //                 SvgPicture.asset(
                    //                   'assets/icons/Clip path group (1).svg',
                    //                   width: 14,
                    //                   height: 14,
                    //                   fit: BoxFit.contain,
                    //                 ),
                    //                 const SizedBox(width: 8),
                    //                 const Text(
                    //                   'Standard',
                    //                   style: TextStyle(fontSize: 12),
                    //                 ),
                    //               ],
                    //             ),
                    //             decoration: InputDecoration(
                    //               filled: true,
                    //               fillColor: Colors.white,
                    //               contentPadding: const EdgeInsets.symmetric(
                    //                 horizontal: 11,
                    //                 vertical: 14,
                    //               ),
                    //               enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 borderSide: const BorderSide(
                    //                   color: Color(0xFFE5E2EA),
                    //                 ),
                    //               ),
                    //               focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 borderSide: const BorderSide(
                    //                   color: primaryColor,
                    //                 ),
                    //               ),
                    //             ),
                    //             items: tutorshipClasses
                    //                 .where((item) => item.standardId != null)
                    //                 .map((item) {
                    //                   return DropdownMenuItem<int>(
                    //                     value: item.standardId,
                    //                     child: Text(
                    //                       item.standard ?? '',
                    //                       style: const TextStyle(fontSize: 12),
                    //                     ),
                    //                   );
                    //                 })
                    //                 .toList(),
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 selectedStandardId = value;

                    //                 selectedDivisionId = null;
                    //               });

                    //               fetchDetails();
                    //             },
                    //           ),
                    //         ),
                    //         const SizedBox(width: 11),
                    //         Expanded(
                    //           child: DropdownButtonFormField<int>(
                    //             value:
                    //                 divisions.any(
                    //                   (item) =>
                    //                       item.divisionId == selectedDivisionId,
                    //                 )
                    //                 ? selectedDivisionId
                    //                 : null,
                    //             isExpanded: true,
                    //             itemHeight: 58,
                    //             icon: const Icon(
                    //               Icons.keyboard_arrow_down_rounded,
                    //               color: primaryColor,
                    //             ),
                    //             hint: Row(
                    //               children: [
                    //                 SvgPicture.asset(
                    //                   'assets/icons/Clip path group (1).svg',
                    //                   width: 14,
                    //                   height: 14,
                    //                   fit: BoxFit.contain,
                    //                 ),
                    //                 const SizedBox(width: 8),
                    //                 const Text(
                    //                   'Division',
                    //                   style: TextStyle(fontSize: 12),
                    //                 ),
                    //               ],
                    //             ),
                    //             decoration: InputDecoration(
                    //               filled: true,
                    //               fillColor: Colors.white,
                    //               contentPadding: const EdgeInsets.symmetric(
                    //                 horizontal: 11,
                    //                 vertical: 14,
                    //               ),
                    //               enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 borderSide: const BorderSide(
                    //                   color: Color(0xFFE5E2EA),
                    //                 ),
                    //               ),
                    //               focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 borderSide: const BorderSide(
                    //                   color: primaryColor,
                    //                 ),
                    //               ),
                    //             ),
                    //             items: divisions
                    //                 .where((item) => item.divisionId != null)
                    //                 .map((item) {
                    //                   return DropdownMenuItem<int>(
                    //                     value: item.divisionId,
                    //                     child: Text(
                    //                       item.division ?? '',
                    //                       style: const TextStyle(fontSize: 12),
                    //                     ),
                    //                   );
                    //                 })
                    //                 .toList(),
                    //             onChanged: selectedStandardId == null
                    //                 ? null
                    //                 : (value) {
                    //                     setState(() {
                    //                       selectedDivisionId = value;
                    //                     });

                    //                     fetchDetails();
                    //                   },
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                  Expanded(
                    child: isFetchingDetails
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : workPlanDetails.isEmpty
                        ? const Center(
                            child: Text(
                              'No class plans found',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            color: primaryColor,
                            onRefresh: fetchDetails,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                18,
                                20,
                                105,
                              ),
                              itemCount: workPlanDetails.length,
                              itemBuilder: (context, index) {
                                final plan = workPlanDetails[index];

                                final createdDate = plan.createdDate ?? '';

                                String date = '';
                                String time = '';

                                if (createdDate.isNotEmpty) {
                                  final parts = createdDate.split(' ');

                                  date = parts.isNotEmpty ? parts.first : '';

                                  time = parts.length > 1 ? parts[1] : '';
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    14,
                                    13,
                                    14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x10000000),
                                        blurRadius: 14,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: const BoxDecoration(
                                          color: lightBlue,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,

                                        // child: const Icon(
                                        //   Icons.chair_alt_rounded,
                                        //   color: blueColor,
                                        //   size: 30,
                                        // ),
                                        child: SvgPicture.asset(
                                          'assets/icons/Group 1165.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              plan.weekName ?? 'Work Plan',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: textColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 11),
                                            Wrap(
                                              spacing: 12,
                                              runSpacing: 5,
                                              children: [
                                                Text(
                                                  '${plan.standard ?? ''} ${plan.division ?? ''}',
                                                  style: const TextStyle(
                                                    color: blueColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  plan.subjectName ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xFF77717D),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                Text(
                                                  date,
                                                  style: const TextStyle(
                                                    color: Color(0xFF77717D),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          time,
                                          style: const TextStyle(
                                            color: Color(0xFF242129),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const WorkPlanCreatingScreen();
                      },
                    ),
                  );
                },
                elevation: 4,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 37),
              ),
            ),
          );
        },
      ),
    );
  }
}
