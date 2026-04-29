import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/primay_button_widget.dart';
import 'package:ecommerce_app/features/cart/logic/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/data/product_model.dart'; // Import the model!

class ProductDetailsScreen extends ConsumerWidget {
  // 1. Add the ProductModel to the constructor
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override

  Widget build(BuildContext context,WidgetRef ref) {
    // 2. Safety check for the image (same as Home Screen)
    final String imageUrl = product.images.isNotEmpty 
        ? product.images.first 
        : 'https://via.placeholder.com/800';

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => context.pop(), 
        ),
        title: Text('Details', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Presentation Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: AppColors.whiteColor, 
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      // 3. Inject the real image
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  // Product Details
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 4. Inject the real title
                        Text(
                          product.title, 
                          style: AppStyles.black18BoldStyle.copyWith(fontSize: 24.sp)
                        ),
                        SizedBox(height: 12.h),
                        
                        // Rating & Reviews Row (Platzi doesn't send ratings, so we keep this static for UI purposes)
                        Row(
                          children: [
                            Icon(Icons.star, color: const Color(0xFFFFC107), size: 20.sp),
                            SizedBox(width: 4.w),
                            Text(
                              '4.0/5', 
                              style: AppStyles.black15BoldStyle.copyWith(
                                decoration: TextDecoration.underline,
                              )
                            ),
                            SizedBox(width: 8.w),
                            Text('(45 reviews)', style: AppStyles.subtitlesStyles),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        
                        // 5. Inject the real description
                        Text(
                          product.description,
                          style: AppStyles.subtitlesStyles.copyWith(
                            height: 1.6, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pinned Bottom Action Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price', style: AppStyles.subtitlesStyles),
                      SizedBox(height: 4.h),
                      // 6. Inject the real price
                      Text(
                        '\$${product.price.toStringAsFixed(2)}', 
                        style: AppStyles.black18BoldStyle.copyWith(fontSize: 24.sp)
                      ),
                    ],
                  ),
                  
                                  PrimayButtonWidget(
                                    width: 220.w, 
                                    buttonText: 'Add to Cart',
                                    icon: Icon(Icons.shopping_bag_outlined, color: AppColors.whiteColor, size: 20.sp),
                                    onPress: () {
                                      // 3. Trigger Riverpod to add the item!
                                      ref.read(cartProvider.notifier).addToCart(product);
                                      
                                      // 4. Show a success message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product.title} added to cart!'),
                                          backgroundColor: AppColors.primaryColor,
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'View Cart',
                                            textColor: AppColors.whiteColor,
                                            onPressed: () {
                                              // Optional: Navigate to Cart Screen
                                              context.pushNamed(AppRoutes.cartScreen);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }