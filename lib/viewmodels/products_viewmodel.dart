import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';

import '../services/product_services.dart';


class ProductViewModel extends ChangeNotifier {
  final ProductService _service;

  ProductViewModel(this._service);

  List<ProductModel> items = [];

  bool isLoading = false;
  ProductModel? editingProduct;

  final nameController = TextEditingController();
  final modelNoController = TextEditingController();
  final rateController = TextEditingController();
  final stockController = TextEditingController();

  // Load from DB
  Future<void> loadItems() async {
    isLoading = true;
    notifyListeners();

    items = await _service.getProducts();

    isLoading = false;
    notifyListeners();
  }


  /// Validation

  String? nameError;
  String? modelNoError;
  String? rateError;
  String? stockError;

  bool validate() {

    // ───── Product Name ─────
    if (nameController.text.trim().isEmpty) {
      nameError = "Product name is required";
    } else {
      nameError = null;
    }

    if (modelNoController.text.trim().isEmpty) {
      modelNoError = "Model No is required";
    } else {
      modelNoError = null;
    }

    // ───── Rate Validation ─────
    if (rateController.text.trim().isEmpty) {
      rateError = "Rate is required";
    } else if (double.tryParse(rateController.text.trim()) == null) {
      rateError = "Enter valid rate";
    } else if (double.parse(rateController.text.trim()) <= 0) {
      rateError = "Rate must be greater than 0";
    } else {
      rateError = null;
    }

    // ───── Stock Validation ─────
    if (stockController.text.trim().isEmpty) {
      stockError = "Stock quantity is required";
    } else if (int.tryParse(stockController.text.trim()) == null) {
      stockError = "Enter valid stock quantity";
    } else if (int.parse(stockController.text.trim()) < 0) {
      stockError = "Stock cannot be negative";
    } else {
      stockError = null;
    }

    notifyListeners();

    return nameError == null &&
        rateError == null &&
        stockError == null &&
        modelNoError == null;
  }

  // Add item
  Future<void> saveNewItem() async {

    final name = nameController.text.trim();

    final modelNo = modelNoController.text.trim();

    final rate =
        int.tryParse(rateController.text.trim()) ?? 0;

    final stock =
        int.tryParse(stockController.text.trim()) ?? 0;

    if (name.isEmpty) return;

    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      modelNo: modelNo,
      staticRate: rate,
      stockQuantity: stock,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _service.addProduct(product);

    await loadItems();

    clearForm();
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    await _service.deleteProduct(id);
    await loadItems();
  }

  Future<void> updateProduct() async {

    if (editingProduct == null) return;

    final updatedProduct = ProductModel(
      id: editingProduct!.id,
      name: nameController.text.trim(),
      modelNo: nameController.text.trim(),
      staticRate:
      int.tryParse(rateController.text.trim()) ?? 0,
      stockQuantity:
      int.tryParse(stockController.text.trim()) ?? 0,
      createdAt: editingProduct!.createdAt,
    );

    await _service.updateProduct(updatedProduct);

    editingProduct = null;

    await loadItems();

    clearForm();
  }


  /////
  void startEditProduct(ProductModel product) {

    editingProduct = product;

    nameController.text = product.name;
    modelNoController.text = product.modelNo;
    rateController.text = product.staticRate.toString();
    stockController.text =
        product.stockQuantity.toString();

    notifyListeners();
  }

  // Clear form
  void clearForm() {

    editingProduct = null;
    nameController.clear();
    rateController.clear();
    stockController.clear();
    modelNoController.clear();

    notifyListeners();
  }
}
