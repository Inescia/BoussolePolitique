import 'package:boussole_politique/core/theme/app_theme.dart';
import 'package:boussole_politique/data/political_currents/currents_data.dart';
import 'package:boussole_politique/features/results/models/scoring_result.dart';
import 'package:boussole_politique/features/results/widgets/affinity_constellation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final currents = loadPoliticalCurrents().take(4).toList();

  ScoringResult resultFor(List<double> percents) {
    final affinities = [
      for (var i = 0; i < percents.length; i++)
        CurrentAffinity(
          currentId: currents[i].id,
          rawScore: 1,
          affinityPercent: percents[i],
          answeredWeight: 2,
        ),
    ];
    return ScoringResult(
      affinities: affinities,
      topCurrents: affinities,
      dimensionScores: const [],
      influentialAnswers: const [],
      answerCount: 12,
      skipCount: 0,
      dimensionCoverage: 0.4,
      completeness: ProfileCompleteness.partial,
      hemicyclePosition: 0,
    );
  }

  testWidgets('affiche Toi, les noms et ouvre la fiche au tap', (tester) async {
    String? opened;
    final result = resultFor(const [78, 64, 55]);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SingleChildScrollView(
              child: AffinityConstellation(
                currents: currents,
                result: result,
                onCurrentTap: (current) => opened = current.id,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Toi'), findsOneWidget);
    expect(find.text(currents.first.name), findsOneWidget);
    expect(find.text(currents[1].name), findsOneWidget);
    expect(find.text('Tape un courant pour l’ouvrir.'), findsOneWidget);

    await tester.tap(find.text(currents.first.name));
    await tester.pump();

    expect(
      find.text('Voir la fiche « ${currents.first.name} »'),
      findsOneWidget,
    );
    await tester.tap(find.text('Voir la fiche « ${currents.first.name} »'));
    await tester.pump();
    expect(opened, currents.first.id);
  });
}
