import 'package:boussole_politique/core/theme/app_theme.dart';
import 'package:boussole_politique/core/utils/haptics.dart';
import 'package:boussole_politique/features/quiz/widgets/milestone_progress_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('affiche jalon, barres globale et locale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: MilestoneProgressHeader(
            answeredCount: 25,
            totalQuestions: 100,
            haptics: AppHaptics(enabled: false),
            reduceMotion: true,
          ),
        ),
      ),
    );

    expect(find.textContaining('Jalon 3 / 10'), findsOneWidget);
    expect(find.text('En orbite'), findsOneWidget);
    expect(find.text('25 / 100'), findsOneWidget);
    expect(find.text('Parcours'), findsOneWidget);
    expect(find.textContaining('Ce jalon'), findsOneWidget);
  });

  testWidgets('célèbre un jalon franchi', (tester) async {
    final haptics = AppHaptics(enabled: false);
    var answered = 19;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  MilestoneProgressHeader(
                    answeredCount: answered,
                    totalQuestions: 100,
                    haptics: haptics,
                    reduceMotion: true,
                  ),
                  TextButton(
                    onPressed: () => setState(() => answered = 20),
                    child: const Text('avancer'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(find.textContaining('débloqué'), findsNothing);

    await tester.tap(find.text('avancer'));
    await tester.pump();

    expect(find.textContaining('Jalon 2 débloqué'), findsOneWidget);
    expect(find.text('Première lumière'), findsWidgets);
  });
}
