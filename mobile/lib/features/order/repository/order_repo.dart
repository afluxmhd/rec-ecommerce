import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/core/constants/firebase_constants.dart';
import 'package:rec_ecommerce/core/failure.dart';
import 'package:rec_ecommerce/core/providers/firebase_providers.dart';
import 'package:rec_ecommerce/models/order.dart' as app;

final ordersRepositoryProvider = Provider((ref) {
  return OrderRepo(firestore: ref.watch(firestoreProvider));
});

class OrderRepo {
  final FirebaseFirestore _firestore;
  OrderRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _orders => _firestore.collection(FirebaseConstants.orders);

  Future<void> addOrder(app.Order order) async {
    try {
      await _orders.doc(order.orderId).set(order.toMap());
    } on FirebaseException catch (e) {
      throw Exception("Firebase error: ${e.message}");
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Stream<app.Order?> getOrders(String userId) {
    return _orders.where("userId", isEqualTo: userId).snapshots().map((querySnapshot) {
      return app.Order.fromMap(
        querySnapshot.docs.last.data() as Map<String, dynamic>,
      );
    });
  }

  Stream<List<app.Order>> getAllOrders() {
    return _orders.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return app.Order.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
