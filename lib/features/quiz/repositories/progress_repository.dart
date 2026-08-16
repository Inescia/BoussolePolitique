import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../models/question.dart';

class QuizProgress {
  const QuizProgress({required this.answers, required this.completed});

  final List<UserAnswer> answers;
  final bool completed;

  Map<String, dynamic> toJson() => {
    'answers': answers.map((a) => a.toJson()).toList(),
    'completed': completed,
  };

  factory QuizProgress.fromJson(Map<String, dynamic> json) => QuizProgress(
    answers: (json['answers'] as List<dynamic>)
        .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
        .toList(),
    completed: json['completed'] as bool? ?? false,
  );

  static const empty = QuizProgress(answers: [], completed: false);
}

/// Persistance locale du quiz et des préférences utilisateur.
///
/// Toutes les données sensibles (réponses politiques) restent dans
/// [SharedPreferences] sur l'appareil — jamais envoyées à un serveur.
class ProgressRepository {
  ProgressRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  Future<QuizProgress> load() async {
    final raw = _prefs.getString(AppConstants.prefsKeyProgress);
    if (raw == null) return QuizProgress.empty;
    try {
      return QuizProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return QuizProgress.empty;
    }
  }

  Future<void> save(QuizProgress progress) async {
    await _prefs.setString(
      AppConstants.prefsKeyProgress,
      jsonEncode(progress.toJson()),
    );
  }

  Future<void> clear() async {
    await _prefs.remove(AppConstants.prefsKeyProgress);
  }

  bool get onboardingDone =>
      _prefs.getBool(AppConstants.prefsKeyOnboardingDone) ?? false;

  Future<void> setOnboardingDone(bool value) async {
    await _prefs.setBool(AppConstants.prefsKeyOnboardingDone, value);
  }

  bool get hapticsEnabled =>
      _prefs.getBool(AppConstants.prefsKeyHaptics) ?? true;

  Future<void> setHapticsEnabled(bool value) async {
    await _prefs.setBool(AppConstants.prefsKeyHaptics, value);
  }

  bool get showSwipeTip =>
      _prefs.getBool(AppConstants.prefsKeySwipeTip) ?? true;

  Future<void> setShowSwipeTip(bool value) async {
    await _prefs.setBool(AppConstants.prefsKeySwipeTip, value);
  }
}
