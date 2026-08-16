import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/motion.dart';
import '../../political_currents/models/political_current.dart';
import '../models/scoring_result.dart';

typedef CurrentTapCallback = void Function(PoliticalCurrent current);

/// Chemin d’affinités : toi en haut, puis les courants du plus proche au plus loin.
class AffinityConstellation extends StatefulWidget {
  const AffinityConstellation({
    super.key,
    required this.currents,
    required this.result,
    required this.onCurrentTap,
  });

  final List<PoliticalCurrent> currents;
  final ScoringResult result;
  final CurrentTapCallback onCurrentTap;

  @override
  State<AffinityConstellation> createState() => _AffinityConstellationState();
}

class _AffinityConstellationState extends State<AffinityConstellation> {
  String? _selectedId;

  List<_PlacedCurrent> _items() {
    final byId = {for (final c in widget.currents) c.id: c};
    final ranked = widget.result.affinities
        .where((a) => a.answeredWeight > 0)
        .take(5)
        .toList();
    return [
      for (var i = 0; i < ranked.length; i++)
        if (byId[ranked[i].currentId] != null)
          _PlacedCurrent(
            current: byId[ranked[i].currentId]!,
            percent: ranked[i].affinityPercent,
            index: i,
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _items();
    final reduce = reduceMotionOf(context);
    _PlacedCurrent? selected;
    for (final item in items) {
      if (item.current.id == _selectedId) {
        selected = item;
        break;
      }
    }

    return Semantics(
      label:
          'Chemin des affinités. Toi en haut, puis tes courants du plus proche '
          'au plus éloigné. Tape un nom pour ouvrir la fiche.',
      child: Column(
        children: [
          const _YouBadge(),
          if (items.isNotEmpty)
            SizedBox(
              height: 28,
              width: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          for (final item in items)
            Builder(
              builder: (context) {
                Widget step = _AffinityStep(
                  item: item,
                  selected: item.current.id == _selectedId,
                  showStem: item.index < items.length - 1,
                  onTap: () => setState(() => _selectedId = item.current.id),
                );
                if (reduce) return step;
                return step
                    .animate(delay: (80 * item.index).ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.12, duration: 400.ms);
              },
            ),
          const SizedBox(height: 10),
          if (selected != null)
            TextButton(
              onPressed: () => widget.onCurrentTap(selected!.current),
              child: Text('Voir la fiche « ${selected.current.name} »'),
            )
          else
            Text(
              'Tape un courant pour l’ouvrir.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _PlacedCurrent {
  const _PlacedCurrent({
    required this.current,
    required this.percent,
    required this.index,
  });

  final PoliticalCurrent current;
  final double percent;
  final int index;
}

class _YouBadge extends StatelessWidget {
  const _YouBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.coral,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'Toi',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _AffinityStep extends StatelessWidget {
  const _AffinityStep({
    required this.item,
    required this.selected,
    required this.showStem,
    required this.onTap,
  });

  final _PlacedCurrent item;
  final bool selected;
  final bool showStem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = 11.0 + ((item.percent - 45) / 55).clamp(0.0, 1.0) * 7;
    final indent = item.index * 10.0;

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.current.color,
                      border: Border.all(
                        color: Colors.white,
                        width: selected ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: item.current.color.withValues(alpha: 0.28),
                          blurRadius: selected ? 12 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  if (showStem)
                    Expanded(
                      child: Container(
                        width: 3,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.softGray,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Material(
                  color: selected
                      ? item.current.color.withValues(alpha: 0.10)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: item.current.color
                          .withValues(alpha: selected ? 0.7 : 0.22),
                    ),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.current.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.percent.round()} %',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: item.current.color,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
