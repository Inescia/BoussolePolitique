import '../../../core/constants/app_constants.dart';
import '../../political_currents/models/political_current.dart';
import '../../results/models/scoring_result.dart';
import '../models/political_dimension.dart';
import '../models/question.dart';

/// Moteur de scoring déterministe, indépendant de l'UI.
///
/// Entrées : liste des questions, réponses utilisateur, courants politiques.
/// Sortie : [ScoringResult] (affinités %, dimensions, hémicycle, réponses influentes).
///
/// Algorithme simplifié :
/// - Chaque réponse (hors « passer ») ajoute `answer.score × impact.weight` par courant
/// - Normalisation en % : `((raw / maxPossible) + 1) × 50`
/// - Les dimensions agrègent les catégories de questions
class ScoringEngine {
  const ScoringEngine();

  ScoringResult compute({
    required List<Question> questions,
    required List<UserAnswer> answers,
    required List<PoliticalCurrent> currents,
  }) {
    final questionById = {for (final q in questions) q.id: q};
    final currentById = {for (final c in currents) c.id: c};
    final currentIds = currentById.keys.toSet();

    final raw = <String, double>{for (final id in currentIds) id: 0};
    final maxPossible = <String, double>{for (final id in currentIds) id: 0};
    final answeredWeight = <String, double>{for (final id in currentIds) id: 0};

    var answerCount = 0;
    var skipCount = 0;
    final coveredCategories = <String>{};
    final influenceCandidates = <InfluentialAnswer>[];

    for (final answer in answers) {
      final question = questionById[answer.questionId];
      if (question == null) continue;

      if (answer.value == AnswerValue.skip) {
        skipCount++;
        continue;
      }

      answerCount++;
      coveredCategories.add(question.category);

      var magnitude = 0.0;
      final contributed = <String, double>{};

      for (final impact in question.impacts) {
        if (!currentIds.contains(impact.currentId)) continue;
        final contribution = answer.value.score * impact.weight;
        raw[impact.currentId] = raw[impact.currentId]! + contribution;
        maxPossible[impact.currentId] =
            maxPossible[impact.currentId]! + 2 * impact.weight.abs();
        answeredWeight[impact.currentId] =
            answeredWeight[impact.currentId]! + impact.weight.abs();
        contributed[impact.currentId] = contribution;
        magnitude += contribution.abs();
      }

      final topIds = contributed.entries.toList()
        ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));

