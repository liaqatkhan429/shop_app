// import 'package:flutter/material.dart';
// import 'package:shop_app/model/home/invoice.dart';


// class InvoiceManagementScreen extends StatefulWidget {
//   const InvoiceManagementScreen({super.key});

//   @override
//   State<InvoiceManagementScreen> createState() =>
//       _InvoiceManagementScreenState();
// }

// class _InvoiceManagementScreenState extends State<InvoiceManagementScreen> {
//   int _selectedNav = 1;

//   final List<NavItem> _navItems = [
//     NavItem(Icons.dashboard_rounded, 'Dashboard'),
//     NavItem(Icons.description_rounded, 'Create Invoice'),
//     NavItem(Icons.people_rounded, 'Clients'),
//     NavItem(Icons.inventory_2_rounded, 'Items'),
//     NavItem(Icons.bar_chart_rounded, 'Reports'),
//     NavItem(Icons.settings_rounded, 'Settings'),
//   ];

//   final List<InvoiceItem> _invoiceItems = [
//     InvoiceItem(
//       name: 'Premium Portland Cement',
//       subtitle: 'Batch #992-B',
//       rate: 12.50,
//       qty: 20,
//     ),
//     InvoiceItem(
//       name: 'Reinforcement Steel Bar',
//       subtitle: '12mm Diameter - 6m',
//       rate: 8.00,
//       qty: 50,
//     ),
//     InvoiceItem(
//       name: 'Construction Grade Sand',
//       subtitle: 'Coarse River Sand',
//       rate: 120.00,
//       qty: 2,
//     ),
//   ];

//   String? _selectedClient;
//   String? _selectedProduct;
//   final TextEditingController _rateController =
//   TextEditingController(text: '0.00');
//   final TextEditingController _qtyController =
//   TextEditingController(text: '1');

//   final List<String> _clients = [
//     'John Smith Construction',
//     'Metro Builders Ltd.',
//     'ABC Infrastructure',
//     'GreenBuild Corp.',
//   ];

//   final List<String> _products = [
//     'Premium Portland Cement',
//     'Reinforcement Steel Bar',
//     'Construction Grade Sand',
//     'Gravel Mix',
//     'Waterproofing Compound',
//   ];

//   double get _subtotal =>
//       _invoiceItems.fold(0, (sum, item) => sum + item.total);
//   double get _discount => _subtotal * 0.05;
//   double get _tax => (_subtotal - _discount) * 0.10;
//   double get _grandTotal => _subtotal - _discount + _tax;

//   void _removeItem(int index) {
//     setState(() => _invoiceItems.removeAt(index));
//   }

//   void _addItem() {
//     if (_selectedProduct == null) return;
//     final rate = double.tryParse(_rateController.text) ?? 0.0;
//     final qty = int.tryParse(_qtyController.text) ?? 1;
//     setState(() {
//       _invoiceItems.add(InvoiceItem(
//         name: _selectedProduct!,
//         subtitle: 'Custom item',
//         rate: rate,
//         qty: qty,
//       ));
//       _selectedProduct = null;
//       _rateController.text = '0.00';
//       _qtyController.text = '1';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       body: Row(
//         children: [
//           _buildSidebar(),
//           Expanded(
//             child: Column(
//               children: [
//                 _buildTopBar(),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(28),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Column(
//                             children: [
//                               _buildClientSelector(),
//                               const SizedBox(height: 20),
//                               _buildAddItemSection(),
//                               const SizedBox(height: 20),
//                               _buildItemsTable(),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         SizedBox(
//                           width: 280,
//                           child: _buildInvoiceSummary(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── SIDEBAR ───────────────────────────────

//   Widget _buildSidebar() {
//     return Container(
//       width: 240,
//       color: const Color(0xFF1E2A3B),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 28, 20, 6),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2563EB),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(Icons.handyman_rounded,
//                       color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   'BuildMax',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20, bottom: 24),
//             child: Text(
//               'INVOICE MANAGEMENT',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.4),
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: _navItems.length,
//               itemBuilder: (context, i) => _buildNavItem(i),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: _buildNavTile(
//               icon: Icons.logout_rounded,
//               label: 'Logout',
//               selected: false,
//               onTap: () {},
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(int index) {
//     final item = _navItems[index];
//     return _buildNavTile(
//       icon: item.icon,
//       label: item.label,
//       selected: _selectedNav == index,
//       onTap: () => setState(() => _selectedNav = index),
//     );
//   }

//   Widget _buildNavTile({
//     required IconData icon,
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         margin: const EdgeInsets.symmetric(vertical: 2),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xFF2563EB) : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             Icon(icon,
//                 color: selected
//                     ? Colors.white
//                     : Colors.white.withOpacity(0.55),
//                 size: 18),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected
//                     ? Colors.white
//                     : Colors.white.withOpacity(0.55),
//                 fontSize: 14,
//                 fontWeight:
//                 selected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── TOP BAR ───────────────────────────────

//   Widget _buildTopBar() {
//     return Container(
//       height: 64,
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 28),
//       child: Row(
//         children: [
//           const Text(
//             'Create Invoice',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//           const Spacer(),
//           Container(
//             width: 260,
//             height: 38,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search orders...',
//                 hintStyle:
//                 TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
//                 prefixIcon: Icon(Icons.search,
//                     color: Color(0xFF94A3B8), size: 18),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(vertical: 10),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_outlined,
//                     color: Color(0xFF475569)),
//                 onPressed: () {},
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                       color: Color(0xFFEF4444),
//                       shape: BoxShape.circle),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(width: 8),
//           Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: const [
//                   Text('Alex Thompson',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                           color: Color(0xFF0F172A))),
//                   Text('Store Manager',
//                       style: TextStyle(
//                           fontSize: 11, color: Color(0xFF94A3B8))),
//                 ],
//               ),
//               const SizedBox(width: 10),
//               const CircleAvatar(
//                 radius: 18,
//                 backgroundColor: Color(0xFF2563EB),
//                 child: Text('AT',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── CLIENT SELECTOR ───────────────────────

