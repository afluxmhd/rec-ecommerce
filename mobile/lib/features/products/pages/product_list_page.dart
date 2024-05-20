import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/order/controller/order_controller.dart';
import 'package:rec_ecommerce/features/products/controller/products_controller.dart';
import 'package:rec_ecommerce/features/products/pages/product_view_page.dart';
import 'package:rec_ecommerce/models/product.dart';
import 'package:rec_ecommerce/widgets/loader_widget.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key, required this.category});

  final String category;

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  List<Product> recentProducts = [];
  List<Product> frequentProducts = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _getRecentOrders();
      _getFrequenctlyBoughtTogether();
    });
    super.initState();
  }

  void _getRecentOrders() async {
    recentProducts = await ref.read(orderControllerProvider.notifier).getRecentOrders();
    setState(() {});
  }

  void _getFrequenctlyBoughtTogether() async {
    frequentProducts = await ref.read(orderControllerProvider.notifier).getFrequentlyBoughtProducts(context, widget.category);
  }

  @override
  Widget build(BuildContext context) {
    var frequentProductLoading = ref.watch(frequentProductLoaderProvider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIconButton(
                    svgPath: "assets/icons/Left 2.svg",
                    bgColor: AppColors.kWhite,
                    height: 38,
                    width: 38,
                    iconSize: 18,
                    borderRadius: 14,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  AppText.bodyOneSemiBold(widget.category.capitalize()),
                  const SizedBox(width: 38)
                ],
              ),
              SizedBox(height: 10.h),
              AppText.bodyTwoMedium("Most Popular"),
              SizedBox(
                height: 250,
                child: ref.watch(productsStreamProvider(widget.category)).when(
                      data: (data) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductViewPage(product: data[index])));
                            },
                            child: Container(
                              width: 150,
                              height: 200,
                              margin: EdgeInsets.only(right: 8.w, top: 8.w, bottom: 8.w),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                  data[index].imgLink,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      error: (err, stTrace) {
                        return ErrorWidget(Exception(err));
                      },
                      loading: () => const LoaderWidget(),
                    ),
              ),
              SizedBox(height: 20.h),
              AppText.bodyTwoMedium("Frequently bought together"),
              SizedBox(height: 10.h),
              frequentProducts.isNotEmpty
                  ? _buildProductRow(context, frequentProducts)
                  : _buildEmptyFrequentState(frequentProductLoading),
              SizedBox(height: 20.h),
              AppText.bodyTwoMedium("Recent bought together"),
              SizedBox(height: 10.h),
              recentProducts.isNotEmpty
                  ? _buildProductRow(context, recentProducts)
                  : _buildEmptyOrderState(frequentProductLoading)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, List<Product> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 130,
        child: Row(
          children: [
            for (var product in products)
              Row(
                children: [
                  _buildProductContainer(context, product),
                  if (products.indexOf(product) != products.length - 1) _buildAddIcon(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductContainer(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductViewPage(product: product)));
      },
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.amber),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            product.imgLink,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildAddIcon() {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(34.r)),
      child: const Center(child: Icon(Icons.add, color: AppColors.kIcon)),
    );
  }

  _buildEmptyOrderState(bool productLoader) {
    return productLoader
        ? const LoaderWidget()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              const Center(
                child: Icon(Icons.shopping_bag, color: AppColors.kAccent),
              ),
              SizedBox(height: 5.h),
              Center(
                child: AppText.captionOneMedium("No recently purchased items"),
              ),
            ],
          );
  }

  _buildEmptyFrequentState(bool productLoader) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 28.h),
      child: productLoader
          ? const LoaderWidget()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/empty_frequent.png",
                    height: 100.h,
                    width: 100.w,
                  ),
                ),
                //assets/images/empty_frequent.png
                SizedBox(height: 5.h),
                Center(
                  child: AppText.captionOneMedium("Please check your configuration"),
                ),
              ],
            ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
//for IAQ PROJECT IS NOT REQUIRED ONLY PPT