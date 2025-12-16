import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';
import '../../../localization/generated/app_localizations.dart';

final debtsProvider = StreamProvider.autoDispose<List<Debt>>((ref) {
  final repo = ref.watch(debtRepositoryProvider);
  return repo.watchDebts();
});

class DebtsScreen extends ConsumerStatefulWidget {
  const DebtsScreen({super.key});

  @override
  ConsumerState<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends ConsumerState<DebtsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.debtsTitle, style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu actions
            },
            itemBuilder: (BuildContext context) {
              return {
                AppLocalizations.of(context)!.sortByDate,
                AppLocalizations.of(context)!.sortByAmount,
                AppLocalizations.of(context)!.settings
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          const _DebtsSummaryCard(),
          
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: AppLocalizations.of(context)!.iOwe),
                Tab(text: AppLocalizations.of(context)!.owedToMe),
              ],
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _DebtList(type: DebtType.borrowing),
                _DebtList(type: DebtType.lending),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/debts/add');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DebtsSummaryCard extends ConsumerWidget {
  const _DebtsSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(debtsProvider);
    final currency = ref.watch(currencyProvider);

    return debtsAsync.when(
      data: (debts) {
        double totalOwedByMe = 0;
        double totalOwedToMe = 0;

        for (var debt in debts) {
          if (debt.status == DebtStatus.paid) continue;
          
          if (debt.type == DebtType.borrowing) {
            totalOwedByMe += debt.remainingAmount;
          } else {
            totalOwedToMe += debt.remainingAmount;
          }
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.purple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.netBalance, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(
                        currency.format(totalOwedToMe - totalOwedByMe),
                        style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 28),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.iOwe, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text(
                            currency.format(totalOwedByMe),
                            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.owedToMe, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text(
                            currency.format(totalOwedToMe),
                            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
      error: (err, _) => SizedBox(height: 180, child: Center(child: Text('Error: $err'))),
    );
  }
}

class _DebtList extends ConsumerWidget {
  final DebtType type;
  const _DebtList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(debtsProvider);
    final currency = ref.watch(currencyProvider);

    return debtsAsync.when(
      data: (allDebts) {
        final debts = allDebts.where((d) => d.type == type).toList();
        
        if (debts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  type == DebtType.borrowing ? AppLocalizations.of(context)!.debtFree : AppLocalizations.of(context)!.noOneOwesYou,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: debts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final debt = debts[index];
            final isOverdue = !debt.isPaid && debt.dueDate.isBefore(DateTime.now());
            
            return GestureDetector(
              onTap: () => context.push('/debts/detail', extra: debt),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.3), width: 1) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (debt.isPaid ? Colors.green : (type == DebtType.borrowing ? Colors.red : Colors.blue)).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        debt.isPaid ? Icons.check_circle : (type == DebtType.borrowing ? Icons.arrow_downward : Icons.arrow_upward),
                        color: debt.isPaid ? Colors.green : (type == DebtType.borrowing ? Colors.red : Colors.blue),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            debt.personName,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                isOverdue ? Icons.error_outline : Icons.calendar_today_outlined,
                                size: 14,
                                color: isOverdue ? Colors.red : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                debt.isPaid ? AppLocalizations.of(context)!.paidStatus : (isOverdue ? AppLocalizations.of(context)!.overdue : AppLocalizations.of(context)!.dueOnDate(DateFormat('d MMM').format(debt.dueDate))),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: debt.isPaid ? Colors.green : (isOverdue ? Colors.red : Colors.grey),
                                  fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            // Action Section
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                      onPressed: () => context.push('/debts/edit', extra: debt),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                      onPressed: () => _confirmDelete(context, ref, debt), // Need to extract _confirmDelete to be usable here or move logic
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                if (!debt.isPaid && debt.paidAmount > 0)
                  Text(
                    AppLocalizations.of(context)!.amountLeft(currency.format(debt.remainingAmount)),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Debt debt) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteDebt),
        content: Text(AppLocalizations.of(context)!.deleteDebtConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(debtRepositoryProvider).deleteDebt(debt.id);
    }
  }
}
