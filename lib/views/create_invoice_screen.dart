import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/services/invoice_services.dart';
import 'package:shop_app/viewmodels/invoice_viewmodel.dart';
import '../constants/app_colors.dart';
import '../models/customer_model.dart';
import '../models/product_model.dart';
import '../viewmodels/customer_viewmodel.dart';
import '../viewmodels/products_viewmodel.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  // ── State ─────────────────────────────────────────────────────────────────
  // Holds the full CustomerModel so invoice saving has access to all fields.
  CustomerModel? _selectedCustomer;

  // Incrementing this key forces _CustomerSearchField to fully rebuild,
  // which is the correct way to programmatically clear Autocomplete's
  // internal TextEditingController (Flutter owns it, not us).
  int _customerFieldKey = 0;

  ProductModel? _selectedProduct;
  final _rateCtrl = TextEditingController(text: '0.00');
  final _qtyCtrl  = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    // addPostFrameCallback ensures the provider tree is fully mounted before
    // we call read<>() — calling it directly in initState would throw.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomerViewModel>().loadCustomers();
      context.read<ProductViewModel>().loadItems();
    });
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  // ── Clear helpers ──────────────────────────────────────────────────────────
  void _clearCustomer() {
    setState(() {
      _selectedCustomer = null;
      // Bump the key so _CustomerSearchField rebuilds with an empty field.
      _customerFieldKey++;
    });
  }

  void _selectCustomer(CustomerModel customer) {
    setState(() => _selectedCustomer = customer);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateInvoiceViewModel(context.read<InvoiceService>()..getInvoices()),
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
                      _buildClientCard(),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
          Text('Create Invoice',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary)),
          const Spacer(),
          Container(
            width: 260,
            height: 36,
            decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
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
              Text('Alex Thompson',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textLightPrimary)),
              Text('Store Manager',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLightSecondary)),
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
          // Section header
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text('Select Client',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textLightPrimary)),
            ],
          ),
          const SizedBox(height: 14),

          // Autocomplete field — keyed so bumping _customerFieldKey forces a
          // clean rebuild with an empty text field (see _clearCustomer()).
          Consumer<CustomerViewModel>(
            builder: (context, customerVm, _) {
              return _CustomerSearchField(
                key: ValueKey(_customerFieldKey),
                customers: customerVm.customers,
                onCustomerSelected: _selectCustomer,
                onCleared: _clearCustomer,
              );
            },
          ),

          // Selected customer badge — only visible after a selection.
          if (_selectedCustomer != null) ...[
            const SizedBox(height: 12),
            _buildSelectedCustomerBadge(_selectedCustomer!),
          ],
        ],
      ),
    );
  }

  // Compact info strip shown below the search field after a customer is picked.
  Widget _buildSelectedCustomerBadge(CustomerModel customer) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Row(
          children: [
            // Avatar initial
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + phone + address
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textLightPrimary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 11, color: AppColors.textLightSecondary),
                      const SizedBox(width: 4),
                      Text(customer.phone,
                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLightSecondary)),
                      if (customer.address.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textLightSecondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(customer.address,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLightSecondary)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Clear button
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textLightSecondary),
              onPressed: _clearCustomer,
              splashRadius: 14,
              tooltip: 'Remove customer',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ),
    );
  }

  // ── Add Item ──────────────────────────────────────────────────────────────
  Widget _buildAddItemCard(CreateInvoiceViewModel vm) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ADD ITEM',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.8, color: AppColors.textLightPrimary)),
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
                      builder: (context, productVm, _) {
                        if (productVm.items.isEmpty) {
                          return DropdownButtonFormField<ProductModel>(
                            value: null,
                            items: const [],
                            decoration: _dropdownDecoration().copyWith(hintText: 'Loading products…'),
                            onChanged: null,
                          );
                        }
                        return DropdownButtonFormField<ProductModel>(
                          value: _selectedProduct,
                          hint: Text('Choose an item...',
                              style: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13)),
                          onChanged: (product) {
                            setState(() {
                              _selectedProduct = product;
                              _rateCtrl.text = product?.staticRate.toString() ?? '0';
                            });
                          },
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
                          decoration: _dropdownDecoration(),
                          items: productVm.items.map((product) {
                            return DropdownMenuItem<ProductModel>(
                              value: product,
                              child: Text(product.name),
                            );
                          }).toList(),
                        );
                      },
                    ),
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
                onPressed: (){},
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                _thInvoice('ITEM DESCRIPTION', flex: 5),
                _thInvoice('RATE',  flex: 2, align: TextAlign.center),
                _thInvoice('QTY',   flex: 1, align: TextAlign.center),
                _thInvoice('TOTAL', flex: 2, align: TextAlign.center),
                const SizedBox(width: 50),
              ],
            ),
          ),
          ...vm.items.asMap().entries.map((e) {
            return _InvoiceItemRow(item: e.value, onDelete: () => vm.removeItem(e.key));
          }),
          if (vm.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: AppColors.borderLight, size: 48),
                    const SizedBox(height: 12),
                    Text('No items added yet',
                        style: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13)),
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
          style: GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: AppColors.textLightSecondary, letterSpacing: 0.4)),
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
              Text('INVOICE SUMMARY',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 12,
                      letterSpacing: 0.8, color: AppColors.textLightPrimary)),
              const SizedBox(height: 20),
              _summaryRow('Subtotal', ""),
              const SizedBox(height: 10),
              _summaryRow('Discount', "",
                  valueColor: AppColors.successGreen),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(color: AppColors.borderLight),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grand Total',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textLightPrimary)),
                      Text('PAYABLE AMOUNT',
                          style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLightSecondary, letterSpacing: 0.8)),
                    ],
                  ),
                  const Spacer(),
                  Text(vm.grandTotal.toStringAsFixed(2),
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primaryBlue)),
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
            label: Text('Print Invoice',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textLightSecondary)),
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
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textLightPrimary)),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(text,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textLightSecondary));
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


