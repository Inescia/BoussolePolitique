part of 'quiz_bloc.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

final class QuizStarted extends QuizEvent {
  const QuizStarted({this.resume = true});

  final bool resume;

  @override
  List<Object?> get props => [resume];
}

final class AnswerSubmitted extends QuizEvent {
  const AnswerSubmitted(this.value);

  final AnswerValue value;

  @override
  List<Object?> get props => [value];
}

final class QuestionSkipped extends QuizEvent {
  const QuestionSkipped();
}

final class AnswerUndone extends QuizEvent {
  const AnswerUndone();
}

final class PartialHintDismissed extends QuizEvent {
  const PartialHintDismissed();
}

final class QuizResumed extends QuizEvent {
  const QuizResumed();
}

final class QuizRestarted extends QuizEvent {
  const QuizRestarted();
}

final class QuizCleared extends QuizEvent {
  const QuizCleared();
}

final class ResultsRequested extends QuizEvent {
  const ResultsRequested();
}
