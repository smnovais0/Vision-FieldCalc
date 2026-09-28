import 'package:flutter/material.dart';

/// Tokens medidos na referência visual e aplicados com marca Vision World Apps.
/// Waldenburg não está licenciada neste repositório; o título editorial usa Inter 300.
class VisionTheme {
  static const canvas = Color(0xFFFDFCFC);
  static const panel = Color(0xFFF5F3F1);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const mutedText = Color(0xFF5F5F5F);
  static const subtleBorder = Color(0x13000000);
  static const error = Color(0xFF8C1D18);
  static const shadow = Color(0x0A000000);

  static const radiusPanel = 24.0;
  static const radiusControl = 14.0;
  static const contentMaxWidth = 1137.0;

  static const space4 = 4.0;
  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space20 = 20.0;
  static const space24 = 24.0;
  static const space32 = 32.0;
  static const space48 = 48.0;
  static const space64 = 64.0;

  static const motion = Duration(milliseconds: 180);

  static const List<BoxShadow> controlShadow = [
    BoxShadow(color: shadow, offset: Offset(0, 1), blurRadius: 1),
    BoxShadow(color: shadow, offset: Offset(0, 2), blurRadius: 4),
  ];

  static const TextStyle math = TextStyle(
    fontFamily: 'NotoSansMath',
    fontFamilyFallback: ['Inter'],
    fontSize: 26,
    height: 1.35,
    color: black,
  );

  static TextStyle inter({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    double height = 1.5,
    double letterSpacing = 0,
    Color color = black,
  }) =>
      TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: const ['NotoSansMath'],
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        splashFactory: NoSplash.splashFactory,
        highlightColor: const Color(0x0A000000),
        hoverColor: const Color(0x0A000000),
        scaffoldBackgroundColor: canvas,
        colorScheme: const ColorScheme.light(
          primary: black,
          onPrimary: white,
          secondary: black,
          onSecondary: white,
          surface: canvas,
          onSurface: black,
          error: error,
          onError: white,
          outline: subtleBorder,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: black,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: inter(size: 18, weight: FontWeight.w600, height: 1.2),
        ),
        cardTheme: CardThemeData(
          color: white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusControl),
            side: const BorderSide(color: subtleBorder, width: 0.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: black,
            foregroundColor: white,
            disabledBackgroundColor: const Color(0xFFBDBDBD),
            disabledForegroundColor: white,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: const StadiumBorder(),
            textStyle: inter(size: 14, height: 21 / 14, color: white),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: white,
            foregroundColor: black,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            side: const BorderSide(color: subtleBorder, width: 0.5),
            shape: const StadiumBorder(),
            elevation: 0,
            shadowColor: black,
            textStyle: inter(size: 14, height: 21 / 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: black,
            minimumSize: const Size(44, 44),
            textStyle: inter(size: 14, height: 21 / 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: inter(size: 14, color: mutedText, height: 21 / 14),
          hintStyle: inter(size: 16, color: mutedText),
          errorStyle: inter(size: 14, color: error, height: 21 / 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusControl),
            borderSide: const BorderSide(color: subtleBorder, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusControl),
            borderSide: const BorderSide(color: subtleBorder, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusControl),
            borderSide: const BorderSide(color: black, width: 1.25),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusControl),
            borderSide: const BorderSide(color: error, width: 1.25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusControl),
            borderSide: const BorderSide(color: error, width: 1.25),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: black, linearTrackColor: panel),
        textTheme: TextTheme(
          displayLarge: inter(size: 48, weight: FontWeight.w300, height: 52 / 48, letterSpacing: -0.96),
          headlineSmall: inter(size: 28, weight: FontWeight.w400, height: 1.15, letterSpacing: -0.4),
          titleLarge: inter(size: 20, weight: FontWeight.w500, height: 1.3),
          titleMedium: inter(size: 18, weight: FontWeight.w500, height: 1.4),
          bodyLarge: inter(size: 18, height: 28.8 / 18),
          bodyMedium: inter(size: 16, height: 24 / 16),
          bodySmall: inter(size: 14, height: 21 / 14, color: mutedText),
          labelLarge: inter(size: 14, height: 21 / 14),
        ),
      );
}
