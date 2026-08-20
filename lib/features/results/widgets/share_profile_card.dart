import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/boussole_logo.dart';
import '../../political_currents/models/political_current.dart';
import '../models/scoring_result.dart';

/// Carte visuelle destinée au partage (capture PNG).
class ShareProfileCard extends StatelessWidget {
  const ShareProfileCard({
    super.key,
    required this.result,
    required this.topCurrents,
  });

  final ScoringResult result;
  final List<(PoliticalCurrent current, double percent)> topCurrents;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      child: Container(
        width: 360,
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8EEFF), AppColors.cream, Color(0xFFFFF0EC)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                BoussoleLogo(size: 40),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Mon profil d’opinions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${result.completeness.label} · ${result.answerCount} réponses',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.warmGray),
            ),
            const SizedBox(height: 18),
            for (final entry in topCurrents.take(3)) ...[
              _ShareRow(current: entry.$1, percent: entry.$2),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            Text(
              'Affinités d’idées, pas une étiquette ni une consigne de vote.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.warmGray,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({required this.current, required this.percent});

  final PoliticalCurrent current;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: current.color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: current.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              current.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.ink,
              ),
            ),
          ),
          Text(
            '${percent.round()} %',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: current.color,
            ),
          ),
        ],
      ),
    );
  }
}
