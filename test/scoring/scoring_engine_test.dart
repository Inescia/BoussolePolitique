import 'package:boussole_politique/data/political_currents/currents_data.dart';
import 'package:boussole_politique/data/questions/questions_data.dart';
import 'package:boussole_politique/features/quiz/domain/scoring_engine.dart';
import 'package:boussole_politique/features/quiz/models/question.dart';
import 'package:boussole_politique/features/results/models/scoring_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final questions = loadQuestions();
  final currents = loadPoliticalCurrents();
  const engine = ScoringEngine();

  List<UserAnswer> answersFor(
    Map<String, AnswerValue> byId,
  ) {
    return byId.entries
        .map(
          (e) => UserAnswer(
            questionId: e.key,
            value: e.value,
            answeredAt: DateTime(2026, 1, 1),
          ),
        )
        .toList();
  }

  Map<String, AnswerValue> allWith(AnswerValue value) => {
        for (final q in questions) q.id: value,
      };

  Map<String, AnswerValue> biased({
    required bool Function(Question q) match,
    required AnswerValue hit,
    AnswerValue other = AnswerValue.skip,
  }) =>
      {
        for (final q in questions)
          q.id: match(q) ? hit : other,
      };

  bool favors(Question q, String currentId) =>
      q.impacts.any((i) => i.currentId == currentId && i.weight > 0);

  test('profil très socialiste privilégie socialisme / social-démocratie', () {
    final answers = answersFor(
      biased(
        match: (q) => favors(q, 'socialisme') || favors(q, 'social_democratie'),
        hit: AnswerValue.superYes,
        other: AnswerValue.no,
      ),
    );
    final result = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    final topIds = result.topCurrents.map((e) => e.currentId).toList();
    expect(
      topIds.any(
        (id) =>
            id == 'socialisme' ||
            id == 'social_democratie' ||
            id == 'communisme',
      ),
      isTrue,
    );
    expect(
      result.affinityFor('liberalisme_economique')!.affinityPercent <
          result.affinityFor('socialisme')!.affinityPercent,
      isTrue,
    );
  });

  test('profil très libéral économique', () {
    final answers = answersFor(
      biased(
        match: (q) => favors(q, 'liberalisme_economique'),
        hit: AnswerValue.superYes,
        other: AnswerValue.no,
      ),
    );
    final result = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    final top = result.topCurrents.map((e) => e.currentId).take(3).toSet();
    expect(top.contains('liberalisme_economique') || top.contains('liberalisme'), isTrue);
    expect(
      result.affinityFor('liberalisme_economique')!.affinityPercent,
      greaterThan(result.affinityFor('communisme')!.affinityPercent),
    );
  });

  test('profil très conservateur social', () {
    final answers = answersFor(
      biased(
        match: (q) =>
            favors(q, 'conservatisme') || favors(q, 'conservatisme_social'),
        hit: AnswerValue.superYes,
        other: AnswerValue.no,
      ),
    );
    final result = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    final top = result.topCurrents.map((e) => e.currentId).toSet();
    expect(
      top
          .intersection({
            'conservatisme',
            'conservatisme_social',
            'national_conservatisme',
          })
          .isNotEmpty,
      isTrue,
    );
  });

  test('profil très écologiste', () {
    final answers = answersFor(
      biased(
        match: (q) => favors(q, 'ecologie_politique'),
        hit: AnswerValue.superYes,
        other: AnswerValue.no,
      ),
    );
    final result = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    final top = result.topCurrents.map((e) => e.currentId).take(3).toList();
    expect(top.contains('ecologie_politique'), isTrue);
    expect(
      result.affinityFor('ecologie_politique')!.affinityPercent,
      greaterThan(result.affinityFor('liberalisme_economique')!.affinityPercent),
    );
  });

  test('profil neutre (tout passer) reste autour de 50%', () {
    final answers = answersFor(allWith(AnswerValue.skip));
    final result = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    expect(result.answerCount, 0);
    expect(result.completeness, ProfileCompleteness.exploring);
    for (final a in result.affinities) {
      expect(a.affinityPercent, closeTo(50, 0.01));
    }
  });

  test('beaucoup de passers + quelques réponses restent cohérents', () {
    final map = allWith(AnswerValue.skip);
    map['q001'] = AnswerValue.yes;
    map['q005'] = AnswerValue.superYes;
    map['q008'] = AnswerValue.yes;
    final result = engine.compute(
      questions: questions,
      answers: answersFor(map),
      currents: currents,
    );
    expect(result.answerCount, 3);
    expect(result.skipCount, questions.length - 3);
    expect(result.influentialAnswers, isNotEmpty);
  });

  test('profil mixte peut avoir plusieurs affinités élevées', () {
    final map = <String, AnswerValue>{};
    for (final q in questions) {
      final eco = favors(q, 'ecologie_politique');
      final social = favors(q, 'social_democratie');
      final lib = favors(q, 'liberalisme_politique');
      if (eco) {
        map[q.id] = AnswerValue.superYes;
      } else if (social) {
        map[q.id] = AnswerValue.yes;
      } else if (lib) {
        map[q.id] = AnswerValue.yes;
      } else {
        map[q.id] = AnswerValue.skip;
      }
    }
    final result = engine.compute(
      questions: questions,
      answers: answersFor(map),
      currents: currents,
    );
    expect(result.topCurrents.length, greaterThanOrEqualTo(2));
    expect(result.dimensionScores, isNotEmpty);
  });

  test('scoring déterministe', () {
    final answers = answersFor({
      'q001': AnswerValue.yes,
      'q002': AnswerValue.superYes,
      'q003': AnswerValue.no,
    });
    final a = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    final b = engine.compute(
      questions: questions,
      answers: answers,
      currents: currents,
    );
    expect(a.affinities, b.affinities);
    expect(a.hemicyclePosition, b.hemicyclePosition);
  });

  test('lean dimensionnel tient compte de la polarité des impacts', () {
    final yesMarket = answersFor({'q003': AnswerValue.superYes});
    final yesPublic = answersFor({'q001': AnswerValue.superYes});
    final market = engine.compute(
      questions: questions,
      answers: yesMarket,
      currents: currents,
    );
    final public = engine.compute(
      questions: questions,
      answers: yesPublic,
      currents: currents,
    );
    final marketEco = market.dimensionScores
        .firstWhere((d) => d.family.label == 'Économie')
        .leanPercent;
    final publicEco = public.dimensionScores
        .firstWhere((d) => d.family.label == 'Économie')
        .leanPercent;
    expect((marketEco - 50).sign, isNot(equals((publicEco - 50).sign)));
  });
}
