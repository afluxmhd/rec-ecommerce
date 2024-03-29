import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/models/frequent_items.dart';
import 'package:rec_ecommerce/services/api/api_client.dart';
import 'package:rec_ecommerce/services/api/api_routes.dart';

import '../../core/design/components/app_snackbar.dart';

final frequentItemServiceProvider = Provider((ref) {
  return FrequentItemServices(apiClient: ref.watch(apiClientProvider), ref: ref);
});

final frequentItemServiceErrorProvider = StateProvider<bool>((ref) => false);

class FrequentItemServices {
  FrequentItemServices({required this.apiClient, required this.ref});
  final APIClient apiClient;
  final Ref ref;

  Future<List<String>> getFrequenctProducts(FrequentItems data, BuildContext context) async {
    List<String> frequentProducts = [];
    try {
      var res = await apiClient.post(APIRoutes.baseUrl + APIRoutes.frequenyItemsPath, data.toMap());
      if (res.containsKey("1") && res["1"] is List<dynamic>) {
        frequentProducts = List<String>.from(res["1"]);
      }
    } on Exception catch (e) {
      if (e.toString().contains("Not found")) {
        frequentProducts = [];
        // ignore: use_build_context_synchronously
        AppSnackBar().show(context, "Frequent Items is not available");
      }
    }

    return frequentProducts;
  }
}
