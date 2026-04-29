// ignore_for_file: unused_result

import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/product_card.dart'; 
import '../../core/widgets/custom_loader.dart'; 
import '../home/logic/product_provider.dart'; 

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  
  Widget _buildCategoryChip({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch both providers at the top
    final categoriesState = ref.watch(categoriesProvider);
    final productsState = ref.watch(productsProvider);

    // 2. THE FULL SCREEN LOADER
    // If either API call is still running, block the whole screen with the Lottie animation
    if (categoriesState.isLoading || productsState.isLoading) {
      return const SafeArea(
        child: Center(
          child: CustomLoader(), // Uses its default 150x150 size
        ),
      );
    }

    // 3. FULL SCREEN ERROR HANDLING
    if (categoriesState.hasError || productsState.hasError) {
      final error = categoriesState.error ?? productsState.error;
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: AppStyles.black16w500Style,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Refresh both if they fail
                  ref.refresh(categoriesProvider);
                  ref.refresh(productsProvider);
                },
                child: const Text('Try Again'),
              )
            ],
          ),
        ),
      );
    }

    // 4. SUCCESS STATE (Both APIs finished successfully)
    // We can safely extract the data now without any null errors!
    final categories = categoriesState.value ?? [];
    final products = productsState.value ?? [];
    final selectedId = ref.watch(selectedCategoryProvider);

    // Now we just build a perfectly clean UI without any Riverpod `.when` logic inside it!
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            
            // Header
            SliverToBoxAdapter(
              child: Text(
                'Discover',
                style: AppStyles.primaryHeadLinesStyle,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Search Row
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyColor),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for clothes...',
                          hintStyle: TextStyle(color: AppColors.greyColor),
                          prefixIcon: Icon(Icons.search, color: AppColors.greyColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, color: AppColors.whiteColor),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Cleaned Up Categories List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1, 
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isAllSelected = selectedId == null;
                      return _buildCategoryChip(
                        title: 'All', 
                        isSelected: isAllSelected, 
                        onTap: () => ref.read(selectedCategoryProvider.notifier).state = null,
                      );
                    }

                    final category = categories[index - 1];
                    final isSelected = selectedId == category.id;

                    return _buildCategoryChip(
                      title: category.name,
                      isSelected: isSelected,
                      onTap: () => ref.read(selectedCategoryProvider.notifier).state = category.id,
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Cleaned Up Product Grid
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, 
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  final String imageUrl = product.images.isNotEmpty 
                      ? product.images.first 
                      : 'https://via.placeholder.com/150';

                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.productDetailsScreen,
                        extra: product, 
                      );                    
                    },
                    child: ProductCard(
                      title: product.title,
                      price: '\$${product.price.toStringAsFixed(2)}',
                      imageUrl: imageUrl,
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}