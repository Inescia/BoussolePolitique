import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/ads/adaptive_banner_ad.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/page_header.dart';
import '../bloc/quiz_bloc.dart';
import '../models/question.dart';
import '../widgets/answer_buttons.dart';
import '../widgets/swipe_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late final AppHaptics _haptics;
  bool _adInFlight = false;

  @override
  void initState() {
    super.initState();
    _haptics = context.read<AppHaptics>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<QuizBloc>();
      final state = bloc.state;
      if (state.status == QuizStatus.completed &&
          !state.hasRemainingQuestions &&
          state.canShowResults) {
        context.go('/results');
      } else if (state.status == QuizStatus.viewingResults &&
          state.hasRemainingQuestions) {
        bloc.add(const QuizResumed());
      } else if (state.status == QuizStatus.initial) {
        bloc.add(const QuizStarted());
      }
    });
  }

  Future<void> _answer(AnswerValue value) async {
    final question = context.read<QuizBloc>().state.currentQuestion;
    final card = question == null
        ? null
        : GlobalObjectKey<SwipeCardState>(question.id).currentState;
    if (card != null) {
      await card.answerProgrammatically(value);
    } else {
      context.read<QuizBloc>().add(AnswerSubmitted(value));
    }
  }

  Future<void> _maybeShowVideoAd(int answeredCount) async {
    if (_adInFlight || !mounted) return;
    setState(() => _adInFlight = true);
    try {
      await context.read<AdService>().maybeShowVideoAfterCards(
        answeredCount: answeredCount,
      );
    } finally {
      if (mounted) setState(() => _adInFlight = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return BlocConsumer<QuizBloc, QuizState>(
      listenWhen: (p, c) =>
          p.status != c.status ||
          p.answeredCount != c.answeredCount ||
          p.showPartialHint != c.showPartialHint,
      listener: (context, state) {
        if (state.status == QuizStatus.completed &&
            !state.hasRemainingQuestions) {
          _haptics.play(HapticKind.success);
          context.go('/results');
          return;
        }
        if (state.status == QuizStatus.active && state.answeredCount > 0) {
          _maybeShowVideoAd(state.answeredCount);
        }
      },
      buildWhen: (p, c) =>
          p.status != c.status ||
          p.currentQuestion != c.currentQuestion ||
          p.answeredCount != c.answeredCount ||
          p.showPartialHint != c.showPartialHint ||
          p.errorMessage != c.errorMessage ||
          p.result?.dimensionCoverage != c.result?.dimensionCoverage ||
          p.canUndo != c.canUndo,
      builder: (context, state) {
        void closeQuiz() {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        }

        if (state.status == QuizStatus.error) {
          return GradientScaffold(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageHeader(title: 'Cartes', onBack: closeQuiz),
                    const Spacer(),
                    SoftCard(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            size: 48,
                            color: AppColors.coral,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Un problème est survenu',
                            style: context.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ??
                                'Impossible de continuer les cartes.',
                            style: context.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () => context.read<QuizBloc>().add(
                              const QuizStarted(),
                            ),
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          );
        }

        final question = state.currentQuestion;
        final busy =
            state.status == QuizStatus.processing ||
            state.status == QuizStatus.loading ||
            _adInFlight;
        final loading = state.status == QuizStatus.loading;

        return GradientScaffold(
          bottomNavigationBar: const AdaptiveBannerAd(),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  PageHeader(
                    title: 'Cartes',
                    subtitle: '${state.answeredCount} réponses',
                    onBack: closeQuiz,
                    actions: [
                      if (state.canUndo)
                        RoundHeaderAction(
                          icon: Icons.undo_rounded,
                          tooltip: 'Annuler la dernière réponse',
                          onTap: () {
                            if (busy) return;
                            context.read<QuizBloc>().add(const AnswerUndone());
                          },
                        ),
                      if (state.canShowResults)
                        RoundHeaderAction(
                          icon: Icons.insights_outlined,
                          tooltip: 'Voir les résultats',
                          onTap: () {
                            context.read<QuizBloc>().add(
                              const ResultsRequested(),
                            );
                            context.push('/results');
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Semantics(
                    label:
                        '${state.result?.completeness.label ?? 'Profil en cours'}. '
                        '${state.answeredCount} réponses. '
                        'Couverture des dimensions : '
                        '${((state.result?.dimensionCoverage ?? 0) * 100).round()} pour cent.',
                    child: _ProgressHeader(state: state),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: loading
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Chargement des cartes…',
                                  style: context.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          )
                        : question == null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Plus de cartes disponibles.',
                                  style: context.textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                if (state.canShowResults)
                                  FilledButton(
                                    onPressed: () {
                                      context.read<QuizBloc>().add(
                                        const ResultsRequested(),
                                      );
                                      context.push('/results');
                                    },
                                    child: const Text(
                                      'Voir mon profil d’opinions',
                                    ),
                                  )
                                else
                                  OutlinedButton(
                                    onPressed: () => context.go('/home'),
                                    child: const Text('Retour à l’accueil'),
                                  ),
                              ],
                            ),
                          )
                        : Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: SwipeCard(
                                    key: GlobalObjectKey<SwipeCardState>(
                                      question.id,
                                    ),
                                    question: question,
                                    enabled: !busy,
                                    reduceMotion: reduceMotion,
                                    haptics: _haptics,
                                    progressLabel: state.questions.isEmpty
                                        ? null
                                        : '${state.answers.length + 1} / ${state.questions.length}',
                                    onAnswered: (value) {
                                      context.read<QuizBloc>().add(
                                        AnswerSubmitted(value),
                                      );
                                    },
                                  )
                                  .animate(target: reduceMotion ? 0 : 1)
                                  .fadeIn(duration: 280.ms)
                                  .scale(
                                    begin: const Offset(0.96, 0.96),
                                    curve: Curves.easeOutCubic,
                                  ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  AnswerButtons(onAnswer: _answer, enabled: !busy),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final coverage = state.result?.dimensionCoverage ?? 0;
    final label =
        state.result?.completeness.label ?? 'Profil en cours d’affinage';

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: context.textTheme.titleSmall)),
            Text(
              '${(coverage * 100).round()} % de dimensions touchées',
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: coverage.clamp(0.05, 1),
            minHeight: 8,
            backgroundColor: AppColors.softGray,
            color: AppColors.electricBlue,
          ),
        ),
      ],
    );
  }
}
