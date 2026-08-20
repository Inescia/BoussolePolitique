import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/left_right_spectrum.dart';
import '../../../core/widgets/main_shell.dart';
import '../../../core/widgets/page_header.dart';
import '../../political_currents/models/political_current.dart';
import '../../political_currents/repositories/political_current_repository.dart';
import '../../quiz/bloc/quiz_bloc.dart';
import '../../quiz/widgets/answer_style.dart';
import '../models/scoring_result.dart';
import '../widgets/affinity_constellation.dart';
import '../widgets/dimension_radar.dart';
import '../widgets/majority_reveal.dart';
import '../widgets/share_profile_card.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _showDetails = false;

  String _affinityLabel(double percent) {
    if (percent >= 75) {
      return 'Forte proximité d’idées avec ce courant.';
    }
    if (percent >= 60) {
      return 'Affinité notable avec certaines idées de ce courant.';
    }
    if (percent >= 50) {
      return 'Quelques points de convergence.';
    }
    return 'Peu d’affinité avec plusieurs idées associées.';
  }

  Future<void> _share(BuildContext context, QuizState state) async {
    final result = state.result;
    if (result == null) return;
    final repo = context.read<PoliticalCurrentRepository>();
    final lines = result.topCurrents.take(3).map((a) {
      final name = repo.getById(a.currentId)?.name ?? a.currentId;
      return '• $name — ${a.affinityPercent.round()} %';
    });
    final text = [
      'Mon profil d’opinions sur Boussole Politique '
          '(outil pédagogique, pas un guide de vote) :',
      ...lines,
      '',
      'Ces pourcentages sont des affinités d’idées, pas une identité politique.',
    ].join('\n');

    XFile? image;
    try {
      final topCurrents = [
        for (final affinity in result.topCurrents.take(3))
          if (repo.getById(affinity.currentId) != null)
            (repo.getById(affinity.currentId)!, affinity.affinityPercent),
      ];
      final png = await _captureShareCard(result, topCurrents);
      if (png != null) {
        image = XFile.fromData(
          png,
          mimeType: 'image/png',
          name: 'boussole-profil.png',
        );
      }
    } catch (_) {}

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'Mon profil d’opinions — Boussole Politique',
        files: image == null ? null : [image],
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Partage ouvert.')));
    }
  }

  Widget _motionFade(BuildContext context, {required Widget child}) {
    if (reduceMotionOf(context)) return child;
    return child.animate().fadeIn(duration: 400.ms).slideY(begin: 0.06);
  }

  Future<Uint8List?> _captureShareCard(
    ScoringResult result,
    List<(PoliticalCurrent current, double percent)> topCurrents,
  ) async {
    final overlay = Overlay.of(context);
    final key = GlobalKey();
    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: -1000,
          top: 0,
          child: Material(
            color: Colors.transparent,
            child: RepaintBoundary(
              key: key,
              child: ShareProfileCard(result: result, topCurrents: topCurrents),
            ),
          ),
        );
      },
    );
    overlay.insert(entry);
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 24));
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final captured = await boundary.toImage(pixelRatio: 3);
      final bytes = await captured.toByteData(format: ui.ImageByteFormat.png);
      return bytes?.buffer.asUint8List();
    } finally {
      entry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currents = context.read<PoliticalCurrentRepository>().getAll();
    final reduceMotion = reduceMotionOf(context);
    final haptics = context.read<AppHaptics>();
    final minAnswers = AppConstants.minAnswersForPartialResult;

    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        final result = state.result;
        if (result == null || !state.canShowResults) {
          return GradientScaffold(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  AppNavMetrics.clearance(context),
                ),
                children: [
                  PageHeader(
                    title: 'Profil pas encore disponible',
                    subtitle: 'Encore quelques cartes à répondre.',
                    onBack: () => context.go('/home'),
                  ),
                  const SizedBox(height: 24),
                  SoftCard(
                    child: Column(
                      children: [
                        Text(
                          'Il te faut encore quelques cartes',
                          style: context.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Réponds à au moins $minAnswers cartes pour voir '
                          'un premier profil d’opinions.',
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            context.read<QuizBloc>().add(const QuizResumed());
                            context.push('/quiz');
                          },
                          child: const Text('Continuer les cartes'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => context.push('/about'),
                      child: const Text('Comment c’est calculé ?'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final top = result.topCurrents.take(8).toList();
        final byId = {for (final c in currents) c.id: c};
        final majority = top.isNotEmpty ? byId[top.first.currentId] : null;
        final majorityPercent = top.isNotEmpty
            ? top.first.affinityPercent
            : 50.0;
        final showDetails = _showDetails || reduceMotion || majority == null;
        final spectrumMarkers = [
          for (final affinity in top.take(3))
            if (byId[affinity.currentId] != null)
              SpectrumMarker(
                position: byId[affinity.currentId]!.hemicycleAngle,
                color: byId[affinity.currentId]!.color,
                label: byId[affinity.currentId]!.name,
              ),
        ];

        return GradientScaffold(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                AppNavMetrics.clearance(context) - 24,
              ),
              children: [
                PageHeader(
                  title: 'Ton profil',
                  subtitle:
                      'Des affinités d’idées, pas une étiquette ni une consigne de vote.',
                  onBack: () => context.go('/home'),
                  actions: [
                    RoundHeaderAction(
                      icon: Icons.ios_share_rounded,
                      tooltip: 'Partager un résumé',
                      onTap: () => _share(context, state),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warmGray.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${result.completeness.label} · ${result.answerCount} réponses',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.warmGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (majority != null)
                  MajorityReveal(
                    key: ValueKey(majority.id),
                    current: majority,
                    percent: majorityPercent,
                    haptics: haptics,
                    reduceMotion: reduceMotion,
                    onFinished: () {
                      if (mounted && !_showDetails) {
                        setState(() => _showDetails = true);
                      }
                    },
                  ),
                if (showDetails) ...[
                  const SizedBox(height: 20),
                  LeftRightSpectrum(
                    position: result.hemicyclePosition,
                    accent: majority?.color ?? AppColors.electricBlue,
                    title: 'Où tu te situes',
                    markers: spectrumMarkers,
                    footnote:
                        'Le gros point, c’est toi. Les petits points sont tes courants les plus proches.\nRepère pédagogique, pas une étiquette définitive.',
                  ),
                  const SizedBox(height: 20),
                  Text('Tes plus proches', style: context.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  _motionFade(
                    context,
                    child: SoftCard(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: AffinityConstellation(
                        currents: currents,
                        result: result,
                        onCurrentTap: (current) =>
                            context.push('/current/${current.id}'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Tes affinités', style: context.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Tape un courant pour lire sa fiche.',
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ...top.asMap().entries.map((entry) {
                    final i = entry.key;
                    final affinity = entry.value;
                    final current = byId[affinity.currentId];
                    if (current == null) return const SizedBox.shrink();
                    final tile = Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AffinityTile(
                        rank: i + 1,
                        current: current,
                        percent: affinity.affinityPercent,
                        caption: _affinityLabel(affinity.affinityPercent),
                        onTap: () => context.push('/current/${current.id}'),
                      ),
                    );
                    if (reduceMotion) return tile;
                    return tile
                        .animate(delay: (70 * i).ms)
                        .fadeIn()
                        .slideX(begin: 0.04);
                  }),
                  const SizedBox(height: 8),
                  Text(
                    'Dimensions explorées',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _motionFade(
                    context,
                    child: SoftCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: DimensionRadar(scores: result.dimensionScores),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pourquoi ce résultat ?',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quelques réponses ont particulièrement influencé le profil.',
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  if (result.influentialAnswers.isEmpty)
                    SoftCard(
                      child: Text(
                        'Réponds à davantage de cartes pour voir quelles '
                        'affirmations ont le plus pesé.',
                        style: context.textTheme.bodyMedium,
                      ),
                    )
                  else
                    ...result.influentialAnswers.map((item) {
                      final currents = item.topCurrentIds
                          .map((id) => byId[id])
                          .whereType<PoliticalCurrent>()
                          .take(2)
                          .toList();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _InfluentialAnswerCard(
                          item: item,
                          currents: currents,
                        ),
                      );
                    }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => context.push('/about'),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('En savoir plus sur la méthode'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AffinityTile extends StatelessWidget {
  const _AffinityTile({
    required this.rank,
    required this.current,
    required this.percent,
    required this.caption,
    required this.onTap,
  });

  final int rank;
  final PoliticalCurrent current;
  final double percent;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      semanticLabel: '${current.name}, ${percent.round()} pour cent d’affinité',
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: current.color.withValues(alpha: 0.15),
            foregroundColor: current.color,
            child: Text(
              '$rank',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(current.name, style: context.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(caption, style: context.textTheme.bodySmall),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: (percent / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppColors.softGray,
                    color: current.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${percent.round()} %',
            style: context.textTheme.titleLarge?.copyWith(
              color: current.color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfluentialAnswerCard extends StatelessWidget {
  const _InfluentialAnswerCard({required this.item, required this.currents});

  final InfluentialAnswer item;
  final List<PoliticalCurrent> currents;

  @override
  Widget build(BuildContext context) {
    final value = item.answer.value;

    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: value.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value.color.withValues(alpha: 0.28),
                  ),
                ),
                child: Icon(
                  value.icon,
                  color: value.color,
                  size: value.isStrong ? 26 : 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.label,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: value.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote_rounded,
                size: 18,
                color: AppColors.warmGray.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.question.text,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          if (currents.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('A surtout pesé sur', style: context.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final current in currents)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: current.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: current.color.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hub_outlined,
                          size: 14,
                          color: current.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          current.name,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: current.color,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
