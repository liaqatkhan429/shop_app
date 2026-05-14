import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/utils.dart';
import '../constants/app_colors.dart';
import '../services/customer_services.dart';
import '../viewmodels/customer_viewmodel.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("full screen rebuilding...");
    return ChangeNotifierProvider(
      create: (_) => CustomerViewModel(context.read<CustomerService>())..loadCustomers(),
      child: Consumer<CustomerViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table (left)
                      Expanded(flex: 7, child: _buildTable(vm)),
                      const SizedBox(width: 20),
                      // Right column: Form + Activity
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            _buildForm(vm),
                            const SizedBox(height: 20),
                            _buildRecentActivity(),
                          ],
                        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            'Customers',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textLightPrimary,
            ),
          ),
          const Spacer(),
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
                hintText: 'Search by name or phone',
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

  // ── Clients Table ─────────────────────────────────────────────────────────
  Widget _buildTable(CustomerViewModel vm) {
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
                _th('CLIENT NAME',          flex: 4),
                _th('PHONE',                flex: 2),
                _th('ADDRESS', flex: 2),
                _th('ACTION', flex: 1),
              ],
            ),
          ),
          // Rows
          ...vm.customers.map((client) {
            return _ClientRow(client: client);
          }),
        ],
      ),
    );
  }

  Widget _th(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textLightSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // ── Add Client Form ───────────────────────────────────────────────────────
  Widget _buildForm(CustomerViewModel vm) {
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
          Text('Add New Client', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary)),
          const SizedBox(height: 22),

          _label('FULL NAME'),
         textInput("Customer name", vm.nameController, (val){}, errorText: vm.nameError),
          const SizedBox(height: 16),

          _label('PHONE NUMBER'),
          textInput("Phone no", vm.phoneController, (val){}, errorText: vm.phoneError,inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 16),

          _label('ADDRESS'),
          textInput("Customer address", vm.addressController, (val){}, errorText: vm.addressError),
          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (){
                bool isValid = vm.validate();
                if (!isValid) return;

                if (vm.editingCustomer != null) {
                  vm.updateCustomer();
                } else {
                  vm.saveCustomer();
                }
              },
              icon: const Icon(Icons.person_add_outlined, size: 16),
              label: Text(vm.editingCustomer != null
                  ? 'Update Customer'
                  : 'Save Customer', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
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
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Activity Card ──────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT ACTIVITY',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textLightSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 18),
          _activityItem('New invoice created for John Doe', '2 minutes ago', AppColors.successGreen),
          const SizedBox(height: 16),
          _activityItem('Walk-in client registered', '1 hour ago', AppColors.primaryBlue),
          const SizedBox(height: 16),
          _activityItem('Payment received from Ahmad Khan', '3 hours ago', AppColors.warningYellow),
        ],
      ),
    );
  }

  Widget _activityItem(String text, String time, Color dotColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary)),
              const SizedBox(height: 3),
              Text(time, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLightSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textLightSecondary, letterSpacing: 0.8)),
    );
  }

}

// ── Client Row Widget ──────────────────────────────────────────────────────
class _ClientRow extends StatefulWidget {
  final dynamic client;
  const _ClientRow({required this.client});

  @override
  State<_ClientRow> createState() => _ClientRowState();
}

class _ClientRowState extends State<_ClientRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    print("🔵 CLIENT ROW BUILD: ${widget.client.name}");
    final client = widget.client;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFF9FAFB) : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: Text(
                      client.name.substring(0, 2).toUpperCase(),
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(client.name, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary)),
                  ),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(client.phone, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary))),
            Expanded(flex: 2, child: Text(client.address, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightSecondary))),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Edit
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.textLightSecondary,
                    ),
                    onPressed: () {
                      context
                          .read<CustomerViewModel>()
                          .startEditCustomer(client);
                    },
                    splashRadius: 16,
                  ),

                  // Delete
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AppColors.errorRed,
                    ),
                    onPressed: () {
                      context
                          .read<CustomerViewModel>()
                          .deleteCustomer(client.id);
                    },
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
