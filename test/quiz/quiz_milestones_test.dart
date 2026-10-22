import 'package:boussole_politique/core/constants/app_constants.dart';
import 'package:boussole_politique/features/quiz/models/quiz_milestones.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuizMilestones', () {
    test('catalogue aligné sur le nombre de jalons', () {
      expect(
        QuizMilestones.catalog.length,
        AppConstants.quizMilestoneCount,
      );
    });

    test('répartit 100 cartes en 10 jalons de 10', () {
      const m = QuizMilestones(answeredCount: 0, totalQuestions: 100);
      expect(m.milestoneCount, 10);
      for (var i = 0; i < 10; i++) {
        expect(m.startInclusive(i), i * 10);
        expect(m.endExclusive(i), (i + 1) * 10);
        expect(m.sizeOf(i), 10);
      }
    });

    test('progression globale et jalon courant', () {
      const mid = QuizMilestones(answeredCount: 25, totalQuestions: 100);
      expect(mid.globalProgress, 0.25);
      expect(mid.completedCount, 2);
      expect(mid.currentIndex, 2);
      expect(mid.milestoneAnsweredLocal, 5);
      expect(mid.milestoneProgress, 0.5);
      expect(mid.currentMeta.title, 'En orbite');
    });

    test('détecte un jalon nouvellement franchi', () {
      const after = QuizMilestones(answeredCount: 20, totalQuestions: 100);
      expect(after.newlyCompletedMilestone(19), 1);
      expect(after.newlyCompletedMilestone(20), isNull);
      expect(after.newlyCompletedMilestone(10), 1);
    });

    test('parcours terminé = 10 jalons', () {
      const done = QuizMilestones(answeredCount: 100, totalQuestions: 100);
      expect(done.completedCount, 10);
      expect(done.globalProgress, 1);
      expect(done.milestoneProgress, 1);
      expect(done.currentMeta.title, 'Boussole calibrée');
    });

    test('total vide reste à zéro', () {
      const empty = QuizMilestones(answeredCount: 3, totalQuestions: 0);
      expect(empty.globalProgress, 0);
      expect(empty.completedCount, 0);
      expect(empty.milestoneProgress, 0);
    });
  });
}
