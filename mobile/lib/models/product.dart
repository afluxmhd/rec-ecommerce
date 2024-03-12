// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final String imgLink;
  final String category;
  final String rating;
  final double price;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imgLink,
    required this.category,
    required this.rating,
    required this.price,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? imgLink,
    String? category,
    String? rating,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imgLink: imgLink ?? this.imgLink,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'imgLink': imgLink,
      'category': category,
      'rating': rating,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imgLink: map['imgLink'] as String,
      category: map['category'] as String,
      rating: map['rating'] as String,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, imgLink: $imgLink, category: $category, rating: $rating, price: $price)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imgLink == imgLink &&
        other.category == category &&
        other.rating == rating &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imgLink.hashCode ^
        category.hashCode ^
        rating.hashCode ^
        price.hashCode;
  }
}
