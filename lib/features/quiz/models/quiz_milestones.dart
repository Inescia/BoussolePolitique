import '../../../core/constants/app_constants.dart';

/// Métadonnées ludiques d’un jalon (indépendant des thèmes / dimensions).
final class MilestoneMeta {
  const MilestoneMeta({
    required this.title,
    required this.cheer,
  });

  final String title;
  final String cheer;
}

/// Découpe le parcours cartes en jalons égaux.
final class QuizMilestones {
  const QuizMilestones({
    required this.answeredCount,
    required this.totalQuestions,
    this.milestoneCount = AppConstants.quizMilestoneCount,
  }) : assert(milestoneCount > 0);

  final int answeredCount;
  final int totalQuestions;
  final int milestoneCount;

  static const List<MilestoneMeta> catalog = [
    MilestoneMeta(
      title: 'Décollage',
      cheer: 'Les moteurs tournent — c’est parti !',
    ),
    MilestoneMeta(
      title: 'Première lumière',
      cheer: 'Tu commences à voir le paysage.',
    ),
    MilestoneMeta(
      title: 'En orbite',
      cheer: 'Le rythme est là, continue !',
    ),
    MilestoneMeta(
      title: 'Radar allumé',
      cheer: 'Tes repères s’affinent.',
    ),
    MilestoneMeta(
      title: 'Mi-parcours',
      cheer: 'La moitié du chemin — bien joué !',
    ),
    MilestoneMeta(
      title: 'Vent arrière',
      cheer: 'Ça glisse, garde le cap.',
    ),
    MilestoneMeta(
      title: 'Grand large',
      cheer: 'Tu as le vent en poupe.',
    ),
    MilestoneMeta(
      title: 'Dernière ligne',
      cheer: 'La ligne d’arrivée se rapproche.',
    ),
    MilestoneMeta(
      title: 'Presque au bout',
      cheer: 'Encore un souffle…',
    ),
    MilestoneMeta(
      title: 'Boussole calibrée',
      cheer: 'Parcours bouclé — bravo !',
    ),
  ];

  int get safeTotal => totalQuestions < 0 ? 0 : totalQuestions;

  int get safeAnswered =>
      answeredCount.clamp(0, safeTotal == 0 ? 0 : safeTotal);

  /// Progression globale 0–1 (cartes passées / total).
  double get globalProgress {
    if (safeTotal == 0) return 0;
    return (safeAnswered / safeTotal).clamp(0.0, 1.0);
  }

  /// Nombre de jalons entièrement franchis (0…[milestoneCount]).
  int get completedCount {
    if (safeTotal == 0) return 0;
    if (safeAnswered >= safeTotal) return milestoneCount;
    var done = 0;
    for (var i = 0; i < milestoneCount; i++) {
      if (safeAnswered >= endExclusive(i)) {
        done = i + 1;
      } else {
        break;
      }
    }
    return done;
  }

  /// Index du jalon en cours (0…[milestoneCount]-1).
  int get currentIndex {
    if (completedCount >= milestoneCount) return milestoneCount - 1;
    return completedCount.clamp(0, milestoneCount - 1);
  }

  int startInclusive(int index) {
    if (safeTotal == 0) return 0;
    return ((index * safeTotal) / milestoneCount).floor();
  }

  int endExclusive(int index) {
    if (safeTotal == 0) return 0;
    return (((index + 1) * safeTotal) / milestoneCount).floor();
  }

  int sizeOf(int index) {
    final size = endExclusive(index) - startInclusive(index);
    return size < 1 ? 1 : size;
  }

  /// Progression dans le jalon courant 0–1.
  double get milestoneProgress {
    if (safeTotal == 0) return 0;
    if (safeAnswered >= safeTotal) return 1;
    final index = currentIndex;
    final start = startInclusive(index);
    final size = sizeOf(index);
    final local = (safeAnswered - start).clamp(0, size);
    return (local / size).clamp(0.0, 1.0);
  }

  int get milestoneAnsweredLocal {
    if (safeTotal == 0) return 0;
    if (safeAnswered >= safeTotal) return sizeOf(currentIndex);
    final start = startInclusive(currentIndex);
    return (safeAnswered - start).clamp(0, sizeOf(currentIndex));
  }

  MilestoneMeta get currentMeta => metaAt(currentIndex);

  MilestoneMeta metaAt(int index) {
    final i = index.clamp(0, catalog.length - 1);
    return catalog[i];
  }

  /// Jalon validé en passant de [previousAnswered] à [safeAnswered], sinon `null`.
  int? newlyCompletedMilestone(int previousAnswered) {
    final before = QuizMilestones(
      answeredCount: previousAnswered,
      totalQuestions: safeTotal,
      milestoneCount: milestoneCount,
    ).completedCount;
    final after = completedCount;
    if (after > before) return after - 1;
    return null;
  }
}
