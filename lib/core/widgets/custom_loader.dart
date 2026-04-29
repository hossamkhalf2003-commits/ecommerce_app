import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoader extends StatelessWidget {
  final double? width;
  final double? height;

  const CustomLoader({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loading.json',
        width: width ?? 150.w, // Scales beautifully with ScreenUtil
        height: height ?? 150.w,
        fit: BoxFit.contain,
        // Optional: Add an error builder just in case the JSON path breaks
        errorBuilder: (context, error, stackTrace) {
          return const CircularProgressIndicator(); 
        },
      ),
    );
  }
}