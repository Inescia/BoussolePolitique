part of 'quiz_bloc.dart';

enum QuizStatus {
  initial,
  loading,
  active,
  processing,
  viewingResults,
  completed,
  error,
}

final class QuizState extends Equatable {
  const QuizState({
    this.status = QuizStatus.initial,
    this.questions = const [],
    this.answers = const [],
    this.currentQuestion,
    this.result,
    this.errorMessage,
    this.showPartialHint = false,
    this.partialHintDismissed = false,
  });

  final QuizStatus status;
  final List<Question> questions;
  final List<UserAnswer> answers;
  final Question? currentQuestion;
  final ScoringResult? result;
  final String? errorMessage;
  final bool showPartialHint;
  final bool partialHintDismissed;

  int get answeredCount =>
      answers.where((a) => a.value != AnswerValue.skip).length;

  int get totalAnsweredIncludingSkips => answers.length;

  Set<String> get answeredIds => answers.map((a) => a.questionId).toSet();

  bool get canShowResults =>
      answeredCount >= AppConstants.minAnswersForPartialResult;

  bool get canUndo => answers.isNotEmpty && status == QuizStatus.active;

  bool get hasRemainingQuestions => currentQuestion != null;

  bool get isQuizExhausted =>
      status == QuizStatus.completed ||
      (questions.isNotEmpty && currentQuestion == null && answers.isNotEmpty);

  QuizState copyWith({
    QuizStatus? status,
    List<Question>? questions,
    List<UserAnswer>? answers,
    Question? currentQuestion,
    ScoringResult? result,
    String? errorMessage,
    bool? showPartialHint,
    bool? partialHintDismissed,
    bool clearCurrentQuestion = false,
    bool clearResult = false,
    bool clearErrorMessage = false,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentQuestion: clearCurrentQuestion
          ? null
          : (currentQuestion ?? this.currentQuestion),
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      showPartialHint: showPartialHint ?? this.showPartialHint,
      partialHintDismissed: partialHintDismissed ?? this.partialHintDismissed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    answers,
    currentQuestion,
    result,
    errorMessage,
    showPartialHint,
    partialHintDismissed,
  ];
}
