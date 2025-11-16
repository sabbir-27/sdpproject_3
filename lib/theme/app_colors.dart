import 'package:flutter/material.dart';

// A more modern, cohesive, and professional color palette.
class AppColors {

  // --- Primary Palette ---
  static const Color primary = Color(0xFF0D6EFD);      // A modern, professional blue
  static const Color accent = Color(0xFFFD7E14);       // A vibrant, complementary orange

  // --- Status & Feedback ---
  static const Color success = Color(0xFF198754);      // A clear green for success states
  static const Color warning = Color(0xFFFFC107);      // A noticeable yellow for warnings
  static const Color error = Color(0xFFDC3545);        // A strong red for errors

  // --- Role-Specific Accents ---
  static const Color accentShopOwner = Color(0xFF1976D2); // A distinct blue for shop owner UI
  static const Color accentPolice = Color(0xFFD32F2F); // A conventional red for police/emergency UI

  // --- UI Neutrals & Backgrounds ---
  static const Color gradientStart = Color(0xFFF8F9FA); // A very light, clean grey
  static const Color gradientEnd = Color(0xFFFFFFFF);   // Pure white
  static const Color textDark = Color(0xFF212529);     // High-contrast, near-black
  static const Color textLight = Color(0xFFFFFFFF);    // Pure white for dark backgrounds
  static const Color textGrey = Color(0xFF6C757D);     // A softer grey for subtitles and secondary text

  // --- Dark Theme Palette ---
  static const Color darkBackground = Color(0xFF0A1017);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkNeon = Color(0xFF22D3EE);      // A bright cyan/mint for accents in dark mode
  static const Color darkGlass = Color(0x1AFFFFFF);    // For semi-transparent surfaces

  // Helper method for generating varied colors for charts
  static Color getPastelColor(int index) {
    final List<Color> pastelColors = [
      const Color(0xFF5E97F6), // Lighter Blue
      const Color(0xFF76D7C4), // Mint Green
      const Color(0xFFA9DFBF), // Pastel Green
      const Color(0xFFF7DC6F), // Pastel Yellow
      const Color(0xFFFAD7A0), // Light Orange
      const Color(0xFFF1948A), // Light Coral
    ];
    return pastelColors[index % pastelColors.length];
  }
}
