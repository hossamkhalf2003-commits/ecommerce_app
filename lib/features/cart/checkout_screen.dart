import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/primay_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../orders/logic/order_provider.dart';
import 'logic/cart_provider.dart'; 

// We use ConsumerStatefulWidget so we can show a loading spinner on the button
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  // Fake network delay for processing payment
  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    final currentCartItems = ref.read(cartProvider);
    final subTotal = ref.read(cartTotalProvider);
    final total = subTotal + 80.0;
    // Simulate API call to Stripe / Payment Gateway
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    setState(() => _isProcessing = false);

    // 1. Wipe the cart clean!
    ref.read(orderProvider.notifier).placeOrder(currentCartItems, total);

    // 3. Wipe the cart clean
    ref.invalidate(cartProvider);

    // 4. Show Success Dialog
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Force them to click the button
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          backgroundColor: AppColors.whiteColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
              ),
              SizedBox(height: 24.h),
              Text('Payment Successful!', style: AppStyles.black18BoldStyle),
              SizedBox(height: 8.h),
              Text(
                'Your order is currently being processed. You will receive an email confirmation shortly.',
                textAlign: TextAlign.center,
                style: AppStyles.subtitlesStyles,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close Dialog
                    // Send them all the way back to the Home Screen!
                    context.goNamed(AppRoutes.mainLayoutScreen); 
                  },
                  child: Text('Back to Home', style: AppStyles.black16w500Style.copyWith(color: AppColors.whiteColor)),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the total from the cart
    final cartItems = ref.watch(cartProvider);
    final subTotal = ref.watch(cartTotalProvider);
    final double shippingFee = 80.0;
    final double total = subTotal + shippingFee;

    // Safety fallback: if they somehow get here with an empty cart
    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.whiteColor, elevation: 0),
        body: Center(child: Text('Your cart is empty.')),
      );
    }

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
        title: Text('Checkout', style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SHIPPING ADDRESS SECTION ---
                  Text('Shipping Address', style: AppStyles.black18BoldStyle),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Home',
                    subtitle: '123 Nile Street, 6th of October City\nGiza, Egypt',
                    onEdit: () {}, // Future feature: go to address book
                  ),
                  
                  SizedBox(height: 32.h),

                  // --- PAYMENT METHOD SECTION ---
                  Text('Payment Method', style: AppStyles.black18BoldStyle),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.credit_card_outlined,
                    title: 'Credit Card',
                    subtitle: '**** **** **** 4242',
                    onEdit: () {}, 
                  ),

                  SizedBox(height: 32.h),

                  // --- ORDER SUMMARY SECTION ---
                  Text('Order Summary', style: AppStyles.black18BoldStyle),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Sub-total', '\$${subTotal.toStringAsFixed(2)}'),
                        SizedBox(height: 12.h),
                        _buildSummaryRow('Shipping fee', '\$${shippingFee.toStringAsFixed(2)}'),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Divider(color: AppColors.greyColor.withOpacity(0.3), thickness: 1),
                        ),
                        _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTTOM ACTION BAR ---
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(top: BorderSide(color: AppColors.greyColor.withOpacity(0.2))),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ]
            ),
            child: SafeArea(
              child: _isProcessing 
                ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                : PrimayButtonWidget(
                    buttonText: 'Pay \$${total.toStringAsFixed(2)}',
                    icon: Icon(Icons.lock_outline, color: AppColors.whiteColor, size: 20.sp),
                    onPress: _processPayment,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // UI Helper for the Address/Payment Cards
  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle, required VoidCallback onEdit}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.black16w500Style),
                SizedBox(height: 4.h),
                Text(subtitle, style: AppStyles.subtitlesStyles),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text('Edit', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // UI Helper for the Summary Math
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