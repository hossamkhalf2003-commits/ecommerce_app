import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/core/routing/app_routes.dart';

import 'widgets/logout_bottom_sheet.dart';
import '../../features/auth/logic/auth_provider.dart'; 
import '../../features/cart/logic/cart_provider.dart'; 

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the live user profile!
    final userProfileState = ref.watch(userProfileProvider);

    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.inventory_2_outlined, 'title': 'My Orders'},
      {'icon': Icons.person_outline, 'title': 'My Details'},
      {'icon': Icons.home_outlined, 'title': 'Address Book'},
      {'icon': Icons.help_outline, 'title': 'FAQs'},
      {'icon': Icons.headset_mic_outlined, 'title': 'Help Center'},
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, 
        title: Text('Account', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: Column(
        children: [
          // 2. The Dynamic User Profile Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: userProfileState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading profile', style: TextStyle(color: AppColors.errorColor)),
              data: (user) => Row(
                children: [
                  CircleAvatar(
                    radius: 35.r,
                    backgroundColor: AppColors.greyColor.withOpacity(0.3),
                    backgroundImage: NetworkImage(user.avatar),
                    // Fallback icon just in case the image link breaks
                    onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppStyles.black18BoldStyle),
                        SizedBox(height: 4.h),
                        Text(user.email, style: AppStyles.subtitlesStyles),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Divider(color: AppColors.greyColor.withOpacity(0.3), thickness: 8.h),

          // 3. The Menu List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              itemCount: menuItems.length,
              separatorBuilder: (_, __) => Divider(color: AppColors.greyColor.withOpacity(0.5), height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(menuItems[index]['icon'], color: AppColors.blackColor, size: 24.sp),
                  title: Text(menuItems[index]['title'], style: AppStyles.black16w500Style),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.greyColor, size: 16.sp),
                  onTap: () {
                    if (menuItems[index]['title'] == 'Address Book') {
                      context.pushNamed(AppRoutes.addressScreen); 
                    }
                    else if (menuItems[index]['title'] == 'My Orders') {
                      context.pushNamed(AppRoutes.ordersScreen); 
                    }
                    else if (menuItems[index]['title'] == 'My Details') {
                      context.pushNamed(AppRoutes.myDetailsScreen); 
                    }
                  },
                );
              },
            ),
          ),

          // 4. The Logout Button (Unchanged)
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(top: BorderSide(color: AppColors.greyColor.withOpacity(0.3))),
            ),
            child: SafeArea(
              child: InkWell(
                onTap: () {
                  LogoutBottomSheet.show(
                    context, 
                    onConfirmLogout: () async {
                      Navigator.pop(context);
                      await ref.read(authControllerProvider.notifier).logout();
                      ref.invalidate(cartProvider);
                      context.goNamed(AppRoutes.loginScreen);
                    }
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.errorColor, size: 24.sp),
                    SizedBox(width: 12.w),
                    Text(
                      'Logout',
                      style: AppStyles.black16w500Style.copyWith(color: AppColors.errorColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}