import 'package:flutter/foundation.dart';
import 'package:shop_app/models/product_model.dart';

import '../models/invoice_model.dart';

class CreateInvoiceViewModel extends ChangeNotifier {
  final List<InvoiceItemModel> _items = [
    InvoiceItemModel(
      item: ProductModel(
        id: '1',
        name: 'Premium Portland Cement',
        modelNo: "dw-12",
        staticRate: 12,
        stockQuantity: 450,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      quantity: 20,
      rate: 12.50,
    ),
  ];

  List<InvoiceItemModel> get items => _items;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  double get discountAmount => subtotal * 0.05; // 5% discount fixed for UI mock
  double get taxAmount =>
      (subtotal - discountAmount) * 0.10; // 10% tax fixed for UI mock
  double get grandTotal => subtotal - discountAmount + taxAmount;

  void addDummyItem() {
    // Just a placeholder function
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void saveInvoice() {
    // Logic to save
  }
}
