import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/logic/auth_provider.dart';

class MyDetailsScreen extends ConsumerWidget {
  const MyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider);

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
        title: Text('My Details', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: userProfileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load profile details.')),
        data: (user) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Avatar with Edit Badge
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.greyColor.withOpacity(0.2),
                      backgroundImage: NetworkImage(user.avatar),
                      onBackgroundImageError: (_, _) => const Icon(Icons.person, size: 50),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.whiteColor, width: 2),
                      ),
                      child: Icon(Icons.camera_alt_outlined, color: AppColors.whiteColor, size: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // 2. Profile Details Form
                _buildDisabledTextField(label: 'Full Name', initialValue: user.name),
                SizedBox(height: 20.h),
                _buildDisabledTextField(label: 'Email Address', initialValue: user.email),
                SizedBox(height: 20.h),
                
                // Password field (Masked for security visuals)
                _buildDisabledTextField(
                  label: 'Password', 
                  initialValue: '••••••••••••', 
                  isPassword: true,
                ),
                
                SizedBox(height: 40.h),

                // 3. Save Button (Visual only for now, since Platzi doesn't have a PUT user endpoint)
                PrimaryButtonWidget(
                  buttonText: 'Save Changes',
                  onPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile details updated successfully!'),
                        backgroundColor: AppColors.primaryColor,
                      ),
                    );
                    context.pop();
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget to build clean, modern form fields
  Widget _buildDisabledTextField({
    required String label, 
    required String initialValue, 
    bool isPassword = false
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.subtitlesStyles),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: initialValue,
          obscureText: isPassword,
          readOnly: true, // Prevents keyboard from popping up
          style: AppStyles.black16w500Style,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyColor.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword 
                ? Icon(Icons.visibility_off, color: AppColors.greyColor, size: 20.sp)
                : null,
          ),
        ),
      ],
    );
  }
}