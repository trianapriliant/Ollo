import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Currency {
  final String code;
  final String symbol;
  final String name;
  final int decimalDigits;
  final String? locale;

  const Currency({
    required this.code, 
    required this.symbol, 
    required this.name,
    this.decimalDigits = 2,
    this.locale,
  });

  String format(double amount) {
    if (amount == 0) {
      if (decimalDigits == 0) return '$symbol 0';
      return NumberFormat.currency(
        locale: locale ?? 'en_US',
        symbol: symbol,
        decimalDigits: decimalDigits,
      ).format(0);
    }
    
    final formatter = NumberFormat.currency(
      locale: locale ?? 'en_US',
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }
}

const List<Currency> availableCurrencies = [
  Currency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah', decimalDigits: 2),
  Currency(code: 'USD', symbol: '\$', name: 'US Dollar', decimalDigits: 2),
  Currency(code: 'EUR', symbol: '€', name: 'Euro', decimalDigits: 2),
  Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', decimalDigits: 0),
  Currency(code: 'GBP', symbol: '£', name: 'British Pound', decimalDigits: 2),
  Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', decimalDigits: 2),
  Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', decimalDigits: 2),
  Currency(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar', decimalDigits: 2),
  Currency(code: 'CHF', symbol: 'Fr', name: 'Swiss Franc', decimalDigits: 2),
  Currency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit', decimalDigits: 2),
  Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', decimalDigits: 2),
  Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', decimalDigits: 2),
  Currency(code: 'KRW', symbol: '₩', name: 'South Korean Won', decimalDigits: 0),
  Currency(code: 'THB', symbol: '฿', name: 'Thai Baht', decimalDigits: 2),
  Currency(code: 'VND', symbol: '₫', name: 'Vietnamese Dong', decimalDigits: 0),
  Currency(code: 'PHP', symbol: '₱', name: 'Philippine Peso', decimalDigits: 2),
  Currency(code: 'TWD', symbol: 'NT\$', name: 'New Taiwan Dollar', decimalDigits: 2),
  Currency(code: 'RUB', symbol: '₽', name: 'Russian Ruble', decimalDigits: 2),
  Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real', decimalDigits: 2),
];

class CurrencyNotifier extends StateNotifier<Currency> {
  CurrencyNotifier() : super(availableCurrencies[0]); // Default to IDR

  void setCurrency(Currency currency) {
    state = currency;
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, Currency>((ref) {
  return CurrencyNotifier();
});
