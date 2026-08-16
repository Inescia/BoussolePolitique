import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Confettis légers (bleu / blanc / corail) pour la révélation des résultats.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    this.active = true,
    this.duration = const Duration(milliseconds: 2800),
  });

  final bool active;
  final Duration duration;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.active) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.speed,
    required this.drift,
    required this.size,
    required this.color,
    required this.spin,
    required this.delay,
  });

  final double x;
  final double speed;
  final double drift;
  final double size;
  final Color color;
  final double spin;
  final double delay;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress}) : _particles = _build();

  final double progress;
  final List<_Particle> _particles;

  static List<_Particle> _build() {
    final rng = math.Random(42);
    const colors = [
      AppColors.electricBlue,
      AppColors.coral,
      Colors.white,
      AppColors.softBlue,
      AppColors.goldHint,
      AppColors.nightBlue,
    ];
    return List.generate(48, (i) {
      return _Particle(
        x: rng.nextDouble(),
        speed: 0.55 + rng.nextDouble() * 0.7,
        drift: (rng.nextDouble() - 0.5) * 0.35,
        size: 4 + rng.nextDouble() * 7,
        color: colors[i % colors.length],
        spin: (rng.nextDouble() - 0.5) * 8,
        delay: rng.nextDouble() * 0.25,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final local = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final opacity = (1 - local).clamp(0.0, 1.0);
      final dx = (p.x + p.drift * local) * size.width;
      final dy = local * p.speed * size.height * 1.15 - 20;
      final rect = Rect.fromCenter(
        center: Offset(dx, dy),
        width: p.size,
        height: p.size * 0.55,
      );
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(p.spin * local);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        Paint()..color = p.color.withValues(alpha: opacity * 0.9),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
