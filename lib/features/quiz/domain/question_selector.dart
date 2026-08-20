import '../models/political_dimension.dart';
import '../models/question.dart';

/// Sélectionne la prochaine question pour équilibrer la couverture des dimensions.
class QuestionSelector {
  const QuestionSelector();

  Question? next({
    required List<Question> allQuestions,
    required Set<String> answeredQuestionIds,
  }) {
    final remaining = allQuestions
        .where((q) => !answeredQuestionIds.contains(q.id))
        .toList();
    if (remaining.isEmpty) return null;

    final answered = allQuestions
        .where((q) => answeredQuestionIds.contains(q.id))
        .toList();

    final categoryCoverage = <String, int>{};
    final familyCoverage = <DimensionFamily, int>{
      for (final f in DimensionFamily.values) f: 0,
    };

    for (final q in answered) {
      categoryCoverage[q.category] = (categoryCoverage[q.category] ?? 0) + 1;
      final family = _familyFor(q.category);
      if (family != null) {
        familyCoverage[family] = familyCoverage[family]! + 1;
      }
    }

    remaining.sort((a, b) {
      final fa = _familyFor(a.category);
      final fb = _familyFor(b.category);
      final familyA = fa == null ? 0 : familyCoverage[fa]!;
      final familyB = fb == null ? 0 : familyCoverage[fb]!;
      if (familyA != familyB) return familyA.compareTo(familyB);

      final ca = categoryCoverage[a.category] ?? 0;
      final cb = categoryCoverage[b.category] ?? 0;
      if (ca != cb) return ca.compareTo(cb);

      final da = a.difficulty.index;
      final db = b.difficulty.index;
      if (da != db) return da.compareTo(db);
      return a.id.compareTo(b.id);
    });

    return remaining.first;
  }

  DimensionFamily? _familyFor(String categoryId) {
    for (final family in DimensionFamily.values) {
      for (final dim in family.dimensions) {
        if (dim.id == categoryId) return family;
      }
    }
    return null;
  }

  Map<DimensionFamily, double> familyCoverage({
    required List<Question> allQuestions,
    required Set<String> answeredQuestionIds,
  }) {
    final result = <DimensionFamily, double>{};
    for (final family in DimensionFamily.values) {
      final cats = family.dimensions.map((d) => d.id).toSet();
      final total = allQuestions.where((q) => cats.contains(q.category)).length;
      if (total == 0) {
        result[family] = 0;
        continue;
      }
      final done = allQuestions
          .where(
            (q) =>
                cats.contains(q.category) && answeredQuestionIds.contains(q.id),
          )
          .length;
      result[family] = done / total;
    }
    return result;
  }
}
