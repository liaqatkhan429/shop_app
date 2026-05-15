import '../models/invoice_model.dart';

abstract class InvoiceRepository {
  Future<void> addInvoice(InvoiceModel invoice);

  Future<List<InvoiceModel>> getInvoices();

  Future<void> deleteInvoice(String id);

  Future<String> generateInvoiceNumber();
}