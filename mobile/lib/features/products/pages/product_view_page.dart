import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_snackbar.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/cart/pages/cart_page.dart';
import 'package:rec_ecommerce/models/cart.dart';
import 'package:rec_ecommerce/models/cart_item.dart';
import 'package:rec_ecommerce/models/product.dart';
import 'package:rec_ecommerce/widgets/loader_widget.dart';

class ProductViewPage extends ConsumerStatefulWidget {
  const ProductViewPage({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends ConsumerState<ProductViewPage> {
  int _quantity = 0;
  bool isItemExist = false;

  CartItem? cartItem;

  void addQuantity(bool isItemExist) {
    if (isItemExist) {
      ref.read(cartControllerProvider.notifier).increaseCartItemQuantity(cartProduct: cartItem!, context: context);
    } else {
      setState(() {
        _quantity++;
      });
    }
  }

  void removeQuantity(bool isItemExist) {
    if (isItemExist) {
      ref.read(cartControllerProvider.notifier).decreaseCartItemQuantity(cartProduct: cartItem!, context: context);
    } else {
      if (_quantity != 0) {
        setState(() {
          _quantity--;
        });
      }
    }
  }

  void addToCart(Product product) {
    if (_quantity == 0) {
      AppSnackBar().show(context, "Quantity can't be empty");
    } else {
      var cartProduct =
          CartItem(id: product.id, userId: "DEMO", product: product, quantity: _quantity, totalAmount: _quantity * product.price);
      ref.read(cartControllerProvider.notifier).addProductToCart(cartProduct: cartProduct, context: context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: ref.watch(cartItemStreamProvider(widget.product.id)).when(
                data: (item) {
                  isItemExist = item!.id != "NO CART";
                  cartItem = item;
                  return Column(
                    children: [
                      SizedBox(
                        height: 300.h,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              child: SizedBox(
                                width: 400,
                                child: Image.network(
                                  widget.product.imgLink,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 14.h,
                              left: 16.w,
                              child: AppIconButton(
                                svgPath: "assets/icons/Left 2.svg",
                                iconColor: AppColors.kWhite,
                                bgColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Positioned(
                              top: 14.h,
                              right: 16.h,
                              child: AppIconButton(
                                svgPath: "assets/icons/Bag 2.svg",
                                iconColor: AppColors.kWhite,
                                bgColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CartPage()));
                                  //ref.read(cartControllerProvider.notifier).removeCartID();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 280.h,
                        decoration: const BoxDecoration(color: AppColors.kPrimaryLight),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.headingThreeSemiBold(widget.product.title),
                                    SizedBox(height: 5.w),
                                    AppText.bodyTwoSemiBold("Rs: ${widget.product.price}", color: AppColors.kPrimaryVariant),
                                  ],
                                ),
                                const AppIconButton(svgPath: "assets/icons/Heart.svg")
                              ],
                            ),
                            SizedBox(height: 20.w),
                            Flexible(
                              child: AppText.bodyThreeRegular(
                                widget.product.description,
                                color: AppColors.kSurface,
                              ),
                            ),
                            SizedBox(height: 20.w),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    removeQuantity(isItemExist);
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(right: 8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.kAccent,
                                      borderRadius: BorderRadius.circular(34.r),
                                    ),
                                    child: const Center(child: Icon(Icons.remove, color: AppColors.kPrimaryLight)),
                                  ),
                                ),
                                AppText.bodyTwoSemiBold(
                                  isItemExist ? item.quantity.toString() : _quantity.toString(),
                                  color: AppColors.kOnPrimary,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    addQuantity(isItemExist);
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(left: 8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.kAccent,
                                      borderRadius: BorderRadius.circular(34.r),
                                    ),
                                    child: const Center(child: Icon(Icons.add, color: AppColors.kPrimaryLight)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
                error: (error, stackTarce) => ErrorWidget(error),
                loading: () => const LoaderWidget()),
          ),

          //Navigation bar cart
          bottomNavigationBar: GestureDetector(
            onTap: () {
              if (isItemExist) {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CartPage()));
              } else {
                addToCart(widget.product);
              }
            },
            child: Container(
              height: 56.h,
              padding: EdgeInsets.only(top: 20.h, bottom: 20.w, left: 20.w, right: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.kAccent,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
              child: AppText.bodyTwoSemiBold(isItemExist ? "CHECKOUT" : "ADD TO CART", color: AppColors.kWhite),
            ),
          )),
    );
  }
}
