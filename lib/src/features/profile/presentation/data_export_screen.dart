import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/icon_helper.dart';

// If CustomDatePicker is not flexible enough, we'll use standard showDateRangePicker
import '../../wallets/presentation/wallet_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../profile/application/data_export_service.dart';
import '../../subscription/presentation/premium_provider.dart';
import '../../subscription/presentation/widgets/premium_gate_widget.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../settings/presentation/icon_pack_provider.dart';

class DataExportScreen extends ConsumerStatefulWidget {
  const DataExportScreen({super.key});

  @override
  ConsumerState<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends ConsumerState<DataExportScreen> {
  // Filters
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String? _selectedWalletId;
  String? _selectedCategoryId;
  TransactionType? _selectedType;

  // State
  int _transactionCount = 0;
  bool _isLoadingCount = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Initialize defaults (e.g. This Month)
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
    
    _refreshCount();
  }

  void _refreshCount() async {
    if (!mounted) return;
    setState(() => _isLoadingCount = true);
    
    try {
      final service = ref.read(dataExportServiceProvider);
      final count = await service.getFilteredTransactionCount(
        startDate: _startDate,
        endDate: _endDate,
        walletId: _selectedWalletId,
        categoryId: _selectedCategoryId,
        type: _selectedType,
      );
      
      if (mounted) {
        setState(() {
          _transactionCount = count;
          _isLoadingCount = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingCount = false);
    }
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      final service = ref.read(dataExportServiceProvider);
      await service.exportTransactionsToCsv(
        startDate: _startDate,
        endDate: _endDate,
        walletId: _selectedWalletId,
        categoryId: _selectedCategoryId,
        type: _selectedType,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.exportFailed(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleSaveToDownloads() async {
    setState(() => _isExporting = true);
    try {
      final service = ref.read(dataExportServiceProvider);
      final path = await service.saveToDownloads(
        startDate: _startDate,
        endDate: _endDate,
        walletId: _selectedWalletId,
        categoryId: _selectedCategoryId,
        type: _selectedType,
      );
      
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
               content: Text(AppLocalizations.of(context)!.fileSavedTo(path)), 
               backgroundColor: Colors.green,
               duration: const Duration(seconds: 4),
            ),
         );
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.saveFailed(e.toString())), backgroundColor: Colors.red),
         );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _refreshCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletListProvider);
    final categoriesAsync = ref.watch(allCategoriesStreamProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);
    final hasPremiumAccess = isPremium || isVip;

    // Show premium gate for free users
    if (!hasPremiumAccess) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(AppLocalizations.of(context)!.exportDataTitle, style: AppTextStyles.h2),
          centerTitle: true,
        ),
        body: PremiumGateWidget(
          featureName: AppLocalizations.of(context)!.exportDataTitle,
          featureDescription: 'Export your transactions to CSV or Excel',
          showPreview: false,
          child: const SizedBox.shrink(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.exportDataTitle, style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Section
             _buildSectionTitle(AppLocalizations.of(context)!.dateRange),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_startDate)} - ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_endDate)}',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Quick Presets
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   _buildChip(AppLocalizations.of(context)!.timeFilterThisMonth, () {
                      final now = DateTime.now();
                      setState(() {
                         _startDate = DateTime(now.year, now.month, 1);
                         _endDate = now;
                      });
                      _refreshCount();
                   }, isSelected: false), // Logic to highlight complex
                   const SizedBox(width: 8),
                   _buildChip(AppLocalizations.of(context)!.lastMonth, () {
                      final now = DateTime.now();
                      final start = DateTime(now.year, now.month - 1, 1);
                      final end = DateTime(now.year, now.month, 0);
                      setState(() {
                         _startDate = start;
                         _endDate = end;
                      });
                      _refreshCount();
                   }, isSelected: false),
                   const SizedBox(width: 8),
                   _buildChip(AppLocalizations.of(context)!.timeFilterAllTime, () {
                      setState(() {
                         _startDate = DateTime(2020);
                         _endDate = DateTime.now();
                      });
                      _refreshCount();
                   }, isSelected: false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Type Filter
            _buildSectionTitle(AppLocalizations.of(context)!.transactionType),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTypeChip(AppLocalizations.of(context)!.filterAll, null),
                  const SizedBox(width: 8),
                  _buildTypeChip(AppLocalizations.of(context)!.income, TransactionType.income),
                  const SizedBox(width: 8),
                  _buildTypeChip(AppLocalizations.of(context)!.expense, TransactionType.expense),
                  const SizedBox(width: 8),
                  _buildTypeChip(AppLocalizations.of(context)!.transfer, TransactionType.transfer),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Wallet Filter
            _buildSectionTitle(AppLocalizations.of(context)!.wallet),
            const SizedBox(height: 12),
            walletsAsync.when(
              data: (wallets) {
                 final selectedWallet = wallets.cast<dynamic>().firstWhere(
                     (w) => (w.externalId ?? w.id.toString()) == _selectedWalletId, 
                     orElse: () => null
                 );
                 return GestureDetector(
                    onTap: () => _showWalletPicker(wallets),
                    child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                       decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                       ),
                       child: Row(
                          children: [
                             Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                   color: AppColors.primary.withOpacity(0.1),
                                   borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconHelper.getIconWidget('wallet', pack: ref.watch(iconPackProvider), color: AppColors.primary, size: 20),
                             ),
                             const SizedBox(width: 12),
                             Expanded(
                                child: Text(
                                   selectedWallet?.name ?? AppLocalizations.of(context)!.allWallets,
                                   style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                                ),
                             ),
                             IconHelper.getIconWidget('keyboard_arrow_down', pack: ref.watch(iconPackProvider), color: Colors.grey),
                          ],
                       ),
                    ),
                 );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),

            // Category Filter
            _buildSectionTitle(AppLocalizations.of(context)!.category),
            const SizedBox(height: 12),
            categoriesAsync.when(
              data: (categories) {
                 final selectedCategory = categories.cast<dynamic>().firstWhere(
                    (c) => (c.externalId ?? c.id.toString()) == _selectedCategoryId,
                    orElse: () => null
                 );
                 
                 return GestureDetector(
                    onTap: () => _showCategoryPicker(categories),
                    child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                       decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                       ),
                       child: Row(
                          children: [
                             Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                   color: AppColors.primary.withOpacity(0.1),
                                   borderRadius: BorderRadius.circular(10),
                                ),
                              child: selectedCategory != null 
                                  ? IconHelper.getIconWidget(
                                      selectedCategory.iconPath,
                                      pack: ref.read(iconPackProvider),
                                      color: Color(selectedCategory.colorValue ?? 0xFF000000).withOpacity(1.0),
                                      size: 20,
                                    )
                                  : IconHelper.getIconWidget(
                                      'category',
                                      pack: ref.read(iconPackProvider),
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                             ),
                             const SizedBox(width: 12),
                             Expanded(
                                child: Text(
                                   selectedCategory?.name ?? AppLocalizations.of(context)!.allCategories,
                                   style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                                ),
                             ),
                             IconHelper.getIconWidget('keyboard_arrow_down', pack: ref.watch(iconPackProvider), color: Colors.grey),
                          ],
                       ),
                    ),
                 );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 48),

            if (_transactionCount == 0 && !_isLoadingCount)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.noTransactionsMatch,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
                    ),
                  ),
                ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Export Button (Share)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isExporting || _transactionCount == 0 
                    ? null 
                    : _handleExport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  icon: _isExporting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.share),
                  label: Text(
                        _isLoadingCount 
                            ? AppLocalizations.of(context)!.calculating 
                            : AppLocalizations.of(context)!.shareCsv(_transactionCount),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        ),
                    ),
                ),
              ),
              const SizedBox(height: 12),
              // Save to Downloads Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                   onPressed: _isExporting || _transactionCount == 0 
                    ? null 
                    : _handleSaveToDownloads,
                   style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   ),
                   icon: const Icon(Icons.download, color: AppColors.primary),
                   label: Text(
                      AppLocalizations.of(context)!.saveToDownloads, 
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)
                   ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.bold, 
        color: AppColors.textSecondary
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onTap, {required bool isSelected}) {
     return InkWell(
        onTap: onTap,
        child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
           decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
           ),
           child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                 color: isSelected ? Colors.white : AppColors.textPrimary,
                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
           ),
        ),
     );
  }

  Widget _buildTypeChip(String label, TransactionType? type) {
    bool isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() => _selectedType = type);
        _refreshCount();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showWalletPicker(List<dynamic> wallets) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.selectWallet,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _selectedWalletId == null ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: IconHelper.getIconWidget('wallet', pack: ref.read(iconPackProvider), 
                          color: _selectedWalletId == null ? AppColors.primary : Colors.grey[700]),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.allWallets,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: _selectedWalletId == null ? FontWeight.w600 : FontWeight.w500,
                          color: _selectedWalletId == null ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      trailing: _selectedWalletId == null 
                          ? IconHelper.getIconWidget('check_circle', pack: ref.read(iconPackProvider), color: AppColors.primary, size: 24)
                          : null,
                      onTap: () {
                        setState(() => _selectedWalletId = null);
                        _refreshCount();
                        context.pop();
                      },
                    ),
                    ...wallets.map((w) {
                      final isSelected = (w.externalId ?? w.id.toString()) == _selectedWalletId;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: IconHelper.getIconWidget('wallet', pack: ref.read(iconPackProvider), 
                            color: isSelected ? AppColors.primary : Colors.grey[700]),
                        ),
                        title: Text(
                          w.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected 
                            ? IconHelper.getIconWidget('check_circle', pack: ref.read(iconPackProvider), color: AppColors.primary, size: 24)
                            : null,
                        onTap: () {
                          setState(() => _selectedWalletId = w.externalId ?? w.id.toString());
                          _refreshCount();
                          context.pop();
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryPicker(List<dynamic> categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.selectCategory,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _selectedCategoryId == null ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: IconHelper.getIconWidget('category', pack: ref.read(iconPackProvider), 
                          color: _selectedCategoryId == null ? AppColors.primary : Colors.grey[700]),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.allCategories,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: _selectedCategoryId == null ? FontWeight.w600 : FontWeight.w500,
                          color: _selectedCategoryId == null ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      trailing: _selectedCategoryId == null 
                          ? IconHelper.getIconWidget('check_circle', pack: ref.read(iconPackProvider), color: AppColors.primary, size: 24)
                          : null,
                      onTap: () {
                        setState(() => _selectedCategoryId = null);
                        _refreshCount();
                        context.pop();
                      },
                    ),
                    ...categories.map((c) {
                      final isSelected = (c.externalId ?? c.id.toString()) == _selectedCategoryId;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: IconHelper.getIconWidget(
                            c.iconPath,
                            pack: ref.read(iconPackProvider),
                            color: isSelected ? AppColors.primary : (Color(c.colorValue ?? 0xFF000000).withOpacity(1.0)),
                          ),
                        ),
                        title: Text(
                          c.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected 
                            ? IconHelper.getIconWidget('check_circle', pack: ref.read(iconPackProvider), color: AppColors.primary, size: 24)
                            : null,
                        onTap: () {
                          setState(() => _selectedCategoryId = c.externalId ?? c.id.toString());
                          _refreshCount();
                          context.pop();
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
