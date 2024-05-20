import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/cart/pages/cart_page.dart';
import 'package:rec_ecommerce/features/home/component/config_dialog.dart';
import 'package:rec_ecommerce/features/products/controller/products_controller.dart';
import 'package:rec_ecommerce/features/products/pages/product_list_page.dart';
import 'package:rec_ecommerce/models/product.dart';

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

  @override
  void initState() {
    ref.read(cartControllerProvider.notifier).fetchExistingCart(context, isFromHome: true);
    super.initState();
  }

  List<Product> products = [
    Product(
      id: '23',
      title: 'Face Mask',
      description:
          'Revitalizing face mask infused with natural ingredients to hydrate and nourish the skin. Leaves your complexion feeling refreshed and rejuvenated after each use.',
      imgLink:
          'https://img.etimg.com/thumb/width-1600,height-900,imgsize-400812,resizemode-75,msid-97283796/top-trending-products/lifestyle/5-charcoal-peel-off-masks-for-men-and-women-under-rs-300.jpg',
      category: 'cosmetics',
      rating: '4.3',
      price: 6.99,
    ),
    Product(
      id: '24',
      title: 'Highlighter Palette',
      description:
          'A palette of radiant highlighter shades to enhance your features. Buildable formula that glides on smoothly for a luminous glow, perfect for day or night.',
      imgLink:
          'https://resources.commerceup.io/?key=https://prod-admin-images.s3.ap-south-1.amazonaws.com/JgyWjz9rvHrN0G1LUw57/product/sph001-main.jpg&width=800&resourceKey=JgyWjz9rvHrN0G1LUw57&jpeg=true',
      category: 'cosmetics',
      rating: '4.7',
      price: 19.99,
    ),
    Product(
      id: '25',
      title: 'Makeup Brushes Set',
      description:
          'Complete set of high-quality makeup brushes for effortless application. Soft bristles and ergonomic handles for precise blending and flawless makeup looks.',
      imgLink:
          'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSRkoMBVRuN38M9H7G_9DiENsPaE7QyofSMNjXiRC9Rvt9Ml5b4uBmB3T6AyVHx51Xd9vHL1dY&usqp=CAE',
      category: 'cosmetics',
      rating: '4.6',
      price: 29.99,
    ),
    Product(
      id: '26',
      title: 'Beard Oil',
      description:
          'Nourishing beard oil enriched with natural oils to soften and condition facial hair. Promotes healthy beard growth and prevents dryness and itchiness for a well-groomed look.',
      imgLink:
          'https://rukminim2.flixcart.com/image/850/1000/xif0q/hair-oil/c/r/c/50-strong-beard-oil-for-men-dadi-mooch-oil-natural-beard-oil-for-original-imagzhhhnht6kzq2.jpeg?q=90&crop=false',
      category: 'cosmetics',
      rating: '4.6',
      price: 12.99,
    ),
    Product(
      id: '27',
      title: 'Men\'s Cologne',
      description:
          'Refined cologne with a masculine scent that exudes confidence and sophistication. Long-lasting fragrance that leaves a lasting impression, perfect for any occasion.',
      imgLink:
          'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQiG4kkubV-mRxjAwtyGGjzSpKb8DAzRgBKMczD6Pv16eVrz04JsO0ZXYpXYVFiNXnV3n04-GNR&usqp=CAE',
      category: 'cosmetics',
      rating: '4.8',
      price: 29.99,
    )
  ];

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
                    showDialog(context: context, builder: (ctx) => const ConfigDialogWidget());
                    // for (var prod in products) {
                    //   ref.read(productsControllerProvider.notifier).addProduct(prod);
                    // }
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.56.h,
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
                itemCount: categories.length,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
