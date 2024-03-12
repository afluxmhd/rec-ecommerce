import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/core/design/components/app_snackbar.dart';
import 'package:rec_ecommerce/features/cart/repo/cart_repo.dart';
import 'package:rec_ecommerce/models/cart.dart';
import 'package:rec_ecommerce/models/cart_item.dart';
import 'package:rec_ecommerce/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final cartStreamProvider = StreamProvider.family<Cart?, String>((ref, String id) {
  final cartController = ref.watch(cartControllerProvider.notifier);
  return cartController.getCartById(id);
});

final cartItemStreamProvider = StreamProvider.family<CartItem?, String>((ref, id) {
  final cartController = ref.watch(cartControllerProvider.notifier);
  return cartController.getCartItemById(id); //cartID and itemID
});

final cartProvider = StateProvider<Cart?>((ref) => null);

final cartIDProvider = StateProvider<String>((ref) => "");

final cartControllerProvider = StateNotifierProvider<CartController, bool>((ref) {
  final cartRepo = ref.watch(cartRepositoryProvider);
  return CartController(ref: ref, cartRepo: cartRepo);
});

class CartController extends StateNotifier<bool> {
  final CartRepo _cartRepo;
  final Ref _ref;

  CartController({required CartRepo cartRepo, required Ref ref})
      : _cartRepo = cartRepo,
        _ref = ref,
        super(false);

  Stream<Cart?> getCartById(String id) {
    return _cartRepo.getCart(id);
  }

  Stream<CartItem?> getCartItemById(String id) {
    var cartId = _ref.read(cartIDProvider);
    return _cartRepo.getCartItem(cartId, id);
  }

  void fetchExistingCart(BuildContext ctx, {bool isFromHome = false}) async {
    var cartID = await getCartID();
    if (cartID.isEmpty) {
      _ref.read(cartProvider.notifier).update((state) => null);
    } else {
      getCartById(cartID).first.then((cart) {
        _ref.read(cartProvider.notifier).update((state) => cart);
        if (isFromHome) AppSnackBar().show(ctx, "User Cart Fetched!");
      });
    }
  }

  String getTotalToPay(Cart? cart) {
    if (cart == null) {
      return "";
    }
    double totalPrice = double.parse(getItemTotal(cart));
    double netAmount = totalPrice - 4;
    double tax = netAmount * 0.18;
    double totalToPay = netAmount + tax;
    return totalToPay.toStringAsFixed(2);
  }

  String getTotalTax(Cart? cart) {
    if (cart == null) {
      return "";
    }
    double totalPrice = double.parse(getItemTotal(cart));
    double netAmount = totalPrice - 4.99;
    return (netAmount * 0.18).toStringAsFixed(2);
  }

  String getItemTotal(Cart? cart) {
    if (cart == null) {
      return "";
    }
    double total = 0;
    for (final cartItem in cart.cartProducts) {
      total += cartItem.quantity * cartItem.product.price;
    }
    return total.toStringAsFixed(2);
  }

  CartItem? getCartProductInfo(String id) {
    final cart = _ref.read(cartProvider);

    return cart!.cartProducts.firstWhere(
      (element) => element.id == id,
      orElse: () => CartItem(
          id: "NO CART",
          userId: "XXX",
          product:
              Product(id: "xxx", title: "xxx", description: "xxx", imgLink: "xxxx", category: "xxx", rating: "XXX", price: 00),
          quantity: 0,
          totalAmount: 0),
    );
  }

