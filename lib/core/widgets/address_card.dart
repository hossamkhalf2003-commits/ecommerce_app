import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isDefault;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    this.isDefault = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.greyColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Icon
            Icon(
              Icons.location_on_outlined,
              color: AppColors.blackColor,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            
            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Default Badge Row
                  Row(
                    children: [
                      Text(title, style: AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold)),
                      if (isDefault) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Default',
                            style: AppStyles.black15BoldStyle.copyWith(
                              fontSize: 10.sp,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(height: 8.h),
                  
                  // Address Text
                  Text(
                    address,
                    style: AppStyles.subtitlesStyles,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}