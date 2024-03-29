import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_snackbar.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/order/controller/order_controller.dart';
import 'package:rec_ecommerce/features/products/controller/products_controller.dart';
import 'package:rec_ecommerce/features/products/pages/product_view_page.dart';
import 'package:rec_ecommerce/models/product.dart';
import 'package:rec_ecommerce/services/frequent_items/frequent_item_service.dart';
import 'package:rec_ecommerce/widgets/loader_widget.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key, required this.category});

  final String category;

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final List<String> networkProductsImgPaths = [
    "https://media.voguebusiness.com/photos/642c3460706ee157689b66bd/master/pass/ai-fashion-week-voguebus-story.jpg",
    "https://img.freepik.com/free-photo/high-fashion-look-glamor-closeup-portrait-beautiful-sexy-stylish-caucasian-young-woman-model_158538-2774.jpg",
    "https://i.pinimg.com/736x/fc/ec/0d/fcec0db61ad2b49c65953bacb8ae01f0.jpg",
    ""
  ];

  final List<String> networkFrequentlyImgPaths = [
    "https://5.imimg.com/data5/LN/PI/JS/SELLER-3749501/corparate-trouser-500x500.jpg",
    "https://justintime.in/cdn/shop/files/Mens_Watches_M_1500x.jpg?v=8590229654416472155",
    "https://prod-img.thesouledstore.com/public/theSoul/uploads/catalog/product/1700825859_2645397.jpg?format=webp&w=480&dpr=2.0"
  ];

  List<Product> products = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _getRecentOrders();
      _getFrequenctlyBoughtTogether();
    });
    super.initState();
  }

  void _getRecentOrders() async {
    products = await ref.read(orderControllerProvider.notifier).getRecentOrders();
    setState(() {});
  }

  void _getFrequenctlyBoughtTogether() async {
    ref.read(orderControllerProvider.notifier).getFrequentlyBoughtProducts(context, widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                          itemCount: networkProductsImgPaths.length - 1,
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
                      loading: () => const LoaderWidget())),
              SizedBox(height: 20.h),
              AppText.bodyTwoMedium("Frequently bought together"),
              SizedBox(height: 10.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 130,
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.amber),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            networkFrequentlyImgPaths[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(34.r)),
                        child: const Center(child: Icon(Icons.add, color: AppColors.kIcon)),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.amber),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            networkFrequentlyImgPaths[1],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: const Center(child: Icon(Icons.add, color: AppColors.kIcon)),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.amber,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            networkFrequentlyImgPaths[2],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              AppText.bodyTwoMedium("Recent bought together"),
              SizedBox(height: 10.h),
              products.isNotEmpty ? _buildProductRow(context, products) : _buildEmptyState()
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

  Column _buildEmptyState() {
    return Column(
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
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
//for IAQ PROJECT IS NOT REQUIRED ONLY PPT