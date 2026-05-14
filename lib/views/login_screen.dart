import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../services/session_service.dart';
import '../widgets/pin_input_field.dart';
import '../widgets/primary_button.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppColors.surfaceHighlight, AppColors.backgroundDark],
            radius: 1.4,
          ),
        ),
        child: Stack(
          children: [
            // ── Main content ──────────────────────────────────────────────
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand logo
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue managing your shop',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Role selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RoleCard(
                          title: 'Admin',
                          icon: Icons.admin_panel_settings_outlined,
                          isSelected: vm.selectedRole == UserRole.admin,
                          onTap: () => vm.setSelectedRole(UserRole.admin),
                        ),
                        const SizedBox(width: 16),
                        _RoleCard(
                          title: 'User',
                          icon: Icons.person_outline,
                          isSelected: vm.selectedRole == UserRole.user,
                          onTap: () => vm.setSelectedRole(UserRole.user),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // PIN card
                    Container(
                      width: 420,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderDark),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            vm.selectedRole == UserRole.admin
                                ? 'ENTER ADMIN PIN'
                                : 'ENTER USER PIN',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDarkSecondary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 26),

                          PinInputField(
                            length: 6,
                            isError: vm.errorMessage != null,
                            onChanged: vm.setPin,
                          ),

                          if (vm.errorMessage != null) ...[
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: AppColors.errorRed,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  vm.errorMessage!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.errorRed,
                                  ),
                                ),
                              ],
                            ),
                          ] else
                            const SizedBox(height: 28),

                          const SizedBox(height: 16),

                          PrimaryButton(
                            text: vm.selectedRole == UserRole.admin
                                ? 'Admin Login'
                                : 'User Login',
                            icon: Icons.login,
                            isLoading: vm.isLoading,
                            onPressed: vm.pin.length == 6
                                ? () async {
                              final ok = await vm.login();

                              if (!ok || !context.mounted) return;

                              if (vm.selectedRole == UserRole.admin) {
                                context.goNamed('dashboard');
                              } else {
                                context.goNamed('dashboard'); // or same dashboard
                              }
                              print("LOGIN RESULT FROM VM: $ok");
                            }
                                : null,
                          ),

                          const SizedBox(height: 22),

                          TextButton(
                            onPressed: () {
                              context.goNamed('forgot_password');
                            },
                            child: Text(
                              'Forgot PIN?',
                              style: GoogleFonts.poppins(
                                color: AppColors.textDarkSecondary,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom status bar ────────────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.successGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TERMINAL 08 SECURE   •   V.4.2.0-STABLE',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.textDarkSecondary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // ── Top right actions ─────────────────────────────────────────
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                      color: AppColors.textDarkSecondary,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.language_outlined,
                      color: AppColors.textDarkSecondary,
                    ),
                    onPressed: () {},
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

// ── Role Card ──────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.surfaceHighlight
                : AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primaryBlue
                  : (_hovered ? AppColors.borderDark : const Color(0xFF1F2937)),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    const BoxShadow(
                      color: AppColors.primaryBlueGlow,
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColors.primaryBlue.withValues(alpha: 0.12)
                      : AppColors.surfaceHighlight,
                ),
                child: Icon(
                  widget.icon,
                  size: 24,
                  color: widget.isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: widget.isSelected
                      ? AppColors.textDarkPrimary
                      : AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
