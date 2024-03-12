import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';

class AppSnackBar {
  void show(BuildContext context, String message) {
    var snackBar = SnackBar(
      duration: const Duration(milliseconds: 2000),
      backgroundColor: AppColors.kAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      content: AppText.bodyThreeMedium(message, color: Colors.white),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
