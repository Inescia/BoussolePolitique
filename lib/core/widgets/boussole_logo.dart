import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

/// Logo officiel Boussole Politique (cocarde + boussole tricolore).
///
/// L’asset est affiché en [BoxFit.contain] pour préserver les rubans
/// et la transparence du PNG.
class BoussoleLogo extends StatelessWidget {
  const BoussoleLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.nightBlue.withValues(alpha: 0.12),
              blurRadius: size * 0.14,
              offset: Offset(0, size * 0.05),
            ),
          ],
        ),
        child: Image.asset(
          AppConstants.logoAsset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => CustomPaint(
            size: Size.square(size),
            painter: const _CompassFallbackPainter(),
          ),
        ),
      ),
    );
  }
}

/// En-tête marque : logo + nom + tagline.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.logoSize = 44,
    this.compact = false,
    this.light = false,
  });

  final double logoSize;
  final bool compact;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final titleColor = light ? Colors.white : AppColors.nightBlue;
    final subtitleColor = light
        ? Colors.white.withValues(alpha: 0.78)
        : AppColors.warmGray;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BoussoleLogo(size: logoSize),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: titleColor,
                  fontSize: compact ? 24 : null,
                  height: 1.1,
                ),
              ),
              if (!compact) ...[
                const SizedBox(height: 2),
                Text(
                  AppConstants.appTagline,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: subtitleColor),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Fallback vectoriel si l’asset PNG est introuvable.
class _CompassFallbackPainter extends CustomPainter {
  const _CompassFallbackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.38;

    canvas.drawCircle(
      center,
      r,
      Paint()..color = AppColors.frenchRed.withValues(alpha: 0.85),
    );
    canvas.drawCircle(center, r * 0.72, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      r * 0.55,
      Paint()
        ..color = AppColors.frenchBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.04,
    );

    final needle = Path()
      ..moveTo(center.dx, center.dy - r * 0.5)
      ..lineTo(center.dx + r * 0.12, center.dy)
      ..lineTo(center.dx, center.dy + r * 0.38)
      ..lineTo(center.dx - r * 0.12, center.dy)
      ..close();

    canvas.drawPath(needle, Paint()..color = AppColors.frenchRed);
    canvas.drawCircle(center, size.width * 0.04, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
