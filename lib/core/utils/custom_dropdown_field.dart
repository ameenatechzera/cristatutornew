// import 'package:flutter/material.dart';

// /// Wrapper so a dismissed sheet (null) is distinguishable from a picked value.
// class _PickedValue<T> {
//   final T? value;

//   const _PickedValue(this.value);
// }

// class CustomDropdownField<T> extends StatelessWidget {
//   final String hint;
//   final T? value;
//   final List<DropdownMenuItem<T>> items;
//   final ValueChanged<T?>? onChanged;

//   const CustomDropdownField({
//     super.key,
//     required this.hint,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   bool get _isEnabled => onChanged != null && items.isNotEmpty;

//   /// The item matching [value]. Null when the value is no longer in the
//   /// list, which falls back to showing the hint.
//   DropdownMenuItem<T>? get _selectedItem {
//     for (final DropdownMenuItem<T> item in items) {
//       if (item.value == value) {
//         return item;
//       }
//     }

//     return null;
//   }

//   Future<void> _openPicker(BuildContext context) async {
//     if (!_isEnabled) return;

//     FocusScope.of(context).unfocus();

//     final _PickedValue<T>? picked = await showModalBottomSheet<_PickedValue<T>>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) {
//         return _DropdownPickerSheet<T>(
//           title: hint,
//           items: items,
//           selectedValue: value,
//         );
//       },
//     );

//     if (picked == null) return;

//     onChanged!(picked.value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DropdownMenuItem<T>? selected = _selectedItem;

//     final Color textColor = _isEnabled ? Colors.black : Colors.grey;

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         _openPicker(context);
//       },
//       child: Container(
//         height: 58,
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xffEEF3FC),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xff8B8B8B), width: 0.8),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: selected == null
//                   ? Text(
//                       hint,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     )
//                   : DefaultTextStyle(
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       child: selected.child,
//                     ),
//             ),
//             Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: _isEnabled ? const Color(0xff5F6368) : Colors.grey,
//               size: 24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Bottom sheet that lists the options of a [CustomDropdownField].
// class _DropdownPickerSheet<T> extends StatelessWidget {
//   final String title;
//   final List<DropdownMenuItem<T>> items;
//   final T? selectedValue;

//   const _DropdownPickerSheet({
//     required this.title,
//     required this.items,
//     required this.selectedValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double maxHeight = MediaQuery.of(context).size.height * 0.6;

//     return SafeArea(
//       top: false,
//       child: Container(
//         constraints: BoxConstraints(maxHeight: maxHeight),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 10),
//             Container(
//               width: 42,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: const Color(0xffE0E0E0),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 14),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Select $title',
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xff222222),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Icon(
//                       Icons.close,
//                       size: 20,
//                       color: Color(0xff5F6368),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Divider(height: 1, color: Color(0xffEDEDED)),
//             Flexible(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 itemCount: items.length,
//                 separatorBuilder: (_, __) => const Divider(
//                   height: 1,
//                   indent: 20,
//                   endIndent: 20,
//                   color: Color(0xffF2F2F2),
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   final DropdownMenuItem<T> item = items[index];

//                   final bool isSelected = item.value == selectedValue;

//                   return InkWell(
//                     onTap: () {
//                       Navigator.pop(context, _PickedValue<T>(item.value));
//                     },
//                     child: Container(
//                       color: isSelected
//                           ? const Color(0xffF5EFFF)
//                           : Colors.transparent,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 16,
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: DefaultTextStyle(
//                               style: TextStyle(
//                                 fontSize: 13.5,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w700
//                                     : FontWeight.w600,
//                                 color: isSelected
//                                     ? const Color(0xff9D75E8)
//                                     : Colors.black,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               child: item.child,
//                             ),
//                           ),
//                           if (isSelected)
//                             const Icon(
//                               Icons.check_circle,
//                               size: 20,
//                               color: Color(0xff9D75E8),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 6),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

/// The bottom modal behind every dropdown-style field.
///
/// Path: lib/core/widgets/option_picker_sheet.dart
///
/// Only the sheet is shared. Each screen draws its own field and calls
/// [showOptionPickerSheet] from its onTap, so a screen keeps whatever
/// height, fill and border it already has.

/// Wrapper so a dismissed sheet (null) stays distinguishable from an option
/// whose own value is null.
class PickerSelection<T> {
  final T? value;

  const PickerSelection(this.value);
}

/// The item matching [value], or null when the value is not in the list.
/// Fields use this to decide between the selected label and the hint.
DropdownMenuItem<T>? selectedItemOf<T>(
  List<DropdownMenuItem<T>> items,
  T? value,
) {
  for (final DropdownMenuItem<T> item in items) {
    if (item.value == value) {
      return item;
    }
  }

  return null;
}

/// Opens the option sheet. Returns null when it is dismissed, or when there
/// is nothing to show, so callers need no guard of their own.
Future<PickerSelection<T>?> showOptionPickerSheet<T>({
  required BuildContext context,
  required String title,
  required List<DropdownMenuItem<T>> items,
  T? selectedValue,
}) {
  if (items.isEmpty) {
    return Future<PickerSelection<T>?>.value();
  }

  FocusScope.of(context).unfocus();

  return showModalBottomSheet<PickerSelection<T>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return _OptionPickerSheet<T>(
        title: title,
        items: items,
        selectedValue: selectedValue,
      );
    },
  );
}

class _OptionPickerSheet<T> extends StatelessWidget {
  final String title;
  final List<DropdownMenuItem<T>> items;
  final T? selectedValue;

  const _OptionPickerSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.6;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff222222),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xff5F6368),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xffEDEDED)),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Color(0xffF2F2F2),
                ),
                itemBuilder: (BuildContext context, int index) {
                  final DropdownMenuItem<T> item = items[index];

                  final bool isSelected = item.value == selectedValue;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, PickerSelection<T>(item.value));
                    },
                    child: Container(
                      color: isSelected
                          ? const Color(0xffF5EFFF)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xff9D75E8)
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: item.child,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Color(0xff9D75E8),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
