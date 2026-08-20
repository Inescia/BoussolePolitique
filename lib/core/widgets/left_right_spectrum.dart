import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import 'gradient_scaffold.dart';

/// Point d’un courant sur l’axe gauche-droite.
class SpectrumMarker {
  const SpectrumMarker({
    required this.position,
    required this.color,
    this.label,
  });

  /// −1 = gauche, +1 = droite.
  final double position;
  final Color color;
  final String? label;
}

/// Curseur pédagogique gauche ↔ droite (hémicycle, −1 … +1).
class LeftRightSpectrum extends StatelessWidget {
  const LeftRightSpectrum({
    super.key,
    required this.position,
    this.accent = AppColors.electricBlue,
    this.title,
    this.footnote,
    this.compact = false,
    this.markers = const [],
  });

  /// −1 = gauche, 0 = centre, +1 = droite.
  final double position;
  final Color accent;
  final String? title;
  final String? footnote;
  final bool compact;
  final List<SpectrumMarker> markers;

  String get _label {
    if (position <= -0.45) return 'Plutôt à gauche';
    if (position <= -0.18) return 'Centre gauche';
    if (position < 0.18) return 'Centre';
    if (position < 0.45) return 'Centre droit';
    return 'Plutôt à droite';
  }

  @override
  Widget build(BuildContext context) {
    final track = compact ? 6.0 : 10.0;
    final thumb = compact ? 16.0 : 22.0;
    final mark = compact ? 8.0 : 11.0;

    final spectrum = Semantics(
      label: 'Position sur l’axe gauche-droite : $_label',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: context.textTheme.titleMedium),
            const SizedBox(height: 4),
          ],
          Text(
            _label,
            style:
                (compact
                        ? context.textTheme.labelMedium
                        : context.textTheme.titleSmall)
                    ?.copyWith(color: accent, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: compact ? 8 : 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              double xFor(double pos, double size) {
                final t = ((pos + 1) / 2).clamp(0.0, 1.0);
                return size / 2 + t * (width - size);
              }

              return SizedBox(
                height: thumb,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        height: track,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.coral,
                              AppColors.softGray,
                              AppColors.electricBlue,
                            ],
                          ),
                        ),
                      ),
                    ),
                    for (final marker in markers)
                      Positioned(
                        left: xFor(marker.position, mark) - mark / 2,
                        child: Tooltip(
                          message: marker.label ?? '',
                          child: Container(
                            width: mark,
                            height: mark,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: marker.color,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      left: xFor(position, thumb) - thumb / 2,
                      child: Container(
                        width: thumb,
                        height: thumb,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Gauche',
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.coral,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'Droite',
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.electricBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (markers.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                for (final marker in markers)
                  if (marker.label != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: marker.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          marker.label!,
                          style: context.textTheme.labelSmall,
                        ),
                      ],
                    ),
              ],
            ),
          ],
          if (footnote != null) ...[
            const SizedBox(height: 8),
            Text(footnote!, style: context.textTheme.bodySmall),
          ],
        ],
      ),
    );

    if (compact) return spectrum;

    return SoftCard(padding: const EdgeInsets.all(18), child: spectrum);
  }
}
