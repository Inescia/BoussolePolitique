import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/question.dart';
import 'answer_style.dart';

class AnswerButtons extends StatelessWidget {
  const AnswerButtons({super.key, required this.onAnswer, this.enabled = true});

  final void Function(AnswerValue value) onAnswer;
  final bool enabled;

  static const _items = [
    (value: AnswerValue.superNo, size: 68.0, arrow: '↖'),
    (value: AnswerValue.no, size: 56.0, arrow: '↙'),
    (value: AnswerValue.skip, size: 48.0, arrow: '↓'),
    (value: AnswerValue.yes, size: 56.0, arrow: '↘'),
    (value: AnswerValue.superYes, size: 68.0, arrow: '↗'),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Boutons de réponse',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 8,
        children: [
          for (final item in _items)
            _LabeledAction(
              tooltip: item.value.label,
              icon: item.value.icon,
              color: item.value.color,
              size: item.size,
              arrow: item.arrow,
              label: item.value.label,
              onPressed: enabled ? () => onAnswer(item.value) : null,
            ),
        ],
      ),
    );
  }
}

class _LabeledAction extends StatelessWidget {
  const _LabeledAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.size,
    required this.arrow,
    required this.label,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final double size;
  final String arrow;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final side = size < 44 ? 44.0 : size;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: '$tooltip, glisser $arrow',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink(
                    width: side,
                    height: side,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.warmWhite,
                      border: Border.all(
                        color: color.withValues(alpha: 0.4),
                        width: size >= 64 ? 2.5 : 2,
                      ),
                    ),
                    child: Icon(icon, color: color, size: side * 0.46),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$arrow $label',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
