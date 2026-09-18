// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/teacher_dashboard_result.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_teacherdashboard_request.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';
// import 'package:cristalteacher/features/tutorprofile/presentation/cubit/tutordetails_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class TeacherProfileScreen extends StatefulWidget {
//   const TeacherProfileScreen({super.key});

//   @override
//   State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
// }

// class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
//   static const Color primaryColor = Color(0xFF807FD8);
//   static const Color backgroundColor = Color(0xFFF8F7FD);
//   static const Color iconBackgroundColor = Color(0xFFF0EDFF);
//   static const Color dividerColor = Color(0xFFEEECEF);

//   int? expandedSectionIndex;

//   List<ProfileDetail> personalDetails = [];
//   List<ProfileDetail> contactDetails = [];
//   List<ProfileDetail> employmentDetails = [];
//   List<ProfileDetail> bankDetails = [];

//   // Teacher dashboard API values.
//   String teacherName = '';
//   String teacherSubject = '';
//   String classInCharge = '';
//   String divisionInCharge = '';
//   String employeeCode = '';
//   int studentCount = 0;
//   int todayClassCount = 0;

//   // Values received through tutor-details API.
//   String teacherEmail = '';
//   String teacherPhone = '';
//   String joiningDate = '';

//   bool tutorDetailsLoading = true;
//   bool dashboardLoading = true;

//   @override
//   void initState() {
//     super.initState();

//     teacherName = AppData.teacherName ?? '';
//     teacherSubject = AppData.teacherSubject ?? '';

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       _loadTutorDetails();
//       _loadTeacherDashboard();
//     });
//   }

//   Future<void> _loadTutorDetails() async {
//     await context.read<TutordetailsCubit>().fetchTutorDetails();
//   }

//   Future<void> _loadTeacherDashboard() async {
//     if (AppData.accYear == null || AppData.employeeId == null) {
//       setState(() {
//         dashboardLoading = false;
//       });

//       debugPrint(
//         'Teacher dashboard not called because AccYear or EmployeeId is null.',
//       );
//       return;
//     }

//     context.read<AuthenticationCubit>().fetchTeacherDashboard(
//       TeacherDashboardRequest(
//         accYear: AppData.accYear!,
//         employeeId: AppData.employeeId!,
//         branchId: 1,
//       ),
//     );
//   }

//   Future<void> _refreshProfile() async {
//     setState(() {
//       tutorDetailsLoading = true;
//       dashboardLoading = true;
//     });

//     _loadTeacherDashboard();
//     await _loadTutorDetails();
//   }

//   void _toggleSection(int index) {
//     setState(() {
//       expandedSectionIndex = expandedSectionIndex == index ? null : index;
//     });
//   }

//   List<ProfileDetail> _convertApiData(List<String> apiData) {
//     return apiData.map((item) {
//       final int separatorIndex = item.indexOf(':');

//       if (separatorIndex == -1) {
//         return ProfileDetail(label: item.trim(), value: '');
//       }

//       final String label = item.substring(0, separatorIndex).trim();
//       final String value = item.substring(separatorIndex + 1).trim();

//       return ProfileDetail(label: label, value: value);
//     }).toList();
//   }

//   String _findValue(List<ProfileDetail> details, List<String> possibleLabels) {
//     for (final detail in details) {
//       final String currentLabel = detail.label
//           .toLowerCase()
//           .replaceAll(' ', '')
//           .replaceAll('-', '')
//           .replaceAll('_', '');

//       for (final possibleLabel in possibleLabels) {
//         final String expectedLabel = possibleLabel
//             .toLowerCase()
//             .replaceAll(' ', '')
//             .replaceAll('-', '')
//             .replaceAll('_', '');

//         if (currentLabel == expectedLabel ||
//             currentLabel.contains(expectedLabel)) {
//           return detail.value.trim();
//         }
//       }
//     }

//     return '';
//   }

//   void _setTutorDetails(TutorDetailsDataEntity data) {
//     final List<ProfileDetail> newPersonalDetails = _convertApiData(
//       data.personalInfo,
//     );

//     final List<ProfileDetail> newContactDetails = _convertApiData(
//       data.contactInfo,
//     );

//     final List<ProfileDetail> newEmploymentDetails = _convertApiData(
//       data.employeeLocationAndDetails,
//     );

//     final List<ProfileDetail> newBankDetails = _convertApiData(
//       data.bankDetails,
//     );

//     setState(() {
//       personalDetails = newPersonalDetails;
//       contactDetails = newContactDetails;
//       employmentDetails = newEmploymentDetails;
//       bankDetails = newBankDetails;

//       teacherEmail = _findValue(newContactDetails, const [
//         'Email',
//         'Email Address',
//         'Official Email',
//         'Personal Email',
//       ]);

//       teacherPhone = _findValue(newContactDetails, const [
//         'Phone Number',
//         'Mobile Number',
//         'Phone',
//         'Mobile',
//         'Contact Number',
//       ]);

//       joiningDate = _findValue(newEmploymentDetails, const [
//         'Joining Date',
//         'Date Of Joining',
//         'Joined On',
//         'Joining On',
//       ]);

//       tutorDetailsLoading = false;
//     });
//   }

//   void _setTeacherDashboard(TeacherDashboardResult result) {
//     final data = result.data;

//     if (data.isEmpty) {
//       setState(() {
//         dashboardLoading = false;
//       });
//       return;
//     }

//     final datum = data.first;

//     setState(() {
//       teacherName = AppData.teacherName ?? teacherName;
//       teacherSubject = datum.classChargeSubjects;
//       classInCharge = datum.classInCharge;
//       divisionInCharge = datum.divisionInCharge;
//       employeeCode = datum.employeeCode;
//       studentCount = datum.studentCountInCharge;
//       todayClassCount = datum.todayPeriods.length;
//       dashboardLoading = false;

//       AppData.teacherSubject = datum.classChargeSubjects;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<TutordetailsCubit, TutordetailsState>(
//           listener: (context, state) {
//             if (state is TutordetailsLoading) {
//               setState(() {
//                 tutorDetailsLoading = true;
//               });
//             }

//             if (state is TutordetailsSuccess) {
//               final TutorDetailsDataEntity? data = state.tutorDetails.data;

//               if (data != null) {
//                 _setTutorDetails(data);
//               } else {
//                 setState(() {
//                   tutorDetailsLoading = false;
//                 });
//               }
//             }

//             if (state is TutordetailsFailure) {
//               setState(() {
//                 tutorDetailsLoading = false;
//               });

//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.message)));
//             }
//           },
//         ),
//         BlocListener<AuthenticationCubit, AuthenticationState>(
//           listener: (context, state) {
//             if (state is FetchDashboardSuccess) {
//               _setTeacherDashboard(state.response);
//             }

//             if (state is FetchDashboardFailure) {
//               setState(() {
//                 dashboardLoading = false;
//               });

