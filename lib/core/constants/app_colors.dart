// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // A private constructor prevents anyone from accidentally creating
  // an instance of this class (e.g., AppColors()). We only want to use the static variables.
  AppColors._();

  // --- Background Colors ---
  // A deep dark charcoal/black for the main scaffold background
  static const Color background = Color(0xFF0F0F13);

  // Slightly lighter dark color for cards, dialogs, and bottom navigation
  static const Color surface = Color(0xFF1E1E24);

  // Highlight color when an item is tapped or hovered
  static const Color surfaceHighlight = Color(0xFF25252D);

  // --- Primary Theme Colors (Purple) ---
  // The main brand color used for active buttons, tabs, and loaders
  static const Color primary = Color(0xFF9333EA);
  static const Color primaryLight = Color(0xFFA855F7);
  static const Color primaryDark = Color(0xFF7E22CE);

  // --- Text Colors ---
  // Main text for titles and important information (White)
  static const Color textPrimary = Color(0xFFFFFFFF);

  // Secondary text for subtitles, dates, or descriptions (Grey)
  static const Color textSecondary = Color(0xFFA1A1AA);

  // Very faded text for disabled items or placeholders
  static const Color textMuted = Color(0xFF71717A);

  // --- Status & Alert Colors ---
  // Used for error messages or deleting items
  static const Color error = Color(0xFFEF4444);

  // Used for success messages or completed items
  static const Color success = Color(0xFF22C55E);

  // Used for warnings
  static const Color warning = Color(0xFFF59E0B);
}