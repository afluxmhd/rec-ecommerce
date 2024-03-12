import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/features/products/repo/products_repo.dart';
import 'package:rec_ecommerce/models/product.dart';

final productsStreamProvider = StreamProvider.family((ref, String category) {
  final productsController = ref.watch(productsControllerProvider.notifier);
  return productsController.getProductByCategory(category);
});

final productsControllerProvider = StateNotifierProvider<ProductsController, bool>((ref) {
  final productsRepo = ref.watch(productsRepositoryProvider);
  return ProductsController(ref: ref, productsRepo: productsRepo);
});

class ProductsController extends StateNotifier<bool> {
  final ProductsRepo _productsRepo;
  final Ref _ref;

  ProductsController({
    required Ref ref,
    required ProductsRepo productsRepo,
  })  : _ref = ref,
        _productsRepo = productsRepo,
        super(false);

  void addProduct(Product prod) async {
    var res = await _productsRepo.addProduct(prod);

    res.fold((l) {
      debugPrint("ERR: ${l.message}");
    }, (r) {
      debugPrint("SUCESSS: ");
    });
  }

  Stream<List<Product>> getProductByCategory(String category) {
    return _productsRepo.getProductsByCategory(category);
  }

  //get recent purchase product

  void getFrequentlyBoughtProducts(String category) {
    //
  }
}
