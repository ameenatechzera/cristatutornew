// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
// import 'package:cristalteacher/features/attendance/presentation/screens/studentattendance_screen.dart';
// import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
// import 'package:flutter/material.dart';

// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});

//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   final TextEditingController narrationController = TextEditingController();

//   DateTime selectedDate = DateTime.now();

//   List<TutorshipClass> standards = [];
//   List<DivisionDetails> divisions = [];

//   int? selectedStandardId;
//   int? selectedDivisionId;

//   String? selectedStandard;
//   String? selectedDivision;

//   String selectedSection = 'Morning';

//   final List<String> sections = ['Morning', 'Evening'];

//   @override
//   void initState() {
//     super.initState();

//     standards = List<TutorshipClass>.from(AppData.standards);

//     if (standards.isNotEmpty) {
//       TutorshipClass? firstStandard;
//       DivisionDetails? firstDivision;

//       for (final standard in standards) {
//         final List<DivisionDetails> standardDivisions = standard.division ?? [];

//         if (standardDivisions.isNotEmpty) {
//           firstStandard = standard;
//           firstDivision = standardDivisions.first;
//           break;
//         }
//       }

//       if (firstStandard != null && firstDivision != null) {
//         selectedStandardId = firstStandard.standardId;
//         selectedStandard = firstStandard.standard;

//         divisions = List<DivisionDetails>.from(firstStandard.division ?? []);

//         selectedDivisionId = firstDivision.divisionId;
//         selectedDivision = firstDivision.division;
//       }
//     }
//   }

//   @override
//   void dispose() {
//     narrationController.dispose();
//     super.dispose();
//   }

//   void _selectStandard(int? standardId) {
//     if (standardId == null) {
//       return;
//     }

//     TutorshipClass? selectedItem;

//     for (final standard in standards) {
//       if (standard.standardId == standardId) {
//         selectedItem = standard;
//         break;
//       }
//     }

//     if (selectedItem == null) {
//       return;
//     }

//     final List<DivisionDetails> newDivisions = selectedItem.division ?? [];

//     setState(() {
//       selectedStandardId = selectedItem!.standardId;
//       selectedStandard = selectedItem.standard;

//       divisions = newDivisions;

//       if (newDivisions.isNotEmpty) {
//         selectedDivisionId = newDivisions.first.divisionId;
//         selectedDivision = newDivisions.first.division;
//       } else {
//         selectedDivisionId = null;
//         selectedDivision = null;
//       }
//     });
//   }

//   void _selectDivision(int? divisionId) {
//     if (divisionId == null) {
//       return;
//     }

//     DivisionDetails? selectedItem;

//     for (final division in divisions) {
//       if (division.divisionId == divisionId) {
//         selectedItem = division;
//         break;
//       }
//     }

//     if (selectedItem == null) {
//       return;
//     }

//     setState(() {
//       selectedDivisionId = selectedItem!.divisionId;
//       selectedDivision = selectedItem.division;
//     });
//   }

//   String formatDisplayDate(DateTime date) {
//     final String day = date.day.toString().padLeft(2, '0');
//     final String month = date.month.toString().padLeft(2, '0');
//     final String year = date.year.toString();

//     return '$day/$month/$year';
//   }

//   String formatApiDate(DateTime date) {
//     final String year = date.year.toString();
//     final String month = date.month.toString().padLeft(2, '0');
//     final String day = date.day.toString().padLeft(2, '0');

//     return '$year-$month-$day';
//   }

//   Future<void> selectDate() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2035),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF9B7ADC),
//               onPrimary: Colors.white,
//               onSurface: Color(0xFF222222),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (pickedDate == null || !mounted) {
//       return;
//     }

//     setState(() {
//       selectedDate = pickedDate;
//     });
//   }

//   void _startAttendance() {
//     final String? accYear = AppData.accYear;

//     if (accYear == null || accYear.trim().isEmpty) {
//       _showMessage('Academic year is not available');
//       return;
//     }

//     if (selectedStandardId == null) {
//       _showMessage('Please select a standard');
//       return;
//     }

//     if (selectedDivisionId == null) {
//       _showMessage('Please select a division');
//       return;
//     }

