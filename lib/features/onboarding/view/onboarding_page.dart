import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/boussole_logo.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/page_header.dart';
import '../../settings/bloc/settings_bloc.dart';
import 'onboarding_scenes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _pageCount = 8;

  bool get _replay =>
      GoRouterState.of(context).uri.queryParameters['replay'] == '1';

  bool get _last => _index == _pageCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    context.read<AppHaptics>().play(HapticKind.selection);
    _controller.animateToPage(
      index,
      duration: 480.ms,
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (!_last) {
      _goTo(_index + 1);
      return;
    }
    _finish();
  }

  void _finish() {
    context.read<AppHaptics>().play(HapticKind.success);
    if (_replay) {
      context.pop();
      return;
    }
    context.read<SettingsBloc>().add(const OnboardingCompleted());
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Stack(
        children: [
          const OnboardingAmbient(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      clipBehavior: Clip.none,
                      onPageChanged: (i) {
                        setState(() => _index = i);
                        context.read<AppHaptics>().play(HapticKind.selection);
                      },
                      children: [
                        _IntroSlide(
                          scene: CompassOrbitScene(
                            onNudge: () => context.read<AppHaptics>().play(
                              HapticKind.light,
                            ),
                          ),
                          eyebrow: 'Bienvenue',
                          title: 'Trouve ta boussole.',
                          body:
                              'Des cartes, un geste, et tes idées se dessinent. '
                              'Pas de leçon. Pas de verdict. Juste ce qui te parle vraiment.',
                        ),
                        const _IntroSlide(
                          scene: WhyAppScene(),
                          eyebrow: 'Pourquoi',
                          title: 'Un espace pour\nclarifier tes idées.',
                          body:
                              'Beaucoup découvrent la politique trop tard, sans lieu neutre. '
                              'Ici, tu explores ce qui te parle, on ne te dit jamais pour qui voter.',
                        ),
                        const _IntroSlide(
                          scene: StackedAffirmationsScene(),
                          eyebrow: 'Les cartes',
                          title: 'Des affirmations,\npas un QCM.',
                          body:
                              'Chaque carte pose une idée. Tu n’as pas à tout justifier : '
                              'tu dis si ça te parle, un peu, beaucoup, ou pas du tout.',
                        ),
                        const _IntroSlide(
                          scene: SwipeDemoScene(),
                          eyebrow: 'Le geste',
                          title: 'Glisse vers les coins.',
                          body:
                              'Même geste que dans l’app : coins pour répondre, bas pour passer. '
                              'Tu peux essayer sur la carte, là, tout de suite.',
                        ),
                        const _IntroSlide(
                          scene: PaceButtonsScene(),
                          eyebrow: 'À ton rythme',
                          title: 'Boutons, ou passer.',
                          body:
                              'Pas envie de swiper ? Les boutons font la même chose. '
                              'Et si tu ne sais pas, tu passes, ça n’oriente pas ton profil.',
                        ),
                        const _IntroSlide(
                          scene: AffinityConstellationScene(),
                          eyebrow: 'Le profil',
                          title: 'Tes thèmes se\ndessinent.',
                          body:
                              'Économie, société, écologie… tu vois comment tes réponses se répartissent. '
                              'Un profil hybride, c’est normal.',
                        ),
                        const _IntroSlide(
                          scene: ResultsAffinityScene(),
                          eyebrow: 'Les résultats',
                          title: 'Des affinités\navec des courants.',
                          body:
                              'Tu vois tes proximités d’idées, en pourcentages. '
                              'Ce n’est ni un ranking de partis, ni une identité à coller.',
                        ),
                        const _IntroSlide(
                          scene: PrivacyLockScene(),
                          eyebrow: 'Tes données',
                          title: 'Tout reste\nsur ton téléphone.',
                          body:
                              'Pas de compte, pas d’envoi de tes réponses. '
                              'Tu peux tout effacer quand tu veux, dans les réglages.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (var i = 0; i < _pageCount; i++)
                        GestureDetector(
                          onTap: () => _goTo(i),
                          child: AnimatedContainer(
                            duration: reduceMotionOf(context)
                                ? Duration.zero
                                : 250.ms,
                            margin: const EdgeInsets.only(right: 6),
                            width: i == _index ? 22 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? AppColors.electricBlue
                                  : AppColors.softGray,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _next,
                        icon: Icon(
                          _last
                              ? Icons.explore_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _last
                              ? (_replay ? 'Fermer' : 'C’est parti')
                              : 'Suite',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_replay) {
      return PageHeader(
        title: 'Intro',
        showBack: true,
        onBack: () => context.pop(),
      );
    }

    return Row(
      children: [
        Expanded(
          child: motionAware(
            context: context,
            child: const BrandMark(logoSize: 44, compact: true),
            animated: (child) => child.animate().fadeIn().slideY(begin: 0.12),
          ),
        ),
        TextButton(onPressed: _finish, child: const Text('Passer')),
      ],
    );
  }
}

class _IntroSlide extends StatelessWidget {
  const _IntroSlide({
    required this.scene,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final Widget scene;
  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 500;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: compact ? 5 : 6,
                child: motionAware(
                  context: context,
                  child: scene,
                  animated: (child) => child
                      .animate()
                      .fadeIn(duration: 420.ms)
                      .scale(
                        begin: const Offset(0.96, 0.96),
                        curve: Curves.easeOutBack,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                eyebrow.toUpperCase(),
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.electricBlue,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style:
                    (compact
                            ? context.textTheme.headlineSmall
                            : context.textTheme.headlineMedium)
                        ?.copyWith(height: 1.12),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.warmGray,
                ),
              ),
              SizedBox(height: compact ? 4 : 8),
            ],
          ),
        );
      },
    );
  }
}
