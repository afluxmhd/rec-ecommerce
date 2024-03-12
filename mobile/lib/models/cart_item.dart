import 'package:rec_ecommerce/models/product.dart';

class CartItem {
  final String id;
  final String userId;
  final Product product;
  int quantity;
  double totalAmount;
  CartItem({
    required this.id,
    required this.userId,
    required this.product,
    required this.quantity,
    required this.totalAmount,
  });

  CartItem copyWith({
    String? id,
    String? userId,
    Product? product,
    int? quantity,
    double? totalAmount,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'product': product.toMap(),
      'quantity': quantity,
      'totalAmount': totalAmount,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      userId: map['userId'] as String,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      totalAmount: map['totalAmount'] as double,
    );
  }

  @override
  String toString() {
    return 'CartProduct(id: $id, userId: $userId, product: $product, quantity: $quantity, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.product == product &&
        other.quantity == quantity &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ product.hashCode ^ quantity.hashCode ^ totalAmount.hashCode;
  }
}
