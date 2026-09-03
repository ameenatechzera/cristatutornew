// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
// import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
// import 'package:cristalteacher/features/materials/presentation/screens/materials_expansion_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MaterialsScreen extends StatefulWidget {
//   MaterialsScreen({super.key});

//   @override
//   State<MaterialsScreen> createState() => _MaterialsScreenState();
// }

// class _MaterialsScreenState extends State<MaterialsScreen> {
//   @override
//   void initState() {
//     super.initState();

//     context.read<AuthenticationCubit>().fetchTutorshipClass(
//       FetchTutorshipClassRequest(
//         accyear: AppData.accYear,
//         employeeId: AppData.employeeId,
//         userId: AppData.userId,
//       ),
//     );
//   }

//   Map<String, dynamic> getSubjectStyle(String name) {
//     switch (name.toLowerCase()) {
//       case "maths":
//         return {
//           "icon": "assets/icons/mathsicon.png",
//           "color": const Color(0xFFFFF3C4),
//         };

//       case "physics":
//         return {
//           "icon": "assets/icons/physics_icon.png",
//           "color": const Color(0xFFDDF5C9),
//         };

//       // case "chemistry":
//       //   return {
//       //     "icon": "assets/icons/chemistry_icon.png",
//       //     "color": const Color(0xFFD4F5D0),
//       //   };

//       // case "english":
//       //   return {
//       //     "icon": "assets/icons/english_icon.png",
//       //     "color": const Color(0xFFD6EAF8),
//       //   };

//       // case "gk":
//       //   return {
//       //     "icon": "assets/icons/chemistry_icon.png",
//       //     "color": const Color(0xFFCFEEFF),
//       //   };

//       // case "arabic":
//       //   return {
//       //     "icon": "assets/icons/chemistry_icon.png",
//       //     "color": const Color(0xFFCFEEFF),
//       //   };

//       default:
//         return {
//           "icon": "assets/icons/physics_icon.png",
//           "color": const Color(0xFFF8D7EC),
//         };
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEDEDED),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFFEDEDED),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Subject",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
//         builder: (context, state) {
//           if (state is FetchTutorshipClassLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is FetchTutorshipClassFailure) {
//             return Center(child: Text(state.message));
//           }

//           if (state is FetchTutorshipClassSuccess) {
//             final subjects =
//                 state
//                     .response
//                     .data
//                     ?.tutorshipClass
//                     ?.first
//                     .division
//                     ?.first
//                     .subject ??
//                 [];

//             if (subjects.isEmpty) {
//               return const Center(child: Text("No subjects found"));
//             }

//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: subjects.length,
//               itemBuilder: (context, index) {
//                 final subject = subjects[index];

//                 final style = getSubjectStyle(subject.subject ?? "");

//                 return InkWell(
//                   borderRadius: BorderRadius.circular(16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => MaterialsExpansionScreen(
//                           subjectId: subject.subjectId,
//                           subjectName: subject.subject ?? "",
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                             color: style["color"] as Color,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Image.asset(
//                               style["icon"] as String,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Text(
//                             subject.subject ?? "",
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/materials/presentation/screens/materials_expansion_screen.dart';
import 'package:flutter/material.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  Map<String, dynamic> getSubjectStyle(String name) {
    switch (name.toLowerCase()) {
      case "maths":
        return {
          "icon": "assets/icons/mathsicon.png",
          "color": const Color(0xFFFFF3C4),
        };

      case "physics":
        return {
          "icon": "assets/icons/physics_icon.png",
          "color": const Color(0xFFDDF5C9),
        };

      default:
        return {
          "icon": "assets/icons/physics_icon.png",
          "color": const Color(0xFFF8D7EC),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = AppData.tutorshipClasses.isNotEmpty
        ? AppData.tutorshipClasses.first.division?.isNotEmpty == true
              ? AppData.tutorshipClasses.first.division!.first.subject ?? []
              : []
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFEDEDED),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Subject",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: subjects.isEmpty
          ? const Center(child: Text("No subjects found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final style = getSubjectStyle(subject.subject ?? "");

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MaterialsExpansionScreen(
                          subjectId: subject.subjectId,
                          subjectName: subject.subject ?? "",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: style["color"] as Color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              style["icon"] as String,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            subject.subject ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