// ═══════════════════════════════════════════════════════════════════════════
// _CustomerSearchField
// ═══════════════════════════════════════════════════════════════════════════
//
// A self-contained Autocomplete<CustomerModel> search field.
//
// Why a separate StatelessWidget?
//   Flutter's Autocomplete widget owns its TextEditingController internally —
//   there's no public API to clear it from outside the widget.  The parent
//   solves this by giving this widget a ValueKey tied to _customerFieldKey.
//   When the parent increments that key (e.g. user taps "×" on the badge),
//   Flutter disposes the old element and mounts a fresh one with an empty
//   field.  No GlobalKey tricks, no custom state — just Flutter's standard
//   element-keying mechanism working exactly as designed.
//
class _CustomerSearchField extends StatelessWidget {
  final List<CustomerModel> customers;
  final ValueChanged<CustomerModel> onCustomerSelected;
  final VoidCallback onCleared;

  const _CustomerSearchField({
    super.key,
    required this.customers,
    required this.onCustomerSelected,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<CustomerModel>(
      // String shown in the field after the user picks a suggestion.
      displayStringForOption: (c) => c.name,

      // Filter logic:
      //   • Empty query  → show every customer (like opening a dropdown).
      //   • Non-empty    → case-insensitive substring match on name.
      //   • No match     → empty iterable → overlay shows "No customers found".
      optionsBuilder: (TextEditingValue textValue) {
        final query = textValue.text.trim().toLowerCase();
        if (query.isEmpty) return customers;
        return customers.where((c) => c.name.toLowerCase().contains(query));
      },

      onSelected: onCustomerSelected,

      // ── Styled text field ──────────────────────────────────────────────
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return _CustomerTextField(
          controller: controller,
          focusNode: focusNode,
          onCleared: () {
            controller.clear();
            onCleared();
          },
        );
      },

      // ── Styled suggestions overlay ────────────────────────────────────
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.black.withValues(alpha: 0.10),
            child: Container(
              // Caps the list at 280 px so it doesn't cover too much UI.
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: options.isEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search_off_rounded,
                        size: 16, color: AppColors.textLightSecondary),
                    const SizedBox(width: 10),
                    Text('No customers found',
                        style: GoogleFonts.poppins(
                            color: AppColors.textLightSecondary, fontSize: 13)),
                  ],
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.borderLight),
                itemBuilder: (context, index) {
                  final customer = options.elementAt(index);
                  return _CustomerSuggestionTile(
                    customer: customer,
                    onTap: () => onSelected(customer),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
// _CustomerTextField  — styled TextField inside the Autocomplete
// ═══════════════════════════════════════════════════════════════════════════
//
// Extracted from fieldViewBuilder so the suffix clear-button (×) can listen
// to the controller's value via ValueListenableBuilder without rebuilding the
// entire Autocomplete subtree on every keystroke.
//
class _CustomerTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onCleared;

  const _CustomerTextField({
    required this.controller,
    required this.focusNode,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
          decoration: InputDecoration(
            hintText: 'Search customer by name...',
            hintStyle: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13),
            // Magnifier icon on the left
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(Icons.search_rounded, color: AppColors.textLightSecondary, size: 18),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            // Clear (×) button — rendered only when there is text
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close_rounded,
                  size: 16, color: AppColors.textLightSecondary),
              splashRadius: 14,
              tooltip: 'Clear',
              onPressed: onCleared,
            )
                : null,
            filled: true,
            fillColor: AppColors.cardWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
          ),
        );
      },
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
// _CustomerSuggestionTile  — a single row inside the suggestions overlay
// ═══════════════════════════════════════════════════════════════════════════
class _CustomerSuggestionTile extends StatefulWidget {
  final CustomerModel customer;
  final VoidCallback onTap;

  const _CustomerSuggestionTile({
    required this.customer,
    required this.onTap,
  });

  @override
  State<_CustomerSuggestionTile> createState() => _CustomerSuggestionTileState();
}

class _CustomerSuggestionTileState extends State<_CustomerSuggestionTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final initial = widget.customer.name.isNotEmpty
        ? widget.customer.name[0].toUpperCase()
        : '?';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: _hovered ? const Color(0xFFF0F7FF) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Avatar circle with customer initial
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Center(
                  child: Text(initial,
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              // Name and phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.customer.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.textLightPrimary)),
                    const SizedBox(height: 1),
                    Text(widget.customer.phone,
                        style: GoogleFonts.poppins(
                            fontSize: 11.5, color: AppColors.textLightSecondary)),
                  ],
                ),
              ),
              // Chevron hint
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: AppColors.textLightSecondary),
            ],
          ),
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
// _InvoiceItemRow  — one data row in the line-items table
// ═══════════════════════════════════════════════════════════════════════════
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
              child: Text(item.item.name,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.textLightPrimary)),
            ),
            Expanded(
              flex: 2,
              child: Text(item.rate.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary)),
            ),
            Expanded(
              flex: 1,
              child: Text('${item.quantity}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary)),
            ),
            Expanded(
              flex: 2,
              child: Text(item.total.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textLightPrimary)),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.textLightSecondary, size: 18),
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