import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/services/user_services.dart';
import 'package:shop_app/widgets/utils.dart';

import '../constants/app_colors.dart';
import '../models/users_model.dart';
import '../viewmodels/users_viewmodel.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(context.read<UserService>())..loadUsers(),
      child: Consumer<UserViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              _buildTopBar(vm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildTable(vm)),
                      const SizedBox(width: 20),
                      SizedBox(width: 320, child: _buildForm(vm)),
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

  // ───────────────── TOP BAR ─────────────────
  Widget _buildTopBar(UserViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Text(
            'Users',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Spacer(),

          // SEARCH
          searchBar("Search User...", vm.searchUsers),
        ],
      ),
    );
  }

  // ───────────────── TABLE ─────────────────
  Widget _buildTable(UserViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _tableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: vm.users.length,
              itemBuilder: (context, index) {
                final user = vm.users[index];
                return Column(
                  children: [
                    _UserRow(
                      user: user,
                      onEdit: () => vm.startEditUser(user),
                      onDelete: () => vm.deleteUser(user.id),
                    ),
                    Divider(color: AppColors.borderLight, thickness: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          _th('NAME', flex: 4),
          _th('PIN', flex: 3),
          _th('ACTIONS', flex: 2, align: TextAlign.center),
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
        ),
      ),
    );
  }

  // ───────────────── FORM (ADD / UPDATE USER) ─────────────────
  Widget _buildForm(UserViewModel vm) {
    final isEditing = vm.editingUser != null;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New User',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          _label('USER NAME'),
          textInput(
            "Enter user name",
            vm.nameController,
            (value) {},
            errorText: vm.nameError,
          ),

          const SizedBox(height: 16),

          _label('USER PIN (6 DIGITS)'),
          textInput(
            "Enter PIN",
            vm.pinController,
            (value) {},
            errorText: vm.pinError,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                bool isValid = vm.validate();

                // ❌ Stop submit if invalid
                if (!isValid) return;

                if (isEditing) {
                  vm.updateUser();
                } else {
                  vm.addUser();
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isEditing ? 'Update User' : 'Add User',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          if (isEditing) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: vm.clearForm,
              child: const Text('Cancel Edit'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textLightSecondary,
        ),
      ),
    );
  }

  // Widget _textField(
  //   TextEditingController controller,
  //   String hint, {
  //   bool isNumber = false,
  // }) {
  //   return TextField(
  //     style: GoogleFonts.poppins(
  //       fontSize: 12,
  //       fontWeight: FontWeight.w400,
  //       color: AppColors.textDarkSecondary,
  //     ),
  //     controller: controller,
  //     keyboardType: isNumber ? TextInputType.number : TextInputType.text,
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       filled: true,
  //       fillColor: AppColors.cardWhite,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   );
  // }
}

// ── Row Widget ─────────────────────────────────────────────────────────────
class _UserRow extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserRow({
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              user.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              user.pin,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textLightSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
