import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final bool allowDecimals;
  final int decimalDigits;

  CurrencyInputFormatter({
    this.allowDecimals = true, 
    this.decimalDigits = 2
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Identify if the user is deleting (handling backspace)
    final isDeleting = oldValue.text.length > newValue.text.length;

    // Remove any existing formatting characters to get pure data
    String cleanText = newValue.text.replaceAll(',', '');
    
    // Prevent multiple decimal points
    if (cleanText.indexOf('.') != cleanText.lastIndexOf('.')) {
      return oldValue; 
    }

    // Handle integer and decimal parts
    String integerPart = cleanText;
    String decimalPart = '';

    if (cleanText.contains('.')) {
      final parts = cleanText.split('.');
      integerPart = parts[0];
      decimalPart = parts.length > 1 ? parts[1] : '';
      
      // Limit decimal digits
      if (decimalPart.length > decimalDigits) {
        decimalPart = decimalPart.substring(0, decimalDigits);
      }
    }

    // Format the integer part with commas
    if (integerPart.isNotEmpty) {
      try {
        final number = int.parse(integerPart);
        // Using en_US pattern locally to force comma separators as requested
        integerPart = NumberFormat.decimalPattern('en_US').format(number);
      } catch (e) {
        // Fallback for extremely large numbers or errors
      }
    }

    // Reconstruct the text
    String newText = integerPart;
    if (cleanText.contains('.') && allowDecimals) {
      newText += '.$decimalPart';
    } 

    // Return logic
    // Be careful with cursor position logic when formatting changes input length
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
  
  /// Helper to parse the raw double value from the formatted string
  static double parse(String text) {
    if (text.isEmpty) return 0.0;
    return double.tryParse(text.replaceAll(',', '')) ?? 0.0;
  }
}
