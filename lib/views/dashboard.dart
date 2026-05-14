// import 'package:flutter/material.dart';


// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int selectedTab = 0;
//   int selectedNav = 0;
//   final List<String> tabs = ['Today', 'Weekly', 'Monthly'];

//   final List<Map<String, dynamic>> navItems = [
//     {'icon': Icons.grid_view_rounded, 'label': 'Dashboard'},
//     {'icon': Icons.receipt_long_outlined, 'label': 'Create Invoice'},
//     {'icon': Icons.people_outline, 'label': 'Clients'},
//     {'icon': Icons.inventory_2_outlined, 'label': 'Items'},
//     {'icon': Icons.bar_chart_outlined, 'label': 'Reports'},
//   ];

//   final List<Map<String, dynamic>> invoices = [
//     {
//       'no': '#INV-2024-001',
//       'initials': 'SM',
//       'client': 'Skyline Modern Build',
//       'date': 'Oct 24, 2023',
//       'amount': '\$12,450.00',
//       'status': 'Paid',
//       'avatarColor': Color(0xFFE0E7FF),
//       'avatarText': Color(0xFF3730A3),
//     },
//     {
//       'no': '#INV-2024-002',
//       'initials': 'UR',
//       'client': 'Urban Renovations Ltd.',
//       'date': 'Oct 23, 2023',
//       'amount': '\$8,200.00',
//       'status': 'Pending',
//       'avatarColor': Color(0xFFE0F2FE),
//       'avatarText': Color(0xFF0369A1),
//     },
//     {
//       'no': '#INV-2024-003',
//       'initials': 'TC',
//       'client': 'Terra Concrete Corp',
//       'date': 'Oct 22, 2023',
//       'amount': '\$15,800.00',
//       'status': 'Paid',
//       'avatarColor': Color(0xFFFEF9C3),
//       'avatarText': Color(0xFF854D0E),
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       body: Row(
//         children: [
//           _buildSidebar(),
//           Expanded(child: _buildMain()),
//         ],
//       ),
//     );
//   }

//   Widget _buildSidebar() {
//     return Container(
//       width: 240,
//       color: const Color(0xFF111827),
//       child: Column(
//         children: [
//           _buildBrand(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Column(
//                 children: List.generate(navItems.length, (i) => _buildNavItem(i)),
//               ),
//             ),
//           ),
//           Container(
//             height: 0.5,
//             color: Colors.white.withOpacity(0.08),
//             margin: const EdgeInsets.symmetric(horizontal: 12),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 _buildFooterItem(Icons.settings_outlined, 'Settings', Colors.white70),
//                 const SizedBox(height: 2),
//                 _buildFooterItem(Icons.logout_rounded, 'Logout', const Color(0xFFF87171)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBrand() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: const Color(0xFF2563EB),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.construction, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('BuildMax',
//                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
//               Text('Construction Management',
//                   style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(int index) {
//     final item = navItems[index];
//     final isActive = selectedNav == index;
//     return GestureDetector(
//       onTap: () => setState(() => selectedNav = index),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 2),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(item['icon'] as IconData,
//                 color: isActive ? Colors.white : const Color(0xFF9CA3AF), size: 16),
//             const SizedBox(width: 10),
//             Text(item['label'] as String,
//                 style: TextStyle(
//                   color: isActive ? Colors.white : const Color(0xFF9CA3AF),
//                   fontSize: 13.5,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFooterItem(IconData icon, String label, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 16),
//           const SizedBox(width: 10),
//           Text(label, style: TextStyle(color: color, fontSize: 13.5)),
//         ],
//       ),
//     );
//   }

//   Widget _buildMain() {
//     return Column(
//       children: [
//         _buildTopBar(),
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildStatCards(),
//                 const SizedBox(height: 16),
//                 _buildChartsRow(),
//                 const SizedBox(height: 16),
//                 _buildInvoicesTable(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTopBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           const Text('Dashboard',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//           const Spacer(),
//           _buildTabGroup(),
//           const SizedBox(width: 16),
//           _buildExportButton(),
//           const SizedBox(width: 16),
//           CircleAvatar(
//             radius: 17,
//             backgroundColor: const Color(0xFF6366F1),
//             child: const Text('JD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabGroup() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: List.generate(tabs.length, (i) {
//           final isActive = selectedTab == i;
//           return GestureDetector(
//             onTap: () => setState(() => selectedTab = i),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
//               decoration: BoxDecoration(
//                 color: isActive ? const Color(0xFFF3F4F6) : Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(tabs[i],
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: isActive ? const Color(0xFF111827) : const Color(0xFF6B7280),
//                     fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
//                   )),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildExportButton() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2563EB),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: const [
//           Icon(Icons.download_rounded, color: Colors.white, size: 14),
//           SizedBox(width: 6),
//           Text('Export Report', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCards() {
//     final stats = [
//       {'label': 'Total Sales', 'value': '\$124,500', 'badge': '+12.5%', 'up': true},
//       {'label': 'Total Invoices', 'value': '1,240', 'badge': '+5.2%', 'up': true},
//       {'label': 'Pending Payments', 'value': '\$18,200', 'badge': '-2.4%', 'up': false},
//       {'label': 'Total Clients', 'value': '450', 'badge': '+8%', 'up': true},
//     ];
//     return Row(
//       children: stats
//           .map((s) => Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(right: s == stats.last ? 0 : 14),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(s['label'] as String,
//                           style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
//                       const SizedBox(height: 10),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(s['value'] as String,
//                               style: const TextStyle(
//                                   fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: (s['up'] as bool) ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(s['badge'] as String,
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w500,
//                                   color: (s['up'] as bool) ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
//                                 )),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   Widget _buildChartsRow() {
//     return Row(
//       children: [
//         Expanded(child: _buildSalesChart()),
//         const SizedBox(width: 14),
//         Expanded(child: _buildRevenueChart()),
//       ],
//     );
//   }

//   Widget _buildSalesChart() {
//     final points = [0.3, 0.38, 0.34, 0.48, 0.44, 1.0];
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
//                 Text('Sales Overview',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//                 SizedBox(height: 2),
//                 Text('Last 6 Months', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
//               ]),
//               const Spacer(),
//               Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
//                 Text('\$124,500',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//                 Text('+12.5%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF16A34A))),
//               ]),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 160,
//             child: CustomPaint(
//               painter: LineChartPainter(points),
//               child: Container(),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
//                 .map((m) => Text(m, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRevenueChart() {
//     final revenue = [0.8, 0.85, 0.76, 0.93, 0.88, 1.0];
//     final expenses = [0.49, 0.53, 0.59, 0.56, 0.65, 0.61];
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
//                 Text('Revenue vs Expenses',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//                 SizedBox(height: 2),
//                 Text('Monthly Breakdown', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
//               ]),
//               const Spacer(),
//               Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
//                 Text('\$85,000',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//                 Text('-5.2%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFDC2626))),
//               ]),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 160,
//             child: CustomPaint(
//               painter: BarChartPainter(revenue, expenses),
//               child: Container(),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
//                 .map((m) => Text(m, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInvoicesTable() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Text('Recent Invoices',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//               const Spacer(),
//               const Text('View All', style: TextStyle(fontSize: 13, color: Color(0xFF2563EB))),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildTableHeader(),
//           const Divider(height: 1, color: Color(0xFFE5E7EB)),
//           ...invoices.map((inv) => _buildInvoiceRow(inv)).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTableHeader() {
//     const style = TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.w500, letterSpacing: 0.04);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: const [
//           Expanded(flex: 2, child: Text('INVOICE NO', style: style)),
//           Expanded(flex: 3, child: Text('CLIENT', style: style)),
//           Expanded(flex: 2, child: Text('DATE', style: style)),
//           Expanded(flex: 2, child: Text('AMOUNT', style: style)),
//           Expanded(flex: 2, child: Text('STATUS', style: style)),
//           Expanded(flex: 1, child: Text('ACTION', style: style, textAlign: TextAlign.center)),
//         ],
//       ),
//     );
//   }

//   Widget _buildInvoiceRow(Map<String, dynamic> inv) {
//     final isPaid = inv['status'] == 'Paid';
//     return Column(
//       children: [
//         const Divider(height: 1, color: Color(0xFFE5E7EB)),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Text(inv['no'] as String,
//                     style: const TextStyle(fontSize: 13, color: Color(0xFF2563EB))),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 14,
//                       backgroundColor: inv['avatarColor'] as Color,
//                       child: Text(inv['initials'] as String,
//                           style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: inv['avatarText'] as Color)),
//                     ),
//                     const SizedBox(width: 10),
//                     Flexible(
//                       child: Text(inv['client'] as String,
//                           style: const TextStyle(fontSize: 13, color: Color(0xFF111827))),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(inv['date'] as String,
//                     style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(inv['amount'] as String,
//                     style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   width: 60,
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF9C3),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(inv['status'] as String,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500,
//                         color: isPaid ? const Color(0xFF15803D) : const Color(0xFF854D0E),
//                       )),
//                 ),
//               ),
//               const Expanded(
//                 flex: 1,
//                 child: Icon(Icons.more_vert, color: Color(0xFF9CA3AF), size: 18),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Line Chart Painter
// class LineChartPainter extends CustomPainter {
//   final List<double> points;
//   LineChartPainter(this.points);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final linePaint = Paint()
//       ..color = const Color(0xFF2563EB)
//       ..strokeWidth = 2.5
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final fillPaint = Paint()..style = PaintingStyle.fill;

//     final w = size.width;
//     final h = size.height;
//     final step = w / (points.length - 1);

//     List<Offset> offsets = List.generate(points.length, (i) {
//       return Offset(i * step, h - (points[i] * h * 0.85) - 10);
//     });

//     final path = Path();
//     final fillPath = Path();

//     path.moveTo(offsets[0].dx, offsets[0].dy);
//     fillPath.moveTo(offsets[0].dx, offsets[0].dy);

//     for (int i = 0; i < offsets.length - 1; i++) {
//       final cp1 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i].dy);
//       final cp2 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i + 1].dy);
//       path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
//       fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
//     }

//     fillPath.lineTo(w, h);
//     fillPath.lineTo(0, h);
//     fillPath.close();

//     final gradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [const Color(0xFF2563EB).withOpacity(0.18), const Color(0xFF2563EB).withOpacity(0.0)],
//     );

//     fillPaint.shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h));
//     canvas.drawPath(fillPath, fillPaint);
//     canvas.drawPath(path, linePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // Bar Chart Painter
// class BarChartPainter extends CustomPainter {
//   final List<double> revenue;
//   final List<double> expenses;
//   BarChartPainter(this.revenue, this.expenses);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final bluePaint = Paint()..color = const Color(0xFF2563EB);
//     final grayPaint = Paint()..color = const Color(0xFFE5E7EB);

//     final w = size.width;
//     final h = size.height - 10;
//     final groupWidth = w / revenue.length;
//     const barWidth = 10.0;
//     const gap = 4.0;
//     const rr = Radius.circular(3);

//     for (int i = 0; i < revenue.length; i++) {
//       final groupX = i * groupWidth + groupWidth / 2;

//       final revH = revenue[i] * h * 0.85;
//       final revX = groupX - barWidth - gap / 2;
//       canvas.drawRRect(
//         RRect.fromLTRBAndCorners(revX, h - revH, revX + barWidth, h, topLeft: rr, topRight: rr),
//         bluePaint,
//       );

//       final expH = expenses[i] * h * 0.85;
//       final expX = groupX + gap / 2;
//       canvas.drawRRect(
//         RRect.fromLTRBAndCorners(expX, h - expH, expX + barWidth, h, topLeft: rr, topRight: rr),
//         grayPaint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }