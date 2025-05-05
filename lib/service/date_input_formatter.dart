import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  static const int maxLength = 10;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < digitsOnly.length && i < 8; i++) {
      buffer.write(digitsOnly[i]);
      if (i == 1 || i == 3) buffer.write('.');
    }

    final string = buffer.toString();
    final truncated = string.length > maxLength
        ? string.substring(0, maxLength)
        : string;

    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
    );
  }
}