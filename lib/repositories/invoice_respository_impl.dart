import 'package:hive/hive.dart';

import '../models/invoice_model.dart';
import '../services/database_service.dart';
import 'invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final DatabaseService db;

  InvoiceRepositoryImpl(this.db);

  Box get _box => db.getInvoicesBox();

  @override
  Future<void> addInvoice(InvoiceModel invoice) async {
    await _box.put(invoice.id, invoice.toMap());
  }

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    return _box.values.map((e) {
      return InvoiceModel.fromMap(Map<String, dynamic>.from(e));
    }).toList();
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await _box.delete(id);
  }

  @override
  Future<String> generateInvoiceNumber() async {
    final count = _box.length + 1;

    return 'INVC-${count.toString().padLeft(2, '0')}';
  }
}
