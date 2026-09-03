import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Font size + colour for one editable field.
///
/// Also owns the HTML round-trip, because the diary APIs store the title
/// and description as HTML: [wrapHtml] on the way out, [fromHtml] and
/// [stripHtml] on the way back in.
@immutable
class EditorTextStyle {
  final double fontSize;
  final Color color;

  const EditorTextStyle({
    this.fontSize = defaultFontSize,
    this.color = defaultColor,
  });

  static const double defaultFontSize = 12;
  static const Color defaultColor = Colors.black;

  static const double minFontSize = 10;
  static const double maxFontSize = 28;

  /// The untouched default, for a fresh form.
  static const EditorTextStyle initial = EditorTextStyle();

  EditorTextStyle copyWith({double? fontSize, Color? color}) {
    return EditorTextStyle(
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
    );
  }

  TextStyle toTextStyle() {
    return TextStyle(fontSize: fontSize, color: color);
  }

  /// Wraps [text] so the size / colour is stored with it.
  String wrapHtml(String text) {
    if (text.isEmpty) {
      return text;
    }

    final String escaped = text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('\n', '<br />');

    final String hex = color.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2);

    return '<span style="font-size:${fontSize.round()}px;color:#$hex">'
        '$escaped'
        '</span>';
  }

  /// Reads a style back out of stored HTML. Missing parts fall back to
  /// the defaults, so plain text loads fine too.
  static EditorTextStyle fromHtml(String? html) {
    return EditorTextStyle(
      fontSize: _fontSizeFromHtml(html) ?? defaultFontSize,
      color: _colorFromHtml(html) ?? defaultColor,
    );
  }

  /// Plain text out of stored HTML, for the controller and for list views.
  static String stripHtml(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    return value
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\n\s*\n'), '\n')
        .trim();
  }

  static double? _fontSizeFromHtml(String? html) {
    if (html == null || html.trim().isEmpty) {
      return null;
    }

    final RegExpMatch? match = RegExp(
      r'font-size\s*:\s*(\d+(?:\.\d+)?)\s*px',
      caseSensitive: false,
    ).firstMatch(html);

    if (match == null) {
      return null;
    }

    final double? size = double.tryParse(match.group(1) ?? '');

    if (size == null) {
      return null;
    }

    return size.clamp(minFontSize, maxFontSize).toDouble();
  }

  /// The leading non-dash guard keeps this off "background-color".
  static Color? _colorFromHtml(String? html) {
    if (html == null || html.trim().isEmpty) {
      return null;
    }

    final RegExpMatch? match = RegExp(
      r'(?:^|[^-a-zA-Z])color\s*:\s*#([0-9a-fA-F]{6})',
      caseSensitive: false,
    ).firstMatch(html);

    final String? hex = match?.group(1);

    if (hex == null) {
      return null;
    }

    return Color(int.parse('ff$hex', radix: 16));
  }

  @override
  bool operator ==(Object other) {
    return other is EditorTextStyle &&
        other.fontSize == fontSize &&
        other.color.value == color.value;
  }

  @override
  int get hashCode => Object.hash(fontSize, color.value);

  @override
  String toString() => '${fontSize.round()}px $color';
}

/// Colours used by the picker and the field, so a screen can match its
/// own palette without the widget hardcoding one.
class EditorStyleTheme {
  final Color accentColor;
  final Color fillColor;
  final Color borderColor;

  const EditorStyleTheme({
    this.accentColor = const Color(0xff9B73E6),
    this.fillColor = const Color(0xffEEF4FF),
    this.borderColor = const Color(0xffB7C4D6),
  });

  static const EditorStyleTheme standard = EditorStyleTheme();
}

/// Bottom sheet with a size slider and round colour swatches
/// (flutter_colorpicker's BlockPicker, its own default palette), plus a
/// "+" dot that opens the full HSV picker.
///
/// [onChanged] fires live while the user drags or taps, so the field
/// behind the sheet updates as they go.
Future<void> showTextStylePicker({
  required BuildContext context,
  required String label,
  required EditorTextStyle style,
  required ValueChanged<EditorTextStyle> onChanged,
  EditorStyleTheme theme = EditorStyleTheme.standard,
}) async {
  FocusScope.of(context).unfocus();

  EditorTextStyle current = style;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          void apply(EditorTextStyle next) {
            setSheetState(() {
              current = next;
            });

            onChanged(next);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$label text',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          apply(EditorTextStyle.initial);
                        },
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Live preview of the current choice.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: theme.fillColor,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: theme.borderColor),
                    ),
                    child: Text('Sample text', style: current.toTextStyle()),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Text(
                        'Size',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '${current.fontSize.round()} px',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xff5C5C5C),
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    value: current.fontSize,
                    min: EditorTextStyle.minFontSize,
                    max: EditorTextStyle.maxFontSize,
                    divisions:
                        (EditorTextStyle.maxFontSize -
                                EditorTextStyle.minFontSize)
                            .round(),
                    activeColor: theme.accentColor,
                    inactiveColor: theme.accentColor.withOpacity(0.25),
                    label: '${current.fontSize.round()}',
                    onChanged: (value) {
                      apply(current.copyWith(fontSize: value));
                    },
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Colour',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  // layoutBuilder / itemBuilder only shape the swatches;
                  // the colour list is BlockPicker's own default.
                  BlockPicker(
                    pickerColor: current.color,
                    onColorChanged: (picked) {
                      apply(current.copyWith(color: picked));
                    },
                    layoutBuilder: (context, colors, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...colors.map((swatch) => child(swatch)),

                            // "+" -> full spectrum, so the swatch grid
                            // stays short without limiting anyone.
                            GestureDetector(
                              onTap: () async {
                                final Color? picked =
                                    await _showFullColorPicker(
                                      context: context,
                                      startColor: current.color,
                                      accentColor: theme.accentColor,
                                    );

                                if (picked != null) {
                                  apply(current.copyWith(color: picked));
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.borderColor),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: theme.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemBuilder: (swatch, isCurrentColor, changeColor) {
                      final bool isDark =
                          ThemeData.estimateBrightnessForColor(swatch) ==
                          Brightness.dark;

                      return GestureDetector(
                        onTap: changeColor,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: swatch,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrentColor
                                  ? theme.accentColor
                                  : const Color(0xffD5D5D5),
                              width: isCurrentColor ? 2.5 : 1,
                            ),
                          ),
                          child: isCurrentColor
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                )
                              : null,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accentColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

/// Full spectrum picker. Returns null when dismissed.
Future<Color?> _showFullColorPicker({
  required BuildContext context,
  required Color startColor,
  required Color accentColor,
}) {
  Color picked = startColor;

  return showDialog<Color>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        title: const Text(
          'Pick a colour',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: startColor,
            onColorChanged: (color) {
              picked = color;
            },
            paletteType: PaletteType.hsvWithHue,
            enableAlpha: false,
            displayThumbColor: true,
            hexInputBar: true,
            labelTypes: const [ColorLabelType.hex, ColorLabelType.rgb],
            pickerAreaBorderRadius: BorderRadius.circular(8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, picked);
            },
            child: Text('Select', style: TextStyle(color: accentColor)),
          ),
        ],
      );
    },
  );
}

/// Text field whose trailing "B" button opens [showTextStylePicker] and
/// renders the text in the chosen size / colour.
///
/// Drop it anywhere a styled input is needed; the host screen only holds
/// the [EditorTextStyle] and rebuilds on [onStyleChanged].
class StyledInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  final EditorTextStyle style;
  final ValueChanged<EditorTextStyle> onStyleChanged;

  /// Title shown in the picker sheet. Defaults to [hint].
  final String? styleLabel;

  final double minHeight;
  final int maxLines;
  final bool enabled;

  final EditorStyleTheme theme;
  final String styleIconAsset;

  const StyledInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.style,
    required this.onStyleChanged,
    this.styleLabel,
    this.minHeight = 44,
    this.maxLines = 1,
    this.enabled = true,
    this.theme = EditorStyleTheme.standard,
    this.styleIconAsset = 'assets/icons/Group (8).svg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // minHeight, not a fixed height, so a bigger font is not clipped.
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: theme.fillColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: theme.borderColor),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        style: style.toTextStyle(),
        textInputAction: maxLines == 1
            ? TextInputAction.next
            : TextInputAction.newline,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Colors.black),

          suffixIcon: GestureDetector(
            onTap: enabled
                ? () {
                    showTextStylePicker(
                      context: context,
                      label: styleLabel ?? hint,
                      style: style,
                      onChanged: onStyleChanged,
                      theme: theme,
                    );
                  }
                : null,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(styleIconAsset, width: 25, height: 25),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 45,
            minHeight: 45,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
