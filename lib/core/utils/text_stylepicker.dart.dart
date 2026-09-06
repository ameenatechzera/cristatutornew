// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// /// Path: lib/core/utils/text_stylepicker.dart.dart
// ///
// /// Rich text for the diary fields. Font size, colour, bold, italic and
// /// underline are all held PER CHARACTER by [RichTextEditingController], so
// /// the style sheet changes the selected words only and leaves the rest of
// /// the field alone. With nothing selected it falls back to the whole field,
// /// which keeps the old "just tap B" behaviour alive.
// ///
// /// The text travels to the API as inline HTML, one span per formatted run:
// ///
// ///   <span style="font-size:12px;color:#000000;...">plain </span>
// ///   <span style="font-size:18px;color:#E04A4A;font-weight:bold;...">word</span>
// ///
// /// [RichTextEditingController.toHtml] writes it, and
// /// [RichTextEditingController.setHtml] reads it back with every run restored.

// /// Style of one run of text: one character in the field, or one span of HTML.
// @immutable
// class EditorTextStyle {
//   final double fontSize;
//   final Color color;
//   final bool bold;
//   final bool italic;
//   final bool underline;

//   const EditorTextStyle({
//     this.fontSize = defaultFontSize,
//     this.color = defaultColor,
//     this.bold = false,
//     this.italic = false,
//     this.underline = false,
//   });

//   static const double defaultFontSize = 12;
//   static const Color defaultColor = Colors.black;

//   static const double minFontSize = 10;
//   static const double maxFontSize = 28;

//   static const EditorTextStyle initial = EditorTextStyle();

//   EditorTextStyle copyWith({
//     double? fontSize,
//     Color? color,
//     bool? bold,
//     bool? italic,
//     bool? underline,
//   }) {
//     return EditorTextStyle(
//       fontSize: fontSize ?? this.fontSize,
//       color: color ?? this.color,
//       bold: bold ?? this.bold,
//       italic: italic ?? this.italic,
//       underline: underline ?? this.underline,
//     );
//   }

//   TextStyle toTextStyle() {
//     return TextStyle(
//       fontSize: fontSize,
//       color: color,
//       fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//       fontStyle: italic ? FontStyle.italic : FontStyle.normal,
//       decoration: underline ? TextDecoration.underline : TextDecoration.none,
//       decorationColor: color,
//     );
//   }

//   /// Escapes one plain text run so it is safe inside HTML.
//   static String escapeHtml(String text) {
//     return text
//         .replaceAll('&', '&amp;')
//         .replaceAll('<', '&lt;')
//         .replaceAll('>', '&gt;')
//         .replaceAll('"', '&quot;')
//         .replaceAll("'", '&#39;')
//         .replaceAll('\n', '<br />');
//   }

//   /// Wraps already escaped HTML in the field wide span. The inner HTML may
//   /// carry its own <b> and <i> runs.
//   String wrapOuterHtml(String innerHtml) {
//     if (innerHtml.isEmpty) {
//       return '';
//     }

//     final String hex = color.value
//         .toRadixString(16)
//         .padLeft(8, '0')
//         .substring(2)
//         .toUpperCase();

//     final String htmlFontWeight = bold ? 'bold' : 'normal';
//     final String htmlFontStyle = italic ? 'italic' : 'normal';
//     final String htmlDecoration = underline ? 'underline' : 'none';

//     return '<span style="'
//         'font-size:${fontSize.round()}px;'
//         'color:#$hex;'
//         'font-weight:$htmlFontWeight;'
//         'font-style:$htmlFontStyle;'
//         'text-decoration:$htmlDecoration;'
//         '">'
//         '$innerHtml'
//         '</span>';
//   }

//   /// Converts plain text and the field wide formatting into HTML.
//   String wrapHtml(String text) {
//     if (text.isEmpty) {
//       return '';
//     }

//     return wrapOuterHtml(escapeHtml(text));
//   }

//   /// Reads formatting from stored HTML.
//   static EditorTextStyle fromHtml(String? html) {
//     return EditorTextStyle(
//       fontSize: _fontSizeFromHtml(html) ?? defaultFontSize,
//       color: _colorFromHtml(html) ?? defaultColor,
//       bold: _boldFromHtml(html),
//       italic: _italicFromHtml(html),
//       underline: _underlineFromHtml(html),
//     );
//   }

//   /// Same as [fromHtml] but never turns the whole field bold or italic.
//   ///
//   /// Used by the diary fields: bold and italic come back run by run through
//   /// [RichTextEditingController.setHtml], so reading them here as well would
//   /// bold the entire field whenever a single word was bold.
//   static EditorTextStyle baseFromHtml(String? html) {
//     return EditorTextStyle(
//       fontSize: _fontSizeFromHtml(html) ?? defaultFontSize,
//       color: _colorFromHtml(html) ?? defaultColor,
//       underline: _underlineFromHtml(html),
//     );
//   }

//   /// Removes HTML and returns plain text.
//   static String stripHtml(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return '';
//     }

//     return value
//         .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
//         .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
//         .replaceAll(RegExp(r'</div\s*>', caseSensitive: false), '\n')
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll('&#160;', ' ')
//         .replaceAll('&amp;', '&')
//         .replaceAll('&lt;', '<')
//         .replaceAll('&gt;', '>')
//         .replaceAll('&quot;', '"')
//         .replaceAll('&#39;', "'")
//         .replaceAll('&#x27;', "'")
//         .replaceAll(RegExp(r'\n\s*\n'), '\n')
//         .trim();
//   }

//   static double? _fontSizeFromHtml(String? html) {
//     if (html == null || html.trim().isEmpty) {
//       return null;
//     }

//     final RegExpMatch? match = RegExp(
//       r'font-size\s*:\s*(\d+(?:\.\d+)?)\s*px',
//       caseSensitive: false,
//     ).firstMatch(html);

//     if (match == null) {
//       return null;
//     }

//     final double? size = double.tryParse(match.group(1) ?? '');

//     if (size == null) {
//       return null;
//     }

//     return size.clamp(minFontSize, maxFontSize).toDouble();
//   }

//   /// Prevents matching background-color.
//   static Color? _colorFromHtml(String? html) {
//     if (html == null || html.trim().isEmpty) {
//       return null;
//     }

//     final RegExpMatch? match = RegExp(
//       r'(?:^|[^-a-zA-Z])color\s*:\s*#([0-9a-fA-F]{6})',
//       caseSensitive: false,
//     ).firstMatch(html);

//     final String? hex = match?.group(1);

//     if (hex == null) {
//       return null;
//     }

//     return Color(int.parse('FF$hex', radix: 16));
//   }

//   static bool _boldFromHtml(String? html) {
//     if (html == null || html.trim().isEmpty) {
//       return false;
//     }

//     final bool hasCssBold = RegExp(
//       r'font-weight\s*:\s*(bold|bolder|[6-9]00)',
//       caseSensitive: false,
//     ).hasMatch(html);

//     final bool hasBoldTag = RegExp(
//       r'<\s*(b|strong)(?:\s[^>]*)?>',
//       caseSensitive: false,
//     ).hasMatch(html);

//     return hasCssBold || hasBoldTag;
//   }

//   static bool _italicFromHtml(String? html) {
//     if (html == null || html.trim().isEmpty) {
//       return false;
//     }

//     final bool hasCssItalic = RegExp(
//       r'font-style\s*:\s*(italic|oblique)',
//       caseSensitive: false,
//     ).hasMatch(html);

//     final bool hasItalicTag = RegExp(
//       r'<\s*(i|em)(?:\s[^>]*)?>',
//       caseSensitive: false,
//     ).hasMatch(html);

//     return hasCssItalic || hasItalicTag;
//   }

//   static bool _underlineFromHtml(String? html) {
//     if (html == null || html.trim().isEmpty) {
//       return false;
//     }

//     final bool hasCssUnderline = RegExp(
//       r'text-decoration(?:-line)?\s*:[^;"]*\bunderline\b',
//       caseSensitive: false,
//     ).hasMatch(html);

//     final bool hasUnderlineTag = RegExp(
//       r'<\s*u(?:\s[^>]*)?>',
//       caseSensitive: false,
//     ).hasMatch(html);

//     return hasCssUnderline || hasUnderlineTag;
//   }

//   @override
//   bool operator ==(Object other) {
//     return other is EditorTextStyle &&
//         other.fontSize == fontSize &&
//         other.color.value == color.value &&
//         other.bold == bold &&
//         other.italic == italic &&
//         other.underline == underline;
//   }

//   @override
//   int get hashCode {
//     return Object.hash(fontSize, color.value, bold, italic, underline);
//   }

//   @override
//   String toString() {
//     return '${fontSize.round()}px '
//         '$color '
//         '${bold ? "bold" : "normal"} '
//         '${italic ? "italic" : "regular"} '
//         '${underline ? "underline" : "no underline"}';
//   }
// }

// /// Everything the style sheet needs to know about a selection.
// ///
// /// [fontSize] and [color] are null when the selected characters do not agree
// /// on one value, which is how the sheet shows "Mixed" instead of lying.
// @immutable
// class SelectionStyleSummary {
//   /// Style of the first character in the range. Drives the live preview.
//   final EditorTextStyle sample;

//   /// True only when EVERY character in the range already carries it.
//   final bool bold;
//   final bool italic;
//   final bool underline;

//   /// Null when the range mixes more than one size / colour.
//   final double? fontSize;
//   final Color? color;

//   /// True when there is nothing to style, i.e. an empty field.
//   final bool isEmpty;

//   const SelectionStyleSummary({
//     required this.sample,
//     required this.bold,
//     required this.italic,
//     required this.underline,
//     required this.fontSize,
//     required this.color,
//     required this.isEmpty,
//   });

//   double get effectiveFontSize => fontSize ?? sample.fontSize;

//   Color get effectiveColor => color ?? sample.color;

//   bool get mixedFontSize => fontSize == null && !isEmpty;

//   bool get mixedColor => color == null && !isEmpty;

//   /// What the preview box shows.
//   EditorTextStyle get previewStyle {
//     return sample.copyWith(
//       bold: bold,
//       italic: italic,
//       underline: underline,
//       fontSize: effectiveFontSize,
//       color: effectiveColor,
//     );
//   }
// }

// /// Text controller that keeps one [EditorTextStyle] per character, so size,
// /// colour, bold, italic and underline all apply to the SELECTED text only.
// ///
// /// Nothing is field wide any more. The screen no longer holds an
// /// [EditorTextStyle] of its own: every run's formatting lives here, goes to
// /// the API through [toHtml] and comes back through [setHtml].
// class RichTextEditingController extends TextEditingController {
//   /// Style given to characters that have none of their own: a fresh field,
//   /// text typed into an empty field, and Reset.
//   final EditorTextStyle baseStyle;

//   /// One entry per character of [text].
//   List<EditorTextStyle> _styles = <EditorTextStyle>[];

//   RichTextEditingController({
//     String? text,
//     this.baseStyle = EditorTextStyle.initial,
//   }) : super(text: text) {
//     _styles = List<EditorTextStyle>.filled(
//       super.value.text.length,
//       baseStyle,
//       growable: true,
//     );
//   }

//   /// Read only copy, handy while debugging.
//   List<EditorTextStyle> get characterStyles {
//     return List<EditorTextStyle>.unmodifiable(_normalisedStyles());
//   }

//   /// True when any character differs from [baseStyle].
//   bool get hasFormatting {
//     return _normalisedStyles().any((EditorTextStyle style) {
//       return style != baseStyle;
//     });
//   }

//   List<EditorTextStyle> _normalisedStyles() {
//     if (_styles.length != text.length) {
//       _styles = List<EditorTextStyle>.filled(
//         text.length,
//         baseStyle,
//         growable: true,
//       );
//     }

//     return _styles;
//   }

//   @override
//   set value(TextEditingValue newValue) {
//     final String oldText = super.value.text;

//     if (oldText != newValue.text) {
//       _syncStyles(oldText, newValue.text);
//     }

//     super.value = newValue;
//   }

//   /// Keeps one style per character after an edit. Typed characters inherit the
//   /// formatting of the character in front of them, the way any editor behaves.
//   void _syncStyles(String oldText, String newText) {
//     List<EditorTextStyle> current = _styles;

//     if (current.length != oldText.length) {
//       current = List<EditorTextStyle>.filled(
//         oldText.length,
//         baseStyle,
//         growable: true,
//       );
//     }

//     final int minLength = min(oldText.length, newText.length);

//     int prefix = 0;

//     while (prefix < minLength &&
//         oldText.codeUnitAt(prefix) == newText.codeUnitAt(prefix)) {
//       prefix++;
//     }

//     int suffix = 0;

//     while (suffix < minLength - prefix &&
//         oldText.codeUnitAt(oldText.length - suffix - 1) ==
//             newText.codeUnitAt(newText.length - suffix - 1)) {
//       suffix++;
//     }

//     final int removedStart = prefix.clamp(0, current.length);
//     final int removedEnd = (oldText.length - suffix).clamp(0, current.length);
//     final int insertedLength = max(newText.length - suffix - prefix, 0);

//     EditorTextStyle inherited = baseStyle;

//     if (removedStart > 0 && removedStart <= current.length) {
//       inherited = current[removedStart - 1];
//     } else if (removedEnd < current.length) {
//       inherited = current[removedEnd];
//     }

//     _styles = <EditorTextStyle>[
//       ...current.sublist(0, removedStart),
//       ...List<EditorTextStyle>.filled(insertedLength, inherited),
//       ...current.sublist(removedEnd),
//     ];
//   }

//   /// The range a style change works on. A collapsed or missing selection means
//   /// the whole field, which keeps the old "just tap B" behaviour alive.
//   TextRange _resolveRange(TextSelection? selection) {
//     final int length = text.length;

//     if (selection == null || !selection.isValid || selection.isCollapsed) {
//       return TextRange(start: 0, end: length);
//     }

//     return TextRange(
//       start: selection.start.clamp(0, length),
//       end: selection.end.clamp(0, length),
//     );
//   }

//   /// What the style sheet shows as active for [selection].
//   SelectionStyleSummary styleForRange(TextSelection? selection) {
//     final List<EditorTextStyle> styles = _normalisedStyles();
//     final TextRange range = _resolveRange(selection);

//     if (styles.isEmpty || range.start >= range.end) {
//       return SelectionStyleSummary(
//         sample: baseStyle,
//         bold: false,
//         italic: false,
//         underline: false,
//         fontSize: baseStyle.fontSize,
//         color: baseStyle.color,
//         isEmpty: true,
//       );
//     }

//     final EditorTextStyle first = styles[range.start];

//     bool bold = true;
//     bool italic = true;
//     bool underline = true;

//     double? fontSize = first.fontSize;
//     Color? color = first.color;

//     for (int i = range.start; i < range.end; i++) {
//       final EditorTextStyle style = styles[i];

//       if (!style.bold) bold = false;
//       if (!style.italic) italic = false;
//       if (!style.underline) underline = false;

//       if (fontSize != null && style.fontSize != fontSize) {
//         fontSize = null;
//       }

//       if (color != null && style.color.value != color.value) {
//         color = null;
//       }
//     }

//     return SelectionStyleSummary(
//       sample: first,
//       bold: bold,
//       italic: italic,
//       underline: underline,
//       fontSize: fontSize,
//       color: color,
//       isEmpty: false,
//     );
//   }

//   /// The plain text sitting inside [selection]. Used by the sheet's preview.
//   String textForRange(TextSelection? selection) {
//     final TextRange range = _resolveRange(selection);

//     if (range.start >= range.end) {
//       return '';
//     }

//     return text.substring(range.start, range.end);
//   }

//   /// Runs [transform] over every character in [selection].
//   void applyStyle(
//     EditorTextStyle Function(EditorTextStyle style) transform, {
//     TextSelection? selection,
//   }) {
//     final List<EditorTextStyle> styles = _normalisedStyles();
//     final TextRange range = _resolveRange(selection);

//     if (range.start >= range.end) {
//       return;
//     }

//     for (int i = range.start; i < range.end; i++) {
//       styles[i] = transform(styles[i]);
//     }

//     notifyListeners();
//   }

//   /// Turns bold on when part of the range is missing it, and off when the
//   /// whole range already carries it. Italic and underline behave the same.
//   void toggleBold({TextSelection? selection}) {
//     final bool enable = !styleForRange(selection).bold;

//     applyStyle(
//       (EditorTextStyle style) => style.copyWith(bold: enable),
//       selection: selection,
//     );
//   }

//   void toggleItalic({TextSelection? selection}) {
//     final bool enable = !styleForRange(selection).italic;

//     applyStyle(
//       (EditorTextStyle style) => style.copyWith(italic: enable),
//       selection: selection,
//     );
//   }

//   void toggleUnderline({TextSelection? selection}) {
//     final bool enable = !styleForRange(selection).underline;

//     applyStyle(
//       (EditorTextStyle style) => style.copyWith(underline: enable),
//       selection: selection,
//     );
//   }

//   void applyFontSize(double fontSize, {TextSelection? selection}) {
//     applyStyle(
//       (EditorTextStyle style) => style.copyWith(fontSize: fontSize),
//       selection: selection,
//     );
//   }

//   void applyColor(Color color, {TextSelection? selection}) {
//     applyStyle(
//       (EditorTextStyle style) => style.copyWith(color: color),
//       selection: selection,
//     );
//   }

//   /// Drops the range back to [baseStyle]. Used by the sheet's Reset.
//   void clearFormatting({TextSelection? selection}) {
//     applyStyle((EditorTextStyle _) => baseStyle, selection: selection);
//   }

//   /// Replaces the text without carrying any formatting over.
//   void setPlainText(String value) {
//     this.value = TextEditingValue(
//       text: value,
//       selection: TextSelection.collapsed(offset: value.length),
//     );

//     _styles = List<EditorTextStyle>.filled(
//       value.length,
//       baseStyle,
//       growable: true,
//     );

//     notifyListeners();
//   }

//   /// Loads stored HTML: the plain text plus every run's formatting.
//   ///
//   /// Returns the style of the first character, for callers that still want a
//   /// single [EditorTextStyle] to show somewhere.
//   EditorTextStyle setHtml(String? html) {
//     final _ParsedRichText parsed = _parseRichHtml(html, baseStyle);

//     value = TextEditingValue(
//       text: parsed.text,
//       selection: TextSelection.collapsed(offset: parsed.text.length),
//     );

//     _styles = List<EditorTextStyle>.from(parsed.styles, growable: true);

//     notifyListeners();

//     return _styles.isEmpty ? baseStyle : _styles.first;
//   }

//   /// Inline HTML for the API: one <span> per formatted run, so a single bold
//   /// red word travels on its own instead of dragging the whole field with it.
//   String toHtml() {
//     final String raw = text;

//     int start = 0;
//     int end = raw.length;

//     while (start < end && raw[start].trim().isEmpty) {
//       start++;
//     }

//     while (end > start && raw[end - 1].trim().isEmpty) {
//       end--;
//     }

//     if (start >= end) {
//       return '';
//     }

//     final List<EditorTextStyle> styles = _normalisedStyles();
//     final StringBuffer buffer = StringBuffer();

//     int runStart = start;

//     for (int i = start + 1; i <= end; i++) {
//       if (i == end || styles[i] != styles[runStart]) {
//         buffer.write(styles[runStart].wrapHtml(raw.substring(runStart, i)));

//         runStart = i;
//       }
//     }

//     return buffer.toString();
//   }

//   /// Draws the field run by run, so one word can be bigger, bold and red
//   /// while the rest of the line stays as it was.
//   @override
//   TextSpan buildTextSpan({
//     required BuildContext context,
//     TextStyle? style,
//     required bool withComposing,
//   }) {
//     final String raw = text;

//     if (raw.isEmpty) {
//       return TextSpan(style: style, text: '');
//     }

//     final List<EditorTextStyle> styles = _normalisedStyles();
//     final List<InlineSpan> runs = <InlineSpan>[];

//     int runStart = 0;

//     for (int i = 1; i <= raw.length; i++) {
//       if (i == raw.length || styles[i] != styles[runStart]) {
//         runs.add(
//           TextSpan(
//             text: raw.substring(runStart, i),
//             style: (style ?? const TextStyle()).merge(
//               styles[runStart].toTextStyle(),
//             ),
//           ),
//         );

//         runStart = i;
//       }
//     }

//     return TextSpan(style: style, children: runs);
//   }
// }

// /// Plain text plus one [EditorTextStyle] per character, read out of HTML.
// class _ParsedRichText {
//   final String text;
//   final List<EditorTextStyle> styles;

//   const _ParsedRichText(this.text, this.styles);
// }

// class _OpenTag {
//   final String name;
//   final EditorTextStyle style;

//   const _OpenTag(this.name, this.style);
// }

// /// Walks the stored HTML and records the size, colour, bold, italic and
// /// underline of every character.
// ///
// /// Handles <b>, <strong>, <i>, <em>, <u>, inline CSS on any tag, plus <br>,
// /// </p> and </div> as line breaks.
// _ParsedRichText _parseRichHtml(String? html, EditorTextStyle base) {
//   if (html == null || html.trim().isEmpty) {
//     return const _ParsedRichText('', <EditorTextStyle>[]);
//   }

//   // Plain text that was never wrapped in HTML.
//   if (!html.contains('<') && !html.contains('&')) {
//     final String plain = html.trim();

//     return _ParsedRichText(
//       plain,
//       List<EditorTextStyle>.filled(plain.length, base, growable: true),
//     );
//   }

//   final StringBuffer buffer = StringBuffer();
//   final List<EditorTextStyle> styles = <EditorTextStyle>[];
//   final List<_OpenTag> openTags = <_OpenTag>[];

//   EditorTextStyle currentStyle() {
//     return openTags.isEmpty ? base : openTags.last.style;
//   }

//   void appendText(String value) {
//     if (value.isEmpty) return;

//     final EditorTextStyle style = currentStyle();

//     buffer.write(value);

//     for (int i = 0; i < value.length; i++) {
//       styles.add(style);
//     }
//   }

//   final RegExp tokenPattern = RegExp(r'<[^>]*>|[^<]+');
//   final RegExp namePattern = RegExp(r'^<\s*/?\s*([a-zA-Z0-9]+)');
//   final RegExp doubleQuotedStyle = RegExp(
//     r'style\s*=\s*"([^"]*)"',
//     caseSensitive: false,
//   );
//   final RegExp singleQuotedStyle = RegExp(
//     r"style\s*=\s*'([^']*)'",
//     caseSensitive: false,
//   );

//   for (final RegExpMatch match in tokenPattern.allMatches(html)) {
//     final String piece = match.group(0) ?? '';

//     if (!piece.startsWith('<')) {
//       appendText(_unescapeHtml(piece));
//       continue;
//     }

//     final String name = (namePattern.firstMatch(piece)?.group(1) ?? '')
//         .toLowerCase();

//     if (name.isEmpty) {
//       continue;
//     }

//     if (name == 'br') {
//       appendText('\n');
//       continue;
//     }

//     final bool isClosing = RegExp(r'^<\s*/').hasMatch(piece);

//     if (isClosing) {
//       if (name == 'p' || name == 'div') {
//         appendText('\n');
//       }

//       final int index = openTags.lastIndexWhere((tag) => tag.name == name);

//       if (index != -1) {
//         openTags.removeRange(index, openTags.length);
//       }

//       continue;
//     }

//     EditorTextStyle tagStyle = currentStyle();

//     switch (name) {
//       case 'b':
//       case 'strong':
//         tagStyle = tagStyle.copyWith(bold: true);
//         break;
//       case 'i':
//       case 'em':
//         tagStyle = tagStyle.copyWith(italic: true);
//         break;
//       case 'u':
//       case 'ins':
//         tagStyle = tagStyle.copyWith(underline: true);
//         break;
//       default:
//         break;
//     }

