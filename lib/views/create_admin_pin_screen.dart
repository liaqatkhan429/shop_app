import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../widgets/pin_input_field.dart';
import '../widgets/primary_button.dart';
import '../viewmodels/create_pin_viewmodel.dart';

class CreateAdminPinScreen extends StatelessWidget {
  const CreateAdminPinScreen({super.key});

  void _showRecoveryCodeDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceHighlight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Recovery Code Generated',
          style: GoogleFonts.poppins(
            color: AppColors.textDarkPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please save this recovery code in a secure location. It is the ONLY way to reset your Admin PIN if you forget it.',
              style: GoogleFonts.poppins(
                color: AppColors.textDarkSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryBlue),
              ),
              alignment: Alignment.center,
              child: SelectableText(
                code,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            text: 'I HAVE SAVED IT',
            width: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed('login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreatePinViewModel>(context);

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
                      Icons.lock_outline,
                      color: AppColors.textDarkSecondary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ── Main Content ──────────────────────────────────────────────
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand header

                  // Main card
                  Container(
                    width: 500,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.borderDark.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.06),
                          blurRadius: 60,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Lock icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceHighlight,
                            border: Border.all(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.primaryBlueGlow,
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 36,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Setup Admin Security',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Create a secure PIN to protect your shop\nsystem and sensitive inventory data.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textDarkSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Initial PIN
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'INITIAL PIN',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDarkSecondary.withValues(
                                alpha: 0.8,
                              ),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        PinInputField(length: 6, onChanged: vm.setInitialPin),

                        const SizedBox(height: 32),

                        // Confirm PIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CONFIRM PIN',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDarkSecondary.withValues(
                                  alpha: 0.8,
                                ),
                                letterSpacing: 1.2,
                              ),
                            ),
                            if (vm.errorMessage != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 14,
                                    color: AppColors.errorRed,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    vm.errorMessage!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.errorRed,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        PinInputField(
                          length: 6,
                          isError: vm.errorMessage != null,
                          onChanged: vm.setConfirmPin,
                        ),

                        const SizedBox(height: 44),

                        PrimaryButton(
                          text: 'Create PIN',
                          isLoading: vm.isLoading,
                          onPressed:
                              (vm.initialPin.length == 6 &&
                                  vm.confirmPin.length == 6)
                              ? () async {
                                  final ok = await vm.createAdminPin();
                                  if (ok &&
                                      vm.recoveryCode != null &&
                                      context.mounted) {
                                    _showRecoveryCodeDialog(
                                      context,
                                      vm.recoveryCode!,
                                    );
                                  }
                                }
                              : null,
                        ),

                        const SizedBox(height: 24),
                        RichText(
                          text: TextSpan(
                            text: 'Forgot your security settings? ',
                            style: GoogleFonts.poppins(
                              color: AppColors.textDarkSecondary,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Contact System Admin',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
