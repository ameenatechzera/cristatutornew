// // import 'package:cristalteacher/core/appdata/appdata.dart';
// // import 'package:cristalteacher/features/authentication/domain/parameters/login_parameter.dart';
// // import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// // import 'package:cristalteacher/features/authentication/presentation/screens/teacherDashboard_screen.dart';
// // import 'package:cristalteacher/services/shared_preference_helper.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   final TextEditingController admissionController = TextEditingController();
// //   final TextEditingController dobController = TextEditingController();

// //   @override
// //   void dispose() {
// //     admissionController.dispose();
// //     dobController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocConsumer<AuthenticationCubit, AuthenticationState>(
// //       listener: (context, state) async {
// //         if (state is AuthenticationSuccess) {
// //           final pref = SharedPreferenceHelper();

// //           final loginResponse = state.loginEntity;
// //           final loginData = loginResponse.data;
// //           final user = loginData?.user;

// //           final String token = loginData?.token ?? '';

// //           if (token.isEmpty) {
// //             ScaffoldMessenger.of(
// //               context,
// //             ).showSnackBar(const SnackBar(content: Text('Token not found')));
// //             return;
// //           }

// //           await pref.setToken(token);
// //           await pref.saveLoginResponse(loginResponse);

// //           AppData.employeeId = user?.employeeId;
// //           AppData.userId = user?.id;
// //           AppData.teacherName = user!.name;

// //           debugPrint('===================================');
// //           debugPrint('APP DATA SAVED');
// //           debugPrint('Academic Year: ${AppData.accYear}');
// //           debugPrint('Employee ID: ${AppData.employeeId}');
// //           debugPrint('User ID: ${AppData.userId}');
// //           debugPrint('===================================');

// //           if (!context.mounted) {
// //             return;
// //           }

// //           // context.read<AuthenticationCubit>().fetchTutorshipClass(
// //           //   FetchTutorshipClassRequest(
// //           //     accyear: AppData.accYear,
// //           //     employeeId: AppData.employeeId,
// //           //     userId: AppData.userId,
// //           //   ),
// //           // );
// //           /// Call academic-year API
// //           // context.read<AuthenticationCubit>().fetchAccYear();

// //           // return;
// //           // Navigator.pushReplacement(
// //           //   context,
// //           //   MaterialPageRoute(builder: (_) => TeacherDashboardPage()),
// //           // );
// //           Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(builder: (_) => TeacherDashboardNewPage()),
// //           );
// //         }

// //         // /// ACADEMIC YEAR SUCCESS
// //         // if (state is FetchAccYearSuccess) {
// //         //   final academicYears = state.response.data ?? [];

// //         //   debugPrint('===================================');
// //         //   debugPrint('ACADEMIC YEAR RESPONSE');
// //         //   debugPrint('Count: ${academicYears.length}');
// //         //   debugPrint('===================================');

// //         //   String? activeAccYear;

// //         //   for (final academicYear in academicYears) {
// //         //     debugPrint(
// //         //       'Academic Year: ${academicYear.accYear}, '
// //         //       'Status: ${academicYear.status}',
// //         //     );

// //         //     if (academicYear.status == true) {
// //         //       activeAccYear = academicYear.accYear;
// //         //       break;
// //         //     }
// //         //   }

// //         //   if (activeAccYear == null || activeAccYear.trim().isEmpty) {
// //         //     ScaffoldMessenger.of(context).showSnackBar(
// //         //       const SnackBar(content: Text('Active academic year not found')),
// //         //     );
// //         //     return;
// //         //   }

// //         //   /// Store active academic year in AppData
// //         //   AppData.accYear = activeAccYear;

// //         //   debugPrint('===================================');
// //         //   debugPrint('ACTIVE ACADEMIC YEAR SAVED');
// //         //   debugPrint('Academic Year: ${AppData.accYear}');
// //         //   debugPrint('Employee ID: ${AppData.employeeId}');
// //         //   debugPrint('User ID: ${AppData.userId}');
// //         //   debugPrint('===================================');

