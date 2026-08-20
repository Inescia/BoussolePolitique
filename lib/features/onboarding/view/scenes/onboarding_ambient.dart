import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/motion.dart';

class OnboardingAmbient extends StatelessWidget {
  const OnboardingAmbient({super.key});

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);
    Widget blob({
      required Color color,
      required double size,
      required Alignment alignment,
    }) {
      return Align(
        alignment: alignment,
        child: IgnorePointer(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.34),
                  color.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final scene = Stack(
      children: [
        blob(
          color: AppColors.electricBlue,
          size: 280,
          alignment: const Alignment(-1.15, -0.85),
        ),
        blob(
          color: AppColors.coral,
          size: 240,
          alignment: const Alignment(1.2, 0.15),
        ),
        blob(
          color: AppColors.goldHint,
          size: 180,
          alignment: const Alignment(-0.4, 1.05),
        ),
      ],
    );

    if (reduce) return scene;
    return scene
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: 10, duration: 4200.ms, curve: Curves.easeInOut);
  }
}
