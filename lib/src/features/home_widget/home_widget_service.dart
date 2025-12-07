import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';


class HomeWidgetService {
  static const String appGroupId = 'group.com.ollo.ollo'; // For iOS sharing if needed later
  static const String androidWidgetName = 'OlloWidgetProvider';
  static const String androidGradientWidgetName = 'OlloGradientWidgetProvider';

  // Keys used in Android/iOS to retrieve data
  static const String keyIncome = 'income_amount';
  static const String keyExpense = 'expense_amount';
  static const String keyBalance = 'balance_amount';
  static const String keyMonth = 'current_month';
  
  // New keys for Gradient Widget
  static const String keyTodayExpense = 'today_expense';
  static const String keyTodayDay = 'today_day';

  static Future<void> updateWidgetData({
    required double income,
    required double expense,
    required double balance,
    // New optional params, defaulting to 0/Today if not passed (though we should pass them)
    double todayExpense = 0,
  }) async {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final monthFormat = DateFormat('MMMM yyyy');
    final dayFormat = DateFormat('EEEE'); // e.g. Sunday

    // Save Data to Shared Preferences (via home_widget)
    await HomeWidget.saveWidgetData<String>(keyIncome, currencyFormat.format(income));
    await HomeWidget.saveWidgetData<String>(keyExpense, currencyFormat.format(expense));
    await HomeWidget.saveWidgetData<String>(keyBalance, currencyFormat.format(balance));
    await HomeWidget.saveWidgetData<String>(keyMonth, monthFormat.format(DateTime.now()));
    
    // Save New Data
    await HomeWidget.saveWidgetData<String>(keyTodayExpense, currencyFormat.format(todayExpense)); // Showing as positive or negative? Usually expense is negative or positive red. Let's keep raw sign logic from UI.
    await HomeWidget.saveWidgetData<String>(keyTodayDay, dayFormat.format(DateTime.now()));

    // Trigger Widget Update (Main Widget)
    await HomeWidget.updateWidget(
      name: androidWidgetName,
      androidName: androidWidgetName,
    );
    
    // Trigger Widget Update (Gradient Widget)
    await HomeWidget.updateWidget(
      name: androidGradientWidgetName,
      androidName: androidGradientWidgetName,
    );
  }
}

