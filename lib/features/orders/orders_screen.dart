import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'logic/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Grab the list of saved orders
    final orders = ref.watch(orderProvider);

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
        title: Text('My Orders', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80.sp, color: AppColors.greyColor),
                  SizedBox(height: 16.h),
                  Text('No orders yet', style: AppStyles.black18BoldStyle),
                  SizedBox(height: 8.h),
                  Text('Check out some products and place an order!', style: AppStyles.subtitlesStyles),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, _) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final order = orders[index];
                
                // Format the date simply (YYYY-MM-DD)
                final String formattedDate = order.date.toString().split(' ')[0];
                
                // Calculate total items
                final int totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Order ID & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.id, style: AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Processing', // Hardcoded for UI purposes
                              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      
                      // Date & Item Count
                      Text('$formattedDate  •  $totalItems Items', style: AppStyles.subtitlesStyles),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Divider(color: AppColors.greyColor.withOpacity(0.3), height: 1),
                      ),
                      
                      // Horizontal Image Preview Array!
                      SizedBox(
                        height: 50.w,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: order.items.length,
                          separatorBuilder: (_, _) => SizedBox(width: 8.w),
                          itemBuilder: (context, itemIndex) {
                            final cartItem = order.items[itemIndex];
                            final imageUrl = cartItem.product.images.isNotEmpty 
                                ? cartItem.product.images.first 
                                : 'https://via.placeholder.com/50';

                            return Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Bottom Row: Total Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount', style: AppStyles.subtitlesStyles),
                          Text('\$${order.totalAmount.toStringAsFixed(2)}', style: AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}