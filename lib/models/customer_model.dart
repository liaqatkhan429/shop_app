class CustomerModel {

  final String id;
  final String name;
  final String phone;
  final String address;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory CustomerModel.fromMap(
      Map<String, dynamic> map) {

    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}