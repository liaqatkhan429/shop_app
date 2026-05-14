import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductService {
  final ProductRepository _repo;

  ProductService(this._repo);

  Future<void> addProduct(ProductModel product) async {
    await _repo.addProduct(product);
  }

  Future<List<ProductModel>> getProducts() {
    return _repo.getProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _repo.updateProduct(product);
  }

  Future<void> deleteProduct(String id) {
    return _repo.deleteProduct(id);
  }
}