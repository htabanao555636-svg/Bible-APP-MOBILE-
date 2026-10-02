import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  /// Switched by ThemeController. Every color below follows it.
  static bool isDark = false;

  static Color _pick(int light, int dark) => Color(isDark ? dark : light);

  /// Single accent color used for buttons, links, active states, bookmarks.
  static Color get primaryGreen => _pick(0xFF1F4C3B, 0xFF35986F);

  static Color get background => _pick(0xFFFFFFFF, 0xFF000000);
  static Color get cardCream => _pick(0xFFF3F3F3, 0xFF161616);
  static Color get surface => _pick(0xFFFFFFFF, 0xFF0D0D0D);
  static Color get textDark => _pick(0xFF111111, 0xFFF5F5F5);
  static Color get textMuted => _pick(0xFF6E6E6E, 0xFFA0A0A0);

  // mood card accents (kept soft so they still read as "categories" on
  // a plain white/black canvas, not full-color blocks)
  static Color get moodBlue => _pick(0xFFDCE9F7, 0xFF23384A);
  static Color get moodPurple => _pick(0xFFE7DFF5, 0xFF3A3050);
  static Color get moodOrange => _pick(0xFFF7E3D0, 0xFF4A3520);
  static Color get moodTeal => _pick(0xFFDCEFE9, 0xFF1F3C36);
  static Color get moodPink => _pick(0xFFF7DFDF, 0xFF4A2A2A);
  static Color get moodYellow => _pick(0xFFF6EFD2, 0xFF4A4118);
}

/// Consistent text scale used across every screen.
class AppText {
  static TextStyle get pageTitle => GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get cardTitle => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        height: 1.55,
        color: AppColors.textDark,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12.5,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );
}

class AppTheme {
  /// Built from whichever mode AppColors.isDark says is active.
  static ThemeData get current {
    final brightness = AppColors.isDark ? Brightness.dark : Brightness.light;

    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F4C3B),
      brightness: brightness,
      surface: AppColors.background,
    ).copyWith(primary: AppColors.primaryGreen, onPrimary: Colors.white);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: scheme,
      splashFactory: InkRipple.splashFactory,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: AppText.pageTitle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppText.button.copyWith(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: BorderSide(color: AppColors.isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0)),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardCream,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.isDark ? const Color(0xFF232323) : const Color(0xFFEDEDED),
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeUpTransitionsBuilder(),
          TargetPlatform.iOS: _FadeUpTransitionsBuilder(),
          TargetPlatform.windows: _FadeUpTransitionsBuilder(),
          TargetPlatform.macOS: _FadeUpTransitionsBuilder(),
          TargetPlatform.linux: _FadeUpTransitionsBuilder(),
        },
      ),
    );
  }
}

class _FadeUpTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeUpTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
