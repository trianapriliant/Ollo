import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../utils/icon_helper.dart';
import '../../../settings/presentation/icon_pack_provider.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../transactions/domain/transaction.dart';
import '../../../../localization/generated/app_localizations.dart';

class TransactionTablePreview extends ConsumerStatefulWidget {
  const TransactionTablePreview({super.key});

  @override
  ConsumerState<TransactionTablePreview> createState() => _TransactionTablePreviewState();
}

class _TransactionTablePreviewState extends ConsumerState<TransactionTablePreview> {
  TransactionType? _selectedType;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    return transactions.where((t) {
      // Type filter
      if (_selectedType != null && t.type != _selectedType) {
        return false;
      }
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final titleMatch = t.title.toLowerCase().contains(query);
        final noteMatch = t.note?.toLowerCase().contains(query) ?? false;
        final categoryMatch = t.categoryName?.toLowerCase().contains(query) ?? false;
        if (!titleMatch && !noteMatch && !categoryMatch) {
          return false;
        }
      }
      return true;
    }).take(8).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionStreamProvider);

    final currency = ref.watch(currencyProvider);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(l10n.transactionLog, style: AppTextStyles.h3),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push('/transaction-table'),
                  child: Row(
                    children: [
                      Text(l10n.viewAll, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                      const SizedBox(width: 4),
                      IconHelper.getIconWidget('chevron_right', pack: ref.watch(iconPackProvider), color: AppColors.primary, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppTextStyles.bodySmall,
              decoration: InputDecoration(
                hintText: l10n.searchTransactions,
                hintStyle: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconHelper.getIconWidget('search', pack: ref.watch(iconPackProvider), color: Colors.grey, size: 18),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter Button - Type Only
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Transaction Type Filter
                _buildFilterPill(
                  label: _selectedType == null
                      ? l10n.filterAll
                      : _selectedType == TransactionType.income
                          ? l10n.income
                          : _selectedType == TransactionType.expense
                              ? l10n.expense
                              : l10n.transfer,
                  onTap: () => _showTypeFilter(context, l10n),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Transaction List
          transactionsAsync.when(
            data: (transactions) {
              final filtered = _filterTransactions(transactions);
              
              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.noTransactionsYet, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                );
              }

              return Column(
                children: filtered.map((t) => _buildTransactionRow(context, ref, t, currency.symbol, dateFormat, l10n)).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(),
          ),

          // View All Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/transaction-table'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(l10n.viewAllTransactions, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[800])),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(BuildContext context, WidgetRef ref, Transaction t, String currency, DateFormat dateFormat, AppLocalizations l10n) {
    final amountColor = t.type == TransactionType.income ? Colors.green : 
                       t.type == TransactionType.expense ? Colors.red : Colors.blue;
    final amountPrefix = t.type == TransactionType.income ? '+' : '-';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/transaction-detail', extra: t),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Date
              SizedBox(
                width: 38,
                child: Text(
                  dateFormat.format(t.date),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[500], fontSize: 11),
                ),
              ),
              
              // Category Icon
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: amountColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: t.subCategoryIcon != null
                      ? IconHelper.getIconWidget(
                          t.subCategoryIcon!,
                          pack: ref.watch(iconPackProvider),
                          size: 14,
                          color: amountColor,
                        )
                      : Icon(Icons.category, size: 14, color: amountColor),
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Title & Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (t.categoryName != null)
                      Text(
                        t.categoryName!,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey, fontSize: 10),
                      ),
                  ],
                ),
              ),
              
              // Amount
              Text(
                '$amountPrefix${_formatAmount(t.amount, currency)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount, String currency) {
    if (amount >= 1000000) {
      return '$currency${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$currency${(amount / 1000).toStringAsFixed(0)}k';
    }
    return '$currency${amount.toStringAsFixed(0)}';
  }

  void _showTypeFilter(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.filterAll),
              trailing: _selectedType == null ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedType = null);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.income),
              trailing: _selectedType == TransactionType.income ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedType = TransactionType.income);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.expense),
              trailing: _selectedType == TransactionType.expense ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedType = TransactionType.expense);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.transfer),
              trailing: _selectedType == TransactionType.transfer ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedType = TransactionType.transfer);
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
