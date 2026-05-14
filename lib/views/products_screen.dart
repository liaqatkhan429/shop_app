import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/utils.dart';
import '../constants/app_colors.dart';
import '../services/product_services.dart';
import '../viewmodels/products_viewmodel.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(context.read<ProductService>())..loadItems(),
      child: Consumer<ProductViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table (left)
                      Expanded(flex: 7, child: _buildTable(vm)),
                      const SizedBox(width: 20),
                      // Form (right)
                      SizedBox(width: 300, child: _buildForm(vm)),
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
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            'Products',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textLightPrimary,
            ),
          ),
          const Spacer(),
          // Search
          Container(
            width: 280,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
              decoration: InputDecoration(
                hintText: 'Search by name',
                hintStyle: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textLightSecondary, size: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Items Table ───────────────────────────────────────────────────────────
  Widget _buildTable(ProductViewModel vm) {
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
                _th('ITEM NAME', flex: 4),
                _th('MODEL NO', flex: 2),
                _th('STATIC RATE', flex: 2),
                _th('STOCK (QTY)',      flex: 2),
                _th('ACTION',          flex: 2, align: TextAlign.center),
              ],
            ),
          ),
          // Rows
          ...vm.items.map((item) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
              ),
              child: _ItemRow(item: item, onDelete: () => vm.deleteItem(item.id)),
            );
          }),
          // Pagination footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing 1 to ${vm.items.length} of ${vm.items.length} items',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLightSecondary),
                ),
                Row(
                  children: [
                    _paginationBtn('Previous', false),
                    const SizedBox(width: 6),
                    _paginationBtn('1', true),
                    const SizedBox(width: 6),
                    _paginationBtn('2', false),
                    const SizedBox(width: 6),
                    _paginationBtn('Next', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _th(String text, {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textLightSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _paginationBtn(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : AppColors.cardWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isActive ? AppColors.primaryBlue : AppColors.borderLight),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? Colors.white : AppColors.textLightSecondary,
        ),
      ),
    );
  }

  // ── Add New Item Form ─────────────────────────────────────────────────────
  Widget _buildForm(ProductViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add New Item', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary)),
          const SizedBox(height: 22),

          _label('ITEM NAME'),
          textInput(
            "Enter Item Name",
            vm.nameController,
                (value) {},
            errorText: vm.nameError,
          ),
          const SizedBox(height: 16),

          _label('MODEL NO'),
          textInput(
            "Enter Product Model No",
            vm.modelNoController,
                (value) {},
            errorText: vm.modelNoError,
          ),
          const SizedBox(height: 16),

          _label('STATIC RATE'),
          textInput("Enter Initial Rate", vm.rateController,(val){}, errorText: vm.rateError, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 16),

          _label('PRODUCT STOCK'),
          textInput("Enter Stock Quantity", vm.stockController,(val){}, errorText: vm.stockError, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (){
                bool isValid = vm.validate();
                if (!isValid) return;

                if (vm.editingProduct != null) {
                  vm.updateProduct();
                } else {
                  vm.saveNewItem();
                }
              },
              icon: const Icon(Icons.save_outlined, size: 16),
              label: Text(
                  vm.editingProduct != null
                      ? 'Update Product'
                      : 'Save Product',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () {
                vm.clearForm();
              },
              child: Text(  vm.editingProduct != null
                  ? 'Cancel'
                  : 'Clear form', style: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 20),

          // Info card
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
                const Icon(Icons.info_outline_rounded, color: AppColors.primaryBlue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Static rates are used as default in invoices but can be overridden during creation.',
                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF1E40AF), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textLightSecondary, letterSpacing: 0.8)),
    );
  }

  Widget _textInput(String hint, ValueChanged<String> onChanged) {
    return TextField(
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary),
        filled: true,
        fillColor: AppColors.cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
      ),
    );
  }

  // Widget _dropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
  //   return DropdownButtonFormField<String>(
  //     initialValue: value,
  //     onChanged: onChanged,
  //     style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
  //     decoration: InputDecoration(
  //       filled: true,
  //       fillColor: AppColors.cardWhite,
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
  //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
  //       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
  //     ),
  //     items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 13)))).toList(),
  //   );
  // }
}

// ── Row Widget ─────────────────────────────────────────────────────────────
class _ItemRow extends StatefulWidget {
  final dynamic item;
  final VoidCallback onDelete;

  const _ItemRow({required this.item, required this.onDelete});

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(flex: 4, child: Text(item.name, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary))),
            Expanded(flex: 2, child: Text(item.modelNo, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary))),
            Expanded(flex: 2, child: Text(item.staticRate.toString(), style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary))),
            Expanded(flex: 2, child: Text(item.stockQuantity.toString(), style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary))),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textLightSecondary),
                    onPressed: () {
                      context.read<ProductViewModel>().startEditProduct(item);
                    },
                    splashRadius: 16,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.errorRed),
                    onPressed: widget.onDelete,
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