//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.message)));
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           toolbarHeight: 62,
//           elevation: 0,
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white,
//           centerTitle: true,
//           leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.arrow_back, size: 23),
//           ),
//           title: const Text(
//             'Teacher Profile',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//         ),
//         body: SafeArea(
//           child: RefreshIndicator(
//             color: primaryColor,
//             onRefresh: _refreshProfile,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
//               child: Column(
//                 children: [
//                   _buildMainProfileCard(),
//                   const SizedBox(height: 16),
//                   _buildSectionCard(
//                     index: 0,
//                     svgAsset: 'assets/icons/Layer 2.svg',
//                     iconColor: const Color(0xFF653FE4),
//                     title: 'Personal Information',
//                     child: _buildPersonalInformation(),
//                   ),
//                   _buildSectionCard(
//                     index: 1,
//                     svgAsset: 'assets/icons/Group (24).svg',
//                     iconColor: const Color(0xFF653FE4),
//                     title: 'Contact Information',
//                     child: _buildContactInformation(),
//                   ),
//                   _buildSectionCard(
//                     index: 2,
//                     svgAsset: 'assets/icons/Clip path group (2).svg',
//                     iconColor: const Color(0xFF653FE4),
//                     title: 'Employment & Location Details',
//                     child: _buildEmploymentInformation(),
//                   ),
//                   // _buildSectionCard(
//                   //   index: 3,
//                   //   svgAsset: 'assets/icons/Group (26).svg',
//                   //   iconColor: const Color(0xFF653FE4),
//                   //   title: 'Document & Card Details',
//                   //   child: _buildDocumentInformation(),
//                   // ),
//                   _buildSectionCard(
//                     index: 4,
//                     svgAsset: 'assets/icons/Group (27).svg',
//                     iconColor: const Color(0xFF653FE4),
//                     title: 'Bank Details',
//                     child: _buildBankInformation(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainProfileCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(17),
//         border: Border.all(color: const Color(0xFFE5E3E9)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.035),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildProfileHeader(),
//           const SizedBox(height: 23),
//           _buildStatistics(),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             border: Border.all(color: const Color(0xFFD4D0DB)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.09),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: const CircleAvatar(
//             radius: 31,
//             backgroundColor: Color(0xFFF0EDFF),
//             backgroundImage: AssetImage('assets/images/defaultstudent.png'),
//           ),
//         ),
//         const SizedBox(width: 15),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 2),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   teacherName.trim().isEmpty ? '--' : teacherName,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Color(0xFF17151E),
//                     fontSize: 17,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   teacherSubject.trim().isEmpty
//                       ? 'Teacher'
//                       : '$teacherSubject Teacher',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Color(0xFF6C46E8),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 11),
//                 _buildContactLine(
//                   svgAsset: 'assets/icons/Group (28).svg',
//                   text: teacherEmail.trim().isEmpty ? '--' : teacherEmail,
//                 ),
//                 const SizedBox(height: 9),
//                 _buildContactLine(
//                   svgAsset: 'assets/icons/Clip path group (3).svg',
//                   text: teacherPhone.trim().isEmpty ? '--' : teacherPhone,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildContactLine({required String svgAsset, required String text}) {
//     return Row(
//       children: [
//         SvgPicture.asset(svgAsset, width: 15, height: 15, fit: BoxFit.contain),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: Color(0xFF44404A), fontSize: 12),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatistics() {
//     if (dashboardLoading) {
//       return const SizedBox(
//         height: 90,
//         child: Center(
//           child: CircularProgressIndicator(
//             color: primaryColor,
//             strokeWidth: 2.5,
//           ),
//         ),
//       );
//     }

