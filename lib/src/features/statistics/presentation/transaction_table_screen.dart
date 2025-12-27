import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/icon_helper.dart';
import '../../settings/presentation/icon_pack_provider.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../../localization/generated/app_localizations.dart';

enum SortOption { dateDesc, dateAsc, amountDesc, amountAsc }
enum DateRangeOption { allTime, thisMonth, lastMonth, last3Months }

class TransactionTableScreen extends ConsumerStatefulWidget {
  const TransactionTableScreen({super.key});

  @override
  ConsumerState<TransactionTableScreen> createState() => _TransactionTableScreenState();
}

class _TransactionTableScreenState extends ConsumerState<TransactionTableScreen> {
  // Filter State - defaults changed
  DateRangeOption _dateRange = DateRangeOption.allTime;
  TransactionType? _selectedType; // null = All
  String? _selectedCategoryId; // null = All
  String _searchQuery = '';
  SortOption _sortOption = SortOption.dateDesc;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateTimeRange _getDateRange() {
    final now = DateTime.now();
    switch (_dateRange) {
      case DateRangeOption.thisMonth:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
      case DateRangeOption.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTimeRange(
          start: lastMonth,
          end: DateTime(now.year, now.month, 0),
        );
      case DateRangeOption.last3Months:
        return DateTimeRange(
          start: DateTime(now.year, now.month - 2, 1),
          end: now,
        );
      case DateRangeOption.allTime:
        return DateTimeRange(
          start: DateTime(2020),
          end: now,
        );
    }
  }

