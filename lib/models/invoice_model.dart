import 'invoice_item_model.dart';

class InvoiceModel {
  final String id;

  // INVC-01
  final String invoiceNo;

  final String customerId;
  final String customerName;

  final List<InvoiceItemModel> items;

  final int grandTotal;
  final int discount;
  final int finalTotal;

  final int createdAt;

  InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.grandTotal,
    required this.discount,
    required this.finalTotal,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'customerId': customerId,
      'customerName': customerName,
      'items': items.map((e) => e.toMap()).toList(),
      'grandTotal': grandTotal,
      'discount': discount,
      'finalTotal': finalTotal,
      'createdAt': createdAt,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'],
      invoiceNo: map['invoiceNo'],
      customerId: map['customerId'],
      customerName: map['customerName'],

      items: List<InvoiceItemModel>.from(
        map['items'].map(
              (x) => InvoiceItemModel.fromMap(
            Map<String, dynamic>.from(x),
          ),
        ),
      ),

      grandTotal: map['grandTotal'],
      discount: map['discount'],
      finalTotal: map['finalTotal'],
      createdAt: map['createdAt'],
    );
  }
}