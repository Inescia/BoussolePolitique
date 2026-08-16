import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/ads/ad_service.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/haptics.dart';
import 'features/political_currents/repositories/political_current_repository.dart';
import 'features/quiz/bloc/quiz_bloc.dart';
import 'features/quiz/repositories/progress_repository.dart';
import 'features/quiz/repositories/question_repository.dart';
import 'features/settings/bloc/settings_bloc.dart';

/// Racine widget de l'application.
///
/// Responsabilités :
/// - Instancier repositories, BLoCs et [GoRouter]
/// - Exposer les services via [MultiRepositoryProvider] / [MultiBlocProvider]
/// - Appliquer le thème Material ([AppTheme])
///
/// Voir [README.md] à la racine pour l'architecture complète.
class BoussoleApp extends StatefulWidget {
  const BoussoleApp({super.key, required this.prefs, required this.adService});

  final SharedPreferences prefs;
  final AdService adService;

  @override
  State<BoussoleApp> createState() => _BoussoleAppState();
}

class _BoussoleAppState extends State<BoussoleApp> {
  late final ProgressRepository _progressRepository;
  late final QuestionRepository _questionRepository;
  late final PoliticalCurrentRepository _currentRepository;
  late final AppHaptics _haptics;
  late final SettingsBloc _settingsBloc;
  late final QuizBloc _quizBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _progressRepository = ProgressRepository(prefs: widget.prefs);
    _questionRepository = QuestionRepository();
    _currentRepository = PoliticalCurrentRepository();
    _haptics = AppHaptics(enabled: _progressRepository.hapticsEnabled);
    _settingsBloc = SettingsBloc(
      progressRepository: _progressRepository,
      haptics: _haptics,
    );
    _quizBloc = QuizBloc(
      questionRepository: _questionRepository,
      currentRepository: _currentRepository,
      progressRepository: _progressRepository,
    )..add(const QuizStarted());
    _router = createRouter(onboardingDone: _progressRepository.onboardingDone);
  }

  @override
  void dispose() {
    widget.adService.dispose();
    _settingsBloc.close();
    _quizBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _progressRepository),
        RepositoryProvider.value(value: _questionRepository),
        RepositoryProvider.value(value: _currentRepository),
        RepositoryProvider.value(value: _haptics),
        RepositoryProvider.value(value: widget.adService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _settingsBloc),
          BlocProvider.value(value: _quizBloc),
        ],
        child: MaterialApp.router(
          title: 'Boussole Politique',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          themeMode: ThemeMode.light,
          routerConfig: _router,
        ),
      ),
    );
  }
}