//     debugPrint('==========================================');
//     debugPrint('📘 START ATTENDANCE');
//     debugPrint('Academic Year: $accYear');
//     debugPrint(
//       'Standard: $selectedStandard '
//       '($selectedStandardId)',
//     );
//     debugPrint(
//       'Division: $selectedDivision '
//       '($selectedDivisionId)',
//     );
//     debugPrint('Section: $selectedSection');
//     debugPrint('Attendance Date: ${formatApiDate(selectedDate)}');
//     debugPrint('Narration: ${narrationController.text.trim()}');
//     debugPrint('==========================================');

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) {
//           return StudentAttendanceScreen(
//             attendanceDate: selectedDate,
//             standardId: selectedStandardId ?? 0,
//             standard: selectedStandard ?? '',
//             divisionId: selectedDivisionId!,
//             division: selectedDivision ?? '',
//             section: selectedSection,
//             narration: narrationController.text.trim(),
//           );
//         },
//       ),
//     );
//   }

//   void _showMessage(String message) {
//     if (!mounted) {
//       return;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Attendance',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF111111),
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.maybePop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             size: 27,
//             color: Color(0xFF222222),
//           ),
//         ),
//       ),
//       body: SafeArea(top: false, child: _buildContent()),
//     );
//   }

//   Widget _buildContent() {
//     return SingleChildScrollView(
//       keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//       padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildDateField(),
//           const SizedBox(height: 22),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildStandardDropdown()),
//               const SizedBox(width: 16),
//               Expanded(child: _buildDivisionDropdown()),
//             ],
//           ),
//           const SizedBox(height: 22),
//           _buildSectionDropdown(),
//           const SizedBox(height: 28),
//           _buildNarrationField(),
//           const SizedBox(height: 26),
//           SizedBox(
//             width: double.infinity,
//             height: 62,
//             child: ElevatedButton(
//               onPressed:
//                   selectedStandardId == null || selectedDivisionId == null
//                   ? null
//                   : _startAttendance,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF9B7ADC),
//                 disabledBackgroundColor: const Color(0xFFD1C7E7),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Start Attendance',
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 6, bottom: 10),
//           child: Text(
//             'Date',
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF333333),
//             ),
//           ),
//         ),
//         Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: selectDate,
//             borderRadius: BorderRadius.circular(26),
//             child: Container(
//               width: double.infinity,
//               height: 72,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF4F4F5),
//                 borderRadius: BorderRadius.circular(26),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       formatDisplayDate(selectedDate),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFF252525),
//                       ),
//                     ),
//                   ),
//                   const Icon(
//                     Icons.calendar_month_rounded,
//                     size: 22,
//                     color: Color(0xFF66686C),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget _buildStandardDropdown() {
//   //   return _buildDropdownContainer(
//   //     label: 'Standard',
//   //     child: DropdownButtonHideUnderline(
//   //       child: DropdownButton<int>(
//   //         value: selectedStandardId,
//   //         isExpanded: true,
//   //         elevation: 4,
//   //         borderRadius: BorderRadius.circular(18),
//   //         dropdownColor: Colors.white,
//   //         hint: const Text(
//   //           'Select',
//   //           style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
//   //         ),
//   //         icon: const Icon(
//   //           Icons.keyboard_arrow_down_rounded,
//   //           size: 25,
//   //           color: Color(0xFF74777D),
//   //         ),
//   //         style: const TextStyle(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.w400,
//   //           color: Color(0xFF252525),
//   //         ),
//   //         items: standards.map((standard) {
//   //           return DropdownMenuItem<int>(
//   //             value: standard.standardId,
//   //             child: Text(
//   //               standard.standard ?? '',
//   //               style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//   //             ),
//   //           );
//   //         }).toList(),
//   //         onChanged: standards.isEmpty ? null : _selectStandard,
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildDivisionDropdown() {
//   //   return _buildDropdownContainer(
//   //     label: 'Division',
//   //     child: DropdownButtonHideUnderline(
//   //       child: DropdownButton<int>(
//   //         value: selectedDivisionId,
//   //         isExpanded: true,
//   //         elevation: 4,
//   //         borderRadius: BorderRadius.circular(18),
//   //         dropdownColor: Colors.white,
//   //         hint: const Text(
//   //           'Select',
//   //           style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
//   //         ),
//   //         icon: const Icon(
//   //           Icons.keyboard_arrow_down_rounded,
//   //           size: 25,
//   //           color: Color(0xFF74777D),
//   //         ),
//   //         style: const TextStyle(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.w400,
//   //           color: Color(0xFF252525),
//   //         ),
//   //         items: divisions.map((division) {
//   //           return DropdownMenuItem<int>(
//   //             value: division.divisionId,
//   //             child: Text(
//   //               division.division ?? '',
//   //               style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//   //             ),
//   //           );
//   //         }).toList(),
//   //         onChanged: divisions.isEmpty ? null : _selectDivision,
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget _buildStandardDropdown() {
//     final List<DropdownMenuItem<int>> items = standards.map((standard) {
//       return DropdownMenuItem<int>(
//         value: standard.standardId,
//         child: Text(
//           standard.standard ?? '',
//           style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//         ),
//       );
//     }).toList();

//     final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
//       items,
//       selectedStandardId,
//     );

//     return _buildDropdownContainer(
//       label: 'Standard',
//       child: InkWell(
//         onTap: items.isEmpty
//             ? null
//             : () async {
//                 final PickerSelection<int>? result =
//                     await showOptionPickerSheet<int>(
//                       context: context,
//                       title: 'Select Standard',
//                       items: items,
//                       selectedValue: selectedStandardId,
//                     );

//                 if (!mounted || result == null) {
//                   return;
//                 }

//                 _selectStandard(result.value);
//               },
//         child: Row(
//           children: [
//             Expanded(
//               child:
//                   selectedItem?.child ??
//                   const Text(
//                     'Select',
//                     style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
//                   ),
//             ),
//             const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               size: 25,
//               color: Color(0xFF74777D),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDivisionDropdown() {
//     final List<DropdownMenuItem<int>> items = divisions.map((division) {
//       return DropdownMenuItem<int>(
//         value: division.divisionId,
//         child: Text(
//           division.division ?? '',
//           style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//         ),
//       );
//     }).toList();

//     final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
//       items,
//       selectedDivisionId,
//     );

//     return _buildDropdownContainer(
//       label: 'Division',
//       child: InkWell(
//         onTap: items.isEmpty
//             ? null
//             : () async {
//                 final PickerSelection<int>? result =
//                     await showOptionPickerSheet<int>(
//                       context: context,
//                       title: 'Select Division',
//                       items: items,
//                       selectedValue: selectedDivisionId,
//                     );

//                 if (!mounted || result == null) {
//                   return;
//                 }

//                 _selectDivision(result.value);
//               },
//         child: Row(
//           children: [
//             Expanded(
//               child:
//                   selectedItem?.child ??
//                   const Text(
//                     'Select',
//                     style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
//                   ),
//             ),
//             const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               size: 25,
//               color: Color(0xFF74777D),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionDropdown() {
//     final List<DropdownMenuItem<String>> items = sections.map((section) {
//       return DropdownMenuItem<String>(
//         value: section,
//         child: Text(
//           section,
//           style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//         ),
//       );
//     }).toList();

//     final DropdownMenuItem<String>? selectedItem = selectedItemOf<String>(
//       items,
//       selectedSection,
//     );

//     return _buildDropdownContainer(
//       label: 'Section',
//       child: InkWell(
//         onTap: items.isEmpty
//             ? null
//             : () async {
//                 final PickerSelection<String>? result =
//                     await showOptionPickerSheet<String>(
//                       context: context,
//                       title: 'Select Section',
//                       items: items,
//                       selectedValue: selectedSection,
//                     );

//                 if (!mounted || result == null || result.value == null) {
//                   return;
//                 }

//                 setState(() {
//                   selectedSection = result.value!;
//                 });
//               },
//         child: Row(
//           children: [
//             Expanded(
//               child:
//                   selectedItem?.child ??
//                   const Text(
//                     'Select',
//                     style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
//                   ),
//             ),
//             const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               size: 25,
//               color: Color(0xFF74777D),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildSectionDropdown() {
//   //   return _buildDropdownContainer(
//   //     label: 'Section',
//   //     child: DropdownButtonHideUnderline(
//   //       child: DropdownButton<String>(
//   //         value: selectedSection,
//   //         isExpanded: true,
//   //         elevation: 4,
//   //         borderRadius: BorderRadius.circular(18),
//   //         dropdownColor: Colors.white,
//   //         icon: const Icon(
//   //           Icons.keyboard_arrow_down_rounded,
//   //           size: 25,
//   //           color: Color(0xFF74777D),
//   //         ),
//   //         style: const TextStyle(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.w400,
//   //           color: Color(0xFF252525),
//   //         ),
//   //         items: sections.map((section) {
//   //           return DropdownMenuItem<String>(
//   //             value: section,
//   //             child: Text(
//   //               section,
//   //               style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//   //             ),
//   //           );
//   //         }).toList(),
//   //         onChanged: (value) {
//   //           if (value == null) {
//   //             return;
//   //           }

//   //           setState(() {
//   //             selectedSection = value;
//   //           });
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildDropdownContainer({
//     required String label,
//     required Widget child,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 6, bottom: 10),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF333333),
//             ),
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           height: 68,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF3F3F5),
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: child,
//         ),
//       ],
//     );
//   }

//   Widget _buildNarrationField() {
//     return Container(
//       width: double.infinity,
//       height: 155,
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F3F5),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: TextField(
//         controller: narrationController,
//         maxLines: null,
//         minLines: null,
//         expands: true,
//         keyboardType: TextInputType.multiline,
//         textInputAction: TextInputAction.newline,
//         textAlignVertical: TextAlignVertical.top,
//         style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
//         decoration: const InputDecoration(
//           hintText: 'Narration',
//           hintStyle: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF333333),
//           ),
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           isCollapsed: true,
//           contentPadding: EdgeInsets.zero,
//         ),
//       ),
//     );
//   }
// }
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/custom_dropdown_field.dart';
import 'package:cristalteacher/features/attendance/presentation/screens/studentattendance_screen.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController narrationController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  /// The teacher's own classes, exactly as they come from AppData. One
  /// entry per standard/division pair, so a standard can appear more
  /// than once.
  List<TutorshipClass> tutorshipClasses = [];

  /// The same classes, one row per standard. This is what the Standard
  /// dropdown lists.
  List<TutorshipClass> standards = [];

  List<DivisionDetails> divisions = [];

  int? selectedStandardId;
  int? selectedDivisionId;

  String? selectedStandard;
  String? selectedDivision;

  String selectedSection = 'Morning';

  final List<String> sections = ['Morning', 'Evening'];

  @override
  void initState() {
    super.initState();

    // Only the classes assigned to this teacher.
    tutorshipClasses = List<TutorshipClass>.from(AppData.tutorshipClasses);

    standards = _uniqueStandards();

    if (standards.isNotEmpty) {
      TutorshipClass? firstStandard;
      DivisionDetails? firstDivision;

      List<DivisionDetails> firstDivisions = [];

      for (final standard in standards) {
        final List<DivisionDetails> standardDivisions = _divisionsFor(
          standard.standardId,
        );

        if (standardDivisions.isNotEmpty) {
          firstStandard = standard;
          firstDivisions = standardDivisions;
          firstDivision = standardDivisions.first;
          break;
        }
      }

      if (firstStandard != null && firstDivision != null) {
        selectedStandardId = firstStandard.standardId;
        selectedStandard = firstStandard.standard;

        divisions = firstDivisions;

        selectedDivisionId = firstDivision.divisionId;
        selectedDivision = firstDivision.division;
      }
    }
  }

  /// One row per standard. The class list repeats a standard for every
  /// division it holds, so the dropdown has to be deduplicated.
  List<TutorshipClass> _uniqueStandards() {
    final Map<int, TutorshipClass> unique = {};

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId != null) {
        unique.putIfAbsent(item.standardId!, () => item);
      }
    }

    return unique.values.toList();
  }

  /// Every division of [standardId], merged across all entries that carry
  /// that standard and deduplicated by division id.
  List<DivisionDetails> _divisionsFor(int? standardId) {
    if (standardId == null) {
      return <DivisionDetails>[];
    }

    final Map<int, DivisionDetails> unique = {};

    for (final TutorshipClass item in tutorshipClasses) {
      if (item.standardId != standardId) {
        continue;
      }

      for (final DivisionDetails division
          in item.division ?? const <DivisionDetails>[]) {
        if (division.divisionId != null) {
          unique.putIfAbsent(division.divisionId!, () => division);
        }
      }
    }

    return unique.values.toList();
  }

  @override
  void dispose() {
    narrationController.dispose();
    super.dispose();
  }

  void _selectStandard(int? standardId) {
    if (standardId == null) {
      return;
    }

    TutorshipClass? selectedItem;

    for (final standard in standards) {
      if (standard.standardId == standardId) {
        selectedItem = standard;
        break;
      }
    }

    if (selectedItem == null) {
      return;
    }

    final List<DivisionDetails> newDivisions = _divisionsFor(standardId);

    setState(() {
      selectedStandardId = selectedItem!.standardId;
      selectedStandard = selectedItem.standard;

      divisions = newDivisions;

      if (newDivisions.isNotEmpty) {
        selectedDivisionId = newDivisions.first.divisionId;
        selectedDivision = newDivisions.first.division;
      } else {
        selectedDivisionId = null;
        selectedDivision = null;
      }
    });
  }

  void _selectDivision(int? divisionId) {
    if (divisionId == null) {
      return;
    }

    DivisionDetails? selectedItem;

    for (final division in divisions) {
      if (division.divisionId == divisionId) {
        selectedItem = division;
        break;
      }
    }

    if (selectedItem == null) {
      return;
    }

    setState(() {
      selectedDivisionId = selectedItem!.divisionId;
      selectedDivision = selectedItem.division;
    });
  }

  String formatDisplayDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();

    return '$day/$month/$year';
  }

  String formatApiDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9B7ADC),
              onPrimary: Colors.white,
              onSurface: Color(0xFF222222),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _startAttendance() {
    final String? accYear = AppData.accYear;

    if (accYear == null || accYear.trim().isEmpty) {
      _showMessage('Academic year is not available');
      return;
    }

    if (selectedStandardId == null) {
      _showMessage('Please select a standard');
      return;
    }

    if (selectedDivisionId == null) {
      _showMessage('Please select a division');
      return;
    }

    debugPrint('==========================================');
    debugPrint('📘 START ATTENDANCE');
    debugPrint('Academic Year: $accYear');
    debugPrint(
      'Standard: $selectedStandard '
      '($selectedStandardId)',
    );
    debugPrint(
      'Division: $selectedDivision '
      '($selectedDivisionId)',
    );
    debugPrint('Section: $selectedSection');
    debugPrint('Attendance Date: ${formatApiDate(selectedDate)}');
    debugPrint('Narration: ${narrationController.text.trim()}');
    debugPrint('==========================================');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return StudentAttendanceScreen(
            attendanceDate: selectedDate,
            standardId: selectedStandardId ?? 0,
            standard: selectedStandard ?? '',
            divisionId: selectedDivisionId!,
            division: selectedDivision ?? '',
            section: selectedSection,
            narration: narrationController.text.trim(),
          );
        },
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Attendance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 27,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: SafeArea(top: false, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateField(),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildStandardDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildDivisionDropdown()),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionDropdown(),
          const SizedBox(height: 28),
          _buildNarrationField(),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            height: 62,
            child: ElevatedButton(
              onPressed:
                  selectedStandardId == null || selectedDivisionId == null
                  ? null
                  : _startAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B7ADC),
                disabledBackgroundColor: const Color(0xFFD1C7E7),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Start Attendance',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            'Date',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: selectDate,
            borderRadius: BorderRadius.circular(26),
            child: Container(
              width: double.infinity,
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatDisplayDate(selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF252525),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month_rounded,
                    size: 22,
                    color: Color(0xFF66686C),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildStandardDropdown() {
  //   return _buildDropdownContainer(
  //     label: 'Standard',
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<int>(
  //         value: selectedStandardId,
  //         isExpanded: true,
  //         elevation: 4,
  //         borderRadius: BorderRadius.circular(18),
  //         dropdownColor: Colors.white,
  //         hint: const Text(
  //           'Select',
  //           style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
  //         ),
  //         icon: const Icon(
  //           Icons.keyboard_arrow_down_rounded,
  //           size: 25,
  //           color: Color(0xFF74777D),
  //         ),
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w400,
  //           color: Color(0xFF252525),
  //         ),
  //         items: standards.map((standard) {
  //           return DropdownMenuItem<int>(
  //             value: standard.standardId,
  //             child: Text(
  //               standard.standard ?? '',
  //               style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: standards.isEmpty ? null : _selectStandard,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDivisionDropdown() {
  //   return _buildDropdownContainer(
  //     label: 'Division',
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<int>(
  //         value: selectedDivisionId,
  //         isExpanded: true,
  //         elevation: 4,
  //         borderRadius: BorderRadius.circular(18),
  //         dropdownColor: Colors.white,
  //         hint: const Text(
  //           'Select',
  //           style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
  //         ),
  //         icon: const Icon(
  //           Icons.keyboard_arrow_down_rounded,
  //           size: 25,
  //           color: Color(0xFF74777D),
  //         ),
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w400,
  //           color: Color(0xFF252525),
  //         ),
  //         items: divisions.map((division) {
  //           return DropdownMenuItem<int>(
  //             value: division.divisionId,
  //             child: Text(
  //               division.division ?? '',
  //               style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: divisions.isEmpty ? null : _selectDivision,
  //       ),
  //     ),
  //   );
  // }
  Widget _buildStandardDropdown() {
    final List<DropdownMenuItem<int>> items = standards.map((standard) {
      return DropdownMenuItem<int>(
        value: standard.standardId,
        child: Text(
          standard.standard ?? '',
          style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
        ),
      );
    }).toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedStandardId,
    );

    return _buildDropdownContainer(
      label: 'Standard',
      child: InkWell(
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

                _selectStandard(result.value);
              },
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  const Text(
                    'Select',
                    style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 25,
              color: Color(0xFF74777D),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivisionDropdown() {
    final List<DropdownMenuItem<int>> items = divisions.map((division) {
      return DropdownMenuItem<int>(
        value: division.divisionId,
        child: Text(
          division.division ?? '',
          style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
        ),
      );
    }).toList();

    final DropdownMenuItem<int>? selectedItem = selectedItemOf<int>(
      items,
      selectedDivisionId,
    );

    return _buildDropdownContainer(
      label: 'Division',
      child: InkWell(
        onTap: items.isEmpty
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

                _selectDivision(result.value);
              },
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  const Text(
                    'Select',
                    style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 25,
              color: Color(0xFF74777D),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDropdown() {
    final List<DropdownMenuItem<String>> items = sections.map((section) {
      return DropdownMenuItem<String>(
        value: section,
        child: Text(
          section,
          style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
        ),
      );
    }).toList();

    final DropdownMenuItem<String>? selectedItem = selectedItemOf<String>(
      items,
      selectedSection,
    );

    return _buildDropdownContainer(
      label: 'Section',
      child: InkWell(
        onTap: items.isEmpty
            ? null
            : () async {
                final PickerSelection<String>? result =
                    await showOptionPickerSheet<String>(
                      context: context,
                      title: 'Select Section',
                      items: items,
                      selectedValue: selectedSection,
                    );

                if (!mounted || result == null || result.value == null) {
                  return;
                }

                setState(() {
                  selectedSection = result.value!;
                });
              },
        child: Row(
          children: [
            Expanded(
              child:
                  selectedItem?.child ??
                  const Text(
                    'Select',
                    style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 25,
              color: Color(0xFF74777D),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSectionDropdown() {
  //   return _buildDropdownContainer(
  //     label: 'Section',
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         value: selectedSection,
  //         isExpanded: true,
  //         elevation: 4,
  //         borderRadius: BorderRadius.circular(18),
  //         dropdownColor: Colors.white,
  //         icon: const Icon(
  //           Icons.keyboard_arrow_down_rounded,
  //           size: 25,
  //           color: Color(0xFF74777D),
  //         ),
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w400,
  //           color: Color(0xFF252525),
  //         ),
  //         items: sections.map((section) {
  //           return DropdownMenuItem<String>(
  //             value: section,
  //             child: Text(
  //               section,
  //               style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           if (value == null) {
  //             return;
  //           }

  //           setState(() {
  //             selectedSection = value;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDropdownContainer({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildNarrationField() {
    return Container(
      width: double.infinity,
      height: 155,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: narrationController,
        maxLines: null,
        minLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontSize: 14, color: Color(0xFF252525)),
        decoration: const InputDecoration(
          hintText: 'Narration',
          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
