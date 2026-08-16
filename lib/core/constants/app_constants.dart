abstract final class AppConstants {
  static const String appName = 'Boussole Politique';
  static const String appShortName = 'Boussole';
  static const String appTagline = 'Explore tes opinions';
  static const String appSubtitle =
      'Un outil ludique pour explorer tes idées, sans te dire pour qui voter.';

  static const int minAnswersForPartialResult = 12;
  static const int suggestedAnswersForReliableProfile = 30;
  static const double wellCoveredDimensionRatio = 0.55;

  /// Seuils internes du moteur de scoring ([ScoringEngine]).
  static const int exploringMaxAnswers = 6;
  static const int partialMinAnswers = 20;
  static const double partialMinCoverage = 0.35;

  /// Masquer l'aide swipe après N réponses.
  static const int swipeTipDismissAfterAnswers = 3;

  static const String prefsKeyProgress = 'quiz_progress_v1';
  static const String prefsKeyOnboardingDone = 'onboarding_done_v1';
  static const String prefsKeyHaptics = 'haptics_enabled_v1';
  static const String prefsKeySwipeTip = 'swipe_tip_v1';

  static const String logoAsset = 'assets/images/boussole_logo.png';
}
