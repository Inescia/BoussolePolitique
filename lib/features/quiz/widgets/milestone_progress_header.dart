import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../results/widgets/confetti_burst.dart';
import '../models/quiz_milestones.dart';

/// Barre globale + barre du jalon courant, avec célébration ludique à chaque jalon.
class MilestoneProgressHeader extends StatefulWidget {
  const MilestoneProgressHeader({
    super.key,
    required this.answeredCount,
    required this.totalQuestions,
    this.haptics,
    this.reduceMotion = false,
  });

  final int answeredCount;
  final int totalQuestions;
  final AppHaptics? haptics;
  final bool reduceMotion;

  @override
  State<MilestoneProgressHeader> createState() =>
      _MilestoneProgressHeaderState();
}

class _MilestoneProgressHeaderState extends State<MilestoneProgressHeader> {
  int _lastAnswered = 0;
  int? _celebratingIndex;
  Timer? _dismissTimer;

  static const _icons = <IconData>[
    Icons.rocket_launch_rounded,
    Icons.wb_twilight_rounded,
    Icons.public_rounded,
    Icons.settings_input_antenna_rounded,
    Icons.flag_rounded,
    Icons.air_rounded,
    Icons.explore_rounded,
    Icons.directions_run_rounded,
    Icons.bolt_rounded,
    Icons.explore_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _lastAnswered = widget.answeredCount;
  }

  @override
  void didUpdateWidget(covariant MilestoneProgressHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.answeredCount == oldWidget.answeredCount &&
        widget.totalQuestions == oldWidget.totalQuestions) {
      return;
    }

    final milestones = QuizMilestones(
      answeredCount: widget.answeredCount,
      totalQuestions: widget.totalQuestions,
    );
    final unlocked = milestones.newlyCompletedMilestone(_lastAnswered);
    _lastAnswered = widget.answeredCount;

    if (unlocked != null) {
      _showCelebration(unlocked);
    }
  }

  void _showCelebration(int index) {
    _dismissTimer?.cancel();
    unawaited(widget.haptics?.play(HapticKind.success));
    setState(() => _celebratingIndex = index);
    if (widget.reduceMotion) {
      _dismissTimer = Timer(const Duration(milliseconds: 900), _dismissCelebration);
    } else {
      _dismissTimer = Timer(const Duration(milliseconds: 2200), _dismissCelebration);
    }
  }

  void _dismissCelebration() {
    if (!mounted || _celebratingIndex == null) return;
    setState(() => _celebratingIndex = null);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final milestones = QuizMilestones(
      answeredCount: widget.answeredCount,
      totalQuestions: widget.totalQuestions,
    );
    final meta = milestones.currentMeta;
    final displayIndex = milestones.completedCount >= milestones.milestoneCount
        ? milestones.milestoneCount
        : milestones.currentIndex + 1;
    final icon =
        _icons[milestones.currentIndex.clamp(0, _icons.length - 1)];

    final semanticsLabel =
        'Jalon $displayIndex sur ${milestones.milestoneCount}, ${meta.title}. '
        '${milestones.safeAnswered} cartes sur ${milestones.safeTotal}. '
        'Progression globale ${(milestones.globalProgress * 100).round()} pour cent. '
        'Jalon en cours ${(milestones.milestoneProgress * 100).round()} pour cent.';

    return Semantics(
      label: semanticsLabel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _MilestoneBadge(
                    icon: icon,
                    pulse: !widget.reduceMotion &&
                        milestones.milestoneProgress > 0 &&
                        milestones.milestoneProgress < 1,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jalon $displayIndex / ${milestones.milestoneCount}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.warmGray,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meta.title,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${milestones.safeAnswered} / ${milestones.safeTotal}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.warmGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _LabeledBar(
                label: 'Parcours',
                trailing:
                    '${(milestones.globalProgress * 100).round()} %',
                value: milestones.globalProgress,
                color: AppColors.electricBlue,
                reduceMotion: widget.reduceMotion,
              ),
              const SizedBox(height: 10),
              _LabeledBar(
                label:
                    'Ce jalon · ${milestones.milestoneAnsweredLocal}/${milestones.sizeOf(milestones.currentIndex)}',
                trailing:
                    '${(milestones.milestoneProgress * 100).round()} %',
                value: milestones.milestoneProgress,
                color: AppColors.coral,
                reduceMotion: widget.reduceMotion,
              ),
              const SizedBox(height: 8),
              _MilestoneDots(
                completed: milestones.completedCount,
                total: milestones.milestoneCount,
                current: milestones.currentIndex,
                allDone: milestones.completedCount >= milestones.milestoneCount,
              ),
            ],
          ),
          if (_celebratingIndex != null)
            Positioned.fill(
              child: _MilestoneCelebration(
                index: _celebratingIndex!,
                meta: milestones.metaAt(_celebratingIndex!),
                icon: _icons[_celebratingIndex!.clamp(0, _icons.length - 1)],
                reduceMotion: widget.reduceMotion,
                onDismiss: _dismissCelebration,
              ),
            ),
        ],
      ),
    );
  }
}

