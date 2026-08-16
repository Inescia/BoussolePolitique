import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import '../utils/motion.dart';

/// En-tête des pages : titre et fermeture sur la même ligne.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.showBack = true,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final canClose = showBack && (onBack != null || context.canPop());
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final titleRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineLarge?.copyWith(
              color: onSurface,
              height: 1.08,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (final action in actions) ...[const SizedBox(width: 8), action],
        if (canClose) ...[
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Fermer',
            onTap: onBack ?? () => context.pop(),
          ),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        motionAware(
          context: context,
          child: titleRow,
          animated: (child) =>
              child.animate().fadeIn(duration: 400.ms).slideY(begin: 0.06),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          motionAware(
            context: context,
            child: Text(
              subtitle!,
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.warmGray,
              ),
            ),
            animated: (child) => child.animate().fadeIn(delay: 60.ms),
          ),
        ],
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final button = Material(
      color: scheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.softGray),
          ),
          child: Icon(icon, color: scheme.onSurface, size: 22),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Action secondaire dans la barre de titre (partage, annuler, etc.).
class RoundHeaderAction extends StatelessWidget {
  const RoundHeaderAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return _HeaderIconButton(icon: icon, onTap: onTap, tooltip: tooltip);
  }
}
