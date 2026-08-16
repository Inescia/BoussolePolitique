import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../political_currents/repositories/political_current_repository.dart';
import '../../results/models/scoring_result.dart';
import '../domain/question_selector.dart';
import '../domain/scoring_engine.dart';
import '../models/question.dart';
import '../repositories/progress_repository.dart';
import '../repositories/question_repository.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

/// Orchestrateur du parcours quiz (machine à états).
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required QuestionRepository questionRepository,
    required PoliticalCurrentRepository currentRepository,
    required ProgressRepository progressRepository,
    ScoringEngine scoringEngine = const ScoringEngine(),
    QuestionSelector questionSelector = const QuestionSelector(),
  })  : _questionRepository = questionRepository,
        _currentRepository = currentRepository,
        _progressRepository = progressRepository,
        _scoringEngine = scoringEngine,
        _questionSelector = questionSelector,
        super(const QuizState()) {
    on<QuizStarted>(_onStarted);
    on<AnswerSubmitted>(_onAnswered);
    on<QuestionSkipped>(_onSkipped);
    on<AnswerUndone>(_onUndone);
    on<PartialHintDismissed>(_onHintDismissed);
    on<QuizRestarted>(_onRestarted);
    on<QuizCleared>(_onCleared);
    on<ResultsRequested>(_onResultsRequested);
    on<QuizResumed>(_onResumed);
  }

  final QuestionRepository _questionRepository;
  final PoliticalCurrentRepository _currentRepository;
  final ProgressRepository _progressRepository;
  final ScoringEngine _scoringEngine;
  final QuestionSelector _questionSelector;

  Future<void> _onStarted(QuizStarted event, Emitter<QuizState> emit) async {
    emit(
      state.copyWith(
        status: QuizStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      final questions = _questionRepository.getAll();
      var answers = <UserAnswer>[];
      var completed = false;

      if (event.resume) {
        final progress = await _progressRepository.load();
        answers = progress.answers;
        completed = progress.completed;
      }

      final next = _questionSelector.next(
        allQuestions: questions,
        answeredQuestionIds: answers.map((a) => a.questionId).toSet(),
      );

      final result = answers.isEmpty
          ? null
          : _scoringEngine.compute(
              questions: questions,
              answers: answers,
              currents: _currentRepository.getAll(),
            );

      final answeredCount =
          answers.where((a) => a.value != AnswerValue.skip).length;
      final exhausted = completed || next == null;

      emit(
        state.copyWith(
          status: exhausted ? QuizStatus.completed : QuizStatus.active,
          questions: questions,
          answers: answers,
          currentQuestion: next,
          result: result,
          showPartialHint: answeredCount >=
                  AppConstants.minAnswersForPartialResult &&
              !exhausted &&
              !state.partialHintDismissed,
          clearCurrentQuestion: next == null,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: QuizStatus.error,
          errorMessage: 'Impossible de charger les cartes.',
        ),
      );
    }
  }

  Future<void> _onAnswered(
    AnswerSubmitted event,
    Emitter<QuizState> emit,
  ) async {
    await _submit(emit, event.value);
  }

  Future<void> _onSkipped(
    QuestionSkipped event,
    Emitter<QuizState> emit,
  ) async {
    await _submit(emit, AnswerValue.skip);
  }

  Future<void> _submit(Emitter<QuizState> emit, AnswerValue value) async {
    final question = state.currentQuestion;
    if (question == null || state.status != QuizStatus.active) return;

    emit(state.copyWith(status: QuizStatus.processing, clearErrorMessage: true));

    final answer = UserAnswer(
      questionId: question.id,
      value: value,
      answeredAt: DateTime.now(),
    );
    final answers = [...state.answers, answer];

    final next = _questionSelector.next(
      allQuestions: state.questions,
      answeredQuestionIds: answers.map((a) => a.questionId).toSet(),
    );

    final result = _scoringEngine.compute(
      questions: state.questions,
      answers: answers,
      currents: _currentRepository.getAll(),
    );

    final answeredCount =
        answers.where((a) => a.value != AnswerValue.skip).length;
    final completed = next == null;

    try {
      await _progressRepository.save(
        QuizProgress(answers: answers, completed: completed),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: QuizStatus.error,
          errorMessage:
              'Impossible d’enregistrer ta réponse. Vérifie l’espace disponible puis réessaie.',
        ),
      );
      return;
    }

    final showHint = answeredCount >= AppConstants.minAnswersForPartialResult &&
        !completed &&
        !state.partialHintDismissed &&
        answeredCount == AppConstants.minAnswersForPartialResult;

    emit(
      state.copyWith(
        status: completed ? QuizStatus.completed : QuizStatus.active,
        answers: answers,
        currentQuestion: next,
        result: result,
        showPartialHint: showHint || (state.showPartialHint && !completed),
        clearCurrentQuestion: next == null,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onUndone(AnswerUndone event, Emitter<QuizState> emit) async {
    if (state.answers.isEmpty) return;
    if (state.status != QuizStatus.active &&
        state.status != QuizStatus.viewingResults &&
        state.status != QuizStatus.completed) {
      return;
    }

    final answers = [...state.answers]..removeLast();
    final next = _questionSelector.next(
      allQuestions: state.questions,
      answeredQuestionIds: answers.map((a) => a.questionId).toSet(),
    );

    final result = answers.isEmpty
        ? null
        : _scoringEngine.compute(
            questions: state.questions,
            answers: answers,
            currents: _currentRepository.getAll(),
          );

    try {
      await _progressRepository.save(
        QuizProgress(answers: answers, completed: false),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: QuizStatus.error,
          errorMessage: 'Impossible d’annuler la dernière réponse.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: QuizStatus.active,
        answers: answers,
        currentQuestion: next,
        result: result,
        showPartialHint: false,
        clearResult: result == null,
        clearErrorMessage: true,
      ),
    );
  }

  void _onHintDismissed(
    PartialHintDismissed event,
    Emitter<QuizState> emit,
  ) {
    emit(
      state.copyWith(
        showPartialHint: false,
        partialHintDismissed: true,
      ),
    );
  }

  Future<void> _onRestarted(
    QuizRestarted event,
    Emitter<QuizState> emit,
  ) async {
    try {
      await _progressRepository.clear();
    } catch (_) {
      emit(
        state.copyWith(
          status: QuizStatus.error,
          errorMessage: 'Impossible de réinitialiser les cartes.',
        ),
      );
      return;
    }
    emit(const QuizState());
    add(const QuizStarted(resume: false));
  }

  Future<void> _onCleared(QuizCleared event, Emitter<QuizState> emit) async {
    try {
      await _progressRepository.clear();
    } catch (_) {
      emit(
        state.copyWith(
          status: QuizStatus.error,
          errorMessage: 'Impossible d’effacer tes réponses.',
        ),
      );
      return;
    }
    emit(const QuizState(status: QuizStatus.initial));
  }

  void _onResultsRequested(ResultsRequested event, Emitter<QuizState> emit) {
    if (!state.canShowResults || state.result == null) return;
    final exhausted = state.currentQuestion == null;
    emit(
      state.copyWith(
        status:
            exhausted ? QuizStatus.completed : QuizStatus.viewingResults,
        showPartialHint: false,
      ),
    );
  }

  void _onResumed(QuizResumed event, Emitter<QuizState> emit) {
    if (state.currentQuestion == null) return;
    if (state.status == QuizStatus.viewingResults ||
        state.status == QuizStatus.completed) {
      emit(state.copyWith(status: QuizStatus.active, showPartialHint: false));
    }
  }
}
