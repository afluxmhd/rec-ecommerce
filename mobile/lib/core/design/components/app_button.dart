import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.width = double.infinity, required this.label, this.onTap, this.height = 55});

  final double width;
  final double height;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: height.h,
          width: width.w,
          decoration: BoxDecoration(
            color: AppColors.kAccent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: AppText.bodyOneMedium(label, color: AppColors.kPrimaryLight),
          ),
        ));
  }
}
