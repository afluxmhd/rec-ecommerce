import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/core/design/components/app_snackbar.dart';
import 'package:rec_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:rec_ecommerce/features/order/repository/order_repo.dart';
import 'package:rec_ecommerce/features/products/controller/products_controller.dart';
import 'package:rec_ecommerce/features/user/controller/user_controller.dart';
import 'package:rec_ecommerce/models/frequent_items.dart';
import 'package:rec_ecommerce/models/order.dart';
import 'package:rec_ecommerce/models/product.dart';
import 'package:rec_ecommerce/services/frequent_items/frequent_item_service.dart';

final orderControllerProvider = StateNotifierProvider<OrderController, bool>((ref) {
  final orderRepo = ref.watch(ordersRepositoryProvider);
  final frequentItemService = ref.watch(frequentItemServiceProvider);
  return OrderController(ref: ref, orderRepo: orderRepo, frequentItemServices: frequentItemService);
});

final frequentProductLoaderProvider = StateProvider<bool>((ref) => false);

class OrderController extends StateNotifier<bool> {
  final OrderRepo _orderRepo;
  final Ref _ref;
  final FrequentItemServices _frequentItemServices;

  OrderController({required OrderRepo orderRepo, required Ref ref, required FrequentItemServices frequentItemServices})
      : _orderRepo = orderRepo,
        _ref = ref,
        _frequentItemServices = frequentItemServices,
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

    if (orders != null) {
      for (var category in orders.allItems) {
        for (var title in category.items) {
          Product product = await _ref.read(productsControllerProvider.notifier).getProductByName(title);
          products.add(product);
        }
      }
    }

    state = false;
    return products;
  }

  Future<List<Product>> getFrequentlyBoughtProducts(BuildContext context, String category) async {
    _ref.read(frequentProductLoaderProvider.notifier).update((state) => true);
    try {
      final allOrders = await _orderRepo.getAllOrders().first;
      final productsByOrderId = <String, List<String>>{};

      for (var order in allOrders) {
        order.allItems.where((productByCategory) => productByCategory.category == category).forEach((productByCategory) {
          productsByOrderId.putIfAbsent(order.orderId, () => []);
          productsByOrderId[order.orderId]!.addAll(productByCategory.items);
        });
      }

      ///Fetching user rec_configs:
      var recConfig = await _ref.read(userControllerProvider).getUserRecommendationConfiguration();

      ///Support value conversion.
      double support = _convertSupport(recConfig.accuracy);

      print("SUPPORT: ${support}");

      final frequentItems =
          FrequentItems(dataset: productsByOrderId, support: support, itemCount: int.parse(recConfig.combination));
      final productTitles = await _frequentItemServices.getFrequenctProducts(frequentItems);
      List<Product> frequentProducts = [];

      for (var title in productTitles) {
        Product product = await _ref.read(productsControllerProvider.notifier).getProductByName(title);
        frequentProducts.add(product);
      }
      _ref.read(frequentProductLoaderProvider.notifier).update((state) => false);

      return frequentProducts;
    } catch (e) {
      _ref.read(frequentProductLoaderProvider.notifier).update((state) => false);
      if (context.mounted) {
        if (e.toString().contains("Not found")) {
          AppSnackBar().show(context, "Frequent Items is not available");
        } else if (e.toString().contains("Connection refused")) {
          AppSnackBar().show(context, "Server is not connected!");
        } else if (e.toString().contains("Server error")) {
          AppSnackBar().show(context, "Somthing went wrong!");
        }
      }
      return [];
    }
  }

  _convertSupport(String accuracyLevel) {
    // Assuming accuracyLevel ranges from "1" to "5"
    int level = int.parse(accuracyLevel);
    double convertedValue = (level - 1) / 4; // Convert to range 0 to 1
    return convertedValue;
  }
}
