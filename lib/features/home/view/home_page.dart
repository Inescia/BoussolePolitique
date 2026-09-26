import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/boussole_logo.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/main_shell.dart';
import '../../../core/widgets/page_header.dart';
import '../../quiz/bloc/quiz_bloc.dart';
import '../../quiz/widgets/catalog_stats_strip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    16,
                    24,
                    AppNavMetrics.clearance(context),
                  ),
                  sliver: SliverList.list(
                    children: [
                      const PageHeader(
                        title: AppConstants.appName,
                        subtitle: AppConstants.appSubtitle,
                        leading: BoussoleLogo(size: 48),
                        showBack: false,
                      ),
                      const SizedBox(height: 14),
                      CatalogStatsStrip(state: state),
                      const SizedBox(height: 20),
                      motionAware(
                        context: context,
                        child: const _PresentationCard(),
                        animated: (child) => child
                            .animate()
                            .fadeIn(delay: 80.ms)
                            .scale(
                              begin: const Offset(0.96, 0.96),
                              curve: Curves.easeOutBack,
                            ),
                      ),
                      const SizedBox(height: 20),
                      _CardsBlock(state: state),
                      const SizedBox(height: 14),
                      _ProfileBlock(state: state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PresentationCard extends StatelessWidget {
  const _PresentationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricBlue.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              AppConstants.appName.toUpperCase(),
              style: context.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Tes idées, sans étiquette.',
            style: context.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '🧠 L’idée, c’est de partir de tes opinions et affinités pour identifier les courants de pensée auxquels elles se rapprochent.\n\n'
            '💡 Ça permet de mettre des mots sur ce que tu penses, comprendre d’où viennent tes idées et avoir les clés pour mieux les expliquer si besoin.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardsBlock extends StatelessWidget {
  const _CardsBlock({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final exhausted = state.isQuizExhausted;
    final hasProgress = state.answers.isNotEmpty;

    final title = exhausted
        ? 'Les cartes sont terminées'
        : hasProgress
        ? 'Continuer les cartes'
        : 'Découvrir les cartes';
    final subtitle = exhausted
        ? 'Tu as répondu à tout. Ton profil est à jour.'
        : 'Glisse pour affiner tes idées.';

    return _HomeTile(
      icon: Icons.style_rounded,
      color: AppColors.electricBlue,
      title: title,
      subtitle: subtitle,
      enabled: !exhausted,
      trailingIcon: exhausted
          ? Icons.check_circle_outline_rounded
          : Icons.chevron_right_rounded,
      onTap: exhausted
          ? null
          : () {
              if (state.status == QuizStatus.viewingResults) {
                context.read<QuizBloc>().add(const QuizResumed());
              } else {
                context.read<QuizBloc>().add(const QuizStarted());
              }
              context.push('/quiz');
            },
    );
  }
}

class _ProfileBlock extends StatelessWidget {
  const _ProfileBlock({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final ready = state.canShowResults;
    final remaining =
        (AppConstants.minAnswersForPartialResult - state.answeredCount).clamp(
          0,
          AppConstants.minAnswersForPartialResult,
        );

    return _HomeTile(
      icon: Icons.badge_rounded,
      color: AppColors.coral,
      title: ready ? 'Ton profil d’opinions' : 'Profil indisponible',
      subtitle: ready
          ? state.result?.completeness.label ?? 'Profil en cours'
          : remaining == 0
          ? 'Encore quelques cartes pour un premier aperçu.'
          : 'Encore $remaining carte${remaining > 1 ? 's' : ''} '
                'pour voir un premier profil.',
      enabled: ready,
      trailingIcon: ready
          ? Icons.chevron_right_rounded
          : Icons.lock_outline_rounded,
      onTap: ready
          ? () {
              context.read<QuizBloc>().add(const ResultsRequested());
              context.push('/results');
            }
          : null,
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool enabled;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.72,
      child: SoftCard(
        onTap: onTap,
        semanticLabel: title,
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleMedium),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(trailingIcon, color: AppColors.warmGray, size: 24),
          ],
        ),
      ),
    );
  }
}
