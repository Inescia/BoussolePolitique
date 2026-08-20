import 'package:equatable/equatable.dart';

/// Échelle de réponse du quiz.
enum AnswerValue {
  superYes(2, 'Super oui', 'SUPER OUI'),
  yes(1, 'Oui', 'OUI'),
  skip(0, 'Passer', 'PASSER'),
  no(-1, 'Non', 'NON'),
  superNo(-2, 'Super non', 'SUPER NON');

  const AnswerValue(this.score, this.label, this.badge);

  final int score;
  final String label;
  final String badge;

  bool get isStrong => this == superYes || this == superNo;
  bool get isAffirmative => this == yes || this == superYes;
  bool get isNegative => this == no || this == superNo;
}

class QuestionImpact extends Equatable {
  const QuestionImpact({required this.currentId, required this.weight});

  final String currentId;

  /// Coefficient d'affinité (−2.0 à +2.0). Jamais affiché à l'utilisateur.
  final double weight;

  factory QuestionImpact.fromJson(Map<String, dynamic> json) => QuestionImpact(
    currentId: json['currentId'] as String,
    weight: (json['weight'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {'currentId': currentId, 'weight': weight};

  @override
  List<Object?> get props => [currentId, weight];
}

enum QuestionDifficulty { intro, standard, advanced }

class Question extends Equatable {
  const Question({
    required this.id,
    required this.text,
    required this.category,
    required this.tags,
    required this.difficulty,
    required this.impacts,
    this.source,
    this.explanation,
  });

  final String id;
  final String text;
  final String category;
  final List<String> tags;
  final QuestionDifficulty difficulty;
  final List<QuestionImpact> impacts;
  final String? source;
  final String? explanation;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as String,
    text: json['text'] as String,
    category: json['category'] as String,
    tags: (json['tags'] as List<dynamic>).cast<String>(),
    difficulty: QuestionDifficulty.values.byName(json['difficulty'] as String),
    impacts: (json['impacts'] as List<dynamic>)
        .map((e) => QuestionImpact.fromJson(e as Map<String, dynamic>))
        .toList(),
    source: json['source'] as String?,
    explanation: json['explanation'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'category': category,
    'tags': tags,
    'difficulty': difficulty.name,
    'impacts': impacts.map((e) => e.toJson()).toList(),
    'source': source,
    'explanation': explanation,
  };

  @override
  List<Object?> get props => [id, text, category, tags, difficulty, impacts];
}

class UserAnswer extends Equatable {
  const UserAnswer({
    required this.questionId,
    required this.value,
    required this.answeredAt,
  });

  final String questionId;
  final AnswerValue value;
  final DateTime answeredAt;

  factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
    questionId: json['questionId'] as String,
    value: AnswerValue.values.byName(json['value'] as String),
    answeredAt: DateTime.parse(json['answeredAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'value': value.name,
    'answeredAt': answeredAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [questionId, value, answeredAt];
}
