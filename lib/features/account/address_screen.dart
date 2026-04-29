import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/address_card.dart';
import 'package:ecommerce_app/features/address/logic/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


// 3. Change to ConsumerWidget
class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Watch the live addresses
    final savedAddresses = ref.watch(addressProvider);

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
        title: Text('Address', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Address',
                  style: AppStyles.black16w500Style.copyWith(fontWeight: FontWeight.bold),
                ),
                // Quick addition: A sleek "Add New" text button
                TextButton(
                  onPressed: () {
                    // Navigate to "Add Address Form" in the future
                  },
                  child: Text('Add New', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            SizedBox(height: 16.h),
            
            // Scalable List
            Expanded(
              child: savedAddresses.isEmpty 
              ? Center(child: Text('No addresses saved.', style: AppStyles.subtitlesStyles))
              : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: savedAddresses.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final address = savedAddresses[index];
                  
                  return AddressCard(
                    title: address.title,
                    address: address.address,
                    isDefault: address.isDefault,
                    // 5. Fire the logic when tapped!
                    onTap: () {
                       ref.read(addressProvider.notifier).setDefaultAddress(address.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}