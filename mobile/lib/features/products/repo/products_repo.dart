import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rec_ecommerce/core/constants/firebase_constants.dart';
import 'package:rec_ecommerce/core/failure.dart';
import 'package:rec_ecommerce/core/providers/firebase_providers.dart';
import 'package:rec_ecommerce/core/type_defs.dart';
import 'package:rec_ecommerce/models/product.dart';

final productsRepositoryProvider = Provider((ref) {
  return ProductsRepo(firestore: ref.watch(firestoreProvider));
});

class ProductsRepo {
  final FirebaseFirestore _firestore;
  ProductsRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _products => _firestore.collection(FirebaseConstants.products);

  FutureVoid addProduct(Product? product) async {
    try {
      return right(_products.doc(product?.id).set(product?.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Product>> getProductsByCategory(String category) {
    return _products.where("category", isEqualTo: category).snapshots().map((querySnapshot) => querySnapshot.docs
        .map(
          (doc) => Product.fromMap(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList());
  }

  Stream<Product> getProduct(String? id) {
    return _products.where("id", isEqualTo: id).snapshots().map((querySnapshot) {
      return Product.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>,
      );
    });
  }

  Stream<Product> getProductByName(String title) {
    return _products.where("title", isEqualTo: title).snapshots().map((querySnapshot) {
      return Product.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>,
      );
    });
  }
}
