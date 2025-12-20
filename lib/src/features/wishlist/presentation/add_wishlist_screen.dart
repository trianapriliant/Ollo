import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/wishlist_repository.dart';
import '../domain/wishlist.dart';

import '../../../utils/currency_input_formatter.dart';

class AddWishlistScreen extends ConsumerStatefulWidget {
  final Wishlist? wishlistToEdit;

  const AddWishlistScreen({super.key, this.wishlistToEdit});

  @override
  ConsumerState<AddWishlistScreen> createState() => _AddWishlistScreenState();
}

class _AddWishlistScreenState extends ConsumerState<AddWishlistScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _linkController = TextEditingController();
  DateTime? _targetDate;
  String? _imagePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.wishlistToEdit != null) {
      final w = widget.wishlistToEdit!;
      _titleController.text = w.title;
      _priceController.text = NumberFormat.decimalPattern('en_US').format(w.price);
      _linkController.text = w.linkUrl ?? '';
      _targetDate = w.targetDate;
      _imagePath = w.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.wishlistToEdit != null ? AppLocalizations.of(context)!.editWishlist : AppLocalizations.of(context)!.addWishlist, style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (widget.wishlistToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    image: _imagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imagePath == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.primary.withOpacity(0.5)),
                            const SizedBox(height: 8),
                            Text(AppLocalizations.of(context)!.addPhoto, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(AppLocalizations.of(context)!.itemName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _titleController,
              hint: AppLocalizations.of(context)!.itemNameHint,
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(height: 24),

            // Price
            Text(AppLocalizations.of(context)!.priceLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _priceController,
              hint: '0',
              prefix: 'Rp ',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              formatter: CurrencyInputFormatter(),
            ),
            const SizedBox(height: 24),

            // Target Date
            Text(AppLocalizations.of(context)!.targetDateLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _targetDate != null
                          ? DateFormat('EEE, d MMM yyyy').format(_targetDate!)
                          : AppLocalizations.of(context)!.selectDate,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _targetDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Product Link
            Text(AppLocalizations.of(context)!.productLinkLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _linkController,
              hint: AppLocalizations.of(context)!.productLinkHint,
              icon: Icons.link,
              keyboardType: TextInputType.url,
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveWishlist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(widget.wishlistToEdit != null ? AppLocalizations.of(context)!.updateWishlist : AppLocalizations.of(context)!.saveWishlist, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? prefix,
    TextInputType keyboardType = TextInputType.text,
    TextInputFormatter? formatter,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatter != null ? [formatter] : null,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          prefixText: prefix,
          prefixIcon: Icon(icon, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Save image to app directory to persist it
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(image.path);
        final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
        
        setState(() {
          _imagePath = savedImage.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorPickingImage(e.toString()))),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _saveWishlist() async {
    final title = _titleController.text.trim();
    final price = CurrencyInputFormatter.parse(_priceController.text);

    if (title.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorInvalidWishlist)),
      );
      return;
    }

    try {
      final wishlistRepo = ref.read(wishlistRepositoryProvider);

      if (widget.wishlistToEdit != null) {
        // UPDATE
        final wishlist = widget.wishlistToEdit!;
        wishlist.title = title;
        wishlist.price = price;
        wishlist.targetDate = _targetDate;
        wishlist.imagePath = _imagePath;
        wishlist.linkUrl = _linkController.text.isEmpty ? null : _linkController.text;
        
        await wishlistRepo.updateWishlist(wishlist);
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.wishlistUpdated)));
        }
      } else {
        // CREATE
        final newWishlist = Wishlist(
          title: title,
          price: price,
          targetDate: _targetDate,
          imagePath: _imagePath,
          linkUrl: _linkController.text.isEmpty ? null : _linkController.text,
          createdAt: DateTime.now(),
        );
        
        await wishlistRepo.addWishlist(newWishlist);
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.wishlistSaved)));
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
  
  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteWishlistTitle),
        content: Text(AppLocalizations.of(context)!.deleteWishlistConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    
    if (confirm == true && widget.wishlistToEdit != null) {
      try {
        final wishlistRepo = ref.read(wishlistRepositoryProvider);
        await wishlistRepo.deleteWishlist(widget.wishlistToEdit!.id);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.wishlistDeleted)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
