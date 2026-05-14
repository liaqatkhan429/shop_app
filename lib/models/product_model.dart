class ProductModel {
  final String id;
  final String name;
  final String modelNo;
  final int staticRate;
  final int stockQuantity;
  final int createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.modelNo,
    required this.staticRate,
    required this.stockQuantity,
    required this.createdAt,
  });
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      modelNo: map['modelNo'] ?? '',
      staticRate: (map['staticRate'] ?? 0),
      stockQuantity: map['stockQuantity'] ?? 0,
      createdAt: map['createdAt'] ?? 0,
    );
  }
}
