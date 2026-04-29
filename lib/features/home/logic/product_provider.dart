import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/product_repository.dart';
import '../data/product_model.dart';
import '../data/category_repository.dart';
import '../data/category_model.dart';

// --- CATEGORIES ---
final categoryRepositoryProvider = Provider((ref) => CategoryRepository());

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

// --- THE FILTER STATE ---
// Holds the ID of the selected category. Null means "All".
final selectedCategoryProvider = StateProvider<int?>((ref) => null); 

// --- PRODUCTS ---
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// We only need ONE products provider!
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  // 1. Get the repository
  final repository = ref.watch(productRepositoryProvider);
  
  // 2. Watch the filter state! 
  // If this changes, Riverpod automatically re-runs this entire function.
  final categoryId = ref.watch(selectedCategoryProvider); 

  // 3. Fetch the products (If categoryId is null, your repository should fetch all)
  return await repository.getProducts(categoryId: categoryId);
});