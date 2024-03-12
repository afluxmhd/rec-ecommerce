import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.w,
      width: 30.h,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.kAccent),
      ),
    );
  }
}
