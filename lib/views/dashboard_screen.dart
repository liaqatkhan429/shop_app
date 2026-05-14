import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 1; // Weekly by default

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..loadDashboardData(),
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          return Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatCards(),
                      const SizedBox(height: 20),
                      _buildChartsRow(),
                      const SizedBox(height: 20),
                      _buildRecentInvoices(vm),
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
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            'Dashboard',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textLightPrimary,
            ),
          ),
          const Spacer(),
          // Tab Group
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildTabPill('Today', 0),
                _buildTabPill('Weekly', 1),
                _buildTabPill('Monthly', 2),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Export button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 15),
            label: Text('Export Report', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFF6366F1),
            child: Text('JD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill(String label, int index) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF3F4F6) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            color: isActive ? AppColors.textLightPrimary : AppColors.textLightSecondary,
          ),
        ),
      ),
    );
  }

  // ── Stat Cards ────────────────────────────────────────────────────────────
  Widget _buildStatCards() {
    final stats = [
      {'label': 'Total Sales',       'value': '\$124,500', 'badge': '+12.5%', 'up': true},
      {'label': 'Total Invoices',    'value': '1,240',     'badge': '+5.2%',  'up': true},
      {'label': 'Pending Payments',  'value': '\$18,200',  'badge': '-2.4%',  'up': false},
      {'label': 'Total Clients',     'value': '450',       'badge': '+8%',    'up': true},
    ];

    return Row(
      children: List.generate(stats.length, (i) {
        final s = stats[i];
        final isUp = s['up'] as bool;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < stats.length - 1 ? 14 : 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['label'] as String,
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLightSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      s['value'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isUp
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s['badge'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isUp ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Charts Row ────────────────────────────────────────────────────────────
  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildSalesChart()),
        const SizedBox(width: 14),
        Expanded(flex: 4, child: _buildRevenueChart()),
      ],
    );
  }

  Widget _buildSalesChart() {
    final points = [0.3, 0.38, 0.34, 0.48, 0.44, 1.0];
    return _ChartCard(
      title: 'Sales Overview',
      subtitle: 'Last 6 Months',
      value: '\$124,500',
      growth: '+12.5%',
      isPositive: true,
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _LineChartPainter(points),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    final revenue  = [0.8, 0.85, 0.76, 0.93, 0.88, 1.0];
    final expenses = [0.49, 0.53, 0.59, 0.56, 0.65, 0.61];
    return _ChartCard(
      title: 'Revenue vs Expenses',
      subtitle: 'Monthly Breakdown',
      value: '\$85,000',
      growth: '-5.2%',
      isPositive: false,
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _BarChartPainter(revenue, expenses),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  // ── Recent Invoices Table ─────────────────────────────────────────────────
  Widget _buildRecentInvoices(DashboardViewModel vm) {
    final invoices = [
      {'no': '#INV-2024-001', 'initials': 'SM', 'client': 'Skyline Modern Build',    'date': 'Oct 24, 2023', 'amount': '\$12,450.00', 'status': 'Paid',    'ac': const Color(0xFFE0E7FF), 'at': const Color(0xFF3730A3)},
      {'no': '#INV-2024-002', 'initials': 'UR', 'client': 'Urban Renovations Ltd.',  'date': 'Oct 23, 2023', 'amount': '\$8,200.00',  'status': 'Pending', 'ac': const Color(0xFFE0F2FE), 'at': const Color(0xFF0369A1)},
      {'no': '#INV-2024-003', 'initials': 'TC', 'client': 'Terra Concrete Corp',     'date': 'Oct 22, 2023', 'amount': '\$15,800.00', 'status': 'Paid',    'ac': const Color(0xFFFEF9C3), 'at': const Color(0xFF854D0E)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Text('Recent Invoices', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary)),
                const Spacer(),
                Text('View All', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // Table header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _tableHeader('INVOICE NO', flex: 2),
                _tableHeader('CLIENT',     flex: 3),
                _tableHeader('DATE',       flex: 2),
                _tableHeader('AMOUNT',     flex: 2),
                _tableHeader('STATUS',     flex: 2),
                _tableHeader('ACTION',     flex: 1, align: TextAlign.center),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // Rows
          ...invoices.map((inv) {
            final isPaid = inv['status'] == 'Paid';
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(inv['no'] as String, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryBlue))),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: inv['ac'] as Color,
                              child: Text(inv['initials'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: inv['at'] as Color)),
                            ),
                            const SizedBox(width: 10),
                            Flexible(child: Text(inv['client'] as String, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary))),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: Text(inv['date'] as String, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary))),
                      Expanded(flex: 2, child: Text(inv['amount'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary))),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF9C3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            inv['status'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isPaid ? const Color(0xFF15803D) : const Color(0xFF854D0E),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(flex: 1, child: Icon(Icons.more_vert, color: AppColors.textLightSecondary, size: 18)),
                    ],
                  ),
                ),
                if (inv != invoices.last) const Divider(height: 1, color: AppColors.borderLight),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _tableHeader(String text, {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textLightSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ── Chart Card ─────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  final String title, subtitle, value, growth;
  final bool isPositive;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.growth,
    required this.isPositive,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLightSecondary)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary)),
                  Text(growth,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
                .map((m) => Text(m, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLightSecondary)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Line Chart Painter ─────────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<double> points;
  _LineChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final step = w / (points.length - 1);

    final offsets = List.generate(points.length, (i) {
      return Offset(i * step, h - (points[i] * h * 0.82) - 6);
    });

    final path = Path()..moveTo(offsets[0].dx, offsets[0].dy);
    final fill = Path()..moveTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final cp1 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i].dy);
      final cp2 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i + 1].dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
      fill.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
    }

    fill.lineTo(w, h);
    fill.lineTo(0, h);
    fill.close();

    fillPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x2E2563EB), Color(0x002563EB)],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Bar Chart Painter ──────────────────────────────────────────────────────
class _BarChartPainter extends CustomPainter {
  final List<double> revenue;
  final List<double> expenses;
  _BarChartPainter(this.revenue, this.expenses);

  @override
  void paint(Canvas canvas, Size size) {
    final blue = Paint()..color = AppColors.primaryBlue;
    final gray = Paint()..color = AppColors.borderLight;
    final w = size.width;
    final h = size.height - 10;
    final gw = w / revenue.length;
    const bw = 10.0;
    const gap = 4.0;
    const rr = Radius.circular(3);

    for (int i = 0; i < revenue.length; i++) {
      final gx = i * gw + gw / 2;

      final rh = revenue[i] * h * 0.82;
      final rx = gx - bw - gap / 2;
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(rx, h - rh, rx + bw, h, topLeft: rr, topRight: rr),
        blue,
      );

      final eh = expenses[i] * h * 0.82;
      final ex = gx + gap / 2;
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(ex, h - eh, ex + bw, h, topLeft: rr, topRight: rr),
        gray,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