//     final String? inlineStyle =
//         doubleQuotedStyle.firstMatch(piece)?.group(1) ??
//         singleQuotedStyle.firstMatch(piece)?.group(1);

//     if (inlineStyle != null) {
//       tagStyle = _applyInlineCss(tagStyle, inlineStyle);
//     }

//     // Self closing tags never open a range.
//     if (!piece.endsWith('/>')) {
//       openTags.add(_OpenTag(name, tagStyle));
//     }
//   }

//   final String parsedText = buffer.toString();

//   int start = 0;
//   int end = parsedText.length;

//   while (start < end && parsedText[start].trim().isEmpty) {
//     start++;
//   }

//   while (end > start && parsedText[end - 1].trim().isEmpty) {
//     end--;
//   }

//   return _ParsedRichText(
//     parsedText.substring(start, end),
//     List<EditorTextStyle>.from(styles.sublist(start, end), growable: true),
//   );
// }

// /// Reads one inline style="..." attribute onto [style].
// ///
// /// Written out property by property so font-weight:normal actually turns bold
// /// back off, instead of only ever switching things on.
// EditorTextStyle _applyInlineCss(EditorTextStyle style, String css) {
//   EditorTextStyle updated = style;

//   for (final String declaration in css.split(';')) {
//     final int separator = declaration.indexOf(':');

//     if (separator == -1) {
//       continue;
//     }

//     final String property = declaration
//         .substring(0, separator)
//         .trim()
//         .toLowerCase();

//     final String value = declaration.substring(separator + 1).trim();

//     switch (property) {
//       case 'font-size':
//         final double? size = _parseCssFontSize(value);

//         if (size != null) {
//           updated = updated.copyWith(fontSize: size);
//         }
//         break;

//       case 'color':
//         final Color? color = _parseCssColor(value);

//         if (color != null) {
//           updated = updated.copyWith(color: color);
//         }
//         break;

//       case 'font-weight':
//         final String weight = value.toLowerCase();
//         final int? numeric = int.tryParse(weight);

//         updated = updated.copyWith(
//           bold:
//               weight == 'bold' ||
//               weight == 'bolder' ||
//               (numeric != null && numeric >= 600),
//         );
//         break;

//       case 'font-style':
//         final String fontStyle = value.toLowerCase();

//         updated = updated.copyWith(
//           italic: fontStyle == 'italic' || fontStyle == 'oblique',
//         );
//         break;

//       case 'text-decoration':
//       case 'text-decoration-line':
//         updated = updated.copyWith(
//           underline: value.toLowerCase().contains('underline'),
//         );
//         break;
//     }
//   }

//   return updated;
// }

// double? _parseCssFontSize(String value) {
//   final RegExpMatch? match = RegExp(r'([\d.]+)').firstMatch(value);

//   if (match == null) {
//     return null;
//   }

//   final double? size = double.tryParse(match.group(1) ?? '');

//   if (size == null || size <= 0) {
//     return null;
//   }

//   return size
//       .clamp(EditorTextStyle.minFontSize, EditorTextStyle.maxFontSize)
//       .toDouble();
// }

// Color? _parseCssColor(String value) {
//   final String raw = value.trim().toLowerCase();

//   if (raw.startsWith('#')) {
//     String hex = raw.substring(1);

//     if (hex.length == 3) {
//       hex = hex.split('').map((String c) => '$c$c').join();
//     }

//     if (hex.length == 6) {
//       final int? parsed = int.tryParse(hex, radix: 16);

//       if (parsed != null) {
//         return Color(0xff000000 | parsed);
//       }
//     }

//     return null;
//   }

//   final RegExpMatch? rgb = RegExp(
//     r'rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)',
//   ).firstMatch(raw);

//   if (rgb != null) {
//     return Color.fromARGB(
//       255,
//       int.parse(rgb.group(1)!).clamp(0, 255),
//       int.parse(rgb.group(2)!).clamp(0, 255),
//       int.parse(rgb.group(3)!).clamp(0, 255),
//     );
//   }

//   const Map<String, int> namedColors = <String, int>{
//     'black': 0xff000000,
//     'white': 0xffffffff,
//     'red': 0xffff0000,
//     'green': 0xff008000,
//     'blue': 0xff0000ff,
//     'grey': 0xff808080,
//     'gray': 0xff808080,
//     'orange': 0xffffa500,
//     'purple': 0xff800080,
//   };

//   final int? named = namedColors[raw];

//   return named == null ? null : Color(named);
// }

// String _unescapeHtml(String value) {
//   return value
//       .replaceAll('&nbsp;', ' ')
//       .replaceAll('&#160;', ' ')
//       .replaceAll('&lt;', '<')
//       .replaceAll('&gt;', '>')
//       .replaceAll('&quot;', '"')
//       .replaceAll('&#39;', "'")
//       .replaceAll('&#x27;', "'")
//       .replaceAll('&amp;', '&');
// }

// /// Colours used by the picker and input field.
// class EditorStyleTheme {
//   final Color accentColor;
//   final Color fillColor;
//   final Color borderColor;

//   const EditorStyleTheme({
//     this.accentColor = const Color(0xff9B73E6),
//     this.fillColor = const Color(0xffEEF4FF),
//     this.borderColor = const Color(0xffB7C4D6),
//   });

//   static const EditorStyleTheme standard = EditorStyleTheme();
// }

// /// Opens a bottom sheet containing:
// /// - B, I and U formatting buttons
// /// - Font-size slider
// /// - Colour picker
// ///
// /// Everything in it is applied to [selection] on [controller], so only the
// /// picked words change. Capture the selection BEFORE calling this: showing a
// /// sheet drops focus, and a collapsed selection means the whole field.
// Future<void> showTextStylePicker({
//   required BuildContext context,
//   required String label,
//   required RichTextEditingController controller,
//   TextSelection? selection,
//   EditorStyleTheme theme = EditorStyleTheme.standard,
// }) async {
//   FocusScope.of(context).unfocus();

//   final bool hasSelection =
//       selection != null &&
//       selection.isValid &&
//       !selection.isCollapsed &&
//       controller.text.isNotEmpty;

