import 'package:flutter/material.dart';

/// Zoovana premium color palette — vibrant, high-energy, nature-inspired
/// Designed to evoke a 'lively' and luxurious pet lifestyle brand.
class AppColors {
  AppColors._();

  // ───── Brand Core (Vibrant Blue #007BFF) ─────
  static const Color brand = Color(0xFF007BFF);          // Base color 007BFF
  static const Color brandLight = Color(0xFF4DA3FF);     // Lighter blue
  static const Color brandSoft = Color(0xFFE5F2FF);      // Very light blue tint
  static const Color brandDeep = Color(0xFF0056B3);      // Deep blue for press states

  // ───── Accent (Matching Blue to avoid gold/other colors) ─────
  static const Color accent = Color(0xFF0069D9);         // Strong blue accent
  static const Color accentSoft = Color(0xFFCCE5FF);     // Light blue bg
  static const Color accentDeep = Color(0xFF004085);     // Deep blue

  // ───── Anchor / Navy ─────
  static const Color navy = Color(0xFF0C1322);           // Very deep, rich midnight blue
  static const Color navyLight = Color(0xFF1E2D4A);      // Soft navy
  
  // ───── Light Surfaces ─────
  static const Color surfaceBase = Color(0xFFF8FAFC);    // Extremely clean, slight cool off-white
  static const Color surfaceRaised = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFF0F7FF);    // Blue-tinted bg
  static const Color surfaceSubtle = Color(0xFFF1F5F9);  // Clean gray
  static const Color borderSubtle = Color(0xFFE2E8F0);   // Soft border
  static const Color borderStrong = Color(0xFFCBD5E1);

  // ───── Dark Surfaces ─────
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkSurfaceRaised = Color(0xFF1E293B);
  static const Color darkSurfaceTint = Color(0xFF0F172A);
  static const Color darkBorderSubtle = Color(0xFF334155);

  // ───── Text (Light) ─────
  static const Color textPrimary = Color(0xFF0F172A);    // High contrast near-black
  static const Color textSecondary = Color(0xFF64748B);  // Slate gray
  static const Color textTertiary = Color(0xFF94A3B8);

  // ───── Text (Dark) ─────
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // ───── Semantic ─────
  static const Color success = Color(0xFF10B981);
  static const Color successSoft = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSoft = Color(0xFFDBEAFE);
  static const Color disabled = Color(0xFFCBD5E1);

  // ───── Skeleton / Shimmer ─────
  static const Color skeletonBase = Color(0xFFE2E8F0);
  static const Color skeletonHighlight = Color(0xFFF1F5F9);

  // ───── Aliases (keep backward compat) ─────
  static const Color primary = brand;
  static const Color surface = surfaceBase;
  static const Color onSurface = textPrimary;
  static const Color muted = textSecondary;
  static const Color error = danger;

  // ───── Gradients ─────
  /// Extremely vibrant and smooth gradient for hero sections and splash screens
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF007BFF), Color(0xFF4DA3FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Vibrant background hero gradient
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFE5F2FF), Color(0xFFF0F7FF), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Deep rich gradient for cards/headers
  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF0C1322), Color(0xFF1E2D4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warm secondary gradient (Now mapped to cool blue/white)
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFE5F2FF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ───── Dashboard Redesign Palette (#007BFF) ─────
  static const Color brandOrange = Color(0xFF007BFF);    // Aliased to Blue to keep compatibility
  static const Color appBg = Color(0xFFFFFFFF);          // Pure white background
  static const Color cardBlue = Color(0xFFF8FAFC);       // Very light grey/blue for some subtle cards
  static const Color textMain = Color(0xFF0F172A);       // Almost black text
  static const Color textSub = Color(0xFF64748B);        // Subdued grey text
  
  // Aliases to avoid breaking existing code
  static const Color zoovanaBlue = brandOrange; 
  static const Color peachCream = appBg;
  static const Color peachLight = cardBlue;
  static const Color peachAccent = zoovanaBlue;
  static const Color peachDark = Color(0xFF0056B3);      // Darker blue
  static const Color peachSoft = Color(0xFFE5F2FF);      // Very light blue tint
  static const Color warmBrown = textMain;
  static const Color warmGray = textSub;

  // ───── Pet Info Chip Colors ─────
  static const Color lavenderChip = Color(0xFFF1F5F9);    
  static const Color lavenderText = Color(0xFF475569);    
  static const Color mintChip = Color(0xFFF1F5F9);        
  static const Color mintChipText = Color(0xFF475569);    
  static const Color sageChip = Color(0xFFF1F5F9);        
  static const Color sageChipText = Color(0xFF475569);    

  // ───── Zoovana Blue Gradient ─────
  static const LinearGradient peachGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