//     final String assignedClass = [
//       classInCharge,
//       divisionInCharge,
//     ].where((value) => value.trim().isNotEmpty).join(' ');

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: _buildStatisticItem(
//             iconColor: const Color(0xFF3F3F3F),
//             svgAsset: 'assets/icons/Group 951.svg',
//             iconBackground: const Color(0xFFE7F0E8),
//             value: employeeCode.trim().isEmpty ? '--' : employeeCode,
//             label: 'Staff Code',
//           ),
//         ),
//         _buildVerticalDivider(),
//         Expanded(
//           child: _buildStatisticItem(
//             svgAsset: 'assets/icons/Group 1312.svg',
//             iconColor: const Color(0xFF3F3F3F),
//             iconBackground: const Color(0xFFEAE4FA),
//             value: '$studentCount',
//             label: 'Student Total',
//           ),
//         ),
//         _buildVerticalDivider(),
//         Expanded(
//           child: _buildStatisticItem(
//             svgAsset: 'assets/icons/Vector (3).svg',
//             iconColor: const Color(0xFF3F3F3F),
//             iconBackground: const Color(0xFFF0EAE1),
//             value: assignedClass.isEmpty ? '--' : assignedClass,
//             label: 'Assigned Class',
//           ),
//         ),
//         _buildVerticalDivider(),
//         Expanded(
//           child: _buildStatisticItem(
//             svgAsset: 'assets/icons/Group (15).svg',
//             iconColor: const Color(0xFF3F3F3F),
//             iconBackground: const Color(0xFFE7EEF1),
//             value: joiningDate.trim().isEmpty
//                 ? '$todayClassCount'
//                 : joiningDate,
//             label: joiningDate.trim().isEmpty ? 'Today Classes' : 'Joining On',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDivider() {
//     return Container(
//       width: 1,
//       height: 40,
//       margin: const EdgeInsets.only(top: 31),
//       color: const Color(0xFFE7E4E9),
//     );
//   }

//   Widget _buildStatisticItem({
//     required String svgAsset,
//     required Color iconColor,
//     required Color iconBackground,
//     required String value,
//     required String label,
//   }) {
//     return Column(
//       children: [
//         Container(
//           width: 41,
//           height: 41,
//           decoration: BoxDecoration(
//             color: iconBackground,
//             shape: BoxShape.circle,
//           ),
//           alignment: Alignment.center,
//           child: SvgPicture.asset(
//             svgAsset,
//             width: 21,
//             height: 21,
//             fit: BoxFit.contain,
//             colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
//           ),
//         ),
//         const SizedBox(height: 9),
//         Text(
//           value.trim().isEmpty ? '--' : value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Color(0xFF18151D),
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Color(0xFF47424C), fontSize: 9),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionCard({
//     required int index,
//     required String svgAsset,
//     Color? iconColor,
//     required String title,
//     required Widget child,
//   }) {
//     final bool isExpanded = expandedSectionIndex == index;

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 13),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(17),
//         border: Border.all(
//           color: isExpanded
//               ? primaryColor.withOpacity(0.30)
//               : const Color(0xFFE3E1E6),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.025),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () => _toggleSection(index),
//               borderRadius: BorderRadius.circular(17),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 14,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 41,
//                       height: 41,
//                       decoration: const BoxDecoration(
//                         color: iconBackgroundColor,
//                         shape: BoxShape.circle,
//                       ),
//                       alignment: Alignment.center,
//                       child: SvgPicture.asset(
//                         svgAsset,
//                         width: 21,
//                         height: 21,
//                         fit: BoxFit.contain,
//                         colorFilter: iconColor == null
//                             ? null
//                             : ColorFilter.mode(iconColor, BlendMode.srcIn),
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: const TextStyle(
//                           color: Color(0xFF4D4851),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     AnimatedRotation(
//                       duration: const Duration(milliseconds: 220),
//                       turns: isExpanded ? -0.25 : 0,
//                       child: Icon(
//                         Icons.chevron_right_rounded,
//                         color: isExpanded
//                             ? const Color(0xFF653FE4)
//                             : const Color(0xFF8E8992),
//                         size: 24,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           AnimatedCrossFade(
//             duration: const Duration(milliseconds: 250),
//             sizeCurve: Curves.easeInOut,
//             crossFadeState: isExpanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             firstChild: const SizedBox(width: double.infinity, height: 0),
//             secondChild: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(18, 2, 18, 20),
//               child: child,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPersonalInformation() {
//     if (tutorDetailsLoading && personalDetails.isEmpty) {
//       return _buildDetailsLoading();
//     }

//     if (personalDetails.isEmpty) {
//       return _buildEmptyDetails();
//     }

//     return _buildDetailsGrid(personalDetails);
//   }

//   Widget _buildContactInformation() {
//     if (tutorDetailsLoading && contactDetails.isEmpty) {
//       return _buildDetailsLoading();
//     }

//     if (contactDetails.isEmpty) {
//       return _buildEmptyDetails();
//     }

//     return _buildDetailsGrid(contactDetails);
//   }

//   Widget _buildEmploymentInformation() {
//     if (tutorDetailsLoading && employmentDetails.isEmpty) {
//       return _buildDetailsLoading();
//     }

//     if (employmentDetails.isEmpty) {
//       return _buildEmptyDetails();
//     }

//     return _buildDetailsGrid(employmentDetails);
//   }

//   // This remains unchanged because no document list was shown
//   // in TutorDetailsDataEntity.
//   // Widget _buildDocumentInformation() {
//   //   return _buildDetailsGrid(const [
//   //     ProfileDetail(label: 'Passport Number', value: '3647859400040404'),
//   //     ProfileDetail(label: 'Passport Issue Date', value: '12-10-2024'),
//   //     ProfileDetail(label: 'Passport Expiry Date', value: 'Shake Mazaui Route'),
//   //     ProfileDetail(label: 'Visa Type', value: '30\$ Per Hr'),
//   //     ProfileDetail(label: 'Visa Number', value: 'Almakthum Shakzayid'),
//   //     ProfileDetail(label: 'Visa Expiry Date', value: 'Hjuberaea N'),
//   //     ProfileDetail(label: 'Labor Card Number', value: 'Dummy Content'),
//   //     ProfileDetail(label: 'Labor Card Issue Date', value: 'Dummy Content'),
//   //     ProfileDetail(label: 'Labor Card Expiry Date', value: '12-10-2024'),
//   //     ProfileDetail(label: 'Insurance Number', value: '-'),
//   //     ProfileDetail(
//   //       label: 'Insurance Expiry Date',
//   //       value: 'Shake Mazaui Route',
//   //     ),
//   //     ProfileDetail(label: 'Mol Contact Number', value: '30\$ Per Hr'),
//   //     ProfileDetail(label: 'Sponsor Name', value: 'Almakthum Shakzayid'),
//   //     ProfileDetail(label: 'GOSI/SSOI Number', value: 'Hjuberaea N'),
//   //   ]);
//   // }

//   Widget _buildBankInformation() {
//     if (tutorDetailsLoading && bankDetails.isEmpty) {
//       return _buildDetailsLoading();
//     }

//     if (bankDetails.isEmpty) {
//       return _buildEmptyDetails();
//     }

//     return _buildDetailsGrid(bankDetails);
//   }

//   Widget _buildDetailsLoading() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Center(
//         child: SizedBox(
//           width: 23,
//           height: 23,
//           child: CircularProgressIndicator(
//             color: primaryColor,
//             strokeWidth: 2.5,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyDetails() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: Text(
//           'No details available',
//           style: TextStyle(
//             color: Color(0xFF8E8992),
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailsGrid(List<ProfileDetail> details) {
//     final int rowCount = (details.length / 2).ceil();

//     return Column(
//       children: List.generate(rowCount, (rowIndex) {
//         final int leftIndex = rowIndex * 2;
//         final int rightIndex = leftIndex + 1;

//         final ProfileDetail leftDetail = details[leftIndex];

//         final ProfileDetail? rightDetail = rightIndex < details.length
//             ? details[rightIndex]
//             : null;

//         final bool isLastRow = rowIndex == rowCount - 1;

//         return Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(child: _buildDetailItem(leftDetail)),
//                 const SizedBox(width: 24),
//                 Expanded(
//                   child: rightDetail != null
//                       ? _buildDetailItem(rightDetail)
//                       : const SizedBox(),
//                 ),
//               ],
//             ),
//             if (!isLastRow) ...[
//               const SizedBox(height: 16),
//               const Divider(height: 1, thickness: 0.7, color: dividerColor),
//               const SizedBox(height: 16),
//             ],
//           ],
//         );
//       }),
//     );
//   }

//   Widget _buildDetailItem(ProfileDetail detail) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           detail.label,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//             color: Color(0xFF464149),
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           detail.value.trim().isEmpty ? '--' : detail.value,
//           style: const TextStyle(
//             color: Color(0xFF111126),
//             fontSize: 15,
//             height: 1.3,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ProfileDetail {
//   final String label;
//   final String value;

//   const ProfileDetail({required this.label, required this.value});
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/authentication/domain/entities/teacher_dashboard_result.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_teacherdashboard_request.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';
import 'package:cristalteacher/features/tutorprofile/presentation/cubit/tutordetails_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  static const Color primaryColor = Color(0xFF807FD8);
  static const Color backgroundColor = Color(0xFFF8F7FD);
  static const Color iconBackgroundColor = Color(0xFFF0EDFF);
  static const Color dividerColor = Color(0xFFEEECEF);

  int? expandedSectionIndex;

  List<ProfileDetail> personalDetails = [];
  List<ProfileDetail> contactDetails = [];
  List<ProfileDetail> employmentDetails = [];
  List<ProfileDetail> bankDetails = [];

  String teacherName = '';
  String teacherSubject = '';
  String classInCharge = '';
  String divisionInCharge = '';
  String employeeCode = '';
  String teacherEmail = '';
  String teacherPhone = '';
  String joiningDate = '';

  int studentCount = 0;
  int todayClassCount = 0;

  bool tutorDetailsLoading = true;
  bool dashboardLoading = true;

  @override
  void initState() {
    super.initState();

    teacherName = AppData.teacherName ?? '';
    teacherSubject = AppData.teacherSubject ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadTutorDetails();
      _loadTeacherDashboard();
    });
  }

  Future<void> _loadTutorDetails() async {
    await context.read<TutordetailsCubit>().fetchTutorDetails();
  }

  Future<void> _loadTeacherDashboard() async {
    if (AppData.accYear == null || AppData.employeeId == null) {
      if (!mounted) return;

      setState(() {
        dashboardLoading = false;
      });

      debugPrint(
        'Teacher dashboard not called because AccYear or EmployeeId is null.',
      );

      return;
    }

    context.read<AuthenticationCubit>().fetchTeacherDashboard(
      TeacherDashboardRequest(
        accYear: AppData.accYear!,
        employeeId: AppData.employeeId!,
        branchId: 1,
      ),
    );
  }

  Future<void> _refreshProfile() async {
    setState(() {
      tutorDetailsLoading = true;
      dashboardLoading = true;
    });

    _loadTeacherDashboard();
    await _loadTutorDetails();
  }

  void _toggleSection(int index) {
    setState(() {
      expandedSectionIndex = expandedSectionIndex == index ? null : index;
    });
  }

  List<ProfileDetail> _convertApiData(List<String> apiData) {
    return apiData.map((item) {
      final int separatorIndex = item.indexOf(':');

      if (separatorIndex == -1) {
        return ProfileDetail(label: item.trim(), value: '');
      }

      final String label = item.substring(0, separatorIndex).trim();
      final String value = item.substring(separatorIndex + 1).trim();

      return ProfileDetail(label: label, value: value);
    }).toList();
  }

  String _findValue(List<ProfileDetail> details, List<String> possibleLabels) {
    for (final detail in details) {
      final String currentLabel = detail.label
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('_', '');

      for (final possibleLabel in possibleLabels) {
        final String expectedLabel = possibleLabel
            .toLowerCase()
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('_', '');

        if (currentLabel == expectedLabel ||
            currentLabel.contains(expectedLabel)) {
          return detail.value.trim();
        }
      }
    }

    return '';
  }

  void _setTutorDetails(TutorDetailsDataEntity data) {
    final List<ProfileDetail> newPersonalDetails = _convertApiData(
      data.personalInfo,
    );

    final List<ProfileDetail> newContactDetails = _convertApiData(
      data.contactInfo,
    );

    final List<ProfileDetail> newEmploymentDetails = _convertApiData(
      data.employeeLocationAndDetails,
    );

    final List<ProfileDetail> newBankDetails = _convertApiData(
      data.bankDetails,
    );

    if (!mounted) return;

    setState(() {
      personalDetails = newPersonalDetails;
      contactDetails = newContactDetails;
      employmentDetails = newEmploymentDetails;
      bankDetails = newBankDetails;

      teacherEmail = _findValue(newContactDetails, const [
        'Email',
        'Email Address',
        'Official Email',
        'Personal Email',
      ]);

      teacherPhone = _findValue(newContactDetails, const [
        'Phone Number',
        'Mobile Number',
        'Phone',
        'Mobile',
        'Contact Number',
      ]);

      joiningDate = _findValue(newEmploymentDetails, const [
        'Joining Date',
        'Date Of Joining',
        'Joined On',
        'Joining On',
      ]);

      tutorDetailsLoading = false;
    });
  }

  void _setTeacherDashboard(TeacherDashboardResult result) {
    final data = result.data;

    if (data.isEmpty) {
      if (!mounted) return;

      setState(() {
        dashboardLoading = false;
      });

      return;
    }

    final datum = data.first;

    if (!mounted) return;

    setState(() {
      teacherName = AppData.teacherName ?? teacherName;
      teacherSubject = datum.classChargeSubjects;
      classInCharge = datum.classInCharge;
      divisionInCharge = datum.divisionInCharge;
      employeeCode = datum.employeeCode;
      studentCount = datum.studentCountInCharge;
      todayClassCount = datum.todayPeriods.length;
      dashboardLoading = false;

      AppData.teacherSubject = datum.classChargeSubjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TutordetailsCubit, TutordetailsState>(
          listener: (context, state) {
            if (state is TutordetailsLoading) {
              if (!mounted) return;

              setState(() {
                tutorDetailsLoading = true;
              });
            }

            if (state is TutordetailsSuccess) {
              final TutorDetailsDataEntity? data = state.tutorDetails.data;

              if (data != null) {
                _setTutorDetails(data);
              } else {
                if (!mounted) return;

                setState(() {
                  tutorDetailsLoading = false;
                });
              }
            }

            if (state is TutordetailsFailure) {
              if (!mounted) return;

              setState(() {
                tutorDetailsLoading = false;
              });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is FetchDashboardSuccess) {
              _setTeacherDashboard(state.response);
            }

            if (state is FetchDashboardFailure) {
              if (!mounted) return;

              setState(() {
                dashboardLoading = false;
              });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 62,
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 23),
          ),
          title: const Text(
            'Teacher Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: _refreshProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
              child: Column(
                children: [
                  _buildMainProfileCard(),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    index: 0,
                    svgAsset: 'assets/icons/Layer 2.svg',
                    iconColor: const Color(0xFF653FE4),
                    title: 'Personal Information',
                    child: _buildPersonalInformation(),
                  ),
                  _buildSectionCard(
                    index: 1,
                    svgAsset: 'assets/icons/Group (24).svg',
                    iconColor: const Color(0xFF653FE4),
                    title: 'Contact Information',
                    child: _buildContactInformation(),
                  ),
                  _buildSectionCard(
                    index: 2,
                    svgAsset: 'assets/icons/Clip path group (2).svg',
                    iconColor: const Color(0xFF653FE4),
                    title: 'Employment & Location Details',
                    child: _buildEmploymentInformation(),
                  ),
                  _buildSectionCard(
                    index: 4,
                    svgAsset: 'assets/icons/Group (27).svg',
                    iconColor: const Color(0xFF653FE4),
                    title: 'Bank Details',
                    child: _buildBankInformation(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE5E3E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 23),
          _buildStatistics(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4D0DB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 31,
            backgroundColor: Color(0xFFF0EDFF),
            backgroundImage: AssetImage('assets/images/defaultstudent.png'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacherName.trim().isEmpty ? '--' : teacherName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF17151E),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 17,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: dashboardLoading
                        ? _buildValueLoader(width: 75)
                        : Text(
                            teacherSubject.trim().isEmpty
                                ? 'Teacher'
                                : '$teacherSubject Teacher',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6C46E8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 9),
                _buildContactLine(
                  svgAsset: 'assets/icons/Group (28).svg',
                  text: teacherEmail.trim().isEmpty ? '--' : teacherEmail,
                  isLoading: tutorDetailsLoading,
                ),
                const SizedBox(height: 9),
                _buildContactLine(
                  svgAsset: 'assets/icons/Clip path group (3).svg',
                  text: teacherPhone.trim().isEmpty ? '--' : teacherPhone,
                  isLoading: tutorDetailsLoading,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactLine({
    required String svgAsset,
    required String text,
    bool isLoading = false,
  }) {
    return Row(
      children: [
        SvgPicture.asset(svgAsset, width: 15, height: 15, fit: BoxFit.contain),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 16,
            child: Align(
              alignment: Alignment.centerLeft,
              child: isLoading
                  ? _buildValueLoader(width: 90)
                  : Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF44404A),
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    final String assignedClass = [
      classInCharge,
      divisionInCharge,
    ].where((value) => value.trim().isNotEmpty).join(' ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStatisticItem(
            iconColor: const Color(0xFF3F3F3F),
            svgAsset: 'assets/icons/Group 951.svg',
            iconBackground: const Color(0xFFE7F0E8),
            value: employeeCode.trim().isEmpty ? '--' : employeeCode,
            label: 'Staff Code',
            isLoading: dashboardLoading,
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildStatisticItem(
            svgAsset: 'assets/icons/Group 1312.svg',
            iconColor: const Color(0xFF3F3F3F),
            iconBackground: const Color(0xFFEAE4FA),
            value: '$studentCount',
            label: 'Student Total',
            isLoading: dashboardLoading,
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildStatisticItem(
            svgAsset: 'assets/icons/Vector (3).svg',
            iconColor: const Color(0xFF3F3F3F),
            iconBackground: const Color(0xFFF0EAE1),
            value: assignedClass.isEmpty ? '--' : assignedClass,
            label: 'Assigned Class',
            isLoading: dashboardLoading,
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildStatisticItem(
            svgAsset: 'assets/icons/Group (15).svg',
            iconColor: const Color(0xFF3F3F3F),
            iconBackground: const Color(0xFFE7EEF1),
            value: joiningDate.trim().isEmpty
                ? '$todayClassCount'
                : joiningDate,
            label: joiningDate.trim().isEmpty ? 'Today Classes' : 'Joining On',
            isLoading: tutorDetailsLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.only(top: 31),
      color: const Color(0xFFE7E4E9),
    );
  }

  Widget _buildStatisticItem({
    required String svgAsset,
    required Color iconColor,
    required Color iconBackground,
    required String value,
    required String label,
    bool isLoading = false,
  }) {
    return Column(
      children: [
        Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            svgAsset,
            width: 21,
            height: 21,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 18,
          child: Center(
            child: isLoading
                ? _buildValueLoader(width: 28)
                : Text(
                    value.trim().isEmpty ? '--' : value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF18151D),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF47424C), fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildValueLoader({required double width}) {
    return _ValueLoadingEffect(width: width, height: 4);
  }

  Widget _buildSectionCard({
    required int index,
    required String svgAsset,
    Color? iconColor,
    required String title,
    required Widget child,
  }) {
    final bool isExpanded = expandedSectionIndex == index;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isExpanded
              ? primaryColor.withOpacity(0.30)
              : const Color(0xFFE3E1E6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleSection(index),
              borderRadius: BorderRadius.circular(17),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 41,
                      height: 41,
                      decoration: const BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        svgAsset,
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        colorFilter: iconColor == null
                            ? null
                            : ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF4D4851),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 220),
                      turns: isExpanded ? -0.25 : 0,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: isExpanded
                            ? const Color(0xFF653FE4)
                            : const Color(0xFF8E8992),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeInOut,
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {
    if (tutorDetailsLoading && personalDetails.isEmpty) {
      return _buildDetailsLoading();
    }

    if (personalDetails.isEmpty) {
      return _buildEmptyDetails();
    }

    return _buildDetailsGrid(personalDetails);
  }

  Widget _buildContactInformation() {
    if (tutorDetailsLoading && contactDetails.isEmpty) {
      return _buildDetailsLoading();
    }

    if (contactDetails.isEmpty) {
      return _buildEmptyDetails();
    }

    return _buildDetailsGrid(contactDetails);
  }

  Widget _buildEmploymentInformation() {
    if (tutorDetailsLoading && employmentDetails.isEmpty) {
      return _buildDetailsLoading();
    }

    if (employmentDetails.isEmpty) {
      return _buildEmptyDetails();
    }

    return _buildDetailsGrid(employmentDetails);
  }

  Widget _buildBankInformation() {
    if (tutorDetailsLoading && bankDetails.isEmpty) {
      return _buildDetailsLoading();
    }

    if (bankDetails.isEmpty) {
      return _buildEmptyDetails();
    }

    return _buildDetailsGrid(bankDetails);
  }

  Widget _buildDetailsLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: 23,
          height: 23,
          child: CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyDetails() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No details available',
          style: TextStyle(
            color: Color(0xFF8E8992),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(List<ProfileDetail> details) {
    final int rowCount = (details.length / 2).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        final int leftIndex = rowIndex * 2;
        final int rightIndex = leftIndex + 1;

        final ProfileDetail leftDetail = details[leftIndex];

        final ProfileDetail? rightDetail = rightIndex < details.length
            ? details[rightIndex]
            : null;

        final bool isLastRow = rowIndex == rowCount - 1;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDetailItem(leftDetail)),
                const SizedBox(width: 24),
                Expanded(
                  child: rightDetail != null
                      ? _buildDetailItem(rightDetail)
                      : const SizedBox(),
                ),
              ],
            ),
            if (!isLastRow) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.7, color: dividerColor),
              const SizedBox(height: 16),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildDetailItem(ProfileDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF464149),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail.value.trim().isEmpty ? '--' : detail.value,
          style: const TextStyle(
            color: Color(0xFF111126),
            fontSize: 15,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ProfileDetail {
  final String label;
  final String value;

  const ProfileDetail({required this.label, required this.value});
}

class _ValueLoadingEffect extends StatefulWidget {
  final double width;
  final double height;

  const _ValueLoadingEffect({required this.width, required this.height});

  @override
  State<_ValueLoadingEffect> createState() => _ValueLoadingEffectState();
}

class _ValueLoadingEffectState extends State<_ValueLoadingEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _movementAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _movementAnimation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            gradient: LinearGradient(
              begin: Alignment(_movementAnimation.value - 1, 0),
              end: Alignment(_movementAnimation.value, 0),
              colors: const [
                Color(0xFFE5E2F8),
                Color(0xFF807FD8),
                Color(0xFFE5E2F8),
              ],
              stops: [0.15, 0.50, 0.85],
            ),
          ),
        );
      },
    );
  }
}
