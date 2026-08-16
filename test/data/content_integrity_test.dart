import 'package:boussole_politique/data/political_currents/currents_data.dart';
import 'package:boussole_politique/data/questions/questions_data.dart';
import 'package:boussole_politique/features/quiz/models/political_dimension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chaque impact de question référence un courant existant', () {
    final currentIds = loadPoliticalCurrents().map((c) => c.id).toSet();
    final questions = loadQuestions();
    final missing = <String>[];

    for (final q in questions) {
      for (final impact in q.impacts) {
        if (!currentIds.contains(impact.currentId)) {
          missing.add('${q.id} → ${impact.currentId}');
        }
      }
    }

    expect(
      missing,
      isEmpty,
      reason: 'Courants manquants : ${missing.join(', ')}',
    );
  });

  test('les ids de questions sont uniques', () {
    final ids = loadQuestions().map((q) => q.id).toList();
    expect(ids.length, ids.toSet().length);
  });

  test('les ids de courants sont uniques', () {
    final ids = loadPoliticalCurrents().map((c) => c.id).toList();
    expect(ids.length, ids.toSet().length);
  });

  test('chaque carte a un contexte et un repère de source', () {
    final missing = <String>[];
    for (final q in loadQuestions()) {
      final explanation = q.explanation?.trim() ?? '';
      final source = q.source?.trim() ?? '';
      if (explanation.isEmpty) missing.add('${q.id} (explanation)');
      if (source.isEmpty) missing.add('${q.id} (source)');
    }
    expect(missing, isEmpty, reason: missing.join(', '));
  });

  test('les catégories de cartes existent dans le modèle', () {
    final dimensionIds = PoliticalDimension.values.map((d) => d.id).toSet();
    final unknown = loadQuestions()
        .where((q) => !dimensionIds.contains(q.category))
        .map((q) => '${q.id} → ${q.category}')
        .toList();
    expect(unknown, isEmpty, reason: unknown.join(', '));
  });
}
