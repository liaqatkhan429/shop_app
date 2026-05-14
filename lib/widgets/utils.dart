import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';


//////// Text field
Widget textInput(
    String hint,

    TextEditingController  controller,
    ValueChanged<String> onChanged, {
      List<TextInputFormatter>? inputFormatters,
      bool hasError = false,
      String? errorText,
    }) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    inputFormatters: inputFormatters,
    style: GoogleFonts.poppins(
      fontSize: 13,
      color: AppColors.textLightPrimary,
    ),
    decoration: InputDecoration(
      hintText: hint,
      errorText: errorText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: AppColors.textLightSecondary,
      ),

      filled: true,
      fillColor: AppColors.cardWhite,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
      ),

      // 🔴 Error Border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),

      // 🔴 Focused Error Border
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),

    ),
  );
}

// label
Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textLightSecondary, letterSpacing: 0.8)),
  );
}



///////// Search Bar
Widget searchBar(
    String hint,
    ValueChanged<String> onChanged,

    ){
  return   Container(
    width: 280,
    height: 38,
    decoration: BoxDecoration(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLightPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppColors.textLightSecondary, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: AppColors.textLightSecondary, size: 18),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    ),
  );
}