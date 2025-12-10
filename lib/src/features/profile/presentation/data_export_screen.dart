import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
// If CustomDatePicker is not flexible enough, we'll use standard showDateRangePicker
import '../../wallets/presentation/wallet_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../profile/application/data_export_service.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
      );
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
               content: Text('File saved to: $path'), 
               backgroundColor: Colors.green,
               duration: const Duration(seconds: 4),
            ),
         );
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Export Data', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Section
             _buildSectionTitle('Date Range'),
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
                        '${DateFormat('dd MMM yyyy').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}',
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
                   _buildChip('This Month', () {
                      final now = DateTime.now();
                      setState(() {
                         _startDate = DateTime(now.year, now.month, 1);
                         _endDate = now;
                      });
                      _refreshCount();
                   }, isSelected: false), // Logic to highlight complex
                   const SizedBox(width: 8),
                   _buildChip('Last Month', () {
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
                   _buildChip('All Time', () {
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
            _buildSectionTitle('Transaction Type'),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTypeChip('All', null),
                  const SizedBox(width: 8),
                  _buildTypeChip('Income', TransactionType.income),
                  const SizedBox(width: 8),
                  _buildTypeChip('Expense', TransactionType.expense),
                  const SizedBox(width: 8),
                  _buildTypeChip('Transfer', TransactionType.transfer),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Wallet Filter
            _buildSectionTitle('Wallet'),
            const SizedBox(height: 12),
            walletsAsync.when(
              data: (wallets) => DropdownButtonFormField<String?>(
                value: _selectedWalletId,
                decoration: _dropdownDecoration(),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Wallets')),
                  ...wallets.map((w) => DropdownMenuItem(
                    value: w.externalId ?? w.id.toString(),
                    child: Text(w.name),
                  )),
                ],
                onChanged: (val) {
                  setState(() => _selectedWalletId = val);
                  _refreshCount();
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),

            // Category Filter
            _buildSectionTitle('Category'),
            const SizedBox(height: 12),
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<String?>(
                value: _selectedCategoryId,
                decoration: _dropdownDecoration(),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Categories')),
                  // Add special categories manually if desired, or skip
                  ...categories.map((c) => DropdownMenuItem(
                    value: c.externalId ?? c.id.toString(),
                    child: Text(c.name),
                  )),
                ],
                onChanged: (val) {
                  setState(() => _selectedCategoryId = val);
                  _refreshCount();
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 48),

            if (_transactionCount == 0 && !_isLoadingCount)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      'No transactions match selected filters.',
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
                            ? 'Calculating...' 
                            : 'Share CSV ($_transactionCount items)',
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
                   label: const Text(
                      "Save to Downloads", 
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)
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

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(16),
         borderSide: BorderSide(color: Colors.grey[200]!),
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
}
