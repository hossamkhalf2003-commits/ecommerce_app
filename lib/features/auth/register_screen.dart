import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/custom_text_field.dart';
import 'package:ecommerce_app/core/widgets/primary_button_widget.dart';
import 'package:ecommerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 1. Swapped out SingleChildScrollView for CustomScrollView
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            
            // 2. The main form lives in the top Sliver
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(40),
                      Text("Create An Account", style: AppStyles.primaryHeadLinesStyle),
                      const HeightSpace(8),
                      Text("Let's Create Your Account", style: AppStyles.subtitlesStyles),
                      
                      const HeightSpace(32),
                      
                      Text("Full Name", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: "Enter Your Full Name",
                        validator: (value) => value!.isEmpty ? "Enter Your Full Name" : null,
                      ),
                      
                      const HeightSpace(16),
                      
                      Text("User Name", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: _userNameController,
                        hintText: "Enter Your User Name",
                        validator: (value) => value!.isEmpty ? "Enter Your User Name" : null,
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
                          if (value.length < 8) return "Password must be at least 8 characters";
                          return null;
                        },
                      ),
                      
                      const HeightSpace(16),
                      
                      Text("Confirm Password", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Your Password",
                        obscureText: _isConfirmPasswordObscured,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                          child: Icon(
                            _isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.greyColor,
                            size: 20.sp,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Confirm Your Password";
                          if (value != _passwordController.text) return "Passwords do not match";
                          return null;
                        },
                      ),

                      const HeightSpace(40),
                      PrimaryButtonWidget(
                        buttonText: "Create Account",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            // context.pushNamed(AppRoutes.verifyOtpScreen);
                          }
                        },
                      ),
                      // Added a small buffer here so the button doesn't touch the bottom text on tiny devices
                      const HeightSpace(24), 
                    ],
                  ),
                ),
              ),
            ),

            // 3. The Login link is locked to the bottom with 30 logical pixels of padding
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () => context.pushReplacementNamed(AppRoutes.loginScreen),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: AppStyles.black15BoldStyle.copyWith(color: AppColors.secondaryColor),
                        children: [
                          TextSpan(
                            text: "Log In",
                            style: AppStyles.black15BoldStyle.copyWith(
                              decoration: TextDecoration.underline,
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