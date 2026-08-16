import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/boussole_logo.dart';
import '../../../core/widgets/content_chrome.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/page_header.dart';

/// Présentation du projet : mission, méthode de calcul, impartialité.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          children: [
            const PageHeader(
              title: 'À propos',
              subtitle: 'Un espace neutre pour explorer tes idées politiques.',
            ),
            const SizedBox(height: 16),
            SoftCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const BoussoleLogo(size: 88),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.appName,
                    style: context.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConstants.appSubtitle,
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                TopicPill(
                  label: 'Apartisan',
                  icon: Icons.balance_rounded,
                  color: AppColors.electricBlue,
                ),
                TopicPill(
                  label: 'Éducatif',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.success,
                ),
                TopicPill(
                  label: 'Confidentiel',
                  icon: Icons.phone_iphone_rounded,
                  color: AppColors.violetHint,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const FeatureTile(
              index: 1,
              icon: Icons.lightbulb_outline_rounded,
              title: 'Pourquoi ça existe ?',
              body:
                  'Beaucoup découvrent la politique au moment de voter, sans espace ludique et neutre pour clarifier leurs idées.',
              color: AppColors.electricBlue,
            ),
            const SizedBox(height: 10),
            const FeatureTile(
              index: 2,
              icon: Icons.person_search_rounded,
              title: 'Pour qui ?',
              body:
                  'Lycéens, jeunes adultes, et toute personne curieuse de mieux comprendre ses propres opinions politiques.',
              color: AppColors.coral,
            ),
            const SizedBox(height: 22),
            Text('Comment ça marche', style: context.textTheme.titleLarge),
            const SizedBox(height: 12),
            InsightStrip(
              items: const [
                (Icons.style_rounded, 'Cartes', AppColors.electricBlue, null),
                (Icons.hub_outlined, 'Courants', AppColors.coral, null),
                (Icons.favorite_border, 'Affinités', AppColors.success, null),
              ],
            ),
            const SizedBox(height: 12),
            const FeatureTile(
              index: 3,
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Des idées, pas un guide de vote',
              body:
                  'Chaque carte est une affirmation. Ta réponse influence ton profil via des coefficients internes.',
              color: AppColors.electricBlue,
            ),
            const SizedBox(height: 10),
            const FeatureTile(
              index: 4,
              icon: Icons.bubble_chart_outlined,
              title: 'Des affinités, pas une étiquette',
              body:
                  'Économie, société, institutions, Europe, écologie… Les pourcentages mesurent une proximité d’idées. Un profil hybride, c’est normal.',
              color: AppColors.coral,
            ),
            const SizedBox(height: 10),
            const FeatureTile(
              index: 5,
              icon: Icons.timelapse_rounded,
              title: 'Un profil qui s’affine',
              body:
                  'Tu n’as pas besoin de tout finir. La fiabilité dépend du nombre de réponses et de la couverture des thèmes.',
              color: AppColors.violetHint,
            ),
            const SizedBox(height: 10),
            const FeatureTile(
              index: 6,
              icon: Icons.verified_user_outlined,
              title: 'Impartial, pas scientifique',
              body:
                  'Formulations neutres, pas de recommandation électorale, pas de jugement. Ce n’est ni une enquête sociologique, ni une prédiction de vote.',
              color: AppColors.success,
            ),
            const SizedBox(height: 10),
            const FeatureTile(
              index: 7,
              icon: Icons.menu_book_outlined,
              title: 'Des débats publics, sourcés',
              body:
                  'Les cartes portent sur des débats documentés par des institutions '
                  '(Vie publique, CNIL, ADEME, Défenseur des droits…). '
                  'La source indique que le sujet existe dans la vie publique, '
                  'pas qu’une réponse serait « vraie ».',
              color: AppColors.electricBlue,
            ),
          ],
        ),
      ),
    );
  }
}