//   Widget _buildClientSelector() {
//     return _card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Select Client',
//               style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                   color: Color(0xFF0F172A))),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _dropdown<String>(
//                   value: _selectedClient,
//                   hint: 'Search existing clients...',
//                   items: _clients,
//                   onChanged: (v) => setState(() => _selectedClient = v),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               ElevatedButton.icon(
//                 onPressed: () => _showNewClientDialog(),
//                 icon: const Icon(Icons.person_add_rounded, size: 16),
//                 label: const Text('New Client'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 18, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   elevation: 0,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── ADD ITEM SECTION ──────────────────────

//   Widget _buildAddItemSection() {
//     return _card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('ADD ITEM',
//               style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 13,
//                   letterSpacing: 0.8,
//                   color: Color(0xFF0F172A))),
//           const SizedBox(height: 16),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _fieldLabel('Item Name'),
//                     const SizedBox(height: 6),
//                     _dropdown<String>(
//                       value: _selectedProduct,
//                       hint: 'Choose an item...',
//                       items: _products,
//                       onChanged: (v) =>
//                           setState(() => _selectedProduct = v),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _fieldLabel('Rate (\$)'),
//                     const SizedBox(height: 6),
//                     _textField(controller: _rateController),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _fieldLabel('Qty'),
//                     const SizedBox(height: 6),
//                     _textField(controller: _qtyController),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               ElevatedButton(
//                 onPressed: _addItem,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   elevation: 0,
//                 ),
//                 child: const Text('Add Item',
//                     style: TextStyle(fontWeight: FontWeight.w600)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── ITEMS TABLE ───────────────────────────

//   Widget _buildItemsTable() {
//     return _card(
//       padding: EdgeInsets.zero,
//       child: Column(
//         children: [
//           // Header row
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 20, vertical: 14),
//             decoration: const BoxDecoration(
//               border: Border(
//                   bottom: BorderSide(color: Color(0xFFE2E8F0))),
//             ),
//             child: Row(
//               children: const [
//                 Expanded(flex: 5, child: _TableHeader('ITEM DESCRIPTION')),
//                 Expanded(
//                     flex: 2,
//                     child: _TableHeader('RATE',
//                         align: TextAlign.center)),
//                 Expanded(
//                     flex: 1,
//                     child:
//                     _TableHeader('QTY', align: TextAlign.center)),
//                 Expanded(
//                     flex: 2,
//                     child: _TableHeader('TOTAL',
//                         align: TextAlign.center)),
//                 SizedBox(width: 50, child: _TableHeader('ACTION')),
//               ],
//             ),
//           ),
//           // Data rows
//           ...List.generate(_invoiceItems.length, (i) {
//             final item = _invoiceItems[i];
//             return Container(
//               decoration: BoxDecoration(
//                 border: i < _invoiceItems.length - 1
//                     ? const Border(
//                     bottom: BorderSide(color: Color(0xFFF1F5F9)))
//                     : null,
//               ),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 20, vertical: 14),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.name,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                                 color: Color(0xFF0F172A))),
//                         Text(item.subtitle,
//                             style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF64748B))),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       '\$${item.rate.toStringAsFixed(2)}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 14, color: Color(0xFF475569)),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Text(
//                       '${item.qty}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 14, color: Color(0xFF475569)),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       '\$${item.total.toStringAsFixed(2)}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Color(0xFF0F172A)),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 50,
//                     child: IconButton(
//                       icon: const Icon(Icons.delete_outline_rounded,
//                           color: Color(0xFF94A3B8), size: 20),
//                       onPressed: () => _removeItem(i),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   // ─── INVOICE SUMMARY ───────────────────────

