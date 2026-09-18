// // import 'package:cristalteacher/core/appdata/appdata.dart';
// // import 'package:cristalteacher/core/navigation/navigator.dart';
// // import 'package:cristalteacher/features/authentication/data/models/fetch_branch_model.dart';
// // import 'package:cristalteacher/features/authentication/domain/parameters/fetch_school_parameter.dart';
// // import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// // import 'package:cristalteacher/features/authentication/presentation/screens/login_screen.dart';
// // import 'package:cristalteacher/services/shared_preference_helper.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class RegisterCodePage extends StatelessWidget {
// //   const RegisterCodePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final TextEditingController schoolCodeController = TextEditingController();
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // Top Purple Section
// //             Container(
// //               width: double.infinity,
// //               height: 220,
// //               decoration: BoxDecoration(
// //                 color: Color(0xFF273D8F),
// //                 borderRadius: const BorderRadius.only(
// //                   bottomLeft: Radius.circular(40),
// //                 ),
// //               ),
// //               child: Stack(
// //                 children: [
// //                   // // Background watermark
// //                   // Positioned(
// //                   //   right: -10,
// //                   //   top: 10,
// //                   //   bottom: 10,
// //                   //   child: Opacity(
// //                   //     opacity: 0.99, //
// //                   //     child: Image.asset(
// //                   //       "assets/images/mask_bg.png",
// //                   //       color: Colors.white,
// //                   //       height: 150,
// //                   //       fit: BoxFit.contain,
// //                   //     ),
// //                   //   ),
// //                   // ),

// //                   //Logo
// //                   Center(
// //                     child: Image.asset(
// //                       'assets/images/cristal_white.png',
// //                       height: 60,
// //                       fit: BoxFit.contain,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 50),

// //             // Register Code Title
// //             const Text(
// //               "School Code",
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.black,
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             // TextField
// //             BlocConsumer<AuthenticationCubit, AuthenticationState>(
// //               listener: (context, state) async {
// //                 if (state is FetchSchoolLoading) {
// //                   showDialog(
// //                     context: context,
// //                     barrierDismissible: false,
// //                     builder: (_) =>
// //                         const Center(child: CircularProgressIndicator()),
// //                   );
// //                 }

// //                 if (state is FetchSchoolSuccess) {
// //                   print('SuccessResult ${state.response.message}');
// //                   if (state.response.message == 'School Not Found') {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('School Code not found..!')),
// //                     );
// //                   }
// //                   Navigator.pop(context); // close loader

// //                   // final school = state.response.schoolDetails?.first;
// //                   final pref = SharedPreferenceHelper();
// //                   // 👉 You can store baseUrl + dbName here if needed
// //                   await pref.saveSchoolRegistered(true); // 🔥 THIS IS IMPORTANT

// //                   print("Saved school registered TRUE"); // add this

// //                   /// 🔥 GET SCHOOL DATA
// //                   final school = state.response.schoolDetails?.first;

// //                   if (school != null) {
// //                     /// ✅ SAVE BASE URL
// //                     await pref.setBaseUrl(school.baseUrl ?? '');

// //                     // School Code
// //                     await pref.setSchoolCode(
// //                       schoolCodeController.text.toString(),
// //                     );

// //                     /// ✅ SAVE DB NAME
// //                     await pref.setDatabaseName(school.dbName ?? '');

// //                     await pref.setAppStoreVersion(school.appStoreVersion!);
// //                     await pref.setPlayStoreVersion(school.playStoreVersion!);

// //                     print("BaseURL saved: ${school.baseUrl}");
// //                     print("DB Name saved: ${school.dbName}");
// //                   }

// //                   /// 🔥 CALL NEXT API (branch)
// //                   context.read<AuthenticationCubit>().getBranchDetails();
// //                   // AppNavigator.pushSlide(context: context, page: MainSplashScreen());
// //                 }

// //                 if (state is FetchSchoolFailure) {
// //                   Navigator.pop(context); // close loader

// //                   ScaffoldMessenger.of(
// //                     context,
// //                   ).showSnackBar(SnackBar(content: Text(state.message)));
// //                 }

// //                 /// 🔄 BRANCH LOADING
// //                 if (state is GetBranchLoading) {
// //                   showDialog(
// //                     context: context,
// //                     barrierDismissible: false,
// //                     builder: (_) =>
// //                         const Center(child: CircularProgressIndicator()),
// //                   );
// //                 }

// //                 /// ✅ BRANCH SUCCESS
// //                 if (state is GetBranchSuccess) {
// //                   Navigator.pop(context); // close loader

