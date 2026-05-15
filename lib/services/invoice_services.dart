import '../models/invoice_model.dart';
import '../repositories/invoice_repository.dart';

class InvoiceService {

  final InvoiceRepository _repository;

  InvoiceService(this._repository);

  Future<void> addInvoice(InvoiceModel invoice) async {
    await _repository.addInvoice(invoice);
  }

  Future<List<InvoiceModel>> getInvoices() async {
    return await _repository.getInvoices();
  }

  Future<void> deleteInvoice(String id) async {
    await _repository.deleteInvoice(id);
  }

  Future<String> generateInvoiceNumber() async {
    return await _repository.generateInvoiceNumber();

  }
}