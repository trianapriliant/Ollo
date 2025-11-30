import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'widgets/main_account_card.dart';
import 'widgets/quick_record_section.dart';
import 'widgets/recent_transactions_list.dart';
import 'widgets/dashboard_filter_bar.dart';
import 'widgets/dashboard_menu_grid.dart';
import 'widgets/dashboard_budget_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_filter_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '~ Hi, Norlanda!',
          style: AppTextStyles.h2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardFilterBar(),
              const SizedBox(height: 16),
              const MainAccountCard(),
              const SizedBox(height: 24),
              const DashboardMenuGrid(),
              const SizedBox(height: 24),
              const DashboardBudgetCard(),
              const SizedBox(height: 24),
              const QuickRecordSection(),
              const SizedBox(height: 24),
              transactionsAsync.when(
                data: (transactions) => RecentTransactionsList(transactions: transactions),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 80), // Bottom padding for scrolling
            ],
          ),
        ),
      ),
    );
  }
}
