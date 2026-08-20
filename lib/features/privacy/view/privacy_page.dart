import 'package:boussole_politique/core/ads/ad_config.dart';
import 'package:boussole_politique/core/ads/ad_service.dart';
import 'package:boussole_politique/features/quiz/bloc/quiz_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/content_chrome.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/main_shell.dart';
import '../../../core/widgets/page_header.dart';

/// Politique de confidentialité : stockage local, pubs AdMob, droits utilisateur.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  static final _googlePrivacyUri = Uri.parse(
    'https://policies.google.com/privacy',
  );

  Future<void> _openGooglePrivacy(BuildContext context) async {
    final ok = await launchUrl(
      _googlePrivacyUri,
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir le lien.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const PageHeader(
              title: 'Vie privée',
              subtitle: 'Tout est stocké exclusivement sur ton téléphone.',
            ),
            const SizedBox(height: 16),
            InsightStrip(
              items: const [
                (
                  Icons.no_accounts_outlined,
                  'Aucun compte',
                  AppColors.electricBlue,
                  null,
                ),
                (
                  Icons.lock_outline_rounded,
                  'Réponses locales',
                  AppColors.coral,
                  null,
                ),
                (
                  Icons.delete_outline_rounded,
                  'Effacement libre',
                  AppColors.success,
                  null,
                ),
              ],
            ),
            const SizedBox(height: 18),

            const _SectionBreak(label: 'Stockage'),
            SoftCard(
              color: AppColors.electricBlue.withValues(alpha: 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ce qui est collecté',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const _PrivacyRow(
                    icon: Icons.style_rounded,
                    text: 'Tes réponses aux cartes',
                  ),
                  const _PrivacyRow(
                    icon: Icons.timeline_rounded,
                    text: 'Ta progression',
                  ),
                  const _PrivacyRow(
                    icon: Icons.vibration_rounded,
                    text: 'Préférences',
                  ),
                  const _PrivacyRow(
                    icon: Icons.phone_android_rounded,
                    text: 'Uniquement sur ton téléphone',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ce qui n’est pas collecté',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pas de compte, pas de nom, pas d’e-mail, pas d’âge, '
                    'pas de localisation, ni de téléphone demandés par l’app.\n\n'
                    'Et aucun envoi de tes réponses.',
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            const _SectionBreak(label: 'Publicité'),
            SoftCard(
              color: AppColors.coral.withValues(alpha: 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Publicité (AdMob)',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Boussole Politique peut afficher des publicités via Google AdMob '
                    'pour financer l’application.\n\n'
                    '• Bannière en bas de la page des cartes\n'
                    '• Vidéo / interstitiel occasionnel tous les ${AdConfig.cardsBetweenVideoAds} réponses\n'
                    '• Pas de bannière sur l’accueil\n'
                    '• Tes réponses et ton profil d’opinions ne sont pas envoyés à AdMob.',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google peut collecter des identifiants publicitaires et des données '
                    'techniques selon ton consentement.',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _openGooglePrivacy(context),
                      child: const Text('Politique de confidentialité Google'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            SoftCard(
              onTap: () async {
                await context.read<AdService>().openPrivacyOptions();
              },
              semanticLabel: 'Options de confidentialité publicitaire',
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Options de confidentialité publicitaire'),
                subtitle: Text(
                  'Gérer le consentement aux pubs personnalisées (RGPD).',
                ),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SizedBox(height: 12),

            const _SectionBreak(label: 'Données'),
            SoftCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.brandRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.brandRed,
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      'Supprimer les données',
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Effacer mon profil ?'),
                    content: const Text(
                      'Tes réponses seront supprimées de cet appareil. '
                      'Tu pourras recommencer quand tu veux depuis l’accueil.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Annuler'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Effacer'),
                      ),
                    ],
                  ),
                );
                if (ok == true && context.mounted) {
                  context.read<QuizBloc>().add(const QuizCleared());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil effacé.')),
                  );
                  context.go('/home');
                }
              },
            ),
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

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.electricBlue),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: context.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
