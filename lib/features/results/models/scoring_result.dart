import 'package:equatable/equatable.dart';

import '../../quiz/models/political_dimension.dart';
import '../../quiz/models/question.dart';

enum ProfileCompleteness {
  exploring('Profil encore à explorer'),
  emerging('Ton profil commence à se préciser'),
  partial('Profil encore partiel'),
  solid('Profil assez complet'),
  wellInformed('Profil bien renseigné');

  const ProfileCompleteness(this.label);
  final String label;
}

class CurrentAffinity extends Equatable {
  const CurrentAffinity({
    required this.currentId,
    required this.rawScore,
    required this.affinityPercent,
    required this.answeredWeight,
  });

  final String currentId;
  final double rawScore;
  final double affinityPercent;
  final double answeredWeight;

  @override
  List<Object?> get props =>
      [currentId, rawScore, affinityPercent, answeredWeight];
}

class DimensionScore extends Equatable {
  const DimensionScore({
    required this.family,
    required this.coverage,
    required this.leanPercent,
    required this.answeredCount,
  });

  final DimensionFamily family;

  /// Part des questions de cette famille déjà répondues (hors passers optionnels).
  final double coverage;

  /// Affinité relative affichée (0–100), neutre à 50 si peu de signal.
  final double leanPercent;
  final int answeredCount;

  @override
  List<Object?> get props => [family, coverage, leanPercent, answeredCount];
}

class InfluentialAnswer extends Equatable {
  const InfluentialAnswer({
    required this.question,
    required this.answer,
    required this.influenceMagnitude,
    required this.topCurrentIds,
  });

  final Question question;
  final UserAnswer answer;
  final double influenceMagnitude;
  final List<String> topCurrentIds;

  @override
  List<Object?> get props =>
      [question, answer, influenceMagnitude, topCurrentIds];
}

class ScoringResult extends Equatable {
  const ScoringResult({
    required this.affinities,
    required this.topCurrents,
    required this.dimensionScores,
    required this.influentialAnswers,
    required this.answerCount,
    required this.skipCount,
    required this.dimensionCoverage,
    required this.completeness,
    required this.hemicyclePosition,
  });

  final List<CurrentAffinity> affinities;
  final List<CurrentAffinity> topCurrents;
  final List<DimensionScore> dimensionScores;
  final List<InfluentialAnswer> influentialAnswers;
  final int answerCount;
  final int skipCount;
  final double dimensionCoverage;
  final ProfileCompleteness completeness;

  /// Position dans l'hémicycle (−1 … +1), dérivée des affinités.
  final double hemicyclePosition;

  CurrentAffinity? affinityFor(String currentId) {
    for (final a in affinities) {
      if (a.currentId == currentId) return a;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        affinities,
        topCurrents,
        dimensionScores,
        answerCount,
        skipCount,
        dimensionCoverage,
        completeness,
        hemicyclePosition,
      ];
}