//   await showModalBottomSheet<void>(
//     context: context,
//     backgroundColor: Colors.white,
//     isScrollControlled: true,
//     useSafeArea: true,
//     constraints: BoxConstraints(
//       maxHeight: MediaQuery.of(context).size.height * 0.85,
//     ),
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (sheetContext) {
//       return StatefulBuilder(
//         builder: (context, setSheetState) {
//           // Re-read on every build so the buttons, slider and swatches follow
//           // what the selected characters actually carry right now.
//           final SelectionStyleSummary summary = controller.styleForRange(
//             selection,
//           );

//           void apply(void Function() change) {
//             change();

//             setSheetState(() {});
//           }

//           // The preview shows the words that are about to change.
//           String previewText = 'Sample text';

//           final String picked = controller.textForRange(selection);

//           if (picked.trim().isNotEmpty) {
//             previewText = picked.length > 60
//                 ? '${picked.substring(0, 60)}...'
//                 : picked;
//           }

//           return SingleChildScrollView(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           '$label text',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       GestureDetector(
//                         onTap: () {
//                           apply(() {
//                             controller.clearFormatting(selection: selection);
//                           });
//                         },
//                         behavior: HitTestBehavior.opaque,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 4,
//                             vertical: 6,
//                           ),
//                           child: Text(
//                             'Reset',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: theme.accentColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 6),

//                   Text(
//                     hasSelection
//                         ? 'Styling the selected text only.'
//                         : 'Nothing is selected, so this styles the whole '
//                               'field. Select a word first to style just '
//                               'that part.',
//                     style: const TextStyle(
//                       fontSize: 10.5,
//                       height: 1.35,
//                       color: Color(0xff5C5C5C),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // Live text preview.
//                   Container(
//                     width: double.infinity,
//                     constraints: const BoxConstraints(minHeight: 56),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       color: theme.fillColor,
//                       borderRadius: BorderRadius.circular(7),
//                       border: Border.all(color: theme.borderColor),
//                     ),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       previewText,
//                       style: summary.previewStyle.toTextStyle(),
//                     ),
//                   ),

//                   const SizedBox(height: 18),

//                   // Spreadsheet-style formatting buttons.
//                   Row(
//                     children: [
//                       _FormattingButton(
//                         hint: 'B',
//                         tooltip: 'Bold',
//                         selected: summary.bold,
//                         theme: theme,
//                         textStyle: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         onTap: () {
//                           apply(() {
//                             controller.toggleBold(selection: selection);
//                           });
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       _FormattingButton(
//                         hint: 'I',
//                         tooltip: 'Italic',
//                         selected: summary.italic,
//                         theme: theme,
//                         textStyle: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           fontStyle: FontStyle.italic,
//                         ),
//                         onTap: () {
//                           apply(() {
//                             controller.toggleItalic(selection: selection);
//                           });
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       _FormattingButton(
//                         hint: 'U',
//                         tooltip: 'Underline',
//                         selected: summary.underline,
//                         theme: theme,
//                         textStyle: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           decoration: TextDecoration.underline,
//                         ),
//                         onTap: () {
//                           apply(() {
//                             controller.toggleUnderline(selection: selection);
//                           });
//                         },
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   Row(
//                     children: [
//                       const Text(
//                         'Size',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         summary.mixedFontSize
//                             ? 'Mixed'
//                             : '${summary.effectiveFontSize.round()} px',
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Color(0xff5C5C5C),
//                         ),
//                       ),
//                     ],
//                   ),

//                   Slider(
//                     value: summary.effectiveFontSize.clamp(
//                       EditorTextStyle.minFontSize,
//                       EditorTextStyle.maxFontSize,
//                     ),
//                     min: EditorTextStyle.minFontSize,
//                     max: EditorTextStyle.maxFontSize,
//                     divisions:
//                         (EditorTextStyle.maxFontSize -
//                                 EditorTextStyle.minFontSize)
//                             .round(),
//                     activeColor: theme.accentColor,
//                     inactiveColor: theme.accentColor.withOpacity(0.25),
//                     label: '${summary.effectiveFontSize.round()}',
//                     onChanged: (value) {
//                       apply(() {
//                         controller.applyFontSize(value, selection: selection);
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 6),

//                   Row(
//                     children: [
//                       const Text(
//                         'Colour',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       if (summary.mixedColor) ...[
//                         const Spacer(),
//                         const Text(
//                           'Mixed',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Color(0xff5C5C5C),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),

//                   const SizedBox(height: 12),

//                   BlockPicker(
//                     // A mixed selection matches no swatch, which is exactly
//                     // what should be shown: no tick anywhere.
//                     pickerColor: summary.mixedColor
//                         ? const Color(0x00000000)
//                         : summary.effectiveColor,
//                     onColorChanged: (pickedColor) {
//                       apply(() {
//                         controller.applyColor(
//                           pickedColor,
//                           selection: selection,
//                         );
//                       });
//                     },
//                     layoutBuilder: (context, colors, child) {
//                       return SizedBox(
//                         width: double.infinity,
//                         child: Wrap(
//                           spacing: 10,
//                           runSpacing: 10,
//                           children: [
//                             ...colors.map((swatch) => child(swatch)),

//                             // Plus button opens the full colour picker.
//                             GestureDetector(
//                               onTap: () async {
//                                 final Color? pickedColor =
//                                     await _showFullColorPicker(
//                                       context: context,
//                                       startColor: summary.effectiveColor,
//                                       accentColor: theme.accentColor,
//                                     );

//                                 if (pickedColor != null) {
//                                   apply(() {
//                                     controller.applyColor(
//                                       pickedColor,
//                                       selection: selection,
//                                     );
//                                   });
//                                 }
//                               },
//                               behavior: HitTestBehavior.opaque,
//                               child: Container(
//                                 width: 32,
//                                 height: 32,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: theme.borderColor),
//                                 ),
//                                 child: Icon(
//                                   Icons.add,
//                                   size: 18,
//                                   color: theme.accentColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     itemBuilder: (swatch, isCurrentColor, changeColor) {
//                       final bool isDark =
//                           ThemeData.estimateBrightnessForColor(swatch) ==
//                           Brightness.dark;

//                       return GestureDetector(
//                         onTap: changeColor,
//                         behavior: HitTestBehavior.opaque,
//                         child: Container(
//                           width: 32,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: swatch,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isCurrentColor
//                                   ? theme.accentColor
//                                   : const Color(0xffD5D5D5),
//                               width: isCurrentColor ? 2.5 : 1,
//                             ),
//                           ),
//                           child: isCurrentColor
//                               ? Icon(
//                                   Icons.check,
//                                   size: 16,
//                                   color: isDark ? Colors.white : Colors.black,
//                                 )
//                               : null,
//                         ),
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 22),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 44,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(sheetContext);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: theme.accentColor,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                       child: const Text(
//                         'Done',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// /// Compact spreadsheet-style B, I or U button.
// class _FormattingButton extends StatelessWidget {
//   final String hint;
//   final String tooltip;
//   final bool selected;
//   final EditorStyleTheme theme;
//   final TextStyle textStyle;
//   final VoidCallback onTap;

//   const _FormattingButton({
//     required this.hint,
//     required this.tooltip,
//     required this.selected,
//     required this.theme,
//     required this.textStyle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Color foregroundColor = selected
//         ? theme.accentColor
//         : const Color(0xff4F4F4F);

//     return Tooltip(
//       message: tooltip,
//       child: Material(
//         color: selected ? theme.accentColor.withOpacity(0.12) : Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(6),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 150),
//             width: 42,
//             height: 38,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(
//                 color: selected ? theme.accentColor : theme.borderColor,
//                 width: selected ? 1.5 : 1,
//               ),
//             ),
//             child: Text(
//               hint,
//               style: textStyle.copyWith(color: foregroundColor),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Full HSV colour picker.
// ///
// /// Returns null if the dialog is dismissed or cancelled.
// Future<Color?> _showFullColorPicker({
//   required BuildContext context,
//   required Color startColor,
//   required Color accentColor,
// }) {
//   Color picked = startColor;

//   return showDialog<Color>(
//     context: context,
//     builder: (dialogContext) {
//       return AlertDialog(
//         titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
//         contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//         title: const Text(
//           'Pick a colour',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//         ),
//         content: SingleChildScrollView(
//           child: ColorPicker(
//             pickerColor: startColor,
//             onColorChanged: (color) {
//               picked = color;
//             },
//             paletteType: PaletteType.hsvWithHue,
//             enableAlpha: false,
//             displayThumbColor: true,
//             hexInputBar: true,
//             labelTypes: const [ColorLabelType.hex, ColorLabelType.rgb],
//             pickerAreaBorderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(dialogContext);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(dialogContext, picked);
//             },
//             child: Text('Select', style: TextStyle(color: accentColor)),
//           ),
//         ],
//       );
//     },
//   );
// }

// /// Text field with font-size, colour, bold, italic and underline controls.
// ///
// /// Every one of them lands on the text that was selected when the style icon
// /// was tapped. With nothing selected they fall back to the whole field.
// ///
// /// The screen keeps no style state of its own: the controller carries it.
// class StyledInputField extends StatefulWidget {
//   final RichTextEditingController controller;
//   final String hint;

//   final String? styleLabel;

//   final double minHeight;
//   final int maxLines;
//   final bool enabled;

//   final EditorStyleTheme theme;
//   final String styleIconAsset;

//   const StyledInputField({
//     super.key,
//     required this.controller,
//     required this.hint,
//     this.styleLabel,
//     this.minHeight = 44,
//     this.maxLines = 1,
//     this.enabled = true,
//     this.theme = EditorStyleTheme.standard,
//     this.styleIconAsset = 'assets/icons/Group (8).svg',
//   });

//   @override
//   State<StyledInputField> createState() => _StyledInputFieldState();
// }

// class _StyledInputFieldState extends State<StyledInputField> {
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void dispose() {
//     _focusNode.dispose();

//     super.dispose();
//   }

//   /// The selection has to be read BEFORE the sheet opens, because opening one
//   /// drops focus and would otherwise lose the highlighted range. Everything
//   /// inside the sheet works on that saved range, and it is put back when the
//   /// sheet closes so the user can carry on where they were.
//   Future<void> _openStylePicker() async {
//     final TextSelection savedSelection = widget.controller.selection;

//     await showTextStylePicker(
//       context: context,
//       label: widget.styleLabel ?? widget.hint,
//       controller: widget.controller,
//       selection: savedSelection,
//       theme: widget.theme,
//     );

//     if (!mounted || !savedSelection.isValid) return;

//     _focusNode.requestFocus();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       widget.controller.selection = savedSelection;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(minHeight: widget.minHeight),
//       decoration: BoxDecoration(
//         color: widget.theme.fillColor,
//         borderRadius: BorderRadius.circular(7),
//         border: Border.all(color: widget.theme.borderColor),
//       ),
//       child: TextField(
//         controller: widget.controller,
//         focusNode: _focusNode,
//         enabled: widget.enabled,
//         maxLines: widget.maxLines,
//         cursorColor: widget.theme.accentColor,

//         // Only the starting point. The controller overrides size, colour,
//         // bold, italic and underline run by run in buildTextSpan.
//         style: widget.controller.baseStyle.toTextStyle(),
//         textInputAction: widget.maxLines == 1
//             ? TextInputAction.next
//             : TextInputAction.newline,
//         decoration: InputDecoration(
//           hintText: widget.hint,
//           hintStyle: const TextStyle(
//             fontSize: 12,
//             color: Colors.black,
//             fontWeight: FontWeight.normal,
//             fontStyle: FontStyle.normal,
//             decoration: TextDecoration.none,
//           ),
//           suffixIcon: GestureDetector(
//             // A GestureDetector on purpose: a focusable button would steal
//             // focus and collapse the selection before the sheet could read it.
//             onTap: widget.enabled ? _openStylePicker : null,
//             behavior: HitTestBehavior.opaque,
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: SvgPicture.asset(
//                 widget.styleIconAsset,
//                 width: 25,
//                 height: 25,
//               ),
//             ),
//           ),
//           suffixIconConstraints: const BoxConstraints(
//             minWidth: 45,
//             minHeight: 45,
//           ),
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           disabledBorder: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// // import 'package:flutter_svg/flutter_svg.dart';

// // /// Font size, colour and formatting options for one editable field.
// // ///
// // /// Supported formatting:
// // /// - Bold
// // /// - Italic
// // /// - Underline
// // ///
// // /// Also handles converting the text to and from HTML.
// // @immutable
// // class EditorTextStyle {
// //   final double fontSize;
// //   final Color color;
// //   final bool bold;
// //   final bool italic;
// //   final bool underline;

// //   const EditorTextStyle({
// //     this.fontSize = defaultFontSize,
// //     this.color = defaultColor,
// //     this.bold = false,
// //     this.italic = false,
// //     this.underline = false,
// //   });

// //   static const double defaultFontSize = 12;
// //   static const Color defaultColor = Colors.black;

// //   static const double minFontSize = 10;
// //   static const double maxFontSize = 28;

// //   static const EditorTextStyle initial = EditorTextStyle();

// //   EditorTextStyle copyWith({
// //     double? fontSize,
// //     Color? color,
// //     bool? bold,
// //     bool? italic,
// //     bool? underline,
// //   }) {
// //     return EditorTextStyle(
// //       fontSize: fontSize ?? this.fontSize,
// //       color: color ?? this.color,
// //       bold: bold ?? this.bold,
// //       italic: italic ?? this.italic,
// //       underline: underline ?? this.underline,
// //     );
// //   }

// //   TextStyle toTextStyle() {
// //     return TextStyle(
// //       fontSize: fontSize,
// //       color: color,
// //       fontWeight: bold ? FontWeight.bold : FontWeight.normal,
// //       fontStyle: italic ? FontStyle.italic : FontStyle.normal,
// //       decoration: underline ? TextDecoration.underline : TextDecoration.none,
// //       decorationColor: color,
// //     );
// //   }

// //   /// Converts plain text and selected formatting into HTML.
// //   String wrapHtml(String text) {
// //     if (text.isEmpty) {
// //       return '';
// //     }

// //     final String escaped = text
// //         .replaceAll('&', '&amp;')
// //         .replaceAll('<', '&lt;')
// //         .replaceAll('>', '&gt;')
// //         .replaceAll('"', '&quot;')
// //         .replaceAll("'", '&#39;')
// //         .replaceAll('\n', '<br />');

// //     final String hex = color.value
// //         .toRadixString(16)
// //         .padLeft(8, '0')
// //         .substring(2)
// //         .toUpperCase();

// //     final String htmlFontWeight = bold ? 'bold' : 'normal';
// //     final String htmlFontStyle = italic ? 'italic' : 'normal';
// //     final String htmlDecoration = underline ? 'underline' : 'none';

// //     return '<span style="'
// //         'font-size:${fontSize.round()}px;'
// //         'color:#$hex;'
// //         'font-weight:$htmlFontWeight;'
// //         'font-style:$htmlFontStyle;'
// //         'text-decoration:$htmlDecoration;'
// //         '">'
// //         '$escaped'
// //         '</span>';
// //   }

// //   /// Reads formatting from stored HTML.
// //   static EditorTextStyle fromHtml(String? html) {
// //     return EditorTextStyle(
// //       fontSize: _fontSizeFromHtml(html) ?? defaultFontSize,
// //       color: _colorFromHtml(html) ?? defaultColor,
// //       bold: _boldFromHtml(html),
// //       italic: _italicFromHtml(html),
// //       underline: _underlineFromHtml(html),
// //     );
// //   }

// //   /// Removes HTML and returns plain text.
// //   static String stripHtml(String? value) {
// //     if (value == null || value.trim().isEmpty) {
// //       return '';
// //     }

// //     return value
// //         .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
// //         .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
// //         .replaceAll(RegExp(r'</div\s*>', caseSensitive: false), '\n')
// //         .replaceAll(RegExp(r'<[^>]*>'), '')
// //         .replaceAll('&nbsp;', ' ')
// //         .replaceAll('&#160;', ' ')
// //         .replaceAll('&amp;', '&')
// //         .replaceAll('&lt;', '<')
// //         .replaceAll('&gt;', '>')
// //         .replaceAll('&quot;', '"')
// //         .replaceAll('&#39;', "'")
// //         .replaceAll('&#x27;', "'")
// //         .replaceAll(RegExp(r'\n\s*\n'), '\n')
// //         .trim();
// //   }

// //   static double? _fontSizeFromHtml(String? html) {
// //     if (html == null || html.trim().isEmpty) {
// //       return null;
// //     }

// //     final RegExpMatch? match = RegExp(
// //       r'font-size\s*:\s*(\d+(?:\.\d+)?)\s*px',
// //       caseSensitive: false,
// //     ).firstMatch(html);

// //     if (match == null) {
// //       return null;
// //     }

// //     final double? size = double.tryParse(match.group(1) ?? '');

// //     if (size == null) {
// //       return null;
// //     }

// //     return size.clamp(minFontSize, maxFontSize).toDouble();
// //   }

// //   /// Prevents matching background-color.
// //   static Color? _colorFromHtml(String? html) {
// //     if (html == null || html.trim().isEmpty) {
// //       return null;
// //     }

// //     final RegExpMatch? match = RegExp(
// //       r'(?:^|[^-a-zA-Z])color\s*:\s*#([0-9a-fA-F]{6})',
// //       caseSensitive: false,
// //     ).firstMatch(html);

// //     final String? hex = match?.group(1);

// //     if (hex == null) {
// //       return null;
// //     }

// //     return Color(int.parse('FF$hex', radix: 16));
// //   }

// //   static bool _boldFromHtml(String? html) {
// //     if (html == null || html.trim().isEmpty) {
// //       return false;
// //     }

// //     final bool hasCssBold = RegExp(
// //       r'font-weight\s*:\s*(bold|bolder|[6-9]00)',
// //       caseSensitive: false,
// //     ).hasMatch(html);

// //     final bool hasBoldTag = RegExp(
// //       r'<\s*(b|strong)(?:\s[^>]*)?>',
// //       caseSensitive: false,
// //     ).hasMatch(html);

// //     return hasCssBold || hasBoldTag;
// //   }

// //   static bool _italicFromHtml(String? html) {
// //     if (html == null || html.trim().isEmpty) {
// //       return false;
// //     }

// //     final bool hasCssItalic = RegExp(
// //       r'font-style\s*:\s*(italic|oblique)',
// //       caseSensitive: false,
// //     ).hasMatch(html);

// //     final bool hasItalicTag = RegExp(
// //       r'<\s*(i|em)(?:\s[^>]*)?>',
// //       caseSensitive: false,
// //     ).hasMatch(html);

// //     return hasCssItalic || hasItalicTag;
// //   }

// //   static bool _underlineFromHtml(String? html) {
// //     if (html == null || html.trim().isEmpty) {
// //       return false;
// //     }

// //     final bool hasCssUnderline = RegExp(
// //       r'text-decoration(?:-line)?\s*:[^;"]*\bunderline\b',
// //       caseSensitive: false,
// //     ).hasMatch(html);

// //     final bool hasUnderlineTag = RegExp(
// //       r'<\s*u(?:\s[^>]*)?>',
// //       caseSensitive: false,
// //     ).hasMatch(html);

// //     return hasCssUnderline || hasUnderlineTag;
// //   }

// //   @override
// //   bool operator ==(Object other) {
// //     return other is EditorTextStyle &&
// //         other.fontSize == fontSize &&
// //         other.color.value == color.value &&
// //         other.bold == bold &&
// //         other.italic == italic &&
// //         other.underline == underline;
// //   }

// //   @override
// //   int get hashCode {
// //     return Object.hash(fontSize, color.value, bold, italic, underline);
// //   }

// //   @override
// //   String toString() {
// //     return '${fontSize.round()}px '
// //         '$color '
// //         '${bold ? "bold" : "normal"} '
// //         '${italic ? "italic" : "regular"} '
// //         '${underline ? "underline" : "no underline"}';
// //   }
// // }

// // /// Colours used by the picker and input field.
// // class EditorStyleTheme {
// //   final Color accentColor;
// //   final Color fillColor;
// //   final Color borderColor;

// //   const EditorStyleTheme({
// //     this.accentColor = const Color(0xff9B73E6),
// //     this.fillColor = const Color(0xffEEF4FF),
// //     this.borderColor = const Color(0xffB7C4D6),
// //   });

// //   static const EditorStyleTheme standard = EditorStyleTheme();
// // }

// // /// Opens a bottom sheet containing:
// // /// - B, I and U formatting buttons
// // /// - Font-size slider
// // /// - Colour picker
// // Future<void> showTextStylePicker({
// //   required BuildContext context,
// //   required String label,
// //   required EditorTextStyle style,
// //   required ValueChanged<EditorTextStyle> onChanged,
// //   EditorStyleTheme theme = EditorStyleTheme.standard,
// // }) async {
// //   FocusScope.of(context).unfocus();

// //   EditorTextStyle current = style;

// //   await showModalBottomSheet<void>(
// //     context: context,
// //     backgroundColor: Colors.white,
// //     isScrollControlled: true,
// //     useSafeArea: true,
// //     constraints: BoxConstraints(
// //       maxHeight: MediaQuery.of(context).size.height * 0.85,
// //     ),
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //     ),
// //     builder: (sheetContext) {
// //       return StatefulBuilder(
// //         builder: (context, setSheetState) {
// //           void apply(EditorTextStyle next) {
// //             setSheetState(() {
// //               current = next;
// //             });

// //             onChanged(next);
// //           }

// //           return SingleChildScrollView(
// //             padding: EdgeInsets.only(
// //               bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Text(
// //                           '$label text',
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: const TextStyle(
// //                             fontSize: 13,
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       GestureDetector(
// //                         onTap: () {
// //                           apply(EditorTextStyle.initial);
// //                         },
// //                         behavior: HitTestBehavior.opaque,
// //                         child: Padding(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 4,
// //                             vertical: 6,
// //                           ),
// //                           child: Text(
// //                             'Reset',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.w500,
// //                               color: theme.accentColor,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(height: 14),

// //                   // Live text preview.
// //                   Container(
// //                     width: double.infinity,
// //                     constraints: const BoxConstraints(minHeight: 56),
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 14,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: theme.fillColor,
// //                       borderRadius: BorderRadius.circular(7),
// //                       border: Border.all(color: theme.borderColor),
// //                     ),
// //                     alignment: Alignment.centerLeft,
// //                     child: Text('Sample text', style: current.toTextStyle()),
// //                   ),

// //                   const SizedBox(height: 18),

// //                   // Spreadsheet-style formatting buttons.
// //                   Row(
// //                     children: [
// //                       _FormattingButton(
// //                         hint: 'B',
// //                         tooltip: 'Bold',
// //                         selected: current.bold,
// //                         theme: theme,
// //                         textStyle: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         onTap: () {
// //                           apply(current.copyWith(bold: !current.bold));
// //                         },
// //                       ),
// //                       const SizedBox(width: 8),
// //                       _FormattingButton(
// //                         hint: 'I',
// //                         tooltip: 'Italic',
// //                         selected: current.italic,
// //                         theme: theme,
// //                         textStyle: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.w600,
// //                           fontStyle: FontStyle.italic,
// //                         ),
// //                         onTap: () {
// //                           apply(current.copyWith(italic: !current.italic));
// //                         },
// //                       ),
// //                       const SizedBox(width: 8),
// //                       _FormattingButton(
// //                         hint: 'U',
// //                         tooltip: 'Underline',
// //                         selected: current.underline,
// //                         theme: theme,
// //                         textStyle: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.w600,
// //                           decoration: TextDecoration.underline,
// //                         ),
// //                         onTap: () {
// //                           apply(
// //                             current.copyWith(underline: !current.underline),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(height: 20),

// //                   Row(
// //                     children: [
// //                       const Text(
// //                         'Size',
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       Text(
// //                         '${current.fontSize.round()} px',
// //                         style: const TextStyle(
// //                           fontSize: 11,
// //                           color: Color(0xff5C5C5C),
// //                         ),
// //                       ),
// //                     ],
// //                   ),

// //                   Slider(
// //                     value: current.fontSize.clamp(
// //                       EditorTextStyle.minFontSize,
// //                       EditorTextStyle.maxFontSize,
// //                     ),
// //                     min: EditorTextStyle.minFontSize,
// //                     max: EditorTextStyle.maxFontSize,
// //                     divisions:
// //                         (EditorTextStyle.maxFontSize -
// //                                 EditorTextStyle.minFontSize)
// //                             .round(),
// //                     activeColor: theme.accentColor,
// //                     inactiveColor: theme.accentColor.withOpacity(0.25),
// //                     label: '${current.fontSize.round()}',
// //                     onChanged: (value) {
// //                       apply(current.copyWith(fontSize: value));
// //                     },
// //                   ),

// //                   const SizedBox(height: 6),

// //                   const Text(
// //                     'Colour',
// //                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// //                   ),

// //                   const SizedBox(height: 12),

// //                   BlockPicker(
// //                     pickerColor: current.color,
// //                     onColorChanged: (pickedColor) {
// //                       apply(current.copyWith(color: pickedColor));
// //                     },
// //                     layoutBuilder: (context, colors, child) {
// //                       return SizedBox(
// //                         width: double.infinity,
// //                         child: Wrap(
// //                           spacing: 10,
// //                           runSpacing: 10,
// //                           children: [
// //                             ...colors.map((swatch) => child(swatch)),

// //                             // Plus button opens the full colour picker.
// //                             GestureDetector(
// //                               onTap: () async {
// //                                 final Color? pickedColor =
// //                                     await _showFullColorPicker(
// //                                       context: context,
// //                                       startColor: current.color,
// //                                       accentColor: theme.accentColor,
// //                                     );

// //                                 if (pickedColor != null) {
// //                                   apply(current.copyWith(color: pickedColor));
// //                                 }
// //                               },
// //                               behavior: HitTestBehavior.opaque,
// //                               child: Container(
// //                                 width: 32,
// //                                 height: 32,
// //                                 decoration: BoxDecoration(
// //                                   shape: BoxShape.circle,
// //                                   border: Border.all(color: theme.borderColor),
// //                                 ),
// //                                 child: Icon(
// //                                   Icons.add,
// //                                   size: 18,
// //                                   color: theme.accentColor,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                     itemBuilder: (swatch, isCurrentColor, changeColor) {
// //                       final bool isDark =
// //                           ThemeData.estimateBrightnessForColor(swatch) ==
// //                           Brightness.dark;

// //                       return GestureDetector(
// //                         onTap: changeColor,
// //                         behavior: HitTestBehavior.opaque,
// //                         child: Container(
// //                           width: 32,
// //                           height: 32,
// //                           decoration: BoxDecoration(
// //                             color: swatch,
// //                             shape: BoxShape.circle,
// //                             border: Border.all(
// //                               color: isCurrentColor
// //                                   ? theme.accentColor
// //                                   : const Color(0xffD5D5D5),
// //                               width: isCurrentColor ? 2.5 : 1,
// //                             ),
// //                           ),
// //                           child: isCurrentColor
// //                               ? Icon(
// //                                   Icons.check,
// //                                   size: 16,
// //                                   color: isDark ? Colors.white : Colors.black,
// //                                 )
// //                               : null,
// //                         ),
// //                       );
// //                     },
// //                   ),

// //                   const SizedBox(height: 22),

// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 44,
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.pop(sheetContext);
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: theme.accentColor,
// //                         foregroundColor: Colors.white,
// //                         elevation: 0,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(6),
// //                         ),
// //                       ),
// //                       child: const Text(
// //                         'Done',
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       );
// //     },
// //   );
// // }

// // /// Compact spreadsheet-style B, I or U button.
// // class _FormattingButton extends StatelessWidget {
// //   final String hint;
// //   final String tooltip;
// //   final bool selected;
// //   final EditorStyleTheme theme;
// //   final TextStyle textStyle;
// //   final VoidCallback onTap;

// //   const _FormattingButton({
// //     required this.hint,
// //     required this.tooltip,
// //     required this.selected,
// //     required this.theme,
// //     required this.textStyle,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final Color foregroundColor = selected
// //         ? theme.accentColor
// //         : const Color(0xff4F4F4F);

// //     return Tooltip(
// //       message: tooltip,
// //       child: Material(
// //         color: selected ? theme.accentColor.withOpacity(0.12) : Colors.white,
// //         borderRadius: BorderRadius.circular(6),
// //         child: InkWell(
// //           onTap: onTap,
// //           borderRadius: BorderRadius.circular(6),
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 150),
// //             width: 42,
// //             height: 38,
// //             alignment: Alignment.center,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(6),
// //               border: Border.all(
// //                 color: selected ? theme.accentColor : theme.borderColor,
// //                 width: selected ? 1.5 : 1,
// //               ),
// //             ),
// //             child: Text(
// //               hint,
// //               style: textStyle.copyWith(color: foregroundColor),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // /// Full HSV colour picker.
// // ///
// // /// Returns null if the dialog is dismissed or cancelled.
// // Future<Color?> _showFullColorPicker({
// //   required BuildContext context,
// //   required Color startColor,
// //   required Color accentColor,
// // }) {
// //   Color picked = startColor;

// //   return showDialog<Color>(
// //     context: context,
// //     builder: (dialogContext) {
// //       return AlertDialog(
// //         titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
// //         contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
// //         title: const Text(
// //           'Pick a colour',
// //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
// //         ),
// //         content: SingleChildScrollView(
// //           child: ColorPicker(
// //             pickerColor: startColor,
// //             onColorChanged: (color) {
// //               picked = color;
// //             },
// //             paletteType: PaletteType.hsvWithHue,
// //             enableAlpha: false,
// //             displayThumbColor: true,
// //             hexInputBar: true,
// //             labelTypes: const [ColorLabelType.hex, ColorLabelType.rgb],
// //             pickerAreaBorderRadius: BorderRadius.circular(8),
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(dialogContext);
// //             },
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(dialogContext, picked);
// //             },
// //             child: Text('Select', style: TextStyle(color: accentColor)),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }

// // /// Text field with font-size, colour, bold, italic and underline controls.
// // class StyledInputField extends StatelessWidget {
// //   final TextEditingController controller;
// //   final String hint;

// //   final EditorTextStyle style;
// //   final ValueChanged<EditorTextStyle> onStyleChanged;

// //   final String? styleLabel;

// //   final double minHeight;
// //   final int maxLines;
// //   final bool enabled;

// //   final EditorStyleTheme theme;
// //   final String styleIconAsset;

// //   const StyledInputField({
// //     super.key,
// //     required this.controller,
// //     required this.hint,
// //     required this.style,
// //     required this.onStyleChanged,
// //     this.styleLabel,
// //     this.minHeight = 44,
// //     this.maxLines = 1,
// //     this.enabled = true,
// //     this.theme = EditorStyleTheme.standard,
// //     this.styleIconAsset = 'assets/icons/Group (8).svg',
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       constraints: BoxConstraints(minHeight: minHeight),
// //       decoration: BoxDecoration(
// //         color: theme.fillColor,
// //         borderRadius: BorderRadius.circular(7),
// //         border: Border.all(color: theme.borderColor),
// //       ),
// //       child: TextField(
// //         controller: controller,
// //         enabled: enabled,
// //         maxLines: maxLines,
// //         style: style.toTextStyle(),
// //         textInputAction: maxLines == 1
// //             ? TextInputAction.next
// //             : TextInputAction.newline,
// //         decoration: InputDecoration(
// //           hintText: hint,
// //           hintStyle: const TextStyle(
// //             fontSize: 12,
// //             color: Colors.black,
// //             fontWeight: FontWeight.normal,
// //             fontStyle: FontStyle.normal,
// //             decoration: TextDecoration.none,
// //           ),
// //           suffixIcon: GestureDetector(
// //             onTap: enabled
// //                 ? () {
// //                     showTextStylePicker(
// //                       context: context,
// //                       label: styleLabel ?? hint,
// //                       style: style,
// //                       onChanged: onStyleChanged,
// //                       theme: theme,
// //                     );
// //                   }
// //                 : null,
// //             behavior: HitTestBehavior.opaque,
// //             child: Padding(
// //               padding: const EdgeInsets.all(10),
// //               child: SvgPicture.asset(styleIconAsset, width: 25, height: 25),
// //             ),
// //           ),
// //           suffixIconConstraints: const BoxConstraints(
// //             minWidth: 45,
// //             minHeight: 45,
// //           ),
// //           border: InputBorder.none,
// //           enabledBorder: InputBorder.none,
// //           focusedBorder: InputBorder.none,
// //           disabledBorder: InputBorder.none,
// //           contentPadding: const EdgeInsets.symmetric(
// //             horizontal: 12,
// //             vertical: 12,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Path: lib/core/utils/text_stylepicker.dart.dart
///
/// Rich text for the diary fields. Font size, colour, bold, italic and
/// underline are all held PER CHARACTER by [RichTextEditingController], so
/// the style sheet changes the selected words only and leaves the rest of
/// the field alone. With nothing selected it falls back to the whole field,
/// which keeps the old "just tap B" behaviour alive.
///
/// The text travels to the API as inline HTML, one span per formatted run:
///
///   <span style="font-size:12px;color:#000000;...">plain </span>
///   <span style="font-size:18px;color:#E04A4A;font-weight:bold;...">word</span>
///
/// [RichTextEditingController.toHtml] writes it, and
/// [RichTextEditingController.setHtml] reads it back with every run restored.

/// Style of one run of text: one character in the field, or one span of HTML.
@immutable
class EditorTextStyle {
  final double fontSize;
  final Color color;
  final bool bold;
  final bool italic;
  final bool underline;

  const EditorTextStyle({
    this.fontSize = defaultFontSize,
    this.color = defaultColor,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });

  static const double defaultFontSize = 12;
  static const Color defaultColor = Colors.black;

  static const double minFontSize = 10;
  static const double maxFontSize = 28;

  static const EditorTextStyle initial = EditorTextStyle();

  EditorTextStyle copyWith({
    double? fontSize,
    Color? color,
    bool? bold,
    bool? italic,
    bool? underline,
  }) {
    return EditorTextStyle(
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
    );
  }

  TextStyle toTextStyle() {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: color,
    );
  }

  /// Escapes one plain text run so it is safe inside HTML.
  static String escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .replaceAll('\n', '<br />');
  }

  /// Wraps already escaped HTML in the field wide span. The inner HTML may
  /// carry its own <b> and <i> runs.
  String wrapOuterHtml(String innerHtml) {
    if (innerHtml.isEmpty) {
      return '';
    }

    final String hex = color.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();

    final String htmlFontWeight = bold ? 'bold' : 'normal';
    final String htmlFontStyle = italic ? 'italic' : 'normal';
    final String htmlDecoration = underline ? 'underline' : 'none';

    return '<span style="'
        'font-size:${fontSize.round()}px;'
        'color:#$hex;'
        'font-weight:$htmlFontWeight;'
        'font-style:$htmlFontStyle;'
        'text-decoration:$htmlDecoration;'
        '">'
        '$innerHtml'
        '</span>';
  }

  /// Converts plain text and the field wide formatting into HTML.
  String wrapHtml(String text) {
    if (text.isEmpty) {
      return '';
    }

    return wrapOuterHtml(escapeHtml(text));
  }

  /// Reads formatting from stored HTML.
  static EditorTextStyle fromHtml(String? html) {
    return EditorTextStyle(
      fontSize: _fontSizeFromHtml(html) ?? defaultFontSize,
      color: _colorFromHtml(html) ?? defaultColor,
      bold: _boldFromHtml(html),
      italic: _italicFromHtml(html),
      underline: _underlineFromHtml(html),
    );
  }

  /// Same as [fromHtml] but never turns the whole field bold or italic.
  ///
  /// Used by the diary fields: bold and italic come back run by run through
  /// [RichTextEditingController.setHtml], so reading them here as well would
  /// bold the entire field whenever a single word was bold.
  static EditorTextStyle baseFromHtml(String? html) {
    return EditorTextStyle(
      fontSize: _fontSizeFromHtml(html) ?? defaultFontSize,
      color: _colorFromHtml(html) ?? defaultColor,
      underline: _underlineFromHtml(html),
    );
  }

  /// Removes HTML and returns plain text.
  static String stripHtml(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    return value
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</div\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#160;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&#x27;', "'")
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

  /// Prevents matching background-color.
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

    return Color(int.parse('FF$hex', radix: 16));
  }

  static bool _boldFromHtml(String? html) {
    if (html == null || html.trim().isEmpty) {
      return false;
    }

    final bool hasCssBold = RegExp(
      r'font-weight\s*:\s*(bold|bolder|[6-9]00)',
      caseSensitive: false,
    ).hasMatch(html);

    final bool hasBoldTag = RegExp(
      r'<\s*(b|strong)(?:\s[^>]*)?>',
      caseSensitive: false,
    ).hasMatch(html);

    return hasCssBold || hasBoldTag;
  }

  static bool _italicFromHtml(String? html) {
    if (html == null || html.trim().isEmpty) {
      return false;
    }

    final bool hasCssItalic = RegExp(
      r'font-style\s*:\s*(italic|oblique)',
      caseSensitive: false,
    ).hasMatch(html);

    final bool hasItalicTag = RegExp(
      r'<\s*(i|em)(?:\s[^>]*)?>',
      caseSensitive: false,
    ).hasMatch(html);

    return hasCssItalic || hasItalicTag;
  }

  static bool _underlineFromHtml(String? html) {
    if (html == null || html.trim().isEmpty) {
      return false;
    }

    final bool hasCssUnderline = RegExp(
      r'text-decoration(?:-line)?\s*:[^;"]*\bunderline\b',
      caseSensitive: false,
    ).hasMatch(html);

    final bool hasUnderlineTag = RegExp(
      r'<\s*u(?:\s[^>]*)?>',
      caseSensitive: false,
    ).hasMatch(html);

    return hasCssUnderline || hasUnderlineTag;
  }

  @override
  bool operator ==(Object other) {
    return other is EditorTextStyle &&
        other.fontSize == fontSize &&
        other.color.value == color.value &&
        other.bold == bold &&
        other.italic == italic &&
        other.underline == underline;
  }

  @override
  int get hashCode {
    return Object.hash(fontSize, color.value, bold, italic, underline);
  }

  @override
  String toString() {
    return '${fontSize.round()}px '
        '$color '
        '${bold ? "bold" : "normal"} '
        '${italic ? "italic" : "regular"} '
        '${underline ? "underline" : "no underline"}';
  }
}

/// Everything the style sheet needs to know about a selection.
///
/// [fontSize] and [color] are null when the selected characters do not agree
/// on one value, which is how the sheet shows "Mixed" instead of lying.
@immutable
class SelectionStyleSummary {
  /// Style of the first character in the range. Drives the live preview.
  final EditorTextStyle sample;

  /// True only when EVERY character in the range already carries it.
  final bool bold;
  final bool italic;
  final bool underline;

  /// Null when the range mixes more than one size / colour.
  final double? fontSize;
  final Color? color;

  /// True when there is nothing to style, i.e. an empty field.
  final bool isEmpty;

  const SelectionStyleSummary({
    required this.sample,
    required this.bold,
    required this.italic,
    required this.underline,
    required this.fontSize,
    required this.color,
    required this.isEmpty,
  });

  double get effectiveFontSize => fontSize ?? sample.fontSize;

  Color get effectiveColor => color ?? sample.color;

  bool get mixedFontSize => fontSize == null && !isEmpty;

  bool get mixedColor => color == null && !isEmpty;

  /// What the preview box shows.
  EditorTextStyle get previewStyle {
    return sample.copyWith(
      bold: bold,
      italic: italic,
      underline: underline,
      fontSize: effectiveFontSize,
      color: effectiveColor,
    );
  }
}

/// Text controller that keeps one [EditorTextStyle] per character, so size,
/// colour, bold, italic and underline all apply to the SELECTED text only.
///
/// Nothing is field wide any more. The screen no longer holds an
/// [EditorTextStyle] of its own: every run's formatting lives here, goes to
/// the API through [toHtml] and comes back through [setHtml].
class RichTextEditingController extends TextEditingController {
  /// Style given to characters that have none of their own: a fresh field,
  /// text typed into an empty field, and Reset.
  final EditorTextStyle baseStyle;

  /// One entry per character of [text].
  List<EditorTextStyle> _styles = <EditorTextStyle>[];

  RichTextEditingController({
    String? text,
    this.baseStyle = EditorTextStyle.initial,
  }) : super(text: text) {
    _styles = List<EditorTextStyle>.filled(
      super.value.text.length,
      baseStyle,
      growable: true,
    );
  }

  /// Read only copy, handy while debugging.
  List<EditorTextStyle> get characterStyles {
    return List<EditorTextStyle>.unmodifiable(_normalisedStyles());
  }

  /// True when any character differs from [baseStyle].
  bool get hasFormatting {
    return _normalisedStyles().any((EditorTextStyle style) {
      return style != baseStyle;
    });
  }

  List<EditorTextStyle> _normalisedStyles() {
    if (_styles.length != text.length) {
      _styles = List<EditorTextStyle>.filled(
        text.length,
        baseStyle,
        growable: true,
      );
    }

    return _styles;
  }

  @override
  set value(TextEditingValue newValue) {
    final String oldText = super.value.text;

    if (oldText != newValue.text) {
      _syncStyles(oldText, newValue.text);
    }

    super.value = newValue;
  }

  /// Keeps one style per character after an edit. Typed characters inherit the
  /// formatting of the character in front of them, the way any editor behaves.
  void _syncStyles(String oldText, String newText) {
    List<EditorTextStyle> current = _styles;

    if (current.length != oldText.length) {
      current = List<EditorTextStyle>.filled(
        oldText.length,
        baseStyle,
        growable: true,
      );
    }

    final int minLength = min(oldText.length, newText.length);

    int prefix = 0;

    while (prefix < minLength &&
        oldText.codeUnitAt(prefix) == newText.codeUnitAt(prefix)) {
      prefix++;
    }

    int suffix = 0;

    while (suffix < minLength - prefix &&
        oldText.codeUnitAt(oldText.length - suffix - 1) ==
            newText.codeUnitAt(newText.length - suffix - 1)) {
      suffix++;
    }

    final int removedStart = prefix.clamp(0, current.length);
    final int removedEnd = (oldText.length - suffix).clamp(0, current.length);
    final int insertedLength = max(newText.length - suffix - prefix, 0);

    EditorTextStyle inherited = baseStyle;

    if (removedStart > 0 && removedStart <= current.length) {
      inherited = current[removedStart - 1];
    } else if (removedEnd < current.length) {
      inherited = current[removedEnd];
    }

    _styles = <EditorTextStyle>[
      ...current.sublist(0, removedStart),
      ...List<EditorTextStyle>.filled(insertedLength, inherited),
      ...current.sublist(removedEnd),
    ];
  }

  /// The range a style change works on. A collapsed or missing selection means
  /// the whole field, which keeps the old "just tap B" behaviour alive.
  TextRange _resolveRange(TextSelection? selection) {
    final int length = text.length;

    if (selection == null || !selection.isValid || selection.isCollapsed) {
      return TextRange(start: 0, end: length);
    }

    return TextRange(
      start: selection.start.clamp(0, length),
      end: selection.end.clamp(0, length),
    );
  }

  /// What the style sheet shows as active for [selection].
  SelectionStyleSummary styleForRange(TextSelection? selection) {
    final List<EditorTextStyle> styles = _normalisedStyles();
    final TextRange range = _resolveRange(selection);

    if (styles.isEmpty || range.start >= range.end) {
      return SelectionStyleSummary(
        sample: baseStyle,
        bold: false,
        italic: false,
        underline: false,
        fontSize: baseStyle.fontSize,
        color: baseStyle.color,
        isEmpty: true,
      );
    }

    final EditorTextStyle first = styles[range.start];

    bool bold = true;
    bool italic = true;
    bool underline = true;

    double? fontSize = first.fontSize;
    Color? color = first.color;

    for (int i = range.start; i < range.end; i++) {
      final EditorTextStyle style = styles[i];

      if (!style.bold) bold = false;
      if (!style.italic) italic = false;
      if (!style.underline) underline = false;

      if (fontSize != null && style.fontSize != fontSize) {
        fontSize = null;
      }

      if (color != null && style.color.value != color.value) {
        color = null;
      }
    }

    return SelectionStyleSummary(
      sample: first,
      bold: bold,
      italic: italic,
      underline: underline,
      fontSize: fontSize,
      color: color,
      isEmpty: false,
    );
  }

  /// The plain text sitting inside [selection]. Used by the sheet's preview.
  String textForRange(TextSelection? selection) {
    final TextRange range = _resolveRange(selection);

    if (range.start >= range.end) {
      return '';
    }

    return text.substring(range.start, range.end);
  }

  /// Runs [transform] over every character in [selection].
  void applyStyle(
    EditorTextStyle Function(EditorTextStyle style) transform, {
    TextSelection? selection,
  }) {
    final List<EditorTextStyle> styles = _normalisedStyles();
    final TextRange range = _resolveRange(selection);

    if (range.start >= range.end) {
      return;
    }

    for (int i = range.start; i < range.end; i++) {
      styles[i] = transform(styles[i]);
    }

    notifyListeners();
  }

  /// Turns bold on when part of the range is missing it, and off when the
  /// whole range already carries it. Italic and underline behave the same.
  void toggleBold({TextSelection? selection}) {
    final bool enable = !styleForRange(selection).bold;

    applyStyle(
      (EditorTextStyle style) => style.copyWith(bold: enable),
      selection: selection,
    );
  }

  void toggleItalic({TextSelection? selection}) {
    final bool enable = !styleForRange(selection).italic;

    applyStyle(
      (EditorTextStyle style) => style.copyWith(italic: enable),
      selection: selection,
    );
  }

  void toggleUnderline({TextSelection? selection}) {
    final bool enable = !styleForRange(selection).underline;

    applyStyle(
      (EditorTextStyle style) => style.copyWith(underline: enable),
      selection: selection,
    );
  }

  void applyFontSize(double fontSize, {TextSelection? selection}) {
    applyStyle(
      (EditorTextStyle style) => style.copyWith(fontSize: fontSize),
      selection: selection,
    );
  }

  void applyColor(Color color, {TextSelection? selection}) {
    applyStyle(
      (EditorTextStyle style) => style.copyWith(color: color),
      selection: selection,
    );
  }

  /// Drops the range back to [baseStyle]. Used by the sheet's Reset.
  void clearFormatting({TextSelection? selection}) {
    applyStyle((EditorTextStyle _) => baseStyle, selection: selection);
  }

  /// Replaces the text without carrying any formatting over.
  void setPlainText(String value) {
    this.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );

    _styles = List<EditorTextStyle>.filled(
      value.length,
      baseStyle,
      growable: true,
    );

    notifyListeners();
  }

  /// Loads stored HTML: the plain text plus every run's formatting.
  ///
  /// Returns the style of the first character, for callers that still want a
  /// single [EditorTextStyle] to show somewhere.
  EditorTextStyle setHtml(String? html) {
    final _ParsedRichText parsed = _parseRichHtml(html, baseStyle);

    value = TextEditingValue(
      text: parsed.text,
      selection: TextSelection.collapsed(offset: parsed.text.length),
    );

    _styles = List<EditorTextStyle>.from(parsed.styles, growable: true);

    notifyListeners();

    return _styles.isEmpty ? baseStyle : _styles.first;
  }

  /// Inline HTML for the API: one <span> per formatted run, so a single bold
  /// red word travels on its own instead of dragging the whole field with it.
  String toHtml() {
    final String raw = text;

    int start = 0;
    int end = raw.length;

    while (start < end && raw[start].trim().isEmpty) {
      start++;
    }

    while (end > start && raw[end - 1].trim().isEmpty) {
      end--;
    }

    if (start >= end) {
      return '';
    }

    final List<EditorTextStyle> styles = _normalisedStyles();
    final StringBuffer buffer = StringBuffer();

    int runStart = start;

    for (int i = start + 1; i <= end; i++) {
      if (i == end || styles[i] != styles[runStart]) {
        buffer.write(styles[runStart].wrapHtml(raw.substring(runStart, i)));

        runStart = i;
      }
    }

    return buffer.toString();
  }

  /// Draws the field run by run, so one word can be bigger, bold and red
  /// while the rest of the line stays as it was.
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final String raw = text;

    if (raw.isEmpty) {
      return TextSpan(style: style, text: '');
    }

    final List<EditorTextStyle> styles = _normalisedStyles();
    final List<InlineSpan> runs = <InlineSpan>[];

    int runStart = 0;

    for (int i = 1; i <= raw.length; i++) {
      if (i == raw.length || styles[i] != styles[runStart]) {
        runs.add(
          TextSpan(
            text: raw.substring(runStart, i),
            style: (style ?? const TextStyle()).merge(
              styles[runStart].toTextStyle(),
            ),
          ),
        );

        runStart = i;
      }
    }

    return TextSpan(style: style, children: runs);
  }
}

/// Plain text plus one [EditorTextStyle] per character, read out of HTML.
class _ParsedRichText {
  final String text;
  final List<EditorTextStyle> styles;

  const _ParsedRichText(this.text, this.styles);
}

class _OpenTag {
  final String name;
  final EditorTextStyle style;

  const _OpenTag(this.name, this.style);
}

/// Walks the stored HTML and records the size, colour, bold, italic and
/// underline of every character.
///
/// Handles <b>, <strong>, <i>, <em>, <u>, inline CSS on any tag, plus <br>,
/// </p> and </div> as line breaks.
_ParsedRichText _parseRichHtml(String? html, EditorTextStyle base) {
  if (html == null || html.trim().isEmpty) {
    return const _ParsedRichText('', <EditorTextStyle>[]);
  }

  // Plain text that was never wrapped in HTML.
  if (!html.contains('<') && !html.contains('&')) {
    final String plain = html.trim();

    return _ParsedRichText(
      plain,
      List<EditorTextStyle>.filled(plain.length, base, growable: true),
    );
  }

  final StringBuffer buffer = StringBuffer();
  final List<EditorTextStyle> styles = <EditorTextStyle>[];
  final List<_OpenTag> openTags = <_OpenTag>[];

  EditorTextStyle currentStyle() {
    return openTags.isEmpty ? base : openTags.last.style;
  }

  void appendText(String value) {
    if (value.isEmpty) return;

    final EditorTextStyle style = currentStyle();

    buffer.write(value);

    for (int i = 0; i < value.length; i++) {
      styles.add(style);
    }
  }

  final RegExp tokenPattern = RegExp(r'<[^>]*>|[^<]+');
  final RegExp namePattern = RegExp(r'^<\s*/?\s*([a-zA-Z0-9]+)');
  final RegExp doubleQuotedStyle = RegExp(
    r'style\s*=\s*"([^"]*)"',
    caseSensitive: false,
  );
  final RegExp singleQuotedStyle = RegExp(
    r"style\s*=\s*'([^']*)'",
    caseSensitive: false,
  );

  for (final RegExpMatch match in tokenPattern.allMatches(html)) {
    final String piece = match.group(0) ?? '';

    if (!piece.startsWith('<')) {
      appendText(_unescapeHtml(piece));
      continue;
    }

    final String name = (namePattern.firstMatch(piece)?.group(1) ?? '')
        .toLowerCase();

    if (name.isEmpty) {
      continue;
    }

    if (name == 'br') {
      appendText('\n');
      continue;
    }

    final bool isClosing = RegExp(r'^<\s*/').hasMatch(piece);

    if (isClosing) {
      if (name == 'p' || name == 'div') {
        appendText('\n');
      }

      final int index = openTags.lastIndexWhere((tag) => tag.name == name);

      if (index != -1) {
        openTags.removeRange(index, openTags.length);
      }

      continue;
    }

    EditorTextStyle tagStyle = currentStyle();

    switch (name) {
      case 'b':
      case 'strong':
        tagStyle = tagStyle.copyWith(bold: true);
        break;
      case 'i':
      case 'em':
        tagStyle = tagStyle.copyWith(italic: true);
        break;
      case 'u':
      case 'ins':
        tagStyle = tagStyle.copyWith(underline: true);
        break;
      default:
        break;
    }

    final String? inlineStyle =
        doubleQuotedStyle.firstMatch(piece)?.group(1) ??
        singleQuotedStyle.firstMatch(piece)?.group(1);

    if (inlineStyle != null) {
      tagStyle = _applyInlineCss(tagStyle, inlineStyle);
    }

    // Self closing tags never open a range.
    if (!piece.endsWith('/>')) {
      openTags.add(_OpenTag(name, tagStyle));
    }
  }

  final String parsedText = buffer.toString();

  int start = 0;
  int end = parsedText.length;

  while (start < end && parsedText[start].trim().isEmpty) {
    start++;
  }

  while (end > start && parsedText[end - 1].trim().isEmpty) {
    end--;
  }

  return _ParsedRichText(
    parsedText.substring(start, end),
    List<EditorTextStyle>.from(styles.sublist(start, end), growable: true),
  );
}

/// Reads one inline style="..." attribute onto [style].
///
/// Written out property by property so font-weight:normal actually turns bold
/// back off, instead of only ever switching things on.
EditorTextStyle _applyInlineCss(EditorTextStyle style, String css) {
  EditorTextStyle updated = style;

  for (final String declaration in css.split(';')) {
    final int separator = declaration.indexOf(':');

    if (separator == -1) {
      continue;
    }

    final String property = declaration
        .substring(0, separator)
        .trim()
        .toLowerCase();

    final String value = declaration.substring(separator + 1).trim();

    switch (property) {
      case 'font-size':
        final double? size = _parseCssFontSize(value);

        if (size != null) {
          updated = updated.copyWith(fontSize: size);
        }
        break;

      case 'color':
        final Color? color = _parseCssColor(value);

        if (color != null) {
          updated = updated.copyWith(color: color);
        }
        break;

      case 'font-weight':
        final String weight = value.toLowerCase();
        final int? numeric = int.tryParse(weight);

        updated = updated.copyWith(
          bold:
              weight == 'bold' ||
              weight == 'bolder' ||
              (numeric != null && numeric >= 600),
        );
        break;

      case 'font-style':
        final String fontStyle = value.toLowerCase();

        updated = updated.copyWith(
          italic: fontStyle == 'italic' || fontStyle == 'oblique',
        );
        break;

      case 'text-decoration':
      case 'text-decoration-line':
        updated = updated.copyWith(
          underline: value.toLowerCase().contains('underline'),
        );
        break;
    }
  }

  return updated;
}

double? _parseCssFontSize(String value) {
  final RegExpMatch? match = RegExp(r'([\d.]+)').firstMatch(value);

  if (match == null) {
    return null;
  }

  final double? size = double.tryParse(match.group(1) ?? '');

  if (size == null || size <= 0) {
    return null;
  }

  return size
      .clamp(EditorTextStyle.minFontSize, EditorTextStyle.maxFontSize)
      .toDouble();
}

Color? _parseCssColor(String value) {
  final String raw = value.trim().toLowerCase();

  if (raw.startsWith('#')) {
    String hex = raw.substring(1);

    if (hex.length == 3) {
      hex = hex.split('').map((String c) => '$c$c').join();
    }

    if (hex.length == 6) {
      final int? parsed = int.tryParse(hex, radix: 16);

      if (parsed != null) {
        return Color(0xff000000 | parsed);
      }
    }

    return null;
  }

  final RegExpMatch? rgb = RegExp(
    r'rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)',
  ).firstMatch(raw);

  if (rgb != null) {
    return Color.fromARGB(
      255,
      int.parse(rgb.group(1)!).clamp(0, 255),
      int.parse(rgb.group(2)!).clamp(0, 255),
      int.parse(rgb.group(3)!).clamp(0, 255),
    );
  }

  const Map<String, int> namedColors = <String, int>{
    'black': 0xff000000,
    'white': 0xffffffff,
    'red': 0xffff0000,
    'green': 0xff008000,
    'blue': 0xff0000ff,
    'grey': 0xff808080,
    'gray': 0xff808080,
    'orange': 0xffffa500,
    'purple': 0xff800080,
  };

  final int? named = namedColors[raw];

  return named == null ? null : Color(named);
}

String _unescapeHtml(String value) {
  return value
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&#160;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&#x27;', "'")
      .replaceAll('&amp;', '&');
}

/// Colours used by the picker and input field.
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

/// Opens a bottom sheet containing:
/// - B, I and U formatting buttons
/// - Font-size slider
/// - Colour picker
///
/// Everything in it is applied to [selection] on [controller], so only the
/// picked words change. Capture the selection BEFORE calling this: showing a
/// sheet drops focus, and a collapsed selection means the whole field.
Future<void> showTextStylePicker({
  required BuildContext context,
  required String label,
  required RichTextEditingController controller,
  TextSelection? selection,
  EditorStyleTheme theme = EditorStyleTheme.standard,
}) async {
  FocusScope.of(context).unfocus();

  final bool hasSelection =
      selection != null &&
      selection.isValid &&
      !selection.isCollapsed &&
      controller.text.isNotEmpty;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          // Re-read on every build so the buttons, slider and swatches follow
          // what the selected characters actually carry right now.
          final SelectionStyleSummary summary = controller.styleForRange(
            selection,
          );

          // Nothing to reset when the range is uniform and already plain.
          final bool canReset =
              !summary.isEmpty &&
              (summary.mixedFontSize ||
                  summary.mixedColor ||
                  summary.previewStyle != controller.baseStyle);

          void apply(void Function() change) {
            change();

            setSheetState(() {});
          }

          // The preview shows the words that are about to change.
          String previewText = 'Sample text';

          final String picked = controller.textForRange(selection);

          if (picked.trim().isNotEmpty) {
            previewText = picked.length > 60
                ? '${picked.substring(0, 60)}...'
                : picked;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label text',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    hasSelection
                        ? 'Styling the selected text only.'
                        : 'Nothing is selected, so this styles the whole '
                              'field. Select a word first to style just '
                              'that part.',
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.35,
                      color: Color(0xff5C5C5C),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Live text preview.
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 56),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: theme.fillColor,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: theme.borderColor),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      previewText,
                      style: summary.previewStyle.toTextStyle(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Spreadsheet-style formatting buttons.
                  Row(
                    children: [
                      _FormattingButton(
                        hint: 'B',
                        tooltip: 'Bold',
                        selected: summary.bold,
                        theme: theme,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () {
                          apply(() {
                            controller.toggleBold(selection: selection);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _FormattingButton(
                        hint: 'I',
                        tooltip: 'Italic',
                        selected: summary.italic,
                        theme: theme,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                        onTap: () {
                          apply(() {
                            controller.toggleItalic(selection: selection);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _FormattingButton(
                        hint: 'U',
                        tooltip: 'Underline',
                        selected: summary.underline,
                        theme: theme,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        onTap: () {
                          apply(() {
                            controller.toggleUnderline(selection: selection);
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                        summary.mixedFontSize
                            ? 'Mixed'
                            : '${summary.effectiveFontSize.round()} px',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xff5C5C5C),
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    value: summary.effectiveFontSize.clamp(
                      EditorTextStyle.minFontSize,
                      EditorTextStyle.maxFontSize,
                    ),
                    min: EditorTextStyle.minFontSize,
                    max: EditorTextStyle.maxFontSize,
                    divisions:
                        (EditorTextStyle.maxFontSize -
                                EditorTextStyle.minFontSize)
                            .round(),
                    activeColor: theme.accentColor,
                    inactiveColor: theme.accentColor.withOpacity(0.25),
                    label: '${summary.effectiveFontSize.round()}',
                    onChanged: (value) {
                      apply(() {
                        controller.applyFontSize(value, selection: selection);
                      });
                    },
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Text(
                        'Colour',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (summary.mixedColor) ...[
                        const Spacer(),
                        const Text(
                          'Mixed',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff5C5C5C),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  BlockPicker(
                    // A mixed selection matches no swatch, which is exactly
                    // what should be shown: no tick anywhere.
                    pickerColor: summary.mixedColor
                        ? const Color(0x00000000)
                        : summary.effectiveColor,
                    onColorChanged: (pickedColor) {
                      apply(() {
                        controller.applyColor(
                          pickedColor,
                          selection: selection,
                        );
                      });
                    },
                    layoutBuilder: (context, colors, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...colors.map((swatch) => child(swatch)),

                            // Plus button opens the full colour picker.
                            GestureDetector(
                              onTap: () async {
                                final Color? pickedColor =
                                    await _showFullColorPicker(
                                      context: context,
                                      startColor: summary.effectiveColor,
                                      accentColor: theme.accentColor,
                                    );

                                if (pickedColor != null) {
                                  apply(() {
                                    controller.applyColor(
                                      pickedColor,
                                      selection: selection,
                                    );
                                  });
                                }
                              },
                              behavior: HitTestBehavior.opaque,
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
                        behavior: HitTestBehavior.opaque,
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

                  Row(
                    children: [
                      _ResetButton(
                        theme: theme,
                        enabled: canReset,
                        onTap: () {
                          apply(() {
                            controller.clearFormatting(selection: selection);
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.accentColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

/// The Reset button sitting beside Done. Greyed out when the selected text is
/// already plain, so it never looks tappable with nothing to undo.
///
/// Sized to match the Done button: same 44 height and same 6 radius, outlined
/// instead of filled so Done stays the primary action.
class _ResetButton extends StatelessWidget {
  final EditorStyleTheme theme;
  final bool enabled;
  final VoidCallback onTap;

  const _ResetButton({
    required this.theme,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = enabled
        ? theme.accentColor
        : const Color(0xffAFAFAF);

    return Tooltip(
      message: 'Clear formatting',
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? theme.accentColor.withOpacity(0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: enabled ? theme.accentColor : theme.borderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.format_clear, size: 15, color: foregroundColor),
              const SizedBox(width: 6),
              Text(
                'Reset',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact spreadsheet-style B, I or U button.
class _FormattingButton extends StatelessWidget {
  final String hint;
  final String tooltip;
  final bool selected;
  final EditorStyleTheme theme;
  final TextStyle textStyle;
  final VoidCallback onTap;

  const _FormattingButton({
    required this.hint,
    required this.tooltip,
    required this.selected,
    required this.theme,
    required this.textStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = selected
        ? theme.accentColor
        : const Color(0xff4F4F4F);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? theme.accentColor.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: selected ? theme.accentColor : theme.borderColor,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              hint,
              style: textStyle.copyWith(color: foregroundColor),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full HSV colour picker.
///
/// Returns null if the dialog is dismissed or cancelled.
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

/// Text field with font-size, colour, bold, italic and underline controls.
///
/// Every one of them lands on the text that was selected when the style icon
/// was tapped. With nothing selected they fall back to the whole field.
///
/// The screen keeps no style state of its own: the controller carries it.
class StyledInputField extends StatefulWidget {
  final RichTextEditingController controller;
  final String hint;

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
    this.styleLabel,
    this.minHeight = 44,
    this.maxLines = 1,
    this.enabled = true,
    this.theme = EditorStyleTheme.standard,
    this.styleIconAsset = 'assets/icons/Group (8).svg',
  });

  @override
  State<StyledInputField> createState() => _StyledInputFieldState();
}

class _StyledInputFieldState extends State<StyledInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  /// The selection has to be read BEFORE the sheet opens, because opening one
  /// drops focus and would otherwise lose the highlighted range. Everything
  /// inside the sheet works on that saved range, and it is put back when the
  /// sheet closes so the user can carry on where they were.
  Future<void> _openStylePicker() async {
    final TextSelection savedSelection = widget.controller.selection;

    await showTextStylePicker(
      context: context,
      label: widget.styleLabel ?? widget.hint,
      controller: widget.controller,
      selection: savedSelection,
      theme: widget.theme,
    );

    if (!mounted || !savedSelection.isValid) return;

    _focusNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.controller.selection = savedSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: widget.minHeight),
      decoration: BoxDecoration(
        color: widget.theme.fillColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: widget.theme.borderColor),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        cursorColor: widget.theme.accentColor,

        // Only the starting point. The controller overrides size, colour,
        // bold, italic and underline run by run in buildTextSpan.
        style: widget.controller.baseStyle.toTextStyle(),
        textInputAction: widget.maxLines == 1
            ? TextInputAction.next
            : TextInputAction.newline,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            decoration: TextDecoration.none,
          ),
          suffixIcon: GestureDetector(
            // A GestureDetector on purpose: a focusable button would steal
            // focus and collapse the selection before the sheet could read it.
            onTap: widget.enabled ? _openStylePicker : null,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                widget.styleIconAsset,
                width: 25,
                height: 25,
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 45,
            minHeight: 45,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
