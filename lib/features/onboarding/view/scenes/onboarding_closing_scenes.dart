import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/gradient_scaffold.dart';

class PaceButtonsScene extends StatefulWidget {
  const PaceButtonsScene({super.key});

  @override
  State<PaceButtonsScene> createState() => _PaceButtonsSceneState();
}

class _PaceButtonsSceneState extends State<PaceButtonsScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  static const _actions = [
    (
      Icons.keyboard_double_arrow_left_rounded,
      'Super non',
      AppColors.superNo,
      52.0,
    ),
    (Icons.close_rounded, 'Non', AppColors.no, 60.0),
    (Icons.skip_next_rounded, 'Passer', AppColors.skip, 52.0),
    (Icons.favorite_rounded, 'Oui', AppColors.yes, 60.0),
    (
      Icons.keyboard_double_arrow_right_rounded,
      'Super oui',
      AppColors.superYes,
      52.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              final t = reduce ? 0.5 : _pulse.value;
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _actions.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _PreviewRound(
                          icon: _actions[i].$1,
                          label: _actions[i].$2,
                          color: _actions[i].$3,
                          size: _actions[i].$4,
                          glow: i == 2 ? 0.35 + t * 0.65 : 0.15,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Tu peux aussi passer si tu hésites.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.warmGray),
          ),
        ],
      ),
    );
  }
}

class _PreviewRound extends StatelessWidget {
  const _PreviewRound({
    required this.icon,
    required this.label,
    required this.color,
    required this.size,
    required this.glow,
  });

  final IconData icon;
  final String label;
  final Color color;
  final double size;
  final double glow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.warmWhite,
            border: Border.all(
              color: color.withValues(alpha: 0.35 + glow * 0.35),
              width: 2,
            ),
          ),
          child: Icon(icon, color: color, size: size * 0.42),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.nightBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Téléphone : tes réponses restent dans l’appareil.
class PrivacyLockScene extends StatelessWidget {
  const PrivacyLockScene({super.key});

  static const _pills = [
    (Icons.no_accounts_outlined, 'Pas de compte', AppColors.electricBlue),
    (Icons.cloud_off_rounded, 'Rien n’est envoyé', AppColors.success),
    (Icons.delete_outline_rounded, 'Effaçable', AppColors.coral),
  ];

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    Widget phone = Container(
      width: 148,
      height: 210,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: AppColors.heroGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.nightBlue.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.style_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 22,
                ),
                const SizedBox(height: 6),
                Text(
                  'Tes réponses',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.16),
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sur cet appareil',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const Spacer(),
        ],
      ),
    );

    if (!reduce) {
      phone = phone
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: -6, duration: 2200.ms, curve: Curves.easeInOut);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          phone,
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _pills.length; i++)
                _PrivacyPill(
                      icon: _pills[i].$1,
                      label: _pills[i].$2,
                      color: _pills[i].$3,
                    )
                    .animate()
                    .fadeIn(delay: reduce ? 0.ms : (120 * i).ms)
                    .slideY(begin: reduce ? 0 : 0.2),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrivacyPill extends StatelessWidget {
  const _PrivacyPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Trois raisons d’être : ludique, neutre, pas un guide de vote.
class WhyAppScene extends StatelessWidget {
  const WhyAppScene({super.key});

  static const _reasons = [
    (Icons.how_to_vote_outlined, 'Pas un bulletin', AppColors.coral),
    (
      Icons.lightbulb_outline_rounded,
      'Clarifier tes idées',
      AppColors.electricBlue,
    ),
    (Icons.balance_rounded, 'Neutre et éducatif', AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < _reasons.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _WhyRow(
                  icon: _reasons[i].$1,
                  label: _reasons[i].$2,
                  color: _reasons[i].$3,
                )
                .animate()
                .fadeIn(delay: reduce ? 0.ms : (90 * i).ms, duration: 420.ms)
                .slideX(begin: reduce ? 0 : -0.08),
          ],
        ],
      ),
    );
  }
}

class _WhyRow extends StatelessWidget {
  const _WhyRow({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.nightBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Aperçu des résultats : tuiles d’affinité comme sur l’écran profil.
class ResultsAffinityScene extends StatefulWidget {
  const ResultsAffinityScene({super.key});

  @override
  State<ResultsAffinityScene> createState() => _ResultsAffinitySceneState();
}

class _ResultsAffinitySceneState extends State<ResultsAffinityScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fill;

  static const _rows = [
    (
      name: 'Écologie politique',
      value: 0.78,
      color: AppColors.success,
      caption: 'Affinité notable avec certaines idées de ce courant.',
    ),
    (
      name: 'Social-démocratie',
      value: 0.64,
      color: AppColors.electricBlue,
      caption: 'Quelques points de convergence.',
    ),
    (
      name: 'Libéralisme',
      value: 0.47,
      color: AppColors.goldHint,
      caption: 'Peu d’affinité avec plusieurs idées associées.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fill = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 360;
        final width = constraints.maxWidth.isFinite
            ? math.min(constraints.maxWidth, 340)
            : 340;
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: SizedBox(
            width: width.toDouble(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'EXEMPLE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.coral,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: compact ? 6 : 8),
                for (var i = 0; i < _rows.length; i++) ...[
                  if (i > 0) SizedBox(height: compact ? 6 : 8),
                  _PreviewAffinityTile(
                    rank: i + 1,
                    name: _rows[i].name,
                    caption: compact ? '' : _rows[i].caption,
                    target: _rows[i].value,
                    color: _rows[i].color,
                    compact: compact,
                    progress: _fill,
                    reduceMotion: reduce,
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

class _PreviewAffinityTile extends StatelessWidget {
  const _PreviewAffinityTile({
    required this.rank,
    required this.name,
    required this.caption,
    required this.target,
    required this.color,
    required this.progress,
    required this.reduceMotion,
    this.compact = false,
  });

  final int rank;
  final String name;
  final String caption;
  final double target;
  final Color color;
  final Animation<double> progress;
  final bool reduceMotion;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 8 : 12,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: compact ? 16 : 20,
            backgroundColor: color.withValues(alpha: 0.15),
            foregroundColor: color,
            child: Text(
              '$rank',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleSmall),
                if (caption.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: progress,
                  builder: (context, _) {
                    final t = reduceMotion
                        ? 1.0
                        : Curves.easeOutCubic.transform(progress.value);
                    return _FillBar(
                      value: (target * t).clamp(0.0, 1.0),
                      color: color,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            child: AnimatedBuilder(
              animation: progress,
              builder: (context, _) {
                final t = reduceMotion
                    ? 1.0
                    : Curves.easeOutCubic.transform(progress.value);
                return Text(
                  '${(target * t * 100).round()} %',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre déterministe sans animation interne (évite les sauts de LinearProgressIndicator).
class _FillBar extends StatelessWidget {
  const _FillBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 6,
        child: ColoredBox(
          color: AppColors.softGray,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              heightFactor: 1,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
