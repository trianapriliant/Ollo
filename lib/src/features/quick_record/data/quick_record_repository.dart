import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';

class QuickRecordRepository {
  final Ref ref;

  QuickRecordRepository(this.ref);

  Future<List<Category>> getAllCategories() async {
    // Read the FutureProvider here
    final categoryRepo = await ref.read(categoryRepositoryProvider.future);
    return await categoryRepo.getAllCategories();
  }
}

final quickRecordRepositoryProvider = Provider<QuickRecordRepository>((ref) {
  return QuickRecordRepository(ref);
});
