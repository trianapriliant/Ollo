import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/wishlist_repository.dart';
import '../domain/wishlist.dart';

class AddWishlistScreen extends ConsumerStatefulWidget {
  const AddWishlistScreen({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add Wishlist', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
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
                            Text('Add Photo', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text('Item Name', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _titleController,
              hint: 'e.g. New Laptop',
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(height: 24),

            // Price
            Text('Price', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _priceController,
              hint: '0',
              prefix: 'Rp ',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Target Date
            Text('Target Date', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
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
                          : 'Select Date',
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
            Text('Product Link (Optional)', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _linkController,
              hint: 'e.g. https://shopee.co.id/...',
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
                child: const Text('Save to Wishlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        SnackBar(content: Text('Error picking image: $e')),
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
    final priceText = _priceController.text.replaceAll(',', '').trim();
    final price = double.tryParse(priceText);

    if (title.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid title and price')),
      );
      return;
    }

    try {
      final wishlistRepo = ref.read(wishlistRepositoryProvider);
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
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added to wishlist!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
