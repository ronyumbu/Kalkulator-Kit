import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 2,
  );

  static final NumberFormat _currencyFormatNoDecimal = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  /// Format double value to Indonesian Rupiah currency format
  /// Example: 12345.67 -> "Rp12.345,67"
  static String formatCurrency(double value) {
    return _currencyFormat.format(value);
  }

  /// Format double value to Indonesian Rupiah currency format without decimal
  /// Example: 12345.67 -> "Rp12.346"
  static String formatCurrencyNoDecimal(double value) {
    return _currencyFormatNoDecimal.format(value);
  }

  /// Format number with thousand separators (no currency symbol)
  /// Example: 12345.67 -> "12.345,67"
  static String formatNumber(double value) {
    final NumberFormat numberFormat = NumberFormat('#,##0.00', 'id_ID');
    return numberFormat.format(value);
  }

  /// Parse formatted currency string back to double
  /// Example: "Rp12.345,67" -> 12345.67
  static double? parseCurrency(String formattedValue) {
    try {
      // Remove currency symbol and parse
      String cleanValue = formattedValue
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      return double.tryParse(cleanValue);
    } catch (e) {
      return null;
    }
  }
}
