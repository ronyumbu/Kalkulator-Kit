class NumberFormatter {
  static String formatNumber(double number) {
    // Convert to string with 2 decimal places
    String numStr = number.toStringAsFixed(2);
    
    // Split into integer and decimal parts
    List<String> parts = numStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];
    
    // Add thousand separators to integer part
    String formattedInteger = _addThousandSeparators(integerPart);
    
    // Remove trailing zeros from decimal part
    decimalPart = decimalPart.replaceAll(RegExp(r'0+$'), '');
    
    // Return formatted number
    if (decimalPart.isEmpty) {
      return formattedInteger;
    } else {
      return '$formattedInteger,$decimalPart';
    }
  }
  
  static String _addThousandSeparators(String number) {
    if (number.length <= 3) return number;
    
    String result = '';
    int count = 0;
    
    // Process from right to left
    for (int i = number.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = '.$result';
        count = 0;
      }
      result = number[i] + result;
      count++;
    }
    
    return result;
  }
}