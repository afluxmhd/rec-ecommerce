import 'package:collection/collection.dart';

class Order {
  final String orderId;
  final String userId;
  final List<PorductsByCategory> allItems;
  Order({
    required this.orderId,
    required this.userId,
    required this.allItems,
  });

  Order copyWith({
    String? orderId,
    String? userId,
    List<PorductsByCategory>? allItems,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      allItems: allItems ?? this.allItems,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'userId': userId,
      'allItems': allItems.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] as String,
      userId: map['userId'] as String,
      allItems: (map['allItems'] as List<dynamic>)
          .map<PorductsByCategory>(
            (x) => PorductsByCategory.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  String toString() => 'Order(orderId: $orderId, userId: $userId ,allItems: $allItems)';

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.orderId == orderId && other.userId == userId && listEquals(other.allItems, allItems);
  }

  @override
  int get hashCode => orderId.hashCode ^ orderId.hashCode ^ allItems.hashCode;
}

class PorductsByCategory {
  final String category;
  final List<String> items;
  PorductsByCategory({
    required this.category,
    required this.items,
  });

  PorductsByCategory copyWith({
    String? category,
    List<String>? items,
  }) {
    return PorductsByCategory(
      category: category ?? this.category,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'items': items,
    };
  }

  factory PorductsByCategory.fromMap(Map<String, dynamic> map) {
    return PorductsByCategory(
      category: map['category'] as String,
      items: List<String>.from((map['items'] as List<dynamic>)),
    );
  }

  @override
  String toString() => 'PorductsByCategory(category: $category, items: $items)';

  @override
  bool operator ==(covariant PorductsByCategory other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.category == category && listEquals(other.items, items);
  }

  @override
  int get hashCode => category.hashCode ^ items.hashCode;
}
