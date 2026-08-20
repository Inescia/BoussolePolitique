import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/boussole_logo.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../quiz/models/political_dimension.dart';
import '../../../quiz/models/question.dart';
import '../../../results/models/scoring_result.dart';
import '../../../results/widgets/dimension_radar.dart';

class CompassOrbitScene extends StatefulWidget {
  const CompassOrbitScene({super.key, this.onNudge});

  final VoidCallback? onNudge;

  @override
  State<CompassOrbitScene> createState() => _CompassOrbitSceneState();
}

class _CompassOrbitSceneState extends State<CompassOrbitScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;
  int _boost = 0;

  static const _chips = [
    (label: 'Économie', color: AppColors.electricBlue),
    (label: 'Société', color: AppColors.coral),
    (label: 'Écologie', color: AppColors.success),
    (label: 'Europe', color: AppColors.violetHint),
  ];

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  void _nudge() {
    if (reduceMotionOf(context)) return;
    setState(() => _boost++);
    widget.onNudge?.call();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final side = math.min(constraints.maxWidth, constraints.maxHeight);
          final radius = side * 0.30;
          final logoSize = (side * 0.26).clamp(64.0, 96.0);

          return GestureDetector(
            onTap: _nudge,
            behavior: HitTestBehavior.opaque,
            child: AnimatedBuilder(
              animation: _spin,
              builder: (context, _) {
                final t = reduce ? 0.0 : _spin.value;
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size.square(side * 0.78),
                      painter: _CompassRingPainter(
                        rotation: t * math.pi * 2,
                        accent: AppColors.electricBlue,
                      ),
                    ),
                    BoussoleLogo(size: logoSize)
                        .animate(key: ValueKey(_boost))
                        .rotate(
                          begin: 0,
                          end: reduce ? 0 : 0.08,
                          duration: 700.ms,
                          curve: Curves.easeOutBack,
                        ),
                    for (var i = 0; i < _chips.length; i++)
                      Transform.translate(
                        offset: _orbitOffset(
                          t: t,
                          index: i,
                          count: _chips.length,
                          radius: radius,
                        ),
                        child: _OrbitChip(
                          label: _chips[i].label,
                          color: _chips[i].color,
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Offset _orbitOffset({
    required double t,
    required int index,
    required int count,
    required double radius,
  }) {
    final angle = t * math.pi * 2 + (index / count) * math.pi * 2 - math.pi / 2;
    return Offset(math.cos(angle) * radius, math.sin(angle) * radius * 0.78);
  }
}

class _OrbitChip extends StatelessWidget {
  const _OrbitChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CompassRingPainter extends CustomPainter {
  const _CompassRingPainter({required this.rotation, required this.accent});

  final double rotation;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final ring = Paint()
      ..color = accent.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(Offset.zero, r, ring);
    canvas.drawCircle(
      Offset.zero,
      r * 0.72,
      ring..color = accent.withValues(alpha: 0.12),
    );

    for (var i = 0; i < 24; i++) {
      final a = i / 24 * math.pi * 2;
      final major = i % 6 == 0;
      final inner = r * (major ? 0.86 : 0.93);
      canvas.drawLine(
        Offset(math.cos(a) * inner, math.sin(a) * inner),
        Offset(math.cos(a) * r, math.sin(a) * r),
        Paint()
          ..color = (major ? AppColors.coral : accent).withValues(
            alpha: major ? 0.7 : 0.28,
          )
          ..strokeWidth = major ? 2.4 : 1.2
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CompassRingPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

/// Mini-carte qui glisse toute seule vers les coins — et qu’on peut draguer.
class SwipeDemoScene extends StatefulWidget {
  const SwipeDemoScene({super.key});

  @override
  State<SwipeDemoScene> createState() => _SwipeDemoSceneState();
}

class _SwipeDemoSceneState extends State<SwipeDemoScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop;
  Offset _drag = Offset.zero;
  bool _holding = false;

  static const _targets = [
    Offset(-36, -44),
    Offset(36, -44),
    Offset(0, 40),
    Offset(-36, 44),
    Offset(36, 44),
  ];

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  Offset _scripted(double t) {
    final count = _targets.length;
    final segment = (t * count).floor().clamp(0, count - 1);
    final local = (t * count) - segment;
    final target = _targets[segment];
    if (local < 0.38) {
      return Offset.lerp(
        Offset.zero,
        target,
        Curves.easeInOut.transform(local / 0.38),
      )!;
    }
    if (local < 0.58) return target;
    return Offset.lerp(
      target,
      Offset.zero,
      Curves.easeInOut.transform((local - 0.58) / 0.42),
    )!;
  }

  AnswerValue? _armed(Offset o) {
    if (o.distance < 28) return null;
    if (o.dy > 28 && o.dx.abs() < 28) return AnswerValue.skip;
    final left = o.dx < 0;
    final top = o.dy < 0;
    if (top) return left ? AnswerValue.superNo : AnswerValue.superYes;
    return left ? AnswerValue.no : AnswerValue.yes;
  }

  Color _color(AnswerValue v) => switch (v) {
    AnswerValue.superYes => AppColors.superYes,
    AnswerValue.yes => AppColors.yes,
    AnswerValue.superNo => AppColors.superNo,
    AnswerValue.no => AppColors.no,
    AnswerValue.skip => AppColors.skip,
  };

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _loop,
            builder: (context, _) {
              final offset = _holding || reduce
                  ? _drag
                  : _scripted(_loop.value);
              final armed = _armed(offset);
              final angle = offset.dx / 420 * 0.22;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  _CornerLabel(
                    alignment: Alignment.topLeft,
                    value: AnswerValue.superNo,
                    arrow: '↖',
                    active: armed == AnswerValue.superNo,
                  ),
                  _CornerLabel(
                    alignment: Alignment.topRight,
                    value: AnswerValue.superYes,
                    arrow: '↗',
                    active: armed == AnswerValue.superYes,
                  ),
                  _CornerLabel(
                    alignment: Alignment.bottomLeft,
                    value: AnswerValue.no,
                    arrow: '↙',
                    active: armed == AnswerValue.no,
                  ),
                  _CornerLabel(
                    alignment: Alignment.bottomCenter,
                    value: AnswerValue.skip,
                    arrow: '↓',
                    active: armed == AnswerValue.skip,
                  ),
                  _CornerLabel(
                    alignment: Alignment.bottomRight,
                    value: AnswerValue.yes,
                    arrow: '↘',
                    active: armed == AnswerValue.yes,
                  ),
                  Center(
                    child: GestureDetector(
                      onPanStart: (_) => setState(() {
                        _holding = true;
                        _drag = Offset.zero;
                      }),
                      onPanUpdate: (d) => setState(() => _drag += d.delta),
                      onPanEnd: (_) {
                        setState(() {
                          _holding = false;
                          _drag = Offset.zero;
                        });
                      },
                      child: Transform.translate(
                        offset: offset,
                        child: Transform.rotate(
                          angle: angle,
                          child: _DemoCard(
                            armed: armed,
                            accent: armed == null
                                ? AppColors.softGray
                                : _color(armed),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CornerLabel extends StatelessWidget {
  const _CornerLabel({
    required this.alignment,
    required this.value,
    required this.arrow,
    required this.active,
  });

  final Alignment alignment;
  final AnswerValue value;
  final String arrow;
  final bool active;

  Color get _color => switch (value) {
    AnswerValue.superYes => AppColors.superYes,
    AnswerValue.yes => AppColors.yes,
    AnswerValue.superNo => AppColors.superNo,
    AnswerValue.no => AppColors.no,
    AnswerValue.skip => AppColors.skip,
  };

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AnimatedScale(
        scale: active ? 1.08 : 1,
        alignment: alignment,
        duration: const Duration(milliseconds: 180),
        child: AnimatedOpacity(
          opacity: active ? 1 : 0.55,
          duration: const Duration(milliseconds: 180),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: active ? 0.18 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _color.withValues(alpha: active ? 0.8 : 0.28),
              ),
            ),
            child: Text(
              '$arrow ${value.label}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({required this.armed, required this.accent});

  final AnswerValue? armed;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 248,
      height: 228,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: accent.withValues(alpha: 0.55), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.nightBlue.withValues(alpha: 0.14),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CardHeader(tag: 'Écologie'),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Les transports publics devraient être gratuits.',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(height: 1.25, color: AppColors.ink),
                      ),
                    ),
                  ),
                  const _MiniContext(
                    text:
                        'Cette carte porte sur l’environnement et les priorités écologiques.',
                  ),
                ],
              ),
              if (armed != null)
                Center(
                  child: Transform.rotate(
                    angle: -math.pi / 28,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: accent, width: 3.5),
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.warmWhite.withValues(alpha: 0.94),
                      ),
                      child: Text(
                        armed!.badge,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.electricBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          tag,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.deepBlue),
        ),
      ),
    );
  }
}

class _MiniContext extends StatelessWidget {
  const _MiniContext({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: AppColors.electricBlue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTEXTE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.electricBlue,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.deepBlue,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Aperçu du radar de dimensions, comme sur l’écran résultats.
class AffinityConstellationScene extends StatelessWidget {
  const AffinityConstellationScene({super.key});

  static const _demoScores = [
    DimensionScore(
      family: DimensionFamily.economy,
      coverage: 0.8,
      leanPercent: 68,
      answeredCount: 5,
    ),
    DimensionScore(
      family: DimensionFamily.society,
      coverage: 0.6,
      leanPercent: 54,
      answeredCount: 4,
    ),
    DimensionScore(
      family: DimensionFamily.institutions,
      coverage: 0.5,
      leanPercent: 46,
      answeredCount: 3,
    ),
    DimensionScore(
      family: DimensionFamily.europeSovereignty,
      coverage: 0.4,
      leanPercent: 61,
      answeredCount: 2,
    ),
    DimensionScore(
      family: DimensionFamily.ecology,
      coverage: 0.7,
      leanPercent: 81,
      answeredCount: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: SoftCard(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
            const Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 300,
                  height: 330,
                  child: DimensionRadar(scores: _demoScores),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trois cartes empilées : l’intro explique que ce sont des affirmations.
class StackedAffirmationsScene extends StatelessWidget {
  const StackedAffirmationsScene({super.key});

  static const _cards = [
    (
      tag: 'Économie',
      text: 'L’État doit investir davantage dans les services publics.',
      context:
          'Cette carte touche au rôle et au financement des services publics.',
    ),
    (
      tag: 'Société',
      text: 'Chacun devrait pouvoir vivre comme il l’entend.',
      context: 'Cette carte porte sur les libertés individuelles.',
    ),
    (
      tag: 'Écologie',
      text: 'Le climat doit passer avant la croissance.',
      context:
          'Cette carte porte sur l’environnement et les priorités écologiques.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(constraints.maxWidth, 280.0);
          Widget stack = SizedBox(
            width: width,
            height: math.min(constraints.maxHeight, 280),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                for (var i = 0; i < _cards.length; i++)
                  Transform.translate(
                    offset: Offset((i - 1) * 10, (_cards.length - 1 - i) * 16),
                    child: Transform.rotate(
                      angle: (i - 1) * 0.045,
                      child: _AffirmationMiniCard(
                        tag: _cards[i].tag,
                        text: _cards[i].text,
                        contextText: _cards[i].context,
                        highlighted: i == _cards.length - 1,
                        width: width,
                      ),
                    ),
                  ),
              ],
            ),
          );

          if (reduce) return Center(child: stack);

          return Center(
            child: stack
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: -8,
                  duration: 2200.ms,
                  curve: Curves.easeInOut,
                ),
          );
        },
      ),
    );
  }
}

class _AffirmationMiniCard extends StatelessWidget {
  const _AffirmationMiniCard({
    required this.tag,
    required this.text,
    required this.contextText,
    required this.highlighted,
    required this.width,
  });

  final String tag;
  final String text;
  final String contextText;
  final bool highlighted;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: highlighted
                ? AppColors.electricBlue.withValues(alpha: 0.35)
                : AppColors.softGray,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.nightBlue.withValues(
                alpha: highlighted ? 0.14 : 0.06,
              ),
              blurRadius: highlighted ? 22 : 12,
              offset: Offset(0, highlighted ? 12 : 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _CardHeader(tag: tag),
              const SizedBox(height: 10),
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.25,
                  color: AppColors.ink,
                ),
              ),
              if (highlighted) ...[
                const SizedBox(height: 12),
                _MiniContext(text: contextText),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
