import 'package:bloc_test/bloc_test.dart';
import 'package:boussole_politique/features/political_currents/repositories/political_current_repository.dart';
import 'package:boussole_politique/features/quiz/bloc/quiz_bloc.dart';
import 'package:boussole_politique/features/quiz/models/question.dart';
import 'package:boussole_politique/features/quiz/repositories/progress_repository.dart';
import 'package:boussole_politique/features/quiz/repositories/question_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late QuestionRepository questionRepository;
  late PoliticalCurrentRepository currentRepository;
  late ProgressRepository progressRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    questionRepository = QuestionRepository(
      questions: List.generate(
        14,
        (i) => Question(
          id: 't$i',
          text: 'Test $i',
          category: i.isEven ? 'economy' : 'ecology',
          tags: const ['t'],
          difficulty: QuestionDifficulty.intro,
          impacts: const [
            QuestionImpact(currentId: 'socialisme', weight: 1.5),
            QuestionImpact(currentId: 'liberalisme_economique', weight: -1.2),
            QuestionImpact(currentId: 'ecologie_politique', weight: 1.0),
          ],
        ),
      ),
    );
    currentRepository = PoliticalCurrentRepository();
    progressRepository = ProgressRepository(
      prefs: await SharedPreferences.getInstance(),
    );
  });

  QuizBloc buildBloc() => QuizBloc(
        questionRepository: questionRepository,
        currentRepository: currentRepository,
        progressRepository: progressRepository,
      );

  blocTest<QuizBloc, QuizState>(
    'démarre et expose une question',
    build: buildBloc,
    act: (bloc) => bloc.add(const QuizStarted(resume: false)),
    wait: const Duration(milliseconds: 10),
    expect: () => [
      isA<QuizState>().having((s) => s.status, 'status', QuizStatus.loading),
      isA<QuizState>()
          .having((s) => s.status, 'status', QuizStatus.active)
          .having((s) => s.currentQuestion?.id, 'qid', 't0'),
    ],
  );

  blocTest<QuizBloc, QuizState>(
    'soumet une réponse et passe à la suivante',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const QuizStarted(resume: false));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const AnswerSubmitted(AnswerValue.yes));
    },
    wait: const Duration(milliseconds: 50),
    verify: (bloc) {
      expect(bloc.state.answers.length, 1);
      expect(bloc.state.currentQuestion?.id, isNot(equals('t0')));
      expect(bloc.state.status, QuizStatus.active);
    },
  );

  blocTest<QuizBloc, QuizState>(
    'annule la dernière réponse',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const QuizStarted(resume: false));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const AnswerSubmitted(AnswerValue.yes));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const AnswerUndone());
    },
    wait: const Duration(milliseconds: 80),
    verify: (bloc) {
      expect(bloc.state.answers, isEmpty);
      expect(bloc.state.currentQuestion?.id, 't0');
      expect(bloc.state.status, QuizStatus.active);
    },
  );

  blocTest<QuizBloc, QuizState>(
    'résultats partiels ne clôturent pas le quiz',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const QuizStarted(resume: false));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      for (var i = 0; i < 12; i++) {
        bloc.add(const AnswerSubmitted(AnswerValue.yes));
        await Future<void>.delayed(const Duration(milliseconds: 15));
      }
      bloc.add(const ResultsRequested());
    },
    wait: const Duration(milliseconds: 400),
    verify: (bloc) {
      expect(bloc.state.canShowResults, isTrue);
      expect(bloc.state.status, QuizStatus.viewingResults);
      expect(bloc.state.hasRemainingQuestions, isTrue);
    },
  );

  blocTest<QuizBloc, QuizState>(
    'reprend après consultation des résultats',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const QuizStarted(resume: false));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      for (var i = 0; i < 12; i++) {
        bloc.add(const AnswerSubmitted(AnswerValue.yes));
        await Future<void>.delayed(const Duration(milliseconds: 15));
      }
      bloc.add(const ResultsRequested());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const QuizResumed());
    },
    wait: const Duration(milliseconds: 450),
    verify: (bloc) {
      expect(bloc.state.status, QuizStatus.active);
      expect(bloc.state.currentQuestion, isNotNull);
    },
  );
}
