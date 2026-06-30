import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_icons.dart';

/// Тема оформления приложения — это не просто цвет, а целостный
/// визуальный язык: палитра, типографика и набор иконок ([AppIconSet]).
/// Пользователь выбирает её на экране Account.
enum AppAppearance { power, nature, tech }

/// Описывает одну тему оформления: её ColorScheme-seed, акцентные тона,
/// типографику и иконографию. [AppTheme.build] собирает из этого
/// полноценный Material [ThemeData] для светлого и тёмного режима.
class AppearanceSpec {
  final AppAppearance id;
  final String labelKey; // ключ AppLocalizations, заполняется в UI слое
  final Color seed;
  final Color accent;
  final TextTheme Function(TextTheme base) typography;
  final AppIconSet icons;
  final Color? darkScaffold;
  final Color? darkSurface;

  const AppearanceSpec({
    required this.id,
    required this.labelKey,
    required this.seed,
    required this.accent,
    required this.typography,
    required this.icons,
    this.darkScaffold,
    this.darkSurface,
  });
}

class AppTheme {
  AppTheme._();

  /// "Quvvat" — электрик-синий + янтарный акцент, Manrope, rounded-иконки.
  static final power = AppearanceSpec(
    id: AppAppearance.power,
    labelKey: 'appearancePower',
    seed: const Color(0xFF2F5DFF),
    accent: const Color(0xFFFFB020),
    icons: AppIconSet.power,
    darkScaffold: const Color(0xFF0B0F1A),
    darkSurface: const Color(0xFF11162A),
    typography: (base) => GoogleFonts.manropeTextTheme(base).copyWith(
      headlineSmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      ),
      titleLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
      ),
      titleMedium: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      labelLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700),
    ),
  );

  /// "Tabiat" — quyosh/teal ekologik, Outfit, outlined-iconlar.
  static final nature = AppearanceSpec(
    id: AppAppearance.nature,
    labelKey: 'appearanceNature',
    seed: const Color(0xFF0E8E72),
    accent: const Color(0xFFE8A33D),
    icons: AppIconSet.nature,
    darkScaffold: const Color(0xFF0E1614),
    darkSurface: const Color(0xFF131E1A),
    typography: (base) => GoogleFonts.outfitTextTheme(base).copyWith(
      headlineSmall: GoogleFonts.outfit(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: GoogleFonts.outfit(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600),
    ),
  );

  /// "Texno" — тёмный техно, неоновый cyan, JetBrains Mono для данных,
  /// Space Grotesk для заголовков, sharp-иконки.
  static final tech = AppearanceSpec(
    id: AppAppearance.tech,
    labelKey: 'appearanceTech',
    seed: const Color(0xFF00E5C7),
    accent: const Color(0xFFFF3D81),
    icons: AppIconSet.tech,
    darkScaffold: const Color(0xFF05080A),
    darkSurface: const Color(0xFF0A1012),
    typography: (base) => GoogleFonts.spaceGroteskTextTheme(base).copyWith(
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      bodyMedium: GoogleFonts.spaceGrotesk(),
      bodySmall: GoogleFonts.jetBrainsMono(fontSize: 12),
    ),
  );

  static List<AppearanceSpec> get all => [power, nature, tech];

  static AppearanceSpec specFor(AppAppearance id) {
    switch (id) {
      case AppAppearance.power:
        return power;
      case AppAppearance.nature:
        return nature;
      case AppAppearance.tech:
        return tech;
    }
  }

  static ThemeData light(AppearanceSpec spec) => _build(spec, Brightness.light);
  static ThemeData dark(AppearanceSpec spec) => _build(spec, Brightness.dark);

  static ThemeData _build(AppearanceSpec spec, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: spec.seed,
      brightness: brightness,
      tertiary: spec.accent,
    );

    final baseTextTheme = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = spec.typography(baseTextTheme);

    final scaffold = isDark
        ? (spec.darkScaffold ?? const Color(0xFF0E1112))
        : const Color(0xFFF7F8FA);
    final surface = isDark ? (spec.darkSurface ?? scheme.surface) : scheme.surface;

    final adjustedScheme = isDark
        ? scheme.copyWith(surface: surface)
        : scheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: adjustedScheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1.5,
        backgroundColor: scaffold,
        surfaceTintColor: adjustedScheme.surfaceTint,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: adjustedScheme.onSurface,
          fontSize: 22,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: adjustedScheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: adjustedScheme.outlineVariant.withValues(
              alpha: isDark ? 0.4 : 0.7,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: adjustedScheme.surfaceContainerHighest.withValues(
          alpha: 0.4,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: adjustedScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: adjustedScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: adjustedScheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: adjustedScheme.outlineVariant),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(
          color: adjustedScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        labelStyle: textTheme.labelMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: adjustedScheme.surface,
        elevation: 2,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      dividerTheme: DividerThemeData(
        color: adjustedScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
