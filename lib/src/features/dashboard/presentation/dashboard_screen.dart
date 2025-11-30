import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'widgets/main_account_card.dart';
import 'widgets/quick_record_section.dart';
import 'widgets/recent_transactions_list.dart';
import 'widgets/dashboard_filter_bar.dart';
import 'widgets/dashboard_menu_grid.dart';
import 'widgets/dashboard_budget_card.dart';
import 'dashboard_filter_provider.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../recurring/application/recurring_transaction_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger recurring transaction processing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recurringTransactionServiceFutureProvider.future).then((service) {
        service.processDueTransactions();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: profileAsync.when(
          data: (profile) => Text(
            '~ Hi, ${profile.name}!',
            style: AppTextStyles.h2,
          ),
          loading: () => Text('~ Hi!', style: AppTextStyles.h2),
          error: (_, __) => Text('~ Hi!', style: AppTextStyles.h2),
        ),
        actions: [
          profileAsync.when(
            data: (profile) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.accentBlue,
                backgroundImage: profile.profileImagePath != null
                    ? FileImage(File(profile.profileImagePath!))
                    : null,
                child: profile.profileImagePath == null
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
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
              const SizedBox(height: 16),
              const DashboardMenuGrid(),
              const SizedBox(height: 16),
              const DashboardBudgetCard(),
              const SizedBox(height: 16),
              const QuickRecordSection(),
              const SizedBox(height: 16),
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
