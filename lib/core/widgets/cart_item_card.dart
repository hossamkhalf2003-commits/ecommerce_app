import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemCard extends StatelessWidget {
  final String title;
  final String size;
  final double price;
  final int quantity;
  final String imageUrl;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemCard({
    super.key,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(title, style: AppStyles.black16w500Style,)),
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(Icons.delete_outline, color: AppColors.errorColor, size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text('Size $size', style: AppStyles.grey12MediumStyle),
                SizedBox(height: 12.h),
                
                // Price & Quantity Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ ${price.toStringAsFixed(0)}', // Formats price nicely
                      style: AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        _buildQuantityBtn(Icons.remove, onDecrement),
                        SizedBox(width: 12.w),
                        Text('$quantity', style: AppStyles.black15BoldStyle),
                        SizedBox(width: 12.w),
                        _buildQuantityBtn(Icons.add, onIncrement),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Small helper for the +/- buttons to keep code DRY
  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8ECF4)),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.blackColor),
      ),
    );
  }
}