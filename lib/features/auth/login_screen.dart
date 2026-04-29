import 'package:ecommerce_app/features/auth/logic/auth_provider.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/custom_text_field.dart';
import 'package:ecommerce_app/core/widgets/primay_button_widget.dart';
import 'package:ecommerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_storage/biometric_helper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  
  bool _isPasswordObscured = true;
  
  // Biometric UI State
  bool _hasBiometrics = false;
  final BiometricHelper _biometricHelper = BiometricHelper();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    
    // Check for hardware so we know if we should draw the fingerprint icon
    _checkBiometricHardware();
  }

  Future<void> _checkBiometricHardware() async {
    final hasHardware = await _biometricHelper.hasBiometrics();
    if (mounted) {
      setState(() {
        _hasBiometrics = hasHardware;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Riverpod Listener: Handles all navigation and error popups automatically!
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error), backgroundColor: Colors.red),
        );
      } else if (next is AuthSuccess) {
        context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(40),
                      Text("Login To Your Account", style: AppStyles.primaryHeadLinesStyle),
                      const HeightSpace(8),
                      Text("It's great to see you again.", style: AppStyles.subtitlesStyles),
                      const HeightSpace(32),
                      
                      Text("Email", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Enter Your Email",
                        validator: (value) => 
                            (value == null || value.isEmpty) ? "Enter Your Email" : null,
                      ),
                      
                      const HeightSpace(16),
                      
                      Text("Password", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "Enter Your Password",
                        obscureText: _isPasswordObscured,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                          child: Icon(
                            _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.greyColor,
                            size: 20.sp,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Enter Your Password";
                          if (value.length < 6) return "Password must be at least 6 characters";
                          return null;
                        },
                      ),
                      
                      const HeightSpace(40),
                      
                      // Primary Manual Login Button
                      authState is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : PrimayButtonWidget(
                              buttonText: "Sign In",
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(authControllerProvider.notifier).login(
                                    _emailController.text, 
                                    _passwordController.text,
                                  );
                                }
                              },
                            ),

                      // Biometric Login Button (Only shows if phone has hardware)
                      if (_hasBiometrics) ...[
                        const HeightSpace(32),
                        Center(
                          child: Text(
                            "Or continue with",
                            style: AppStyles.subtitlesStyles,
                          ),
                        ),
                        const HeightSpace(24),
                        Center(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.r),
                            onTap: () {
                              // We just tell Riverpod to handle the entire biometric flow!
                              ref.read(authControllerProvider.notifier).loginWithBiometrics();
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
                                color: AppColors.greyColor.withOpacity(0.05),
                              ),
                              child: Icon(
                                Icons.fingerprint, 
                                size: 40.sp, 
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Sign Up Text
            SliverFillRemaining(
              hasScrollBody: false, 
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.registerScreen),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppStyles.black15BoldStyle.copyWith(color: AppColors.greyColor),
                        children: [
                          TextSpan(
                            text: "Join",
                            style: AppStyles.black15BoldStyle.copyWith(
                              decoration: TextDecoration.underline,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}