import 'package:flutter/foundation.dart';
import '../models/invoice_model.dart';

class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Dummy stats
  double get totalSales => 124500.0;
  double get totalSalesGrowth => 12.5;

  int get totalInvoices => 1240;
  double get totalInvoicesGrowth => 5.2;

  double get pendingPayments => 18200.0;
  double get pendingPaymentsGrowth => -2.4;

  int get totalClients => 450;
  double get totalClientsGrowth => 8.0;

  // Dummy recent invoices
  // List<InvoiceModel> get recentInvoices => [
  //   InvoiceModel(
  //     invoiceNo: '#INV-2024-001',
  //     clientId: 'c1',
  //     clientName: 'Skyline Modern Build',
  //     date: DateTime(2023, 10, 24),
  //     items: [],
  //     status: 'Paid',
  //   ),
  //   InvoiceModel(
  //     invoiceNo: '#INV-2024-002',
  //     clientId: 'c2',
  //     clientName: 'Urban Renovations Ltd.',
  //     date: DateTime(2023, 10, 23),
  //     items: [],
  //     status: 'Pending',
  //   ),
  //   InvoiceModel(
  //     invoiceNo: '#INV-2024-003',
  //     clientId: 'c3',
  //     clientName: 'Terra Concrete Corp',
  //     date: DateTime(2023, 10, 22),
  //     items: [],
  //     status: 'Paid',
  //   ),
  // ];

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();
    // Simulate network/db delay
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }
}
