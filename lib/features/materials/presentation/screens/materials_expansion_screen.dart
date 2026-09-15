import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/date_utils_helper.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/entities/fetch_material_entity.dart';
import 'package:cristalteacher/features/materials/domain/parameter/fetch_material_parameter.dart';
import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
import 'package:cristalteacher/features/materials/presentation/screens/addmaterials_screen.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class MaterialsExpansionScreen extends StatefulWidget {
  final int? subjectId;
  final String subjectName;

  /// Optional pre-selection. When omitted the screen falls back to the
  /// first standard / division available in AppData.
  final int? standardId;
  final int? divisionId;

  const MaterialsExpansionScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    this.standardId,
    this.divisionId,
  });

  @override
  State<MaterialsExpansionScreen> createState() => _MaterialsExpansionScreen();
}

class _MaterialsExpansionScreen extends State<MaterialsExpansionScreen> {
  int selectedTab = 0;

  /// Selected class. Both are required by FetchMaterialParameter, so the
  /// list is only fetched once each has a value.
  int? selectedStandardId;
  int? selectedDivisionId;

  final List<String> tabs = ["Documents", "Links", "Notes"];

  final Color primaryColor = const Color(0xFF9B73E6);
  final Color darkColor = const Color(0xFF202020);
  final Color bgColor = const Color(0xFFFCFAFF);
  final Color cardColor = const Color(0xFFF5F2FF);
  final Color fieldColor = const Color(0xFFF5F2FF);

  /// Every standard in the school, as already cached by login.
  List<TutorshipClass> get _standards => AppData.standards;

  /// Divisions belonging to the currently selected standard.
  List<DivisionDetails> get _divisions {
    for (final TutorshipClass standard in _standards) {
      if (standard.standardId == selectedStandardId) {
        return (standard.division ?? <DivisionDetails>[])
            .where((division) => division.divisionId != null)
            .toList();
      }
    }

    return <DivisionDetails>[];
  }

  /// Standards that can actually be shown: they need an id and a name.
  List<TutorshipClass> get _validStandards {
    return _standards.where((standard) {
      final bool hasId = standard.standardId != null;
      final bool hasName = standard.standard?.trim().isNotEmpty ?? false;

      return hasId && hasName;
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    selectedStandardId = widget.standardId;
    selectedDivisionId = widget.divisionId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _applyDefaultSelection();
      _fetchMaterials();
    });
  }

  /// Picks the first standard that has at least one division, so the screen
  /// opens with a real class instead of two empty dropdowns.
  void _applyDefaultSelection() {
    if (selectedStandardId != null && selectedDivisionId != null) {
      return;
    }

    for (final TutorshipClass standard in _validStandards) {
      final List<DivisionDetails> divisions =
          (standard.division ?? <DivisionDetails>[])
              .where((division) => division.divisionId != null)
              .toList();

      if (divisions.isEmpty) continue;

      setState(() {
        selectedStandardId ??= standard.standardId;
        selectedDivisionId ??= divisions.first.divisionId;
      });

      return;
    }
  }

  void _fetchMaterials() {
    if (!mounted) return;

    final int? subjectId = widget.subjectId;
    final String? accYear = AppData.accYear;

    // Every one of these is required by the API. Bailing out with a message
    // beats sending nulls and getting an empty list back.
    if (subjectId == null) {
      _showMessage('Subject is not available');
      return;
    }

    if (accYear == null) {
      _showMessage('Academic year is not available');
      return;
    }

    if (selectedStandardId == null || selectedDivisionId == null) {
      debugPrint('FETCH MATERIALS SKIPPED — standard or division not selected');
      return;
    }

    final String currentDate = DateUtilsHelper.getCurrentDate();

    final FetchMaterialParameter parameter = FetchMaterialParameter(
      subjectId: subjectId,
      accYear: accYear,
      branchId: AppData.branchId ?? 1,
      fromDate: currentDate,
      toDate: currentDate,
      staffId: null,
      standardId: selectedStandardId!,
      divisionId: selectedDivisionId!,
    );

    debugPrint('====================================');
    debugPrint('FETCH MATERIALS');
    debugPrint('Request: ${parameter.toJson()}');
    debugPrint('====================================');

    context.read<MaterialCubit>().fetchMaterials(parameter);
  }

