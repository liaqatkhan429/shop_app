import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

class CustomerService {

  final CustomerRepository _repository;

  CustomerService(this._repository);

  Future<void> addCustomer(
      CustomerModel customer) async {

    await _repository.addCustomer(customer);
  }

  Future<List<CustomerModel>>
  getCustomers() async {

    return await _repository.getCustomers();
  }

  Future<void> updateCustomer(
      CustomerModel customer) async {

    await _repository.updateCustomer(customer);
  }

  Future<void> deleteCustomer(String id) async {

    await _repository.deleteCustomer(id);
  }
}