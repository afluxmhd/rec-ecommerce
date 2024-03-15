import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/components/icon_button.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/order/controller/order_controller.dart';
import 'package:rec_ecommerce/models/cart.dart';
import 'package:rec_ecommerce/widgets/cart_list_card_widget.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  String cartId = "";
  Cart? cart;

  void getCartID() async {
    cartId = await ref.read(cartControllerProvider.notifier).getCartID();
    setState(() {});
  }

  void fetchCart() {
    ref.read(cartControllerProvider.notifier).fetchExistingCart(context);
  }

  @override
  void initState() {
    getCartID();
    fetchCart();
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
                        svgPath: "assets/icons/Left 2.svg",
                        bgColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      AppText.headingThreeMedium("Your Cart List"),
                      const AppIconButton(
                        svgPath: "assets/icons/Category.svg",
                        bgColor: Colors.transparent,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.w),
                  Expanded(
                    flex: 2,
                    child: ref.watch(cartStreamProvider(cartId.isEmpty ? "1" : cartId)).when(
                          data: _buildCartWidget,
                          error: _buildErrorWidget,
                          loading: () => const CircularProgressIndicator(),
                        ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.w),
                        AppText.bodyOneMedium("Order Summary"),
                        const Divider(thickness: 0.3, color: AppColors.kSurface),
                        buildOrderSummaryWidget("Item Total", "\$${ref.read(cartControllerProvider.notifier).getItemTotal(cart)}",
                            isBold: true),
                        buildOrderSummaryWidget("Delivery Charges", "\$4.99"),
                        buildOrderSummaryWidget(
                            "Taxes & Charges", "\$${ref.read(cartControllerProvider.notifier).getTotalTax(cart)}"),
                        const Divider(thickness: 0.3, color: AppColors.kSurface),
                        buildOrderSummaryWidget(
                            "Total to Pay", "\$${ref.read(cartControllerProvider.notifier).getTotalToPay(cart)}",
                            isBold: true),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () {
                ref.read(orderControllerProvider.notifier).orderCartProducts(context: context);
              },
              child: Container(
                height: 56.h,
                padding: EdgeInsets.only(top: 20.h, bottom: 20.w, left: 20.w, right: 20.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.kAccent,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
                child: AppText.bodyTwoSemiBold("ORDER NOW", color: AppColors.kWhite),
              ),
            )));
  }

  Widget _buildCartWidget(Cart? data) {
    cart = data;
    if (data == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Image.asset(
            "assets/images/add_to_cart.png",
            height: 200.h,
            width: 200.w,
          ),
          Center(
            child: AppText.bodyOneMedium("EMPTY CART!"),
          ),
        ],
      );
    }
    if (data.cartProducts.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Image.asset(
            "assets/images/add_to_cart.png",
            height: 200.h,
            width: 200.w,
          ),
          Center(
            child: AppText.bodyOneMedium("EMPTY CART!"),
          ),
        ],
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, index) => CartListCardWidget(
        index: index,
        cartProduct: data.cartProducts[index],
        onAdd: () {
          ref
              .read(cartControllerProvider.notifier)
              .increaseCartItemQuantity(cartProduct: data.cartProducts[index], context: context);
        },
        onRemove: () {
          ref
              .read(cartControllerProvider.notifier)
              .decreaseCartItemQuantity(cartProduct: data.cartProducts[index], context: context);
        },
        onDismissed: (direction) {
          ref
              .read(cartControllerProvider.notifier)
              .removeProductFromCart(cartProduct: data.cartProducts[index], context: context);
        },
      ),
      itemCount: data.cartProducts.length,
    );
  }

  Widget _buildErrorWidget(Object error, StackTrace stackTrace) {
    return Center(child: Text('An error occurred: $error')); // Better custom error handling
  }

  buildOrderSummaryWidget(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isBold ? AppText.bodyThreeMedium(title) : AppText.bodyThreeRegular(title),
          isBold ? AppText.bodyThreeMedium(value) : AppText.bodyThreeRegular(value),
        ],
      ),
    );
  }
}
