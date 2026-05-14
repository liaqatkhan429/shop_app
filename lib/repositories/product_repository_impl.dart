import 'package:hive/hive.dart';
import 'package:shop_app/repositories/product_repository.dart';

import '../models/product_model.dart';
import '../services/database_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseService db;

  ProductRepositoryImpl(this.db);

  Box get _box => db.getProductsBox();

  @override
  Future<void> addProduct(ProductModel product) async {
    await _box.put(product.id, _toMap(product));
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    return _box.values
        .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _box.put(product.id, _toMap(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _box.delete(id);
  }

  Map<String, dynamic> _toMap(ProductModel p) {
    return {
      'id': p.id,
      'name': p.name,
      'modelNo': p.modelNo,
      'staticRate': p.staticRate,
      'stockQuantity': p.stockQuantity,
      'createdAt': p.createdAt,
    };
  }
}