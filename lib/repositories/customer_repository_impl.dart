import 'package:hive/hive.dart';

import '../models/customer_model.dart';
import '../services/database_service.dart';
import 'customer_repository.dart';

class CustomerRepositoryImpl
    implements CustomerRepository {

  final DatabaseService db;

  CustomerRepositoryImpl(this.db);

  Box get _box => db.getCustomersBox();

  @override
  Future<void> addCustomer(
      CustomerModel customer) async {

    await _box.put(
      customer.id,
      customer.toMap(),
    );
  }

  @override
  Future<List<CustomerModel>>
  getCustomers() async {

    return _box.values
        .map(
          (e) => CustomerModel.fromMap(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }

  @override
  Future<void> updateCustomer(
      CustomerModel customer) async {

    await _box.put(
      customer.id,
      customer.toMap(),
    );
  }

  @override
  Future<void> deleteCustomer(String id) async {

    await _box.delete(id);
  }
}