  List<Transaction> _filterAndSort(List<Transaction> transactions) {
    final dateRange = _getDateRange();
    
    var filtered = transactions.where((t) {
      // Date filter
      if (t.date.isBefore(dateRange.start) || t.date.isAfter(dateRange.end.add(const Duration(days: 1)))) {
        return false;
      }
      
      // Type filter
      if (_selectedType != null && t.type != _selectedType) {
        return false;
      }
      
      // Category filter
      if (_selectedCategoryId != null && t.categoryId != _selectedCategoryId) {
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
    }).toList();

    // Sort
    switch (_sortOption) {
      case SortOption.dateDesc:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.dateAsc:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.amountDesc:
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.amountAsc:
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionStreamProvider);
    final currency = ref.watch(currencyProvider);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd MMM');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: IconHelper.getIconWidget('arrow_back', pack: ref.watch(iconPackProvider), color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.transactionLog, style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Row 1: Date Range + Type Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Date Range Filter
                Expanded(
                  child: _buildFilterPill(
                    label: _getDateRangeLabel(l10n),
                    onTap: () => _showDateRangeSheet(context, l10n),
                  ),
                ),
                const SizedBox(width: 8),
                // Type Filter
                Expanded(
                  child: _buildFilterPill(
                    label: _getTypeLabel(l10n),
                    onTap: () => _showTypeSheet(context, l10n),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Row 2: Category + Sort Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Category Filter
                Expanded(
                  child: _buildFilterPill(
                    label: _getCategoryLabel(l10n),
                    onTap: () => _showCategorySheet(context, l10n),
                  ),
                ),
                const SizedBox(width: 8),
                // Sort Filter
                Expanded(
                  child: _buildFilterPill(
                    label: _getSortLabel(l10n),
                    onTap: () => _showSortSheet(context, l10n),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Divider
          Divider(height: 1, color: Colors.grey[200]),

          // Transaction List
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                final filtered = _filterAndSort(transactions);
                
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconHelper.getIconWidget('receipt', pack: ref.watch(iconPackProvider), color: Colors.grey[300], size: 48),
                        const SizedBox(height: 12),
                        Text(l10n.noTransactionsFound, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100], indent: 70),
                  itemBuilder: (context, index) {
                    final t = filtered[index];
                    return _buildTransactionItem(context, t, currency.symbol, dateFormat, l10n);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[700], fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction t, String currency, DateFormat dateFormat, AppLocalizations l10n) {
    final amountColor = t.type == TransactionType.income ? Colors.green : 
                       t.type == TransactionType.expense ? Colors.red : Colors.blue;
    final amountPrefix = t.type == TransactionType.income ? '+' : '-';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/transaction-detail', extra: t),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: amountColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: t.subCategoryIcon != null
                      ? IconHelper.getIconWidget(
                          t.subCategoryIcon!,
                          pack: ref.watch(iconPackProvider),
                          size: 18,
                          color: amountColor,
                        )
                      : Icon(Icons.receipt_long, size: 18, color: amountColor),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Title, Category, and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          t.categoryName ?? '-',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey, fontSize: 11),
                        ),
                        Text(' • ', style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400])),
                        Text(
                          dateFormat.format(t.date),
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey, fontSize: 11),
                        ),
                        Text(' • ', style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400])),
                        Text(
                          _getWalletName(t.walletId),
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Amount
              Text(
                '$amountPrefix${_formatAmount(t.amount, currency)}',
                style: AppTextStyles.bodyMedium.copyWith(
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

  String _getWalletName(String? walletId) {
    if (walletId == null) return '-';
    final walletsAsync = ref.read(walletListProvider);
    return walletsAsync.maybeWhen(
      data: (wallets) {
        final wallet = wallets.cast<dynamic>().firstWhere(
          (w) => (w.externalId ?? w.id.toString()) == walletId,
          orElse: () => null,
        );
        return wallet?.name ?? '-';
      },
      orElse: () => '-',
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

  String _getDateRangeLabel(AppLocalizations l10n) {
    switch (_dateRange) {
      case DateRangeOption.allTime: return l10n.timeFilterAllTime;
      case DateRangeOption.thisMonth: return l10n.timeFilterThisMonth;
      case DateRangeOption.lastMonth: return l10n.lastMonth;
      case DateRangeOption.last3Months: return l10n.last3Months;
    }
  }

  String _getTypeLabel(AppLocalizations l10n) {
    if (_selectedType == null) return l10n.filterAll;
    switch (_selectedType!) {
      case TransactionType.income: return l10n.income;
      case TransactionType.expense: return l10n.expense;
      case TransactionType.transfer: return l10n.transfer;
      default: return l10n.filterAll;
    }
  }

  String _getSortLabel(AppLocalizations l10n) {
    switch (_sortOption) {
      case SortOption.dateDesc: return l10n.dateNewest;
      case SortOption.dateAsc: return l10n.dateOldest;
      case SortOption.amountDesc: return l10n.amountHighest;
      case SortOption.amountAsc: return l10n.amountLowest;
    }
  }

  String _getCategoryLabel(AppLocalizations l10n) {
    if (_selectedCategoryId == null) return l10n.allCategories;
    final categoriesAsync = ref.read(allCategoriesStreamProvider);
    return categoriesAsync.maybeWhen(
      data: (categories) {
        final category = categories.firstWhere(
          (c) => (c.externalId ?? c.id.toString()) == _selectedCategoryId,
          orElse: () => categories.first,
        );
        return category.name;
      },
      orElse: () => l10n.allCategories,
    );
  }

  void _showDateRangeSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(l10n.dateRange, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...DateRangeOption.values.map((option) => ListTile(
              title: Text(_getLabelForDateRange(option, l10n)),
              trailing: _dateRange == option ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _dateRange = option);
                Navigator.pop(ctx);
              },
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getLabelForDateRange(DateRangeOption option, AppLocalizations l10n) {
    switch (option) {
      case DateRangeOption.allTime: return l10n.timeFilterAllTime;
      case DateRangeOption.thisMonth: return l10n.timeFilterThisMonth;
      case DateRangeOption.lastMonth: return l10n.lastMonth;
      case DateRangeOption.last3Months: return l10n.last3Months;
    }
  }

  void _showTypeSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(l10n.transactionType, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
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

  void _showSortSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(l10n.sortBy, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...SortOption.values.map((option) => ListTile(
              title: Text(_getLabelForSort(option, l10n)),
              trailing: _sortOption == option ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _sortOption = option);
                Navigator.pop(ctx);
              },
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getLabelForSort(SortOption option, AppLocalizations l10n) {
    switch (option) {
      case SortOption.dateDesc: return l10n.dateNewest;
      case SortOption.dateAsc: return l10n.dateOldest;
      case SortOption.amountDesc: return l10n.amountHighest;
      case SortOption.amountAsc: return l10n.amountLowest;
    }
  }

  void _showCategorySheet(BuildContext context, AppLocalizations l10n) {
    final categoriesAsync = ref.read(allCategoriesStreamProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(l10n.category, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: categoriesAsync.when(
                  data: (categories) => ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(l10n.allCategories),
                        trailing: _selectedCategoryId == null ? const Icon(Icons.check, color: AppColors.primary) : null,
                        onTap: () {
                          setState(() => _selectedCategoryId = null);
                          Navigator.pop(ctx);
                        },
                      ),
                      ...categories.map((cat) => ListTile(
                        leading: IconHelper.getIconWidget(cat.iconPath, pack: ref.watch(iconPackProvider), size: 20),
                        title: Text(cat.name),
                        trailing: _selectedCategoryId == (cat.externalId ?? cat.id.toString())
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () {
                          setState(() => _selectedCategoryId = cat.externalId ?? cat.id.toString());
                          Navigator.pop(ctx);
                        },
                      )),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
