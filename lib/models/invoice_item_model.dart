class InvoiceItemModel {
  final String productId;
  final String productName;
  final int rate;
  final int quantity;
  final int subTotal;

  InvoiceItemModel({
    required this.productId,
    required this.productName,
    required this.rate,
    required this.quantity,
    required this.subTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'rate': rate,
      'quantity': quantity,
      'subTotal': subTotal,
    };
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      productId: map['productId'],
      productName: map['productName'],
      rate: map['rate'],
      quantity: map['quantity'],
      subTotal: map['subTotal'],
    );
  }
}