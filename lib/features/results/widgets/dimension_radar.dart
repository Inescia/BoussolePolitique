import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/scoring_result.dart';

/// Visualisation radar stylisée des familles de dimensions.
class DimensionRadar extends StatefulWidget {
  const DimensionRadar({super.key, required this.scores});

  final List<DimensionScore> scores;

  @override
  State<DimensionRadar> createState() => _DimensionRadarState();
}

class _DimensionRadarState extends State<DimensionRadar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: reduceMotion ? 1 : 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.scores
        .where((s) => s.family.label != 'Numérique' || s.answeredCount > 0)
        .toList();

    return AspectRatio(
      aspectRatio: 1.1,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOutCubic.transform(_controller.value);
          return CustomPaint(
            painter: _RadarPainter(scores: visible, progress: t),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.scores, required this.progress});

  final List<DimensionScore> scores;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.30;
    final n = scores.length;

    final grid = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.softGray
      ..strokeWidth = 1.2;

    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final a = -math.pi / 2 + i * 2 * math.pi / n;
        final r = radius * ring / 4;
        final p = Offset(
          center.dx + r * math.cos(a),
          center.dy + r * math.sin(a),
        );
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    final dataPath = Path();
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / n;
      final t = ((scores[i].leanPercent / 100).clamp(0.08, 1.0)) * progress;
      final p = Offset(
        center.dx + radius * t * math.cos(a),
        center.dy + radius * t * math.sin(a),
      );
      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(
      dataPath,
      Paint()
        ..color = AppColors.electricBlue.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = AppColors.electricBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final dotPaint = Paint()
      ..color = AppColors.electricBlue
      ..style = PaintingStyle.fill;
    final dotBorder = Paint()
      ..color = AppColors.warmWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / n;
      final t = ((scores[i].leanPercent / 100).clamp(0.08, 1.0)) * progress;
      final vertex = Offset(
        center.dx + radius * t * math.cos(a),
        center.dy + radius * t * math.sin(a),
      );
      canvas.drawCircle(vertex, 4.5, dotPaint);
      canvas.drawCircle(vertex, 4.5, dotBorder);

      final labelR = radius * 1.38;
      final p = Offset(
        center.dx + labelR * math.cos(a),
        center.dy + labelR * math.sin(a),
      );
      final percent = scores[i].leanPercent.round();
      final text = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${_shortLabel(scores[i].family.label)}\n',
              style: const TextStyle(
                color: AppColors.nightBlue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
            TextSpan(
              text: '$percent %',
              style: const TextStyle(
                color: AppColors.electricBlue,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: 96);
      text.paint(canvas, Offset(p.dx - text.width / 2, p.dy - text.height / 2));
    }
  }

  String _shortLabel(String label) {
    if (label.startsWith('Europe')) return 'Europe';
    return label;
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.scores != scores || oldDelegate.progress != progress;
}
