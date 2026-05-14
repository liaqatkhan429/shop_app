import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../viewmodels/forget_password_viewmodel.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForgotPasswordViewModel>(context);

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
              top: 26,
              left: 26,
              child:  IconButton(onPressed: (){
                context.goNamed('login');
              }, icon:  Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),)
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
                            Icons.lock_reset,
                            size: 36,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Setup Admin Password Recovery',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Please enter your recovery code. It is the ONLY way to reset or forgot your Admin PIN.',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textDarkSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Initial PIN
              

                        const SizedBox(height: 32),

                        // Confirm PIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recovery Code',
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
                        // TEXT FIELD BETWEEN ROW AND BUTTON

                        const SizedBox(height: 12),

                        TextField(
                          onChanged: vm.setRecoveryCode,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDarkPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Recovery Code',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textDarkSecondary.withValues(alpha: 0.6),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundDark,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.borderColor.withValues(alpha: 0.2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.borderColor.withValues(alpha: 0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.borderDark,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        PrimaryButton(
                          text: 'Verify Recovery Code',
                          isLoading: vm.isLoading,
                          onPressed: () async {
                            final isValid = await vm.verifyRecoveryCode();

                            if (isValid) {
                              if (!context.mounted) return;
                              context.goNamed('create_admin_pin');
                            }
                          },
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
