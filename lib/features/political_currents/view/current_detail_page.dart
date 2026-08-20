import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/left_right_spectrum.dart';
import '../../../core/widgets/main_shell.dart';
import '../../../core/widgets/page_header.dart';
import '../../quiz/bloc/quiz_bloc.dart';
import '../models/political_current.dart';
import '../repositories/political_current_repository.dart';

class CurrentDetailPage extends StatelessWidget {
  const CurrentDetailPage({super.key, required this.currentId});

  final String currentId;

  @override
  Widget build(BuildContext context) {
    final current = context.read<PoliticalCurrentRepository>().getById(
      currentId,
    );
    if (current == null) {
      return GradientScaffold(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              AppNavMetrics.clearance(context),
            ),
            children: [
              const PageHeader(title: 'Courant'),
              const SizedBox(height: 24),
              SoftCard(
                child: Text(
                  'Courant introuvable',
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final affinity = context.watch<QuizBloc>().state.result?.affinityFor(
      current.id,
    );
    final d = current.lastUpdated;
    final date =
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
    final repo = context.read<PoliticalCurrentRepository>();

    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            AppNavMetrics.clearance(context),
          ),
          children: [
            PageHeader(title: 'Courant politique'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    current.color.withValues(alpha: 0.92),
                    AppColors.nightBlue.withValues(alpha: 0.88),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: current.color.withValues(alpha: 0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'FICHE PÉDAGOGIQUE',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    current.name,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    current.shortDescription,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  if (affinity != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Ton affinité estimée · ${affinity.affinityPercent.round()} %',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Mise à jour le $date',
                      textAlign: TextAlign.right,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LeftRightSpectrum(
              position: current.hemicycleAngle,
              accent: current.color,
              title: 'Dans l’hémicycle',
              footnote:
                  'Repère pédagogique : où ce courant se situe le plus souvent sur l’axe gauche-droite.',
            ),
            const SizedBox(height: 16),
            _FancySection(
              icon: Icons.menu_book_rounded,
              title: 'En bref',
              body: current.longDescription,
              color: current.color,
            ),
            _FancySection(
              icon: Icons.history_edu_rounded,
              title: 'Origines historiques',
              body: current.historicalOrigins,
              color: AppColors.deepBlue,
            ),
            _FancySection(
              icon: Icons.payments_outlined,
              title: 'Économie',
              body: current.economicPosition,
              color: AppColors.electricBlue,
            ),
            _FancySection(
              icon: Icons.groups_2_outlined,
              title: 'Société',
              body: current.socialPosition,
              color: AppColors.coral,
            ),
            _FancySection(
              icon: Icons.account_balance_outlined,
              title: 'État & institutions',
              body: current.institutionalPosition,
              color: AppColors.nightBlue,
            ),
            _FancySection(
              icon: Icons.vpn_key_outlined,
              title: 'Libertés',
              body: current.civilLibertiesPosition,
              color: AppColors.goldHint,
            ),
            _FancySection(
              icon: Icons.flag_outlined,
              title: 'Europe',
              body: current.europeanPosition,
              color: AppColors.softBlue,
            ),
            _FancySection(
              icon: Icons.eco_outlined,
              title: 'Écologie',
              body: current.ecologicalPosition,
              color: AppColors.success,
            ),
            _FancySection(
              icon: Icons.tune_rounded,
              title: 'Nuances internes',
              body: current.internalNuances,
              color: AppColors.violetHint,
            ),
            const _SectionBreak(label: 'Repères'),
            _TintedSection(
              icon: Icons.hub_outlined,
              title: 'Affinités & oppositions',
              accent: AppColors.electricBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (current.relatedCurrents.isNotEmpty) ...[
                    Text(
                      'Courants proches',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: AppColors.electricBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final id in current.relatedCurrents)
                          _CurrentLinkChip(
                            label: repo.getById(id)?.name ?? id,
                            color:
                                repo.getById(id)?.color ??
                                AppColors.electricBlue,
                            onTap: () => context.push('/current/$id'),
                          ),
                      ],
                    ),
                  ],
                  if (current.relatedCurrents.isNotEmpty &&
                      current.opposedCurrents.isNotEmpty)
                    const SizedBox(height: 16),
                  if (current.opposedCurrents.isNotEmpty) ...[
                    Text(
                      'Oppositions historiques ou idéologiques',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: AppColors.warmGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final id in current.opposedCurrents)
                          _CurrentLinkChip(
                            label: repo.getById(id)?.name ?? id,
                            color:
                                repo.getById(id)?.color ?? AppColors.warmGray,
                            onTap: () => context.push('/current/$id'),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            _TintedSection(
              icon: Icons.place_outlined,
              title: 'Dans la vie politique française',
              accent: AppColors.coral,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Associations partielles et contextuelles. '
                    'Un parti n’« est » pas un courant.',
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < current.examplesInFrance.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _ExampleTile(example: current.examplesInFrance[i]),
                  ],
                ],
              ),
            ),
            _TintedSection(
              icon: Icons.menu_book_outlined,
              title: 'Sources',
              accent: AppColors.warmGray,
              tint: _SectionTint.neutral,
              child: Column(
                children: [
                  for (var i = 0; i < current.sources.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _SourceTile(source: current.sources[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FancySection extends StatelessWidget {
  const _FancySection({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: context.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(body, style: context.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _SectionBreak extends StatelessWidget {
  const _SectionBreak({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: Row(
        children: [
          Expanded(child: Divider(height: 1, color: AppColors.softGray)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.warmGray,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(height: 1, color: AppColors.softGray)),
        ],
      ),
    );
  }
}

enum _SectionTint { accent, neutral }

class _TintedSection extends StatelessWidget {
  const _TintedSection({
    required this.icon,
    required this.title,
    required this.accent,
    required this.child,
    this.tint = _SectionTint.accent,
  });

  final IconData icon;
  final String title;
  final Color accent;
  final Widget child;
  final _SectionTint tint;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final (:background, :border) = switch (tint) {
      _SectionTint.accent => (
        background: Color.alphaBlend(accent.withValues(alpha: 0.10), surface),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      _SectionTint.neutral => (
        background: AppColors.cream,
        border: Border.all(color: AppColors.softGray),
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftCard(
        padding: const EdgeInsets.all(18),
        color: background,
        border: border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: context.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _CurrentLinkChip extends StatelessWidget {
  const _CurrentLinkChip({
    required this.label,
    required this.color,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(label, style: context.textTheme.labelMedium),
              if (onTap != null) ...[
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 16, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.example});

  final FranceExample example;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warmWhite.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(example.label, style: context.textTheme.titleSmall),
              ),
              if (example.period != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    example.period!,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(example.context, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.source});

  final ContentSource source;

  Future<void> _open(BuildContext context) async {
    final raw = source.url;
    if (raw == null) return;
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir le lien.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = source.url != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasUrl ? () => _open(context) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warmWhite.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.softGray.withValues(alpha: 0.8),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasUrl ? Icons.link_rounded : Icons.article_outlined,
                size: 18,
                color: hasUrl ? AppColors.electricBlue : AppColors.warmGray,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(source.title, style: context.textTheme.titleSmall),
                    Text(
                      source.organization,
                      style: context.textTheme.bodySmall,
                    ),
                    if (source.url != null)
                      Text(
                        source.url!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.electricBlue,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
