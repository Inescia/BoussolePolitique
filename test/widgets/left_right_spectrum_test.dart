import 'package:boussole_politique/core/theme/app_colors.dart';
import 'package:boussole_politique/core/theme/app_theme.dart';
import 'package:boussole_politique/core/widgets/left_right_spectrum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('affiche le libellé de position et les marqueurs', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: LeftRightSpectrum(
            position: -0.6,
            title: 'Où tu te situes',
            markers: [
              SpectrumMarker(
                position: -0.7,
                color: AppColors.coral,
                label: 'Socialisme',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Où tu te situes'), findsOneWidget);
    expect(find.text('Plutôt à gauche'), findsOneWidget);
    expect(find.text('Socialisme'), findsOneWidget);
    expect(find.text('Gauche'), findsOneWidget);
    expect(find.text('Droite'), findsOneWidget);
  });
}
