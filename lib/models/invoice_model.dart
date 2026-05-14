import 'package:shop_app/models/product_model.dart';


class InvoiceItemModel {
  final ProductModel item;
  final int quantity;
  final double rate;

  InvoiceItemModel({
    required this.item,
    required this.quantity,
    required this.rate,
  });

  double get total => quantity * rate;
}

class InvoiceModel {
  final String invoiceNo;
  final String clientId;
  final String clientName;
  final DateTime date;
  final List<InvoiceItemModel> items;
  final double discountPercentage;
  final double taxPercentage;
  final String status;

  InvoiceModel({
    required this.invoiceNo,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.items,
    this.discountPercentage = 0.0,
    this.taxPercentage = 0.0,
    this.status = 'Pending',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get discountAmount => subtotal * (discountPercentage / 100);
  double get taxAmount => (subtotal - discountAmount) * (taxPercentage / 100);
  double get grandTotal => subtotal - discountAmount + taxAmount;
}
