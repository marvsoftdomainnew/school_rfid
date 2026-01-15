import 'package:flutter/services.dart';

/// Converts all alphabetic characters to UPPERCASE.
/// Useful for Section, Name abbreviations, etc.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Allows alphanumeric input where:
/// - Numbers remain unchanged
/// - Alphabets are converted to UPPERCASE
/// Example: kg1 -> KG1
class AlphaNumericUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final upperText = newValue.text.toUpperCase();

    return TextEditingValue(
      text: upperText,
      selection: newValue.selection,
    );
  }
}
