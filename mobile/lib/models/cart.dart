import 'package:flutter/foundation.dart';
import 'package:rec_ecommerce/models/cart_item.dart';

class Cart {
  final String id;
  final String userId;
  final List<CartItem> cartProducts;
  final DateTime createdAt;
  Cart({
    required this.id,
    required this.userId,
    required this.cartProducts,
    required this.createdAt,
  });

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? cartProducts,
    DateTime? createdAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cartProducts: cartProducts ?? this.cartProducts,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'cartProducts': cartProducts.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      userId: map['userId'] as String,
      cartProducts: (map['cartProducts'] as List<dynamic>)
          .map<CartItem>(
            (x) => CartItem.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Cart(id: $id, userId: $userId, cartProducts: $cartProducts, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        listEquals(other.cartProducts, cartProducts) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ cartProducts.hashCode ^ createdAt.hashCode;
  }
}
