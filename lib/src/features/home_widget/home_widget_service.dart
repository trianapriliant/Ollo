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

  // Keys for Budget Widget
  static const String keyBudgetSpent = 'budget_spent_text';
  static const String keyBudgetTotal = 'budget_total_text';
  static const String keyBudgetPercent = 'budget_percent_text';
  static const String keyBudgetRemaining = 'budget_remaining_text';
  static const String keyBudgetProgress = 'budget_progress';

  static const String androidBudgetWidgetName = 'OlloBudgetWidgetProvider';

  static Future<void> updateWidgetData({
    double? income,
    double? expense,
    double? balance,
    // New optional params
    double? todayExpense,
    // Budget Params (Optional, default to 0 if not provided)
    double budgetSpent = 0,
    double budgetTotal = 0,
  }) async {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final monthFormat = DateFormat('MMMM yyyy');
    final dayFormat = DateFormat('EEEE'); // e.g. Sunday

    // ... Existing Standard & Gradient Updates ...
    if (income != null) await HomeWidget.saveWidgetData<String>(keyIncome, currencyFormat.format(income));
    if (expense != null) await HomeWidget.saveWidgetData<String>(keyExpense, currencyFormat.format(expense));
    if (balance != null) await HomeWidget.saveWidgetData<String>(keyBalance, currencyFormat.format(balance));
    await HomeWidget.saveWidgetData<String>(keyMonth, monthFormat.format(DateTime.now()));
    
    if (todayExpense != null) await HomeWidget.saveWidgetData<String>(keyTodayExpense, currencyFormat.format(todayExpense));
    await HomeWidget.saveWidgetData<String>(keyTodayDay, dayFormat.format(DateTime.now()));

    // ... Budget Update ...
    if (budgetTotal > 0) {
       final percent = (budgetSpent / budgetTotal * 100).clamp(0, 100).toInt();
       final remaining = budgetTotal - budgetSpent;
       
       await HomeWidget.saveWidgetData<String>(keyBudgetSpent, '${currencyFormat.format(budgetSpent)} used');
       await HomeWidget.saveWidgetData<String>(keyBudgetTotal, '/ ${currencyFormat.format(budgetTotal)}');
       await HomeWidget.saveWidgetData<String>(keyBudgetPercent, '($percent%)');
       await HomeWidget.saveWidgetData<String>(keyBudgetRemaining, 'Remaining: ${currencyFormat.format(remaining)}');
       await HomeWidget.saveWidgetData<int>(keyBudgetProgress, percent); // int for progress bar
    } else {
       // Reset or Empty state
       await HomeWidget.saveWidgetData<String>(keyBudgetSpent, 'No Budget');
       await HomeWidget.saveWidgetData<String>(keyBudgetTotal, '');
       await HomeWidget.saveWidgetData<String>(keyBudgetPercent, '-');
       await HomeWidget.saveWidgetData<String>(keyBudgetRemaining, 'Set a budget in app');
       await HomeWidget.saveWidgetData<int>(keyBudgetProgress, 0);
    }


    // Trigger Widget Updates
    await HomeWidget.updateWidget(
      name: androidWidgetName,
      androidName: androidWidgetName,
    );
    
    await HomeWidget.updateWidget(
      name: androidGradientWidgetName,
      androidName: androidGradientWidgetName,
    );

    await HomeWidget.updateWidget(
      name: androidBudgetWidgetName,
      androidName: androidBudgetWidgetName,
    );
  }
}

