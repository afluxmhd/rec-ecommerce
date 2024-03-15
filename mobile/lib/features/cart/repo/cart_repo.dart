import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rec_ecommerce/core/constants/firebase_constants.dart';
import 'package:rec_ecommerce/core/failure.dart';
import 'package:rec_ecommerce/core/providers/firebase_providers.dart';
import 'package:rec_ecommerce/core/type_defs.dart';

import 'package:rec_ecommerce/models/cart.dart';
import 'package:rec_ecommerce/models/cart_item.dart';
import 'package:rec_ecommerce/models/product.dart';

final cartRepositoryProvider = Provider((ref) {
  return CartRepo(firestore: ref.watch(firestoreProvider));
});

class CartRepo {
  final FirebaseFirestore _firestore;
  CartRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _carts => _firestore.collection(FirebaseConstants.carts);

  Future<void> createCart(Cart cart) async {
    try {
      await _carts.doc(cart.id).set(cart.toMap());
    } on FirebaseException catch (e) {
      throw Exception("Firebase error: ${e.message}");
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  FutureVoid updateCart(Cart cart) async {
    try {
      return right(_carts.doc(cart.id).update(cart.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<Cart?> getCart(String id) {
    return _carts.doc(id).snapshots().map((docSnapshot) {
      final data = docSnapshot.data();
      if (data != null) {
        return Cart.fromMap(data as Map<String, dynamic>);
      }
      return null;
    });
  }

  Stream<CartItem?> getCartItem(String cartId, String itemId) {
    var inValidItem = CartItem(
        id: "NO CART",
        userId: "XXX",
        product: Product(id: "xxx", title: "xxx", description: "xxx", imgLink: "xxxx", category: "xxx", rating: "XXX", price: 00),
        quantity: 0,
        totalAmount: 0);
    if (cartId == "") {
      return Stream.value(inValidItem);
    }
    return _carts.doc(cartId).snapshots().map((docSnapshot) {
      final data = docSnapshot.data();
      Cart? cart;
      if (data != null) {
        cart = Cart.fromMap(data as Map<String, dynamic>);
      }

      return cart?.cartProducts.firstWhere(
        (item) => item.id == itemId,
        orElse: () => inValidItem,
      );
    });
  }

  FutureVoid deleteCart(String id) async {
    try {
      return right(_carts.doc(id).delete());
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
