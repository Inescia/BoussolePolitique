import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../utils/motion.dart';

/// Coque principale : 3 onglets dans une barre tricolore (drapeau français).
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FrenchFlagNavBar(
              index: navigationShell.currentIndex,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre flottante : trois bandes verticales bleu · blanc · rouge.
class _FrenchFlagNavBar extends StatelessWidget {
  const _FrenchFlagNavBar({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.auto_stories_outlined, Icons.auto_stories_rounded, 'Explorer'),
    (Icons.explore_outlined, Icons.explore_outlined, 'Accueil'),
    (Icons.tune_outlined, Icons.tune_rounded, 'Réglages'),
  ];

  static const _stripeColors = [
    AppColors.frenchBlue,
    AppColors.frenchWhite,
    AppColors.frenchRed,
  ];

  @override
  Widget build(BuildContext context) {
    const barWidth = 250.0;
    const barHeight = 52.0;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final reduceMotion = reduceMotionOf(context);

    return Padding(
      padding: EdgeInsets.only(bottom: bottom > 0 ? bottom + 8 : 14),
      child: Center(
        child: SizedBox(
          width: barWidth,
          height: barHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.nightBlue.withValues(alpha: 0.2),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Expanded(
                      child: _FlagStripe(
                        color: _stripeColors[i],
                        stripeIndex: i,
                        label: _items[i].$3,
                        icon: _items[i].$1,
                        selectedIcon: _items[i].$2,
                        selected: index == i,
                        reduceMotion: reduceMotion,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTap(i);
                        },
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

class _FlagStripe extends StatelessWidget {
  const _FlagStripe({
    required this.color,
    required this.stripeIndex,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.reduceMotion,
    required this.onTap,
  });

  final Color color;
  final int stripeIndex;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final bool reduceMotion;
  final VoidCallback onTap;

  bool get _isWhiteStripe => stripeIndex == 1;

  Color get _iconColor {
    if (_isWhiteStripe) {
      return selected
          ? AppColors.frenchBlue
          : AppColors.frenchBlue.withValues(alpha: 0.45);
    }
    return selected ? Colors.white : Colors.white.withValues(alpha: 0.65);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          splashColor: _isWhiteStripe
              ? AppColors.frenchBlue.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.2),
          highlightColor: _isWhiteStripe
              ? AppColors.frenchBlue.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.1),
          child: Center(
            child: AnimatedScale(
              scale: selected ? 1.08 : 1.0,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 220),
                width: selected ? 38 : 36,
                height: selected ? 38 : 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? (_isWhiteStripe
                            ? AppColors.frenchBlue.withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.22))
                      : Colors.transparent,
                  border: selected && !_isWhiteStripe
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Icon(
                  selected ? selectedIcon : icon,
                  size: 25,
                  color: _iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
