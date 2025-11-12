import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Enhanced with modern community-focused color palettes for better visual appeal.
class AppTheme {
  AppTheme._();

  // Color Palette Options - Choose one by uncommenting the desired palette

  // PALETTE 1: Vibrant Community (Recommended for WE Community Tasks)
  // Modern, energetic colors that inspire action and community engagement
  static const Color primaryLight =
      Color(0xFF6366F1); // Vibrant indigo for trust and action
  static const Color secondaryLight =
      Color(0xFF8B5CF6); // Rich purple for premium feel
  static const Color accentLight =
      Color(0xFF06B6D4); // Cyan for notifications and highlights
  static const Color successLight =
      Color(0xFF10B981); // Emerald for completed tasks
  static const Color warningLight =
      Color(0xFFF59E0B); // Amber for pending states
  static const Color errorLight = Color(0xFFEF4444); // Red for errors
  static const Color backgroundLight = Color(0xFFFAFBFC); // Soft off-white
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white for cards
  static const Color textPrimaryLight = Color(0xFF1F2937); // Dark gray
  static const Color textSecondaryLight = Color(0xFF6B7280); // Medium gray
  static const Color borderLight = Color(0xFFE5E7EB); // Light border

  // Dark theme variants for Palette 1
  static const Color primaryDark = Color(0xFF818CF8);
  static const Color secondaryDark = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF22D3EE);
  static const Color successDark = Color(0xFF34D399);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color errorDark = Color(0xFFF87171);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // Shadow colors for subtle depth
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x1AFFFFFF);

  /// Light theme - Modern Community Design
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: primaryLight.withAlpha(26),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight.withAlpha(26),
      onSecondaryContainer: secondaryLight,
      tertiary: accentLight,
      onTertiary: Colors.white,
      tertiaryContainer: accentLight.withAlpha(26),
      onTertiaryContainer: accentLight,
      error: errorLight,
      onError: Colors.white,
      errorContainer: errorLight.withAlpha(26),
      onErrorContainer: errorLight,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: borderLight.withAlpha(128),
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: surfaceDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: borderLight,

    // AppBar theme - Modern community feel
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: const IconThemeData(
        color: textPrimaryLight,
        size: 24,
      ),
    ),

    // Card theme - Enhanced visual hierarchy
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // More rounded for modern feel
      ),
      margin: const EdgeInsets.all(0),
    ),

    // Bottom Navigation - Community focused
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600, // Bolder for better readability
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Navigation Bar theme - Modern adaptive design
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primaryLight.withAlpha(26),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primaryLight,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryLight, size: 24);
        }
        return const IconThemeData(color: textSecondaryLight, size: 24);
      }),
    ),

    // Floating Action Button - Enhanced with gradient feel
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 8, // Increased for better prominence
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Button themes - Modern community design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryLight,
        elevation: 3, // Slightly more elevated
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 14), // More padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600, // Bolder text
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        side: BorderSide(
            color: primaryLight.withAlpha(128),
            width: 1.5), // Slightly thicker border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography - Inter for exceptional mobile readability
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration - Modern input styling
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14), // More padding
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w500, // Slightly bolder
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryLight.withAlpha(179),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorLight,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Interactive elements with community colors
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return textSecondaryLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(77);
        }
        return borderLight;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: borderLight, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3), // Slightly more rounded
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return textSecondaryLight;
      }),
    ),

    // Progress indicators with vibrant colors
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: borderLight,
      circularTrackColor: borderLight,
    ),

    // Slider theme with accent colors
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withAlpha(26),
      inactiveTrackColor: borderLight,
      trackHeight: 4,
    ),

    // Tab bar theme with modern styling
    tabBarTheme: TabBarThemeData(
      labelColor: primaryLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryLight.withAlpha(230),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    // Snackbar theme with modern styling
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // More rounded
      ),
      elevation: 8,
    ),

    // Dialog theme with enhanced styling
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceLight,
      elevation: 12, // Higher elevation for prominence
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // More rounded
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
    ),

    // Bottom sheet theme with modern styling
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceLight,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // More rounded for modern feel
        ),
      ),
    ),
  );

  /// Dark theme - Modern Community Design (Dark variant)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: backgroundDark,
      primaryContainer: primaryDark.withAlpha(51),
      onPrimaryContainer: primaryDark,
      secondary: secondaryDark,
      onSecondary: backgroundDark,
      secondaryContainer: secondaryDark.withAlpha(51),
      onSecondaryContainer: secondaryDark,
      tertiary: accentDark,
      onTertiary: backgroundDark,
      tertiaryContainer: accentDark.withAlpha(51),
      onTertiaryContainer: accentDark,
      error: errorDark,
      onError: backgroundDark,
      errorContainer: errorDark.withAlpha(51),
      onErrorContainer: errorDark,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: borderDark.withAlpha(128),
      shadow: shadowDark,
      scrim: Colors.black87,
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: borderDark,

    // Continue with dark theme configurations...
    // ... rest of code ...
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for exceptional mobile readability
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;

    return TextTheme(
      // Display styles - Large headings with enhanced weights
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w800, // Bolder for impact
        color: textPrimary,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),

      // Headline styles - Section headers with better hierarchy
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Title styles - Card titles and important text
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600, // Bolder for better hierarchy
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
      ),

      // Body styles - Main content text with improved readability
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.6, // Better line height
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.4,
      ),

      // Label styles - Buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600, // Bolder for better readability
        color: textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Helper method to get accent text style for highlights
  static TextStyle getAccentStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final Color accentColor = isLight ? accentLight : accentDark;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: accentColor,
    );
  }

  /// Helper method to get success text style
  static TextStyle getSuccessStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final Color successColor = isLight ? successLight : successDark;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: successColor,
    );
  }

  /// Helper method to get warning text style
  static TextStyle getWarningStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final Color warningColor = isLight ? warningLight : warningDark;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: warningColor,
    );
  }

  /// Helper method to get error text style
  static TextStyle getErrorStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final Color errorColor = isLight ? errorLight : errorDark;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: errorColor,
    );
  }

  /// Helper method to get gradient decorations for special elements
  static BoxDecoration getPrimaryGradientDecoration({bool isLight = true}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isLight
            ? [primaryLight, secondaryLight]
            : [primaryDark, secondaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isLight ? shadowLight : shadowDark,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Helper method to get accent gradient decoration
  static BoxDecoration getAccentGradientDecoration({bool isLight = true}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors:
            isLight ? [accentLight, primaryLight] : [accentDark, primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isLight ? shadowLight : shadowDark,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
