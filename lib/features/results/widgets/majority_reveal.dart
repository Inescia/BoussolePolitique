import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../political_currents/models/political_current.dart';
import 'confetti_burst.dart';

/// Séquence d’annonce du courant majoritaire + confettis + compteur animé.
class MajorityReveal extends StatefulWidget {
  const MajorityReveal({
    super.key,
    required this.current,
    required this.percent,
    required this.haptics,
    this.reduceMotion = false,
    this.onFinished,
  });

  final PoliticalCurrent current;
  final double percent;
  final AppHaptics haptics;
  final bool reduceMotion;
  final VoidCallback? onFinished;

  @override
  State<MajorityReveal> createState() => _MajorityRevealState();
}

class _MajorityRevealState extends State<MajorityReveal>
    with TickerProviderStateMixin {
  late final AnimationController _countController;
  bool _showConfetti = false;
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _countController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.reduceMotion ? 200 : 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Future<void>.delayed(
        Duration(milliseconds: widget.reduceMotion ? 50 : 150),
      );
      if (!mounted) return;
      setState(() => _showConfetti = !widget.reduceMotion);
      widget.haptics.play(HapticKind.success);
      await _countController.forward();
      await Future<void>.delayed(
        Duration(milliseconds: widget.reduceMotion ? 80 : 120),
      );
      _notifyFinished();
    });
  }

  void _notifyFinished() {
    if (_notified || !mounted) return;
    _notified = true;
    widget.onFinished?.call();
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: widget.current.color.withValues(alpha: 0.08),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_showConfetti) const Positioned.fill(child: ConfettiBurst()),
          Column(
            children: [
              motionAware(
                context: context,
                child: Text(
                  'Plus forte proximité d’idées',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: widget.current.color,
                    letterSpacing: 0.6,
                  ),
                ),
                animated: (child) =>
                    child.animate().fadeIn().slideY(begin: 0.2),
              ),
              const SizedBox(height: 14),
              motionAware(
                context: context,
                child: Text(
                  widget.current.name,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.nightBlue,
                    height: 1.1,
                  ),
                ),
                animated: (child) => child
                    .animate()
                    .fadeIn(delay: 120.ms)
                    .scale(
                      begin: const Offset(0.86, 0.86),
                      curve: Curves.easeOutBack,
                    ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 120,
                width: 120,
                child: AnimatedBuilder(
                  animation: _countController,
                  builder: (context, _) {
                    final t = Curves.easeOutCubic.transform(
                      _countController.value,
                    );
                    final value = (widget.percent * t).round();
                    return CustomPaint(
                      painter: _RingPainter(
                        progress: t * (widget.percent / 100),
                        color: widget.current.color,
                      ),
                      child: Center(
                        child: Text(
                          '$value %',
                          style: context.textTheme.headlineSmall?.copyWith(
                            color: widget.current.color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Tes réponses présentent une forte affinité avec certaines idées de ce courant — '
                'sans définir une identité politique unique.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = color.withValues(alpha: 0.15)
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = color
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      progress.clamp(0.0, 1.0) * 6.2832,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
