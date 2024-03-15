import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/order/repository/order_repo.dart';
import 'package:rec_ecommerce/features/products/controller/products_controller.dart';
import 'package:rec_ecommerce/models/order.dart';
import 'package:rec_ecommerce/models/product.dart';

final orderControllerProvider = StateNotifierProvider<OrderController, bool>((ref) {
  final orderRepo = ref.watch(ordersRepositoryProvider);
  return OrderController(ref: ref, orderRepo: orderRepo);
});

class OrderController extends StateNotifier<bool> {
  final OrderRepo _orderRepo;
  final Ref _ref;

  OrderController({required OrderRepo orderRepo, required Ref ref})
      : _orderRepo = orderRepo,
        _ref = ref,
        super(false);

  Future<void> orderCartProducts({required BuildContext context}) async {
    var cart = _ref.read(cartProvider);
    var cartId = cart!.id;
    List<PorductsByCategory> items = [];

    // Group cart products by category
    Map<String, List<String>> categoryMap = {};
    for (var cartItem in cart.cartProducts) {
      String category = cartItem.product.category;
      if (!categoryMap.containsKey(category)) {
        categoryMap[category] = [];
      }
      categoryMap[category]!.add(cartItem.product.title);
    }

    categoryMap.forEach((category, products) {
      items.add(PorductsByCategory(category: category, items: products));
    });

    // Create order with grouped items
    Order order = Order(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: "DEMO",
      allItems: items,
    );

    await _orderRepo.addOrder(order);
    await _ref.read(cartControllerProvider.notifier).removeCartID();
    _ref.read(cartProvider.notifier).update((state) => null);
    await _ref.read(cartControllerProvider.notifier).deleteCart(cartId).then((value) {
      Navigator.pop(context);
    });
  }

  Future<List<Product>> getRecentOrders() async {
    state = true;
    List<Product> products = [];
    var orders = await _orderRepo.getOrders("DEMO").first;

    for (var category in orders!.allItems) {
      for (var title in category.items) {
        Product product = await _ref.read(productsControllerProvider.notifier).getProductByName(title);
        products.add(product);
      }
    }
    state = false;
    return products;
  }
}
