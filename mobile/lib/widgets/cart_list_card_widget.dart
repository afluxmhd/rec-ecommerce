import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rec_ecommerce/core/design/components/app_text.dart';
import 'package:rec_ecommerce/core/design/shared/app_colors.dart';
import 'package:rec_ecommerce/models/cart_item.dart';

class CartListCardWidget extends StatefulWidget {
  const CartListCardWidget(
      {super.key, required this.index, required this.cartProduct, this.onDismissed, this.onRemove, this.onAdd});

  final int index;
  final CartItem cartProduct;
  final Function(DismissDirection)? onDismissed;
  final Function()? onRemove;
  final Function()? onAdd;

  @override
  State<CartListCardWidget> createState() => _CartListCardWidgetState();
}

class _CartListCardWidgetState extends State<CartListCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cartProduct.product.title),
      onDismissed: widget.onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.kErrorAccent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText.bodyOneMedium("Swipe to remove", color: AppColors.kWhite),
            SizedBox(width: 5.w),
            // ignore: deprecated_member_use
            SvgPicture.asset("assets/icons/Trash can.svg", color: AppColors.kPrimaryLight),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.w),
        padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(widget.cartProduct.product.imgLink),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodyTwoMedium(widget.cartProduct.product.title),
                    AppText.captionOneRegular('${widget.cartProduct.product.description.substring(0, 35)}....'),
                  ],
                ),
                SizedBox(height: 10.w),
                SizedBox(
                  width: 240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.bodyTwoMedium("\$${widget.cartProduct.totalAmount.toStringAsFixed(2)}"),
                      Container(
                        width: 75.w,
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.w),
                        decoration: BoxDecoration(color: AppColors.kPrimaryLight, borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: widget.onRemove,
                                child: Container(
                                  height: 20.w,
                                  width: 18.w,
                                  decoration: BoxDecoration(color: AppColors.kWhite, borderRadius: BorderRadius.circular(2.r)),
                                  child: Icon(
                                    Icons.remove,
                                    size: 14.sp,
                                    color: Colors.black,
                                  ),
                                )),
                            AppText.bodyTwoMedium(widget.cartProduct.quantity.toString()),
                            GestureDetector(
                              onTap: widget.onAdd,
                              child: Container(
                                height: 20.w,
                                width: 18.w,
                                decoration: BoxDecoration(color: AppColors.kWhite, borderRadius: BorderRadius.circular(2.r)),
                                child: Icon(
                                  Icons.add,
                                  size: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
