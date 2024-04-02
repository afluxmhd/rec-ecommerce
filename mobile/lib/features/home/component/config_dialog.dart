import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_button.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/user/controller/user_controller.dart';
import 'package:rec_ecommerce/models/rec_configuration.dart';

class ConfigDialogWidget extends ConsumerStatefulWidget {
  const ConfigDialogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigDialogWidgetState();
}

class _ConfigDialogWidgetState extends ConsumerState<ConfigDialogWidget> {
  RecConfiguration recConfig = RecConfiguration(combination: '2', accuracy: '4');
  int selectCombination = 0;
  int selectAccuracy = 0;

  void fetchConfig() async {
    recConfig = await ref.read(userControllerProvider).getUserRecommendationConfiguration();
    setState(() {
      selectCombination = int.parse(recConfig.combination);
      selectAccuracy = int.parse(recConfig.accuracy);
    });
  }

  @override
  void initState() {
    fetchConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 160.w, horizontal: 40.w),
      height: 200.h,
      width: 200.w,
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText.bodyTwoMedium("Configure Recommendations", textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            AppText.bodyThreeRegular("Select Combination", textAlign: TextAlign.center),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) {
                  final double ratio = index / 4;
                  final Color? color = Color.lerp(Colors.amber.shade400, Colors.amber.shade600, ratio);

                  return GestureDetector(
                    onTap: () {
                      recConfig = recConfig.copyWith(combination: '${index + 1}');
                      selectCombination = index + 1;
                      setState(() {});
                    },
                    child: Container(
                      height: 22.w,
                      width: 22.w,
                      margin: EdgeInsets.only(left: 5.w),
                      decoration: BoxDecoration(
                        color: color,
                        border: selectCombination - 1 == index ? Border.all() : null,
                      ),
                      alignment: Alignment.center,
                      child: AppText.captionOneMedium('${index + 1}', color: AppColors.kWhite),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),
            AppText.bodyThreeRegular("Select Accuracy", textAlign: TextAlign.center),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) {
                  final double ratio = index / 4;
                  final Color? color = Color.lerp(Colors.redAccent, Colors.green, ratio);

                  return GestureDetector(
                    onTap: () {
                      recConfig = recConfig.copyWith(accuracy: '${index + 1}');
                      selectAccuracy = index + 1;
                      setState(() {});
                    },
                    child: Container(
                      height: 22.w,
                      width: 22.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 5.w),
                      decoration: BoxDecoration(
                        color: color,
                        border: selectAccuracy - 1 == index ? Border.all() : null,
                      ),
                      child: AppText.captionOneMedium('${index + 1}', color: AppColors.kPrimaryLight),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 18.h),
            AppText.captionTwoRegular(
              'Note: Accuracy and combinations aren\'t always guaranteed, depending on available data or orders',
              textAlign: TextAlign.center,
              color: AppColors.kError,
            ),
            const Spacer(),
            AppButton(
              height: 38,
              width: 120.w,
              label: "Configure",
              onTap: () {
                ref.read(userControllerProvider).saveRecConfiguration(context, recConfig);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
