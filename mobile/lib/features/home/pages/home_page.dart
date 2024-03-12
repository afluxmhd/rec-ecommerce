import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/cart/pages/cart_page.dart';
import 'package:rec_ecommerce/features/products/pages/product_list_page.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

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

  // List<Product> hardcodedProducts = [

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
                const AppIconButton(
                  svgPath: "assets/icons/Category.svg",
                  bgColor: Colors.transparent,
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
