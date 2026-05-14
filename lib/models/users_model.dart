class UserModel {
  final String id;
  final String name;
  final String pin;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.pin,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? pin,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pin': pin,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      pin: map['pin'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}