import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/styling/app_colors.dart';
import '../../../core/styling/app_styles.dart';
import '../../../core/widgets/primary_button_widget.dart';

class LogoutBottomSheet {
  // 1. The static show method requires the context and the callback function
  static void show(BuildContext context, {required VoidCallback onConfirmLogout}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content tightly
            children: [
              // 2. The Drag Handle indicator at the top
              Container(
                width: 48.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 24.h),
              
              // 3. Title
              Text(
                'Logout',
                style: AppStyles.black18BoldStyle.copyWith(
                  color: AppColors.errorColor,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 16.h),
              
              // 4. Subtitle
              Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: AppStyles.subtitlesStyles,
              ),
              SizedBox(height: 32.h),
              
              // 5. Action Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context), // Just closes the sheet
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyles.black16w500Style.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  
                  // Confirm Logout Button
                  Expanded(
                    child: PrimaryButtonWidget(
                      buttonText: 'Yes, Logout',
                      // Trigger the logic passed down from AccountScreen!
                      onPress: onConfirmLogout, 
                    ),
                  ),
                ],
              ),
              
              // Bottom safe area padding
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}