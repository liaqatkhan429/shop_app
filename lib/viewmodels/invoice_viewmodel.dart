
import 'package:flutter/cupertino.dart';

import '../models/customer_model.dart';
import '../models/invoice_item_model.dart';
import '../models/invoice_model.dart';
import '../models/product_model.dart';
import '../services/invoice_services.dart';

class CreateInvoiceViewModel extends ChangeNotifier {

  final InvoiceService _service;

  CreateInvoiceViewModel(this._service);

// ───────── INVOICE STATE ─────────

  List<InvoiceItemModel> _items = [];

  List<InvoiceItemModel> get items => _items;

  CustomerModel? selectedCustomer;

  int discount = 0;

  bool isLoading = false;

// ───────── TOTALS ─────────

  int get grandTotal {
    return _items.fold(
    0,
    (sum, item) => sum + item.subTotal,
    );
  }

  int get finalTotal {
    return grandTotal - discount;
  }

// ───────── ADD ITEM ─────────

  void addItem({
    required ProductModel product,
    required int quantity,
  }) {
    final subTotal =
    product.staticRate * quantity;

    final item = InvoiceItemModel(
    productId: product.id,
    productName: product.name,
    rate: product.staticRate,
    quantity: quantity,
    subTotal: subTotal,
    );

    _items.add(item);

    notifyListeners();
  }

// ───────── REMOVE ITEM ─────────

  void removeItem(int index) {
    _items.removeAt(index);

    notifyListeners();
  }

// ───────── DISCOUNT ─────────

  void setDiscount(int value) {
    discount = value;

    notifyListeners();
  }

// ───────── CUSTOMER ─────────

  void setCustomer(CustomerModel customer) {
    selectedCustomer = customer;

    notifyListeners();
  }

// ───────── SAVE INVOICE ─────────

  Future<void> saveInvoice() async {
    if (selectedCustomer == null) return;

    if (_items.isEmpty) return;

    isLoading = true;

    notifyListeners();

    final invoiceNo =
    await _service.generateInvoiceNumber();

    final invoice = InvoiceModel(

    id: DateTime.now()
        .millisecondsSinceEpoch
        .toString(),

    invoiceNo: invoiceNo,

    customerId: selectedCustomer!.id,

    customerName: selectedCustomer!.name,

    items: _items,

    grandTotal: grandTotal,

    discount: discount,

    finalTotal: finalTotal,

    createdAt: DateTime.now()
        .millisecondsSinceEpoch,
    );

    await _service.addInvoice(invoice);

    clearInvoice();

    isLoading = false;

    notifyListeners();
  }

// ───────── CLEAR ─────────

  void clearInvoice() {
    _items.clear();

    selectedCustomer = null;

    discount = 0;

    notifyListeners();
  }
}