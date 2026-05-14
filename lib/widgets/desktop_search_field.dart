import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DesktopSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final double width;

  const DesktopSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 40,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.textLightPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: AppColors.textLightSecondary),
          prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textLightSecondary),
          filled: true,
          fillColor: AppColors.borderLight.withValues(alpha: 0.3),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}
