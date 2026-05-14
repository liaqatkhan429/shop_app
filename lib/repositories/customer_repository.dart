import '../models/customer_model.dart';

abstract class CustomerRepository {

  Future<void> addCustomer(
      CustomerModel customer);

  Future<List<CustomerModel>> getCustomers();

  Future<void> updateCustomer(
      CustomerModel customer);

  Future<void> deleteCustomer(String id);
}