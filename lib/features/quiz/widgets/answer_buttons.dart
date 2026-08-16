import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/question.dart';

class AnswerButtons extends StatelessWidget {
  const AnswerButtons({
    super.key,
    required this.onAnswer,
    this.enabled = true,
  });

  final void Function(AnswerValue value) onAnswer;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Boutons de réponse',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _RoundAction(
            tooltip: 'Super non',
            icon: Icons.keyboard_double_arrow_left_rounded,
            color: AppColors.superNo,
            size: 56,
            onPressed: enabled ? () => onAnswer(AnswerValue.superNo) : null,
          ),
          _RoundAction(
            tooltip: 'Non',
            icon: Icons.close_rounded,
            color: AppColors.no,
            size: 64,
            onPressed: enabled ? () => onAnswer(AnswerValue.no) : null,
          ),
          _RoundAction(
            tooltip: 'Passer',
            icon: Icons.skip_next_rounded,
            color: AppColors.skip,
            size: 52,
            onPressed: enabled ? () => onAnswer(AnswerValue.skip) : null,
          ),
          _RoundAction(
            tooltip: 'Oui',
            icon: Icons.favorite_rounded,
            color: AppColors.yes,
            size: 64,
            onPressed: enabled ? () => onAnswer(AnswerValue.yes) : null,
          ),
          _RoundAction(
            tooltip: 'Super oui',
            icon: Icons.keyboard_double_arrow_right_rounded,
            color: AppColors.superYes,
            size: 56,
            onPressed: enabled ? () => onAnswer(AnswerValue.superYes) : null,
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.size,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final side = size < 48 ? 48.0 : size;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Ink(
              width: side,
              height: side,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warmWhite,
                border: Border.all(
                  color: color.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: Icon(icon, color: color, size: side * 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
