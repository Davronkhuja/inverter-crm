import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Тема приложения: Material 3, светлый и тёмный режимы.
/// Палитра построена вокруг "энергетического" teal-акцента (солнечная
/// энергетика), а не дефолтного фиолетового — чтобы не выглядеть шаблонно.
class AppTheme {
  AppTheme._();

  // Брендовый акцент (teal/cyan) + поддерживающие тона.
  static const Color _seed = Color(0xFF0E7C7B);
  static const Color _accentAmber = Color(
    0xFFE8A33D,
  ); // предупреждения/неисправность

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
      tertiary: _accentAmber,
    );

    final baseTextTheme = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = GoogleFonts.manropeTextTheme(baseTextTheme).copyWith(
      headlineSmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: GoogleFonts.manrope(fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.manrope(fontWeight: FontWeight.w600),
    );

    final surfaceTint = isDark
        ? const Color(0xFF101516)
        : const Color(0xFFF6F8F8);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surfaceTint,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1.5,
        backgroundColor: surfaceTint,
        surfaceTintColor: scheme.surfaceTint,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontSize: 22,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: isDark ? 0.5 : 0.7),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
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
            color: scheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.error, width: 1.4),
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
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        labelStyle: textTheme.labelMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 2,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
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