// //                   final pref = SharedPreferenceHelper();

// //                   final branch = state.response.data;

// //                   if (branch != null && branch is BranchDataModel) {
// //                     await pref.saveBranchData(branch.toJson());

// //                     /// Save to AppData
// //                     AppData.branchId = branch.branchId;
// //                     AppData.branchName = branch.branchName;
// //                     print("Branch saved successfully: ${branch.branchName}");
// //                     print("Branch saved successfully: ${branch.branchName}");
// //                     print("Branch Id: ${AppData.branchId}");
// //                   }
// //                   AppNavigator.pushReplacementSlide(
// //                     context: context,
// //                     page: LoginScreen(),
// //                   );
// //                 }

// //                 /// ❌ BRANCH FAILURE
// //                 if (state is GetBranchFailure) {
// //                   Navigator.pop(context);
// //                   ScaffoldMessenger.of(
// //                     context,
// //                   ).showSnackBar(SnackBar(content: Text(state.message)));
// //                 }
// //               },
// //               builder: (context, state) {
// //                 return Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   child: TextField(
// //                     controller: schoolCodeController,
// //                     textCapitalization: TextCapitalization.characters,
// //                     inputFormatters: [
// //                       FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
// //                       UpperCaseTextFormatter(),
// //                     ],
// //                     decoration: InputDecoration(
// //                       hintText: "Enter Code",
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                         borderSide: BorderSide(color: Colors.grey.shade400),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                         borderSide: BorderSide(color: Colors.grey.shade400),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                         borderSide: const BorderSide(
// //                           color: Color(0xFF8D84E8),
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),

// //             const Spacer(),

// //             // Connect Button
// //             Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: SizedBox(
// //                 width: double.infinity,
// //                 height: 50,
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF8D84E8),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(6),
// //                     ),
// //                     elevation: 0,
// //                   ),
// //                   onPressed: () {
// //                     final code = schoolCodeController.text.trim();

// //                     if (code.isEmpty) {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                           content: Text("Please enter school code"),
// //                         ),
// //                       );
// //                       return;
// //                     }

// //                     /// 🔥 CALL API
// //                     context.read<AuthenticationCubit>().fetchSchools(
// //                       FetchSchoolRequest(slno: code),
// //                     );
// //                   },
// //                   child: const Text(
// //                     "Connect",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class UpperCaseTextFormatter extends TextInputFormatter {
// //   @override
// //   TextEditingValue formatEditUpdate(
// //     TextEditingValue oldValue,
// //     TextEditingValue newValue,
// //   ) {
// //     return newValue.copyWith(
// //       text: newValue.text.toUpperCase(),
// //       selection: newValue.selection,
// //     );
// //   }
// // }
// // import 'package:cristalteacher/core/appdata/appdata.dart';
// // import 'package:cristalteacher/core/navigation/navigator.dart';
// // import 'package:cristalteacher/features/authentication/data/models/fetch_branch_model.dart';
// // import 'package:cristalteacher/features/authentication/domain/parameters/fetch_school_parameter.dart';
// // import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// // import 'package:cristalteacher/features/authentication/presentation/screens/login_screen.dart';
// // import 'package:cristalteacher/services/shared_preference_helper.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // /// Light lavender used for the decorative circles in the background.
// // const Color kBlobColor = Color(0xFFECECFF);
// // const Color kPrimaryPurple = Color(0xFF8D84E8);

