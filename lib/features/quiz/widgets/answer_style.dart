import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/question.dart';

/// Style visuel unique des réponses (quiz, cartes, résultats).
extension AnswerValueStyle on AnswerValue {
  IconData get icon => switch (this) {
    AnswerValue.superYes || AnswerValue.yes => Icons.favorite_rounded,
    AnswerValue.skip => Icons.skip_next_rounded,
    AnswerValue.no || AnswerValue.superNo => Icons.close_rounded,
  };

  Color get color => switch (this) {
    AnswerValue.superYes => AppColors.superYes,
    AnswerValue.yes => AppColors.yes,
    AnswerValue.superNo => AppColors.superNo,
    AnswerValue.no => AppColors.no,
    AnswerValue.skip => AppColors.skip,
  };
}
