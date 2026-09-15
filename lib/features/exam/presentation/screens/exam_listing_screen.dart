import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
import 'package:cristalteacher/features/exam/presentation/cubit/exammanagement_cubit.dart';
import 'package:cristalteacher/features/exam/presentation/screens/exam_adding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamListingScreen extends StatefulWidget {
  const ExamListingScreen({super.key});

  @override
  State<ExamListingScreen> createState() => _ExamListingScreenState();
}

class _ExamListingScreenState extends State<ExamListingScreen> {
  static const Color primaryColor = Color(0xFF9B73E6);

  static const Color backgroundColor = Color(0xFFFBF7FF);

  List<ExamListingEntity> _exams = <ExamListingEntity>[];

  bool _isLoading = true;
  String? _listingError;
  int? _deletingExamId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchExamListing();
    });
  }

  Future<void> _fetchExamListing() async {
    await context.read<ExamManagementCubit>().fetchExamListing();
  }

  Future<void> _refreshExamListing() async {
    await _fetchExamListing();
  }

  Future<void> _openAddExamScreen() async {
    final ExamManagementCubit cubit = context.read<ExamManagementCubit>();

    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const AddExamScreen()),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await _fetchExamListing();
    }
  }

  Future<void> _openEditExamScreen(ExamListingEntity exam) async {
    final int? examId = exam.examId;

    if (examId == null || examId <= 0) {
      _showMessage('Invalid Exam ID', Colors.red);
      return;
    }

    final ExamManagementCubit cubit = context.read<ExamManagementCubit>();

    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AddExamScreen(
            examId: examId,
            examName: exam.examName,
            examTermId: exam.examTermId,
            examTypeId: exam.examTypeId,
            isOpen: exam.isOpen,
            isPublish: exam.isPublish,
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await _fetchExamListing();
    }
  }

  Future<void> _confirmDeleteExam(ExamListingEntity exam) async {
    final int? examId = exam.examId;

    if (examId == null || examId <= 0) {
      _showMessage('Invalid Exam ID', Colors.red);
      return;
    }

    if (_deletingExamId != null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Exam',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${_displayValue(exam.examName)}"?',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _deletingExamId = examId;
    });

    await context.read<ExamManagementCubit>().deleteExam(examId);
  }

  void _handleCubitState(ExamManagementState state) {
    if (!mounted) return;

    if (state is ExamListingLoading) {
      setState(() {
        _isLoading = true;
        _listingError = null;
      });
    } else if (state is ExamListingSuccess) {
      setState(() {
        _exams = state.response.data ?? <ExamListingEntity>[];

        _isLoading = false;
        _listingError = null;
      });
    } else if (state is ExamListingFailure) {
      setState(() {
        _isLoading = false;
        _listingError = state.message;
      });
    } else if (state is DeleteExamLoading) {
      setState(() {
        _deletingExamId = state.examId;
      });
    } else if (state is DeleteExamSuccess) {
      final int deletedExamId = state.examId;

      setState(() {
        _deletingExamId = null;

        _exams.removeWhere((exam) => exam.examId == deletedExamId);
      });

      _showMessage('Exam deleted successfully', Colors.green);

      // Reload the server list to confirm deletion.
      _fetchExamListing();
    } else if (state is DeleteExamFailure) {
      setState(() {
        _deletingExamId = null;
      });

      _showMessage(state.message, Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _displayValue(String? value, {String fallback = 'N/A'}) {
    final String formatted = value?.trim() ?? '';

    return formatted.isEmpty ? fallback : formatted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamManagementCubit, ExamManagementState>(
      listener: (context, state) {
        _handleCubitState(state);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: const Text(
            'Exam Listing',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: _deletingExamId == null ? _openAddExamScreen : null,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _exams.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (_listingError != null && _exams.isEmpty) {
      return _buildFailureView(_listingError!);
    }

    if (_exams.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _refreshExamListing,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        itemCount: _exams.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 14);
        },
        itemBuilder: (context, index) {
          return _buildExamCard(exam: _exams[index]);
        },
      ),
    );
  }

  Widget _buildExamCard({required ExamListingEntity exam}) {
    final bool isOpen = exam.isOpen ?? false;

    final bool isPublished = exam.isPublish ?? false;

    final bool isDeleting =
        exam.examId != null && exam.examId == _deletingExamId;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E0EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayValue(exam.examName, fallback: 'Unnamed Exam'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _displayValue(exam.examTypeName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _CircleActionButton(
                  icon: Icons.edit_outlined,
                  iconColor: primaryColor,
                  onTap: isDeleting || _deletingExamId != null
                      ? null
                      : () {
                          _openEditExamScreen(exam);
                        },
                ),
                const SizedBox(width: 8),
                isDeleting
                    ? const SizedBox(
                        width: 31,
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : _CircleActionButton(
                        icon: Icons.delete_outline,
                        iconColor: Colors.red,
                        onTap: _deletingExamId != null
                            ? null
                            : () {
                                _confirmDeleteExam(exam);
                              },
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _information(
                        label: 'Exam Term',
                        value: _displayValue(exam.examTermName),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _information(
                        label: 'Exam Type',
                        value: _displayValue(exam.examTypeName),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statusChip(
                      text: isOpen ? 'Open' : 'Closed',
                      color: isOpen ? const Color(0xFF2E9B63) : Colors.red,
                    ),
                    _statusChip(
                      text: isPublished ? 'Published' : 'Not Published',
                      color: isPublished
                          ? const Color(0xFF366FD3)
                          : Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureView(String message) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _refreshExamListing,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
          const SizedBox(height: 14),
          const Text(
            'Unable to load exams',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              onPressed: _refreshExamListing,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _refreshExamListing,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        children: const [
          Icon(Icons.assignment_outlined, color: Colors.black26, size: 52),
          SizedBox(height: 14),
          Text(
            'No exams found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _information({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black45),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _statusChip({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _CircleActionButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 31,
      height: 31,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: const WidgetStatePropertyAll(CircleBorder()),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade100;
            }

            if (states.contains(WidgetState.pressed)) {
              return Colors.grey.shade300;
            }

            return Colors.white.withOpacity(0.85);
          }),
          elevation: const WidgetStatePropertyAll(2),
          minimumSize: const WidgetStatePropertyAll(Size(31, 31)),
          maximumSize: const WidgetStatePropertyAll(Size(31, 31)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Icon(
          icon,
          size: 17,
          color: onTap == null ? Colors.black26 : iconColor,
        ),
      ),
    );
  }
}
// import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
// import 'package:cristalteacher/features/exam/presentation/cubit/exammanagement_cubit.dart';
// import 'package:cristalteacher/features/exam/presentation/screens/exam_adding_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ExamListingScreen extends StatefulWidget {
//   const ExamListingScreen({super.key});

//   @override
//   State<ExamListingScreen> createState() => _ExamListingScreenState();
// }

// class _ExamListingScreenState extends State<ExamListingScreen> {
//   static const Color primaryColor = Color(0xFF9B73E6);

//   static const Color backgroundColor = Color(0xFFFBF7FF);

//   int? _deletingExamId;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       context.read<ExamManagementCubit>().fetchExamListing();
//     });
//   }

//   Future<void> _refreshExamListing() async {
//     await context.read<ExamManagementCubit>().fetchExamListing();
//   }

//   Future<void> _openAddExamScreen() async {
//     final ExamManagementCubit cubit = context.read<ExamManagementCubit>();

//     final bool? result = await Navigator.push<bool>(
//       context,
//       MaterialPageRoute(
//         builder: (_) =>
//             BlocProvider.value(value: cubit, child: const AddExamScreen()),
//       ),
//     );

//     if (!mounted) return;

//     if (result == true) {
//       await _refreshExamListing();
//     }
//   }

//   void _openEditExamScreen(ExamListingEntity exam) {
//     /*
//      * The edit option is ready in the UI.
//      *
//      * After creating the Update Exam API, this method can
//      * navigate to AddExamScreen in edit mode and pass exam.
//      */
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text('Edit ${_displayValue(exam.examName)}'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }

//   Future<void> _confirmDeleteExam(ExamListingEntity exam) async {
//     final int? examId = exam.examId;

//     if (examId == null || examId <= 0) {
//       _showMessage('Exam ID is missing', color: Colors.red);
//       return;
//     }

//     if (_deletingExamId != null) return;

//     final bool? shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             'Delete Exam',
//             style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//           ),
//           content: Text(
//             'Are you sure you want to delete '
//             '"${_displayValue(exam.examName)}"?',
//             style: const TextStyle(fontSize: 13, color: Colors.black87),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext, false);
//               },
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext, true);
//               },
//               child: const Text(
//                 'Delete',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (shouldDelete != true || !mounted) return;

//     setState(() {
//       _deletingExamId = examId;
//     });

//     await context.read<ExamManagementCubit>().deleteExam(examId);
//   }

//   void _showMessage(String message, {required Color color}) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: color,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }

//   String _displayValue(String? value, {String fallback = 'N/A'}) {
//     final String formatted = value?.trim() ?? '';

//     return formatted.isEmpty ? fallback : formatted;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.maybePop(context);
//           },
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: const Text(
//           'Exam Listing',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<ExamManagementCubit, ExamManagementState>(
//         // Delete states should not replace the currently
//         // displayed exam-listing UI.
//         buildWhen: (previous, current) {
//           return current is ExamListingLoading ||
//               current is ExamListingSuccess ||
//               current is ExamListingFailure;
//         },
//         listener: (context, state) async {
//           if (state is ExamListingFailure) {
//             _showMessage(state.message, color: Colors.red);
//           }

//           if (state is DeleteExamSuccess) {
//             if (mounted) {
//               setState(() {
//                 _deletingExamId = null;
//               });
//             }

//             _showMessage(
//               state.response.message ?? 'Exam deleted successfully',
//               color: Colors.green,
//             );

//             await _refreshExamListing();
//           }

//           if (state is DeleteExamFailure) {
//             if (mounted) {
//               setState(() {
//                 _deletingExamId = null;
//               });
//             }

//             _showMessage(state.message, color: Colors.red);
//           }
//         },
//         builder: (context, state) {
//           if (state is ExamListingLoading) {
//             return const Center(
//               child: CircularProgressIndicator(color: primaryColor),
//             );
//           }

//           if (state is ExamListingFailure) {
//             return _buildFailureView(state.message);
//           }

//           if (state is ExamListingSuccess) {
//             final List<ExamListingEntity> exams =
//                 state.response.data ?? <ExamListingEntity>[];

//             if (exams.isEmpty) {
//               return _buildEmptyView();
//             }

//             return RefreshIndicator(
//               color: primaryColor,
//               onRefresh: _refreshExamListing,
//               child: ListView.separated(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
//                 itemCount: exams.length,
//                 separatorBuilder: (_, __) {
//                   return const SizedBox(height: 14);
//                 },
//                 itemBuilder: (context, index) {
//                   return _buildExamCard(exam: exams[index]);
//                 },
//               ),
//             );
//           }

//           return _buildEmptyView();
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _deletingExamId == null ? _openAddExamScreen : null,
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 3,
//         shape: const CircleBorder(),
//         child: const Icon(Icons.add, size: 28),
//       ),
//     );
//   }

//   Widget _buildExamCard({required ExamListingEntity exam}) {
//     final bool isOpen = exam.isOpen ?? false;
//     final bool isPublished = exam.isPublish ?? false;

//     final bool isDeleting =
//         exam.examId != null && exam.examId == _deletingExamId;

//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE5E0EC)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: primaryColor.withOpacity(0.14),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.assignment_outlined,
//                   color: primaryColor,
//                   size: 22,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _displayValue(exam.examName, fallback: 'Unnamed Exam'),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       _displayValue(exam.examTypeName),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         color: Colors.black54,
//                         fontSize: 11.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (isDeleting)
//                 const Padding(
//                   padding: EdgeInsets.all(10),
//                   child: SizedBox(
//                     width: 19,
//                     height: 19,
//                     child: CircularProgressIndicator(
//                       color: Colors.red,
//                       strokeWidth: 2,
//                     ),
//                   ),
//                 )
//               else
//                 PopupMenuButton<String>(
//                   padding: EdgeInsets.zero,
//                   enabled: _deletingExamId == null,
//                   icon: const Icon(
//                     Icons.more_vert,
//                     color: Colors.black54,
//                     size: 21,
//                   ),
//                   onSelected: (value) {
//                     if (value == 'edit') {
//                       _openEditExamScreen(exam);
//                     } else if (value == 'delete') {
//                       _confirmDeleteExam(exam);
//                     }
//                   },
//                   itemBuilder: (_) {
//                     return const [
//                       PopupMenuItem<String>(
//                         value: 'edit',
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.edit_outlined,
//                               size: 19,
//                               color: primaryColor,
//                             ),
//                             SizedBox(width: 8),
//                             Text('Edit'),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'delete',
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.delete_outline,
//                               size: 19,
//                               color: Colors.red,
//                             ),
//                             SizedBox(width: 8),
//                             Text('Delete', style: TextStyle(color: Colors.red)),
//                           ],
//                         ),
//                       ),
//                     ];
//                   },
//                 ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           const Divider(height: 1, color: Color(0xFFECE8F1)),
//           const SizedBox(height: 13),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _information(
//                   label: 'Exam Term',
//                   value: _displayValue(exam.examTermName),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _information(
//                   label: 'Exam Type',
//                   value: _displayValue(exam.examTypeName),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               _statusChip(
//                 text: isOpen ? 'Open' : 'Closed',
//                 color: isOpen ? const Color(0xFF2E9B63) : Colors.red,
//               ),
//               _statusChip(
//                 text: isPublished ? 'Published' : 'Not Published',
//                 color: isPublished ? const Color(0xFF366FD3) : Colors.orange,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFailureView(String message) {
//     return RefreshIndicator(
//       color: primaryColor,
//       onRefresh: _refreshExamListing,
//       child: ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
//         children: [
//           const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
//           const SizedBox(height: 14),
//           const Text(
//             'Unable to load exams',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 7),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.black54, fontSize: 12),
//           ),
//           const SizedBox(height: 18),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: _refreshExamListing,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//               ),
//               icon: const Icon(Icons.refresh, size: 19),
//               label: const Text('Retry'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyView() {
//     return RefreshIndicator(
//       color: primaryColor,
//       onRefresh: _refreshExamListing,
//       child: ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
//         children: const [
//           Icon(Icons.assignment_outlined, color: Colors.black26, size: 52),
//           SizedBox(height: 14),
//           Text(
//             'No exams found',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.black54,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _information({required String label, required String value}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 10, color: Colors.black45),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _statusChip({required String text, required Color color}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }
