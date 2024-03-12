import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.svgPath,
    this.bgColor = AppColors.kWhite,
    this.width = 48,
    this.height = 48,
    this.onTap,
    this.iconColor = AppColors.kOnPrimary,
    this.iconSize = 24,
    this.borderRadius = 16,
  });

  final String svgPath;
  final Color bgColor;
  final Color iconColor;
  final double borderRadius;
  final double width;
  final double height;
  final double iconSize;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius.r), color: bgColor),
        child: Center(
            child: SvgPicture.asset(
          svgPath,
          height: iconSize.h,
          width: iconSize.w,
          color: iconColor,
        )),
      ),
    );
  }
}
