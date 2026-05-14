import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/customer_model.dart';
import '../models/product_model.dart';
import '../viewmodels/create_invoice_viewmodel.dart';
import '../viewmodels/customer_viewmodel.dart';
import '../viewmodels/products_viewmodel.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  String? _selectedClient;
  ProductModel? _selectedProduct;
  final _rateCtrl = TextEditingController(text: '0.00');
  final _qtyCtrl  = TextEditingController(text: '1');

  final _products = ['Premium Portland Cement', 'Reinforcement Steel Bar', 'Construction Grade Sand', 'Gravel Mix', 'Waterproofing Compound'];

  @override
  void dispose() {
    _rateCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateInvoiceViewModel(),
      child: Consumer<CreateInvoiceViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client Selector
                      _buildClientCard(),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left: Add Item + Table
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildAddItemCard(vm),
                                const SizedBox(height: 20),
                                _buildItemsTable(vm),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right: Summary
                          SizedBox(width: 300, child: _buildSummaryCard(vm)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Text('Create Invoice', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary)),
          const Spacer(),
          // Search
          Container(
            width: 260,
            height: 36,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
            child: TextField(
              style: GoogleFonts.poppins(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search orders...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textLightSecondary, size: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 9),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textLightSecondary),
                onPressed: () {},
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.errorRed, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Alex Thompson', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textLightPrimary)),
              Text('Store Manager', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLightSecondary)),
            ],
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryBlue,
            child: Text('AT', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Client Selector ───────────────────────────────────────────────────────
  Widget _buildClientCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Client', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textLightPrimary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Consumer<CustomerViewModel>(
                  builder: (context, vm, _) {
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedClient,
                      items: vm.customers.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        );
                      }).toList(),
                      decoration: _dropdownDecoration(),
                      onChanged: (v) => setState(() => _selectedClient = v),
                    );
                  },
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Add Item ──────────────────────────────────────────────────────────────
  Widget _buildAddItemCard(CreateInvoiceViewModel vm) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ADD ITEM', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.8, color: AppColors.textLightPrimary)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Item Name'),
                    const SizedBox(height: 6),
                    Consumer<ProductViewModel>(
                      builder: (context, vm, _) {

                        return DropdownButtonFormField<ProductModel>(

                          initialValue: _selectedProduct,

                          hint: Text(
                            'Choose an item...',
                            style: GoogleFonts.poppins(
                              color: AppColors.textLightSecondary,
                              fontSize: 13,
                            ),
                          ),

                          onChanged: (product) {

                            setState(() {

                              _selectedProduct = product;

                              // Auto-fill rate
                              _rateCtrl.text =
                                  product?.staticRate.toString() ?? '0';
                            });
                          },

                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textLightPrimary,
                          ),

                          decoration: _dropdownDecoration(),

                          items: vm.items.map((product) {

                            return DropdownMenuItem<ProductModel>(

                              value: product,

                              child: Text(product.name),
                            );

                          }).toList(),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Rate'),
                    const SizedBox(height: 6),
                    _inputField(controller: _rateCtrl),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Qty'),
                    const SizedBox(height: 6),
                    _inputField(controller: _qtyCtrl),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: vm.addDummyItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Add Item', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Items Table ───────────────────────────────────────────────────────────
  Widget _buildItemsTable(CreateInvoiceViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                _thInvoice('ITEM DESCRIPTION', flex: 5),
                _thInvoice('RATE',   flex: 2, align: TextAlign.center),
                _thInvoice('QTY',    flex: 1, align: TextAlign.center),
                _thInvoice('TOTAL',  flex: 2, align: TextAlign.center),
                const SizedBox(width: 50),
              ],
            ),
          ),
          // Rows
          ...vm.items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return _InvoiceItemRow(item: item, onDelete: () => vm.removeItem(i));
          }),
          // Empty state
          if (vm.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: AppColors.borderLight, size: 48),
                    const SizedBox(height: 12),
                    Text('No items added yet', style: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _thInvoice(String text, {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(text, textAlign: align,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textLightSecondary, letterSpacing: 0.4)),
    );
  }

  // ── Invoice Summary ───────────────────────────────────────────────────────
  Widget _buildSummaryCard(CreateInvoiceViewModel vm) {
    return Column(
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INVOICE SUMMARY', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.8, color: AppColors.textLightPrimary)),
              const SizedBox(height: 20),
              _summaryRow('Subtotal', vm.subtotal.toStringAsFixed(2)),
              const SizedBox(height: 10),
              _summaryRow('Discount (5%)', '-${vm.discountAmount.toStringAsFixed(2)}', valueColor: AppColors.successGreen),
              const SizedBox(height: 10),
              _summaryRow('Tax (10%)', vm.taxAmount.toStringAsFixed(2)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(color: AppColors.borderLight),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grand Total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textLightPrimary)),
                      Text('PAYABLE AMOUNT', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLightSecondary, letterSpacing: 0.8)),
                    ],
                  ),
                  const Spacer(),
                  Text(vm.grandTotal.toStringAsFixed(2), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primaryBlue)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: vm.saveInvoice,
            icon: const Icon(Icons.save_rounded, size: 17),
            label: Text('Save Invoice', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print_rounded, size: 17, color: AppColors.textLightSecondary),
            label: Text('Print Invoice', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textLightSecondary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primaryBlue, size: 15),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please ensure all quantity units match the material specifications before saving.',
                  style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF1E40AF), height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: child,
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textLightSecondary)),
        const Spacer(),
        Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textLightPrimary)),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(text, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textLightSecondary));
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.cardWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
    );
  }

  Widget _inputField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
      decoration: _dropdownDecoration().copyWith(
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary),
      ),
    );
  }
}

// ── Invoice Item Row ───────────────────────────────────────────────────────
class _InvoiceItemRow extends StatefulWidget {
  final dynamic item;
  final VoidCallback onDelete;
  const _InvoiceItemRow({required this.item, required this.onDelete});

  @override
  State<_InvoiceItemRow> createState() => _InvoiceItemRowState();
}

class _InvoiceItemRowState extends State<_InvoiceItemRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hovered ? const Color(0xFFF9FAFB) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(item.item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.textLightPrimary)),
            ),
            Expanded(
              flex: 2,
              child: Text(item.rate.toStringAsFixed(2), textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary)),
            ),
            Expanded(
              flex: 1,
              child: Text('${item.quantity}', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary)),
            ),
            Expanded(
              flex: 2,
              child: Text(item.total.toStringAsFixed(2), textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textLightPrimary)),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textLightSecondary, size: 18),
                onPressed: widget.onDelete,
                splashRadius: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