class _LabeledBar extends StatelessWidget {
  const _LabeledBar({
    required this.label,
    required this.trailing,
    required this.value,
    required this.color,
    required this.reduceMotion,
  });

  final String label;
  final String trailing;
  final double value;
  final Color color;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.warmGray,
                ),
              ),
            ),
            Text(
              trailing,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.75),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: SizedBox(
            height: 8,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final target = math.max(value.clamp(0.0, 1.0), 0.02);
                return Stack(
                  children: [
                    const ColoredBox(
                      color: AppColors.softGray,
                      child: SizedBox.expand(),
                    ),
                    AnimatedContainer(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 420),
                      curve: Curves.easeOutCubic,
                      width: constraints.maxWidth * target,
                      color: color,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MilestoneBadge extends StatelessWidget {
  const _MilestoneBadge({required this.icon, required this.pulse});

  final IconData icon;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.electricBlue.withValues(alpha: 0.18),
            AppColors.coral.withValues(alpha: 0.14),
          ],
        ),
        border: Border.all(
          color: AppColors.electricBlue.withValues(alpha: 0.28),
        ),
      ),
      child: Icon(icon, size: 20, color: AppColors.electricBlue),
    );

    if (!pulse) return badge;

    return badge
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.06, 1.06),
          duration: 1100.ms,
          curve: Curves.easeInOut,
        );
  }
}

class _MilestoneDots extends StatelessWidget {
  const _MilestoneDots({
    required this.completed,
    required this.total,
    required this.current,
    required this.allDone,
  });

  final int completed;
  final int total;
  final int current;
  final bool allDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final done = allDone || i < completed;
        final active = !allDone && i == current;
        final color = done
            ? AppColors.success
            : active
            ? AppColors.coral
            : AppColors.softGray;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == total - 1 ? 0 : 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              height: active ? 6 : 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MilestoneCelebration extends StatelessWidget {
  const _MilestoneCelebration({
    required this.index,
    required this.meta,
    required this.icon,
    required this.reduceMotion,
    required this.onDismiss,
  });

  final int index;
  final MilestoneMeta meta;
  final IconData icon;
  final bool reduceMotion;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final card = Material(
      color: AppColors.warmWhite,
      elevation: 8,
      shadowColor: AppColors.nightBlue.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onDismiss,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricBlue.withValues(alpha: 0.2),
                      AppColors.coral.withValues(alpha: 0.18),
                    ],
                  ),
                ),
                child: Icon(icon, color: AppColors.coral, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Jalon ${index + 1} débloqué',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.coral,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta.cheer,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.warmGray,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget content = Stack(
      alignment: Alignment.center,
      children: [
        if (!reduceMotion)
          const Positioned.fill(
            child: ConfettiBurst(
              duration: Duration(milliseconds: 1800),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: card,
        ),
      ],
    );

    if (reduceMotion) return content;

    return content
        .animate()
        .fadeIn(duration: 180.ms)
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
          duration: 420.ms,
        )
        .then(delay: 1400.ms)
        .fadeOut(duration: 280.ms);
  }
}
