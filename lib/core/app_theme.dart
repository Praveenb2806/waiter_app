import 'package:flutter/material.dart';


class AppColors {
  static const primary = Color(0xFF5B46FF);
  static const scaffoldBg = Color(0xFFF8F8FB);
  static const cardBg = Colors.white;
}


class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}