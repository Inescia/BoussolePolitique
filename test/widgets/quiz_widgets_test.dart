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
    tags: const ['services'],
    difficulty: QuestionDifficulty.intro,
    impacts: const [
      QuestionImpact(currentId: 'socialisme', weight: 1),
    ],
  );

  testWidgets('AnswerButtons déclenche les callbacks', (tester) async {
    final received = <AnswerValue>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AnswerButtons(onAnswer: received.add),
        ),
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

    expect(find.textContaining('services publics'), findsOneWidget);
    expect(find.text('AFFIRMATION'), findsOneWidget);
  });
}
