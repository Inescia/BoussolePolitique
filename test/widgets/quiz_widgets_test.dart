import 'package:boussole_politique/core/theme/app_theme.dart';
import 'package:boussole_politique/core/utils/haptics.dart';
import 'package:boussole_politique/features/quiz/models/question.dart';
import 'package:boussole_politique/features/quiz/widgets/answer_buttons.dart';
import 'package:boussole_politique/features/quiz/widgets/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const question = Question(
    id: 'w1',
    text: 'Les services publics devraient être renforcés.',
    category: 'public_services',
    tags: ['services'],
    difficulty: QuestionDifficulty.intro,
    impacts: [QuestionImpact(currentId: 'socialisme', weight: 1)],
  );

  testWidgets('AnswerButtons déclenche les callbacks', (tester) async {
    final received = <AnswerValue>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: AnswerButtons(onAnswer: received.add)),
      ),
    );

    await tester.tap(find.byTooltip('Oui'));
    await tester.pumpAndSettle();
    expect(received, contains(AnswerValue.yes));

    await tester.tap(find.byTooltip('Super non'));
    await tester.pumpAndSettle();
    expect(received, contains(AnswerValue.superNo));
  });

  testWidgets('SwipeCard affiche le texte de la question', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SwipeCard(
            question: question,
            haptics: AppHaptics(enabled: false),
            onAnswered: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.text('Les services publics devraient être renforcés.'),
      findsOneWidget,
    );
    expect(find.textContaining('CONTEXTE'), findsOneWidget);
  });

  testWidgets('SwipeCard répond au bouton programmatique', (tester) async {
    AnswerValue? received;
    final key = GlobalObjectKey<SwipeCardState>('swipe');

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SwipeCard(
              key: key,
              question: question,
              haptics: AppHaptics(enabled: false),
              reduceMotion: true,
              onAnswered: (value) => received = value,
            ),
          ),
        ),
      ),
    );

    await key.currentState!.answerProgrammatically(AnswerValue.yes);
    await tester.pump();
    expect(received, AnswerValue.yes);
  });
}
