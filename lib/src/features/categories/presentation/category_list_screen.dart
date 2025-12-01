import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_text_styles.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider(CategoryType.expense)); // Default to expense

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: AppTextStyles.h2),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(category.colorValue ?? 0xFF9E9E9E),
                  child: Icon(Icons.category, color: Colors.white),
                ),
                title: Text(category.name),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