// // class RegisterCodePage extends StatelessWidget {
// //   const RegisterCodePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final TextEditingController schoolCodeController = TextEditingController();

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Stack(
// //         children: [
// //           /// 🎨 BACKGROUND DECORATION (lavender circles)
// //           const Positioned.fill(child: _BackgroundBlobs()),

// //           /// 📄 CONTENT
// //           SafeArea(
// //             child: LayoutBuilder(
// //               builder: (context, constraints) {
// //                 return SingleChildScrollView(
// //                   physics: const ClampingScrollPhysics(),
// //                   child: ConstrainedBox(
// //                     constraints: BoxConstraints(
// //                       minHeight: constraints.maxHeight,
// //                     ),
// //                     child: IntrinsicHeight(
// //                       child: Column(
// //                         children: [
// //                           const Spacer(flex: 2),

// //                           /// 🏫 ILLUSTRATION
// //                           Padding(
// //                             padding: const EdgeInsets.symmetric(horizontal: 32),
// //                             child: Image.asset(
// //                               'assets/images/image 63.png',
// //                               height: 180,
// //                               fit: BoxFit.contain,
// //                             ),
// //                           ),

// //                           const SizedBox(height: 28),

// //                           /// 📝 SUBTITLE
// //                           const Padding(
// //                             padding: EdgeInsets.symmetric(horizontal: 32),
// //                             child: Text(
// //                               "Enter  Your School Code Get  Started\nAnd Connect With Your School",
// //                               textAlign: TextAlign.center,
// //                               style: TextStyle(
// //                                 fontSize: 12.5,
// //                                 height: 1.5,
// //                                 fontWeight: FontWeight.w500,
// //                                 color: Color(0xFF3D3D3D),
// //                               ),
// //                             ),
// //                           ),

// //                           const SizedBox(height: 22),

// //                           /// 🔠 TITLE
// //                           const Text(
// //                             "Register Code",
// //                             style: TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.w700,
// //                               color: Colors.black,
// //                             ),
// //                           ),

// //                           const SizedBox(height: 22),

// //                           /// ⌨️ TEXT FIELD
// //                           BlocConsumer<
// //                             AuthenticationCubit,
// //                             AuthenticationState
// //                           >(
// //                             listener: (context, state) async {
// //                               if (state is FetchSchoolLoading) {
// //                                 showDialog(
// //                                   context: context,
// //                                   barrierDismissible: false,
// //                                   builder: (_) => const Center(
// //                                     child: CircularProgressIndicator(),
// //                                   ),
// //                                 );
// //                               }

// //                               if (state is FetchSchoolSuccess) {
// //                                 print(
// //                                   'SuccessResult ${state.response.message}',
// //                                 );
// //                                 if (state.response.message ==
// //                                     'School Not Found') {
// //                                   ScaffoldMessenger.of(context).showSnackBar(
// //                                     SnackBar(
// //                                       content: Text('School Code not found..!'),
// //                                     ),
// //                                   );
// //                                 }
// //                                 Navigator.pop(context); // close loader

// //                                 // final school = state.response.schoolDetails?.first;
// //                                 final pref = SharedPreferenceHelper();
// //                                 // 👉 You can store baseUrl + dbName here if needed
// //                                 await pref.saveSchoolRegistered(
// //                                   true,
// //                                 ); // 🔥 THIS IS IMPORTANT

// //                                 print(
// //                                   "Saved school registered TRUE",
// //                                 ); // add this

// //                                 /// 🔥 GET SCHOOL DATA
// //                                 final school =
// //                                     state.response.schoolDetails?.first;

// //                                 if (school != null) {
// //                                   /// ✅ SAVE BASE URL
// //                                   await pref.setBaseUrl(school.baseUrl ?? '');

// //                                   // School Code
// //                                   await pref.setSchoolCode(
// //                                     schoolCodeController.text.toString(),
// //                                   );

// //                                   /// ✅ SAVE DB NAME
// //                                   await pref.setDatabaseName(
// //                                     school.dbName ?? '',
// //                                   );

// //                                   await pref.setAppStoreVersion(
// //                                     school.appStoreVersion!,
// //                                   );
// //                                   await pref.setPlayStoreVersion(
// //                                     school.playStoreVersion!,
// //                                   );

// //                                   print("BaseURL saved: ${school.baseUrl}");
// //                                   print("DB Name saved: ${school.dbName}");
// //                                 }

// //                                 /// 🔥 CALL NEXT API (branch)
// //                                 context
// //                                     .read<AuthenticationCubit>()
// //                                     .getBranchDetails();
// //                                 // AppNavigator.pushSlide(context: context, page: MainSplashScreen());
// //                               }

// //                               if (state is FetchSchoolFailure) {
// //                                 Navigator.pop(context); // close loader

// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(content: Text(state.message)),
// //                                 );
// //                               }

// //                               /// 🔄 BRANCH LOADING
// //                               if (state is GetBranchLoading) {
// //                                 showDialog(
// //                                   context: context,
// //                                   barrierDismissible: false,
// //                                   builder: (_) => const Center(
// //                                     child: CircularProgressIndicator(),
// //                                   ),
// //                                 );
// //                               }

// //                               /// ✅ BRANCH SUCCESS
// //                               if (state is GetBranchSuccess) {
// //                                 Navigator.pop(context); // close loader

// //                                 final pref = SharedPreferenceHelper();

// //                                 final branch = state.response.data;

// //                                 if (branch != null &&
// //                                     branch is BranchDataModel) {
// //                                   await pref.saveBranchData(branch.toJson());

// //                                   /// Save to AppData
// //                                   AppData.branchId = branch.branchId;
// //                                   AppData.branchName = branch.branchName;
// //                                   print(
// //                                     "Branch saved successfully: ${branch.branchName}",
// //                                   );
// //                                   print(
// //                                     "Branch saved successfully: ${branch.branchName}",
// //                                   );
// //                                   print("Branch Id: ${AppData.branchId}");
// //                                 }
// //                                 AppNavigator.pushReplacementSlide(
// //                                   context: context,
// //                                   page: LoginScreen(),
// //                                 );
// //                               }

// //                               /// ❌ BRANCH FAILURE
// //                               if (state is GetBranchFailure) {
// //                                 Navigator.pop(context);
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(content: Text(state.message)),
// //                                 );
// //                               }
// //                             },
// //                             builder: (context, state) {
// //                               return Padding(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   horizontal: 22,
// //                                 ),
// //                                 child: Container(
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.white,
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     boxShadow: [
// //                                       BoxShadow(
// //                                         color: Colors.black.withOpacity(0.06),
// //                                         blurRadius: 12,
// //                                         offset: const Offset(0, 4),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   child: TextField(
// //                                     controller: schoolCodeController,
// //                                     textCapitalization:
// //                                         TextCapitalization.characters,
// //                                     inputFormatters: [
// //                                       FilteringTextInputFormatter.allow(
// //                                         RegExp(r'[A-Z0-9]'),
// //                                       ),
// //                                       UpperCaseTextFormatter(),
// //                                     ],
// //                                     style: const TextStyle(
// //                                       fontSize: 14,
// //                                       fontWeight: FontWeight.w500,
// //                                       color: Colors.black87,
// //                                     ),
// //                                     decoration: InputDecoration(
// //                                       hintText: "Enter School Code",
// //                                       hintStyle: const TextStyle(
// //                                         fontSize: 13,
// //                                         color: Color(0xFF9A9A9A),
// //                                       ),
// //                                       filled: true,
// //                                       fillColor: Colors.white,
// //                                       prefixIcon: Padding(
// //                                         padding: const EdgeInsets.fromLTRB(
// //                                           12,
// //                                           10,
// //                                           10,
// //                                           10,
// //                                         ),
// //                                         child: Container(
// //                                           width: 34,
// //                                           height: 34,
// //                                           decoration: BoxDecoration(
// //                                             color: const Color(0xFF6C63E8),
// //                                             borderRadius: BorderRadius.circular(
// //                                               8,
// //                                             ),
// //                                           ),
// //                                           child: const Icon(
// //                                             Icons.account_balance_rounded,
// //                                             color: Colors.white,
// //                                             size: 19,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       prefixIconConstraints:
// //                                           const BoxConstraints(
// //                                             minWidth: 56,
// //                                             minHeight: 54,
// //                                           ),
// //                                       contentPadding:
// //                                           const EdgeInsets.symmetric(
// //                                             horizontal: 12,
// //                                             vertical: 18,
// //                                           ),
// //                                       border: OutlineInputBorder(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                         borderSide: BorderSide(
// //                                           color: Colors.grey.shade300,
// //                                         ),
// //                                       ),
// //                                       enabledBorder: OutlineInputBorder(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                         borderSide: BorderSide(
// //                                           color: Colors.grey.shade300,
// //                                         ),
// //                                       ),
// //                                       focusedBorder: OutlineInputBorder(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                         borderSide: const BorderSide(
// //                                           color: kPrimaryPurple,
// //                                           width: 1.5,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                           ),

// //                           const SizedBox(height: 40),

// //                           /// 🟣 CONNECT BUTTON
// //                           Padding(
// //                             padding: const EdgeInsets.symmetric(horizontal: 22),
// //                             child: SizedBox(
// //                               width: double.infinity,
// //                               height: 50,
// //                               child: ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: kPrimaryPurple,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(8),
// //                                   ),
// //                                   elevation: 0,
// //                                 ),
// //                                 onPressed: () {
// //                                   final code = schoolCodeController.text.trim();

// //                                   if (code.isEmpty) {
// //                                     ScaffoldMessenger.of(context).showSnackBar(
// //                                       const SnackBar(
// //                                         content: Text(
// //                                           "Please enter school code",
// //                                         ),
// //                                       ),
// //                                     );
// //                                     return;
// //                                   }

// //                                   /// 🔥 CALL API
// //                                   context
// //                                       .read<AuthenticationCubit>()
// //                                       .fetchSchools(
// //                                         FetchSchoolRequest(slno: code),
// //                                       );
// //                                 },
// //                                 child: const Text(
// //                                   "Connect",
// //                                   style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),

// //                           const Spacer(flex: 3),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // /// Decorative lavender circles behind the whole screen.
// // class _BackgroundBlobs extends StatelessWidget {
// //   const _BackgroundBlobs();

// //   @override
// //   Widget build(BuildContext context) {
// //     return ClipRect(
// //       child: Stack(
// //         children: const [
// //           // top-left
// //           Positioned(left: -70, top: -50, child: _Blob(170)),
// //           // top-right big
// //           Positioned(right: -80, top: -70, child: _Blob(230)),
// //           // top-right small overlap
// //           Positioned(right: 30, top: 95, child: _Blob(110)),
// //           // bottom-left big
// //           Positioned(left: -95, bottom: -70, child: _Blob(270)),
// //           // bottom-left small overlap
// //           Positioned(left: 60, bottom: -40, child: _Blob(140)),
// //           // bottom-right
// //           Positioned(right: -55, bottom: 40, child: _Blob(150)),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _Blob extends StatelessWidget {
// //   final double size;
// //   const _Blob(this.size);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: size,
// //       height: size,
// //       decoration: const BoxDecoration(
// //         color: kBlobColor,
// //         shape: BoxShape.circle,
// //       ),
// //     );
// //   }
// // }

// // class UpperCaseTextFormatter extends TextInputFormatter {
// //   @override
// //   TextEditingValue formatEditUpdate(
// //     TextEditingValue oldValue,
// //     TextEditingValue newValue,
// //   ) {
// //     return newValue.copyWith(
// //       text: newValue.text.toUpperCase(),
// //       selection: newValue.selection,
// //     );
// //   }
// // }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/navigation/navigator.dart';
import 'package:cristalteacher/features/authentication/data/models/fetch_branch_model.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_school_parameter.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/login_screen.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

const Color kBlobColor = Color(0xFFDFDFFF);
const Color kPrimaryPurple = Color(0xFF8D84E8);

class RegisterCodePage extends StatefulWidget {
  const RegisterCodePage({super.key});

  @override
  State<RegisterCodePage> createState() => _RegisterCodePageState();
}

class _RegisterCodePageState extends State<RegisterCodePage> {
  final TextEditingController schoolCodeController = TextEditingController();

  bool _loaderVisible = false;

  @override
  void dispose() {
    schoolCodeController.dispose();
    super.dispose();
  }

  void _showLoader() {
    if (_loaderVisible || !mounted) return;

    _loaderVisible = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(color: kPrimaryPurple),
          ),
        );
      },
    ).then((_) {
      _loaderVisible = false;
    });
  }

  void _closeLoader() {
    if (!_loaderVisible || !mounted) return;

    Navigator.of(context, rootNavigator: true).pop();

    _loaderVisible = false;
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _submitSchoolCode() {
    FocusScope.of(context).unfocus();

    final String code = schoolCodeController.text.trim();

    if (code.isEmpty) {
      _showMessage('Please enter school code');
      return;
    }

    context.read<AuthenticationCubit>().fetchSchools(
      FetchSchoolRequest(slno: code),
    );
  }

  Future<void> _authenticationListener(
    BuildContext context,
    AuthenticationState state,
  ) async {
    if (state is FetchSchoolLoading) {
      _showLoader();
      return;
    }

    if (state is FetchSchoolSuccess) {
      _closeLoader();

      debugPrint('SuccessResult: ${state.response.message}');

      if (state.response.message == 'School Not Found') {
        _showMessage('School Code not found..!');
        return;
      }

      final school = state.response.schoolDetails?.first;

      if (school == null) {
        _showMessage('School details not available');
        return;
      }

      final SharedPreferenceHelper pref = SharedPreferenceHelper();

      await pref.saveSchoolRegistered(true);

      await pref.setBaseUrl(school.baseUrl ?? '');

      await pref.setSchoolCode(schoolCodeController.text.trim());

      await pref.setDatabaseName(school.dbName ?? '');

      if (school.appStoreVersion != null) {
        await pref.setAppStoreVersion(school.appStoreVersion!);
      }

      if (school.playStoreVersion != null) {
        await pref.setPlayStoreVersion(school.playStoreVersion!);
      }

      debugPrint('Saved school registered: TRUE');
      debugPrint('Base URL saved: ${school.baseUrl}');
      debugPrint('DB Name saved: ${school.dbName}');

      if (!mounted) return;

      context.read<AuthenticationCubit>().getBranchDetails();

      return;
    }

    if (state is FetchSchoolFailure) {
      _closeLoader();
      _showMessage(state.message);
      return;
    }

    if (state is GetBranchLoading) {
      _showLoader();
      return;
    }

    if (state is GetBranchSuccess) {
      _closeLoader();

      final SharedPreferenceHelper pref = SharedPreferenceHelper();

      final dynamic branch = state.response.data;

      if (branch != null && branch is BranchDataModel) {
        await pref.saveBranchData(branch.toJson());

        AppData.branchId = branch.branchId;
        AppData.branchName = branch.branchName;

        debugPrint(
          'Branch saved successfully: '
          '${branch.branchName}',
        );

        debugPrint('Branch ID: ${AppData.branchId}');
      }

      if (!mounted) return;

      AppNavigator.pushReplacementSlide(
        context: context,
        page: const LoginScreen(),
      );

      return;
    }

    if (state is GetBranchFailure) {
      _closeLoader();
      _showMessage(state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: _authenticationListener,
        child: Stack(
          children: [
            // Lavender decorative circles.
            const _BackgroundBlobs(),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const Spacer(flex: 2),

                            // School illustration.
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Image.asset(
                                'assets/images/image 63.png',
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    'School image error: '
                                    '$error',
                                  );

                                  return const SizedBox(
                                    height: 170,
                                    child: Center(
                                      child: Icon(
                                        Icons.school_rounded,
                                        size: 100,
                                        color: kPrimaryPurple,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Subtitle.
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'Enter Your School Code Get Started\n'
                                'And Connect With Your School',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3D3D3D),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Page title.
                            const Text(
                              'Register Code',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 22),

                            // School-code text field.
                            _buildSchoolCodeField(),

                            const SizedBox(height: 90),

                            // Connect button.
                            _buildConnectButton(),

                            const Spacer(flex: 5),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolCodeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: schoolCodeController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            UpperCaseTextFormatter(),
          ],
          onSubmitted: (_) => _submitSchoolCode(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Enter School Code',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9A9A9A)),
            filled: true,
            fillColor: Colors.white,

            // prefixIcon: Padding(
            //   padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            //   child: Container(
            //     width: 34,
            //     height: 34,
            //     decoration: BoxDecoration(
            //       color: const Color(0xFF6C63E8),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: const Icon(
            //       Icons.account_balance_rounded,
            //       color: Colors.white,
            //       size: 19,
            //     ),
            //   ),
            // ),
            // prefixIconConstraints: const BoxConstraints(
            //   minWidth: 56,
            //   minHeight: 54,
            // ),
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/Vector (4).svg',
                  width: 19,
                  height: 19,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 54,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD3D2D7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD3D2D7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryPurple, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _submitSchoolCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryPurple,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Connect',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundBlobs extends StatelessWidget {
  const _BackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: ClipRect(child: CustomPaint(painter: _BlobPainter())),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  const _BlobPainter();

  static const Color lightCircleColor = Color(0xFFECECFF);

  static const Color darkCircleColor = Color(0xFFDFDFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint lightPaint = Paint()
      ..color = lightCircleColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint darkPaint = Paint()
      ..color = darkCircleColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // ============================================================
    // TOP CIRCLES
    // ============================================================

    // Large light circle at top-center.
    canvas.drawCircle(
      Offset(width * 0.505, height * 0.010),
      width * 0.300,
      lightPaint,
    );

    // Darker circle at top-right.
    canvas.drawCircle(
      Offset(width * 0.950, height * 0.040),
      width * 0.270,
      darkPaint,
    );

    // Light circle overlapping the darker circle from the right.
    //
    // This creates the lighter crescent visible at the
    // extreme right of the reference image.
    canvas.drawCircle(
      Offset(width * 1.210, height * 0.075),
      width * 0.270,
      lightPaint,
    );

    // ============================================================
    // BOTTOM CIRCLES
    // ============================================================

    // Light partial circle entering from bottom-left.
    canvas.drawCircle(
      Offset(width * -0.120, height * 1.075),
      width * 0.380,
      lightPaint,
    );

    // Darker main circle at bottom-left/center.
    canvas.drawCircle(
      Offset(width * 0.280, height * 1.055),
      width * 0.340,
      darkPaint,
    );

    // Light circle overlapping the darker bottom circle.
    canvas.drawCircle(
      Offset(width * 0.540, height * 1.085),
      width * 0.310,
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return false;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
