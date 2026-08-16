import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme textTheme() {
    const baseColor = AppColors.ink;
    const muted = Color(0xFF5A564F);

    final display = GoogleFonts.outfit(
      color: baseColor,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      height: 1.1,
    );
    final body = GoogleFonts.dmSans(
      color: baseColor,
      fontWeight: FontWeight.w400,
      height: 1.45,
    );

    return TextTheme(
      displayLarge: display.copyWith(fontSize: 44),
      displayMedium: display.copyWith(fontSize: 36),
      displaySmall: display.copyWith(fontSize: 30),
      headlineLarge: display.copyWith(fontSize: 28),
      headlineMedium: display.copyWith(fontSize: 24),
      headlineSmall: display.copyWith(fontSize: 20),
      titleLarge: body.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: body.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
      titleSmall: body.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      bodyLarge: body.copyWith(fontSize: 17),
      bodyMedium: body.copyWith(fontSize: 15, color: muted),
      bodySmall: body.copyWith(fontSize: 13, color: muted),
      labelLarge: body.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      labelMedium: body.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: body.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
    );
  }
}
