import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/domain/entities/product.dart';

class ProductRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'products';

  Stream<List<Product>> getProducts() {
    return _db.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  Future<void> addProduct(Product product) {
    return _db.collection(_collectionPath).add(product.toFirestore());
  }
}
