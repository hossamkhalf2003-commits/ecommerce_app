import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/cart_item_card.dart';
import 'package:ecommerce_app/core/widgets/primay_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'logic/cart_provider.dart'; // 2. Import your Cart Provider

// 3. Upgrade to ConsumerWidget
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Watch the live cart data and the total math!
    final cartItems = ref.watch(cartProvider);
    final subTotal = ref.watch(cartTotalProvider);
    
    // Dynamic shipping logic: no shipping fee if cart is empty
    final double shippingFee = cartItems.isEmpty ? 0.0 : 80.0;
    final double total = subTotal + shippingFee;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevents back button if this is a main tab
        title: Text('My Cart', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: Column(
        children: [
          // 5. The Scrollable Cart List or Empty State
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80.sp, color: AppColors.greyColor),
                        SizedBox(height: 16.h),
                        Text('Your cart is empty', style: AppStyles.black18BoldStyle),
                        SizedBox(height: 8.h),
                        Text('Start adding some products!', style: AppStyles.subtitlesStyles),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(20.w),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, _) => SizedBox(height: 16.h,width: 16.w,),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item.product;
                      
                      // Safety check for images
                      final String imageUrl = product.images.isNotEmpty 
                          ? product.images.first 
                          : 'https://via.placeholder.com/150';

                      return CartItemCard(
                        title: product.title,
                        size: 'M', // Platzi doesn't have sizes, so we set a default
                        price: product.price,
                        quantity: item.quantity,
                        imageUrl: imageUrl,
                        
                        // 6. Hooking up the buttons directly to the Riverpod Notifier
                        onIncrement: () {
                          ref.read(cartProvider.notifier).addToCart(product);
                        },
                        onDecrement: () {
                          ref.read(cartProvider.notifier).decrementItem(product.id);
                        },
                        onDelete: () {
                          ref.read(cartProvider.notifier).removeItem(product.id);
                        },
                      );
                    },
                  ),
          ),

          // 7. The Pinned Bottom Summary
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(top: BorderSide(color: AppColors.greyColor.withOpacity(0.2))),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildSummaryRow('Sub-total', '\$${subTotal.toStringAsFixed(2)}'),
                  SizedBox(height: 12.h),
                  _buildSummaryRow('VAT (%)', '\$0.00'),
                  SizedBox(height: 12.h),
                  _buildSummaryRow('Shipping fee', '\$${shippingFee.toStringAsFixed(2)}'),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Divider(color: AppColors.greyColor.withOpacity(0.3), thickness: 1),
                  ),
                  
                  _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
                  
                  SizedBox(height: 24.h),
                  
                  PrimayButtonWidget(
                    buttonText: 'Go To Checkout',
                    icon: Icon(Icons.arrow_forward, color: AppColors.whiteColor, size: 20.sp),
                    onPress: cartItems.isEmpty ? null : () {
                      context.pushNamed(AppRoutes.checkoutScreen);
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

  // Helper widget
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: isTotal 
              ? AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold)
              : AppStyles.subtitlesStyles,
        ),
        Text(
          value,
          style: isTotal 
              ? AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold)
              : AppStyles.black15BoldStyle,
        ),
      ],
    );
  }
}