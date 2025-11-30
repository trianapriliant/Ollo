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
