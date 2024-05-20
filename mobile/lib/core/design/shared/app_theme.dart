import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.kPrimaryLight,
      primaryColor: AppColors.kPrimaryLight,
      brightness: Brightness.dark,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.kPrimarydark,
      primaryColor: AppColors.kPrimarydark,
      brightness: Brightness.light,
    );
  }

  void getAppStatusBarColor(String theme) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: theme == "light" ? Brightness.dark : Brightness.light,
    ));
  }
}
