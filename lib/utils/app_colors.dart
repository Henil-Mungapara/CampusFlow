import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF07294D); // Deep Navy Blue
  static const Color primaryLight = Color(0xFF134E8E);
  static const Color secondary = Color(0xFF0EA5E9); // Sky Blue
  static const Color accent = Color(0xFFF43F5E); // Rose

  // Background and Surfaces
  static const Color background = Colors.white; // Pure White Background
  static const Color surface = Colors.white; // White Surface
  static const Color cardColor = Color(0xFFF8FAFC); // Very light gray for contrast against white BG
  static const Color glassSurface = Color(0xCCFFFFFF); 

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Almost Black
  static const Color textSecondary = Color(0xFF64748B); // Slate Gray
  static const Color textLight = Color(0xFF94A3B8);

  // Priority / Semantic Colors
  static const Color priorityUrgent = Color(0xFFEF4444); // Red
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber/Yellow
  static const Color priorityLow = Color(0xFF10B981); // Emerald/Green

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF07294D), Color(0xFF134E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Default Shadow
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: const Color(0xFF07294D).withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF07294D).withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
}