  Future<void> addProductToCart({required CartItem cartProduct, required BuildContext context}) async {
    var cartID = await getCartID();
    var newCartID = const Uuid().v4();
    if (cartID.isEmpty) {
      _cartRepo.createCart(Cart(id: newCartID, userId: "DEMO", cartProducts: [cartProduct], createdAt: DateTime.now()));
      await saveCartID(newCartID).then((value) {
        _ref.read(cartIDProvider.notifier).update((state) => newCartID);
        Navigator.pop(context);
      });
    } else {
      //fetch cart
      var existingCart = await getCartById(cartID).first;
      if (existingCart != null) {
        int index = existingCart.cartProducts
            .indexWhere((item) => item.product.id == cartProduct.product.id); //whether it is same product
        if (index != -1) {
          existingCart.cartProducts[index].quantity = cartProduct.quantity;
          existingCart.cartProducts[index].totalAmount =
              existingCart.cartProducts[index].quantity * existingCart.cartProducts[index].product.price;
        } else {
          existingCart.cartProducts.add(cartProduct);
        }
        await _cartRepo.updateCart(existingCart).then((value) {
          Navigator.pop(context);
        });
      }
    }
  }

  Future<void> removeProductFromCart({required CartItem cartProduct, required BuildContext context}) async {
    var cartID = await getCartID();
    if (cartID.isNotEmpty) {
      // Fetch the existing cart
      var existingCart = await getCartById(cartID).first;
      if (existingCart != null) {
        // Find the product in the cart
        int index = existingCart.cartProducts.indexWhere((item) => item.product.id == cartProduct.product.id);

        // Check if the product exists
        if (index != -1) {
          existingCart.cartProducts.removeAt(index);

          // Update the cart
          await _cartRepo.updateCart(existingCart).then((value) {
            AppSnackBar().show(context, "Product Removed");
          });
        }
      }
    } else {
      AppSnackBar().show(context, "Cart ID is empty");
    }
  }

  Future<void> increaseCartItemQuantity({required CartItem cartProduct, required BuildContext context}) async {
    var cartID = await getCartID();
    if (cartID.isNotEmpty) {
      var existingCart = await getCartById(cartID).first;
      if (existingCart != null) {
        int index = existingCart.cartProducts.indexWhere((item) => item.product.id == cartProduct.product.id);
        if (index != -1) {
          existingCart.cartProducts[index].quantity += 1; // Increase the quantity by 1
          existingCart.cartProducts[index].totalAmount =
              existingCart.cartProducts[index].quantity * existingCart.cartProducts[index].product.price;
          await _cartRepo.updateCart(existingCart).then((value) {
            fetchExistingCart(context);
          });
        } else {
          print("Product not found in the cart");
        }
      } else {
        print("Cart not found");
      }
    } else {
      print("Cart ID is empty");
    }
  }

  Future<void> decreaseCartItemQuantity({required CartItem cartProduct, required BuildContext context}) async {
    var cartID = await getCartID();
    if (cartID.isNotEmpty) {
      var existingCart = await getCartById(cartID).first;
      if (existingCart != null) {
        int index = existingCart.cartProducts.indexWhere((item) => item.product.id == cartProduct.product.id);
        if (index != -1 && existingCart.cartProducts[index].quantity > 1) {
          existingCart.cartProducts[index].quantity -= 1; // Decrease the quantity by 1
          existingCart.cartProducts[index].totalAmount =
              existingCart.cartProducts[index].quantity * existingCart.cartProducts[index].product.price;
          await _cartRepo.updateCart(existingCart);
        } else if (existingCart.cartProducts[index].quantity == 1) {
          // Optionally, you can choose to remove the item if its quantity becomes 1 and is decremented
          existingCart.cartProducts.removeAt(index);
          await _cartRepo.updateCart(existingCart).then((value) {
            fetchExistingCart(context);
          });
        } else {
          print("Product not found in the cart");
        }
      } else {
        print("Cart not found");
      }
    } else {
      print("Cart ID is empty");
    }
  }

  Future<void> orderCartProducts() async {
    //delete cart from firebase
    //remove cart id
    //clear providers (id,cart)
    //update firebase list for py as per category
  }

  Future<void> saveCartID(String cartID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('cartID', cartID);
  }

  Future<String> getCartID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString('cartID') ?? '';
    _ref.read(cartIDProvider.notifier).update((state) => key);
    return key;
  }

  Future<void> removeCartID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ref.read(cartIDProvider.notifier).update((state) => "");
    await prefs.remove('cartID');
  }
}
