import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_button.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/cart/pages/cart_page.dart';
import 'package:rec_ecommerce/features/products/pages/product_list_page.dart';
import 'package:rec_ecommerce/features/user/controller/user_controller.dart';
import 'package:rec_ecommerce/models/rec_configuration.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<String> imgpaths = [
    "assets/images/beauty.webp",
    "assets/images/fashion.webp",
    "assets/images/stationary.webp",
    "assets/images/grocery.webp"
  ];

  final List<String> categories = ["cosmetics", "fashion", "stationary", "grocery"];

  RecConfiguration recConfig = RecConfiguration(combination: '2', accuracy: '4');

  @override
  void initState() {
    ref.read(cartControllerProvider.notifier).fetchExistingCart(context, isFromHome: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIconButton(
                  svgPath: "assets/icons/Category.svg",
                  bgColor: Colors.transparent,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => Container(
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
                                        3,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              recConfig = recConfig.copyWith(combination: '${index + 1}');
                                            },
                                            child: Container(
                                              height: 22.w,
                                              width: 22.w,
                                              margin: EdgeInsets.only(left: 5.w),
                                              color: Colors.amber,
                                              alignment: Alignment.center,
                                              child: AppText.captionOneMedium('${index + 1}', color: AppColors.kOnPrimary),
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
                                            },
                                            child: Container(
                                              height: 22.w,
                                              width: 22.w,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(left: 5.w),
                                              color: color,
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
                                        Navigator.pop(ctx);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
                AppIconButton(
                  svgPath: "assets/icons/Bag 2.svg",
                  bgColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CartPage()));
                  },
                ),
              ],
            ),
            SizedBox(height: 10.w),
            AppText.headingTwoMedium("Get your Perfect Recommendation"),
            SizedBox(height: 5.w),
            AppText.bodyThreeMedium("As per your our customers", color: AppColors.kSecondary),
            SizedBox(height: 16.w),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductListPage(category: categories[index])));
                    },
                    onLongPress: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(width: 0.2),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.asset(
                                imgpaths[index],
                                height: 300,
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 4,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