      influenceCandidates.add(
        InfluentialAnswer(
          question: question,
          answer: answer,
          influenceMagnitude: magnitude,
          topCurrentIds: topIds.take(3).map((e) => e.key).toList(),
        ),
      );
    }

    final affinities = currentIds.map((id) {
      final max = maxPossible[id]!;
      final score = raw[id]!;
      final percent = max <= 0 ? 50.0 : ((score / max) + 1) * 50;
      return CurrentAffinity(
        currentId: id,
        rawScore: score,
        affinityPercent: percent.clamp(0, 100),
        answeredWeight: answeredWeight[id]!,
      );
    }).toList()..sort((a, b) => b.affinityPercent.compareTo(a.affinityPercent));

    final topCurrents = affinities
        .where((a) => a.answeredWeight > 0)
        .take(5)
        .toList();

    influenceCandidates.sort(
      (a, b) => b.influenceMagnitude.compareTo(a.influenceMagnitude),
    );

    final dimensionScores = _computeDimensionScores(
      questions: questions,
      answers: answers,
      questionById: questionById,
      currentById: currentById,
    );

    final allCategories = questions.map((q) => q.category).toSet();
    final coverage = allCategories.isEmpty
        ? 0.0
        : coveredCategories.length / allCategories.length;

    final completeness = _completeness(
      answerCount: answerCount,
      coverage: coverage,
    );

    final hemicyclePosition = _hemicyclePosition(
      affinities: affinities,
      currents: currents,
    );

    return ScoringResult(
      affinities: affinities,
      topCurrents: topCurrents,
      dimensionScores: dimensionScores,
      influentialAnswers: influenceCandidates.take(5).toList(),
      answerCount: answerCount,
      skipCount: skipCount,
      dimensionCoverage: coverage,
      completeness: completeness,
      hemicyclePosition: hemicyclePosition,
    );
  }

  /// Polarité d'une question : accord → plutôt « gauche » (−) ou « droite » (+)
  /// dans l'espace des courants touchés (métaphore pédagogique).
  double questionPolarity(
    Question question,
    Map<String, PoliticalCurrent> currentById,
  ) {
    var sum = 0.0;
    var weight = 0.0;
    for (final impact in question.impacts) {
      final current = currentById[impact.currentId];
      if (current == null) continue;
      sum += impact.weight * current.hemicycleAngle;
      weight += impact.weight.abs();
    }
    if (weight == 0) return 0;
    return (sum / weight).clamp(-1.0, 1.0);
  }

  List<DimensionScore> _computeDimensionScores({
    required List<Question> questions,
    required List<UserAnswer> answers,
    required Map<String, Question> questionById,
    required Map<String, PoliticalCurrent> currentById,
  }) {
    final answeredIds = {
      for (final a in answers)
        if (a.value != AnswerValue.skip) a.questionId,
    };

    return DimensionFamily.values.map((family) {
      final familyCategories = family.dimensions.map((d) => d.id).toSet();
      final familyQuestions = questions
          .where((q) => familyCategories.contains(q.category))
          .toList();
      final answeredInFamily = familyQuestions
          .where((q) => answeredIds.contains(q.id))
          .length;

      // Lean directionnel : réponse × polarité des impacts (évite le biais « tout oui »).
      double leanSum = 0;
      var leanWeight = 0.0;
      for (final a in answers) {
        if (a.value == AnswerValue.skip) continue;
        final q = questionById[a.questionId];
        if (q == null || !familyCategories.contains(q.category)) continue;
        final polarity = questionPolarity(q, currentById);
        leanSum += a.value.score * polarity;
        leanWeight += polarity.abs().clamp(0.25, 1.0);
      }

      final leanPercent = leanWeight == 0
          ? 50.0
          : ((leanSum / (2 * leanWeight)) + 1) * 50;
      final coverage = familyQuestions.isEmpty
          ? 0.0
          : answeredInFamily / familyQuestions.length;

      return DimensionScore(
        family: family,
        coverage: coverage,
        leanPercent: leanPercent.clamp(0, 100),
        answeredCount: answeredInFamily,
      );
    }).toList();
  }

  ProfileCompleteness _completeness({
    required int answerCount,
    required double coverage,
  }) {
    if (answerCount < AppConstants.exploringMaxAnswers) {
      return ProfileCompleteness.exploring;
    }
    if (answerCount < AppConstants.minAnswersForPartialResult) {
      return ProfileCompleteness.emerging;
    }
    if (coverage < AppConstants.partialMinCoverage ||
        answerCount < AppConstants.partialMinAnswers) {
      return ProfileCompleteness.partial;
    }
    if (coverage < AppConstants.wellCoveredDimensionRatio ||
        answerCount < AppConstants.suggestedAnswersForReliableProfile) {
      return ProfileCompleteness.solid;
    }
    return ProfileCompleteness.wellInformed;
  }

  double _hemicyclePosition({
    required List<CurrentAffinity> affinities,
    required List<PoliticalCurrent> currents,
  }) {
    final byId = {for (final c in currents) c.id: c};
    double weighted = 0;
    double total = 0;
    for (final a in affinities) {
      final current = byId[a.currentId];
      if (current == null || a.answeredWeight <= 0) continue;
      // Ne tire la position que via les affinités au-dessus du neutre.
      final aboveNeutral = (a.affinityPercent - 50).clamp(0, 50) / 50;
      if (aboveNeutral <= 0) continue;
      final w = a.answeredWeight * (0.4 + aboveNeutral);
      weighted += current.hemicycleAngle * aboveNeutral * w;
      total += w;
    }
    if (total == 0) return 0;
    return (weighted / total).clamp(-1.0, 1.0);
  }
}