// //         //   if (!context.mounted) {
// //         //     return;
// //         //   }

// //         //   /// Fetch standard and division after academic year is available
// //         //   context.read<AuthenticationCubit>().fetchTutorshipClass(
// //         //     FetchTutorshipClassRequest(
// //         //       accyear: AppData.accYear,
// //         //       employeeId: AppData.employeeId,
// //         //       userId: AppData.userId,
// //         //     ),
// //         //   );

// //         //   return;
// //         // }

// //         // /// ACADEMIC YEAR FAILURE
// //         // if (state is FetchAccYearFailure) {
// //         //   ScaffoldMessenger.of(
// //         //     context,
// //         //   ).showSnackBar(SnackBar(content: Text(state.message)));

// //         //   return;
// //         // }
// //         // if (state is FetchTutorshipClassSuccess) {
// //         //   ScaffoldMessenger.of(context).showSnackBar(
// //         //     const SnackBar(content: Text("Standard & Division Loaded")),
// //         //   );

// //         //   Navigator.pushReplacement(
// //         //     context,
// //         //     MaterialPageRoute(builder: (_) => TeacherDashboardPage()),
// //         //   );
// //         // }

// //         if (state is AuthenticationFailure) {
// //           print('errorLogin');
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('Invalid Username Or Password..!')),
// //           );
// //         }

// //         if (state is FetchTutorshipClassFailure) {
// //           ScaffoldMessenger.of(
// //             context,
// //           ).showSnackBar(SnackBar(content: Text(state.message)));
// //         }
// //       },
// //       builder: (context, state) {
// //         final bool isLoading =
// //             state is AuthenticationLoading ||
// //             state is FetchTutorshipClassLoading;

// //         return Scaffold(
// //           backgroundColor: Colors.white,
// //           body: SafeArea(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   Container(
// //                     height: 340,
// //                     width: double.infinity,
// //                     decoration: const BoxDecoration(
// //                       borderRadius: BorderRadius.only(
// //                         bottomLeft: Radius.circular(50),
// //                       ),
// //                     ),
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 24,
// //                         vertical: 40,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFF8B84E8).withOpacity(0.55),
// //                         borderRadius: const BorderRadius.only(
// //                           bottomLeft: Radius.circular(50),
// //                         ),
// //                       ),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         mainAxisAlignment: MainAxisAlignment.end,
// //                         children: [
// //                           Text(
// //                             'Welcome',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 42,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           SizedBox(height: 8),

// //                           Text(
// //                             AppData.schoolName!,
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 22,
// //                               fontWeight: FontWeight.w700,
// //                             ),
// //                           ),
// //                           SizedBox(height: 20),
// //                         ],
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(height: 40),

// //                   const Text(
// //                     'Login',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w700,
// //                       color: Colors.black,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 35),

// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 18),
// //                     child: TextField(
// //                       controller: admissionController,
// //                       textInputAction: TextInputAction.next,
// //                       decoration: InputDecoration(
// //                         hintText: 'Username',
// //                         hintStyle: TextStyle(
// //                           color: Colors.grey.shade700,
// //                           fontSize: 15,
// //                         ),
// //                         contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 15,
// //                           vertical: 14,
// //                         ),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: BorderSide(color: Colors.grey.shade400),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: const BorderSide(
// //                             color: Color(0xFF8B84E8),
// //                             width: 1.5,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(height: 20),

// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 18),
// //                     child: TextField(
// //                       controller: dobController,
// //                       obscureText: true,
// //                       decoration: InputDecoration(
// //                         hintText: 'Password',
// //                         hintStyle: TextStyle(
// //                           color: Colors.grey.shade700,
// //                           fontSize: 15,
// //                         ),
// //                         contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 15,
// //                           vertical: 14,
// //                         ),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: BorderSide(color: Colors.grey.shade400),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: const BorderSide(
// //                             color: Color(0xFF8B84E8),
// //                             width: 1.5,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(height: 50),

// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 20,
// //                       vertical: 24,
// //                     ),
// //                     child: SizedBox(
// //                       width: double.infinity,
// //                       height: 50,
// //                       child: ElevatedButton(
// //                         onPressed: isLoading
// //                             ? null
// //                             : () {
// //                                 if (admissionController.text.trim().isEmpty ||
// //                                     dobController.text.trim().isEmpty) {
// //                                   ScaffoldMessenger.of(context).showSnackBar(
// //                                     const SnackBar(
// //                                       content: Text(
// //                                         "Please enter username and password",
// //                                       ),
// //                                     ),
// //                                   );
// //                                   return;
// //                                 }

// //                                 context.read<AuthenticationCubit>().login(
// //                                   LoginRequest(
// //                                     username: admissionController.text.trim(),
// //                                     password: dobController.text.trim(),
// //                                   ),
// //                                 );
// //                               },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xFF8B84E8),
// //                           foregroundColor: Colors.white,
// //                           elevation: 0,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                         ),
// //                         child: isLoading
// //                             ? const SizedBox(
// //                                 width: 22,
// //                                 height: 22,
// //                                 child: CircularProgressIndicator(
// //                                   strokeWidth: 2,
// //                                   color: Colors.white,
// //                                 ),
// //                               )
// //                             : const Text(
// //                                 'Login',
// //                                 style: TextStyle(
// //                                   fontSize: 15,
// //                                   fontWeight: FontWeight.w600,
// //                                 ),
// //                               ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/login_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/authentication/presentation/screens/teacherDashboard_screen.dart';
// import 'package:cristalteacher/services/shared_preference_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   static const Color primaryColor = Color(0xFF8079DF);
//   static const Color fieldBorderColor = Color(0xFFD9DDF2);
//   static const Color fieldTextColor = Color(0xFF929BB7);

//   final TextEditingController admissionController = TextEditingController();

//   final TextEditingController dobController = TextEditingController();

//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     admissionController.dispose();
//     dobController.dispose();
//     super.dispose();
//   }

//   void _submitLogin(bool isLoading) {
//     if (isLoading) return;

//     FocusScope.of(context).unfocus();

//     if (admissionController.text.trim().isEmpty ||
//         dobController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter username and password')),
//       );
//       return;
//     }

//     context.read<AuthenticationCubit>().login(
//       LoginRequest(
//         username: admissionController.text.trim(),
//         password: dobController.text.trim(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthenticationCubit, AuthenticationState>(
//       listener: (context, state) async {
//         if (state is AuthenticationSuccess) {
//           final pref = SharedPreferenceHelper();

//           final loginResponse = state.loginEntity;
//           final loginData = loginResponse.data;
//           final user = loginData?.user;

//           final String token = loginData?.token ?? '';

//           if (token.isEmpty) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text('Token not found')));
//             return;
//           }

//           await pref.setToken(token);
//           await pref.saveLoginResponse(loginResponse);

//           AppData.employeeId = user?.employeeId;
//           AppData.userId = user?.id;
//           AppData.teacherName = user!.name;

//           debugPrint('===================================');
//           debugPrint('APP DATA SAVED');
//           debugPrint('Academic Year: ${AppData.accYear}');
//           debugPrint('Employee ID: ${AppData.employeeId}');
//           debugPrint('User ID: ${AppData.userId}');
//           debugPrint('===================================');

//           if (!context.mounted) {
//             return;
//           }

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const TeacherDashboardNewPage()),
//           );
//         }

//         if (state is AuthenticationFailure) {
//           debugPrint('errorLogin');

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Invalid Username Or Password..!')),
//           );
//         }

//         if (state is FetchTutorshipClassFailure) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       builder: (context, state) {
//         final bool isLoading =
//             state is AuthenticationLoading ||
//             state is FetchTutorshipClassLoading;

