import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import 'gradient_scaffold.dart';

/// En-tête visuel pour les pages éditoriales (à propos, vie privée…).
class ContentHero extends StatelessWidget {
  const ContentHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.accent = AppColors.electricBlue,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.nightBlue, accent.withValues(alpha: 0.85)],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 20),
          Text(
            eyebrow.toUpperCase(),
            style: context.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06);
  }
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.index,
    required this.title,
    required this.body,
    required this.icon,
    this.color = AppColors.electricBlue,
  });

  final int index;
  final String title;
  final String body;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.18),
                      color.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(icon, color: color, size: 22),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Text(
                        '$index',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(body, style: context.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (60 * index).ms)
        .fadeIn()
        .slideX(begin: 0.04, curve: Curves.easeOutCubic);
  }
}

class TopicPill extends StatelessWidget {
  const TopicPill({
    super.key,
    required this.label,
    required this.icon,
    this.color = AppColors.electricBlue,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class InsightStrip extends StatelessWidget {
  const InsightStrip({super.key, required this.items});

  /// Icône, libellé, couleur, et éventuellement un compteur (ex. `12 / 100`).
  final List<(IconData, String, Color, String?)> items;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 48, color: AppColors.softGray),
            Expanded(
              child: Column(
                children: [
                  Icon(items[i].$1, color: items[i].$3, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    '${items[i].$4 ?? ''} ${items[i].$2} ',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
