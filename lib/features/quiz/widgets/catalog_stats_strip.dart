import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/content_chrome.dart';
import '../../political_currents/repositories/political_current_repository.dart';
import '../bloc/quiz_bloc.dart';
import '../repositories/question_repository.dart';

/// Compteurs cartes / courants / réponses, partagés accueil et à propos.
class CatalogStatsStrip extends StatelessWidget {
  const CatalogStatsStrip({super.key, required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final totalCards = state.questions.isNotEmpty
        ? state.questions.length
        : context.read<QuestionRepository>().length;
    final currentCount = context
        .read<PoliticalCurrentRepository>()
        .getAll()
        .length;

    return InsightStrip(
      items: [
        (Icons.style_rounded, 'Cartes', AppColors.electricBlue, '$totalCards'),
        (Icons.hub_outlined, 'Courants', AppColors.coral, '$currentCount'),
        (
          Icons.question_answer_rounded,
          'Réponses',
          AppColors.success,
          '${state.answeredCount}',
        ),
      ],
    );
  }
}