//   Widget _buildInvoiceSummary() {
//     return Column(
//       children: [
//         _card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('INVOICE SUMMARY',
//                   style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13,
//                       letterSpacing: 0.8,
//                       color: Color(0xFF0F172A))),
//               const SizedBox(height: 20),
//               _summaryRow('Subtotal',
//                   '\$${_subtotal.toStringAsFixed(2)}', false),
//               const SizedBox(height: 10),
//               _summaryRow('Discount (5%)',
//                   '-\$${_discount.toStringAsFixed(2)}', true),
//               const SizedBox(height: 10),
//               _summaryRow('Tax (10%)',
//                   '\$${_tax.toStringAsFixed(2)}', false),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 child: Divider(color: Color(0xFFE2E8F0)),
//               ),
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text('Grand Total',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                               color: Color(0xFF0F172A))),
//                       Text('PAYABLE AMOUNT',
//                           style: TextStyle(
//                               fontSize: 10,
//                               color: Color(0xFF94A3B8),
//                               letterSpacing: 0.8)),
//                     ],
//                   ),
//                   const Spacer(),
//                   Text(
//                     '\$${_grandTotal.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                         color: Color(0xFF2563EB)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 14),

//         // Save Invoice button
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () => _showSaveConfirmation(),
//             icon: const Icon(Icons.save_rounded, size: 18),
//             label: const Text('Save Invoice',
//                 style: TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.w600)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2563EB),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               elevation: 0,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),

//         // Print Invoice button
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             onPressed: () {},
//             icon: const Icon(Icons.print_rounded,
//                 size: 18, color: Color(0xFF475569)),
//             label: const Text('Print Invoice',
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF475569))),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               side: const BorderSide(color: Color(0xFFE2E8F0)),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 14),

//         // Info box
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFEFF6FF),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: const Color(0xFFBFDBFE)),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Icon(Icons.info_outline_rounded,
//                   color: Color(0xFF2563EB), size: 16),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Please ensure all quantity units match the material specifications before saving.',
//                   style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ─── HELPERS ───────────────────────────────

//   Widget _card({required Widget child, EdgeInsets? padding}) {
//     return Container(
//       width: double.infinity,
//       padding: padding ?? const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _summaryRow(String label, String value, bool isDiscount) {
//     return Row(
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 14, color: Color(0xFF64748B))),
//         const Spacer(),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDiscount
//                     ? const Color(0xFF16A34A)
//                     : const Color(0xFF0F172A))),
//       ],
//     );
//   }

//   Widget _fieldLabel(String text) => Text(text,
//       style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF64748B)));

//   Widget _dropdown<T>({
//     required T? value,
//     required String hint,
//     required List<T> items,
//     required ValueChanged<T?> onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: DropdownButton<T>(
//         value: value,
//         hint: Text(hint,
//             style: const TextStyle(
//                 color: Color(0xFF94A3B8), fontSize: 13)),
//         isExpanded: true,
//         underline: const SizedBox(),
//         icon: const Icon(Icons.keyboard_arrow_down_rounded,
//             color: Color(0xFF94A3B8)),
//         items: items
//             .map((e) => DropdownMenuItem<T>(
//           value: e,
//           child: Text(e.toString(),
//               style: const TextStyle(fontSize: 13)),
//         ))
//             .toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   Widget _textField({required TextEditingController controller}) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       style: const TextStyle(fontSize: 13),
//       decoration: InputDecoration(
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFF2563EB)),
//         ),
//       ),
//     );
//   }

//   void _showNewClientDialog() {
//     final nameCtrl = TextEditingController();
//     final emailCtrl = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16)),
//         title: const Text('New Client',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         content: SizedBox(
//           width: 380,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameCtrl,
//                 decoration: const InputDecoration(
//                     labelText: 'Client Name',
//                     border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: emailCtrl,
//                 decoration: const InputDecoration(
//                     labelText: 'Email Address',
//                     border: OutlineInputBorder()),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel')),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2563EB),
//                 foregroundColor: Colors.white),
//             onPressed: () {
//               if (nameCtrl.text.isNotEmpty) {
//                 setState(() => _clients.add(nameCtrl.text));
//               }
//               Navigator.pop(context);
//             },
//             child: const Text('Add Client'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSaveConfirmation() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.check_circle_rounded,
//                 color: Color(0xFF16A34A), size: 24),
//             SizedBox(width: 10),
//             Text('Invoice Saved',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Text(
//           'Invoice saved successfully!\nGrand Total: \$${_grandTotal.toStringAsFixed(2)}',
//           style: const TextStyle(
//               fontSize: 14, color: Color(0xFF475569)),
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2563EB),
//                 foregroundColor: Colors.white),
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Done'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // STATELESS HELPERS
// // ─────────────────────────────────────────────

// class _TableHeader extends StatelessWidget {
//   final String text;
//   final TextAlign align;
//   const _TableHeader(this.text, {this.align = TextAlign.left});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       textAlign: align,
//       style: const TextStyle(
//         fontSize: 11,
//         fontWeight: FontWeight.w700,
//         color: Color(0xFF94A3B8),
//         letterSpacing: 0.6,
//       ),
//     );
//   }
// }