import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Currency {
  final String code;
  final String symbol;
  final String name;

  const Currency({required this.code, required this.symbol, required this.name});

  String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US', // Ensures #,###.## format
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}

const List<Currency> availableCurrencies = [
  Currency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
  Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
  Currency(code: 'EUR', symbol: '€', name: 'Euro'),
  Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
  Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
  Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
  Currency(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
  Currency(code: 'CHF', symbol: 'Fr', name: 'Swiss Franc'),
  Currency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
  Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
  Currency(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
  Currency(code: 'THB', symbol: '฿', name: 'Thai Baht'),
  Currency(code: 'VND', symbol: '₫', name: 'Vietnamese Dong'),
  Currency(code: 'PHP', symbol: '₱', name: 'Philippine Peso'),
  Currency(code: 'TWD', symbol: 'NT\$', name: 'New Taiwan Dollar'),
  Currency(code: 'RUB', symbol: '₽', name: 'Russian Ruble'),
  Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
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
