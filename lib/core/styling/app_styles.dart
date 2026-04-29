import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  
  static TextStyle get primaryHeadLinesStyle => TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor);

  static TextStyle get subtitlesStyles => TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryColor);

  static TextStyle get black16w500Style => TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.blackColor);

  static TextStyle get grey12MediumStyle => TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.greyColor);

  static TextStyle get black15BoldStyle => TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black);

  static TextStyle get black18BoldStyle => TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black);
}