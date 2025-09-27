import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika input kosong, return as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Hapus semua karakter non-digit
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Jika tidak ada digit, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Format dengan titik sebagai pemisah ribuan
    String formatted = _addThousandsSeparator(digitsOnly);

    // Hitung posisi cursor yang baru
    int cursorPosition = formatted.length;

    // Jika user mengetik di tengah, pertahankan posisi relatif
    if (newValue.selection.baseOffset < newValue.text.length) {
      int digitsBefore = newValue.text
          .substring(0, newValue.selection.baseOffset)
          .replaceAll(RegExp(r'[^\d]'), '')
          .length;

      // Hitung posisi dalam formatted string
      int newPosition = 0;
      int digitCount = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (formatted[i].contains(RegExp(r'\d'))) {
          digitCount++;
          if (digitCount >= digitsBefore) {
            newPosition = i + 1;
            break;
          }
        }
      }
      cursorPosition = newPosition;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _addThousandsSeparator(String value) {
    if (value.length <= 3) {
      return value;
    }

    String result = '';
    int counter = 0;

    // Iterate from right to left
    for (int i = value.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) {
        result = '.$result';
      }
      result = '${value[i]}$result';
      counter++;
    }

    return result;
  }
}
