import 'package:flutter/material.dart';

class AppColors {
  // Main brand colors
  static const Color orangeVif = Color(0xFFE1701A);
  static const Color bleuNuit = Color(0xFF0C1C2C);
  static const Color blanc = Color(0xFFFFFFFF);
  
  // Color variations
  static const Color orangeLight = Color(0xFFF4A261);
  static const Color orangeDark = Color(0xFFD2691E);
  static const Color bleuNuitLight = Color(0xFF1A2A3A);
  static const Color bleuNuitDark = Color(0xFF05111C);
  
  // Neutral colors
  static const Color greyLight = Color(0xFFF8F9FA);
  static const Color greyMedium = Color(0xFF6C757D);
  static const Color greyDark = Color(0xFF343A40);
  
  // Status colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [orangeVif, orangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [bleuNuit, bleuNuitLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Shadow colors
  static Color get shadowColor => bleuNuit.withOpacity(0.1);
  static Color get cardShadow => bleuNuit.withOpacity(0.05);
}
