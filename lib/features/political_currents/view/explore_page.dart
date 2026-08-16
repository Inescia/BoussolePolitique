import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/page_header.dart';
import '../../quiz/bloc/quiz_bloc.dart';
import '../models/political_current.dart';
import '../repositories/political_current_repository.dart';

const Map<String, String> familyLabels = {
  'left': 'Gauche & critiques du capitalisme',
  'center_left': 'Centre gauche',
  'green': 'Écologie',
  'center': 'Centre & républicanisme',
  'center_right': 'Centre droit',
  'right_econ': 'Libéralisme économique',
  'right': 'Droite',
  'sovereign': 'Souveraineté',
  'liberty': 'Libertés maximales',
  'other': 'Autres',
};

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _query = '';
  String? _family;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PoliticalCurrentRepository>();
    final all = repo.getAll();
    final families = all.map((c) => c.family).toSet().toList()
      ..sort((a, b) => (familyLabels[a] ?? a).compareTo(familyLabels[b] ?? b));
    var items = repo.search(_query);
    if (_family != null) {
      items = items.where((c) => c.family == _family).toList();
    }

    final quizState = context.watch<QuizBloc>().state;
    final result = quizState.result;
    final showAffinityHint = !quizState.canShowResults;

    return GradientScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      title: 'Explorer',
                      subtitle:
                          'Comprendre les courants pour mieux situer tes opinions',
                      showBack: false,
                    ),
                    const SizedBox(height: 16),
                    if (showAffinityHint)
                      SoftCard(
                        color: AppColors.electricBlue.withValues(alpha: 0.06),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.style_outlined,
                              color: AppColors.electricBlue,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Réponds à quelques cartes pour voir tes '
                                'affinités estimées ici.',
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/quiz'),
                              child: const Text('Commencer'),
                            ),
                          ],
                        ),
                      ),
                    if (showAffinityHint) const SizedBox(height: 16),
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        hintText: 'Rechercher un courant…',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Tous'),
                            selected: _family == null,
                            onSelected: (_) => setState(() => _family = null),
                          ),
                          const SizedBox(width: 8),
                          for (final f in families) ...[
                            FilterChip(
                              label: Text(familyLabels[f] ?? f),
                              selected: _family == f,
                              onSelected: (_) => setState(() => _family = f),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SoftCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 40,
                          color: AppColors.warmGray,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aucun courant ne correspond',
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Essaie un autre mot-clé ou réinitialise les filtres.',
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => setState(() {
                            _query = '';
                            _family = null;
                          }),
                          child: const Text('Réinitialiser'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final current = items[index];
                    final affinity = result?.affinityFor(current.id);
                    return _CurrentCard(
                      current: current,
                      affinityPercent: affinity?.affinityPercent,
                      onTap: () => context.push('/current/${current.id}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CurrentCard extends StatelessWidget {
  const _CurrentCard({
    required this.current,
    required this.onTap,
    this.affinityPercent,
  });

  final PoliticalCurrent current;
  final double? affinityPercent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      semanticLabel: '${current.name}, fiche courant politique',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 72,
            decoration: BoxDecoration(
              color: current.color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(current.name, style: context.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  current.shortDescription,
                  style: context.textTheme.bodyMedium,
                ),
                if (affinityPercent != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Affinité estimée · ${affinityPercent!.round()} %',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.electricBlue,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