//         return Scaffold(
//           resizeToAvoidBottomInset: true,
//           backgroundColor: Colors.white,
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               return Stack(
//                 children: [
//                   const Positioned.fill(
//                     child: CustomPaint(painter: _LoginBackgroundPainter()),
//                   ),

//                   SafeArea(
//                     child: SingleChildScrollView(
//                       keyboardDismissBehavior:
//                           ScrollViewKeyboardDismissBehavior.onDrag,
//                       padding: EdgeInsets.only(
//                         bottom: MediaQuery.viewInsetsOf(context).bottom,
//                       ),
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           minHeight:
//                               constraints.maxHeight -
//                               MediaQuery.paddingOf(context).top -
//                               MediaQuery.paddingOf(context).bottom,
//                         ),
//                         child: IntrinsicHeight(
//                           child: Column(
//                             children: [
//                               _buildIllustrationSection(context),
//                               _buildLoginSection(isLoading),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildIllustrationSection(BuildContext context) {
//     final double screenHeight = MediaQuery.sizeOf(context).height;

//     return SizedBox(
//       height: screenHeight * 0.385,
//       width: double.infinity,
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Image.asset(
//           'assets/images/image 67 (1).png',
//           height: screenHeight * 0.34,
//           width: double.infinity,
//           fit: BoxFit.contain,
//           alignment: Alignment.bottomCenter,
//           errorBuilder: (context, error, stackTrace) {
//             debugPrint('Login teacher image error: $error');

//             return SizedBox(
//               height: screenHeight * 0.30,
//               child: const Center(
//                 child: Icon(
//                   Icons.person_rounded,
//                   size: 150,
//                   color: primaryColor,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginSection(bool isLoading) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),

//             // The supplied UI shows "Sign Up".
//             const Text(
//               'Sign Up',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Color(0xFF17171A),
//                 fontSize: 17,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),

//             const SizedBox(height: 37),

//             _buildUsernameField(),

//             const SizedBox(height: 10),

//             _buildPasswordField(),

//             const Spacer(),

//             _buildLoginButton(isLoading),

//             // Space above the bottom wave.
//             const SizedBox(height: 116),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUsernameField() {
//     return SizedBox(
//       height: 51,
//       child: TextField(
//         controller: admissionController,
//         keyboardType: TextInputType.text,
//         textInputAction: TextInputAction.next,
//         autofillHints: const [AutofillHints.username],
//         style: const TextStyle(
//           color: Color(0xFF282834),
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           hintText: 'User Name',
//           hintStyle: const TextStyle(
//             color: fieldTextColor,
//             fontSize: 13,
//             fontWeight: FontWeight.w400,
//           ),
//           prefixIcon: const Padding(
//             padding: EdgeInsets.only(left: 13, right: 10),
//             child: Icon(
//               Icons.person_outline_rounded,
//               color: Color(0xFF6548FF),
//               size: 20,
//             ),
//           ),
//           prefixIconConstraints: const BoxConstraints(
//             minWidth: 46,
//             minHeight: 50,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 15,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: fieldBorderColor, width: 1),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: fieldBorderColor, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: primaryColor, width: 1.4),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField() {
//     return SizedBox(
//       height: 51,
//       child: TextField(
//         controller: dobController,
//         obscureText: _obscurePassword,
//         keyboardType: TextInputType.visiblePassword,
//         textInputAction: TextInputAction.done,
//         autofillHints: const [AutofillHints.password],
//         onSubmitted: (_) {
//           final AuthenticationState state = context
//               .read<AuthenticationCubit>()
//               .state;

//           final bool isLoading =
//               state is AuthenticationLoading ||
//               state is FetchTutorshipClassLoading;

//           _submitLogin(isLoading);
//         },
//         style: const TextStyle(
//           color: Color(0xFF282834),
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           hintText: 'Password',
//           hintStyle: const TextStyle(
//             color: fieldTextColor,
//             fontSize: 13,
//             fontWeight: FontWeight.w400,
//           ),
//           prefixIcon: const Padding(
//             padding: EdgeInsets.only(left: 13, right: 10),
//             child: Icon(
//               Icons.lock_outline_rounded,
//               color: Color(0xFF6548FF),
//               size: 19,
//             ),
//           ),
//           prefixIconConstraints: const BoxConstraints(
//             minWidth: 46,
//             minHeight: 50,
//           ),
//           suffixIcon: IconButton(
//             splashRadius: 20,
//             onPressed: () {
//               setState(() {
//                 _obscurePassword = !_obscurePassword;
//               });
//             },
//             icon: Icon(
//               _obscurePassword
//                   ? Icons.visibility_off_outlined
//                   : Icons.visibility_outlined,
//               color: const Color(0xFF9AA2B8),
//               size: 19,
//             ),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 15,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: fieldBorderColor, width: 1),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: fieldBorderColor, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: primaryColor, width: 1.4),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginButton(bool isLoading) {
//     return SizedBox(
//       width: double.infinity,
//       height: 43,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : () => _submitLogin(isLoading),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           disabledBackgroundColor: primaryColor.withOpacity(0.65),
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 width: 21,
//                 height: 21,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : const Text(
//                 'Login',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class _LoginBackgroundPainter extends CustomPainter {
//   const _LoginBackgroundPainter();

//   static const Color topDarkPurple = Color(0xFFBDBCFF);

//   static const Color topLightPurple = Color(0xFFDEDDFF);

//   static const Color bottomDarkPurple = Color(0xFFB6ABF8);

//   static const Color bottomLightPurple = Color(0xFFDFD9FC);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double width = size.width;
//     final double height = size.height;

//     final Paint topDarkPaint = Paint()
//       ..color = topDarkPurple
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     final Paint topLightPaint = Paint()
//       ..color = topLightPurple
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     final Paint bottomDarkPaint = Paint()
//       ..color = bottomDarkPurple
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     final Paint bottomLightPaint = Paint()
//       ..color = bottomLightPurple
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     final Paint whitePaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     // Fill entire background white.
//     canvas.drawRect(Offset.zero & size, whitePaint);

//     // ============================================================
//     // TOP BACKGROUND
//     // ============================================================

//     // Main top purple area.
//     final Path topBackground = Path()
//       ..moveTo(0, 0)
//       ..lineTo(width, 0)
//       ..lineTo(width, height * 0.405)
//       ..cubicTo(
//         width * 0.80,
//         height * 0.350,
//         width * 0.69,
//         height * 0.365,
//         width * 0.54,
//         height * 0.375,
//       )
//       ..cubicTo(
//         width * 0.33,
//         height * 0.390,
//         width * 0.17,
//         height * 0.445,
//         0,
//         height * 0.400,
//       )
//       ..close();

//     canvas.drawPath(topBackground, topDarkPaint);

//     // Large light circular section at the top-right.
//     canvas.drawCircle(
//       Offset(width * 0.88, height * 0.085),
//       width * 0.63,
//       topLightPaint,
//     );

//     // Clip the light circle back inside the top background shape.
//     //
//     // Redraw a translucent top design shape to create the soft
//     // illustration-style layers visible behind the teacher.
//     final Path upperLightShape = Path()
//       ..moveTo(width * 0.35, 0)
//       ..cubicTo(
//         width * 0.16,
//         height * 0.17,
//         width * 0.27,
//         height * 0.30,
//         width * 0.57,
//         height * 0.38,
//       )
//       ..lineTo(width, height * 0.40)
//       ..lineTo(width, 0)
//       ..close();

//     canvas.drawPath(
//       upperLightShape,
//       Paint()
//         ..color = topLightPurple.withOpacity(0.72)
//         ..style = PaintingStyle.fill
//         ..isAntiAlias = true,
//     );

//     // Soft decorative swirl behind the image.
//     final Paint swirlPaint = Paint()
//       ..color = const Color(0xFFD5D3FF)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = width * 0.055
//       ..strokeCap = StrokeCap.round
//       ..isAntiAlias = true;

//     final Path swirl = Path()
//       ..moveTo(width * -0.04, height * 0.16)
//       ..cubicTo(
//         width * 0.32,
//         height * 0.14,
//         width * 0.28,
//         height * 0.30,
//         width * 0.15,
//         height * 0.27,
//       )
//       ..cubicTo(
//         width * 0.04,
//         height * 0.23,
//         width * 0.18,
//         height * 0.17,
//         width * 0.41,
//         height * 0.19,
//       );

//     canvas.drawPath(swirl, swirlPaint);

//     // White curved section over the bottom of the top background.
//     final Path whiteTopCurve = Path()
//       ..moveTo(0, height * 0.395)
//       ..cubicTo(
//         width * 0.18,
//         height * 0.445,
//         width * 0.34,
//         height * 0.385,
//         width * 0.53,
//         height * 0.373,
//       )
//       ..cubicTo(
//         width * 0.72,
//         height * 0.355,
//         width * 0.88,
//         height * 0.350,
//         width,
//         height * 0.400,
//       )
//       ..lineTo(width, height)
//       ..lineTo(0, height)
//       ..close();

//     canvas.drawPath(whiteTopCurve, whitePaint);

//     // ============================================================
//     // BOTTOM WAVES
//     // ============================================================

//     // Light upper wave.
//     final Path bottomLightWave = Path()
//       ..moveTo(0, height * 0.855)
//       ..cubicTo(
//         width * 0.21,
//         height * 0.845,
//         width * 0.45,
//         height * 0.920,
//         width * 0.74,
//         height * 0.915,
//       )
//       ..cubicTo(
//         width * 0.86,
//         height * 0.910,
//         width * 0.95,
//         height * 0.885,
//         width,
//         height * 0.870,
//       )
//       ..lineTo(width, height)
//       ..lineTo(0, height)
//       ..close();

//     canvas.drawPath(bottomLightWave, bottomLightPaint);

//     // Darker lower wave.
//     final Path bottomDarkWave = Path()
//       ..moveTo(0, height * 0.885)
//       ..cubicTo(
//         width * 0.20,
//         height * 0.900,
//         width * 0.43,
//         height * 0.965,
//         width * 0.72,
//         height * 0.970,
//       )
//       ..cubicTo(
//         width * 0.83,
//         height * 0.972,
//         width * 0.93,
//         height * 0.950,
//         width,
//         height * 0.925,
//       )
//       ..lineTo(width, height)
//       ..lineTo(0, height)
//       ..close();

//     canvas.drawPath(bottomDarkWave, bottomDarkPaint);
//   }

//   @override
//   bool shouldRepaint(covariant _LoginBackgroundPainter oldDelegate) {
//     return false;
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/login_parameter.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/teacherDashboard_screen.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color primaryColor = Color(0xFF8079DF);

  static const Color fieldBorderColor = Color(0xFFD9DDF2);

  static const Color fieldTextColor = Color(0xFF929BB7);

  final TextEditingController admissionController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    admissionController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _submitLogin(bool isLoading) {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    if (admissionController.text.trim().isEmpty ||
        dobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    context.read<AuthenticationCubit>().login(
      LoginRequest(
        username: admissionController.text.trim(),
        password: dobController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationSuccess) {
          final pref = SharedPreferenceHelper();

          final loginResponse = state.loginEntity;

          final loginData = loginResponse.data;

          final user = loginData?.user;

          final String token = loginData?.token ?? '';

          if (token.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Token not found')));
            return;
          }

          await pref.setToken(token);
          await pref.saveLoginResponse(loginResponse);

          AppData.employeeId = user?.employeeId;

          AppData.userId = user?.id;

          AppData.teacherName = user!.name;

          debugPrint('===================================');
          debugPrint('APP DATA SAVED');
          debugPrint('Academic Year: ${AppData.accYear}');
          debugPrint('Employee ID: ${AppData.employeeId}');
          debugPrint('User ID: ${AppData.userId}');
          debugPrint('===================================');

          if (!context.mounted) {
            return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TeacherDashboardNewPage()),
          );
        }

        if (state is AuthenticationFailure) {
          debugPrint('errorLogin');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Username Or Password..!')),
          );
        }

        if (state is FetchTutorshipClassFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final bool isLoading =
            state is AuthenticationLoading ||
            state is FetchTutorshipClassLoading;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final double screenHeight = constraints.maxHeight;

              return Stack(
                children: [
                  // Background and waves.
                  const Positioned.fill(
                    child: CustomPaint(painter: _LoginBackgroundPainter()),
                  ),

                  // Teacher image behind the
                  // white foreground curve.
                  Positioned(
                    top: screenHeight * 0.045,
                    left: 25,
                    right: 25,
                    height: screenHeight * 0.355,
                    child: Image.asset(
                      'assets/images/image 67 (1).png',
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          'Login teacher image error: '
                          '$error',
                        );

                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 80,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),

                  // White curved foreground.
                  // This covers the bottom portion
                  // of the teacher image.
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(painter: _LoginForegroundPainter()),
                    ),
                  ),

                  // Login form.
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight -
                              MediaQuery.paddingOf(context).top -
                              MediaQuery.paddingOf(context).bottom,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // Illustration space.
                                SizedBox(height: screenHeight * 0.395),

                                const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF17171A),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 37),

                                _buildUsernameField(),

                                const SizedBox(height: 10),

                                _buildPasswordField(),

                                const Spacer(),

                                _buildLoginButton(isLoading),

                                // Space above waves.
                                SizedBox(height: screenHeight * 0.190),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildUsernameField() {
    return SizedBox(
      height: 51,
      child: TextField(
        controller: admissionController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.username],
        style: const TextStyle(
          color: Color(0xFF282834),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'User Name',
          hintStyle: const TextStyle(
            color: fieldTextColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 13, right: 10),
            child: Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF6548FF),
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 50,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: fieldBorderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: fieldBorderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SizedBox(
      height: 51,
      child: TextField(
        controller: dobController,
        obscureText: _obscurePassword,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        onSubmitted: (_) {
          final AuthenticationState state = context
              .read<AuthenticationCubit>()
              .state;

          final bool isLoading =
              state is AuthenticationLoading ||
              state is FetchTutorshipClassLoading;

          _submitLogin(isLoading);
        },
        style: const TextStyle(
          color: Color(0xFF282834),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: fieldTextColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 13, right: 10),
            child: Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF6548FF),
              size: 19,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 50,
          ),
          suffixIcon: IconButton(
            splashRadius: 20,
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF9AA2B8),
              size: 19,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: fieldBorderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: fieldBorderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 43,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _submitLogin(isLoading),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.65),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// Background layer:
/// purple header, decorative shapes,
/// and bottom waves.
class _LoginBackgroundPainter extends CustomPainter {
  const _LoginBackgroundPainter();

  static const Color topDarkPurple = Color(0xFFBDBCFF);

  static const Color topLightPurple = Color(0xFFDEDDFF);

  static const Color topPatternPurple = Color(0xFFD5D3FF);

  static const Color bottomDarkPurple = Color(0xFFB6ABF8);

  static const Color bottomLightPurple = Color(0xFFDFD9FC);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint topDarkPaint = Paint()
      ..color = topDarkPurple
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint topLightPaint = Paint()
      ..color = topLightPurple
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint bottomLightPaint = Paint()
      ..color = bottomLightPurple
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint bottomDarkPaint = Paint()
      ..color = bottomDarkPurple
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // White page.
    canvas.drawRect(Offset.zero & size, whitePaint);

    // Main top purple section.
    final Path topArea = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height * 0.405)
      ..cubicTo(
        width * 0.84,
        height * 0.365,
        width * 0.70,
        height * 0.362,
        width * 0.53,
        height * 0.375,
      )
      ..cubicTo(
        width * 0.34,
        height * 0.390,
        width * 0.18,
        height * 0.440,
        0,
        height * 0.400,
      )
      ..close();

    canvas.drawPath(topArea, topDarkPaint);

    canvas.save();
    canvas.clipPath(topArea);

    // Large light-purple circle.
    canvas.drawCircle(
      Offset(width * 0.87, height * 0.105),
      width * 0.63,
      topLightPaint,
    );

    // Light diagonal top area.
    final Path diagonalLightShape = Path()
      ..moveTo(width * 0.35, 0)
      ..cubicTo(
        width * 0.23,
        height * 0.12,
        width * 0.24,
        height * 0.25,
        width * 0.42,
        height * 0.34,
      )
      ..cubicTo(
        width * 0.55,
        height * 0.40,
        width * 0.79,
        height * 0.40,
        width,
        height * 0.40,
      )
      ..lineTo(width, 0)
      ..close();

    canvas.drawPath(
      diagonalLightShape,
      Paint()
        ..color = const Color(0xFFE2E1FF)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );

    // Background swirl.
    final Paint swirlPaint = Paint()
      ..color = topPatternPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.060
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final Path swirlPath = Path()
      ..moveTo(width * -0.08, height * 0.155)
      ..cubicTo(
        width * 0.20,
        height * 0.145,
        width * 0.32,
        height * 0.180,
        width * 0.27,
        height * 0.235,
      )
      ..cubicTo(
        width * 0.23,
        height * 0.285,
        width * 0.10,
        height * 0.285,
        width * 0.09,
        height * 0.235,
      )
      ..cubicTo(
        width * 0.08,
        height * 0.185,
        width * 0.20,
        height * 0.165,
        width * 0.39,
        height * 0.190,
      );

    canvas.drawPath(swirlPath, swirlPaint);

    // Right decorative curve.
    final Paint rightPatternPaint = Paint()
      ..color = const Color(0xFFE6E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.027
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final Path rightPattern = Path()
      ..moveTo(width * 0.58, height * 0.145)
      ..cubicTo(
        width * 0.79,
        height * 0.125,
        width * 0.97,
        height * 0.155,
        width * 1.08,
        height * 0.225,
      );

    canvas.drawPath(rightPattern, rightPatternPaint);

    canvas.restore();

    // Light upper bottom wave.
    final Path lightBottomWave = Path()
      ..moveTo(0, height * 0.857)
      ..cubicTo(
        width * 0.19,
        height * 0.842,
        width * 0.43,
        height * 0.900,
        width * 0.66,
        height * 0.912,
      )
      ..cubicTo(
        width * 0.79,
        height * 0.920,
        width * 0.92,
        height * 0.893,
        width,
        height * 0.872,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    canvas.drawPath(lightBottomWave, bottomLightPaint);

    // Darker bottom wave.
    final Path darkBottomWave = Path()
      ..moveTo(0, height * 0.885)
      ..cubicTo(
        width * 0.19,
        height * 0.896,
        width * 0.40,
        height * 0.949,
        width * 0.65,
        height * 0.968,
      )
      ..cubicTo(
        width * 0.79,
        height * 0.981,
        width * 0.93,
        height * 0.957,
        width,
        height * 0.932,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    canvas.drawPath(darkBottomWave, bottomDarkPaint);
  }

  @override
  bool shouldRepaint(covariant _LoginBackgroundPainter oldDelegate) {
    return false;
  }
}

/// Foreground white curve.
/// Drawn after the image so the teacher's
/// lower body is hidden behind the curve.
class _LoginForegroundPainter extends CustomPainter {
  const _LoginForegroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Path whiteForeground = Path()
      ..moveTo(0, height * 0.395)
      ..cubicTo(
        width * 0.15,
        height * 0.435,
        width * 0.28,
        height * 0.405,
        width * 0.43,
        height * 0.382,
      )
      ..cubicTo(
        width * 0.60,
        height * 0.356,
        width * 0.82,
        height * 0.345,
        width,
        height * 0.400,
      )
      ..lineTo(width, height * 0.855)
      ..cubicTo(
        width * 0.78,
        height * 0.915,
        width * 0.47,
        height * 0.895,
        0,
        height * 0.855,
      )
      ..close();

    canvas.drawPath(whiteForeground, whitePaint);
  }

  @override
  bool shouldRepaint(covariant _LoginForegroundPainter oldDelegate) {
    return false;
  }
}