  void _onStandardChanged(int? standardId) {
    if (standardId == null || standardId == selectedStandardId) return;

    setState(() {
      selectedStandardId = standardId;

      // The old division belongs to the previous standard, so it is
      // replaced with the first division of the new one.
      final List<DivisionDetails> divisions = _divisions;

      selectedDivisionId = divisions.isNotEmpty
          ? divisions.first.divisionId
          : null;
    });

    _fetchMaterials();
  }

  void _onDivisionChanged(int? divisionId) {
    if (divisionId == null || divisionId == selectedDivisionId) return;

    setState(() {
      selectedDivisionId = divisionId;
    });

    _fetchMaterials();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          elevation: 3,
          shape: const CircleBorder(),
          onPressed: () async {
            final result = await Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => AddMaterialPage()));

            if (result == true && mounted) {
              debugPrint('Material added successfully - refreshing materials');

              _fetchMaterials();
            }
          },
          child: const Icon(Icons.add, color: Colors.white, size: 34),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 18),
            _buildTabBar(),
            const SizedBox(height: 14),
            _buildClassDropdowns(),
            const SizedBox(height: 14),
            _buildSearchRow(),
            const SizedBox(height: 14),
            Expanded(
              child: BlocConsumer<MaterialCubit, MaterialState>(
                listener: (context, state) {
                  if (state is FetchMaterialFailure) {
                    _showMessage(state.message);
                  }
                },
                builder: (context, state) {
                  if (selectedStandardId == null ||
                      selectedDivisionId == null) {
                    return const Center(
                      child: Text(
                        'Select a standard and division',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    );
                  }

                  if (state is FetchMaterialLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }

                  if (state is FetchMaterialFailure) {
                    return _buildFailureView(state.message);
                  }

                  if (state is FetchMaterialSuccess) {
                    final allMaterials = state.response.data ?? [];

                    final List<MaterialEntity> materials = _filterByTab(
                      allMaterials,
                    );

                    if (materials.isEmpty) {
                      return RefreshIndicator(
                        color: primaryColor,
                        onRefresh: () async => _fetchMaterials(),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 160),
                            Center(child: Text("No materials found")),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: primaryColor,
                      onRefresh: () async => _fetchMaterials(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 90),
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          final material = materials[index];

                          return Column(
                            children: [
                              if (index == 0 ||
                                  materials[index - 1].createdDate !=
                                      material.createdDate)
                                _buildDateText(material.createdDate ?? ""),
                              const SizedBox(height: 10),
                              _buildMaterialCard(material),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MaterialEntity> _filterByTab(List<MaterialEntity> allMaterials) {
    switch (selectedTab) {
      case 0:
        return allMaterials.where((e) {
          final hasDocument = e.documentName?.trim().isNotEmpty ?? false;
          final hasLink = e.link?.trim().isNotEmpty ?? false;
          final hasNote = e.notes?.trim().isNotEmpty ?? false;

          return hasDocument && !hasLink && !hasNote;
        }).toList();

      case 1:
        return allMaterials
            .where((e) => e.link?.trim().isNotEmpty ?? false)
            .toList();

      case 2:
        return allMaterials
            .where((e) => e.notes?.trim().isNotEmpty ?? false)
            .toList();

      default:
        return allMaterials;
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${widget.subjectName} Material',
                style: const TextStyle(
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final bool isSelected = selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
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

  /// Standard and Division pickers. Changing either refetches the list.
  Widget _buildClassDropdowns() {
    final List<TutorshipClass> standards = _validStandards;
    final List<DivisionDetails> divisions = _divisions;

    // DropdownButtonFormField asserts its value matches exactly one item.
    // Hold the value back until the matching item exists.
    final int? standardValue =
        standards.any((item) => item.standardId == selectedStandardId)
        ? selectedStandardId
        : null;

    final int? divisionValue =
        divisions.any((item) => item.divisionId == selectedDivisionId)
        ? selectedDivisionId
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _dropdownShell(
              label: 'Standard',
              child: DropdownButtonFormField<int>(
                value: standardValue,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primaryColor,
                  size: 20,
                ),
                decoration: _dropdownDecoration(
                  standards.isEmpty ? 'No Standards' : 'Select Standard',
                ),
                items: standards.map((standard) {
                  return DropdownMenuItem<int>(
                    value: standard.standardId,
                    child: Text(
                      standard.standard ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: standards.isEmpty ? null : _onStandardChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _dropdownShell(
              label: 'Division',
              child: DropdownButtonFormField<int>(
                value: divisionValue,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primaryColor,
                  size: 20,
                ),
                decoration: _dropdownDecoration(
                  divisions.isEmpty ? 'No Divisions' : 'Select Division',
                ),
                items: divisions.map((division) {
                  return DropdownMenuItem<int>(
                    value: division.divisionId,
                    child: Text(
                      division.division ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: divisions.isEmpty ? null : _onDivisionChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownShell({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 5),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
        ),
        child,
      ],
    );
  }

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 11, color: Colors.black45),
      filled: true,
      fillColor: fieldColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: primaryColor, width: 1.2),
      ),
    );
  }

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: primaryColor, width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureView(String message) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async => _fetchMaterials(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 90),
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 44),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.redAccent),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _fetchMaterials,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateText(String date) {
    return Center(
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMaterialCard(MaterialEntity material) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          _buildLeadingIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              selectedTab == 0
                  ? (material.documentName ?? "")
                  : selectedTab == 1
                  ? (material.link ?? "")
                  : (material.notes ?? ""),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 8),
          _buildTrailingSection(material),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon() {
    String iconPath;

    switch (selectedTab) {
      case 0:
        iconPath = "assets/icons/Group (10).svg";
        break;

      case 1:
        iconPath = "assets/icons/Group (11).svg";
        break;

      default:
        iconPath = "assets/icons/Group (11).svg";
    }

    return SvgPicture.asset(
      iconPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
    );
  }

  Widget _buildTrailingSection(MaterialEntity material) {
    return SizedBox(
      width: 55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _SmallActionButton(iconPath: 'assets/icons/Group (6).svg'),
              SizedBox(width: 5),
              _SmallActionButton(iconPath: 'assets/icons/Group (7).svg'),
            ],
          ),
          const SizedBox(height: 10),
          if (selectedTab == 0)
            Text(
              formatTime(material.createdDate),
              style: const TextStyle(fontSize: 9, color: Colors.black),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  selectedTab == 1 ? Icons.star : Icons.star_border,
                  color: selectedTab == 1 ? Colors.amber : Colors.black45,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryColor,
                  size: 14,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

String formatTime(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) return "";

  try {
    final date = DateTime.parse(dateTime);
    return DateFormat('hh:mm a').format(date);
  } catch (e) {
    return "";
  }
}

class _SmallActionButton extends StatelessWidget {
  final String iconPath;

  const _SmallActionButton({required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        color: Color(0xFFDAC8FF),
        shape: BoxShape.circle,
      ),
      child: Center(child: SvgPicture.asset(iconPath, width: 14, height: 14)),
    );
  }
}

// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/date_utils_helper.dart';
// import 'package:cristalteacher/features/materials/domain/entities/fetch_material_entity.dart';
// import 'package:cristalteacher/features/materials/domain/parameter/fetch_material_parameter.dart';
// import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
// import 'package:cristalteacher/features/materials/presentation/screens/addmaterials_screen.dart';
// import 'package:flutter/material.dart' hide MaterialState;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';

// class MaterialsExpansionScreen extends StatefulWidget {
//   final int? subjectId;
//   final String subjectName;

//   const MaterialsExpansionScreen({
//     super.key,
//     required this.subjectId,
//     required this.subjectName,
//   });

//   @override
//   State<MaterialsExpansionScreen> createState() => _MaterialsExpansionScreen();
// }

// class _MaterialsExpansionScreen extends State<MaterialsExpansionScreen> {
//   void _fetchMaterials() {
//     final String currentDate = DateUtilsHelper.getCurrentDate();

//     context.read<MaterialCubit>().fetchMaterials(
//       FetchMaterialParameter(
//         subjectId: widget.subjectId!,
//         accYear: AppData.accYear!,
//         branchId: 1,
//         fromDate: currentDate,
//         toDate: currentDate,
//         staffId: null,
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchMaterials();
//   }

//   int selectedTab = 0;

//   final List<String> tabs = ["Documents", "Links", "Notes"];

//   final Color primaryColor = const Color(0xFF9B73E6);
//   final Color darkColor = const Color(0xFF202020);
//   final Color bgColor = const Color(0xFFFCFAFF);
//   final Color cardColor = const Color(0xFFF5F2FF);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 30),
//         child: FloatingActionButton(
//           backgroundColor: primaryColor,
//           elevation: 3,
//           shape: const CircleBorder(),
//           onPressed: () async {
//             final result = await Navigator.of(
//               context,
//             ).push(MaterialPageRoute(builder: (context) => AddMaterialPage()));

//             if (result == true && mounted) {
//               print("Material added successfully - refreshing materials");

//               _fetchMaterials();
//             }
//           },
//           child: const Icon(Icons.add, color: Colors.white, size: 34),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             const SizedBox(height: 18),
//             _buildTabBar(),
//             const SizedBox(height: 14),
//             _buildSearchRow(),
//             const SizedBox(height: 14),
//             Expanded(
//               child: BlocConsumer<MaterialCubit, MaterialState>(
//                 listener: (context, state) {},
//                 builder: (context, state) {
//                   if (state is FetchMaterialLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (state is FetchMaterialFailure) {
//                     return Center(child: Text(state.message));
//                   }

//                   if (state is FetchMaterialSuccess) {
//                     final allMaterials = state.response.data ?? [];

//                     for (final item in allMaterials) {
//                       print(
//                         "Document: ${item.documentName}, "
//                         "Link: ${item.link}, "
//                         "Notes: ${item.notes}",
//                       );
//                     }

//                     List<MaterialEntity> materials;

//                     switch (selectedTab) {
//                       case 0:
//                         materials = allMaterials.where((e) {
//                           final hasDocument =
//                               e.documentName?.trim().isNotEmpty ?? false;
//                           final hasLink = e.link?.trim().isNotEmpty ?? false;
//                           final hasNote = e.notes?.trim().isNotEmpty ?? false;

//                           return hasDocument && !hasLink && !hasNote;
//                         }).toList();
//                         break;

//                       case 1:
//                         materials = allMaterials
//                             .where((e) => e.link?.trim().isNotEmpty ?? false)
//                             .toList();
//                         break;

//                       case 2:
//                         materials = allMaterials
//                             .where((e) => e.notes?.trim().isNotEmpty ?? false)
//                             .toList();
//                         break;

//                       default:
//                         materials = allMaterials;
//                     }

//                     if (materials.isEmpty) {
//                       return const Center(child: Text("No materials found"));
//                     }

//                     return ListView.builder(
//                       padding: const EdgeInsets.fromLTRB(24, 0, 24, 90),
//                       itemCount: materials.length,
//                       itemBuilder: (context, index) {
//                         final material = materials[index];

//                         return Column(
//                           children: [
//                             if (index == 0 ||
//                                 materials[index - 1].createdDate !=
//                                     material.createdDate)
//                               _buildDateText(material.createdDate ?? ""),
//                             const SizedBox(height: 10),
//                             _buildMaterialCard(material),
//                           ],
//                         );
//                       },
//                     );
//                   }

//                   return const SizedBox();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 '${widget.subjectName} Material',
//                 style: const TextStyle(
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

//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 22),
//       height: 48,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: darkColor,
//         borderRadius: BorderRadius.circular(28),
//       ),
//       child: Row(
//         children: List.generate(tabs.length, (index) {
//           final bool isSelected = selectedTab == index;

//           return Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedTab = index;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 220),
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   color: isSelected ? primaryColor : Colors.transparent,
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Center(
//                   child: Text(
//                     tabs[index],
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                       fontWeight: isSelected
//                           ? FontWeight.w600
//                           : FontWeight.w400,
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

//   Widget _buildSearchRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Row(
//         children: [
//           Container(
//             height: 34,
//             width: 34,
//             decoration: BoxDecoration(
//               color: primaryColor,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.filter_list_rounded,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(4),
//                 border: Border.all(color: primaryColor, width: 1),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.search, size: 18, color: Colors.grey),
//                   SizedBox(width: 8),
//                   Text(
//                     "Search",
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateText(String date) {
//     return Center(
//       child: Text(
//         date,
//         style: const TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w500,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildMaterialCard(MaterialEntity material) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(7),
//       ),
//       child: Row(
//         children: [
//           _buildLeadingIcon(),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Text(
//               selectedTab == 0
//                   ? (material.documentName ?? "")
//                   : selectedTab == 1
//                   ? (material.link ?? "")
//                   : (material.notes ?? ""),
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//           ),
//           const SizedBox(width: 8),
//           _buildTrailingSection(material),
//         ],
//       ),
//     );
//   }

//   Widget _buildLeadingIcon() {
//     String iconPath;

//     switch (selectedTab) {
//       case 0:
//         iconPath = "assets/icons/Group (10).svg";
//         break;

//       case 1:
//         iconPath = "assets/icons/Group (11).svg";
//         break;

//       default:
//         iconPath = "assets/icons/Group (11).svg";
//     }

//     return SvgPicture.asset(
//       iconPath,
//       width: 24,
//       height: 24,
//       colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
//     );
//   }

//   Widget _buildTrailingSection(MaterialEntity material) {
//     return SizedBox(
//       width: 55,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               _SmallActionButton(iconPath: 'assets/icons/Group (6).svg'),
//               SizedBox(width: 5),
//               _SmallActionButton(iconPath: 'assets/icons/Group (7).svg'),
//             ],
//           ),
//           const SizedBox(height: 10),
//           if (selectedTab == 0)
//             Text(
//               formatTime(material.createdDate),
//               style: const TextStyle(fontSize: 9, color: Colors.black),
//             )
//           else
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Icon(
//                   selectedTab == 1 ? Icons.star : Icons.star_border,
//                   color: selectedTab == 1 ? Colors.amber : Colors.black45,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 6),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: primaryColor,
//                   size: 14,
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

// String formatTime(String? dateTime) {
//   if (dateTime == null || dateTime.isEmpty) return "";

//   try {
//     final date = DateTime.parse(dateTime);
//     return DateFormat('hh:mm a').format(date);
//   } catch (e) {
//     return "";
//   }
// }

// class _SmallActionButton extends StatelessWidget {
//   final String iconPath;

//   const _SmallActionButton({required this.iconPath});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 25,
//       height: 25,
//       decoration: const BoxDecoration(
//         color: Color(0xFFDAC8FF),
//         shape: BoxShape.circle,
//       ),
//       child: Center(child: SvgPicture.asset(iconPath, width: 14, height: 14)),
//     );
//   }
// }
