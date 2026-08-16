import 'package:flutter/material.dart';

/// Palette contemporaine inspirée des codes tricolores, sans drapeau omniprésent.
abstract final class AppColors {
  /// Bleu et rouge de marque (logo Boussole Politique).
  static const Color brandBlue = Color(0xFF4685CC);
  static const Color brandRed = Color(0xFFF75460);

  static const Color nightBlue = Color(0xFF0B1B3A);
  static const Color deepBlue = Color(0xFF132B55);
  static const Color electricBlue = brandBlue;
  static const Color softBlue = Color(0xFF7AA8DD);
  static const Color coral = brandRed;
  static const Color softCoral = Color(0xFFFA9299);
  static const Color cream = Color(0xFFF7F4EF);
  static const Color warmWhite = Color(0xFFFFFCF8);
  static const Color warmGray = Color(0xFF6E6A63);
  static const Color softGray = Color(0xFFE8E3DB);
  static const Color ink = Color(0xFF12141A);
  static const Color success = Color(0xFF2F9E6B);
  static const Color warning = Color(0xFFE0A100);
  static const Color violetHint = Color(0xFF7A6BFF);
  static const Color goldHint = Color(0xFFE8C547);

  /// Tricolore (navbar, accents discrets) — bleu/rouge alignés sur la marque.
  static const Color frenchBlue = brandBlue;
  static const Color frenchWhite = Color(0xFFFFFFFF);
  static const Color frenchRed = brandRed;

  static const Color yes = Color(0xFF2F9E6B);
  static const Color superYes = Color(0xFF1B7A52);
  static const Color no = Color(0xFFE85A64);
  static const Color superNo = Color(0xFFD94450);
  static const Color skip = Color(0xFF8A857C);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1B3A), Color(0xFF1A3A7A), brandBlue],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFCF8), Color(0xFFF3F0EA)],
  );

  static const LinearGradient accentGlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x334685CC), Color(0x00F75460)],
  );
}
