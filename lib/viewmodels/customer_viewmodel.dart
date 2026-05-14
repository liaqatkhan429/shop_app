import 'package:flutter/cupertino.dart';

import '../models/customer_model.dart';
import '../services/customer_services.dart';

class CustomerViewModel
    extends ChangeNotifier {

  final CustomerService _service;

  CustomerViewModel(this._service);

  List<CustomerModel> _customers = [];

  List<CustomerModel> get customers =>
      _customers;

  CustomerModel? editingCustomer;

  final nameController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final addressController =
  TextEditingController();


  /// ───────────────── VALIDATION ─────────────────

  String? nameError;
  String? phoneError;
  String? addressError;

  bool validate() {

    // ───── Name Validation ─────
    if (nameController.text.trim().isEmpty) {
      nameError = 'Customer name is required';
    } else {
      nameError = null;
    }

    // ───── Phone Validation ─────
    if (phoneController.text.trim().isEmpty) {
      phoneError = 'Phone number is required';
    } else if (
    !RegExp(r'^[0-9]+$')
        .hasMatch(phoneController.text.trim())) {
      phoneError = 'Enter valid phone number';
    } else if (
    phoneController.text.trim().length < 11) {
      phoneError = 'Phone number is too short';
    }
    else if (
    phoneController.text.trim().length > 11) {
      phoneError = 'Phone number is too long.... Not valid! ';
    } else {
      phoneError = null;
    }

    // ───── Address Validation ─────
    if (addressController.text.trim().isEmpty) {
      addressError = 'Address is required';
    } else {
      addressError = null;
    }

    notifyListeners();

    return nameError == null &&
        phoneError == null &&
        addressError == null;
  }

  Future<void> loadCustomers() async {
    print("LOADING CUSTOMERS...");

    final data = await _service.getCustomers();

    print("SERVICE RETURNED: ${data.length}");

    _customers = data;
    notifyListeners();
  }

  Future<void> saveCustomer() async {

    if (!validate()) return;

    final customer = CustomerModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      name: nameController.text.trim(),

      phone: phoneController.text.trim(),

      address: addressController.text.trim(),
    );

    await _service.addCustomer(customer);

    await loadCustomers();

    clearForm();
  }

  Future<void> updateCustomer() async {

    if (!validate()) return;

    if (editingCustomer == null) return;

    final updatedCustomer = CustomerModel(
      id: editingCustomer!.id,

      name: nameController.text.trim(),

      phone: phoneController.text.trim(),

      address: addressController.text.trim(),
    );

    await _service.updateCustomer(updatedCustomer);

    editingCustomer = null;

    await loadCustomers();

    clearForm();
  }

  Future<void> deleteCustomer(
      String id) async {

    await _service.deleteCustomer(id);

    await loadCustomers();
  }

  void startEditCustomer(
      CustomerModel customer) {

    editingCustomer = customer;

    nameController.text = customer.name;
    phoneController.text = customer.phone;
    addressController.text = customer.address;

    notifyListeners();
  }

  void clearForm() {

    editingCustomer = null;

    nameController.clear();
    phoneController.clear();
    addressController.clear();

    notifyListeners();
  }

  List<CustomerModel> searchCustomers(String query) {
    if (query.isEmpty) return _customers;

    return _customers.where((customer) {
      return customer.name
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  }

  CustomerModel? _selectedCustomer;

  CustomerModel? get selectedCustomer => _selectedCustomer;

  void selectCustomer(CustomerModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }


}